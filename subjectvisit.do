quietly: do "${do_folder}open_table.do" "intecomm_subject" "subjectvisit"
tempfile subjectvisit
save `subjectvisit'

quietly: do "${do_folder}open_table.do" "intecomm_group" "patientgroup"
keep group_identifier randomized_datetime name
tempfile patientgroup
save `patientgroup'

quietly: do "${do_folder}patients.do"
drop if subject_identifier == ""
drop created modified user_created user_modified id revision device_created device_modified hostname_created hostname_modified site_id

drop if grouped == 0

merge 1:m subject_identifier using "`subjectvisit'"
gen no_visits = 1 if _merge == 1
replace no_visits = 0 if no_visits != 1

drop _merge

merge m:1 group_identifier using "`patientgroup'"

sort consent_datetime subject_identifier 
list subject_identifier visit_code group_identifier site_name screening_datetime consent_datetime  if visit_code == ""
