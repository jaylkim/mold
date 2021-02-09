*! version 0.0.0.9000 Jay Kim 07feb2021
/***

_version 0.0.0.9000_

__mold init__ - Initialize a proejct

Description
-----------

{p}
This command initializes a project structure with a pre-specified template.
The structure of directories is as follows:

{col 8}.
{col 8}|--data
{col 8}|--src
{col 8}|--|-R
{col 8}|--|-stata
{col 8}|--doc
{col 8}|--ext
{col 8}|--output
{col 8}|--|-figures
{col 8}|--|-tables

{p}
If specified, you can initialize a git repository.
It also adds some to {it:.gitignore}.
You can modify it according to your preference.

{p}
It automatically creates {it:_config.do} including global macros
that will be used by your project.
It also makes {it:_start_[proj_name].do} that makes you ready to work.
Before starting working, open the {it:_start_[proj_name].do} file
and press the {bf:run} button on the upper right corner of the do-editor.
This will change the working directory and load the global macros required.
You can check the list of them by running {cmd:macro} {cmd:list}.


Syntax
------

{col 8}{cmd:mold} {cmd:init} {it:project_name} [, {it:options}]

{col 8} where {it:project_name} is the folder name of your project.

Options
-------

{p 8 8}
- {cmd:parent}: Under which directory you want to create your project?
If not provided, the current working directory is assumed.

{p 8 8}
- {cmdab:proj:ect} : Project title 

{p 8 8}
- {cmdab:aut:hor} : Author name 

{p 8 8}
- {cmdab:d:epends} : Any dependencies other than the base commands 

{p 8 8}
- {cmdab:stata:ver} : Stata version on which your project will be run (default 15). 

{p 8 8}
- {cmd:git} : Initialize a git repository

{p 8 8}
- {cmdab:r:path} : A path to the Rscript command on your computer.



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



program define mold_init

  syntax anything(name=proj_folder id="Project folder name") ///
    [,                      ///
      parent(str)           /// Parent dir 
      PROJect(str)          /// project title
      AUThor(str)           /// Author name
      Depends(namelist)     /// Dependencies other than the base commands
      STATAver(integer 15)  /// Stata version your script will run on
      git                   /// Set this project as a git repo
      Rpath(str)            /// Path to Rscript command
    ]
  

  // Parent dir

  if "`parent'" == "" {
    local parent = c(pwd)
  }

  // Make a root directory

  mata: st_local("projpath", pathjoin("`parent'", "`proj_folder'")) 
  cap mkdir "`projpath'"

  // Give an err msg if the folder exists

  if _rc != 0 {
    disp as err "`projpath' already exists"
    exit
  }

  // Paths

  mata: st_local("datapath", pathjoin("`projpath'", "data"))
  mata: st_local("srcpath", pathjoin("`projpath'", "src"))
  mata: st_local("src_rpath", pathjoin("`srcpath'", "R"))
  mata: st_local("src_stpath", pathjoin("`srcpath'", "stata"))

  // Write a _config.do file

  mata: st_local("configpath", pathjoin("`projpath'", "_config.do"))
  qui file open config using "`configpath'", write replace

  file write config "global PROJECT_PATH `projpath'" _n
  file write config "global R_EXEC_PATH `rpath'" _n
  file write config "global DATA_PATH `datapath'" _n
  file write config "global SRC_PATH `srcpath'" _n
  file write config "global SRC_R_PATH `src_rpath'" _n
  file write config "global SRC_STATA_PATH `src_stpath'" _n
  file write config `"global PROJECT_TITLE "`project'""' _n
  file write config `"global AUTHOR "`author'""' _n
  file write config `"global DEPENDENCY "`depends'""' _n
  file write config "global STATA_VERSION `stataver'" _n
  
  if "`git'" == "" {
    local git = 0
  }
  else {
    local git = 1
  }

  file write config "global GIT `git'" _n

  file close config

  // Write a _start_proj_name.do

  mata: st_local("startpath", pathjoin("`projpath'", "_start_`proj_folder'.do"))
  qui file open start using "`startpath'", write replace

  file write start "do `configpath'" _n
  file write start "cd `projpath'" _n
  file write start `"disp as txt \`"Project "`project'" in `projpath' loaded"'"' _n
 
  file write start `"disp = ("-" * 10 + "Git information" + "-" * 10)"' _n
  file write start `"if "\$GIT" == "1" {"' _n
  file write start _skip(2) `"disp "* git status ---- ""' _n
  file write start _skip(2) `"shell git status"' _n
  file write start _skip(2) `"disp "* git branches ---- ""' _n
  file write start _skip(2) `"shell git branch"' _n
  file write start _skip(2) `"disp "* git log ---- ""' _n
  file write start _skip(2) `"shell git log --oneline --graph"' _n
  file write start "}" _n

  file close start

  // Change the working directory

  qui cd "`projpath'"
  
  // Run _config.do

  do _config.do


  disp as txt "`projpath' created. Set as a working directory"

  // Create a default template file

  mata: st_local("temppath", pathjoin("`projpath'", "_template.do")

  qui file open template using "`temppath'", write replace

  file write template "* Any line that starts with * will be ignored." _n
  file write template "* You may edit any lines that you want to include "
  file write template "in your do file." _n
  file write template "* You can use any macros on memory in your template." _n
  file write template "* Macros in this template will be replaced by their "
  file write template "values." _n
  file write template "* Once you create a project with mold init, "
  file write template "some global macros you can use will be defined." _n
  file write template "* You can check them by running 'macro list'." _n
  file write template "* A local macro \`log_name' will be "
  file write template "defined by mold init. So you can use them " 
  file write template "in this template." _n
  file write template _n(3)
  file write template "clear all" _n
  file write template _n(2)
  file write template "log using \`log_name'.log, replace text" _n
  file write template _n(2)
  file write template "version \$STATA_VERSION" _n

  file close template


  // Make directories required
  // .              // Project dir
  // |--data        // Raw/processed data
  // |--src         // R or Stata source files
  // |--|-R
  // |--|-stata
  // |--doc         // Documents illustrating your analysis
  // |--ext         // All external files
  // |--output      // Figures/tables created from the analysis
  // |--|-figures
  // |--|-tables

  mkdir "$DATA_PATH"
  mkdir "$SRC_PATH"
  mkdir "$SRC_R_PATH"
  mkdir "$SRC_STATA_PATH"
  mkdir "doc"
  mkdir "ext"
  mkdir "output"
  qui cd "output"
  mkdir "figures"
  mkdir "tables"
  qui cd ..

  // Initializing a git repo
  // Ignore anything that starts with temp

  if "$GIT" == "1" {

    shell git init

    file open gitignore using ".gitignore", write
    file write gitignore ".DS_Store" _n
    file write gitignore "*.swp" _n
    file write gitignore "ext/" _n
    file write gitignore "data/" _n
    file write gitignore "temp*" _n
    file close gitignore
    
    disp "Create a commit with a message 'Initial commit'? (y/n)" _request(_ans)
    
    if "`ans'" == "y" | "`ans'" == "Y" {
      
      shell git add .
      shell git commit -m "Initial commit"

    }
    else if "`ans'" == "n" | "`ans'" == "N" {
      
      disp "Check the git status."
      shell git status
   
    }
    else {

      disp "Create a commit with a message 'Initial commit'? (y/n)" _request(_ans)
    
    }
      
      
  }

end
