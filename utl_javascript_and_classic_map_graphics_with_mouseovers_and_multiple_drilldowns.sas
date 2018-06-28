Javascript and classic map graphics with mouseovers and multiple drilldowns

github output
https://tinyurl.com/y72jptna
https://github.com/rogerjdeangelis/utl_javascript_and_classic_map_graphics_with_mouseovers_and_multiple_drilldowns/blob/master/utl_javascript_and_classic_map_graphics_with_mouseovers_and_multiple_drilldowns.zip

Also here
https://goo.gl/Xw4f0O
https://drive.google.com/file/d/0ByX2ii2B0Rq9OVZQcjg5SEZQTlU/view?usp=sharing

github code
https://tinyurl.com/ydhjs2lf
https://github.com/rogerjdeangelis/utl_javascript_and_classic_map_graphics_with_mouseovers_and_multiple_drilldowns

Another example
http://robslink.com/SAS/democd23/overlib.sas

You should be able to download this and click on oberlib.htm to try it out before you create your own.
These files have to be in c:/rsf/htm.


You have to UNZIP  and place on in "C:/rsf/htm"  (has to be the c drive )

  The result should be

     c:/rsf/htm

        NURSES_FL.htm
        NURSES_GA.htm
        NURSES_NC.htm
        NURSES_SC.htm
        NURSES_VA.htm

        overli12.png

        overlib.htm       ** click on this

        overlib.js
        overlib.png
        overlib_anchor.js
        overlib_centerpopup.js
        overlib_crossframe.js
        overlib_cssstyle.js
        overlib_debug.js
        overlib_exclusive.js
        overlib_followscroll.js
        overlib_hideform.js
        overlib_setonoff.js
        overlib_shadow.js

        PHYSICIANS_FL.htm
        PHYSICIANS_GA.htm
        PHYSICIANS_NC.htm
        PHYSICIANS_SC.htm
        PHYSICIANS_VA.htm


Other javascript library tools
MIT Dygraph
R leaflet

INPUT
====

  Poulation statistics for nurses in various states
  -------------------------------------------------

  WORK.RSF_TSTDAT total obs=5

   YEAR    STATECODE      PHYSICIANS          NURSES      POPULATION

   2000       VA              707851         1707851         2707851
   2000       NC              804931         1804931         2804931
   2000       SC              401201         1401201         2401201
   2000       GA              818645         1818645         2818645
   2000       FL             1598237        11598237        21598237


  Ten HTML reports
  ----------------

  c:/rsf/physicians_fl.htm

   Year Florida Pysicians and overall Population

   STATE  PHYSICIANS  POPULATION
   FL      1,598,237  21,598,237

   ...

  c:/rsf/nurses_fl.htm

   Year Florida Nurses and overall Population

   STATE  PHYSICIANS  POPULATION
   FL     11,598,237  21,598,237

  Overlib Javascript library
  ==========================

  I downloaded this library many years ago.
  I was not familiar with the many download sites on the net.
  I have used my version fro many years without any problems or viruses.

  c:/rsf/htm

   overlib.js
   overlib_anchor.js
   overlib_centerpopup.js
   overlib_crossframe.js
   overlib_cssstyle.js
   overlib_debug.js
   overlib_exclusive.js
   overlib_followscroll.js
   overlib_hideform.js
   overlib_setonoff.js
   overlib_shadow.js


PROCESS (all the code)
=======================

After you run this code, copy all the overlib files in
the file you unzipped to the new directory.

* CREATE DIRECTORY STRUCTURE;
data _null_;
  rc=dcreate("rsf","c:/");
  rc=dcreate("htm","c:/rsf");
run;quit;

* CREATE POPUALATION DATA;
data rsf_tstdat;
retain year statecode;
format physicians nurses comma12.0;
input statecode $ 1-2 physicians nurses population;
year=2000;
cards4;
VA  707851  1707851   2707851
NC  804931  1804931   2804931
SC  401201  1401201   2401201
GA  818645  1818645   2818645
FL 1598237 11598237  21598237
;;;;
run;quit;

