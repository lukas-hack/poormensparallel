cap program drop pmp_add
program define pmp_add, rclass
    syntax, input(string)  [clearparallel continuejob header clearheader preserve(string)] 
	* Job strings	
	if "`header'" != "header" {
		if "`clearparallel'" == "clearparallel" {
			return local _parallel_string `input'		
		}
		else {		
			if "`continuejob'" == "continuejob" {
				* ~ indicates that current job string continutes on next line
				return local _parallel_string  `r(_parallel_string)' ~ `input'
			}
			else {
				* ; indicates end of current job string
				return local _parallel_string  `r(_parallel_string)' ; `input'
			}
		}
		return local _header_string `preserve'
	}
	* Header strings
	else {
		if "`clearheader'" == "clearheader" {
			return local _header_string `input'
			return local _parallel_string `r(_parallel_string)'
		}
		else {
			* ~ indicates that current job string continutes on next line
			return local _header_string `r(_header_string)' ~ `input'
			return local _parallel_string `r(_parallel_string)'
		}
		return local _parallel_string `preserve'
	}	

end