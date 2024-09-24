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




*===============================================================================
//level 1
*===============================================================================
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
/*
//FGT :  indices de Foster-Greer-Thorbecke (FGT) 
définis en 1984
L'incidence de la pauvreté (fgt0) mesure la proportion de la population qui vit en état de 
pauvreté, celle pour laquelle la consommation est inférieure à la ligne (seuil) de 
pauvreté par personne par an.  

La profondeur de la pauvreté (écart de pauvreté)  (fgt1) mesure la distance moyenne entre 
le revenu des ménages et la ligne de pauvreté, en donnant une distance zéro aux 
ménages qui sont au-dessus de la ligne de pauvreté.  

La sévérité de pauvreté (fgt2)
	forval a=0/2{
	    gen fgt`a' = (welfare<pl_abs)*(1-welfare/(pl_abs))^`a'
	}
*/
preserve
groupfunction [aw=WTA_S_HHSIZE], mean(fgt0) rawsum(WTA_S_HHSIZE) by(region clust)

groupfunction [aw=WTA_S_HHSIZE], mean(fgt0) count(clust) by(region)
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
///////////	
	
	
	
	
	
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


//restore

//preserve


*===============================================================================
//level 2 
*===============================================================================
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

//preserve
groupfunction [aw=WTA_S_HHSIZE], mean(fgt0) rawsum(WTA_S_HHSIZE) by(region clust)

groupfunction [aw=WTA_S_HHSIZE], mean(fgt0) count(clust) by(region)
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
////	
	
	
	
	
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
replace adm2_pcode = "BF4601" if province == 31
replace adm2_pcode = "BF4901" if province == 1
replace adm2_pcode = "BF4602" if province == 32
replace adm2_pcode = "BF5101" if province == 2
replace adm2_pcode = "BF5701" if province == 3
replace adm2_pcode = "BF4801" if province == 4
replace adm2_pcode = "BF5001" if province == 5
replace adm2_pcode = "BF4701" if province == 6
replace adm2_pcode = "BF5501" if province == 7
replace adm2_pcode = "BF5201" if province == 8
replace adm2_pcode = "BF5202" if province == 9
replace adm2_pcode = "BF5301" if province == 10
replace adm2_pcode = "BF5702" if province == 33
replace adm2_pcode = "BF1300" if province == 11
replace adm2_pcode = "BF5302" if province == 12
replace adm2_pcode = "BF5203" if province == 34
//replace adm2_pcode = "BF5204" if province == 
replace adm2_pcode = "BF4603" if province == 13
replace adm2_pcode = "BF4802" if province == 36
replace adm2_pcode = "BF4803" if province == 14
replace adm2_pcode = "BF5502" if province == 37
replace adm2_pcode = "BF4702" if province == 38
replace adm2_pcode = "BF5401" if province == 39
replace adm2_pcode = "BF4604" if province == 15
replace adm2_pcode = "BF5102" if province == 16
replace adm2_pcode = "BF4902" if province == 17
replace adm2_pcode = "BF4605" if province == 40
replace adm2_pcode = "BF5703" if province == 41
replace adm2_pcode = "BF5503" if province == 18
replace adm2_pcode = "BF5601" if province == 19
replace adm2_pcode = "BF5402" if province == 20
replace adm2_pcode = "BF5704" if province == 21
replace adm2_pcode = "BF5002" if province == 22
replace adm2_pcode = "BF4903" if province == 23
replace adm2_pcode = "BF5602" if province == 24
replace adm2_pcode = "BF5003" if province == 25
replace adm2_pcode = "BF5603" if province == 26
replace adm2_pcode = "BF4606" if province == 27
replace adm2_pcode = "BF5205" if province == 28
replace adm2_pcode = "BF5303" if province == 42
replace adm2_pcode = "BF5604" if province == 43
replace adm2_pcode = "BF5403" if province == 29
replace adm2_pcode = "BF5004" if province == 44
replace adm2_pcode = "BF5404" if province == 45

save "$data\direct_survey_ehcvm_bfa_2021_province.dta", replace



////

