set more off
clear all


set matsize 8000
set seed 648743

*===============================================================================
//Specify team paths 
*===============================================================================
global main          "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso"
global data       	"$main\00.Data"
global figs        "$main\05.Graphics"


mata
	//Mata function for selection
	function mysel2(_bb, _se, _pval){
		thevars = tokens(st_local("_myhhvars"))
		zvals   = (_bb':/_se)[1..(rows(_se)-1)]
		zvals   = 2:*normal(-abs(zvals))
		if (colmax(zvals)>_pval){
			keepvar = thevars[selectindex(colmax(zvals):>zvals)]
			return(keepvar)	
		}	
		else{
			keepvar = "it's done"
			return(keepvar)
		}
	}

end


use "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso\00.Data\EHCVM data\BFA_2021_EHCVM-P_v02_M_Stata\commune_survey_ehcvm_bfa_2021.dta", clear

sort adm3_pcode
quietly by adm3_pcode:  gen dup = cond(_N==1,0,_n)

tabulate dup
/*
dup = 0       record is unique
dup = 1       record is duplicate, first occurrence
dup = 2       record is duplicate, second occurrence
dup = 3       record is duplicate, third occurrence
etc.



        dup |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        351      100.00      100.00
------------+-----------------------------------
      Total |        351      100.00



*/

drop if dup>1
drop dup


merge 1:1 adm3_pcode using "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso\00.Data\spatial_data_admin3.dta"
drop _merge



merge 1:1 adm3_pcode using "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso\00.Data\EHCVM data\BFA_2021_EHCVM-P_v02_M_Stata\direct_survey_ehcvm_bfa_2021_admin3.dta"
/*

    Result                      Number of obs
    -----------------------------------------
    Not matched                           114
        from master                       114  (_merge==1)
        from using                          0  (_merge==2)

    Matched                               237  (_merge==3)
    -----------------------------------------

*/
drop _merge
/*

*===============================================================================
// Voir l'effet des conflict events sur le fait de ne pas etre enquete
*===============================================================================
gen dummy = (fgt0 !=.)


/*

Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. err.   Std. dev.   [95% conf. interval]
---------+--------------------------------------------------------------------
       0 |     142    .1679182    .0182251    .2171769    .1318884    .2039479
       1 |     209    .0720957    .0116606    .1685758    .0491076    .0950839
---------+--------------------------------------------------------------------
Combined |     351    .1108615    .0104196    .1952116    .0903686    .1313545
---------+--------------------------------------------------------------------
    diff |            .0958224     .020632                .0552438    .1364011
------------------------------------------------------------------------------
    diff = mean(0) - mean(1)                                      t =   4.6444
H0: diff = 0                                     Degrees of freedom =      349

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 1.0000         Pr(|T| > |t|) = 0.0000          Pr(T > t) = 0.0000

*/


gen dummy_ei_battles = (acled_ei_battles >0)

foreach x of varlist acled_events_*  {
	gen dummy_`x' = (`x' >0)
}
// utiliser gtsummary pour avoir un tableau avec tous les events
tab dummy_ei_battles dummy, col

ssc install asdoc
asdoc prtest dummy_ei_battles, by(dummy) replace
asdoc ttest acled_ei , by(dummy) replace


foreach x of varlist acled_ei_vac acled_ei_battles acled_ei_riots acled_ei_protests acled_ei_erv acled_ei_sd  {
	asdoc ttest `x' , by(dummy) append
}
stepwise, pr(.1): probit dummy acled_cdi_* acled_ei_*
estimates store model 
esttab model using "${data}\Model_Results2.rtf", replace

save "$data\Model_data_forR.dta", replace


//,  cells(b(star fmt(%3.2f)) se(par)) starlevels( * 0.10 ** 0.05 *** 0.01) stats(bic aic hqic N r2 , star) label replace
drop dummy_ei_battles  dummy

////////////////////////////////////////////////////////////////

*/

*===============================================================================
//FH Estimation
*===============================================================================

foreach x of varlist geo_* acled_* ham_2019_* haw_2019_* ttc_2015_* pf_parasite_rate_* pf_mortality_rate_*  night_* buildings_* {
	gen `x'2 = `x' * `x'
}

/*
local vars  hage	hcsp6	resid1	hcsp4	lien1	lien2	lien3	lien4	lien5	lien6	lien7	lien8	lien9	lien10	hsectins3		mstat3		mstat6	religion1	religion2	religion3	religion4	ethnie1	ethnie2	ethnie3	ethnie4	ethnie5	ethnie6	ethnie7	ethnie8	ethnie9	ethnie10	ethnie11	nation1	nation2		nation4			nation7	nation8	nation9	nation10	hcsp8	hsectins1	nation13	nation14	nation15	mal30j1		hos12m1	couvmal1			educ_hi1	educ_hi2	educ_hi3	hcsp9	educ_hi5	educ_hi6		educ_hi8	diplome1	diplome2	diplome3	diplome4	diplome5	diplome6	diplome7	diplome8	hcsp3		diplome11		internet1	activ7j1	activ7j2	activ7j3	activ7j4	activ7j5	activ12m1	branch1	branch2	branch3	branch4	branch5	branch6	branch7	branch8	branch9	branch10	bank1	logem1	logem2	logem3	mur1	hcsp5	sol1		elec_ac1	elec_ur1	elec_ua1	ordure1	toilet1	eva_toi1	eva_eau1	tv1	fer1	hsectins2	cuisin1	ordin1	decod1	hsectins5	sh_id_demo1	sh_co_natu1	sh_co_eco1		sh_co_vio1	sh_co_oth1	milieu1		hmstat2		hmstat4	hmstat5	hmstat6	hreligion1	hreligion2	hreligion3	hreligion4	hnation1	hnation2	hnation3	hcsp7	hnation5	hnation6	hnation7	hethnie1	hethnie2	hethnie3	hethnie4	hethnie5	hethnie6	hethnie7	hethnie8		hsectins4	halfa1	heduc1	heduc2	heduc3	heduc4	heduc5	heduc6	heduc7	hdiploma1	hdiploma2	hdiploma3	hdiploma4	hdiploma6	hdiploma7	hdiploma8	hdiploma9	hdiploma10	hhandig1	hactiv7j1	hcsp1	hcsp2	hactiv7j4	hactiv12m1	hbranch1	hbranch2	hbranch3	hbranch4	hbranch5	hbranch6	hbranch7		hbranch9	hbranch10 


//Normalize
foreach x of local vars{
	cap sum `x'
	cap replace `x' = (`x' - r(mean))/r(sd)
}

*/
local vars geo_* ham_2019_* haw_2019_* ttc_2015_* pf_parasite_rate_* pf_mortality_rate_*  night_* acled_cdi_* acled_ei_* buildings_* adm1_pcode_1-adm1_pcode_13 

unab hhvars: `vars'


*===============================================================================
//Create smoothed variance function
*===============================================================================
//replace dir_fgt0_var = 0.0001 if dir_fgt0_var ==. //in 1/237
gen log_s2 = log(dir_fgt0_var)
gen logN = log(N)
gen logN2 = logN^2
gen logpop  = log(Worlpop_population)
//pop
gen logpop2 = logpop^2

gen share = log(N_hhsize/Worlpop_population)
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
	local hhvars : list clean hhvars
	dis as error "Sim : `sim' first removal"
	//Removal of non-significant variables
	forval z= 0.2(-0.05)1e-5{
		local regreso 
		while ("`regreso'"!="it's done"){
			quietly:fhsae dir_fgt0 `hhvars', revar(dir_fgt0_var) method(fh) 
			mata: bb=st_matrix("e(b)")
			mata: se=sqrt(diagonal(st_matrix("e(V)")))
			local _myhhvars : colnames(e(b))
			mata: st_local("regreso", invtokens(mysel2(bb, se, `z')))	
			if ("`regreso'"!="it's done") local hhvars `regreso'
		}		
	}
	
	//Global with non-significant variables removed
	global postsign `hhvars'
	
	//Final model without non-significant variables 
	quietly:fhsae dir_fgt0 ${postsign}, revar(dir_fgt0_var) method(fh)
	
	//Check VIF
	reg dir_fgt0 $postsign, r
	gen touse = e(sample)
	gen weight = 1
	mata: ds = _f_stepvif("$postsign","weight",5,"touse") 
	
	global postvif `vifvar'	
	local hhvars $postvif
/*	
	//One final removal of non-significant covariates
dis as error "Sim : `sim' final removal"
	//One final removal of non-significant covariates
	forval z= 0.2(-0.05)1e-5{
		local regreso 
		while ("`regreso'"!="it's done"){
			quietly:fhsae dir_fgt0 `hhvars', revar(dir_fgt0_var) method(reml) precision(1e-10)
			mata: bb=st_matrix("e(b)")
			mata: se=sqrt(diagonal(st_matrix("e(V)")))
			local _myhhvars : colnames(e(b))
			mata: st_local("regreso", invtokens(mysel2(bb, se, `z')))	
			if ("`regreso'"!="it's done") local hhvars `regreso'
		}	
	}	
*/	
	
	global last `hhvars'
	
//*********************************************************************************************//


	//Obtain SAE-FH-estimates	
	fhsae dir_fgt0  $postsign, revar(dir_fgt0_var) method(reml) fh(fh_fgt0) ///
	fhse(fh_fgt0_se) fhcv(fh_fgt0_cv) gamma(fh_fgt0_gamma) out noneg precision(1e-13)

	//Check normal errors
	predict xb
	gen u_d = fh_fgt0 - xb
	lab var u_d "FH area effects"
	
	histogram u_d, normal graphregion(color(white))
	//graph export "$figs\Fig1_left.png", as(png) replace
	qnorm u_d, graphregion(color(white))
	
	gen e_d = dir_fgt0 - fh_fgt0
	lab var e_d "FH errors"
	
	histogram e_d, normal graphregion(color(white))
	///graph export "$figs\SAE Ghana 2017\3. Graphics\Fig1_right.png", as(png) replace
	qnorm e_d, graphregion(color(white))

stepwise, pr(.1): reg dir_fgt0 $postsign, r 	
order adm0_pcode adm1_pcode adm2_pcode adm3_pcode fh_fgt0 fh_fgt0_se fgt0se fh_fgt0_cv dir_fgt0_cv fh_fgt0_gamma fgt0 dir_fgt0 dir_fgt0_var
//keep adm0_pcode adm1_pcode adm2_pcode adm3_pcode fh_fgt0 fh_fgt0_se fh_fgt0_cv fh_fgt0_gamma fgt0
save "$data\FH_sae_poverty.dta", replace

*/