* CREATE 10 REPORTS IN C:/RSF/HTM;
data _null_;
  set rsf_tstdat;
  call symputx('state',statecode);
  array pracs[2] physicians nurses;
  do i=1 to 2;
    call symputx('prac',vname(pracs[i]));
    rc=dosubl('
      ods html file="c:/rsf/htm/&prac._&state..htm";
      proc print data=rsf_tstdat(drop=&prac. where=(statecode="&state."));run;quit;
      ods html close;
    ');
  end;
run;quit;

x "cd c:\rsf";

%let name=overlib;
filename odsout 'c:\rsf\htm\';

* template;
proc template;
define style styles.mydrill;
 parent=styles.default;
 style body from body /
  prehtml=' <div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000; opacity:0.8;"></div>';
 end;
run;


* set up overlib;
data rsf_addlnk;
    set rsf_tstdat;
    length htmlvar $1000;
    stpop    =  catx(' ','Title="State:',statecode,'0D'x,'Population:',put(population,comma12.0),'"');
    overlib  =  catx('href="','javascript:void(0);" onclick="return overlib(');
    fylone   =  cats("'<a href=\'file:c:/rsf/htm/Physicians_",statecode,".htm\'");
    fyltwo   =  cats("\'>Physicians</a><br><a href=\'file:c:/rsf/htm/Nurses_",statecode,".htm\'",">Nurses</a>'");
    fylend   =  catx(' ',', STICKY, CAPTION,',"'Choose a Drilldown', CENTER, TEXTSIZE, 3, WIDTH, 300);",'" onmouseout="nd();"');
    overlib  =  translate(overlib,"'",'#');
    htmlvar  =  cats(stpop,overlib,fylone,fyltwo,fylend);
    put htmlvar=;
run;

goptions reset=global;
goptions rotate=landscape device=png cback=white noborder hsize=10in vsize=8in;

ods listing close;
ods html path=odsout body="&name..htm" (title="SAS/Graph ODS HTML multi-Drilldown Bar gchart") style=mydrill
 headtext='<script type="text/javascript" src="overlib.js"><!-- overLIB (c) Erik Bosrup --></script>';

axis1 label=none;
axis2 label=none minor=none offset=(0,0);

pattern v=solid color=cx43a2ca;

footnote ls=1 "Each bar has 2 html drilldowns, via javascript";

axis1 label=none;
axis2 label=none minor=none offset=(0,0);

pattern v=solid color=cx43a2ca;

title1 ls=1.5 "Year 2000 U.S. Census Population";
title2 ls=1 color=gray "GMAP with ODS HTML Drilldown";

footnote color=gray "(Each state has an html drilldown)";

proc gmap data=rsf_addlnk map=maps.us all;
id statecode;
choro population / levels=1 nolegend
 coutline=black
 html=htmlvar
 des='' name="&name";
run;quit;

filename odsout clear;
ods html close;
ods listing;



WANT
====

  click on c:/rsf/htm/overlib.htm to bring up map

  State Popualtion when you mouseover state
  Click on state and pull down menu with selections
     Physicians
     Nurses
  Click on Physicians and get statistics for physicians



    ################################ ##
  ####      ##               #        #  # ## ####
   ###      ###              #        #      ######                       ##
   #        # ##             #        #      ### #######                 #
   ### ######  ##            ####     #    ##  #########                ##  #
            #   ## #         #        ##   ##     ####  #         # ## ##   ##
   #        #    #############         #    ##    # #   #        ##  ########
  ##        #       #        ########   #######    ##    #   ####    ## ##
  #         #       #        #      ####      ####  #   #           #####
  ###################        #         #      ##  ##########      ########
  ##    #       #   ############       ########   #        #      ########
   #    #       #     #        ###########   #    #        ######## #
   #    #       #     #        #        ##   ##   #  ####### #######
     #   ##     #     #        #         #        #### ###  ## ####
     #    ##    #     #        #         #      ####    #####   ###
     ##     ##  ##################################################
      #      ####             #   #      #     ##      ###      ### If you mouseover Florida
       #      ##              #   #      #    ########  ######  ### __________________________
         ##    ##             #   ########    #  #   #  ##   ###    | State: Florida         |
          ###  #              #       ## ######  #       ##         | Population: 21,598,237 |
            # ##              #           #  ##  #   ##   ##        --------------------------
                ###############           #  #   #   #    ##        If you click on Florida
                          ###             #    # ##########         __________________________
                            #  ##         #### ###########          | Physicians             |
                            ### ##      ##  #####       # #         | Nurses                 |
                                 ##   ##                # #         --------------------------
                                  ## ##                 # #         If you click on Physicians
                                   ###                   # #
                                    #                     # #        You get a report
                                                          ###
                                                                     STATE  PHYSICIANS  POPULATION

 This does the mouseover and drilldown

 stpop    =  catx(' ','Title="State:',statecode,'0D'x,'Population:',put(population,comma12.0),'"');
 overlib  =  catx('href="','javascript:void(0);" onclick="return overlib(');
 fylone   =  cats("'<a href=\'file:c:/rsf/htm/Physicians_",statecode,".htm\'");
 fyltwo   =  cats("\'>Physicians</a><br><a href=\'file:c:/rsf/htm/Nurses_",statecode,".htm\'",">Nurses</a>'");
 fylend   =  catx(' ',', STICKY, CAPTION,',"'Choose a Drilldown', CENTER, TEXTSIZE, 3, WIDTH, 300);",'" onmouseout="nd();"');
 overlib  =  translate(overlib,"'",'#');
 htmlvar  =  cats(stpop,overlib,fylone,fyltwo,fylend);




