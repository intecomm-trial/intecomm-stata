/* begin patients.do */

clear
quietly: do "get_env.do"

use "${dta_folder}intecomm_rando_randomizationlist_${date_stamp}.dta"
keep if allocated == 1
keep group_identifier sid allocated_datetime assignment site_name
tempfile randomizationlist
save "`randomizationlist'", replace

use "${dta_folder}edc_registration_registeredsubject_${date_stamp}.dta"
do "${do_folder}excluded_subjects.do"
do "${do_folder}sites_to_country.do"
keep subject_identifier country consent_datetime dob
tempfile registeredsubject
save "`registeredsubject'", replace

use "${dta_folder}intecomm_screening_subjectscreening_${date_stamp}.dta"
keep screening_identifier eligible reasons_ineligible
tempfile subjectscreening
save "`subjectscreening'", replace


use "${dta_folder}intecomm_screening_patientlog_${date_stamp}.dta"
do "${do_folder}excluded_subjects.do"

merge m:1 group_identifier using "`randomizationlist'"

gen randomized = 1 if _merge == 3
replace randomized = 0 if randomized != 1

gen screened = 1 if screening_identifier != ""
replace screened = 0 if screened != 1

gen grouped = 1 if group_identifier != ""
replace grouped = 0 if grouped != 1

drop _merge

merge m:1 subject_identifier using "`registeredsubject'"
gen consented = 1 if _merge == 3
replace consented = 0 if consented != 1
drop _merge

merge m:1 screening_identifier using "`subjectscreening'"

replace eligible = 2 if eligible == 0 & screened == 1
replace eligible = 0 if eligible == .
label define eligible_labels 0 "not screened" 1 "eligible" 2 "not eligible"
label values eligible eligible_labels




/* end patients.do */
