
help pmp_add
-------------------------------------------------------------------------------
Title
	pmp_add -- Input program that takes header and jobs to create master do file

Syntax
	pmp_add, input(string) [clearparallel continuejob header clearheader preserve(string)]

Description
	Adds strings containing the Stata code one wishes to execute in parallel. It adds job-strings or header-strings. The header will be executed before each parallel job-string. Importantly, note that characters ~ and ; may not be used in code strings because the program uses them internally to separate code lines and jobs when concatenating input strings. This does only apply to the direct code commands provided via input(); see Remark 3 below for a possible workaround.

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

Example
	Create header: load data and ensure crossfold package is installed
	. parallel_add, header input(use ../../tsdata.dta, clear) clearheader 
	. parallel_add, header input(ssc install crossfold)  			 		
	
	Create two separate jobs
	. parallel_add, input(crossfold arima y, ar(1) k(10) ) preserve(`r(_header_string)') clearparallel 
	. parallel_add, input(crossfold arima y, ar(2) k(10) ) preserve(`r(_header_string)') continuejob 
	. parallel_add, input(crossfold arima y, ar(3) k(10) ) preserve(`r(_header_string)')
	. parallel_add, input(crossfold arima y, ar(4) k(10) ) preserve(`r(_header_string)') continuejob 
	
	Remarks:
	1) The preserve command is needed to ensure the header string remains available
	2) The option continuejob ensure to add an additional line of code to the current job.
	3) Importantly, note that characters ~ and ; may not be used in code strings because the program uses them internally to separate code lines and jobs when concatenating input strings. This does only apply to the direct code commands provided via input(). Programs or do-files that are called within the header or within a job are not subject to this restriction. If you need to use these characters, you can write a wrapper program or do-file that is called via the input strings.
	
Author
	Lukas Hack, ETH Zuerich
	https://lukas-hack.github.io/
	
-------------------------------------------------------------------------------
