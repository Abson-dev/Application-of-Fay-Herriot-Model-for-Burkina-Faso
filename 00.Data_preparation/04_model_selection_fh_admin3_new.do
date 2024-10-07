set more off
clear all


set matsize 8000
set seed 648743

*===============================================================================
//Specify team paths 
*===============================================================================
global main          "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso"
global data       	"$main\00.Data"
global figs        "$main\05.Graphics"


mata
	//Mata function for selection
	function mysel2(_bb, _se, _pval){
		thevars = tokens(st_local("_myhhvars"))
		zvals   = (_bb':/_se)[1..(rows(_se)-1)]
		zvals   = 2:*normal(-abs(zvals))
		if (colmax(zvals)>_pval){
			keepvar = thevars[selectindex(colmax(zvals):>zvals)]
			return(keepvar)	
		}	
		else{
			keepvar = "it's done"
			return(keepvar)
		}
	}

end


use "$data\commune_survey_ehcvm_bfa_2021.dta", clear

drop 

local vars hage hgender1 age hmstat1 hmstat2 hmstat3  hreligion1 hreligion2   hnation2 hethnie1 hethnie2  halfa1  heduc1 heduc2 hactiv12m1  hbranch1  hbranch3 hbranch4  hcsp1 hcsp2 sexe1   mstat1 mstat2  religion1 religion2 nation2   telpor1  internet1 activ12m1   logem1  mur1  toit1  sol1  eauboi_ss1    elec_ac1  elec_ur1  eva_toi1   tv1  fer1  frigo1  cuisin1  ordin1  decod1  car1


//Normalize
foreach x of local vars{
	cap sum `x'
	cap replace `x' = (`x' - r(mean))/r(sd)
}



gen D = region*100
replace D = D+district

drop district 
rename D district

merge 1:1 adm3_pcode using "$data\direct_survey_ehcvm_bfa_2021_geo_indices_Median_Acled_admin3.dta"
tab region, gen(thereg)
unab hhvars: `vars'


*===============================================================================
//Create smoothed variance function
*===============================================================================
gen log_s2 = log(dir_fgt0_var)
gen logN = log(N)
gen logN2 = logN^2
gen logpop  = log(pop)
gen logpop2 = logpop^2
gen accra = region==3
//reg log_s2 logpop logpop2 i.accra#c.logN, r
//reg log_s2 logpop logpop2 i.accra##c.logN, r
gen share = log(N_hhsize/pop)
reg log_s2 share, r
local phi2 = e(rmse)^2
cap drop xb_fh
predict xb_fh, xb
predict residual,res
sum xb_fh if res!=.,d
gen exp_xb_fh = exp(xb_fh)
sum dir_fgt0_var
local sumvar = r(sum)
sum exp_xb_fh
local sump = r(sum)

//Below comes from: https://presidencia.gva.es/documents/166658342/168130165/Ejemplar+45-01.pdf/fb04aeb3-9ea6-441f-a15c-bc65e857d689?t=1557824876209#page=107
gen smoothed_var = exp_xb_fh*(`sumvar'/`sump') 

//Modified to only replace for the locations with 0 variance
replace dir_fgt0_var = smoothed_var if ((num_ea>1 & !missing(num_ea)) | (num_ea==1 & zero!=0 & zero!=1)) & missing(dir_fgt0_var)
replace dir_fgt0 = zero if !missing(dir_fgt0_var)

fhsae dir_fgt0 `hhvars', revar(dir_fgt0_var) method(fh)


//Removal of non-significant variables
	//Removal of non-significant variables
	local hhvars : list clean hhvars
	dis as error "Sim : `sim' first removal"
	//Removal of non-significant variables
	forval z= 0.8(-0.05)0.01{
		local regreso 
		while ("`regreso'"!="it's done"){
			fhsae dir_fgt0 `hhvars', revar(dir_fgt0_var) method(fh) 
			mata: bb=st_matrix("e(b)")
			mata: se=sqrt(diagonal(st_matrix("e(V)")))
			local _myhhvars : colnames(e(b))
			mata: st_local("regreso", invtokens(mysel2(bb, se, `z')))	
			if ("`regreso'"!="it's done") local hhvars `regreso'
		}		
	}
	
	//Global with non-significant variables removed
	global postsign `hhvars'
	
	//Final model without non-significant variables no funciona
	fhsae dir_fgt0 ${postsign}, revar(dir_fgt0_var) method(fh)
	
	//Check VIF
	reg dir_fgt0 $postsign, r
	gen touse = e(sample)
	gen weight = 1
	mata: ds = _f_stepvif("$postsign","weight",5,"touse") 
	
	//ver abajo
	global postvif `vifvar'
	
	local hhvars $postvif
	
	//One final removal of non-significant covariates
dis as error "Sim : `sim' final removal"
	//One final removal of non-significant covariates
	forval z= 0.8(-0.05)0.0001{
		local regreso 
		while ("`regreso'"!="it's done"){
			fhsae dir_fgt0 `hhvars', revar(dir_fgt0_var) method(reml) precision(1e-10)
			mata: bb=st_matrix("e(b)")
			mata: se=sqrt(diagonal(st_matrix("e(V)")))
			local _myhhvars : colnames(e(b))
			mata: st_local("regreso", invtokens(mysel2(bb, se, `z')))	
			if ("`regreso'"!="it's done") local hhvars `regreso'
		}	
	}	
	
	
	global last `hhvars'
	
	fhsae dir_fgt0 `hhvars', revar(dir_fgt0_var) method(reml) precision(1e-10)
	local remove head_religion3
	local hhvars: list hhvars - remove
	global last `hhvars'
	
	fhsae dir_fgt0 workpop_primary $last, revar(dir_fgt0_var) method(chandra)
	fhsae dir_fgt0 workpop_primary $last, revar(dir_fgt0_var) method(fh)
	fhsae dir_fgt0 workpop_primary $last, revar(dir_fgt0_var) method(reml)
//*********************************************************************************************//

	//Obtain SAE-FH-estimates	
	fhsae dir_fgt0 workpop_primary $last, revar(dir_fgt0_var) method(reml) fh(fh_fgt0) ///
	fhse(fh_fgt0_se) fhcv(fh_fgt0_cv) gamma(fh_fgt0_gamma) out noneg precision(1e-13)

	//Check normal errors
	predict xb
	gen u_d = fh_fgt0 - xb
		lab var u_d "FH area effects"
	
	histogram u_d, normal graphregion(color(white))
	//graph export "$figs\Fig1_left.png", as(png) replace
	qnorm u_d, graphregion(color(white))
	
	gen e_d = dir_fgt0 - fh_fgt0
		lab var e_d "FH errors"
	
	histogram e_d, normal graphregion(color(white))
	///graph export "$figs\SAE Ghana 2017\3. Graphics\Fig1_right.png", as(png) replace
	qnorm e_d, graphregion(color(white))

keep region district fh_fgt0 fh_fgt0_se
save "$data\FH_sae_poverty.dta", replace