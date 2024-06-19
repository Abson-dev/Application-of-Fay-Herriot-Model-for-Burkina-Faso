
*===============================================================================
//Specify team paths 
*===============================================================================

global main          "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso"
global data       	"$main\00.Data"


use "$data\direct_and_fh_provinces.dta", clear 

//Global with eligible variables

keep adm2_pcode dir_fgt0 fh_fgt0 hage hgender1   hreligion1   hmstat1 hbranch1 hcsp1 mstat1 nation2 toit1 eauboi_ss1 eva_toi1 cuisin1 conflict_diffusion_indicator ///
	geo_mndwi geo_brba geo_nbai  geo_vari geo_savi geo_osavi  geo_evi geo_ndvi geo_sr geo_arvi geo_ui


drop if adm2_pcode == "."
drop if nation2 == .
rename dir_fgt0 direct
rename fh_fgt0 true
sort adm2_pcode

order adm2_pcode direct
* Miscellaneous cleaning and save
export delimited using "$data\data_admin2", replace
clear all	
/*
* Set directory
global path  "/Users/hendersonhl/Documents/Articles/Poverty-Mapping/Data/"

* Import "true" poverty rates
import delimited "$path/true_mun.csv", clear
keep mimun poor
rename poor true
tempfile true
save `true'

* Import poverty rates from one sample
import delimited "$path/svydata_mun.csv", clear
keep if sim_sample==1
keep mimun poor
rename poor direct
tempfile direct
save `direct'

* Merge poverty rates and covariates
use "$path/xmatrix_mun_ntl.dta", clear
drop hhid estado municipio
rename MiMun mimun 
merge 1:1 mimun using `true'
drop _merge
merge 1:1 mimun using `direct'
drop _merge
rename mimun municipality
order municipality direct true
drop census_automobile

* Miscellaneous cleaning and save
drop gis*
rename census_* *
export delimited using "/Users/hendersonhl/Desktop/Summer University/Application/data", replace
clear all
*/