cap program drop pmp_setdir
program define pmp_setdir, rclass
	syntax , [dirname(string)  replace ]
	
	* Set default folder name in current wd if not specified
	if ("`dirname'" == "") local dirname _parallel
	* Check if directory already exists / I can write this directory
	pmp_aux_check, path("`dirname'")
	if r(excode) == -1 {
		di in red "No writing permission for stated path"
		error 1
	}
	* Delete and create new directory with replace
	if (r(excode) == 0 & "`replace'" == "replace") {
		rmdir `dirname'
		mkdir `dirname'
	}		
	* Create new directory when no directory found
	if (r(excode) == -2) mkdir `dirname'
	// Do nothing when directory exists and no replace specified
end