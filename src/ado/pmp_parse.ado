cap program drop pmp_parse
program define pmp_parse, rclass

	syntax , [doname(string) dirname(string) replace runparallel]

	* Store locals because r() locals get overwritten after next prog call
	local _parallel_string 	`r(_parallel_string)'
	local _header_string 	`r(_header_string)'
	
	* Prepare directories
	if "`dirname'" != "" {
		pmp_setdir, dirname("`dirname'")
		pmp_setdir, dirname("`dirname'\log")
		pmp_setdir, dirname("`dirname'\dos")

	} 
	else {
		pmp_setdir, dirname("log")
		pmp_setdir, dirname("dos")
	}	

	
	* Parse parallel string to discet different jobs
	// di "`_parallel_string'"
	tokenize "`_parallel_string'", parse("<")
	
	* Catch if too many jobs specified that violate loop range (loop range may be adjusted)
	if "`100'" != "" {
		di in red "more than 99 jobs are not allowed - stop parsing"
		error 1
	}
	* Store each job in a new local 
	forv i = 1(1)99 {
		if "``i''" != "" & "``i''" != "<" {
			local jobcount = `jobcount' + 1
			local job`jobcount' ``i''
		}
	}

	* Read header and intialize do file
	tokenize "`_header_string'", parse(">")	
	* Catch if too many header lines specified that violate loop range (loop range may be adjusted)
	if "`100'" != "" {
		di in red "more than 99 header lines are not allowed - stop parsing"
		error 1
	}	
	* Loop over all header lines
	cap file close textfile	
	if ("`doname'" == "") 	local doname _master_parallel.do
	if ("`dirname'" != "") 	local doname_full `dirname'\\`doname'
	else 					local doname_full `doname'
	file open textfile using "`doname_full'", text write `replace'

	forv i = 1(1)99 {
		* Exit loop when nothing to parse left
		if ("``i''" == "") 	continue, break
		* Write current line if not parse symbol
		if ("``i''" != ">") file write textfile "``i''" _n _n
		// Maybe rethink line above to handle strings with quotes or write in doc that not allowed		
	}	
	file write textfile "" _n _n
	file write textfile "* Take start time" _n 
	file write textfile "scalar t1 = c(current_time)" _n _n 
	file write textfile "* Body with jobs starts here:" _n _n
	file write textfile "if 1 == 2 { " _n 
	file write textfile " // gets ignored " _n
	file write textfile "}" _n _n

	* Discect each job local with new tokenize to create do
	forv i = 1(1)`jobcount' {	

		* Parse do file for current job
		tokenize "`job`i''" , parse(">")
		
		* Check that at most 99 lines
		if "`100'" != "" {
			di in red "more than 99 lines in job `i' are not allowed - stop parsing"
			error 1
		}	
		
		* Parse if condition
		//if (`i' == 1) 	file write textfile `"else if \`i' == `i' {"' _n
		//else 			
		file write textfile `"else if `i' == \`i' {"' _n
		
		* Parse body of command
		forv j = 1(1)99 {
			* Exit loop when nothing to parse left
			if ("``j''" == "") continue, break
			* Write current line if not parse symbol
			if ("``j''" != ">") file write textfile "``j''" _n  					
		}
		* Parse end of job
		file write textfile "}" _n _n
	}

	file write textfile "* Take end time and display runtime" _n 
	file write textfile "scalar t2 = c(current_time)" _n
	file write textfile `"display "Runtime: " (clock(t2, "hms") - clock(t1, "hms")) / 1000 " seconds""' _n _n 	
	file close textfile	 	
	
	* Ensure that locals remain available
	return local _parallel_string 	`_parallel_string'
	return local _header_string 	`_header_string'
		
	* Generate do files for each job
	forv id = 1(1)`jobcount'  {	
		* Create separate .do file for each job based on the wrapper .do created above
		file open textfile using `dirname'\dos\job_`id'.do, write replace
		local temp_name `doname' //`id'
		file write textfile "local i = `id'" _n
		file write textfile `"include ..\\`temp_name' "'
		file close textfile
		//// COMMENT I CHANGED THE SECOND POINT TO TEXTFILE - REVIEW IF IT DOES NOT RUN
	}

	* Read stata system if specified
	if ("$_parallel_stataexe" == "") 	local stataexe C:\Program Files\Stata18\StataSE-64.exe
	else 								local stataexe $_parallel_stataexe

	* Generate the master batch file that starts all jobs
	forv id = 1(1)`jobcount'  {			
		if `id' == 1  {
			file open textfile using "`dirname'\run_jobs.bat", text write replace
			file write textfile `"CD .\log"' _n
			// Currently hardcoded such that only relative paths work here
		}
		//file write textfile "timeout 1" _n
		file write textfile "start "
		file write textfile `""""'
		file write textfile " "
		file write textfile `""`stataexe'" /e do "..\dos\job_`id'.do""' _n
	}	
	// file write textfile "PAUSE" // Activate this if cmd prompt should not automatically close
	file close textfile		
	
	
	if "`runparallel'" == "runparallel" {		
		cd ./`dirname'
		shell run_jobs.bat
		cd ../
	}
 	
end
