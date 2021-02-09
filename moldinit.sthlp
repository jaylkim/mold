{smcl}

{p 4 4 2}
{it:version 0.0.0.9000}

{p 4 4 2}
{bf:mold init} - Initialize a proejct


{title:Description}

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



{title:Syntax}

{col 8}{cmd:mold} {cmd:init} {it:project_name} [, {it:options}]

{col 8} where {it:project_name} is the folder name of your project.


{title:Options}

{p 8 8}
{break}    - {cmd:parent}: Under which directory you want to create your project?
If not provided, the current working directory is assumed.

{p 8 8}
{break}    - {cmdab:proj:ect} : Project title 

{p 8 8}
{break}    - {cmdab:aut:hor} : Author name 

{p 8 8}
{break}    - {cmdab:d:epends} : Any dependencies other than the base commands 

{p 8 8}
{break}    - {cmdab:stata:ver} : Stata version on which your project will be run (default 15). 

{p 8 8}
{break}    - {cmd:git} : Initialize a git repository

{p 8 8}
{break}    - {cmdab:r:path} : A path to the Rscript command on your computer.



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



