
help pmp_parse
-------------------------------------------------------------------------------
Title
    pmp_parse -- Parser that creates do file from input strings

Syntax
    pmp_parse, [doname(string) dirname(string) replace runparallel]

Description
    Parses the input strings to create a master do-file and individual job 
    do-files. This program manages the creation of directories, parsing of job 
    and header strings, and the generation of batch files to run jobs in 
    parallel.

Options
    doname(string)       specifies the name of the master do-file. Default is 
                         _master_parallel.do.
    dirname(string)      specifies the directory name where the files will be 
                         stored. Default is the current working directory.
    replace              replaces existing files if specified.
    runparallel          runs the generated batch file to execute jobs in 
                         parallel.

Outputs
    Creates the master do-file and individual job do-files.
    Generates a batch file to run all jobs in parallel.

Examples
    . pmp_parse, doname("master.do") dirname("parallel_jobs") replace
    . pmp_parse, doname("master.do") runparallel

Notes
    - Ensure that the Stata executable path is correctly specified in the 
      global `$_parallel_stataexe`.
    - The master do-file and job do-files will be created in the specified 
      directory.
    - The batch file `run_jobs.bat` will be generated to run all jobs in 
      parallel.

-------------------------------------------------------------------------------
