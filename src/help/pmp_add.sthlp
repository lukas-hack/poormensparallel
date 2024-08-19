
help pmp_add
-------------------------------------------------------------------------------
Title
    pmp_add -- Input program that takes header and jobs to create master 
                    do file

Syntax
    pmp_add, input(string) [clearparallel continuejob header clearheader preserve(string)]

Description
    Adds job or header strings to create a master do-file. This program manages 
    the job and header strings, allowing for the creation of a comprehensive 
    master do-file for parallel execution.

Options
    input(string)       specifies the job or header string to be added.
    clearparallel       clears the current job string.
    continuejob         continues the current job string on the next line.
    header              indicates that the input is a header string.
    clearheader         clears the current header string.
    preserve(string)    preserves the specified local variable.

Outputs
    r(_parallel_string)    the combined job string.
    r(_header_string)      the combined header string.

Examples
    . pmp_add, input("job1.do") clearparallel
    . pmp_add, input("job2.do") continuejob
    . pmp_add, input("header line") header

-------------------------------------------------------------------------------
