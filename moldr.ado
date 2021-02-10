*! version 0.0.0.9000 Jay Kim 07feb2021

/***

_version 0.0.0.9000_


__mold r__ - Export and process an embedded R code chunk in a do-file


Description
-----------

{p}
This command does the following:

{p 8 8}
1. Detects an R code chunk before its call and creates an __.R__ file.
2. Saves the data on memory so that the R file can use it.
3. Runs the R file.
4. Prints any side effects other than figures.
5. Saves figures.
6. Returns one {it:data.frame-like} object (e.g. _tibble_). 
7. Loads the data on Stata memory.

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


Syntax
------

{p}
Put this command right after an R code chunk.

{col 8}{cmd:mold} {cmd:r}, dopath({it:path_to_do}) 

{p}
The options will be retrieved from global macros defined by {cmd:mold},
so you will not have to specify them by yourself.


Options
-------

{p 8 8}
- {cmdab:do:path(str)}: The path to the currently running do file. 
It will be retrieved from \$CURRENT_DO_PATH.

    


Author
------

Jay (Jongyeon) Kim

Johns Hopkins University

jay.luke.kim@gmail.com

[https://github.com/jaylkim](https://github.com/jaylkim)

[https://jaylkim.rbind.io](https://jaylkim.rbind.io)


License
-------

MIT License

Copyright (c) 2021 Jongyeon Kim


_This help file was created by the_ __markdoc__ _package written by Haghish_

***/



program define moldr 

  syntax , DOpath(str)
  
  // Path manipulations

  mata: pathsplit("`dopath'", path = "", file = ""); st_local("dofilename", file)
  mata: st_local("dofilenosuffix", pathrmsuffix("`dofilename'"))

  // Detects an R code chunk

  cap file open dofile using "`dopath'", read
  file read dofile line

  while r(eof) == 0 {
  
    local line = strtrim(`"`line'"')

    if regexm(`"`line'"', "^~~~r") {
      
      local chunk_title = word(regexr(`"`line'"', "~~~r", ""), 1)
      
      if "`chunk_title'" == "" {
        
        disp as txt "Chunk title not provided"
        
        local current_d = subinstr(c(current_date), " ", "", .)
        local current_t = subinstr(c(current_time), ":", "", .) 

        local chunk_title = ("`current_d'" + "_" + "`current_t'")
        local chunk_title = ("`chunk_title'" + char(runiformint(97, 122)))
        local chunk_title = ("`chunk_title'" + char(runiformint(97, 122)))
        local chunk_title = ("`chunk_title'" + char(runiformint(97, 122)))

        disp as txt "Chunk title created based on the current date-time"

      }
      
      disp as txt `"R code chunk (`chunk_title') detected"'


      // Save the data on memory
      
      local datafilename = "st_`dofilenosuffix'_`chunk_title'.dta"
      mata: st_local("datafilepath", pathjoin("$DATA_PATH", "`datafilename'"))
      qui save "`datafilepath'", replace 

      disp as txt `"Data for the chunk saved in `datafilepath'"'

      // Extract the R chunk

      local rfilename = "st_`dofilenosuffix'_`chunk_title'.R" 
      mata: st_local("rfilepath", pathjoin("$SRC_R_PATH", "`rfilename'"))

      qui file open rfile using "`rfilepath'", write replace
      
      file write rfile "## This file was written by running `dofilename'." _n
      file write rfile "" _n(2)
      file write rfile "## Read the data from Stata" _n
      file write rfile `"data <-"' _n
      file write rfile _col(2) `"haven::read_dta("' _n
      file write rfile _col(4) `""`datafilepath'""' _n
      file write rfile _col(2) ")" _n
      file write rfile "" _n(3)

      file read dofile line

      while `"`line'"' != "~~~" {
      
        file write rfile `"`line'"' _n

        file read dofile line

      }

      qui file close rfile

      disp as txt `"`rfilepath' written"'
      
      continue, break

    }
    
    file read dofile line 

  }

  if r(eof) != 0 {
    file close dofile
  }


  // Create a temp R file to run the R file above

  tempname rtemp

  mata: st_local("r_temppath", pathjoin(pwd(), "`rtemp'.R"))

  qui file open rtmp using "`r_temppath'", write replace

  file write rtmp `"source("`rfilepath'", echo = TRUE)"' _n
  file write rtmp _n
  file write rtmp "obj_data <-" _n
  file write rtmp "ls()[" _n
  file write rtmp "sapply(" _n
  file write rtmp "lapply(" _n
  file write rtmp "lapply(" _n
  file write rtmp "lapply(" _n
  file write rtmp "ls(), as.symbol" _n
  file write rtmp ")," _n
  file write rtmp "eval)," _n
  file write rtmp "class)," _n
  file write rtmp `"function(x) "data.frame" %in% x)]"' _n
  file write rtmp `"haven::write_dta(eval(as.symbol(obj_data)), "`datafilepath'")"'
  
  file close rtmp
 
  // Run the R code
  // Any side effects will be printed or saved
  // One data frame should be returned
  // The returned data frame will be loaded on Stata memory

  shell $R_EXEC_PATH `r_temppath'

  erase "`r_temppath'"

  qui use "`datafilepath'", clear

  disp as txt "New dataset from the R code retrieved"

end
