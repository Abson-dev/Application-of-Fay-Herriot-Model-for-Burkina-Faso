

*===============================================================================
//Specify team paths 
*===============================================================================

global main          "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso"
global data       	"$main\00.Data"



*===============================================================================
//Geo data admin level 1 
*===============================================================================


import delimited "$data\input\geo_indices_admin_1.csv",clear 


unab variable : _all 
 	foreach x in `variable' {
 		rename `x' geo_`x'
 	}
rename geo_adm1_pcode adm1_pcode


merge 1:1 adm1_pcode using "$data\direct_survey_ehcvm_bfa_2021_region.dta" //direct_survey_ehcvm_bfa_2021_province
drop _merge

save "$data\direct_survey_ehcvm_bfa_2021_region.dta", replace

//ACLED data
import delimited "$data\input\conflict_diffusion2022_admin_1.csv",clear

/*
unab variable : _all
 	foreach x in `variable' {
 		rename `x' acled_`x'
 	}
rename acled_adm1_pcode adm1_pcode
*/
merge 1:1 adm1_pcode using "$data\direct_survey_ehcvm_bfa_2021_region.dta" //direct_survey_ehcvm_bfa_2021_province
drop _merge

save "$data\direct_survey_ehcvm_bfa_2021_region.dta", replace