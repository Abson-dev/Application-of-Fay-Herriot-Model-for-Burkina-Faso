**************************************
*This dofile prepares data from BFA EHCVM 2021 for
* small area estimation
*****************************************
clear all

set more off

version 14





*===============================================================================
//Specify team paths 
*===============================================================================
//global main       	"C:\Users\\`c(username)'\GitHub\wb_sae_training"
global main          "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso"
global data       	"$main\00.Data"



*===============================================================================
//ehcvm_welfare_2b_bfa2021.dta 
*===============================================================================
use "$data\input\BFA_2021_EHCVM-P_v02_M_Stata\ehcvm_welfare_2b_bfa2021.dta",clear



tab  hnation,gen(hnation) 
//hnation2 for Burkina 
tabulate  hethnie,gen(hethnie)
tabulate  hreligion,gen(hreligion)
tabulate  heduc,gen(heduc)
tabulate  hcsp,gen(hcsp)



*===============================================================================
//ehcvm_menage_bfa2021.dta 
*===============================================================================
use "$data\input\BFA_2021_EHCVM-P_v02_M_Stata\ehcvm_menage_bfa2021.dta",clear

tabulate  ordin,gen(ordin)
tabulate  logem,gen(logem)
tabulate  mur,gen(mur)
tabulate  sol,gen(sol)
tabulate  toit,gen(toit)
tabulate  logem,gen(logem)
tabulate  elec_ac,gen(elec_ac)
tabulate  elec_ur,gen(elec_ur)
tabulate  elec_ua,gen(elec_ua)
tabulate  eauboi_ss,gen(eauboi_ss)
tabulate  eauboi_sp,gen(eauboi_sp)
tabulate  toilet,gen(toilet)
tabulate  ordure,gen(ordure)
tabulate  eva_toi,gen(eva_toi)
tabulate  eva_eau,gen(eva_eau)
tabulate  tv,gen(tv)
tabulate  fer,gen(fer)
tabulate  frigo,gen(frigo)
tabulate  cuisin,gen(cuisin)
tabulate  decod,gen(decod)
tabulate  car,gen(car)

