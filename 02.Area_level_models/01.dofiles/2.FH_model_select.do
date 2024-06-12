set more off
clear all

version 15
set matsize 8000
set seed 648743

//ssc install sae

global main          "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso"
global data       	"$main\00.Data"
global figs        "$main\02_Area_level_models\04.graphics"



use "$data\province_survey_ehcvm_bfa_2021.dta", clear


local vars  hgender1  hage age hmstat1 hmstat2 hmstat3  hreligion1 hreligion2 hreligion3  hnation2   hethnie1 hethnie2 hethnie3 hethnie4 hethnie5 hethnie6 hethnie7 hethnie8 hethnie9 hethnie10 hethnie11 hethnie12 halfa1  heduc1 heduc2 heduc3  hdiploma1 hdiploma2 hdiploma3  hhandig1  hactiv7j1  hactiv7j4 hactiv7j5 hactiv12m1 hactiv12m2 hactiv12m3 hbranch1  hbranch3 hbranch4 hbranch5 hbranch6 hbranch7 hbranch8 hbranch9 hbranch10 hbranch11 hsectins1 hsectins2 hsectins3 hsectins4 hsectins5  hcsp1 hcsp2 hcsp3 hcsp4 hcsp5 hcsp6  hcsp9 hcsp10 sexe1  lien2 lien3 lien4 lien5  lien7 lien8 lien9 lien10  mstat1 mstat2 mstat3  religion1 religion2 religion3  ethnie1 ethnie2 ethnie3 ethnie4 ethnie5 ethnie6 ethnie7   nation2  mal30j1  aff30j1 aff30j2 aff30j3 aff30j4  arrmal1  hos12m1  couvmal1  handit1  alfa1  educ_scol1 educ_scol2 educ_scol3 educ_scol4 educ_scol5  educ_hi1 educ_hi2 educ_hi3 educ_hi4  diplome1 diplome2 diplome3 diplome4 diplome5 diplome6 diplome7  telpor1  internet1 activ7j1 activ7j2 activ7j3 activ7j4 activ12m1 activ12m2  branch1 branch2 branch3 branch4 branch5  sectins1 sectins2 sectins3 sectins4  emploi_sec1  sectins_sec1 sectins_sec2 sectins_sec3  csp_sec1 csp_sec2 csp_sec3 csp_sec4 csp_sec5 csp_sec6 csp_sec7  bank1  serviceconsult1 serviceconsult2 serviceconsult3  persconsult1 persconsult2 logem1 logem2 logem3  mur1  toit1  sol1  eauboi_ss1  eauboi_sp1  elec_ac1  elec_ur1  elec_ua1 ordure1  toilet1  eva_toi1  eva_eau1  tv1  fer1  frigo1  cuisin1  ordin1  decod1  car1  sh_id_demo1  sh_co_natu1 sh_co_eco1  sh_id_eco1  sh_co_vio1  

egen workpop_primary = rsum(csp1 csp2 csp3 csp4)

//Normalize all covariates
foreach x of local vars{
	cap sum `x'
	cap replace `x' = (`x' - r(mean))/r(sd)
}


/*
gen D = region*100
replace D = D+district

drop district 
rename D district
*/
merge 1:1 adm2_pcode using "$data\direct_survey_ehcvm_bfa_2021_province.dta"
tab region, gen(thereg)
unab hhvars: `vars'


*===============================================================================
//Create smoothed variance function
*===============================================================================
gen log_s2 = log(dir_fgt0_var)
gen logN = log(N)
gen logN2 = logN^2
gen logpop  = log(pop)
gen logpop2 = logpop^2
//gen accra = region==3
//reg log_s2 logpop logpop2 i.accra#c.logN, r
//reg log_s2 logpop logpop2 i.accra##c.logN, r
gen share = log(N_hhsize/pop)
reg log_s2 share, r
local phi2 = e(rmse)^2
cap drop xb_fh
predict xb_fh, xb
predict residual,res
sum xb_fh if residual!=.,d
gen exp_xb_fh = exp(xb_fh)
sum dir_fgt0_var
local sumvar = r(sum)
sum exp_xb_fh
local sump = r(sum)

//Below comes from: https://presidencia.gva.es/documents/166658342/168130165/Ejemplar+45-01.pdf/fb04aeb3-9ea6-441f-a15c-bc65e857d689?t=1557824876209#page=107
gen smoothed_var = exp_xb_fh*(`sumvar'/`sump') 

