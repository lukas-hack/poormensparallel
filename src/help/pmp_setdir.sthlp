
help pmp_setdir
-------------------------------------------------------------------------------
Title
    pmp_setdir -- Ensures that a directory is used or created where all 
                       parallel stuff is stored

Syntax
    pmp_setdir, [dirname(string) replace]

Description
    Ensures that a directory is used or created where all parallel files are 
    stored. If the directory does not exist, it will be created. If the 
    directory exists and the replace option is specified, the directory will 
    be deleted and recreated.

Options
    dirname(string)    specifies the name of the directory. If not specified, 
                       the default is _parallel.
    replace            specifies that the directory should be replaced if it 
                       already exists.

Examples
    . pmp_setdir, dirname("parallel_jobs") replace
    . pmp_setdir, dirname("parallel_jobs")

-------------------------------------------------------------------------------
