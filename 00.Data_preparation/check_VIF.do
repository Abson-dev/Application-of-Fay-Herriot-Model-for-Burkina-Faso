	
	//local threshold = 10 
	//local keepvars "" 
	// Run initial regression 
	//regress dir_fgt0 $postsign 
	// Calculate VIF for each variable 
/*	local postsign geo_mndwi_min	geo_brba_min	geo_arvi_min2	geo_vari_min	geo_savi_min	geo_osavi_min	geo_ui_min2	acled_sh_inside5km_riots2	acled_sh_inside5km_protests	geo_sr_min	malaria_pf_parasite_rate_median2	health_access_w2	malaria_pf_parasite_rate_min2	acled_cdi	geo_ndvi_median2	acled_ei2	night_offset_max2	geo_evi_max2	geo_ndvi_min2	geo_vari_min2	geo_ui_median2	health_access_w	geo_arvi_max	night_offset_max	geo_mndwi_median	geo_brba_median	acled_sh_inside5km_erv	acled_cdi2	geo_arvi_max2	geo_osavi_median	geo_osavi_min2	night_scale_min	geo_sr_median	geo_savi_min2	geo_sr_min2	geo_mndwi_min2	geo_brba_min2

	local remove  ""
	foreach var of varlist $postsign {
		local remove `var'
		local $postsign : list $postsign  - remove
		regress `var' $postsign 
		vif, uncentered     
		if r(vif) <= `threshold' { 
        	local keepvars `keepvars' `var'  
			} 
			} 
// Drop variables with high VIF and rerun regression 
if "`keepvars'" != "" {
	     di "Keeping variables with VIF <= `threshold': `keepvars'" 
		 regress dir_fgt0 `keepvars'
		 }
/

* Define your dependent variable and independent variables
local dependent_var dir_fgt0
local independent_vars $postsign

* Set a threshold for VIF
local vif_threshold 10

* Start the loop
local keep_going = 1

while `keep_going' {
    * Run the regression
    regress `dependent_var' `independent_vars'
    
    * Calculate VIF
    vif
    
    * Capture the VIF results
    matrix VIFs = r(VIF)
    mata: st_matrix("VIFs", VIFs)

    * Find variables with high VIF
    local high_vif_vars ""
    foreach var of local independent_vars {
        local v = VIFs[1, `var']
        if `v' > `vif_threshold' {
            local high_vif_vars "`high_vif_vars' `var'"
        }
    }
    
    * Check if there are any high VIF variables
    if "`high_vif_vars'" == "" {
        * No high VIF variables, exit the loop
        local keep_going = 0
    }
    else {
        * Remove the variable with the highest VIF
        local highest_var = word(1, `high_vif_vars')
        di "Removing variable: `highest_var' with VIF: " VIFs[1, `highest_var']
        
        * Update the list of independent variables
        local independent_vars: remove `highest_var' `independent_vars'
    }
}

* Final model with selected variables
di "Final model includes: `independent_vars'"
regress `dependent_var' `independent_vars'


*/	
	