//Modified to only replace for the locations with 0 variance
replace dir_fgt0_var = smoothed_var if ((num_ea>1 & !missing(num_ea)) | (num_ea==1 & zero!=0 & zero!=1)) & missing(dir_fgt0_var)
replace dir_fgt0 = zero if !missing(dir_fgt0_var)

fhsae dir_fgt0 `hhvars', revar(dir_fgt0_var) method(fh)


//Removal of non-significant variables
	//Removal of non-significant variables
	forval z= 0.8(-0.05)0.05{
		qui:  fhsae dir_fgt0 `hhvars', revar(dir_fgt0_var) method(fh) nonegative
		mata: bb=st_matrix("e(b)")
		mata: se=sqrt(diagonal(st_matrix("e(V)")))
		mata: zvals = bb':/se
		mata: st_matrix("min",min(abs(zvals)))
		local zv = (-min[1,1])
		if (2*normal(`zv')<`z') exit	
		foreach x of varlist `hhvars'{
			local hhvars1
			qui: fhsae dir_fgt0 `hhvars', revar(dir_fgt0_var) method(fh) nonegative
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
	
	//Final model without non-significant variables no funciona
	fhsae dir_fgt0 ${postsign}, revar(dir_fgt0_var) method(fh)
	
	//Check VIF
	reg dir_fgt0 $postsign, r
	gen touse = e(sample)
	gen weight = 1
	mata: ds =  _f_stepvif("$postsign","weight",5,"touse") 
	
	//ver abajo
	global postvif `vifvar'
	
	local hhvars $postvif
	
	//One final removal of non-significant covariates
	forval z= 0.8(-0.05)0.0001{
		qui:fhsae dir_fgt0 workpop_primary `hhvars', revar(dir_fgt0_var) method(reml) precision(1e-10)
		mata: bb=st_matrix("e(b)")
		mata: se=sqrt(diagonal(st_matrix("e(V)")))
		mata: zvals = bb':/se
		mata: st_matrix("min",min(abs(zvals)))
		local zv = (-min[1,1])
		if (2*normal(`zv')>=`z'){
			foreach x of varlist `hhvars'{
				local hhvars1
				qui: fhsae dir_fgt0 workpop_primary `hhvars', revar(dir_fgt0_var) method(reml) precision(1e-10)
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
	}
	
	fhsae dir_fgt0 `hhvars', revar(dir_fgt0_var) method(reml) precision(1e-10)
	//local remove head_religion3
	//local hhvars: list hhvars - remove
	global last `hhvars'
	
	fhsae dir_fgt0 workpop_primary $last, revar(dir_fgt0_var) method(chandra)
	fhsae dir_fgt0 workpop_primary $last, revar(dir_fgt0_var) method(fh)
	fhsae dir_fgt0 workpop_primary $last, revar(dir_fgt0_var) method(reml)
//*********************************************************************************************//

	//Obtain SAE-FH-estimates	
	fhsae dir_fgt0 workpop_primary $last, revar(dir_fgt0_var) method(reml) fh(fh_fgt0) ///
	fhse(fh_fgt0_se) fhcv(fh_fgt0_cv) gamma(fh_fgt0_gamma) out noneg precision(1e-13)

	//Check normal errors
	predict xb
	gen u_d = fh_fgt0 - xb //Random errors (area effects) and represent unexplained heterogeneity between areas, assumed to have a zero mean and constant variance
	lab var u_d "FH area effects"
	
	histogram u_d, normal graphregion(color(white))
	graph export "$figs\Fig1_left.png", as(png) replace
	qnorm u_d, graphregion(color(white))
	graph export "$figs\u_d.png", as(png) replace
	
	gen e_d = dir_fgt0 - fh_fgt0 //The errors, e_d are assumed to be heteroskedastic
	lab var e_d "FH errors"
	
	histogram e_d, normal graphregion(color(white))
	graph export "$figs\Fig1_right.png", as(png) replace
	qnorm e_d, graphregion(color(white))
	graph export "$figs\e_d.png", as(png) replace

	
//keep region district fh_fgt0 fh_fgt0_se
save "$data\FH_sae_poverty.dta", replace