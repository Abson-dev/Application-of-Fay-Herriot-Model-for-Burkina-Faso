global main          "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso"
global data       	"$main\00.Data"





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

//gen pl_abs2 = pl_abs
//*def_temp*def_spa
gen fgt0 = (welfare < pl_abs) if !missing(welfare)

//tab fgt0 [aw = WTA_S_HHSIZE*hhsize]

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

collapse  (sum)  Sample_size popw WTA_S_HHSIZE (mean) fgt0 (semean) fgt0se [aw = popw], by(adm3_pcode) //region province 

gen dir_fgt0_var = fgt0se ^2

gen adm0_pcode = substr(adm3_pcode, 1, 2)
gen adm1_pcode = substr(adm3_pcode, 1, 4) 
gen adm2_pcode = substr(adm3_pcode, 1, 6) 

order adm1_pcode  adm2_pcode adm3_pcode

save "$data\direct_survey_ehcvm_bfa_2021_admin3.dta", replace