*===============================================================================
//level 3 
*===============================================================================
/*
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

//preserve
groupfunction [aw=WTA_S_HHSIZE], mean(fgt0) rawsum(WTA_S_HHSIZE) by(region clust)

groupfunction [aw=WTA_S_HHSIZE], mean(fgt0) count(clust) by(region)
restore


preserve
svy:proportion fgt0, over(adm3_pcode_bis)

	mata: fgt0 = st_matrix("e(b)")
	mata: fgt0 = fgt0[(cols(fgt0)/2+1)..cols(fgt0)]'
	mata: fgt0_var = st_matrix("e(V)")
	mata: fgt0_var = diagonal(fgt0_var)[(cols(fgt0_var)/2+1)..cols(fgt0_var)]

	gen N=1 //Need the number of observation by province...for smoother variance function
	gen N_hhsize = hhsize

	//Number of EA by province
	bysort adm3_pcode_bis clust: gen num_ea = 1 if _n==1

	groupfunction [aw=WTA_S_HHSIZE], mean(fgt0) rawsum(N WTA_S_HHSIZE N_hhsize num_ea) by(region province adm3_pcode_bis)

	sort adm3_pcode_bis
	getmata dir_fgt0 = fgt0 dir_fgt0_var = fgt0_var

	gen zero = dir_fgt0 //original variable with direct estimates

	replace dir_fgt0_var = . if dir_fgt0_var==0
	replace dir_fgt0 = . if missing(dir_fgt0_var)
*/




*===============================================================================
//level 3 
*===============================================================================

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

gen popw = WTA_S_HHSIZE*hhsize

gen fgt0se = fgt0

gen Sample_size = 1

collapse  (sum)  Sample_size popw WTA_S_HHSIZE (mean) fgt0 (semean) fgt0se [aw = popw], by(adm3_pcode_bis) // not [aw = popw]

collapse (count)
gen dir_fgt0_var = fgt0se ^2

