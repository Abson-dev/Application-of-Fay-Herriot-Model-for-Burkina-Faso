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
gen fgt0 = (welfare < pl_abs) if !missing(welfare) // pl_abs * tempo/spat
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

collapse  (sum)  Sample_size popw WTA_S_HHSIZE (mean) fgt0 (semean) fgt0se [aw = popw], by(region)
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

	order adm1_pcode region 
	save "$data\direct_survey_ehcvm_bfa_2021_admin1.dta", replace
