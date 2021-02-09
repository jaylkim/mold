*! version 0.0.0.9000 Jay Kim 09feb2021

/***

_version 0.0.0.9000_

__mold do__ - Create a do file based on a template

Description
-----------

{p}
This command is designed to create a do-file with a pre-specified template.

Syntax
------

{col 8}{cmd:mold} {cmd:do} {it:do_file_name} [, {it:options}]

{col 8}where {it:do_file_name} is the name of your do file.

{col 8}If no file extension is specified, {bf:.do} will be assumed.

Options
-------

{p 8 8}
- {cmd:parent(str)}: Under which directory you want to create your project?
If not provided, the current working directory is assumed.

{p 8 8}
- {cmdab:proj:ect(str)} : Project title 

{p 8 8}
- {cmdab:t:itle(str)} : Script title

{p 8 8}
- {cmdab:aut:hor(str)} : Author name 

{p 8 8}
- {cmdab:d:epends(namelist)} : Any dependencies other than the base commands 

{p 8 8}
- {cmdab:stata:ver(int)} : Stata version on which your project will be run (default 15). 

{col 8}All options except for {it:title} will be retrieved from {it:_config.do}.


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

***/


program define mold_do

  syntax anything(name=filename id="Do-file name") ///
  [,                ///
  PROJect(str)      /// Project name
  Title(str)        /// Script title
  AUThor(str)       /// Author name
  Depends(namelist) /// Dependencies other than the base commands
  STATAver(integer 15) /// Stata version your script will run on
  ]

  // Append .do if not provided

  mata:st_local("fileext", pathsuffix("`filename'"))
  
  if "`fileext'" == "" {
    
    local filename = "`filename'.do"

  }


  // If an option is not given, use the meta data 

  if missing("`project'") {
    local project = "$PROJECT_TITLE"
  }
  if missing("`author'") {
    local author = "$AUTHOR"
  }
  if missing("`depends'") {
    local depends = "$DEPENDENCY"
  }
  if missing("`stataver'") {
    local stataver = "$STATA_VERSION"
  }

  // Check if the file exists

  mata: st_local("dopath", pathjoin("$SRC_STATA_PATH", "`filename'"))

  capture confirm file "`dopath'"

  if _rc == 0 {
    local ans = ""
    while "`ans'" != "y" & "`ans'" != "n" {
      disp "`filename' already exists. Replace it? (y/n)?" _request(_ans)
      if "`ans'" == "y" {
        file open mydo using "`dopath'", write replace
        continue, break
      }
      else if "`ans'" == "n" {
        disp as error "Aborted"
        exit 
      }
    }
  }
  else {
    file open mydo using "`dopath'", write
  }

  // Write a template header
  file write mydo ("*" + "=" * 79) _n
  file write mydo ("* Project       : " + "`project'") _n
  file write mydo ("* Title         : " + "`title'") _n
  file write mydo ("* Author        : " + "`author'")  _n
  file write mydo ("* Script Version: ") _n
  file write mydo ("* Date added    : " + c(current_date)) _n
  file write mydo ("* Date modified : ") _n
  file write mydo ("* Depends on    : " + "`depends'") _n
  file write mydo ("*" + "-" * 79) _n
  file write mydo _n
  file write mydo _n

  // Write template code lines
 
  mata: st_local("log_name", pathrmsuffix("`filename'"))
  file open template using "_template.do", read
  file read template line

  while r(eof) == 0 {
  
    if regexm(strtrim("`line'"), "^\*") {
      
      file read template line
      continue

    }
    else {
 
      file write mydo "`line'" _n
      file read template line

    }
  }

  file close mydo
  file close template

  disp "`dopath' written based on _template.do"

end
