*! version 0.0.0.9000 Jay Kim 10feb2021
/***

{p}
{bf:mold} - Create a Structured Project with a Template


Description
-----------

{p}
{bf:mold} creates a structured project with a template ({cmd:mold} {cmd:init}).
Once your project is initiated, you can make do files with a pre-specified
header and code lines.
You can also edit this template ({it:_template.do}).
After editing this file, you can create do files based on the new template
with {cmd:mold} {cmd:do}.

{p}
{bf:mold} provides an additional feature that is to effectively
embed your R code in do files ({cmd:mold} {cmd:r}).


Syntax
------

{col 8}{cmd:mold} {it:subcommand} {it:argument}, [{it:options}]

Subcommands
-----------

{col 8}{cmd:mold} {cmd:init} ({help moldinit: mold init})
{col 8}{cmd:mold} {cmd:do} ({help molddo: mold do})
{col 8}{cmd:mold} {cmd:r} ({help moldr: mold r})


Author
------

{p}
Jay (Jongyeon) Kim {break}
Johns Hopkins University {break}
jay.luke.kim@gmail.com {break}
{browse "https://github.com/jaylkim": https://github.com/jaylkim} {break}
{browse "https://jaylkim.rbind.io": https://jaylkim.rbind.io} {break}

License
-------

{p}
MIT License {break}
Copyright (c) 2021 Jongyeon Kim {break}


_This help file was created by the_ __markdoc__ _package written by Haghish_

***/


program define mold

  
  syntax anything(name=arglist id="Subcommand") ///
    [, ///
      parent(str) ///
      PROJect(str) ///
      Title(str) ///
      DOpath(str) ///
      AUThor(str) ///
      Depends(namelist) ///
      STATAver(integer 15) ///
      git ///
      Rpath(str) ///
    ]


  tokenize `arglist'

  if "`1'" == "init" {
    
    moldinit "`2'", ///
      parent("`parent'") ///
      project("`project'") ///
      author("`author'") ///
      depends("`depends'") ///
      stataver(`stataver') ///
      `git' ///
      rpath("`rpath'")

  }
  else if "`1'" == "do" {
    
    molddo "`2'", ///
      project("`project'") ///
      title("`title'") ///
      author("`author'") ///
      depends("`depends'") ///
      stataver(`stataver') ///
      

  }
  else if "`1'" == "r" {
  
    moldr, dopath("`dopath'")
      
  
  }
  else {

    disp as err "Subcommand unrecognized"

  }



end
