/*
this dofile creates maps at the admin level 1, admin level 2, and admin level 3 for the direct, FH and XGBoost estimates. 
*/



clear all

set more off

version 14





*===============================================================================
//Specify team paths 
*===============================================================================

global main          "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso"
global data       	"$main\00.Data"
global figs        "$main\05.Graphics"
//use "$data\direct_survey_ehcvm_bfa_2021_region.dta",clear

*===============================================================================
//Direct and XGBoost estimates  at the administrative level 1 
*===============================================================================


      
* Maps displaying levels of a variable

* ------------------------------------------------------------------------------
*    Packages
* ------------------------------------------------------------------------------

    ssc install spmap
    ssc install shp2dta

* ------------------------------------------------------------------------------
*     Data
* ------------------------------------------------------------------------------

/*
foreach format in shp dbf prj shx {
        copy "$data\input\bfa_admbnda_igb_20200323_em_v2_shp\bfa_admbnda_adm1_igb_20200323_em.`format'" "bfa_admbnda_adm1_igb_20200323_em.`format'"
    }

    *Shapefiles 
	 shp2dta using "$main\00.Data_preparation\bfa_admbnda_adm1_igb_20200323_em.shp", ///
	 database("bfa__adm1") ///
	 coord("bfa_adm1_coord") 


	 use  "$main\00.Data_preparation\bfa__adm1.dta", clear
	 rename ADM1_PCODE adm1_pcode
	 
	 


	merge 1:1 adm1_pcode using "$data\direct_survey_ehcvm_bfa_2021_region.dta" 

	save "$main\00.Data_preparation\bfa_shp1.dta"
*/
* ------------------------------------------------------------------------------
*     Map
* ------------------------------------------------------------------------------
use "$main\00.Data_preparation\bfa_shp1.dta",replace
    spmap fgt0 using bfa_adm1_coord ///
        , ///
        id(_ID) ///
        fcolor(Reds) osize(.1) ocolor(black) ///
        clmethod(custom)  clbreaks(0 .2 .40 .6 .8 1)  ///
        legend(position(8) ///
               region(lcolor(black)) ///
               label(1 "No data") ///
               label(2 "0% to 20%") ///
               label(3 "20% to 40%") ///
               label(4 "40% to 60%") ///
               label(5 "60% to 80%") /// 
               label(6 "80% to 100%")) ///
        legend(region(color(white))) ///
        plotregion(icolor(bluishgray)) ///
        title("Estimated poverty rate in BFA regions") ///
        subtitle("(Direct estimates)") ///
        note("Source: EHCVM 2021 Survey")
        graph export "$figs\direct_region.png", as(png) replace
//bimap fgt0 N_hhsize using bfa_shp1, cut(pctile) palette(pinkgreen) 
*===============================================================================
//Direct and XGBoost estimates  at the administrative level 2 
*===============================================================================

/*
	foreach format in shp dbf prj shx {
			copy "$data\input\bfa_admbnda_igb_20200323_em_v2_shp\bfa_admbnda_adm2_igb_20200323_em.`format'" "bfa_admbnda_adm2_igb_20200323_em.`format'"
		}

		*Shapefiles 
	 shp2dta using "$main\00.Data_preparation\bfa_admbnda_adm2_igb_20200323_em.shp", ///
	 database("bfa_adm2") ///
	 coord("bfa_adm2_coord") 


	 use  "$main\00.Data_preparation\bfa_adm2.dta", clear
	 rename ADM2_PCODE adm2_pcode
	 
	 


	merge 1:1 adm2_pcode using "$data\direct_survey_ehcvm_bfa_2021_province.dta" 

	save "$main\00.Data_preparation\bfa_shp2.dta"

*/
* ------------------------------------------------------------------------------
*     Map
* ------------------------------------------------------------------------------
use "$main\00.Data_preparation\bfa_shp2.dta",replace
    spmap fgt0 using bfa_adm2_coord ///
        , ///
        id(_ID) ///
        fcolor(Reds) osize(.1) ocolor(black) ///
        clmethod(custom)  clbreaks(0 .2 .40 .6 .8 1)  ///
        legend(position(8) ///
               region(lcolor(black)) ///
               label(1 "No data") ///
               label(2 "0% to 20%") ///
               label(3 "20% to 40%") ///
               label(4 "40% to 60%") ///
               label(5 "60% to 80%") /// 
               label(6 "80% to 100%")) ///
        legend(region(color(white))) ///
        plotregion(icolor(bluishgray)) ///
        title("Estimated poverty rate in BFA provinces") ///
        subtitle("(Direct estimates)") ///
        note("Source: EHCVM 2021 Survey")
        graph export "$figs\direct_province.png", as(png) replace


*===============================================================================
//Direct and XGBoost estimates  at the administrative level 3
*===============================================================================



//use "$data\direct_survey_ehcvm_bfa_2021_commune.dta",clear