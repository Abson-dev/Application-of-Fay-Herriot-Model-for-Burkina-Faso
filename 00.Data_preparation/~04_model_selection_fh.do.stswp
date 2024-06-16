clear all 

version     15
set matsize 8000
set seed    648743

set more off
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


//global with candidate variables.

local  thevar   hgender1  hage age hmstat1 hmstat2 hmstat3  hreligion1 hreligion2 hreligion3  hnation2 ///
  hethnie1 hethnie2 hethnie3 hethnie4 hethnie5 hethnie6 hethnie7 ///
  heduc1 heduc2 heduc3  hdiploma1 hdiploma2 ///
  hos12m1  couvmal1  handit1  alfa1  educ_scol1 educ_scol2 educ_scol3 ///
  csp_sec5 csp_sec6 csp_sec7  bank1  serviceconsult1 ///
  elec_ua1 ordure1  toilet1  eva_toi1  eva_eau1  tv1 ///
  fer1  frigo1  cuisin1  ordin1  decod1 car1  sh_id_demo1  sh_co_natu1 ///
  conflict_diffusion_indicator mndwi brba nbai ndsi vari savi osavi ndmi  evi ndvi sr arvi ui
  
//Normalize all covariates
foreach x of local thevar{
	cap sum `x'
	cap replace `x' = (`x' - r(mean))/r(sd)
}
	
*===============================================================================
// Regression diagnostics
*===============================================================================  
  //Fit full model	
	fhsae dir_fgt0 $thevar, revar(dir_fgt0_var) method(fh) 
	
	local hhvars $thevar
	
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

*===============================================================================
// Collinearity
*=============================================================================== 
 		
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