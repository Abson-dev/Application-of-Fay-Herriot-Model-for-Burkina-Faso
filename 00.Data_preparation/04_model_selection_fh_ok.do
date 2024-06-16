clear all 
set more off 

version     18
set matsize 8000
set seed    648743

local graphs graphregion(color(white)) xsize(9) ysize(6) msize(small)



//ssc install sae

/*==============================================================================
Do-file prepared for SAE Guidelines
- Real world data application
- authors Paul Corral
*==============================================================================*/

*===============================================================================
//Specify team paths 
*===============================================================================

global main          "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso"
global data       	"$main\00.Data"
global figs        "$main\05.Graphics"



use "$data\region_survey_ehcvm_bfa_2021.dta", clear //province_survey_ehcvm_bfa_2021

merge 1:1 adm1_pcode using "$data\direct_survey_ehcvm_bfa_2021_region.dta" //direct_survey_ehcvm_bfa_2021_province
drop _merge


//Global with eligible variables
global thevar conflict_diffusion_indicator geo_mndwi geo_brba geo_nbai geo_ndsi geo_vari geo_savi geo_osavi geo_ndmi geo_v10 geo_evi geo_ndvi geo_sr geo_arvi geo_ui

  
//Normalize all covariates
foreach x of global thevar {
	cap sum `x'
	cap replace `x' = (`x' - r(mean))/r(sd)
}
	
//Fit full model	
	fhsae dir_fgt0 $thevar, revar(dir_fgt0_var) method(fh) 
/*	
note: geo_ndsi omitted because of collinearity.
note: geo_ndmi omitted because of collinearity.
note: geo_v10 omitted because of collinearity.
*/	
	//local hhvars $thevar
	local hhvars conflict_diffusion_indicator geo_mndwi geo_brba geo_nbai  geo_vari geo_savi geo_osavi  geo_evi geo_ndvi geo_sr geo_arvi geo_ui
	//Removal of non-significant variables
	forval z= 0.8(-0.05)0.0001{
		qui:fhsae dir_fgt0 `hhvars', revar(dir_fgt0_var) method(fh) 
		mata: bb=st_matrix("e(b)")
		mata: se=sqrt(diagonal(st_matrix("e(V)")))
		mata: zvals = bb':/se
		mata: st_matrix("min",min(abs(zvals)))
		local zv = (-min[1,1])
		if (2*normal(`zv')<`z') exit	
		foreach x of varlist `hhvars'{
			local hhvars1
			qui: fhsae dir_fgt0 `hhvars', revar(dir_fgt0_var) method(fh) 
			qui: test `x' 
			if (r(p)>`z'){
				local hhvars1
				foreach yy of local hhvars{
					if ("`yy'"=="`x'") dis ""
					else local hhvars1 `hhvars1' `yy'
				}
			}
			else local hhvars1 `hhvars'
			local hhvars `hhvars1'		
		}
	}	

	//Global with non-significant variables removed
	global postsign `hhvars'
	//Final model without non-significant variables
	fhsae dir_fgt0 $postsign, revar(dir_fgt0_var) method(fh) 
	//Check VIF
	reg dir_fgt0 $postsign, r
	gen touse = e(sample)
	gen weight = 1
	mata: ds = _f_stepvif("$postsign","weight",5,"touse") 
	global postvif `vifvar'
	
	local hhvars $postvif
	
	//One final removal of non-significant covariates
	forval z= 0.8(-0.05)0.0001{
		qui:fhsae dir_fgt0 `hhvars', revar(dir_fgt0_var) method(fh) 
		mata: bb=st_matrix("e(b)")
		mata: se=sqrt(diagonal(st_matrix("e(V)")))
		mata: zvals = bb':/se
		mata: st_matrix("min",min(abs(zvals)))
		local zv = (-min[1,1])
		if (2*normal(`zv')<`z') exit	
		foreach x of varlist `hhvars'{
			local hhvars1
			qui: fhsae dir_fgt0 `hhvars', revar(dir_fgt0_var) method(fh) 
			qui: test `x' 
			if (r(p)>`z'){
				local hhvars1
				foreach yy of local hhvars{
					if ("`yy'"=="`x'") dis ""
					else local hhvars1 `hhvars1' `yy'
				}
			}
			else local hhvars1 `hhvars'
			local hhvars `hhvars1'		
		}
	}	
	
	global last `hhvars'
	
	//Obtain SAE-FH-estimates	
	fhsae dir_fgt0 $last, revar(dir_fgt0_var) method(reml) fh(fh_fgt0) ///
	fhse(fh_fgt0_se) fhcv(fh_fgt0_cv) gamma(fh_fgt0_gamma) out
	
	
*===============================================================================
// Residual Analysis
*=============================================================================== 	
	
	//Check normal errors
	predict xb
	gen u_d = fh_fgt0 - xb //Random errors (area effects) and represent unexplained heterogeneity between areas, assumed to have a zero mean and constant variance
	lab var u_d "FH area effects"
	histogram u_d, normal `graphs'
	graph export "$figs\Fig1_left.png", as(png) replace
	qnorm u_d, `graphs'
	graph export "$figs\u_d.png", as(png) replace
	
	gen e_d = dir_fgt0 - fh_fgt0 //The errors, e_d are assumed to be heteroskedastic
	lab var e_d "FH errors"
	
	histogram e_d, normal `graphs'
	graph export "$figs\Fig1_right.png", as(png) replace
	qnorm e_d, `graphs'
	graph export "$figs\e_d.png", as(png) replace
		
	
	
save "$data\direct_and_fh_region.dta", replace //direct_and_fh_provinces