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


gen popw = WTA_S_HHSIZE*hhsize

gen fgt0se = fgt0

gen Sample_size = 1

collapse  (sum)  Sample_size popw WTA_S_HHSIZE (mean) fgt0 (semean) fgt0se [aw = popw], by(region province)
gen dir_fgt0_var = fgt0se ^2

	
	
	
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
replace adm2_pcode = "BF5204" if province == 30
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


order adm1_pcode region adm2_pcode province
save "$data\direct_survey_ehcvm_bfa_2021_admin2.dta", replace