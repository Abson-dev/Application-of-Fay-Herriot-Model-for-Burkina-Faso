

*===============================================================================
//Specify team paths 
*===============================================================================

global main          "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso"
global data       	"$main\00.Data"


/*
*===============================================================================
//Geo data admin level 1 
*===============================================================================


import delimited "$data\input\geo_indices_admin_1.csv",clear //geo_indices_admin_1.csv


unab variable : _all 
 	foreach x in `variable' {
 		rename `x' geo_`x'
 	}
rename geo_adm1_pcode adm1_pcode 


merge 1:1 adm1_pcode using "$data\direct_survey_ehcvm_bfa_2021_admin1.dta" //direct_survey_ehcvm_bfa_2021_admin1
drop _merge

save "$data\direct_survey_ehcvm_bfa_2021_admin1.dta", replace //direct_survey_ehcvm_bfa_2021_admin1

//ACLED data
import delimited "$data\input\events_diffusion_Count_admin1_2021.csv",clear //events_diffusion_Count_admin1_2021

/*
unab variable : _all
 	foreach x in `variable' {
 		rename `x' acled_`x'
 	}
rename acled_adm1_pcode adm1_pcode
*/
merge 1:1 adm1_pcode using "$data\direct_survey_ehcvm_bfa_2021_admin1.dta" //direct_survey_ehcvm_bfa_2021_admin1
drop _merge

order adm1_pcode region

save "$data\direct_survey_ehcvm_bfa_2021_admin1.dta", replace //direct_survey_ehcvm_bfa_2021_admin1



*===============================================================================
//Geo data admin level 2
*===============================================================================


import delimited "$data\input\geo_indices_admin_2.csv",clear //geo_indices_admin_1.csv


unab variable : _all 
 	foreach x in `variable' {
 		rename `x' geo_`x'
 	}
rename geo_adm2_pcode adm2_pcode 


merge 1:1 adm2_pcode using "$data\direct_survey_ehcvm_bfa_2021_admin2.dta" //direct_survey_ehcvm_bfa_2021_admin1
drop _merge

save "$data\direct_survey_ehcvm_bfa_2021_admin2.dta", replace //direct_survey_ehcvm_bfa_2021_admin1

//ACLED data
import delimited "$data\input\events_diffusion_Count_admin2_2021.csv",clear //events_diffusion_Count_admin1_2021

/*
unab variable : _all
 	foreach x in `variable' {
 		rename `x' acled_`x'
 	}
rename acled_adm1_pcode adm1_pcode
*/
merge 1:1 adm2_pcode using "$data\direct_survey_ehcvm_bfa_2021_admin2.dta" //direct_survey_ehcvm_bfa_2021_admin1
drop _merge

save "$data\direct_survey_ehcvm_bfa_2021_admin2.dta", replace //direct_survey_ehcvm_bfa_2021_admin1
*/

*===============================================================================
//Geo data admin level 3
*===============================================================================


import delimited "$data\Geospatial Data\geo_indices_Median_admin_3.csv",clear //keep geo_indices_Median_admin_3.csv

drop v10
unab variable : _all 
 	foreach x in `variable' {
 		rename `x' geo_`x'
 	}
rename geo_adm3_pcode adm3_pcode 


merge 1:1 adm3_pcode using "$data\direct_survey_ehcvm_bfa_2021_admin3.dta" 
drop adm0_pcode
gen adm0_pcode = substr(adm3_pcode, 1, 2)
keep if adm0_pcode == "BF"

order adm0_pcode adm1_pcode adm2_pcode adm3_pcode
//keep if _merge==3
drop _merge

pwcorr fgt0 geo_*

stepwise, pr(.10):reg fgt0 geo_*
save "$data\direct_survey_ehcvm_bfa_2021_geo_indices_Median_admin3.dta", replace 

//ACLED data
import delimited "$data\Geospatial Data\ACLED_Conflict_diffusion_Indicator_admin_3.csv",clear

rename conflict_diffusion_indicator cdi
save "$data\cdi.dta", replace //direct_survey_ehcvm_bfa_2021_admin1
import delimited "$data\Geospatial Data\ACLED_Exposed_Indicator_admin_3.csv",clear

rename inhabitants_100m Worlpop_population
rename inhabitants_inside5km_events Worlpop_population_exposed
rename exposed_to_conflict_indicator ei
merge 1:1 adm3_pcode using "$data\cdi.dta"
drop _merge
unab variable : _all 
 	foreach x in `variable' {
 		rename `x' acled_`x'
 	}
rename acled_adm3_pcode adm3_pcode 
rename acled_Worlpop_population  Worlpop_population
rename acled_Worlpop_population_exposed Worlpop_population_exposed

merge 1:1 adm3_pcode using "$data\direct_survey_ehcvm_bfa_2021_geo_indices_Median_admin3.dta" 
keep if _merge==3
drop _merge
order adm0_pcode adm1_pcode adm2_pcode adm3_pcode
save "$data\direct_survey_ehcvm_bfa_2021_admin3.dta", replace 


save "$data\direct_survey_ehcvm_bfa_2021_geo_indices_Median_Acled_admin3.dta", replace 
