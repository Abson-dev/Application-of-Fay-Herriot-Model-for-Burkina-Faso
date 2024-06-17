

*===============================================================================
//Specify team paths 
*===============================================================================

global main          "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso"
global data       	"$main\00.Data"



*===============================================================================
//Geo data admin level 1 
*===============================================================================


import delimited "$data\input\geo_indices_admin_3.csv",clear //geo_indices_admin_1.csv


unab variable : _all 
 	foreach x in `variable' {
 		rename `x' geo_`x'
 	}
rename geo_adm3_pcode adm3_pcode 


merge 1:1 adm3_pcode using "$data\direct_survey_ehcvm_bfa_2021_commune.dta" //direct_survey_ehcvm_bfa_2021_region
drop _merge

save "$data\direct_survey_ehcvm_bfa_2021_commune.dta", replace //direct_survey_ehcvm_bfa_2021_region

//ACLED data
import delimited "$data\input\events_diffusion_Count_admin3_2021.csv",clear //events_diffusion_Count_admin1_2021

/*
unab variable : _all
 	foreach x in `variable' {
 		rename `x' acled_`x'
 	}
rename acled_adm1_pcode adm1_pcode
*/
merge 1:1 adm3_pcode using "$data\direct_survey_ehcvm_bfa_2021_commune.dta" //direct_survey_ehcvm_bfa_2021_region
drop _merge

save "$data\direct_survey_ehcvm_bfa_2021_commune.dta", replace //direct_survey_ehcvm_bfa_2021_region