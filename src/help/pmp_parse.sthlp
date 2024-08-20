
help pmp_parse
-------------------------------------------------------------------------------
Title
    pmp_parse -- Parser that creates all files and runs current parallel strings

Syntax
    pmp_parse, [doname(string) dirname(string) replace runparallel]

Description
    Parses the input strings created by pmp_add to create (i) a master do-file (ii) individual do-files for each job, and (iii) a run_jobs.bat file that can run all jobs in parallel. All files are stored in directory dirname with corresponding subfolders for the job do-files (\dos\) and the log files which Stata creates when running the do-files (\log). Disclaimer: Run at own risk. This all works by running multiple instances of Stata via a batch script. Verify that all jobs were executed as desired is important because there will be no error messages in Stata (the version in which pmp_parse is executed). One can still consult the log files. Importantly, one needs to set the (absolute) path to the stata.exe in Stata global _parallel_stataexe (default is global _parallel_stataexe "C:\Program Files\Stata18\StataSE-64.exe").

Options
    doname(string)       specifies the name of the master do-file. Default is 
                         _master_parallel.do.
    dirname(string)      specifies the directory name where the files will be 
                         stored. Default is the current working directory.
    replace              replaces existing files if specified.
    runparallel          runs the generated batch file to execute jobs in 
                         parallel. Without this option, one can manually start all jobs by starting run_jobs.bat

Outputs
    Creates the master do-file and individual job do-files and generates a batch file to run all jobs in parallel. If runparallel is specified, then all outputs from the job do-files will also be created (but must be stored, i.e., they will not be available in the current dataframe)

Examples
	Create header: load data and ensure crossfold package is installed
	. parallel_add, header input(use ../../tsdata.dta, clear) clearheader 
	. parallel_add, header input(ssc install crossfold)  			 		
	
	Create two separate jobs
	. parallel_add, input(crossfold arima y, ar(1) k(10) ) preserve(`r(_header_string)') clearparallel 
	. parallel_add, input(crossfold arima y, ar(2) k(10) ) preserve(`r(_header_string)') continuejob 
	. parallel_add, input(crossfold arima y, ar(3) k(10) ) preserve(`r(_header_string)')
	. parallel_add, input(crossfold arima y, ar(4) k(10) ) preserve(`r(_header_string)') continuejob 
	
	Create all files in folder "\_myparallel\" and run the two jobs in parallel
	. parallel_parse, runparallel replace dirname(_myparallel) 

Notes
    - Ensure that the Stata executable path is correctly specified in the 
      global `$_parallel_stataexe`.
    - The master do-file and job do-files will be created in the specified 
      directory.
    - The batch file `run_jobs.bat` will be generated to run all jobs in 
      parallel.

Author
	Lukas Hack, ETH Zuerich
	https://lukas-hack.github.io/

-------------------------------------------------------------------------------
