{smcl}

{p 4 4 2}
{it:version 0.0.0.9000}


{p 4 4 2}
{bf:mold r} - Export and process an embedded R code chunk in a do-file



{title:Description}

{p}
This command does the following:

{p 8 8}
{break}    1. Detects an R code chunk before its call and creates an {bf:.R} file.
{break}    2. Saves the data on memory so that the R file can use it.
{break}    3. Runs the R file.
{break}    4. Prints any side effects other than figures.
{break}    5. Saves figures.
{break}    6. Returns one {it:data.frame-like} object (e.g. {it:tibble}). 
{break}    7. Loads the data on Stata memory.

{p}
You have to embed this command right after an R code chunk.
An R code chunk is not supposed to be run by Stata, so you have to
comment it out with /* */.

{p}
This command detects any R code chunks in order.
Thus, you may not skip this command after any R code chunk.

{p}
An R code chunk have to look like this:

{col 8}~~~r chunk-title
{col 8}Any R code lines
{col 8}~~~

{p}
The leading part should include a chunk title.
If not provided, it assigns one based on the current date time
followed by three random letters.



{title:Syntax}

{p}
Put this command right after an R code chunk.

{col 8}{cmd:mold} {cmd:r}, dopath({it:path_to_do}) 

{p}
The options will be retrieved from global macros defined by {cmd:mold},
so you will not have to specify them by yourself.



{title:Options}

{p 8 8}
{break}    - {cmdab:do:path(str)}: The path to the currently running do file. 
It will be retrieved from $CURRENT_DO_PATH.





{title:Author}

{p 4 4 2}
Jay (Jongyeon) Kim

{p 4 4 2}
Johns Hopkins University

{p 4 4 2}
jay.luke.kim@gmail.com

{p 4 4 2}
{browse "https://github.com/jaylkim":https://github.com/jaylkim}

{p 4 4 2}
{browse "https://jaylkim.rbind.io":https://jaylkim.rbind.io}



{title:License}

{p 4 4 2}
MIT License

{p 4 4 2}
Copyright (c) 2021 Jongyeon Kim


{p 4 4 2}
{it:This help file was created by the} {bf:markdoc} {it:package written by Haghish}