/*

//SVY set, SRS	
	svyset [pw=popw], strata(adm3_pcode_bis)
	//Get direct estimates
	qui:svy: proportion fgt0, over(adm3_pcode_bis)
	mata: fgt0 = st_matrix("e(b)")
	mata: fgt0 = fgt0[(cols(fgt0)/2)..cols(fgt0)]'
	mata: fgt0_var = st_matrix("e(V)")
	mata: fgt0_var = diagonal(fgt0_var)[(cols(fgt0_var)/2)..cols(fgt0_var)]

	gen N=1 //Need the number of observation by province...for smoother variance function
	gen N_hhsize = hhsize

	//Number of EA by province
	bysort adm3_pcode_bis clust: gen num_ea = 1 if _n==1

	groupfunction [aw=WTA_S_HHSIZE], mean(fgt0) rawsum(popw WTA_S_HHSIZE N_hhsize num_ea) by(adm3_pcode_bis)

	sort adm3_pcode_bis
	getmata dir_fgt0 = fgt0 dir_fgt0_var = fgt0_var

	gen zero = dir_fgt0 //original variable with direct estimates

	replace dir_fgt0_var = . if dir_fgt0_var==0
	replace dir_fgt0 = . if missing(dir_fgt0_var)
*/	
gen adm3_pcode = "."
replace adm3_pcode = "BF130001" if adm3_pcode_bis == 130001
replace adm3_pcode = "BF130002" if adm3_pcode_bis == 130002
replace adm3_pcode = "BF130003" if adm3_pcode_bis == 130003
replace adm3_pcode = "BF130004" if adm3_pcode_bis == 130004
replace adm3_pcode = "BF130006" if adm3_pcode_bis == 130006
replace adm3_pcode = "BF130007" if adm3_pcode_bis == 130007
replace adm3_pcode = "BF460101" if adm3_pcode_bis == 460101
replace adm3_pcode = "BF460102" if adm3_pcode_bis == 460102
replace adm3_pcode = "BF460103" if adm3_pcode_bis == 460103
replace adm3_pcode = "BF460104" if adm3_pcode_bis == 460104
replace adm3_pcode = "BF460105" if adm3_pcode_bis == 460105
replace adm3_pcode = "BF460106" if adm3_pcode_bis == 460106
replace adm3_pcode = "BF460108" if adm3_pcode_bis == 460108
replace adm3_pcode = "BF460201" if adm3_pcode_bis == 460201
replace adm3_pcode = "BF460202" if adm3_pcode_bis == 460202
replace adm3_pcode = "BF460204" if adm3_pcode_bis == 460204
replace adm3_pcode = "BF460205" if adm3_pcode_bis == 460205
replace adm3_pcode = "BF460206" if adm3_pcode_bis == 460206
replace adm3_pcode = "BF460303" if adm3_pcode_bis == 460303
replace adm3_pcode = "BF460304" if adm3_pcode_bis == 460304
replace adm3_pcode = "BF460309" if adm3_pcode_bis == 460309
replace adm3_pcode = "BF460401" if adm3_pcode_bis == 460401
replace adm3_pcode = "BF460402" if adm3_pcode_bis == 460402
replace adm3_pcode = "BF460403" if adm3_pcode_bis == 460403
replace adm3_pcode = "BF460405" if adm3_pcode_bis == 460405
replace adm3_pcode = "BF460406" if adm3_pcode_bis == 460406
replace adm3_pcode = "BF460407" if adm3_pcode_bis == 460407
replace adm3_pcode = "BF460501" if adm3_pcode_bis == 460501
replace adm3_pcode = "BF460504" if adm3_pcode_bis == 460504
replace adm3_pcode = "BF460506" if adm3_pcode_bis == 460506
replace adm3_pcode = "BF460601" if adm3_pcode_bis == 460601
replace adm3_pcode = "BF460606" if adm3_pcode_bis == 460606
replace adm3_pcode = "BF460608" if adm3_pcode_bis == 460608
replace adm3_pcode = "BF470101" if adm3_pcode_bis == 470101
replace adm3_pcode = "BF470102" if adm3_pcode_bis == 470102
replace adm3_pcode = "BF470103" if adm3_pcode_bis == 470103
replace adm3_pcode = "BF470105" if adm3_pcode_bis == 470105
replace adm3_pcode = "BF470107" if adm3_pcode_bis == 470107
replace adm3_pcode = "BF470108" if adm3_pcode_bis == 470108
replace adm3_pcode = "BF470109" if adm3_pcode_bis == 470109
replace adm3_pcode = "BF470202" if adm3_pcode_bis == 470202
replace adm3_pcode = "BF470204" if adm3_pcode_bis == 470204
replace adm3_pcode = "BF470205" if adm3_pcode_bis == 470205
replace adm3_pcode = "BF470206" if adm3_pcode_bis == 470206
replace adm3_pcode = "BF470207" if adm3_pcode_bis == 470207
replace adm3_pcode = "BF480101" if adm3_pcode_bis == 480101
replace adm3_pcode = "BF480102" if adm3_pcode_bis == 480102
replace adm3_pcode = "BF480103" if adm3_pcode_bis == 480103
replace adm3_pcode = "BF480105" if adm3_pcode_bis == 480105
replace adm3_pcode = "BF480106" if adm3_pcode_bis == 480106
replace adm3_pcode = "BF480107" if adm3_pcode_bis == 480107
replace adm3_pcode = "BF480108" if adm3_pcode_bis == 480108
replace adm3_pcode = "BF480110" if adm3_pcode_bis == 480110
replace adm3_pcode = "BF480111" if adm3_pcode_bis == 480111
replace adm3_pcode = "BF480113" if adm3_pcode_bis == 480113
replace adm3_pcode = "BF480201" if adm3_pcode_bis == 480201
replace adm3_pcode = "BF480203" if adm3_pcode_bis == 480203
replace adm3_pcode = "BF480204" if adm3_pcode_bis == 480204
replace adm3_pcode = "BF480205" if adm3_pcode_bis == 480205
replace adm3_pcode = "BF480206" if adm3_pcode_bis == 480206
replace adm3_pcode = "BF480207" if adm3_pcode_bis == 480207
replace adm3_pcode = "BF480208" if adm3_pcode_bis == 480208
replace adm3_pcode = "BF480301" if adm3_pcode_bis == 480301
replace adm3_pcode = "BF480302" if adm3_pcode_bis == 480302
replace adm3_pcode = "BF480303" if adm3_pcode_bis == 480303
replace adm3_pcode = "BF480304" if adm3_pcode_bis == 480304
replace adm3_pcode = "BF480305" if adm3_pcode_bis == 480305
replace adm3_pcode = "BF480306" if adm3_pcode_bis == 480306
replace adm3_pcode = "BF480307" if adm3_pcode_bis == 480307
replace adm3_pcode = "BF480308" if adm3_pcode_bis == 480308
replace adm3_pcode = "BF480309" if adm3_pcode_bis == 480309
replace adm3_pcode = "BF490101" if adm3_pcode_bis == 490101
replace adm3_pcode = "BF490102" if adm3_pcode_bis == 490102
replace adm3_pcode = "BF490103" if adm3_pcode_bis == 490103
replace adm3_pcode = "BF490105" if adm3_pcode_bis == 490105
replace adm3_pcode = "BF490107" if adm3_pcode_bis == 490107
replace adm3_pcode = "BF490108" if adm3_pcode_bis == 490108
replace adm3_pcode = "BF490201" if adm3_pcode_bis == 490201
replace adm3_pcode = "BF490202" if adm3_pcode_bis == 490202
replace adm3_pcode = "BF490203" if adm3_pcode_bis == 490203
replace adm3_pcode = "BF490204" if adm3_pcode_bis == 490204
replace adm3_pcode = "BF490206" if adm3_pcode_bis == 490206
replace adm3_pcode = "BF490301" if adm3_pcode_bis == 490301
replace adm3_pcode = "BF490304" if adm3_pcode_bis == 490304
replace adm3_pcode = "BF490305" if adm3_pcode_bis == 490305
replace adm3_pcode = "BF490306" if adm3_pcode_bis == 490306
replace adm3_pcode = "BF490309" if adm3_pcode_bis == 490309
replace adm3_pcode = "BF490310" if adm3_pcode_bis == 490310
replace adm3_pcode = "BF490311" if adm3_pcode_bis == 490311
replace adm3_pcode = "BF500101" if adm3_pcode_bis == 500101
replace adm3_pcode = "BF500103" if adm3_pcode_bis == 500103
replace adm3_pcode = "BF500104" if adm3_pcode_bis == 500104
replace adm3_pcode = "BF500105" if adm3_pcode_bis == 500105
replace adm3_pcode = "BF500106" if adm3_pcode_bis == 500106
replace adm3_pcode = "BF500109" if adm3_pcode_bis == 500109
replace adm3_pcode = "BF500110" if adm3_pcode_bis == 500110
replace adm3_pcode = "BF500112" if adm3_pcode_bis == 500112
replace adm3_pcode = "BF500114" if adm3_pcode_bis == 500114
replace adm3_pcode = "BF500202" if adm3_pcode_bis == 500202
replace adm3_pcode = "BF500203" if adm3_pcode_bis == 500203
replace adm3_pcode = "BF500206" if adm3_pcode_bis == 500206
replace adm3_pcode = "BF500207" if adm3_pcode_bis == 500207
replace adm3_pcode = "BF500208" if adm3_pcode_bis == 500208
replace adm3_pcode = "BF500209" if adm3_pcode_bis == 500209
replace adm3_pcode = "BF500301" if adm3_pcode_bis == 500301
replace adm3_pcode = "BF500302" if adm3_pcode_bis == 500302
replace adm3_pcode = "BF500303" if adm3_pcode_bis == 500303
replace adm3_pcode = "BF500305" if adm3_pcode_bis == 500305
replace adm3_pcode = "BF500306" if adm3_pcode_bis == 500306
replace adm3_pcode = "BF500307" if adm3_pcode_bis == 500307
replace adm3_pcode = "BF500403" if adm3_pcode_bis == 500403
replace adm3_pcode = "BF500405" if adm3_pcode_bis == 500405
replace adm3_pcode = "BF500406" if adm3_pcode_bis == 500406
replace adm3_pcode = "BF510101" if adm3_pcode_bis == 510101
replace adm3_pcode = "BF510103" if adm3_pcode_bis == 510103
replace adm3_pcode = "BF510104" if adm3_pcode_bis == 510104
replace adm3_pcode = "BF510105" if adm3_pcode_bis == 510105
replace adm3_pcode = "BF510106" if adm3_pcode_bis == 510106
replace adm3_pcode = "BF510107" if adm3_pcode_bis == 510107
replace adm3_pcode = "BF510202" if adm3_pcode_bis == 510202
replace adm3_pcode = "BF510203" if adm3_pcode_bis == 510203
replace adm3_pcode = "BF510204" if adm3_pcode_bis == 510204
replace adm3_pcode = "BF510205" if adm3_pcode_bis == 510205
replace adm3_pcode = "BF510301" if adm3_pcode_bis == 510301
replace adm3_pcode = "BF510302" if adm3_pcode_bis == 510302
replace adm3_pcode = "BF510303" if adm3_pcode_bis == 510303
replace adm3_pcode = "BF510304" if adm3_pcode_bis == 510304
replace adm3_pcode = "BF510306" if adm3_pcode_bis == 510306
replace adm3_pcode = "BF510307" if adm3_pcode_bis == 510307
replace adm3_pcode = "BF520101" if adm3_pcode_bis == 520101
replace adm3_pcode = "BF520102" if adm3_pcode_bis == 520102
replace adm3_pcode = "BF520103" if adm3_pcode_bis == 520103
replace adm3_pcode = "BF520104" if adm3_pcode_bis == 520104
replace adm3_pcode = "BF520105" if adm3_pcode_bis == 520105
replace adm3_pcode = "BF520106" if adm3_pcode_bis == 520106
replace adm3_pcode = "BF520201" if adm3_pcode_bis == 520201
replace adm3_pcode = "BF520202" if adm3_pcode_bis == 520202
replace adm3_pcode = "BF520203" if adm3_pcode_bis == 520203
replace adm3_pcode = "BF520206" if adm3_pcode_bis == 520206
replace adm3_pcode = "BF520303" if adm3_pcode_bis == 520303
replace adm3_pcode = "BF520501" if adm3_pcode_bis == 520501
replace adm3_pcode = "BF520502" if adm3_pcode_bis == 520502
replace adm3_pcode = "BF520504" if adm3_pcode_bis == 520504
replace adm3_pcode = "BF520506" if adm3_pcode_bis == 520506
replace adm3_pcode = "BF520507" if adm3_pcode_bis == 520507
replace adm3_pcode = "BF530101" if adm3_pcode_bis == 530101
replace adm3_pcode = "BF530102" if adm3_pcode_bis == 530102
replace adm3_pcode = "BF530104" if adm3_pcode_bis == 530104
replace adm3_pcode = "BF530105" if adm3_pcode_bis == 530105
replace adm3_pcode = "BF530106" if adm3_pcode_bis == 530106
replace adm3_pcode = "BF530107" if adm3_pcode_bis == 530107
replace adm3_pcode = "BF530108" if adm3_pcode_bis == 530108
replace adm3_pcode = "BF530110" if adm3_pcode_bis == 530110
replace adm3_pcode = "BF530111" if adm3_pcode_bis == 530111
replace adm3_pcode = "BF530112" if adm3_pcode_bis == 530112
replace adm3_pcode = "BF530113" if adm3_pcode_bis == 530113
replace adm3_pcode = "BF530201" if adm3_pcode_bis == 530201
replace adm3_pcode = "BF530203" if adm3_pcode_bis == 530203
replace adm3_pcode = "BF530204" if adm3_pcode_bis == 530204
replace adm3_pcode = "BF530206" if adm3_pcode_bis == 530206
replace adm3_pcode = "BF530207" if adm3_pcode_bis == 530207
replace adm3_pcode = "BF530208" if adm3_pcode_bis == 530208
replace adm3_pcode = "BF530209" if adm3_pcode_bis == 530209
replace adm3_pcode = "BF530210" if adm3_pcode_bis == 530210
replace adm3_pcode = "BF530212" if adm3_pcode_bis == 530212
replace adm3_pcode = "BF530301" if adm3_pcode_bis == 530301
replace adm3_pcode = "BF530302" if adm3_pcode_bis == 530302
replace adm3_pcode = "BF530303" if adm3_pcode_bis == 530303
replace adm3_pcode = "BF530304" if adm3_pcode_bis == 530304
replace adm3_pcode = "BF530305" if adm3_pcode_bis == 530305
replace adm3_pcode = "BF530306" if adm3_pcode_bis == 530306
replace adm3_pcode = "BF530307" if adm3_pcode_bis == 530307
replace adm3_pcode = "BF540102" if adm3_pcode_bis == 540102
replace adm3_pcode = "BF540104" if adm3_pcode_bis == 540104
replace adm3_pcode = "BF540201" if adm3_pcode_bis == 540201
replace adm3_pcode = "BF540204" if adm3_pcode_bis == 540204
replace adm3_pcode = "BF540206" if adm3_pcode_bis == 540206
replace adm3_pcode = "BF540208" if adm3_pcode_bis == 540208
replace adm3_pcode = "BF540210" if adm3_pcode_bis == 540210
replace adm3_pcode = "BF540302" if adm3_pcode_bis == 540302
replace adm3_pcode = "BF540303" if adm3_pcode_bis == 540303
replace adm3_pcode = "BF540304" if adm3_pcode_bis == 540304
replace adm3_pcode = "BF540305" if adm3_pcode_bis == 540305
replace adm3_pcode = "BF540307" if adm3_pcode_bis == 540307
replace adm3_pcode = "BF540308" if adm3_pcode_bis == 540308
replace adm3_pcode = "BF540309" if adm3_pcode_bis == 540309
replace adm3_pcode = "BF540310" if adm3_pcode_bis == 540310
replace adm3_pcode = "BF540402" if adm3_pcode_bis == 540402
replace adm3_pcode = "BF540403" if adm3_pcode_bis == 540403
replace adm3_pcode = "BF550101" if adm3_pcode_bis == 550101
replace adm3_pcode = "BF550103" if adm3_pcode_bis == 550103
replace adm3_pcode = "BF550105" if adm3_pcode_bis == 550105
replace adm3_pcode = "BF550106" if adm3_pcode_bis == 550106
replace adm3_pcode = "BF550107" if adm3_pcode_bis == 550107
replace adm3_pcode = "BF550108" if adm3_pcode_bis == 550108
replace adm3_pcode = "BF550201" if adm3_pcode_bis == 550201
replace adm3_pcode = "BF550203" if adm3_pcode_bis == 550203
replace adm3_pcode = "BF550204" if adm3_pcode_bis == 550204
replace adm3_pcode = "BF550205" if adm3_pcode_bis == 550205
replace adm3_pcode = "BF550302" if adm3_pcode_bis == 550302
replace adm3_pcode = "BF550304" if adm3_pcode_bis == 550304
replace adm3_pcode = "BF550305" if adm3_pcode_bis == 550305
replace adm3_pcode = "BF550306" if adm3_pcode_bis == 550306
replace adm3_pcode = "BF550307" if adm3_pcode_bis == 550307
replace adm3_pcode = "BF560102" if adm3_pcode_bis == 560102
replace adm3_pcode = "BF560104" if adm3_pcode_bis == 560104
replace adm3_pcode = "BF560201" if adm3_pcode_bis == 560201
replace adm3_pcode = "BF560202" if adm3_pcode_bis == 560202
replace adm3_pcode = "BF560203" if adm3_pcode_bis == 560203
replace adm3_pcode = "BF560205" if adm3_pcode_bis == 560205
replace adm3_pcode = "BF560206" if adm3_pcode_bis == 560206
replace adm3_pcode = "BF560301" if adm3_pcode_bis == 560301
replace adm3_pcode = "BF560304" if adm3_pcode_bis == 560304
replace adm3_pcode = "BF560308" if adm3_pcode_bis == 560308
replace adm3_pcode = "BF560403" if adm3_pcode_bis == 560403
replace adm3_pcode = "BF560406" if adm3_pcode_bis == 560406
replace adm3_pcode = "BF570102" if adm3_pcode_bis == 570102
replace adm3_pcode = "BF570103" if adm3_pcode_bis == 570103
replace adm3_pcode = "BF570104" if adm3_pcode_bis == 570104
replace adm3_pcode = "BF570201" if adm3_pcode_bis == 570201
replace adm3_pcode = "BF570202" if adm3_pcode_bis == 570202
replace adm3_pcode = "BF570203" if adm3_pcode_bis == 570203
replace adm3_pcode = "BF570204" if adm3_pcode_bis == 570204
replace adm3_pcode = "BF570205" if adm3_pcode_bis == 570205
replace adm3_pcode = "BF570207" if adm3_pcode_bis == 570207
replace adm3_pcode = "BF570208" if adm3_pcode_bis == 570208
replace adm3_pcode = "BF570301" if adm3_pcode_bis == 570301
replace adm3_pcode = "BF570304" if adm3_pcode_bis == 570304
replace adm3_pcode = "BF570305" if adm3_pcode_bis == 570305
replace adm3_pcode = "BF570401" if adm3_pcode_bis == 570401
replace adm3_pcode = "BF570402" if adm3_pcode_bis == 570402
replace adm3_pcode = "BF570404" if adm3_pcode_bis == 570404
replace adm3_pcode = "BF570405" if adm3_pcode_bis == 570405
replace adm3_pcode = "BF570406" if adm3_pcode_bis == 570406
replace adm3_pcode = "BF570407" if adm3_pcode_bis == 570407
replace adm3_pcode = "BF570409" if adm3_pcode_bis == 570409
replace adm3_pcode = "BF570410" if adm3_pcode_bis == 570410

	
save "$data\direct_survey_ehcvm_bfa_2021_commune.dta", replace


