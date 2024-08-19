cap program drop pmp_aux_check 
program define pmp_aux_check , rclass 
	syntax, path(string)

	confirmdir "`path'"
	if `r(confirmdir)' == 0 {
		* Folder exists
		capture {
			tempfile _parallel_testfile
			cap drop _parallel_aux
			gen _parallel_aux = 1
			save "`path'\_parallel_testfile.dta", replace
			drop _parallel_aux
		}
		if _rc == 0 {
			* Have writing permission
			erase "`path'\_parallel_testfile.dta"
			return scalar excode = 0
		} 
		else {
			* No writing permission
			return scalar excode = -1
		}
	} 
	else {
		* Folder does not exist
		return scalar excode = -2
	}
end
