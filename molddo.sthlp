{smcl}

{p 4 4 2}
{it:version 0.0.0.9000}

{p 4 4 2}
{bf:mold do} - Create a do file based on a template


{title:Description}

{p}
This command is designed to create a do-file with a pre-specified template.


{title:Syntax}

{col 8}{cmd:mold} {cmd:do} {it:do_file_name} [, {it:options}]

{col 8}where {it:do_file_name} is the name of your do file.

{col 8}If no file extension is specified, {bf:.do} will be assumed.


{title:Options}

{p 8 8}
{break}    - {cmd:parent(str)}: Under which directory you want to create your project?
If not provided, the current working directory is assumed.

{p 8 8}
{break}    - {cmdab:proj:ect(str)} : Project title 

{p 8 8}
{break}    - {cmdab:t:itle(str)} : Script title

{p 8 8}
{break}    - {cmdab:aut:hor(str)} : Author name 

{p 8 8}
{break}    - {cmdab:d:epends(namelist)} : Any dependencies other than the base commands 

{p 8 8}
{break}    - {cmdab:stata:ver(int)} : Stata version on which your project will be run (default 15). 

{col 8}All options except for {it:title} will be retrieved from {it:_config.do}.



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



