
*===============================================================================
//Specify team paths 
*===============================================================================

global main          "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso"
global data       	"$main\00.Data"



* Import "true" poverty rates


import excel "$data\input\true_poverty.xlsx", sheet("province") firstrow clear
keep Incidence adm2_pcode
rename Incidence true

save true, replace

* Import poverty rates from one sample
use "$data\direct_and_fh_provinces.dta", clear 

//Global with eligible variables

keep adm2_pcode dir_fgt0 hage hgender1   hreligion1   hmstat1 hbranch1 hcsp1 mstat1 nation2 toit1 eauboi_ss1 eva_toi1 cuisin1 conflict_diffusion_indicator ///
	geo_mndwi geo_brba geo_nbai  geo_vari geo_savi geo_osavi  geo_evi geo_ndvi geo_sr geo_arvi geo_ui


drop if adm2_pcode == "."
drop if nation2 == .
rename dir_fgt0 direct
sort adm2_pcode

order adm2_pcode direct


* Merge poverty rates and covariates

merge 1:1 adm2_pcode using true
drop _merge

order adm2_pcode direct true
* Miscellaneous cleaning and save
export delimited using "$data\data_admin2", replace
clear all	
