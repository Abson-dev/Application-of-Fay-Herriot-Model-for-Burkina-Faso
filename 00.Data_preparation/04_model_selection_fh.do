clear all 
set more off 

version     18
set matsize 8000
set seed    648743

local graphs graphregion(color(white)) xsize(9) ysize(6) msize(small)



//ssc install sae
//cap: net install github, from("https://haghish.github.io/github/")
//github install jpazvd/fhsae

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



use "$data\province_survey_ehcvm_bfa_2021.dta", clear //region_survey_ehcvm_bfa_2021

merge 1:1 adm2_pcode using "$data\direct_survey_ehcvm_bfa_2021_province.dta" //direct_survey_ehcvm_bfa_2021_region
drop _merge


//Global with eligible variables
global thevar hage hgender1 age hmstat1 hmstat2 hmstat3  hreligion1 hreligion2   hnation2 hethnie1 hethnie2  halfa1  heduc1 heduc2 hactiv12m1  hbranch1  hbranch3 hbranch4  hcsp1 hcsp2 sexe1   mstat1 mstat2  religion1 religion2 nation2   telpor1  internet1 activ12m1   logem1  mur1  toit1  sol1  eauboi_ss1    elec_ac1  elec_ur1  eva_toi1   tv1  fer1  frigo1  cuisin1  ordin1  decod1  car1  conflict_diffusion_indicator geo_*

  
//Normalize all covariates
foreach x of global thevar {
	cap sum `x'
	cap replace `x' = (`x' - r(mean))/r(sd)
}
	
//Fit full model	
	fhsae dir_fgt0 $thevar, revar(dir_fgt0_var) method(fh) 
/*	
//hage hgender1 hmstat1 hbranch1 hcsp1 mstat1 nation2 toit1 eauboi_ss1 eva_toi1 cuisin1 conflict_diffusion_indicator
//geo_mndwi geo_brba geo_nbai  geo_vari geo_savi geo_osavi  geo_evi geo_ndvi geo_sr geo_arvi geo_ui

hmstat1  hreligion1  hethnie2   
*/	
	//local hhvars $thevar
	local hhvars  hage hgender1   hreligion1   hmstat1 hbranch1 hcsp1 mstat1 nation2 toit1 eauboi_ss1 eva_toi1 cuisin1 conflict_diffusion_indicator ///
	geo_mndwi geo_brba geo_nbai  geo_vari geo_savi geo_osavi  geo_evi geo_ndvi geo_sr geo_arvi geo_ui

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
	graph export "$figs\Fig1_left_admin2.png", as(png) replace
	qnorm u_d, `graphs'
	graph export "$figs\u_d_admin2.png", as(png) replace
	
	gen e_d = dir_fgt0 - fh_fgt0 //The errors, e_d are assumed to be heteroskedastic
	lab var e_d "FH errors"
	
	histogram e_d, normal `graphs'
	graph export "$figs\Fig1_right_admin2.png", as(png) replace
	qnorm e_d, `graphs'
	graph export "$figs\e_d_admin2.png", as(png) replace
/*		

// Normality 
 
    reg dir_fgt0 $postvif,r
    predict resid, resid
    
    // Kernel density plot  for residuals with a normal density overlaid
    kdensity resid, normal `graphs' 
                  
    graph export "$figs\kdensity_resid.png", as(png) replace
    
    // Standardized normal probability 
    pnorm resid , `graphs' 
                  
    graph export "$figs\pnorm.png", as(png) replace
    
    // Quantiles of a variable against the quantiles of a normal distribution
    qnorm resid , `graphs' 
                  
    graph export "$figs\qnorm.png", as(png) replace
    
    // Numerical Test:  Shapiro-Wilk W test for normal data
    swilk resid		
		
// Heteroscedasticity 

    reg dir_fgt0 $postvif

    // Residuals vs fitted values with a reference line at y=0
    rvfplot , yline(0)  `graphs' 
                                         
    graph export "$figs\rvfplot_1.png", as(png) replace

    // Cameron & Trivedi's decomposition of IM-test / White test
    estat imtest
    
    // Breusch-Pagan / Cook-Weisberg test for heteroskedasticity
    estat hettest	
*===============================================================================
// Influence Analysis
*===============================================================================     

// Graphic method < before >

    reg dir_fgt0 $postvif
    
    // residuals vs fitted vals
    rvfplot , yline(0)  `graphs' 
                                         
    graph export "$figs\rvfplot_2.png", as(png) replace
    
    
    // normalized residual squared vs leverage
    lvr2plot ,  `graphs' 
                                         
    graph export "$figs\lvr2plot.png", as(png) replace	
	

*===============================================================================
// Model Specification tests
*===============================================================================
   
   reg dir_fgt0 $postvif 
      
// Wald test for ommited vars < will compare with previous regression>   
   boxcox dir_fgt0 $postvif, nolog // Box - Cox model 

   
// Functional form of the conditional mean 
    reg dir_fgt0 $postvif 

    estat ovtest // performs regression specification error test (RESET) for omitted variables 

    linktest //performs a link test for model specification

// Omnibus tests + Heteroscedasticity tests 
    reg dir_fgt0 $postvif 
    
    estat imtest   // Cameron & Trivedi's decomposition of IM-test / White test
        
    estat hettest // Breusch-Pagan / Cook-Weisberg test for Heteroscedasticity 	


*/	
	
save "$data\direct_and_fh_provinces.dta", replace //direct_and_fh_region