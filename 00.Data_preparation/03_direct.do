//do file to prepare SURVEY data for poverty mapping
*same as collapse




ssc install groupfunction
/*
cap: net install github, from("https://haghish.github.io/github/")
github install jpazvd/fhsae
github install pcorralrodas/groupfunction 
github install pcorralrodas/sp_groupfunction
*/


**************************************
/*
we calculate direct estimates at every geographic level of disaggregation: national, regional, admin level 1, admin level 2, and admin level 3. We only use the output from 01_dataprep_survey.do.
To obtain direct estimates with correctly calculated standard errors from a complex sample, it is necessary to input the structure by specifying the stratification and clustering used ( svyset in Stata). The script describes how to obtain direct estimates of poverty rates and their sampling variances for each area in the sample. 
*/
*****************************************
clear all

set more off

version 14





*===============================================================================
//Specify team paths 
*===============================================================================

global main          "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso"
global data       	"$main\00.Data"

use "$data\survey_ehcvm_bfa_2021.dta",clear

rename milieu1 urban
rename pcexp welfare
rename zref pl_abs
rename hhweight2021 WTA_S_HHSIZE
//rename province province
rename grappe clust //to check


egen strata = group(region urban)
svyset clust [pw=WTA_S_HHSIZE], strata(strata)
gen fgt0 = (welfare < pl_abs) if !missing(welfare)

preserve
groupfunction [aw=WTA_S_HHSIZE], mean(fgt0) rawsum(WTA_S_HHSIZE) by(province clust)

groupfunction [aw=WTA_S_HHSIZE], mean(fgt0) count(clust) by(province)
restore


preserve
//The below are for comparison to final FH estimates
svy: proportion fgt0, over(region)
	mata: fgt0 = st_matrix("e(b)")
	mata: fgt0 = fgt0[(cols(fgt0)/2+1)..cols(fgt0)]'
	mata: fgt0_var = st_matrix("e(V)")
	mata: fgt0_var = diagonal(fgt0_var)[(cols(fgt0_var)/2+1)..cols(fgt0_var)]
	gen N=1 //Need the number of observation by province...for smoother variance function
	gen N_hhsize = hhsize

	//Number of EA by province
	bysort region clust: gen num_ea = 1 if _n==1

	groupfunction [aw=WTA_S_HHSIZE], mean(fgt0) rawsum(N WTA_S_HHSIZE N_hhsize num_ea) by(region)
	sort region
	getmata dir_fgt0 = fgt0 dir_fgt0_var = fgt0_var
    gen zero = dir_fgt0 //original variable with direct estimates
	replace dir_fgt0_var = . if dir_fgt0_var==0
	replace dir_fgt0 = . if missing(dir_fgt0_var)
	gen adm1_pcode ="."
	replace adm1_pcode = "BF46" if region == 1
	replace adm1_pcode = "BF47" if region == 2
	replace adm1_pcode = "BF13" if region == 3
	replace adm1_pcode = "BF48" if region == 4
	replace adm1_pcode = "BF49" if region == 5
	replace adm1_pcode = "BF50" if region == 6
	replace adm1_pcode = "BF51" if region == 7
	replace adm1_pcode = "BF52" if region == 8
	replace adm1_pcode = "BF53" if region == 9
	replace adm1_pcode = "BF54" if region == 10
	replace adm1_pcode = "BF55" if region == 11
	replace adm1_pcode = "BF56" if region == 12
	replace adm1_pcode = "BF57" if region == 13

	save "$data\direct_survey_ehcvm_bfa_2021_region.dta", replace


restore

