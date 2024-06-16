/*


combining direct estimates and the georeferenced covariates at the appropriate area level. Poverty rate estimates are calculated at the admin level 1, admin level 2, and admin level 3



*/




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

//global with candidate variables.

local  vars   hgender1  hage age hmstat1 hmstat2 hmstat3  hreligion1 hreligion2 hreligion3  hnation2 ///
  hethnie1 hethnie2 hethnie3 hethnie4 hethnie5 hethnie6 hethnie7 ///
  heduc1 heduc2 heduc3  hdiploma1 hdiploma2 ///
  hos12m1  couvmal1  handit1  alfa1  educ_scol1 educ_scol2 educ_scol3 ///
  csp_sec5 csp_sec6 csp_sec7  bank1  serviceconsult1 ///
  elec_ua1 ordure1  toilet1  eva_toi1  eva_eau1  tv1 ///
  fer1  frigo1  cuisin1  ordin1  decod1 car1  sh_id_demo1  sh_co_natu1 ///
  conflict_diffusion_indicator geo_*
 /*
 
 hgender1  hage age hmstat1 hmstat2 hmstat3  hreligion1 hreligion2 hreligion3  hnation2 ///
  hethnie1 hethnie2 hethnie3 hethnie4 hethnie5 hethnie6 hethnie7 ///
  heduc1 heduc2 heduc3  hdiploma1 hdiploma2 ///
  hos12m1  couvmal1  handit1  alfa1  educ_scol1 educ_scol2 educ_scol3 ///
  csp_sec5 csp_sec6 csp_sec7  bank1  serviceconsult1 ///
  elec_ua1 ordure1  toilet1  eva_toi1  eva_eau1  tv1 ///
  fer1  frigo1  cuisin1  ordin1  decod1 car1  sh_id_demo1  sh_co_natu1 ///
  conflict_diffusion_indicator mndwi brba nbai ndsi vari savi osavi ndmi  evi ndvi sr arvi ui
 
 */
  

/* hage age hmstat1 hmstat2 hmstat3  hreligion1 hreligion2 hreligion3  hnation2 hethnie1 hethnie2 hethnie3 hethnie8 hethnie9 hethnie10 hethnie11 hethnie12 halfa1  heduc1 heduc2 heduc3  hdiploma1 hdiploma2 hdiploma3  hhandig1  hactiv7j1  hactiv7j4 hactiv7j5 hactiv12m1 hactiv12m2 hactiv12m3 hbranch1  hbranch3 hbranch4 hbranch5 hbranch6 hbranch7 hbranch8 hbranch9 hbranch10 hbranch11 hsectins1 hsectins2 hsectins3 hsectins4 hsectins5  hcsp1 hcsp2 hcsp3 hcsp4 hcsp5 hcsp6  hcsp9 hcsp10 sexe1  lien2 lien3 lien4 lien5  lien7 lien8 lien9 lien10  mstat1 mstat2 mstat3  religion1 religion2 religion3  ethnie1 ethnie2 ethnie3 ethnie4 ethnie5 ethnie6 ethnie7   nation2  mal30j1  aff30j1 aff30j2 aff30j3 aff30j4  arrmal1  hos12m1  couvmal1  handit1  alfa1  educ_scol1 educ_scol2 educ_scol3 educ_scol4 educ_scol5  educ_hi1 educ_hi2 educ_hi3 educ_hi4  diplome1 diplome2 diplome3 diplome4 diplome5 diplome6 diplome7  telpor1  internet1 activ7j1 activ7j2 activ7j3 activ7j4 activ12m1 activ12m2  branch1 branch2 branch3 branch4 branch5  sectins1 sectins2 sectins3 sectins4  emploi_sec1  sectins_sec1 sectins_sec2 sectins_sec3  csp_sec1 csp_sec2 csp_sec3 csp_sec4 csp_sec5 csp_sec6 csp_sec7  bank1  serviceconsult1 serviceconsult2 serviceconsult3  persconsult1 persconsult2 logem1 logem2 logem3  mur1  toit1  sol1  eauboi_ss1  eauboi_sp1  elec_ac1  elec_ur1  elec_ua1 ordure1  toilet1  eva_toi1  eva_eau1  tv1  fer1  frigo1  cuisin1  ordin1  decod1  car1  sh_id_demo1  sh_co_natu1 sh_co_eco1  sh_id_eco1  sh_co_vio1 conflict_diffusion_indicator mndwi brba nbai ndsi vari savi osavi ndmi  evi ndvi sr arvi ui 
*/





merge 1:1 adm1_pcode using "$data\direct_survey_ehcvm_bfa_2021_region.dta" //direct_survey_ehcvm_bfa_2021_province
drop _merge

//Normalize all covariates
foreach x of local vars{
	cap sum `x'
	cap replace `x' = (`x' - r(mean))/r(sd)
}





// Kernel density plot  for dir_fgt0 with a normal density overlaid
    kdensity dir_fgt0, normal `graphs'
    graph export "$figs\kdensity_dir_fgt0.png", as(png) replace
	
	
	
//global with candidate variables.
global  thevar hgender1  hage age ///
  conflict_diffusion_indicator geo_*	
	
*===============================================================================
// Regression diagnostics
*===============================================================================
	//Fit full model	
	fhsae dir_fgt0 $thevar, revar(dir_fgt0_var) method(fh) 
	
	global  hhvars $thevar
	
	//Loop designed to remove non-significant covariates sequentially//0.5(-0.05)0.05//0.8(-0.05)0.0001
	forval z= 0.5(-0.05)0.05{
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
			gen touse = e(sample)   //Indicates the observations used
			gen weight = 1
			//mata: ds = _f_stepvif("`postsign'","weight",5,"touse") 
			
			//mata: ds = _f_stepvif($postsign,"weight",5,"touse")
			//global postvif `vifvar'
	
	
	//local hhvars $postvif
	global hhvars $postsign
	
	//One final removal of non-significant covariates //0.5(-0.05)0.05//0.8(-0.05)0.0001
	forval z= 0.5(-0.05)0.05{
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


// Normality 
 
    reg dir_fgt0 $last ,r
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

// Heteroscedasticity 

    reg dir_fgt0 $last

    // Residuals vs fitted values with a reference line at y=0
    rvfplot , yline(0)  `graphs' 
                                         
    graph export "$figs\rvfplot_1.png", as(png) replace

    // Cameron & Trivedi's decomposition of IM-test / White test
    estat imtest
    
    // Breusch-Pagan / Cook-Weisberg test for heteroskedasticity
    estat hettest
	
	
save "$data\direct_and_fh_region.dta", replace //direct_and_fh_provinces