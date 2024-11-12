/*
this dofile creates maps at the admin level 1, admin level 2, and admin level 3 for the direct, FH and XGBoost estimates. 
*/

* ------------------------------------------------------------------------------
*    Packages
* ------------------------------------------------------------------------------
 /*
ssc install spmap
ssc install shp2dta
   
   
 
ssc install geoplot, replace
ssc install moremata, replace

ssc install palettes, replace
ssc install colrspace, replace
*/  

clear all

set more off

version 14


graph set window fontface "Arial Narrow"


*===============================================================================
//Specify team paths 
*===============================================================================

global main          "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso"
global data       	"$main\00.Data"
global figs        "$main\05.Graphics"

		
*===============================================================================
//Direct and XGBoost estimates  at the administrative level 3
*===============================================================================




 
 /*
  //compass(pos(2)) sbar(length(.002) units(km)) ///
 geoplot ///
 (area admin2 fgt0, levels(10) color(viridis, reverse) label("@lb - @ub (N=@n)")) ///
 , legend(pos(2) outside) 
 
*/


 

foreach format in shp dbf prj shx {
        copy "$data\input\bfa_admbnda_igb_20200323_em_v2_shp\bfa_admbnda_adm3_igb_20200323_em.`format'" "bfa_admbnda_adm3_igb_20200323_em.`format'", replace
    }

    *Shapefiles 
	 shp2dta using "$main\00.Data_preparation\bfa_admbnda_adm3_igb_20200323_em.shp", ///
	 database("bfa_adm3") ///
	 coord("bfa_adm3_coord") 


	 use  "$main\00.Data_preparation\bfa_adm3.dta", clear
	 rename ADM3_PCODE adm3_pcode
	 

	 
	 merge 1:1 adm3_pcode using "$data\FH_sae_poverty.dta" 

	 save "$main\00.Data_preparation\bfa_shp3.dta", replace


* ------------------------------------------------------------------------------
*     Map 1
* ------------------------------------------------------------------------------
use "$main\00.Data_preparation\bfa_shp3.dta",replace
    spmap fgt0 using bfa_adm3_coord ///
        , ///
        id(_ID) ///
        fcolor(Reds) osize(.1) ocolor(black) ///
        clmethod(custom)  clbreaks(0 .2 .40 .6 .8 1)  ///
        legend(position(4) ///
               region(lcolor(black)) ///
               label(1 "No data") ///
               label(2 "0% to 20%") ///
               label(3 "20% to 40%") ///
               label(4 "40% to 60%") ///
               label(5 "60% to 80%") /// 
               label(6 "80% to 100%")) ///
        legend(region(color(white))) ///
        title("Estimated poverty rate in BFA communes") ///
        subtitle("(Direct estimates)") ///
        note("Source: EHCVM 2021 Survey")
graph export "$figs\direct_communes.png", as(png) replace
* ------------------------------------------------------------------------------
*     Map 2
* ------------------------------------------------------------------------------		

geoframe create admin3 bfa_shp3.dta, replace shpfile(bfa_adm3_coord)

frame change admin3

format  fgt0 %6.2f 
 
geoplot ///
 (area admin3 fgt0, levels(10) color(viridis, reverse)) ///
 , legend(pos(2) outside) ///
 title("Estimated poverty rate in BFA communes", size(6) span) ///
 subtitle("(Direct estimates)") ///
 note("Source: EHCVM 2021 Survey", size(2))
 graph export "$figs\direct_communes2.png", as(png) replace
	 

*===============================================================================
//FH estimates  at the administrative level 3
*=============================================================================== 

* ------------------------------------------------------------------------------
*     Map 1
* ------------------------------------------------------------------------------
 
use  "$main\00.Data_preparation\bfa_adm3.dta", clear
rename ADM3_PCODE adm3_pcode

merge 1:1 adm3_pcode using "$data\FH_sae_poverty.dta"
drop _merge
spmap fh_fgt0 using bfa_adm3_coord ///
        , ///
        id(_ID) ///
        fcolor(Reds) osize(.1) ocolor(black) ///
        clmethod(custom)  clbreaks(0 .2 .40 .6 .8 1)  ///
        legend(position(4) ///
               region(lcolor(black)) ///
               label(1 "No data") ///
               label(2 "0% to 20%") ///
               label(3 "20% to 40%") ///
               label(4 "40% to 60%") ///
               label(5 "60% to 80%") /// 
               label(6 "80% to 100%")) ///
        legend(region(color(white))) ///
        title("Estimated poverty rate in BFA communes") ///
        subtitle("(FH estimates)") ///
        note("Source: EHCVM 2021 Survey")
		
graph export "$figs\fh_commune.png", as(png) replace		

* ------------------------------------------------------------------------------
*     Map 2
* ------------------------------------------------------------------------------		

geoframe create admin3 bfa_shp3.dta, replace shpfile(bfa_adm3_coord)

frame change admin3

format  fgt0 %6.2f 
 
geoplot ///
 (area admin3 fgt0, levels(10) color(viridis, reverse)) ///
 , legend(pos(2) outside) ///
 title("Estimated poverty rate in BFA communes", size(6) span) ///
 subtitle("(Direct estimates)") ///
 note("Source: EHCVM 2021 Survey", size(2))
 graph export "$figs\direct_communes2.png", as(png) replace
