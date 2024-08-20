# Poor Men's Parallel Stata Package

## What is it?
By default Stata SE runs only one a single CPU but most computers have multiple CPUs. A common (poor men's) workaround is to let mutliple instances of Stata run at the same time. Running multiple instances simulatenously is automized in this package. It is the side product of a research project. Use at your own risk. Alternatively, buy Stata MP.

## What are the capabilities?
It can parallelize independent Stata commands. For example, it can run multiple regress (or any other Stata command) in parallel. It can NOT break up dependent Stata code, e.g. loops, unless the users finds a way to break the dependence. It can NOT work on multiple computers simultaneously - there are other packages. 

## How it works under the hood?
The user inputs the code to run in parallel. Then program creates a windows batch file that starts a separate Stata instance for each job specified by the user simulatenously. There is nothing that ensures that Windows distributes Stata across cores efficiently. Depending on the machine one may need more jobs (and Stata instances) than CPUs to get the CPU to full utilization. 

## What are the gains?
In the examples I tested on a 4 core thinkpad, it reduced runtime up to one third of the non-parallel code.

## Get started
Type the following command in Stata directly to install
```
net install poormensparallel, from("https://raw.githubusercontent.com/lukas-hack/poormensparallel/main/src") 
```
I recommend to consult the help files after downloading 
```
help pmp_add
help pmp_parse
```
A simple example can also be downloaded from here.

## Feedback
Highly welcome. That said, I am not a software developer but an economist who thought that these pieces of code could be useful to others. If you find bugs, report them. You can also download the programs and modify them for your use case.