preserve
svy:proportion fgt0, over(province)

	mata: fgt0 = st_matrix("e(b)")
	mata: fgt0 = fgt0[(cols(fgt0)/2+1)..cols(fgt0)]'
	mata: fgt0_var = st_matrix("e(V)")
	mata: fgt0_var = diagonal(fgt0_var)[(cols(fgt0_var)/2+1)..cols(fgt0_var)]

	gen N=1 //Need the number of observation by province...for smoother variance function
	gen N_hhsize = hhsize

	//Number of EA by province
	bysort province clust: gen num_ea = 1 if _n==1

	groupfunction [aw=WTA_S_HHSIZE], mean(fgt0) rawsum(N WTA_S_HHSIZE N_hhsize num_ea) by(region province)

	sort province
	getmata dir_fgt0 = fgt0 dir_fgt0_var = fgt0_var

	gen zero = dir_fgt0 //original variable with direct estimates

	replace dir_fgt0_var = . if dir_fgt0_var==0
	replace dir_fgt0 = . if missing(dir_fgt0_var)
	gen adm1_pcode ="."
	replace adm1_pcode = "BF46" if region == 1
	replace adm1_pcode = "BF47" if region == 2
	replace adm1_pcode = "BF13" if region == 3
	replace adm1_pcode = "BF48" if region == 4
	replace adm1_pcode = "BF49" if region == 5
	replace adm1_pcode = "BF50" if region == 6
	replace adm1_pcode = "BF51" if region == 7
	replace adm1_pcode = "BF52" if region == 8
	replace adm1_pcode = "BF53" if region == 9
	replace adm1_pcode = "BF54" if region == 10
	replace adm1_pcode = "BF55" if region == 11
	replace adm1_pcode = "BF56" if region == 12
	replace adm1_pcode = "BF57" if region == 13
	
	
	gen adm2_pcode ="."
	replace adm2_pcode = "BF4601" if province == 1
	replace adm2_pcode = "BF4901" if province == 2
	replace adm2_pcode = "BF4602" if province == 3
	replace adm2_pcode = "BF5101" if province == 4
	replace adm2_pcode = "BF5701" if province == 5
	replace adm2_pcode = "BF4801" if province == 6
	replace adm2_pcode = "BF5001" if province == 7
	replace adm2_pcode = "BF4701" if province == 8
	replace adm2_pcode = "BF5501" if province == 9
	replace adm2_pcode = "BF5201" if province == 10
	replace adm2_pcode = "BF5202" if province == 11
	replace adm2_pcode = "BF5301" if province == 12
	replace adm2_pcode = "BF5702" if province == 13
	replace adm2_pcode = "BF1300" if province == 14
	replace adm2_pcode = "BF5302" if province == 15
	replace adm2_pcode = "BF5203" if province == 16
	replace adm2_pcode = "BF5204" if province == 17
	replace adm2_pcode = "BF4603" if province == 18
	replace adm2_pcode = "BF4802" if province == 19
	replace adm2_pcode = "BF4803" if province == 20
	replace adm2_pcode = "BF5502" if province == 21
	replace adm2_pcode = "BF4702" if province == 22
	replace adm2_pcode = "BF5401" if province == 23
	replace adm2_pcode = "BF4604" if province == 24
	replace adm2_pcode = "BF5102" if province == 25
	replace adm2_pcode = "BF4902" if province == 26
	replace adm2_pcode = "BF4605" if province == 27
	replace adm2_pcode = "BF5703" if province == 28
	replace adm2_pcode = "BF5503" if province == 29
	replace adm2_pcode = "BF5601" if province == 30
	replace adm2_pcode = "BF5402" if province == 31
	replace adm2_pcode = "BF5704" if province == 32
	replace adm2_pcode = "BF5002" if province == 33
	replace adm2_pcode = "BF4903" if province == 34
	replace adm2_pcode = "BF5602" if province == 35
	replace adm2_pcode = "BF5003" if province == 36
	replace adm2_pcode = "BF5603" if province == 37
	replace adm2_pcode = "BF4606" if province == 38
	replace adm2_pcode = "BF5205" if province == 39
	replace adm2_pcode = "BF5303" if province == 40
	replace adm2_pcode = "BF5604" if province == 41
	replace adm2_pcode = "BF5403" if province == 42
	replace adm2_pcode = "BF5004" if province == 43
	replace adm2_pcode = "BF5404" if province == 44
	replace adm2_pcode = "BF5103" if province == 45

	save "$data\direct_survey_ehcvm_bfa_2021_province.dta", replace



////

