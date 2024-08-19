
help pmp_aux_check
-------------------------------------------------------------------------------
Title
    pmp_aux_check -- Checks whether a folder exists and whether one has 
                          writing rights

Syntax
    pmp_aux_check, path(string)

Description
    Checks whether a folder exists and whether one has writing rights. The 
    result is stored in the scalar r(excode).

Options
    path(string)    specifies the path to the folder (relative or absolute).

Outputs
    r(excode)    scalar indicating the status of the folder:
                 0  - exists and has writing rights
                 -1 - exists but no writing rights
                 -2 - does not exist

Examples
    . pmp_aux_check, path("parallel_jobs")

-------------------------------------------------------------------------------