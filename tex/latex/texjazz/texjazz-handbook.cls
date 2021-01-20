% !TEX encoding = UTF-8 Unicode
%%
%% texjazz-handbook.cls
%%
%% A LaTeX package Typesetting French/English handbook/workbook
%%
%% Copyright (c) 2020-2021 ejazz.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This work is part of the TeXjazz bundle. It may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
%
% This work has the LPPL maintenance status `maintained'.
%
% The Current Maintainer of this work is ejazz <ejazz.fr@gmail.com>.
%
% This work consists of the main file of the `TexJazz' bundle: `texjazz-handbook.cls'
%
% Its companion packages are: 
%   − textjazz-askreply.sty for exercise and quiz layout
%   − textjazz-assignpoints.sty for points within exercises and quizzes
%   − textjazz-forest.sty based on the `forest' package for tree directories and icons
%   − textjazz-modelling.sty for UML and Merise diagrams
%   − textjazz-piechart.sty which extends a little bit `the pgf-pie.sty' package
%   − xfontawesome.sty witch extends `fontawesome' with some glyphs from `fontmfizz'
%
% Its companion file for Pygments Python module (`minted' and `PythonTeX' packages) is:
%   − jazzcode.py which must be copied in the Pygments styles directory. For Linux box:
%     /lib/python3/dist-packages/pygments/styles/.
%
% A few ideas have been borrowed to and originally inspired by Yves Zumbach's YLaTeX bundle (2015)
% − now maintained by Harvey Sheppard (2017+) on GitHub: https://github.com/HarveySheppard/yLaTeX/
% For distribution reasons, some packages have been partly integrated in this class. This is 
% the case of the `needspace` and `sidenote` packages.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%---------------------------------------------------------------------------------------------------
%
% PLEASE TAKE CARE! NO WARRANTY IS GIVEN, USE IT AND BORROW WHATEVER YOU WANT BUT DO NOT DISTRIBUTE 
% THIS CLASS FOR THE MOMENT BEING.
%-  Although the code snippets which have been borrowed are mainly under the LPPL license − LaTeX
%   Project Public Licence −, the licenses dues have not yet been fine verified.
%   Moreother, please consider that this class and associated packages are still *experimental*
%   and may certainly have side effects and be buggy (this is the case of the `workbook` option).
%   Use it for personal needs: (re)compilation of a document or inspiration for some commands.
%   A amazing amount of things has been resolved thanks to the incredible and awesome mutual aid
%   Web site TeX.SX: https://tex.stackexchange.com/
%
%   For the moment being, there is no documentation, but the code is over commented.
%
% Known bugs:
%    * Overfull\hbox (0.4pt too wide) with \part or \partoclayout or whatever sectionning command
%      --> Comming from the `geometry' package and `showframe' option. 
%-     Why? It works for other documents.
%    * "list of figure" order may contain mistakes for `marginfigure' and `sidefigure'.
%    * Make the hyperanchor at the begining of the figure environment and not at the caption command
%      when only using \captionsetup + \caption (because the caption is *after* the display).
%      See how Heiko Oberdiek solves this for standard figure environment. We don't need this
%      feature for captions *before* the environment (see "code" or "listing").
%    * List environments (itemize, enumerate) have indentation issues within exercise/solution
%      environment: see `texjazz-askreply' package.
%    * \nameref and part counter do not work together: bug with `titlesec` package? (solved)
%    * Criptic warning from `titletoc' package: "Unknown TOC type... level -1000" HUMMM...
%    * Sometimes, the vertical space before a subsubsection is zero! A \newline must be added. WHY?
%    * `idleconsole' environment leads to vertical space when used before a sectionning command.
%      One has to manually add a small \vspace (like 1pt) to circumvent the issue. Very strange...
%    * Quiz question title does not support \texttt{} nor \ttfamily.
%
% Author: ejazz <ejazz.fr@gmail.com>
%
%---------------------------------------------------------------------------------------------------

%---------------------------------------------------------------------------------------------------
%- Cette extension de classe LaTeX a été développée « au fil de l'eau » depuis plusieurs années
%- pour répondre aux besoins de manuels de cours et de cahier d'exercises (cours du soir du Cnam
%- et Mooc divers). Ce faisant, il reste nombre d'artéfacts désormais inutiles et un travail 
%- de toilletage est indispensable qui, pour le moment n'a pas été réalisé. En conséquence,
%- merci de ne pas diffuser ce fichier avant qu'il ne soit « présentable » et de l'utiliser
%- uniquement dans la perspective de recompiler le manuel des Moocs Inria ICN, SNT et Python
%- à partir des sources fournies.
%---------------------------------------------------------------------------------------------------

%---------------------------------------------------------------------------------------------------
%---- Class identification
%---------------------------------------------------------------------------------------------------

\ProvidesClass{texjazz-handbook}[2020/12/22 v0.1b − Typesetting French/English handbook/workbook]
\NeedsTeXFormat{LaTeX2e}

%---------------------------------------------------------------------------------------------------
%---- LaTeX engine tests (LuaTeX only compilation)
%---------------------------------------------------------------------------------------------------

%- Testing used engine for compiling LaTeX document: only LuaTeX is allowed

\RequirePackage{ifluatex}% Only LuaTeX / abandon de pdfTeX, raison: UTF-8 et bien plus...

\ifluatex
  \typeout{*** LuaTeX compiling with TeXjazz is in process ***}
\else%
  \ClassError{texjazz-handbook}%
    {LuaTeX is required by the TeXjazz bundle:\MessageBreak
     you *must* change your typesetting engine}
\fi

%-- Compilation note
%-------------------
%- To compile a document with this class, one has to allow shell-escape (write18) option, i. e.:
%- /opt/texlive/2020/bin/x86_64-linux/[...]
%-    [...]lualatex -shell-escape -synctex=1 -interaction=nonstopmode <filename.tex>


%---------------------------------------------------------------------------------------------------
%---- (La)TeX programming utilities and basic class options
%---------------------------------------------------------------------------------------------------

%-- Programming utilities
%------------------------

%- Provides facilities to write readable informational messages to the console and log file (e-TeX)
%- See: https://tex.stackexchange.com/questions/3595/how-can-i-word-wrap-latex-warning-error-output
%- See also the basic original idea which lead to the hardwrap package (Will Robertson):
%-   https://gist.github.com/wspr/605753
%- For the moment being, one have to add these following line in ".../texlive/2020/texmf.cnf:
%-  max_print_line=1000
%-  error_line=254
%-  half_error_line=238
%- From: https://tex.stackexchange.com/questions/52988/[...]
%-         [...]avoid-linebreaks-in-latex-console-log-output-or-increase-columns-in-terminal

%\RequirePackage{hardwrap}
%\setmaxprintline{99}% DOESN'T WORK FOR THE TIME BEING! WHY? FIX IT! LOG FILES ARE UNREADABLE...

%- LaTeX 3 syntax and commands (not aware of this, but used by some borrowed code snippets)
\RequirePackage{expl3}

%- Provides the new LaTeX3 interface for producing document-level commands (really useful)
\RequirePackage{xparse}

%- Provides LaTeX frontends to some e-TeX primitives and generic tools (real swiss knife!)
\RequirePackage{etoolbox}

%- Extends commands from the `etoolbox' package
\RequirePackage{xpatch}

%- Extends commands from the `etoolbox' package
%\RequirePackage{regexpatch}

%- Provides tuning hooks like \AfterLastShipout and others (see doc)
\RequirePackage{atveryend}

%- Adds specific hooks for input files (\AtBeginOfFile...)
\RequirePackage{filehook}

%- Provides the file name and path information of the current input file as LaTeX macros
\RequirePackage{currfile}

%- Extends \let assignment to macros with optional arguments or robust
\RequirePackage{letltxmacro}

%- Calculates in a easier way: allows arithmetic operation
\RequirePackage{calc}

%- Provides new method for defining environments
\RequirePackage{environ}

%- Provides new method for defining environments (CLASH?)
%\RequirePackage{newenviron}

%- Implements (using Lua) some pdfTeX primitives that are not defined by LuaTeX
\RequirePackage{pdftexcmds}

%- Key-value options management for packages and classes
\RequirePackage{pgfopts}

%- Checking if "-shell-escape" option is enabled, see:
%-   https://tex.stackexchange.com/questions/88614/how-do-you-detect-restricted-write18-support/
%-   https://tex.stackexchange.com/questions/475183/[...]
%-       [...]conditional-output-dependent-on-shell-escape-option-value/

\ifcase\pdf@shellescape
  %- 0: Shell escape is disabled
  %\message{\string`\jobname.tex' Shell escape is disabled.}
  \ClassError{texjazz-handbook}%
    {Shell escape is disabled.\MessageBreak
     Please run LaTeX with the unrestricted shell escape option}
  \or
  %- 1: Unrestricted shell escape is enabled
  %\message{\string`\jobname.tex' Shell escape is enabled.}
  \ClassInfo{texjazz-handbook}%
    {Unrestricted shell escape is enabled.\MessageBreak
     Fine, let's do the job}
  \or
  %- 1: Restricted shell escape is enabled
  %\message{Restricted shell escape is enabled.}
  \ClassWarningNoLine{texjazz-handbook}%
    {Restricted shell escape is enabled.\MessageBreak
     Please run LaTeX with the unrestricted option}
\fi

%-- Checking/creating working directory for PythonTex outputs
%------------------------------------------------------------

%- Enables shell commands to be ran from the LaTeX source file (needs the "-shell-escape" option)

\RequirePackage{ifplatform}% Checking the operating system
\RequirePackage{shellesc}% Accessing to system commands from LaTeX (--shell-escape option is needed)

%- From: https://tex.stackexchange.com/questions/16790/[...]
%-          [...]write18-capturing-shell-script-output-as-command-variable/

\ExplSyntaxOn
\NewDocumentCommand{\jazzcaptureshell}{ s o m }
 {
  \texjazz_captureshell:Ne \l__texjazz_captureshell_out_tl { #3 }
  \IfBooleanT { #1 }
   {% we may need to stringify the result
    \tl_set:Nx \l__texjazz_captureshell_out_tl
     { \tl_to_str:N \l__texjazz_captureshell_out_tl }
   }
  \IfNoValueTF { #2 }
   {
    \tl_use:N \l__texjazz_captureshell_out_tl
   }
   {
    \tl_set_eq:NN #2 \l__texjazz_captureshell_out_tl
   }
 }
\tl_new:N \l__texjazz_captureshell_out_tl
\cs_new_protected:Nn \texjazz_captureshell:Nn
 {
  \sys_get_shell:nnN { #2 } { } #1
  \tl_trim_spaces:N #1 % remove leading and trailing spaces
 }
\cs_generate_variant:Nn \texjazz_captureshell:Nn { Ne }
\ExplSyntaxOff

\iflinux
  \typeout{*** The Operating System is a \linuxname\space box ***}
  \jazzcaptureshell*[\dirstatus]{[ -d ./PythonTeX/ ] && echo 'Existing' || echo 'Missing'}
  \ifdefstring{\dirstatus}{Existing}%
    {\typeout{*** \string`\jobname.tex' *** Directory `PythonTeX' already exists.}}%
    {\ShellEscape{mkdir PythonTeX}
      \typeout{*** \string`\jobname.tex' *** Directory `PythonTeX' has been created.}}
\fi
\ifmacosx
  \typeout{*** The Operating System is a \macosxname\space box ***}
  \jazzcaptureshell*[\dirstatus]{[ -d ./PythonTeX/ ] && echo 'Existing' || echo 'Missing'}
  \ifdefstring{\dirstatus}{Existing}%
    {\typeout{*** \string`\jobname.tex' *** Directory `PythonTeX' already exists.}}%
    {\ShellEscape{mkdir PythonTeX}
      \typeout{*** \string`\jobname.tex' *** Directory `PythonTeX' has been created.}}
\fi
\ifwindows
  \message{*** The Operating System is \windowsname\space ***}
  %  \usepackage{texosquery}% To be continued... But how?
\fi

%-- Tests for empty or no value arguments, E. Gregorio (aka egreg)
%-----------------------------------------------------------------

%- Detects empty arguments "eTeX way"

\def\ifemptyarg#1{%
  \if\relax\detokenize{#1}\relax % H. Oberdiek
    \expandafter\@firstoftwo
  \else
    \expandafter\@secondoftwo
  \fi}

%- Detects empty arguments "LaTeX3 way"
%- https://tex.stackexchange.com/questions/63223/xparse-empty-arguments

\ExplSyntaxOn% Used by `sidenotes` package but defined by egreg in the above referenced link
% TODO → USE IT TO CLEAN THE CODE FOR/WITH L3 syntax
\DeclareExpandableDocumentCommand{\IfNoValueOrEmptyTF}{ m m m }%
  {\IfNoValueTF{#1}{#2}{\tl_if_empty:nTF {#1} {#2} {#3}}}
\ExplSyntaxOff

%- Global (re)definition of macros with LaTeX syntax (which isn't exist). Enrico Gregorio:
%- https://tex.stackexchange.com/questions/51733/global-renewcommand-equivalent-of-global-def

\def\gnewcommand{\g@star@or@long\gnew@command}
\def\grenewcommand{\g@star@or@long\grenew@command}
\def\g@star@or@long#1{%
  \@ifstar{\let\l@ngrel@x\global#1}{\def\l@ngrel@x{\long\global}#1}}
\def\gnew@command#1{\@testopt{\@gnewcommand#1}0}
\def\@gnewcommand#1[#2]{%
  \kernel@ifnextchar [{\@gxargdef#1[#2]}%
                {\@argdef#1[#2]}}
\let\@gxargdef\@xargdef
\patchcmd{\@gxargdef}{\def}{\gdef}{}{}
\let\grenew@command\renew@command
\patchcmd{\grenew@command}{\new@command}{\gnew@command}{}{}

%-- Options (prospectives TODO → key-value system − PGFOpts/PGFkeys? With a \jazzsetup?)
%---------------------------------------------------------------------------------------

%\newbool{doc@article}
\newbool{doc@english}
\newbool{doc@showframe}
\newbool{doc@askreply}
\newbool{doc@assignpoints}

%- Document type: workbook or handbook
%- See: https://tex.stackexchange.com/questions/36274/defining-a-wrapper-class-for-a-set-of-document-classes
\newif\ifdoc@article\doc@articlefalse
\DeclareOption{workbook}{
  \doc@articletrue
  %\def\jazz@class{article}
  \def\jazz@class{extarticle}
}
\DeclareOption{handbook}{
  \doc@articlefalse
  \def\jazz@class{book}
}

%- Language: French or English
\newif\ifdoc@english\doc@englishfalse
\DeclareOption{english}{
  \doc@englishtrue
}

%- Language: polyglossia or babel system
\newif\ifdoc@polyglossia\doc@polyglossiafalse
\DeclareOption{polyglossia}{
  \doc@polyglossiatrue
}

%- Document licence
\newif\ifdoc@licence\doc@licencefalse
\DeclareOption{licence}{
  \doc@licencetrue
}

%- Layout: invisible or visible
\newif\ifdoc@showframe\doc@showframefalse
\DeclareOption{showframe}{
  \doc@showframetrue
}

%- Displaying or not the used packages (at end of document)
\newif\ifdoc@printfiles\doc@printfilesfalse
\DeclareOption{printfiles}{
  \doc@printfilestrue
}

%- Old fashion: deprecated (to be deleted soon)
\newif\iftypo@full\typo@fullfalse
\DeclareOption{fulltypo}{
  \typo@fulltrue
}

%- Old fashion: deprecated (use "firamath light" font instead)
\newif\iftypo@mathprevious\typo@mathpreviousfalse
\DeclareOption{mathprevioustypo}{
  \typo@mathprevioustrue
}

%- Mathematical font style: upright or italic
\newif\iftypo@mathit\typo@mathitfalse
\DeclareOption{mathit}{
  \typo@mathittrue
}

%- Modelling tools: UML, Merise, etc.
\newif\ifdoc@modelling\doc@modellingfalse
\DeclareOption{modelling}{
  \doc@modellingtrue
}

%- Assignpoints package: exercises/quizzes environments
%\newif\ifdoc@assignpoints\doc@assignpointsfalse
%\DeclareOption{assignpoints}{
%  \doc@assignpointstrue
%}

%- Askreply package: exercises/quizzes environments
%\newif\ifdoc@askreply\doc@askreplyfalse
%\DeclareOption{askreply}{
%  \doc@askreplytrue
%}

%- Embedding files into the PDF: references (.bib), sources (.tex) or images, etc.
\newif\ifdoc@embedding\doc@embeddingfalse
\DeclareOption{embedding}{
  \doc@embeddingtrue
}

%- Suppressing glossaries package warning for final version (too much warnings to deal with...)
\newif\ifdoc@glossnowarn\doc@glossnowarnfalse% DOES NOT WORK!
\DeclareOption{glossnowarn}{
  \doc@glossnowarntrue
}

%\pgfkeys{
%  texjazz-handbook/.cd,
%  showframe/.is if = doc@showframe,% Layout control
%  assignpoints/.is choice,
%  assignpoints/true/.code = \booltrue{doc@assignpoints},
%  assignpoints/false/.code = \boolfalse{doc@assignpoints},
%  assignpoints/.initial = true,
%  askreply/.is choice,
%  askreply/true/.code = \booltrue{doc@askreply},
%  askreply/false/.code = \boolfalse{doc@askreply},
%  askreply/.initial = true,
%}

%\ProcessPgfOptions*
%\ProcessPgfOptions{/texjazz-handbook}

%\newrobustcmd\setjazzhandbook[1]{\pgfqkeys{/texjazz-handbook}{#1}}

%\DeclareOption{9pt}{\renewcommand\@ptsize{9}}
%\DeclareOption{10pt}{\def\@@ptsize{10pt}}
%\DeclareOption{11pt}{\def\@@ptsize{11pt}}
%\DeclareOption{12pt}{\def\@@ptsize{12pt}}

%--- TODO → Avoid option doc@article by defining \chapter even with the article class

%-- Taken from the `appendix' package to check conditionals and inputs
%\newif\if@chapterAppend\@chapterAppendfalse
%\newif\if@knownclassAppend\@knownclassAppendfalse
%\@ifundefined{chapter}{%
%  \@ifundefined{section}{}{\@knownclassAppendtrue}}{%
%  \@chapterAppendtrue\@knownclassAppendtrue}
%\providecommand{\phantomsection}{}
%\newcommand{\@ppendinput}{}
%\if@knownclass@pp\else
%  \ClassWarningNoLine{texjazz-handbook}%
%    {There is no \protect\chapter\space or \protect\section\space command.\MessageBreak
%     The appendix package will not be used}
%  \renewcommand{\@ppendinput}{\endinput}
%\fi
%\@ppendinput

%-- Derived from the `article' (workbook) or `book' (hanbook) classes
%--------------------------------------------------------------------

%- See: https://tex.stackexchange.com/questions/36274/defining-a-wrapper-class-for-a-set-of-document-classes
\ifdoc@article
  \DeclareOption*{\PassOptionsToClass{\CurrentOption}{\jazz@class}}
  %\ExecuteOptions{a4paper,10pt}
  \ExecuteOptions{workbook,a4paper,twoside}
  \ProcessOptions\relax
  %\LoadClass{article}
  %\LoadClass[a4paper,9pt,twoside]{\jazz@class}
  \LoadClass{\jazz@class}
\else
  \DeclareOption*{\PassOptionsToClass{\CurrentOption}{\jazz@class}}
  \ExecuteOptions{handbook,a4paper,twoside,openright}
  \ProcessOptions\relax
  %\LoadClass{book}
  \LoadClass{\jazz@class}
\fi

%-- Tools and facilities
%-----------------------

%- Getting box size
%\RequirePackage{settobox}

%-- Reserving space to keep material from being split over a page break
%\RequirePackage{needspace}

%- Source of the `needspace' package (two commands: no need to load the package)
\newcommand{\needspace}[1]{%
  \begingroup
    \setlength{\dimen@}{#1}%
    \vskip\z@\@plus\dimen@
    \penalty -100\vskip\z@\@plus -\dimen@
    \vskip\dimen@
    \penalty 9999%
    \vskip -\dimen@
    \vskip\z@skip % hide the previous |\vskip| from |\addvspace|
  \endgroup
}
\newcommand{\Needspace}{%
  \@ifstar{\@sneedsp@}{\@needsp@}%
}
\newcommand{\@sneedsp@}[1]{%
  \par \penalty-100\begingroup
  \setlength{\dimen@}{#1}%
  \dimen@ii\pagegoal \advance\dimen@ii-\pagetotal
  \ifdim \dimen@>\dimen@ii
    \break
  \fi\endgroup%
}
\newcommand{\@needsp@}[1]{%
  \par \penalty-100\begingroup
  \setlength{\dimen@}{#1}%
  \dimen@ii\pagegoal \advance\dimen@ii-\pagetotal
  \ifdim \dimen@>\dimen@ii
    \ifdim \dimen@ii>\z@
      \vfil
    \fi
    \break
  \fi\endgroup%
}


%---------------------------------------------------------------------------------------------------
%---- Referencing the document / Référencement du document
%---------------------------------------------------------------------------------------------------

\newif\ifdoc@Ref\doc@Reffalse

%-- New information "fields" about the document
%-----------------------------------------------

\newcommand{\copyrightsymbol}[1]{%
   \def\@copyrightsymbol{#1}%
    \if\relax\detokenize{#1}\relax\else
      \doc@Reftrue
    \fi
}
\copyrightsymbol{}

\newcommand{\copyrightname}[1]{%
  \def\@copyrightname{#1}%
    \if\relax\detokenize{#1}\relax\else
      \doc@Reftrue
    \fi
}
\copyrightname{}

%- Setting a new author reference field
\newcommand{\@authorref}{}
\newcommand{\authorref}[1]{%
  \renewcommand{\@authorref}{#1}%
}

%- Setting a new version document field
\newcommand{\@docversion}{}
\newcommand{\docversion}[1]{%
  \renewcommand{\@docversion}{#1}%
}
\docversion{}
\newcommand{\version}{\@docversion}

\newcommand{\versiondate}[1]{%
  \def\@versiondate{#1}%
    \if\relax\detokenize{#1}\relax\else
      \doc@Reftrue
    \fi
}
\versiondate{}

\newcommand{\typesettinginfo}[1]{%
  \def\@typesettinginfo{#1}%
    \if\relax\detokenize{#1}\relax\else
      \doc@Reftrue
    \fi
}
\typesettinginfo{}

\newcommand{\licenseinfo}{%
  \footnotesize%
  \textsc{\@doctitle} --- \textsc{\@subtitle}\\%
  \textsc{\@author} --- \@copyrightsymbol\space{}\@copyrightname, \@versiondate, \@docversion
}

%-- Referencing commands
%-----------------------

%- Initialization (for front title page or cover with forgotten/no title or author)
\title{}
\author{}
%\date{}

%- Setting the title: optional field for ToC
\newcommand{\@doctitle}{}
\RenewDocumentCommand{\title}{o m}{% option: adding a doctitle (short title or without newline)
  \IfValueTF{#1}
    {\renewcommand{\@doctitle}{#1}\gdef\@title{#2}}% \@title from `latex.ltx'
    {\renewcommand{\@doctitle}{#2}\gdef\@title{#2}}%
}

%- Setting a new subtitle field
\newcommand{\@subtitle}{}
\newcommand{\subtitle}[1]{%
  \renewcommand{\@subtitle}{#1}%
}

%- Attaching and displaying a logotype to the document (title page, etc.)
\newcommand{\doc@logo}{}
\newcommand{\doc@logoscale}{1.0}
\newcommand{\displaylogo}{}
%\newcommand{\doclogo}[1][]{\renewcommand{\doc@logo}{#1}}
%\DeclareDocumentCommand{\doclogo}{o m}{%
%  \IfNoValueTF{#1}{%
%    \renewcommand{\doc@logo}{#2}%
%  }{%
%    \renewcommand{\doc@logoscale}{#1}%
%    \renewcommand{\doc@logo}{#2}%
%  }%
%}
\NewDocumentCommand{\doclogo}{o g}{%
  \IfNoValueTF{#2}{}{%
    \IfNoValueTF{#1}{%
      \renewcommand{\doc@logo}{#2}%
      \renewcommand{\displaylogo}{\includegraphics[scale=\doc@logoscale]{\doc@logo}}%
    }{%
      \renewcommand{\doc@logoscale}{#1}%
      \renewcommand{\doc@logo}{#2}%
      \renewcommand{\displaylogo}{\includegraphics[scale=\doc@logoscale]{\doc@logo}}%
    }
  }
}
\newcommand{\doc@addlogo}{}
\newcommand{\doc@addlogoscale}{1.0}
\newcommand{\displayaddlogo}{}
\NewDocumentCommand{\docaddlogo}{o g}{%
  \IfNoValueTF{#2}{}{%
    \IfNoValueTF{#1}{%
      \renewcommand{\doc@addlogo}{#2}%
      \renewcommand{\displayaddlogo}{\includegraphics[scale=\doc@addlogoscale]{\doc@addlogo}}%
    }{%
      \renewcommand{\doc@addlogoscale}{#1}%
      \renewcommand{\doc@addlogo}{#2}%
      \renewcommand{\displayaddlogo}{\includegraphics[scale=\doc@addlogoscale]{\doc@addlogo}}%
    }
  }
}


%---------------------------------------------------------------------------------------------------
%---- Use of colors / Utilisation des couleurs
%---------------------------------------------------------------------------------------------------

%- Color management
\PassOptionsToPackage{table}{xcolor}% provides commands for colored tabular environments
\RequirePackage{xcolor}

%- Pantone and other color management
%\RequirePackage{colorspace}

%-- Colors definition TODO → Clean all that stuff to match the real needs
%------------------------------------------------------------------------

%\definecolor{white}{RGB}{255,255,255}
\definecolor{purered}{RGB}{255, 0, 0}% HTML: #ff0806 (pure red)
\definecolor{puregreen}{RGB}{0, 255, 0}% HTML: 
\definecolor{pureblue}{RGB}{0, 0, 255}% HTML: 

%- CV colors (`moderncv' package)
\definecolor{darkgraycv}{HTML}{333333}
\definecolor{graycv}{HTML}{4D4D4D}
\definecolor{lightgraycv}{HTML}{999999}

%- LaTeX Colors cf. http://latexcolor.com/
\definecolor{darkcandyapplered}{rgb}{0.64, 0.0, 0.0}
%\definecolor{darkelectricblue}{rgb}{0.33, 0.41, 0.47}% RGB (%): 32.5, 40.8, 47.1
\definecolor{darkelectricblue}{RGB}{83, 104, 120}% HTML: #536878 - CMYK: 31, 13, 0, 53
%\definecolor{darkred}{rgb}{0.55, 0.0, 0.0}
\definecolor{dimgray}{rgb}{0.41, 0.41, 0.41}
%\definecolor{darkgray}{rgb}{0.66, 0.66, 0.66}
\definecolor{darkgray}{RGB}{168, 168, 168}% #a8a8a8ff
%-
\definecolor{green}{HTML}{C2E15F}
\definecolor{orange}{HTML}{FDA333}
\definecolor{purple}{HTML}{D3A4F9}
\definecolor{red}{HTML}{FB4485}
%\definecolor{blue}{HTML}{6CE0F1}
\definecolor{blue}{HTML}{0000FF}% W3C blue
\definecolor{ocre}{RGB}{243,102,25}
\definecolor{jazzblue}{HTML}{003F60}% LFSx101 table blue

%- Linux colors
\definecolor{linuxblue}{HTML}{0D3A63}% Linux Foundation logo dark blue
\definecolor{linuxlightblue}{HTML}{6DBCEA}% Linux Foundation logo light blue

%- Cnam colors
\definecolor{cnamred}{HTML}{BA002A}% Cnam logo red
\definecolor{cnamlightgray}{HTML}{E3DEDA}% Cnam light gray regional logo
\definecolor{cnambrown}{HTML}{796549}% Cnam light gray regional logo

%- ArsClassica and teal green
\definecolor{maroon}{HTML}{AC3535}
%\definecolor{maroon}{cmyk}{0, 0.87, 0.68, 0.32}% RGB 172, 53, 53 ; HTML #AC3535
%\definecolor{webbrown}{rgb}{.6,0,0}% for Web links
\definecolor{webbrown}{HTML}{990000}
\definecolor{teal}{RGB}{0, 128, 128}% medium-satured blue-green
\definecolor{tealblue}{RGB}{54, 117, 136}%

%- Some more gray and others
\definecolor{coldgrey}{RGB}{128, 138, 135}% SVGname
\definecolor{jazzgray}{rgb}{0.66, 0.66, 0.66}
%\definecolor{redbrown}{rgb}{.6, .1, .1}
\definecolor{redbrown}{RGB}{153, 25, 25}% #991919ff
\definecolor{firebrick}{HTML}{B22222}
\definecolor{darkred}{RGB}{139, 0, 0}% #8b0000
\definecolor{GoldDecoration}{RGB}{170, 120, 70}
\definecolor{GoldDecoration}{RGB}{200, 200, 160}

%- Some brown
\definecolor{beaver}{rgb}{0.62, 0.51, 0.44}
\definecolor{brown}{rgb}{0.59, 0.29, 0.0}
\definecolor{burntumber}{rgb}{0.54, 0.2, 0.14}
\definecolor{camel}{rgb}{0.76, 0.6, 0.42}
\definecolor{copper}{rgb}{0.72, 0.45, 0.2}
\definecolor{darkbrown}{rgb}{0.4, 0.26, 0.13}
\definecolor{frenchbeige}{rgb}{0.65, 0.48, 0.36}
\definecolor{lightbrown}{rgb}{0.71, 0.4, 0.11}
\definecolor{lighttaupe}{rgb}{0.7, 0.55, 0.43}
\definecolor{mediumtaupe}{rgb}{0.4, 0.3, 0.28}
\definecolor{palebrown}{rgb}{0.6, 0.46, 0.33}
\definecolor{pastelbrown}{rgb}{0.51, 0.41, 0.33}

%- More brown (from Rossing ed.: Springer Hanbook of Acoustics)
\definecolor{lightchocolate}{RGB}{219, 194, 163}% 
\definecolor{middlechocolate}{RGB}{148, 98, 45}% 
\definecolor{chocolate}{RGB}{183, 141, 94}% 
\definecolor{darkchocolate}{RGB}{113, 63, 14}% 

%- MATLAB "jet" shading color scheme
\definecolor{matlabdarkblue}{RGB}{0, 0, 128}%
\definecolor{matlabblue}{RGB}{0, 0, 255}
\definecolor{matlabcyan}{RGB}{0, 255, 255}
\definecolor{matlabgreen}{RGB}{0, 255, 0}
\definecolor{matlabyellow}{RGB}{255, 255, 0}
\definecolor{matlaborange}{RGB}{255, 10, 0}
\definecolor{matlabred}{RGB}{255, 0, 0}
\definecolor{matlabdarkred}{RGB}{128, 0, 0}


%- yReport
\definecolor{lightGrey}{gray}{0.92}
\definecolor{middleGrey}{gray}{.75}
\definecolor{darkGrey}{gray}{.55}
\colorlet{bigVerticalLineGrey}{lightGrey}% background margin
\definecolor{main-yReportColor}{RGB}{211, 47, 47}
\definecolor{second-yReportColor}{RGB}{255, 193, 7}

%- Awesomebox settings
\definecolor{abnote}{RGB}{25,64,122}% dark blue
\definecolor{abcaution}{RGB}{188,50,0}% brown-yellow
\definecolor{abwarning}{RGB}{188,103,0}% brown-orange
\definecolor{abimportant}{RGB}{188,0,0}% red

%- Ubuntu design (see: https://design.ubuntu.com/brand/colour-palette)
\definecolor{ubuntuorange}{HTML}{E95420}
\definecolor{ubuntulightaubergine}{HTML}{77216F}
\definecolor{ubuntumidaubergine}{HTML}{5E2750}
\definecolor{ubuntudarkaubergine}{HTML}{2C001E}
\definecolor{canonicalaubergine}{HTML}{772953}
\definecolor{ubuntuwarmgrey}{HTML}{AEA79F}
\definecolor{ubuntucoolgrey}{HTML}{333333}

%- Extract from humanity icons (roughly)
\definecolor{ubuntudarkorange}{HTML}{A82711}
\definecolor{ubuntusoftorange}{RGB}{237,163,116}
\definecolor{ubuntugray}{HTML}{BEBEBE}
\definecolor{ubuntugrayicon}{HTML}{969696}

%-- Document colors
%------------------

%- Cover / Front page colors
\colorlet{covercolor}{cnamred}
\colorlet{titlecovercolor}{black}
\colorlet{authorcovercolor}{cnambrown}

%- Layout colors
\colorlet{maincolor}{darkgray}
%\colorlet{maincolor}{linuxblue}
\colorlet{firstcolor}{darkelectricblue}
\colorlet{secondcolor}{redbrown}
\colorlet{thirdcolor}{teal}
\colorlet{fourthcolor}{chocolate}
\colorlet{framecolor}{darkelectricblue}

%- Titling colors
\colorlet{titlingnumbercolor}{darkelectricblue}
%\colorlet{titlingcolor}{darkelectricblue}
\colorlet{titlingcolor}{black}

%- Coloured box settings
\colorlet{boxbackgroundcolor}{black!10}%\colorlet{boxbackgroundcolor}{darkelectricblue}
%\colorlet{boxtitlecolor}{black}
\colorlet{boxtitlecolor}{darkelectricblue}
\colorlet{boxframecolor}{black!5}
\colorlet{lettrinecolor}{darkelectricblue}
\colorlet{itemcolor}{darkelectricblue}

%-- Some more colors simulating IDEs layout
%------------------------------------------

%- Eclipse IDE and Firefox source view (roughly the same conventions)
\definecolor{idesyntaxcolor}{HTML}{7F0055}% Eclipse keyword color (purple)
\colorlet{ideattributecolor}{maroon}% Color for second level attributes (CSS, JavaScript)
%\definecolor{idestringcolor}{HTML}{2A00FF}% Eclipe string color (blue)
\definecolor{idestringcolor}{HTML}{0000FF}% Eclipe string color (blue)
\definecolor{idecommentcolor}{HTML}{3F7F5F}% Eclipe comment color (green-olive)
\definecolor{idemisccolor}{HTML}{0000C0}% Eclipse miscellaneous color (Static Field)
\colorlet{algostringcolor}{brown}
\colorlet{csssyntaxcolor}{maroon}

%- Colors apparently from NetBeans, see below TeX.SE link: FIXME
%- http://tex.stackexchange.com/questions/99500/listings-code-style-for-html5-css-html-javascript
%\definecolor{editorGray}{rgb}{0.95, 0.95, 0.95}
%\definecolor{editorOcher}{rgb}{1, 0.5, 0} % #FF7F00 -> rgb(239, 169, 0)
%\definecolor{editorGreen}{rgb}{0, 0.5, 0} % #007C00 -> rgb(0, 124, 0)

%- Another attempt for HTML+CSS+JavaScript+PHP
%- http://tex.stackexchange.com/questions/252307/specific-color-for-different-tags-and-comments
\definecolor{editorlightgray}{cmyk}{0.05, 0.05, 0.05, 0.1}
%\definecolor{editorGray}{cmyk}{0.6, 0.55, 0.55, 0.2}
\colorlet{editorgreen}{idecommentcolor}
\definecolor{editorpurple}{cmyk}{0.5, 1, 0, 0}
\definecolor{editorwhite}{cmyk}{0, 0, 0, 0}
\definecolor{editorblack}{cmyk}{1, 1, 1, 1}
\definecolor{editororange}{cmyk}{0, 0.8, 1, 0}
\definecolor{editorblue}{cmyk}{1, 0.6, 0, 0}
\definecolor{editorpink}{cmyk}{0, 1, 0, 0}

\newcommand{\inColor}[1]{{\bfseries\color{maincolor}#1}}
%\colorlet{light-gray}{lightGrey}%redefines infoBulle background light-grey to match yReport lightGrey

%-- Old naming system for compatibility TODO-TODO-TODO: only one system!
%-- Couleur principale du document (faire une option print et web)
\newcommand*{\@layoutcolor}{black}% couleur du document (defaut = black)
\newcommand{\layoutcolor}[1]{% définition par l'utilisateur
  \renewcommand{\@layoutcolor}{#1}}

%-- Couleur des titres de sectionnement
\newcommand*{\@titlingcolor}{\@layoutcolor!65}% couleur des titres
\newcommand{\titlingcolor}[1]{% définition par l'utilisateur
  \renewcommand{\@titlingcolor}{#1}}


%---------------------------------------------------------------------------------------------------
%---- Typography settings / Paramétrage des éléments typographiques
%---------------------------------------------------------------------------------------------------

%----- Note about font creation or modification with FontForge and Inkscape
%--------------------------------------------------------------------------
%- Some fonts have to be modified or need a missing glyph (here Canter and Font-mfizz fonts).
%- Some guidelines are given in the following links:
%-  https://fontforge.org/importexample.html
%-  https://www.reddit.com/r/neography/comments/818364/creating_fonts_with_inkscape_and_fontforge_table/
%-  https://www.reddit.com/r/neography/comments/8186cc/creating_fonts_with_inkscape_and_fontforge_part1/
%-  https://www.reddit.com/r/neography/comments/8189bg/creating_fonts_with_inkscape_and_fontforge_part2/
%- Tutorial on Youtube:
%-   Part 1: https://www.youtube.com/watch?v=5O4bIAzbebI
%-   Part 2: https://www.youtube.com/watch?v=AQWamt5KCzQ
%-   Part 3: https://www.youtube.com/watch?v=UUUeogQAjv0
%-   Part 4: https://www.youtube.com/watch?v=MoLrnPm33Ao
%- The "Fira-math" project seems also a good starting point:
%-  https://github.com/firamath/firamath
%-----
%- Exporting font glyphs to SVG files:
%- Open the font you want to export.
%-     Go to File > Execute Script
%-     Paste: SelectWorthOutputting(); foreach Export("svg"); endloop;
%-     Select "FF" radial button.
%-     Hit OK
%- The font files are saved in you user directory ~./.
%-----

%----- Extended font definition (in French)
%------------------------------------------
%- L'intérêt des fontes, plutôt que des pictogrammes ou images, est de pouvoir y faire appel très
%- facilement dans le corps de texte, tout en réglant leur taille et couleur tout aussi aisément.
%- Pour accompagner cette classe de documents, certaines fontes employées doivent être complétées
%- ou reprises. Il s'agit de :
%-   * la fonte "Canter Bold", utilisée pour les titres de partie et de chapitre, qui ne dispose pas
%-     d'apostrophe (39 0x27, U+0027 "quotesingle" APOSTROPHE), ni de tiret semi quadratin − \endash
%-     en LaTeX − (8211 0x2013 − U+0335 "endash" EN DASH) et quadratin, − \emdash en LaTeX −  (8212
%-     0x2014 − U+2014 "emdash" EM DASH). Une nouvelle version "XCanter Bold" a été réalisée.
%-     L'apostrophe est issue de la virgule réhaussée (44 0x2c − U+002C "comma" COMMA) et les tirets
%-     du glyphe de césure (45 0x2d − U+002D "hyphen" HYPHEN-MINUS)
%-     Il en est de même pour la fonte "Canter Light" des sous-titres,
%-   * la fonte "font-mfizz" de logotypes et symboles informatiques complémentaire à Font Awesome
%-     (v4.7 ou 5.12) dont certains glyphes sont trop symplistes ou mal agencés. Une nouvelle
%-     fonte "XFontAwesome" a été créée pour pallier ces manques.
%- Avant de (re)définir un glyphe, pour s'assurer de repartir « à zéro », il faut le supprimer :
%-  * ouvrir le fichier de fonte avec FontForge et sélectionner le glyphe
%-  * dans le menu FontForge, appliquer : Codage > Détacher et supprimer les glyphes
%- Ensuite, après avoir générer les fichiers SVG des glyphes existants de la fonte (cf. supra)
%- et en s'inspirant des dimensions d'autres glyphes (hauteur, largeur, etc.), on reprend ou crée
%- le glyphe avec Inkscape. Pour le sauvegarder, bien l'enregistrer comme "SVG simple" (Plain SVG
%- en anglais) et non comme "SVG Inkscape". Enfin, il suffit d'ouvrir (par double clic) le glyphe
%- de destination sous FontForge sur le fichier.sfd (créé au préalable à partir d'un fichier TTF
%- ou OTF), puis par copier/coller depuis Inkscape, d'insérer le nouveau dessin.
%- À noter que le transfert entre Inkscape et FontForge peut nécessiter des ajustements, notamment
%- en hauteur de positionnement des glyphes.
%- Le fichier opérationnel de la nouvelle fonte se construit en générant la fonte sous FontForge :
%-   Fichier > Générer fonte(s)
%- Des boîtes de dialogue permettent de préciser le type de fonte (TTF ou OTF) et leur emplacement
%- dans l'arborescence.
%- Dans une architecture d'intallation TeXLive, ces fichiers sont à placer :
%-   * pour une utilisation personnelle, dans le répertoire ~/.texmf/fonts/opentype/fontname ;
%-     puis lancer la commande > texhash ~/.texmf pour lister les accès au fichiers contenus
%-     dans cette arborescence (fontes, styles, documentation, etc.)
%-   * pour une exploitation par tous les utilisateurs du système, il faut disposer des droits
%-     d'administration et placer le(s) nouveau(x) fichier(s), par exemple dans le répertoire :
%-     [installdir]/texlive/2019/texmf-dist/fonts/opentype/[public]/fontname
%- Pour que les fontes soient accessibles par le système et d'autres programmes
%- de traitement de texte (typiquement LibreOffice), il faut placer les fichiers de fontes dans :
%-   /usr/share/fonts/opentype/fontname
%- et reconstruire les fichiers de cache pour accéder aux fontes :
%-  > sudo fc-cache -f -v
%- Cette dernière opération peut également se réaliser pour uniquement l'utilisateur courant.
%-----

%-- Loading font stuff (TeXjazz bundle settings: Fira fonts) − Old fashion
%-------------------------------------------------------------------------

%\RequirePackage{texjazz-typography}% Old fashion

%-- Font settings − since 2019, Fira Regular fonts have mathematical glyphs (Fira Light are on work)
%---------------------------------------------------------------------------------------------------

%-- Encoding and UTF-8 font management (LuaLaTeX and XeLaTeX)

%\PassOptionsToPackage{no-math}{fontspec}%
\RequirePackage{fontspec}% Codage et gestion des fontes UTF-8 en natif

%\defaultfontfeatures{Scale = MatchLowercase}

%- Realscripts package is not a good idea: it introduces too large spaces between characters...
%\RequirePackage{realscripts}% In order to have real textsuperscript and textsubscript fonts, if any

%- The new version of fontspec (February 1, 2016, version 2.5a) sets WordSpace globally.
%- The following code permits to locally add WordSpace feature to the current font
%- But no way finding for the moment to reset WordSpace=1 TODO
%- The more efficient way is given below with \spacecontrol command
%\ExplSyntaxOn
%  \__fontspec_keys_define_code:nnn {fontspec-addfeatures} {WordSpace} {}
%\ExplSyntaxOff

%-- Fine tuning of font features: character protrusion, font expansion, interword spacing, etc.

\RequirePackage[activate,final]{microtype}

%- Italic small caps activation
\DeclareMicrotypeSet*{smallcapsi}{
  encoding = {OT1,T1,T2A,LY1,OT4,QX,T5,TS1,EU1,EU2},
  shape    = {sc*,si,scit}
}

%-- Text fonts (see the `fontspec' package documentation)

%----- Note about TeX ligatures
%- TAKE CARE THAT THE FOLLOWING GLOBAL `Ligatures' SETTING IS APPLIED TO MONOSPACED FONTS TOO!
%- FOR EXAMPLE, ">>>" GIVES "»>" IN A PYTHON CONSOLE, BUT SUCH A BEHAVIOUR IS UNWANTED!
%- WE EXPECT THAT IT IS ONLY ALLOWED FOR TEXT FONTS BUT NOT FOR MONOSPACED ONES!
%- \defaultfontfeatures{Ligatures=TeX}
%- THIS MUST CORRECTLY APPLIED TO TYPESET CODE AND/OR FOR PYTHON CONSOLE DISPLAY. SEE `minted'
%- AND 'pythontex' PACKAGES, THE TWICE USING THE PYTHON PYGMENTS LIBRARY.
%- ALTHOUGHT THIS IS THE DEFAULT SETTING FOR \setmainfont AND \setsansfont, WE SET IT EXPLICITLY...
%-----

\ifdoc@article
  %- Main font
  \setmainfont{Fira Sans Light}[% all small caps (historically the Mozilla OS fonts)
  %\setmainfont{FiraGO Light}[% New Fira-Sans fonts development
    Scale = 0.9,
    Ligatures=TeX,
    Numbers=OldStyle,
    BoldFont=Fira Sans Medium,
    ItalicFont=Fira Sans Light Italic,
    BoldItalicFont=Fira Sans Medium Italic
    ]
  %- Sans serif font
  \setsansfont{Fira Sans Light}[
  %\setsansfont{FiraGO Light}[% New Fira-Sans fonts development
    Scale = 0.9,
    Numbers=OldStyle,
    Ligatures=TeX,
    BoldFont=Fira Sans Medium,
    ItalicFont=Fira Sans Light Italic,
    BoldItalicFont=Fira Sans Medium Italic
    ]
  %- Monotype font
  %- Personal Ubuntu Mono : extended with some glyphs from Fira Code / Fira Mono Regular ←↑↓→
  \setmonofont{UbuntuXMono-R.ttf}[%
    Scale=MatchLowercase,
    ItalicFont={UbuntuMono-RI.ttf},
    BoldFont={UbuntuMono-B.ttf},
    BoldItalicFont={UbuntuMono-BI.ttf},
    ]
  %\input{texjazz-size9.clo}
\else
  %- Main font
  \setmainfont{Fira Sans Light}[% all small caps (historically the Mozilla OS fonts)
  %\setmainfont{FiraGO Light}[% New Fira-Sans fonts development
    %Scale = 0.98,
    Ligatures=TeX,
    Numbers=OldStyle,
    BoldFont=Fira Sans Medium,
    ItalicFont=Fira Sans Light Italic,
    BoldItalicFont=Fira Sans Medium Italic
    ]
  %- Sans serif font
  \setsansfont{Fira Sans Light}[
  %\setsansfont{FiraGO Light}[% New Fira-Sans fonts development
    Numbers=OldStyle,
    Ligatures=TeX,
    BoldFont=Fira Sans Medium,
    ItalicFont=Fira Sans Light Italic,
    BoldItalicFont=Fira Sans Medium Italic
    ]
  %- Monotype font
  %\setmonofont{Fira Mono}[% Regular, Medium, Bold FIXME: too large! Scale it or use Incosolata?
  % Scale=0.925,
  %  LetterSpace=0.7,
  %  BoldFont=Fira Mono Medium,
  %  AutoFakeSlant,
  %  BoldItalicFeatures={FakeSlant},
  %  ]
  %\setmonofont{Inconsolatazi4}[% only Regular and Bold, FakeSlant (false Italic) with `fontspec'
    %Scale=1.075,% PAS DE LETTRES GRÈQUES :-(
  %  AutoFakeSlant,
  %  BoldItalicFeatures={FakeSlant},
    % Allows \ttfamily hyphenation: https://tex.stackexchange.com/questions/290731/
    % https://tex.stackexchange.com/questions/87073/scope-of-addfontfeature/87076#87076
    % This is set globaly and not modifiable → Solution: newfont declaration sightly scaled
    %HyphenChar={-}% OK but annoying warnings at complilation time
  %  ]
  %\setmonofont{Ubuntu Mono}[% FakeSlant (false Italic) with `fontspec' if needed
  %  %Scale=0.95,
  %  ItalicFont={Ubuntu Mono Italic},
  %  BoldFont={Ubuntu Mono Bold},
  %  BoldItalicFont={Ubuntu Mono Bold Italic},
  %  ]
  %- Personal Ubuntu Mono : extended with some glyphs from Fira Code / Fira Mono Regular ←↑↓→
  \setmonofont{UbuntuXMono-R.ttf}[%
    %Scale=0.95,
    ItalicFont={UbuntuMono-RI.ttf},
    BoldFont={UbuntuMono-B.ttf},
    BoldItalicFont={UbuntuMono-BI.ttf},
    ]
\fi

%\RequirePackage{newunicodechar}%

%Δ Π Σ Φ Ψ
%α β γ δ ε ζ η θ κ λ μ ν ξ π σ τ υ φ χ ψ ω ϑ

%-- Mathematical fonts

%- Remark: fdsymbol loads the `amsmath' and `textcomp' packages, they are loaded explicitly
%- to possibly pass options to these packages (TEXTCOMP IS NOT NEEDED WITH LuaTeX)

%- Must be loaded before `unicode-math' which redefines some commands
\RequirePackage{amsmath}%

%- Awesome math symbols (!!! incompatible with amsfonts and amssymb !!!)
\RequirePackage{fdsymbol}

%- Typesetting mathematics for physics (extend amsmath macros)
%\RequirePackage{physics}% <-- Leads to too many warnings − TODO: SEE AND FIXME

%- Typesetting tensors (upper/lower indices with correct horizontal spacing)
%\RequirePackage{tensor}

%- Typesetting maths with Unicode characters − Options: math-style=ISO, TeX, french, upright
\iftypo@mathit
  % Layout with "Italic" mathematical glyphs for all letters Latin/Greek
  \RequirePackage[math-style=ISO, bold-style=ISO]{unicode-math}
  %\unimathsetup{math-style=ISO, bold-style=ISO}%, mathup=sym}
\else
  % Layout with "Upright" mathematical glyphs for all letters Latin/Greek (default)
  \RequirePackage[math-style=upright, bold-style=upright]{unicode-math}
  %\unimathsetup{math-style=upright, bold-style=upright}%, mathup=sym}
\fi

%- Fira fonts: only Fira Regular has a complete set of maths glyphs
%\setmathfont{Fira Math Light}% Ordinary glyphs availability
\setmathfont{FiraMath-Regular}% Ordinary glyphs availability (because glyphs set is not complete)
%\setmathfont{FiraMath-Light.otf}% Ordinary glyphs availability
%\setmathfont[range=bfup]{FiraMath-Regular.otf}% Ordinary glyphs availability
%\setmathfont[range={bfup,bfsfup,bfit,bfsfit,bfscr}]{Fira Math Regular}% <-- Does not work! WHY?
\setmathfont[%
  range={up, sfup, it, sfit,% + some glyphs already present in Fira Math Light
         "0023,"0024,"0025,"0026,"0027,"0028,"0029,"002A,"002B,"002C,"002D,"002E,"002F,
         "003A,"003B,"003C,"003D,"003E,"003F,"0040,"005B,"005C,"005D,"005E,"005F,"0060,
         %"007B,"007C,"007D,% curly brackets, pipe: does not work!
         "007E,"00A7,"00F7,"2016,"2044,"2126,"2140,
         "00D7,%"0300,"0301,"0302,"0303,"0304,"0305,"0306,"0307,"0308,"0309,% accents: bad position!
         "2190,"2191,"2192,"2193,"2194,"2195,"2196,"2197,"2198,"2199,% arrows
         "2202,"2205,"2206,"220F,"2210,"2211,"2212,"2213,"2214,"221E,
         "222B,"222C,"222D,"222E,"222F,"2230,% integrales
         "2032,"2033,"2034,"2057,"2035,"2236,"2037,% prime: single, double, etc.
        }
  ]{Fira Math Light}% <-- It does work! But not complete for the moment being... (2020/06)
%\setmathfont[range={}]{FiraMath-Light}
%\let\mathbfup\mathbf

%\RequirePackage[bold=0.001]{xfakebold}% Just to test the features with negive values


%----- Note about the "Fira Math" fonts family
%---------------------------------------------
%- Since the end of 2018, a project (Xiangdong Zeng) has proposed a mathematical character set for
%- the Fira Sans and Fira Go fonts from which it is based. In 2020, the most advanced typeface is
%- the font which weight corresponds to "Fira Math Regular" and it is included to TeXLive. The work
%- is in progress for the other typefaces. To have an idea of what is implemented or missed for the
%- "Fira Math Light" (which is used here), one can have a look to the file "jazz-unicode-math.pdf"
%- which is a new comparison of the more fulfill maths fonts availiable with LaTeX.
%- One may also notice that a "fake" bold Fira Math Regular font has been developed (Herbert Voß).
%- Thus, for the time being, the "Fira Math Light" is used and achieved by other fonts in order
%- to obtain the most used glyphs.
%-----
%- To get the "FiraMath-Light.otf" file, dowload it from:
%-   https://github.com/scikit-hep/mplhep/blob/master/mplhep/fonts/firamath/FiraMath-Light.otf
%- An attempt to compile this font from the sources (FiraMath-Light.sfd) failed :-( TODO: FIXME
%- See: https://github.com/firamath/firamath
%-----

%-- Basic mathematical fonts (already present in TeXLive)

%-----
% PLEASE SEE RECENT THREAD ON TeX.SE (April 2018):
% https://tex.stackexchange.com/questions/425098/which-opentype-math-fonts-are-available/
%
% A Fira Math font is now available and under development! THANKS! Great work!
% See:
%   https://www.ctan.org/pkg/firamath
%   https://github.com/firamath/firamath
%   https://ctan.org/pkg/firamath-otf (Herbert Voß)
%   https://github.com/bBoxType/FiraGO
%
% As of november 2018, only the regular version has from todays update all symbols.
% Herbert Voß extends it to fake bold version with the `firamath-otf' package.
%
% We use the Fira Sans Light version, so see what happens and what is missing?
% As of april 2019 (2019/04/30 → TeXLive 2019 release!), a FiraMath-Light.otf file is availaible!
%-----

%\setmathfont{Fira Math Thin}
%\setmathfont{Fira Math Light}% Pas encore mur... juin 2019
%\setmathfont{Fira Math Regular}
%\setmathfont{Fira Math Bold}
%\setmathfont{Fira Math Medium}
%- Fine fitting: TOO LONG COMPILATION AND TOO MUCH `fontspec' WARNINGS
%\setmathfont{FiraGO-Light}[range = {up,sfup}, Numbers = {Lining, Proportional}]
%\setmathfont{FiraGO-LightItalic}[range = {it,sfit}, Numbers = {Lining, Proportional}]
%\setmathfont{FiraGO-Medium}[range = bfup, Numbers = {Lining, Proportional}]
%\setmathfont{FiraGO-MediumItalic}[range = bfit, Numbers = {Lining, Proportional}]
%\setmathfont{FiraMono-Regular}[range = tt, Scale = MatchLowercase]
%\setmathfont{Inconsolatazi4-Regular}[range = tt, Scale = MatchLowercase]
%\setmathfont{FiraSans-Light}[range = {up,sfup}, Numbers = {Lining, Proportional}]

%-- Setting text font as math text font

%\setmathfont{FiraSans-Light}%[range = {up,sfup}, Numbers = {Lining, Proportional}]

%-----
% To have a fine tuning of the characters, one may redefine them individually, e.g.
% For the record, we have:
% 2212 − 002B + 0028 ( 0029 ) 005B [ 005D ] 2248 ≈ 2249 ≉  007C |
% 2026 … 2202 ∂ 00D7 × 0302   ̂ 2261 ≡ 0025 % 22C5 ⋅ 00B1   ± 2194 ↔ 21D4 ⇔ 2260 ≠
% 20AC € 00A3 £ 0024 $ 00A5 ¥ 2032 ′ 2033 ′′ 2034 ′′′
% 221E ∞ 2190 ← 2191 ↑ 2192 → 2193 ↓ 2243 ≃ 223C ∼ 2208 ∈ 2209 ∉ 221D ∝ 2223 ∣
% 00F7 ÷ 2044 ⁄ 2215 ∕ 002F / 2015 ―
% 003C < (\less) 003D = (\equal) 003E > (\greater) 2264 ≤ (\leq) 2265 ≥ (\geq)
% 2266 ≦ (\leqq) 2267 ≧ (\geqq) 226A ≪ (\ll) 226B ≫ (\gg) 22D8 ⋘ (\lll) 22D9 ⋙ (\ggg)
% 2A7D ⩽ (\leqslant) 2A7E ⩾ (\geqslant)
% 0021 ! 002C , 003A : 003B ; 23B7 ⎷(\sqrtbottom) 221A √ 2211 ∑ 222B ∫
% 22C8 ⋈ (\bowtie) 22B2 ⊲ (\vartriangleleft) 22B3 ⊳ (\vartriangleright)
% 2282 ⊂ (\subset) 2283 ⊃ (\supset) 2284 ⊄ (\nsubset) 2285 ⊅ (\nsupset)
% It works for most symbols below (see `unimath-symbol.pdf')
% See Fira implementation: https://github.com/mozilla/Fira/tree/master/technical%20reports
% TODO: complete Fira fonts in the future with most useful symbols like triangles and bowtie
%-----

%- Previous (2017) mathematical typography previous fitting: a fake Fira-Light maths font
\iftypo@mathprevious% Too much compilation time! Even incomplete, test the font "Fira Math Light"
  \setmathfont{FiraSans-Light}[
    range = {up,sfup,
            "2212,"002B,"0028,"0029,"005B,"005D,"2248,"002F,
            "007C,"2026,"2202,"00D7,"0302,"00B1,"2194,"21D4,"2260,
            "20AC,"00A3,"0024,"00A5,"00F7,"2044,"2215,
            "221E,"2190,"2191,"2192,"2193,"2243,"2015,"0021,"002C,"003A,"003B,
            "003C,"003D,"003E,"2264,"2265,},
    Numbers = {Lining, Proportional}]
  \setmathfont{FiraSans-LightItalic}[range = {it,sfit}, Numbers = {Lining, Proportional}]
  %\setmathfont{FiraSans-Medium}[range = bfup, Numbers = {Lining, Proportional}]
  \setmathfont{FiraSans-Medium}[range = bfup, Numbers = {Lining, Proportional}]
  \setmathfont{FiraSans-MediumItalic}[range = bfit, Numbers = {Lining, Proportional}]
  %\setmathfont{FiraMono-Regular}[range = tt, Scale = MatchLowercase]
  \setmathfont{Inconsolatazi4-Regular}[range = tt, Scale = MatchLowercase]
%\else
%  \setmathfont{Fira Math Light}% Incomplete set, but amazing work for the main needed symbols
\fi

%-- Possible math adaptations (\left\(, \right\), etc.)

\RequirePackage{scalerel}
%- Usage: \scaleleftright[0.8ex]{(}{1+\frac{1}{n}}{)}}

%- New Sum operator definition
%\DeclareMathOperator*{\Sum}{\scalerel*{\Sigma}{\sum}}% First sol. (Steven B. Stegletes)
%\DeclareMathOperator*{\Sum}{\scalerel*{\maltese}{\sum}}
\newcommand{\Sum}{% egreg' working solution
  \mathop{ % we want it to be an operator
    \mathchoice{\dobigSum\huge}%\Large
               {\dobigSum\large}
               {\dobigSum\normalsize}
               {\dobigSum\small}
    }\displaylimits % not necessary, but added for clarity
}
\newcommand{\dobigSum}[1]{%
  \vcenter{#1\kern.2ex\hbox{$\Sigma$}\kern.2ex}}

%- Redefine \log with text font and not mathematical font
%- Original def.: \def\log{\mathop{\operator@font log}\nolimits}
\def\log{\mathop{log}\nolimits}

%-- Set vertical (too large by default) spacing around mathematical environments: \[...\], etc.

%%% !!! TODO-TODO-TODO: bug with `titleps' whith the next codes 1 and 2 below! Why ? Where ?
%- The different solutions are explained in the following discussion as a start entry:
%- http://tex.stackexchange.com/questions/69662/how-to-globally-change-the-spacing-around-equations
%- For mathematical typessetting with LaTeX, a complete documentation is given by Herbert Voß:
%- http://texdoc.net/texmf-dist/doc/latex/voss-mathmode/Mathmode.pdf
%- 1. Redefining the \normalsize macro: IT FAILS!
%\g@addto@macro\normalsize{% Solution with internals (Stefan Kottwitz)
%  \setlength\abovedisplayskip{2pt plus 1pt minus 1pt}%
%  \setlength\belowdisplayskip{2pt plus 1pt minus 1pt}%
%  \setlength{\abovedisplayshortskip}{\z@}
%  \setlength{\belowdisplayshortskip}{\z@}
  %\setlength{\abovedisplayshortskip}{1pt plus .5pt minus .5pt}
  %\setlength{\belowdisplayshortskip}{1pt plus .5pt minus .5pt}
%}
%- 2. Adding stuff to the \normalsize macro: IT FAILS! (seems better not to break \normalsize def.)
%\expandafter\def\expandafter\normalsize\expandafter{% Other sol. with internals (Stefan Kottwitz)
%    \normalsize
%    \setlength\abovedisplayskip{2pt plus 1pt minus 1pt}
%    \setlength\belowdisplayskip{2pt plus 1pt minus 1pt}
%    \setlength\abovedisplayshortskip{\z@}
%    \setlength\belowdisplayshortskip{\z@}
%}
%- 3. With the help of the `etoolbox' package: IT WORKS!
%\apptocmd\normalsize{% Solution with etoolbox.sty (Marco Daniel)
% \abovedisplayskip=2pt plus 1pt minus 1pt
% \abovedisplayshortskip=0pt plus 1pt minus 1pt
% \belowdisplayskip=2pt plus 1pt minus 1pt
% \belowdisplayshortskip=0pt plus 1pt minus 1pt
%}{}{}
%- 4. With the help of the `xpatch' package: IT WORKS TOO!
\ifdoc@article\else
  \RequirePackage{xpatch}
  \xapptocmd\normalsize{% Solution with xpatch.sty (Marco Daniel)
    \abovedisplayskip=4pt plus 1pt minus 1pt
    \abovedisplayshortskip=0pt plus 1pt minus 1pt
    \belowdisplayskip=4pt plus 1pt minus 1pt
    \belowdisplayshortskip=0pt plus 1pt  minus 1pt
  }{}{}
\fi

%-- Defining specific font shapes and sizes

\newfontfamily{\fullglyphfont}{FiraCode-Light}
%[
%       Extension = .otf,
%     UprightFont = *-regular,
%        BoldFont = *-bold,
%      ItalicFont = *-italic,
%  BoldItalicFont = *-bolditalic,
%  ]

\newfontfamily{\lightboldfont}{Fira Sans Regular}[
  Numbers=OldStyle,
  Ligatures=TeX,
  ItalicFont=Fira Sans Italic,
  BoldFont=Fira Sans Medium,
  BoldItalicFont=Fira Sans Medium Italic,
  ]
\newfontfamily{\heavyboldfont}{Fira Sans Heavy}
%- TODO: Add missing glyphs to Canter Bold/Light with FontForge and Inkscape (DONE 2020/03/01)
%- apostrophe (single quote, U+027=39); endash and emdash (cf. § introduction above)
%\newfontfamily{\XCanterFont}{XCanter Bold}[Ligatures=TeX]
%\newfontfamily{\XCanterFont}{XCanter Light}[Ligatures=TeX]
\newfontfamily{\titlefont}{XCanter Bold}[Ligatures=TeX]
\newfontfamily{\subtitlefont}{XCanter Light}[Ligatures=TeX]
\newfontfamily{\titlingfont}{Fira Sans Book}[
  Numbers=OldStyle,
  Ligatures=TeX,
  ItalicFont={Fira Sans Book Italic},
  ]
\newfontfamily{\boxtitlefont}{Fira Sans Book}[
  Scale=1.075,
  LetterSpace=14,
  WordSpace=2,
  Numbers=OldStyle,
  Ligatures=TeX,
  ItalicFont={Fira Sans Book Italic},
  ]
\newfontfamily{\titlingspacedfont}{Fira Sans Book}[
  Numbers=OldStyle,
  Ligatures=TeX,
  ItalicFont={Fira Sans Book Italic},
  LetterSpace=8,% Appel direct, i.e. pas de réglage local avec \tracked, etc. (cf. infra)
  Scale=.999,
  WordSpace=2,
  ]
\newfontfamily{\wordspacedfont}{Fira Sans Light}[
  Numbers=OldStyle,
  BoldFont=Fira Sans Medium,
  ItalicFont=Fira Sans Light Italic,
  BoldItalicFont=Fira Sans Medium Italic,
  %LetterSpace=8,% contrôle avec les commandes ci-après comme \spacedsmallcaps, etc.
  Scale=.999,
  WordSpace=2,
  ]
\newfontfamily{\listingfont}{Fira Mono}[
  %Numbers = Proportional,% NOT AN AVAILIABLE OPENTYPE FEATURE OF THE FONT (`fontspec' warning)
  BoldFont=Fira Mono Medium,
  AutoFakeSlant,
  BoldItalicFeatures={FakeSlant},
  Scale =.999,
  ]
\newfontfamily{\codefont}{Fira Code}[% Fira Mono with ligatures: https://github.com/tonsky/FiraCode
  %Numbers=Proportional,% NOT AN AVAILIABLE OPENTYPE FEATURE OF THE FONT (`fontspec' warning)
  BoldFont=Fira Code Medium,
  AutoFakeSlant,
  BoldItalicFeatures={FakeSlant},
%  Scale=.999,
  ]
%\newfontfamily{codefontAlt}{Inconsolatazi4}[% Regular and Bold, FakeSlant (false Italic) with `fontspec'
%  %Scale=1.075,
%  AutoFakeSlant,
%  BoldItalicFeatures={FakeSlant},
%  ]
%\newfontfamily{\chapternumberfont}{Canter Bold 3D}%{London}%{DiamondsThinItalic}%Abril Fatface}
%\newfontfamily{\chapterFont}{Canter Bold}
%\newfontfamily{\chapterFont}{Jazz Canter Bold}
%\newfontfamily{\serifFont}{Vollkorn}
\newfontfamily{\sectionnumberfont}{Fira Sans Light}[% all small caps
  Numbers=OldStyle,
  BoldFont=Fira Sans Medium,
  ItalicFont=Fira Sans Light Italic,
  BoldItalicFont=Fira Sans Medium Italic,
  ]
\newfontfamily{\tocfont}{Fira Sans Book}[ItalicFont={Fira Sans Book Italic}]
%\newfontfamily{\sectionnumberfont}{Oswald BoldItalic}
%\newfontfamily{\abril}{Abril Fatface}

%- Free SIL-OFL Fraktur fonts with numerals, punctuation and some basic mathematical glyphs
%- See: https://fonts.google.com/specimen/UnifrakturMaguntia
%- Presentation and download: http://unifraktur.sourceforge.net/maguntia.html
%\newfontfamily{\glossaryheaderfont}{UnifrakturMaguntia}
%- Less complete but more readible and stylistic Fracktur font
%- 1001Fonts Free For Commercial Use License (FFC)
%\newfontfamily{\glossaryheaderfont}{Lautenbach Normal}

%- Free SIL-OFL font with numerals, punctuation and some basic mathematical glyphs
%- Chomsky font: a newspaper masthead font in the style of the New York Times masthead
%- See: https://github.com/ctrlcctrlv/chomsky
%- But some glyphs like € are missing and numerical ones must be taken from an other font
%- Really impressive and great work! See other fonts designed by this guy:
%-   Fredrick R. Brennan (<copypaste@kittens.ph>)
%\newfontfamily{\glossaryheaderfont}{Chomsky}
%- The following font seems to be the most readable of Fraktur/medieval fonts we have found
\newfontfamily{\glossaryheaderfont}{Quaerite Regnum Dei}
%- The following font is the more complete one (€ symbol and many others): it's a matter of choice
%\newfontfamily{\glossaryheaderfont}{KJV 1611}

%- For the record, just to test a font before using it
\newcommand{\displayglyphfont}{%
  \begin{raggedright}\glossaryheaderfont
    A B C D E F G H I J K L M N O P Q R S T U V W X Y Z\par
    a b c d e f g h i j k l m n o p q r s t u v w x y z\par
    À É È Ê Ï Ô Ù Æ Œ\par
    à é è ê ï ô ù æ œ\par
    Ç ç\par
    \{ \} ( ) ' " / [ ] \par
    ~ = + - ± | < > ? : ; µ \par% ≠
    0 1 2 3 4 5 6 7 8 9\par
    \copyright \textregistered @ \textparagraph \par
    « » ß ë ‘ ’ € £ \% \& \# \$ \S
    \end{raggedright}
}

%-- Tirets « maison » pour les fontes Canter (incomplètes)
%-- TODO: étendre la fonte (FontForge): DONE 2020/03/01

%\newcommand*{\textemTitle}{-\kern -.2ex -\kern -.2ex -}
%\newcommand*{\textenTitle}{-\kern -.2ex -}
%\newcommand*{\emDashTitle}{-\kern -.2ex -\kern -.2ex -}
%\newcommand*{\enDashTitle}{-\kern -.2ex -}
%\newcommand*{\shortenDashTitle}{-\kern -.3333ex -}

%-- Note typesetting: make sure to end the paragraph (using \par) before leaving the group

\newcommand{\notefontsize}[1]{%
  \@setfontsize\notefontsize\@viiipt{9.5}% \footnotesize=\@viiipt{9.5}
  \abovedisplayskip 1\p@ \@plus.5\p@ \@minus.5\p@
  \abovedisplayshortskip \z@ \@plus1\p@
  \belowdisplayshortskip 1\p@ \@plus.5\p@ \@minus.5\p@
  \belowdisplayskip \abovedisplayskip
  \let\@listi\@listI
  \noindent#1\par%
}

%-- Listings typesetting

\newcommand\lstfontsize{%
  \@setfontsize\normalsize\@viiipt{9.5}% ≈ \footnotesize=\@viiipt{9.5}
    \abovedisplayskip 1\p@ \@plus.5\p@ \@minus.5\p@
    \abovedisplayshortskip \z@ \@plus.5\p@
    \belowdisplayshortskip 1\p@ \@plus.5\p@ \@minus.5\p@
    \belowdisplayskip \abovedisplayskip%
}

%-- Icons and symbols fonts

%\RequirePackage{fontawesome5}% 2019/05/28 v.5.7, cf. icon list: https://fontawesome.com/cheatsheet
%\RequirePackage[fixed]{fontawesome5}% 2020/01/15 v.5.12.0.1
\RequirePackage{fontawesome5}% 2020/01/15 v.5.12.0.1
\RequirePackage{fontawesome}% Fontawesome v4.6: to be loaded after v.5.x to override definitions
\RequirePackage{fontmfizz}% Icones informatiques TTF XeLaTeX (extension fontawesome)
\RequirePackage{xfontawesome}% Icones informatiques OTF LuaLaTeX (extension maison font-mfizz)
\RequirePackage{academicons}% Icones academiques TTF XeLaTeX (extension fontawesome)
\RequirePackage{ccicons}% Creative Commons
\PassOptionsToPackage{os=win}{menukeys}% See: TeX.SX question 237683
\AtEndOfClass{% Recommended to be loaded as the last package, even after `hyperref' package
  \RequirePackage{menukeys}% Keyboard keystroke
  \tikzset{tw@jazzmenus@base/.style={%
    tw@set@tikz@colors,
    rounded corners=0.15ex,
    inner sep=0pt,
    inner xsep=2pt,
    %text height=1.825ex,
    %text depth=0.7ex,
    text height=1.5ex,
    text depth=0.375ex,
    minimum width=1.5em,
    font=\relsize{-1}\sffamily,
    signal,
    signal to=nowhere,
    signal pointer angle=110,
  }}
  \tw@declare@style*{jazzmenus}{%
    %\tikz[baseline={($(tw@node.base)+(0,-0.2ex)$)}]{%
    \tikz[baseline={($(tw@node.base)+(0,-0.07ex)$)}]{%
      \node(tw@node)[tw@jazzmenus@base,signal to=east]%
        {\strut\color{\usemenucolor{txt}}\CurrentMenuElement};}%
  }[\hspace{-0.2em}\hspace{0em plus 0.1em minus 0.05em}]%
  {%
    %\tikz[baseline={($(tw@node.base)+(0,-0.2ex)$)}]{%
    \tikz[baseline={($(tw@node.base)+(0,-0.07ex)$)}]{%
      \node(tw@node)[tw@jazzmenus@base,signal from=west,signal to=east]%
        {\strut\color{\usemenucolor{txt}}\CurrentMenuElement};}%
  }{%
    %\tikz[baseline={($(tw@node.base)+(0,-0.2ex)$)}]{%
    \tikz[baseline={($(tw@node.base)+(0,-0.07ex)$)}]{%
      \node(tw@node)[tw@jazzmenus@base,signal from=west,]%
        {\strut\color{\usemenucolor{txt}}\CurrentMenuElement};}%
  }{%
    %\tikz[baseline={($(tw@node.base)+(0,-0.2ex)$)}]{%
    \tikz[baseline={($(tw@node.base)+(0,-0.07ex)$)}]{%
      \node(tw@node)[tw@jazzmenus@base]{\strut\color{\usemenucolor{txt}}\CurrentMenuElement};}%
  }{gray}
  \tikzset{tw@jazzshadowedkeys@base/.style={% Ajustements des touches sur une interligne normale
    tw@set@tikz@colors,
    rounded corners=0.3ex,
    inner sep=0pt,
    inner xsep=2pt,
    %text height=1.825ex,
    %text depth=0.7ex,
    text height=1.5ex,
    text depth=0.375ex,
    minimum width=1.5em,
    font=\relsize{-1}\sffamily,
    general shadow={%
      shadow xshift=.2ex, shadow yshift=-.15ex,
      fill=\usemenucolor{c},
    },
  }}
  \tw@declare@style@simple*{jazzshadowedkeys}{%
    %\tikz[baseline={($(tw@node.base)+(0,-0.2ex)$)}]{%
    \tikz[baseline={($(tw@node.base)+(0,-0.07ex)$)}]{%
      \node(tw@node)[tw@jazzshadowedkeys@base]%
        {\strut\color{\usemenucolor{txt}}\CurrentMenuElement};%
    }%
  }[%
    \hspace{0.2ex}\hspace{0.1em plus 0.1em minus 0.05em}%
    %\textcolor{\usemenucolor{b}}{\raisebox{0.25ex}{\sffamily\relsize{-2}+}}%
    \textcolor{\usemenucolor{b}}{\raisebox{0.125ex}{\sffamily\relsize{-2}+}}%
    \hspace{0.1em plus 0.1em minus 0.05em}%
  ][\hspace{0.2ex}]{gray}
  \renewmenumacro{\menu}[>]{jazzmenus}% 
  \renewmenumacro{\keys}[+]{jazzshadowedkeys}% https://tex.stackexchange.com/questions/235523/
  \renewmenumacro{\directory}[/]{pathswithblackfolder}% 
}

%- Creative Commons shortcuts

%- SEE ALSO THE `doclicense' package

%\newcommand*{\ccbyncnd}{\ccLogo\ccAttribution\ccNonCommercial\ccNoDerivatives}

%- Compatibility between Font Awesome v.4.6 and v.5.7
%- TODO: select the needed different icons (there is some little differences, e.g. \faKey)
%\let\faVideoCamera\faVideo
%\let\faFilePdfO\faFilePdf
%\let\faThumbTack\faThumbtack
%\let\faExternalLink\faExternalLinkAit
%\let\faEye\faEye
%\let\faFirefox\faFirefox
%\let\faCaretRight\faCaretRight
%\let\faSquareO\faIcon[regular]{square}
%\let\faExclamationTriangle\faExclamationTriangle
%\let\faQuestionCircle\faQuestionCircle
%\let\faInfoCircle\faInfoCircle
%\let\faHtml5\faHtml5
%\let\faCss3\faCss3
%\let\faTag\faTag
%\let\faPencil\faIcon[solid]{pencil-alt}
%\let\faSquare\faSquare
%\let\faComments\faIcon[solid]{comments}
%\let\faAnchor\faIcon[solid]{anchor}
%\let\faQuestion\faicon[solid]{question}
%\let\faUser\faUser
%\let\faKey\faKey
%\let\faMobile\faIcon[solid]{mobile-alt}
%\let\faHome\faHome
%\let\faEnvelopeO\faEnvelope%\faIcon[solid]{envelop}
%\let\faTags\faTags%\faIcon[solid]{tags}
%\let\faBook\faBook%\faIcon[solid]{book}
%\let\faCheck\faCheck%\faIcon[solid]{check}
%\let\faCircleThin\faCircle
%\let\faSignIn\faSignIn%

%- Adding some \faIconName missing in the `fontawesome' 4.6 set but existing in the 5.7 version

%\let\faPython\faIcon[regular]{python}


%--- Fancy typography stuff
%--------------------------

%-- Extending the LaTeX commands \MakeUppercase and \MakeLowercase

\RequirePackage{textcase}% provides \MakeTextUppercase, \MakeTextLowercase and \NoCaseChange

%-- Enlarging letter spacing of caps (full and small) font to emphasize titles without bold font

%\newcommand{\tracked}[1]{{\addfontfeature{LetterSpace=18}#1}}% roman fonts OK
\newcommand{\tracked}[1]{{\addfontfeature{LetterSpace=14}#1}}% Reduced Fira font (ugly results)
\newcommand{\addtracked}[2][]{{\addfontfeature{LetterSpace=#1}#2}}%
% !ERREUR à la compilation avec Wordspace (pour les titres) alors que ça fonctionnait avant!
% Cela vient-il de la fonte utilisée ou de la mise à jour de fontspec 2016/02/01 ? À voir... TODO
% A priori, cela vient de la misee à jour de `fontspec': réglage global désormais
%- http://tex.stackexchange.com/questions/256025/local-application-of-addfontfeature-and-wordspace-x
%\newcommand{\trackedword}[1]{{\addfontfeature{LetterSpace=18,WordSpace={1.8}}#1}}
%\newcommand{\spacedword}[2][]{\bgroup\addfontfeature{WordSpace={#1}}#2\egroup}
%\newcommand{\resetspacedword}{\addfontfeature{WordSpace={1}}}% reset normal WordSpace

%- Il vaut mieux utiliser \spaceskip (Enrico Gregorio - egreg)
\newcommand{\shrinkspace}[1]% espace inter mots serrée
  {\bgroup\spaceskip=0.2pt plus 0.2pt minus 0.1pt\relax#1\egroup}
\newcommand{\stretchspace}[1]% espace inter mots élargi
  {\bgroup\spaceskip=0.2pt plus 0.2pt minus 0.1pt\relax#1\egroup}
%- Proposal from Gonzalo Medina
\newcommand{\adjustspace}[1]% espace inter mots serrée
  %{\spaceskip=1.5\fontdimen2\font plus 1.5\fontdimen3\font minus 1.5\fontdimen4\font}
  {\bgroup\spaceskip=1\fontdimen2\font
    plus 1\fontdimen3\font minus 1\fontdimen4\font\relax#1\egroup}
\newcommand{\adjustedspace}% espace inter mots variable
  {\spaceskip=.8\fontdimen2\font plus 1.2\fontdimen3\font minus 2\fontdimen4\font}

%---
%- La solution ultime est de définir une nouvelle fonte (cf. supra) très légèrement différente
%- (Scale = .999) de manière que cela n'affecte pas les réglages (globaux) de la police initiale
%- http://tex.stackexchange.com/questions/87073/scope-of-addfontfeature (toujours egreg !)
%---

\DeclareRobustCommand{\spacedsmallcaps}[1]{%
  \textsc{\tracked{\titlingspacedfont#1}}%
}
\DeclareRobustCommand{\spacedsfsmallcaps}[1]{%
  \textsc{\textsf{\tracked{#1}}}%
}
\DeclareRobustCommand{\spacedallcaps}[1]{%
  \tracked{\titlingspacedfont\MakeTextUppercase{#1}}%
}
\DeclareRobustCommand{\spacedsfallcaps}[1]{%
  \textsf{\tracked{\MakeTextUppercase{#1}}}%
}
\DeclareRobustCommand{\spacedlowsmallcaps}[1]{%
  \textsc{\tracked{\titlingspacedfont\MakeTextLowercase{#1}}}%
}
\DeclareRobustCommand{\spacedsflowsmallcaps}[1]{%
  \textsc{\textsf{\tracked{\MakeTextLowercase{#1}}}}%
}

%-- Font scaling commands (with shrink-stretch of the \baselineskip)

%\input{texjazz-scalefnt.def}% promptly scale the font (usage: \scalefont{<factor-percentage>})
%- Another solution(?) without add-on: \scalebox{<factor>}{<text>}
%- Full font spacing control. Usage: \spacecontrol{interspace}{stretch}{shrink}{<text>}
\newcommand{\spacecontrol}[4]{%
  \begingroup
    \spaceskip=#1\fontdimen2\font % inter word space
      plus #2\fontdimen3\font % inter word stretch
      minus #3\fontdimen4\font % inter word shrink
      #4% text
  \endgroup%
}

%-- Hacking typographic stuff

%-- TODO: équilibrage des paragraphes pour éviter les "underfull" (manipulation de boites ?)
%- command-to-fill-paragraph-with-repeated-text-alignment-spacing-problem
%- http://tex.stackexchange.com/questions/229556/
%- See: texjazz-hackpar.def

%- TAKE CARE! \verb doesn't work in footnote and float/tabular(x) environments!
%- From: https://tex.stackexchange.com/questions/140616/ (Enrico Gregorio),
%- instead, use the following work-around macro:
\newcommand{\jazzverb}[1]{\texttt{\string#1}}

%- Extend verbatim contents in floats and commands (footnote, sectioning, etc.)
%- Caution! `fancyvrb' is not compatible with `listings' package frames, use it if really needed!
%\RequirePackage{fancyvrb}% provides \Verb, Verbatim environment and more
%- Usage: \section{The \protect\Verb+@interface+ Section}
%- Allow LaTeX (\verb) and `fancyvrb' (\Verb) verbatim contents in footnotes
%\AtBeginDocument{\VerbatimFootnotes}

%- Curly quotation mark characters ` and ' associated with Unicode positions U+2018 and U+2019
%\RequirePackage{upquote}% Only \verb and verbatim for code display, does not affect \tt commands

%- Utilisation de lettrines en entrée de chapitres (for `book' or `report' classes)
\RequirePackage{lettrine}

%- Lettrine aux couleurs du document
\renewcommand{\LettrineFontHook}{\color{lettrinecolor}}

%-- Typesetting shortcuts
%------------------------

%\renewcommand{\emph}[1]{\textcolor{\@titlingcolor}{\itshape\bfseries#1}}
\newcommand{\lightbf}[1]{\bgroup\lightboldfont#1\egroup}
%\newcommand{\lightbf}[1]{\bgroup\titlingspacedfont#1\egroup}
%\let\lightbf\textbf
\newcommand{\emphbf}[1]{\emph{\lightboldfont#1}}
\newcommand{\intextcolor}[1]{\textcolor{\@layoutcolor}{#1}}
%\newcommand{\jazzicon}[1]{\textcolor{firstcolor}{\normalfont #1}}

%- Surrounded number
\newlength{\surroundedwidth}
\settowidth{\surroundedwidth}{\faCircleThin}
%\newcommand{\surroundednumber}[1]{\faCircleThin\hspace*{\surroundedwidth}#1}
%\newcommand{\surroundednumber}[1]{%
%  \makebox[\surroundedwidth][c]{\faCircleThin}%
%  \hspace*{-\surroundedwidth}%
%  \makebox[\surroundedwidth][c]{\tiny#1}%
%}
%\newcommand{\surroundednumber}[1]{\space\makebox[0pt]{\faCircleThin}$#1$}
\newcommand{\surroundednumber}[1]{\textcircled{\raisebox{-0.0pt}{\tiny$#1$}}}
\newlength{\textcirledwidth}
%\settowidth{\textcirledwidth}{\textcircled}
\newcommand{\circledtext}[1]{% \textcircled undefined in Fira: use CM instead (default and warning)
  \normalfont\textcircled{\lightbf{#1}}%
}

\RequirePackage{circledsteps}% Circle/ellipse around text letters: \Circled[]{}

%-- In text title (simulate \paragraph layout)
%---------------------------------------------

\newcommand{\textttl}[1]{\textsc{\titlingspacedfont #1}}
\newcommand{\textsubttl}[1]{\textsc{\titlingspacedfont #1}}
\newcommand{\texttitle}[1]{\vskip 2pt\noindent\normalsize\textttl{#1}\par\vskip\parskip}
\newcommand{\textsubtitle}[1]{\vskip\parskip\noindent\normalsize\textttl{#1}\par}
\newcommand{\intexttitle}[1]{\vskip 2\parskip\noindent\normalsize\textttl{\textit{#1}}}
\newcommand{\intextsubtitle}[1]{\vskip\parskip\noindent\normalsize\textttl{#1}}

%-- In text listing (it's better to use \lstinline from the `listing' package)
%-----------------------------------------------------------------------------

%- Deprecated: the `minted` package is used now

%\newcommand{\textlst}[1]{#1}
%\newcommand{\lstttl}[1]{\textcolor{secondcolor}{\hrulefill}\space%
%            \textttl{#1}\space\textcolor{secondcolor}{\hrulefill}}% Listing title layout

\newcommand{\varstt}[1]{\texttt{\small#1}}


%---------------------------------------------------------------------------------------------------
%---- Text spacing, widow and orphan / Espacements de texte, « veuve et orpheline »
%---------------------------------------------------------------------------------------------------

%-- Interligne dans un paragraphe
%--------------------------------

%\renewcommand{\baselinestretch}{1.05}

%-- Text spacing and indentation (échancrure)
%--------------------------------------------

%- Paragraph spacing
\parskip=0.2\baselineskip \advance\parskip by 0pt plus 1pt minus 1pt
%\parskip\z@ \@plus .3\p@\relax% `book.cls' definition
%\parskip 1ex% not a good idea to have a fixed value
%\parskip 2\p@ \@plus.5\p@ \@minus.5\p@\relax

%- Indentation
%\parindent=16pt% fixed value for titling alignment with the paragraph indentation
%\parindent=\z@% let to be set by the end-user?
\parindent=1.5em % default for French Babel

%- Disable single lines at the beginning of a paragraph
\clubpenalty = 10000

%- Disable single lines at the end of a paragraph
\widowpenalty = 10000
\displaywidowpenalty = 10000 % formulas

%- Penalty for page breaking after hyphenated line
\brokenpenalty=700

%- Prevent overfull lines
%\sloppy

%- Just a copy of the `indentfirst' package (David Carlisle 1995/11/23) to indent all paragraphs
%\let\@afterindentfalse\@afterindenttrue
%\@afterindenttrue


%---------------------------------------------------------------------------------------------------
%---- Document layout / Agencement du document
%---------------------------------------------------------------------------------------------------

%-- Setting general layout
%-------------------------

%- Overall layout
\RequirePackage{geometry}

%- Provides commands/environment according to the page `side' (odd/even)
\RequirePackage[strict]{changepage}

%- Adds commands to put contents according to the current page `side'
\RequirePackage{ifoddpage}% Must be loaded *after* the `changepage' package

%- An analogue of minipage whose width is the natural width of its contents
\RequirePackage{varwidth}

%- Alignement du texte avec césures correctes
\RequirePackage{ragged2e}

%- Arranges marginpars "intelligently" / Automatically adjust the side material nicely
\RequirePackage{marginfix}

%- LaTex3 implementation of sidenotes, for compatibility (clashes because we use same names commands)
%\RequirePackage{sidenotes}

%-- Effective layout application
%-------------------------------

%--- For the record:
%- inner/outer margins = 20mm, marginparwidth = 52mm, marginparsep=8mm,
%- textwidth = 110mm, fullwidth = 170mm
%---

\ifbool{doc@showframe}{%
%\ifdoc@showframe
  \geometry{%
    a4paper, twoside,
    top=27mm, bottom=27mm, inner=20mm, outer=20mm,
    ignorehead, ignorefoot, includemp,
    marginparwidth=52mm, marginparsep=8mm,
    headsep=7mm, headheight=12.2pt, footskip=14mm, showframe
  }
  }{%
%\else
  \geometry{%
    a4paper, twoside,
    top=27mm, bottom=27mm, inner=20mm, outer=20mm,
    ignorehead, ignorefoot, includemp,
    marginparwidth=52mm, marginparsep=8mm,
    headsep=7mm, headheight=12.2pt, footskip=14mm
  }
%\fi
}

%- Layout utility commands: changing the page layout mid-document
\newcommand{\symmetricalpage}{
  \newgeometry{%
    top=27mm, bottom=27mm, inner=20mm, outer=20mm,
    ignorehead, ignorefoot, includemp, nomarginpar,
    headsep=7mm, headheight=12.2pt, footskip=14mm,
  }
}
\newcommand{\appendixpage}{
  \newgeometry{%
    twoside,
    top=27mm, bottom=27mm, inner=20mm, outer=10mm,
    ignorehead, ignorefoot, includemp,
    marginparwidth=36mm, marginparsep=4mm,
    headsep=7mm, headheight=12.2pt, footskip=14mm
  }
}
\newcommand{\referencepage}{
  \newgeometry{%
    twoside,
    top=27mm, bottom=27mm, inner=20mm, outer=20mm,
    ignorehead, ignorefoot, includemp,
    marginparwidth=24mm, marginparsep=8mm,
    headsep=7mm, headheight=12.2pt, footskip=14mm
  }
}
\newcommand{\asymmetricalpage}{\restoregeometry}


%---------------------------------------------------------------------------------------------------
%----    Counter management
%---------------------------------------------------------------------------------------------------

\RequirePackage[figure,table,xspace]{totalcount}% Count figures, tables and others...

\RequirePackage{totcount}% Count total value of counters (not only printing but also internal value)


%---------------------------------------------------------------------------------------------------
%---- New "floating" environments / Nouveaux environments de flottant : video, etc.
%---------------------------------------------------------------------------------------------------

%-- Creating new floats / Création de nouveaux flottants
%-------------------------------------------------------

%-- Floats inside text core: figure, table (and others with the 'newfloat' package below)

%- If the `float' package is used, the `wrapfig' package has to be loaded after the `float' package
%- and the both before declaring a newfloat type
\RequirePackage{wrapfig}

%----- Agencement des figures dans le corps de texte / Arrange figures and graphics in the text body
%- Syntax: \begin{wrapfigure}[12]{r}[34pt]{5cm}<figure>\end{wrapfigure}
%- [number of narrow lines]{placement}[overhang]{width}
%- If the text is less height than the figure, insert the whole in a group:
%- \begingroup <wrapfigure> <text sfuff> \vfill\endgroup (see doc. p.1 "idiosyncrasies #2")
%-----

\setlength{\intextsep}{0pt}% gap at the top and bottom: default=12.0pt plus 2.0pt minus 2.0pt
\setlength{\columnsep}{8pt}% (like \marginparsep) gap between wrapped figure and the text: default=10pt
%\setlength{\wrapoverhang}{\marginparwidth}% figure in margin
%\addtolength{\wrapoverhang}{\marginparsep}

%-- New floating environments (with the `newfloat' package, part of the `caption' bundle)

\RequirePackage{newfloat}% Helper package

%- New floats

\DeclareFloatingEnvironment[% Graphic environment
  name=graphic,
  placement=hbt,
  within=none,
]{graphic}

%\DeclareFloatingEnvironment[within=none]{duplicata}
%\DeclareFloatingEnvironment[within=none]{training}

\ifdoc@article
  \DeclareFloatingEnvironment[% Video environment
    fileext=lov,
    listname={List of Videos},
    name=video,
    placement=hbt,
    within=none,%section
  ]{video}
\else
  \DeclareFloatingEnvironment[% Video environment
    fileext=lov,
    listname={List of Videos},
    name=video,
    placement=hbt,
    within=chapter,
  ]{video}
\fi

%\ifdoc@article
%\DeclareFloatingEnvironment[% Listing environment: already defined by the `minted' package below
%  fileext=lol,
%  listname={List of Listings},
%  name=listing,
%  placement=hbt,
%  within=none,
%]{listing}
%\else
%\DeclareFloatingEnvironment[% Listing environment: already defined by the `minted' package below
%  fileext=lol,
%  listname={List of Listings},
%  name=listing,
%  placement=hbt,
%  within=chapter,
%]{listing}
%\fi

\ifdoc@article
  \DeclareFloatingEnvironment[% Code environment: must be define to use \captionof and wrapfig
    fileext=loc,
    listname={List of Codes},
    name=code,
    placement=hbt,
    within=none,
  ]{code}
\else
  \DeclareFloatingEnvironment[% Code environment: must be define to use \captionof and wrapfig
    fileext=loc,
    listname={List of Codes},
    name=code,
    placement=hbt,
    within=chapter,
  ]{code}
\fi

%- Default placement of floats (figures and tables are already defined by article and book classes)

\SetupFloatingEnvironment{figure}{placement=hbt}
\SetupFloatingEnvironment{table}{placement=hbt}
\SetupFloatingEnvironment{graphic}{placement=hbt}
\SetupFloatingEnvironment{code}{placement=hbt}

%----- Defining a movie floating environment like e.g. figure (from book.cls)
%- FAR TOO COMPLEX FOR THE MOMENT BEING! STILL LACK OF SKILLS → use the 'newfloat' package
%- See:
%-  − https://tex.stackexchange.com/questions/32359/what-is-the-exact-purpose-of-ftypetype
%-  − https://tex.stackexchange.com/questions/113631/[...]
%-      [...]caption-placement-for-new-float-in-tufte-book-class
%-----

%----- Allowing more floats processing (default maximum = 18 floats)
%- The use of the `morefloats' package is no more usefull, because the new eTeX kernel (> 2015/01)
%- controls the extended allocation mechanism (see egreg's answer referenced below).
%- Cf. http://tex.stackexchange.com/questions/38607/no-room-for-a-new-dimen/38609#38609
%- Older ref.: http://tex.stackexchange.com/questions/1650/[...]
%-   [...]too-many-unprocessed-floats-with-marginpar
%-----

\extrafloats{500}% Maximum of float processings (up to 256?)

%-- Placement et rotation des flottants / Floats placing and rotating
%--------------------------------------------------------------------

%----- Several solutions
%- 0. placeins.sty -> keeps floats ‘in their place’, preventing them from floating past
%-     a “\FloatBarrier” command into another section. To use it, insert “\FloatBarrier”
%-     at places that floats should not move past, perhaps at every “\section”.
\RequirePackage{placeins}
%- 1. float.sty -> creation et placement de nouveaux flottants (option H pour HERE expressement,
%-     incompatible avec les options hbtp des flottants natifs LaTeX)
%\RequirePackage{float}
%- 2. afterpage.sty -> put instructions after the current page like: \afterpage{\clearpage}
\RequirePackage{afterpage}
%- 3. rotating.sty -> rotation d'objets et rotfloat.sty -> rotation de flottants
%\RequirePackage{rotating}
%\RequirePackage{rotfloat}
%- 4. floatrow.sty -> inclut le code de base de float.sty/rotfloat.sty et propose d'autres
%-     fonctionnalités comme le placement des légendes, notamment dans la marge (doc très confuse)
%\RequirePackage{floatrow}% Incompatible avec float.sty et rotfloat.sty car fonctionnalités incluses
%\floatsetup{margins=hangleft,capposition=beside,
%            capbesideposition={top,left},floatwidth=\textwidth}
%-----


%---------------------------------------------------------------------------------------------------
%---- Code listings  / Listings de code de programmation
%---------------------------------------------------------------------------------------------------

%- Substantially extending the `verbatim' environment

%\RequirePackage{fancyvrb}% Used by minted, see below


%---- Code listings typesetting with the `listings' package
%----------------------------------------------------------

%%%%% WAY TOO COMPLEX! SIMPLIFY THIS STUFF AND, CERTAINLY BETTER, SWITCH TO MINTED! %%%%%
%%%%% WITH MINTED, ONE IS ABLE TO MIX HTML+PHP AND SO ON. FOR NOW ON, IT IS A MUST! %%%%%
%%%%% But the moment being, we kepp the twice for convenience. `listings' package   %%%%%
%%%%% is easier to custom                                                           %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%\RequirePackage{listings}% also loaded by the `tcolorbox' package (see above previous section)
%\g@addto@macro\lst@setcatcodes{\catcode`\"=12 }% cf. TeX.SX egreg

%-- Input language (re)definitions styles and environments

%- Code style definitions

%\input{texjazz-listings.def}

% Code environment definitions (with `tcolorbox': so, to be loaded later)

%\input{texjazz-code-listings.def}


%---- Code listings typesetting with the `minted' package
%--------------------------------------------------------

%%%%% MUCH MORE POWERFUL! BASED ON PYGMENTS PYTHON PROGRAM (OVER THAN 300 LANGUAGES SUPPORTED) %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----- Caution!
%- The `minted' package, due to its depency with the Pygments library, needs the "-shell-escape"
%- option to be enable when running LaTeX, for example: > lualatex -shell-escape file.tex
%- But, firstly, `pygmentize' must be installed: synaptic (python3-pip, python3-pygments) or pip.
%-----
%- UBUNTU MATE 20.04: A LINK FROM PYTHON TO PYTHON3 *MUST BE DONE* IN /bin (AND MAYBE /usr/bin)
%- IN ORDER TO USE minted, tcolorbox WITH minted AND PythonTeX WITH PYTHON3:
%-   > sudo ln -s /bin/python3 /bin/python
%-----

\ifdoc@article
  \PassOptionsToPackage{section,newfloat=true}{minted}
\else
  \PassOptionsToPackage{chapter,newfloat=true}{minted}
\fi
\RequirePackage{minted}% also loaded by the `tcolorbox' package (see below)

%\usemintedstyle[python]{tango}
\setminted[python]{style=jazzcode}
%\setmintedinline[python]{style=ipythonjazz}

%----- Note about listings with the `minted' package
%---------------------------------------------------
%- Be aware that, by default, the `minted' package defines a "listing" floating environment,
%- with the help of the `float' (default) or `newfloat' packages. So, no need to define one here.
%- By default, the float package is used (option "newfloat=false"), but the `newfloat' package
%- is much more powerful (option "newfloat=true").
%- This has to be taken into account when one is defining code environments with their associated
%- counters and captions (see below).
%- The `minted' settings are (see minted source):
%-   environment name = listing (\floatname{listing}{\listingscaption}),
%-   default placement = tbp,
%-   list of listings file extension = lol,
%-   listing caption name = Listing (\newcommand{\listingscaption}{Listing}),
%-   list of listings name = "List of Listings".
%- With the `float' package, \listoflistingscaption must be refined, from:
%-   \newcommand{\listoflistingscaption}{List of Listings})
%-   \providecommand{\listoflistings}{\listof{listing}{\listoflistingscaption}}
%- to:
%-   \renewcommand{\listoflistingscaption}{\listlistingname})
%-   \renewcommand{\listoflistings}{% \renewcommand because defined by the 'minted' package
%-      %\tcblistof[\chapter*]{loc}{\listlistingname}%
%-      \chapter*{\listlistingname}
%-      \@starttoc{lol}
%-   }
%- Nothing has to be done with the `newfloat' package (TeXjazz-handbook class already use it).
%- Unfortunately, the `tcolorbox' package loads the `minted' package without option at all (see
%- /opt/texlive/2019/texmf-dist/tex/latex/tcolorbox/tcbminted.code.tex loaded with the command
%- \tcbuselibrary{minted} as below). So, `minted' MUST BE LOADED BEFORE `tcolorbox' or with
%- the command \PassOptionsToPackage{newfloat=true}{minted} STILL BEFORE `tcolorbox' load.
%- Consequently, TeXjazz handbook class is setting up two main code listing environments:
%-   1. A "listingbox" environment which supersedes the "minted" environment. It has to be used
%-      inside the floating "listing" environment, namely the "listing" environment remains a float
%-      and its placement may be tricky to adjust for long listings. The caption and label, if any,
%-      have to be given within the "listing" environment.
%-   2. A new "code" environment, only based on "tcblisting" environment.
%- These environments are both similar and full line width printed, but their using purpose differs.
%- The "listing" environment is designed to display "full or important" code relatively short.
%- The availiable features are: caption and entry in the list of listings, no title,
%- icon for the code language (both in the margin separation − right at the top of the listing −
%- and in the list of listings), lines of code numbering.
%- The preferable "code" environment (despite its more french name) is designed to display as well
%- as "full or important" (nevermind its length) and "parts or snippets" of code. Its features are
%- the same as for the "listing" environment plus:
%- numbering lines or not, title or not, caption or not, title or not (default = nonumber + notitle
%- + nocaption), if a title is given without a caption, an entry in the list of codes is generated.
%- For both these environments, a icon/symbol for the code language is displayed both in the margin
%- and in the caption within the list of codes.
%-----

%- If the `float' package is used by `minted'
%\ifminted@newfloat\else
%  \newcommand{\listingscaption}{\listingname}% \listingname is defined below
%  %\floatname{listing}{\listingscaption}
%  \newcommand{\listoflistingscaption}{\listlistingname}% \listlistingname is defined below
%  %\providecommand{\listoflistings}{\listof{listing}{\listoflistingscaption}}% Redefined below
%\fi

%- Default placement of the floating "listing" environment

\SetupFloatingEnvironment{listing}{placement=hbt}


%---------------------------------------------------------------------------------------------------
%---- New "non floating" environments / Nouveaux environments « fixes » : figure, table, etc.
%---------------------------------------------------------------------------------------------------

%-- All the following environments are defined to easily and automatically detect their presence
%-- and for assigning their caption in their respectve "List of..." (see below)

%-- Fixed "figure-like" environment

\NewDocumentEnvironment{jazzfigure}{  }
  {\captionsetup{type=figure}}{}

\NewDocumentEnvironment{jazzfigure*}{  }
  {\begin{fullwidth}\captionsetup{type=figure}}%
  {\end{fullwidth}}

%-- Fixed "table-like" environment

\NewDocumentEnvironment{jazztable}{  }
  {\captionsetup{type=table}}{}

\NewDocumentEnvironment{jazztable*}{  }
  {\begin{fullwidth}\captionsetup{type=table}}%
  {\end{fullwidth}}

%-- Fixed "code-like" environment

\NewDocumentEnvironment{jazzcode}{  }
  {\captionsetup{type=code}}{}

\NewDocumentEnvironment{jazzcode*}{  }
  {\begin{fullwidth}\captionsetup{type=code}}%
  {\end{fullwidth}}

%-- Fixed "listing-like" environment

\NewDocumentEnvironment{jazzlisting}{  }
  {\captionsetup{type=listing}}{}

\NewDocumentEnvironment{jazzlisting*}{  }
  {\begin{fullwidth}\captionsetup{type=listing}}%
  {\end{fullwidth}}

%-- Fixed "graphic-like" environment

\NewDocumentEnvironment{jazzgraphic}{  }
  {\captionsetup{type=graphic}}{}

\NewDocumentEnvironment{jazzgraphic*}{  }
  {\begin{fullwidth}\captionsetup{type=jazzgraphic}}%
  {\end{fullwidth}}



%---------------------------------------------------------------------------------------------------
%---- Document localization language / Francisation du document
%---------------------------------------------------------------------------------------------------

%-- Choix du système utilisé / Language system in use

%----- Important note
%- As for TeXLive 2019, the `polyglossia` package v.1.44 leads to compilation errors for French
%- spaced ponctuation, like ; : ! ? and guillemets « ». This was not the case with the 2018 release
%- V.1.43 (please note that they seem to be the same after a comparison beetween the two releases).
%- Because with LuaLaTeX, it seems that the `babel' package give better results we go back and
%- use this latter.
%-----

\ifdoc@polyglossia
  % IS THERE A BUG WITH TEXLIVE2019? MANY ISSUES LIKE NO MORE UTF8 GUILLEMETS...
  %\RequirePackage{texjazz-polyglossia}% 2018 release: that works fine
  \RequirePackage{polyglossia}% TODO: adapting list vertical spacing (itemize, enumerate...)
  %\input{texjazz-frenchb.def}% Old `babel' system settings
  %
  %- Redifining footnote layout (from polyglossia bundle, `gloss-french.ldf' file)²
  %\ifx\@makefntext\undefined\else
  %\long\def\@makefntext#1{\large\@thefnmark.\quad #1}
  %\renewcommand\@makefntext[1]{\large\@thefnmark.\quad #1}
  %\renewcommand\@makefntext[1]{\quad\ifx\@thefnmark\empty\else\@thefnmark.\space\fi #1}
  %\fi
  %
  %--- French polyglossia issue (part counter)
  %- greek-text-suppresses-roman-numbers:
  %- https://tex.stackexchange.com/questions/374496/
  %- remove-space-before-polyglossias-french-parts-in-toc:
  %- https://tex.stackexchange.com/questions/375310/
  %- polyglossia-and-toc:
  %- https://tex.stackexchange.com/questions/144383/
  %- parts-not-working-when-using-multiple-languages-with-polyglossia:
  %- https://tex.stackexchange.com/questions/291586/
  %---
  %
  %- Take care that `polyglossia/gloss-french.ldf' package sets \partname to empty: \def\partname{}
  %- Fix/avoid the French setup of \def\thepart{}
  \patchcmd{\captionsfrench}{\def\thepart{}}{}{}{}
  \patchcmd{\captionsfrench}
    {\def\partname{\protect\@Fpt partie}}
    {\def\partname{Partie}}
    {}{}
  \AtBeginDocument{% Polyglossia sets \def\thepart{}
    \renewcommand{\thepart}{\Roman{part}}% The numbering must be done after \selectlanguage
    \def\partname{\protect\@Fpt partie}
  }
  %- Language selection
  \ifdoc@english
    \setdefaultlanguage{english}
    \setotherlanguage{french}
    %\PolyglossiaSetup{english}{indentfirst=false}
  \else
    \setdefaultlanguage{french}% French is the default language
    \setotherlanguage{english}% Needed to automatically switch to English bibliographic entries
    %\PolyglossiaSetup{french}{indentfirst=false}
    %- Modifying or extending captions and date formats: see `gloss-french.ldf' file
    %\gappto\captionsfrench{\renewcommand{\contentsname}{Sommaire}}% defaut=Table des matières
    \gappto\captionsfrench{\renewcommand{\listfigurename}{Liste des figures}}% defaut=Table des figures
    \gappto\captionsfrench{\renewcommand{\listtablename}{Liste des tableaux}}% defaut=idem
    \gappto\captionsfrench{\renewcommand{\figurename}{Figure}}% default=\def\figurename{\textsc{Fig.}}
    \gappto\captionsfrench{\renewcommand{\tablename}{Table}}% default=\def\tablename{\textsc{Tab.}}
    \gappto\captionsfrench{\renewcommand{\appendixname}{Annexe}}% default=Annexe
    %- Better French expression for text numbering of parts
    \gappto\captionsfrench{
      \renewcommand{\@Fpt}{%
        \ifcase\value{part}\or Première\or
          %\ifnum\value{part} > 2 Deuxième\else Seconde\fi\or
          Deuxième\or
          Troisième\or Quatrième\or Cinquième\or Sixième\or
          Septième\or Huitième\or Neuvième\or Dixième\or Onzième\or
          Douzième\or Treizième\or Quatorzième\or Quinzième\or
          Seizième\or Dix-septième\or Dix-huitième\or Dix-neuvième\or Vingtième
        \fi\space
      }%
    }%
  \fi
  %- New names and/or explicitly redefining names
  \ifdoc@english
    \renewcommand{\codename}{Code}% \renewcommand if already defined with the 'newfloat' package
    \renewcommand{\listingname}{Listing}% \newcommand if not defined by 'minted' (newfloat=false)
    \newcommand{\documentname}{Document}
    \newcommand{\exercisename}{Exercise}
    \newcommand{\quizname}{Quiz}
    \renewcommand{\videoname}{Video}% Already defined with the 'newfloat' package
    \newcommand{\listcodename}{List of Codes}% \renewcommand if already defined with 'newfloat'
    \renewcommand{\listlistingname}{List of Listings}% \newcommand if not defined by 'minted'
    \newcommand{\listdocumentname}{List of Documents}
    \newcommand{\listexercisename}{List of Exercises}
    \newcommand{\listquizname}{List of Quizzes}
    \renewcommand{\listvideoname}{List of Videos}% Already defined with the 'newfloat' package
  \else
    \renewcommand{\codename}{Code}% \renewcommand if already defined with the 'newfloat' package
    \renewcommand{\listingname}{Listing}% \newcommand if not defined by 'minted' (newfloat=false)
    \newcommand{\documentname}{Document}
    \newcommand{\exercisename}{Exercice}
    \newcommand{\quizname}{Quiz}
    \renewcommand{\videoname}{Vidéo}% Already defined with the 'newfloat' package
    \renewcommand{\listcodename}{Liste des codes}% \renewcommand if already defined with 'newfloat'
    \renewcommand{\listlistingname}{Liste des listings}% \newcommand if not defined by 'minted'
    \newcommand{\listdocumentname}{Liste des documents}
    \newcommand{\listexercisename}{Liste des exercices}
    \newcommand{\listquizname}{Liste des questionnaires}
    \renewcommand{\listvideoname}{Liste des vidéos}% Already defined with the 'newfloat' package
  \fi
  %- Removing French ponctuation locally (Polyglossia)
  \newcommand{\nofrspace}[1]{\nofrench@punctuation{#1}}
  %-------------------------------------------------------------------------------------------------
\else% If French typessetting system is Babel French (seems to be better with BibLaTeX: TeXSE)
  %- Attention ! Les caractères rendus actifs par babel-french (;:!?) peuvent perturber certaines
  %- extensions, c’est le cas de tikz, xcolor, cleveref par exemple. Voir solutions : doc. §6.
  \ifdoc@english
    \RequirePackage[french, english]{babel}%
    \selectlanguage{english}
  \else
    \RequirePackage[english, french]{babel}%
    \selectlanguage{french}
  \fi
  %\frenchsetup{}% TODO
  %-- New names and/or explicitly redefining names
  \ifdoc@english
    \renewcommand{\codename}{Code}% \renewcommand if already defined with the 'newfloat' package
    \renewcommand{\listingname}{Listing}% \renewcommand if already defined with 'minted'
    \newcommand{\documentname}{Document}
    \newcommand{\exercisename}{Exercise}
    \newcommand{\quizname}{Quiz}
    \renewcommand{\videoname}{Video}% Already defined with the 'newfloat' package
    \renewcommand{\listcodename}{List of Codes}% \renewcommand if already defined with 'newfloat'
    \renewcommand{\listlistingname}{List of Listings}% \newcommand because not defined by 'minted'
    \newcommand{\listdocumentname}{List of Documents}
    \newcommand{\listexercisename}{List of Exercises}
    \newcommand{\listquizname}{List of Quizzes}
    \renewcommand{\listvideoname}{List of Videos}% Already defined with the 'newfloat' package
  \else
    \renewcommand{\frenchlistfigurename}{Liste des figures}% Default = Table des figures! Ugly!
    \renewcommand{\codename}{Code}% \renewcommand if already defined with the 'newfloat' package
    \renewcommand{\listingname}{Listing}% \renewcommand if already defined with 'minted'
    \newcommand{\documentname}{Document}
    \newcommand{\exercisename}{Exercice}
    \newcommand{\quizname}{Quiz}
    \renewcommand{\videoname}{Vidéo}% Already defined with the 'newfloat' package
    \renewcommand{\listcodename}{Liste des codes}% \renewcommand if already defined with 'newfloat'
    \renewcommand{\listlistingname}{Liste des listings}% \newcommand if not defined by 'minted'
    \newcommand{\listdocumentname}{Liste des documents}
    \newcommand{\listexercisename}{Liste des exercices}
    \newcommand{\listquizname}{Liste des questionnaires}
    \renewcommand{\listvideoname}{Liste des vidéos}% Already defined with the 'newfloat' package
  \fi
\fi

%-- Textsuperscript : \up, \ieme... from French Babel do not work fine (cf. `realscript' and doc.)

\newcommand{\frup}[1]{\textsuperscript{#1}}

%-- Guillemets, citation, ellipse, exergue

%- We explicity load here the `fvextra' package to avoid warnings from the `lineno' package
%- (these are used by the `minted' package and `fvextra' must be loaded before `csquotes' package)
%\RequirePackage{fvextra}% several extensions and internal patchs to the `fanvrb' package

\RequirePackage[autostyle=true]{csquotes}% provides facilities for inline and display quotations
\ifdoc@english\else
  \setquotestyle[guillemets]{french}
\fi

%-- Nombres avec espacement et séparateur en fonction de la langue

\RequirePackage[autolanguage]{numprint}% (default=german=french OK)
%- Usage: \numprint[N/mm^2]{-123456}
%\newcommand*\npunitcommand[1]{\ensuremath{\mathrm{#1}}}% Original
\renewcommand*\npunitcommand[1]{\ensuremath{\mathsfup{#1}}}% to select text fonts

%- Séparateur des nombres décimaux en français (virgule), voir
%-    https://tex.stackexchange.com/questions/344953/using-decimal-numbers-with-systeme-package
\RequirePackage{siunitx}
\sisetup{output-decimal-marker={,}}% Usage: \num{1.5} or \num{1,5}

%-- Gestion des dates

\RequirePackage{datetime2}% provides advanced features for managing and printing date and time

\ifdoc@english
  \newcommand{\monthThreeLetterName}{%
  \ifcase\the\month
  \or Jan% 1
  \or Feb% 2
  \or Mar% 3
  \or Apr% 4
  \or May% 5
  \or Jun% 6
  \or Jul% 7
  \or Aug% 8
  \or Sep% 9
  \or Oct% 10
  \or Nov% 11
  \or Dec% 12
  \fi
}
\else
  \newcommand{\monthThreeLetterName}{%
  \ifcase\the\month
  \or Jan% 1
  \or Fév% 2
  \or Mar% 3
  \or Avr% 4
  \or Mai% 5
  \or Jui% 6
  \or Jul% 7
  \or Aou% 8
  \or Sep% 9
  \or Oct% 10
  \or Nov% 11
  \or Déc% 12
  \fi
}
\fi
\DTMnewdatestyle{dayNumberOnTwoDigit}{%
  %\renewcommand*{\DTMdisplaydate}[4]{\DTMtwodigit{##3}-\DTMtwodigits{##2}-##1}%
  \renewcommand*{\DTMdisplaydate}[4]{\DTMtwodigits{##3}}%
  \renewcommand*{\DTMDisplaydate}{\DTMdisplaydate}
  %\DTMtwodigit{\THEDAY}
}
\AtBeginDocument{\let\today\DTMtoday}


%---------------------------------------------------------------------------------------------------
%---- Graphics tools
%---------------------------------------------------------------------------------------------------

%-- Graphic contents management
%------------------------------

%- Inserting external graphical elements
\RequirePackage{graphicx}
%\DeclareGraphicsExtensions{.pdf,.png,.jpg,.eps}

%- Inserting external graphical elements in SVG format (use of Inkscape)
%\RequirePackage{svg}

%\RequirePackage[off]{svg-extract}

%-- Very old fashion (last century!)

%\RequirePackage{epstopdf}% converting eps to pdf files from LaTeX source file
%\epstopdfDeclareGraphicsRule{.eps}{pdf}{.pdf}{% ps2pdf software instead of epstopdf.pl
%  ps2pdf -dEPSCrop #1 \OutputFile
%}
%\epstopdfsetup{outdir=./}

%\RequirePackage{eso-pic}% adding some picture commands to every page at absolute positions

%- Shortcut to include graph file in text (useless: to be deleted)
%\newcommand{\jazzgraph}[2][width=\linewidth,draft=false]{% arg1=options ; arg2=graph-filename
%  \begingroup
%  \centering\vspace{2.5\parskip}% no `\vspace*' (no space at the start at the top of a newpage)
%  \includegraphics[#1]{#2}%
%  \vspace{2.5\parskip}%
%  \endgroup%
%}

%-- TeX PGF/TikZ graphic composing
%---------------------------------

%- Graphic composition
\RequirePackage{tikz}

%- Inserting external graphical TikZ pictures
%\RequirePackage{tikzscale}
%\RequirePackage{incgraph}% From Thomas F. Sturm (author of the `tcolorbox' package)

%- Providing relative nodes to the `current page' (loads `ifoddpage')
\RequirePackage{tikzpagenodes}% From Martin Schärrer

%- Providing vectorian symbols with TikZ (may be used in ToC/TdM)
\RequirePackage{pgfornament}%

%-- TikZ/PGF settings
%--------------------

%----- Interesting readings
%- https://tex.stackexchange.com/questions/89773/how-can-i-create-new-commands-in-tikz
%-----

%- TikZ libraies loading
%- See: https://tex.stackexchange.com/questions/42611 → list-of-available-tikz-libraries
\usetikzlibrary{
  angles,%
  arrows,% arrow styles library
  arrows.meta,% arrow styles library
  %animations,% DOES NOT WORK! WHY? changes the appearance of some part of a graphic over time
  backgrounds,% background management e.g. see http://tex.stackexchange.com/questions/78731/
  bending,
  calc,% Calculations
  %calendar,% calendar display
  chains,% chained nodes
  circuits.logic.US,
  er,% Entity Relationship diagram library
  fit,% fitting a node so that it contains a set of coordinates
  graphs,% chained nodes with edges
  intersections,% calculate intersections of paths
  trees,% to display trees, see the tikz-qtrees package and the very powerful forest package
  %mindmap,% mindmap display
  %decorations.markings,
  decorations.pathmorphing,% Decoration add-ons stuff: cf. G. Medina http://tex.stackexchange.com
  decorations.text,
  matrix,% defines additional styles and options for creating matrices
  patterns,% Some graphical patterns
  positioning,% advanced positioning of nodes
  %shapes,% Doc. says: [...] provided for compatibility only. [...] include sublibraries directly
  shapes.geometric,% diamond, ellipse, trapezium, semi circle, polygon...
  shapes.symbols,% different signs, cloud, signal...
  shapes.arrows,% multiple arrows
  shapes.multipart,% multiple (text) parts nodes
  %shapes.misc,% rounded and chamfered rectangles (see also texjazz-tikz-shapes.def)
  shapes.callouts,% info-bulles type bande-dessinée
  spy,% magnifying a part of a picture
  %svg.path,% specify a path using the SVG-syntax
  %through,% define keys for creating shapes that go through given points
  %tree,% define styles to be used when drawing trees
  %datavisualization,%
   %datavisualization.polar,%
  shadings,% extend the shading possibilities
  shadows,
  fadings,
  tikzmark,% adding \tikzmark and \subnode macros for saving nodes coordinates for later/earlier use
  hobby,% smooth curve between given points: Hobby's algorithm
}

%\usepgfmodule{oo}% define classes, methods, attributes... commands (object-oriented programming)

%- Backgrounds library: must be set in order to be used
%- TeXJazz settings
\pgfdeclarelayer{background}% declare background layer
\pgfdeclarelayer{foreground}
\pgfsetlayers{background,main,foreground}% set the order of the layers (main is the standard layer)

%-- PGF/TikZ utilities
%---------------------

%- Cool features to implement
%- https://tex.stackexchange.com/questions/86693/[...]
%-     [...]is-it-possible-to-use-tikz-to-draw-a-background-on-the-printed-page
%- https://tex.stackexchange.com/questions/351440/[...]
%-     [...]rectangle-with-shading-pattern-as-header-background
%- Storing some experimental codes for testing purpose
%\input{texjazz-tikz-macros.def}

%- Measuring the width of a node that has already been typeset and named
%- See: https://tex.stackexchange.com/questions/8691/widthof-within-tikzpicture
\newcommand\getwidthofnode[2]{% Among others used here for the title layout and display (see below)
  \pgfextractx{#1}{\pgfpointanchor{#2}{east}}%
  % \pgf@xa = length defined by PGF for temporary storage: no need to create a new temporary length
  \pgfextractx{\pgf@xa}{\pgfpointanchor{#2}{west}}%
  \addtolength{#1}{-\pgf@xa}%
}

%- Distance between two referenced nodes. See: https://tex.stackexchange.com/questions/295673
\NewDocumentCommand{\getdistance}{ m m O{center} m O{center} }{%
%- Syntax: {\<length variable/macro>} {<ref1>} [<anchor>] {<ref2>} [<anchor>]
  \pgfpointdiff{\pgfpointanchor{#2}{#3}}% http://tex.stackexchange.com/a/39325/13552
               {\pgfpointanchor{#4}{#5}}% http://tex.stackexchange.com/a/39325/13552
  \pgf@xa=\pgf@x
  \pgf@ya=\pgf@y
  \pgfmathparse{veclen(\pgf@xa,\pgf@ya)}% result as number (floating point)
  %\pgfmathveclen{\pgf@xa}{\pgf@ya}% alternate syntax to pgfmathparse: result as number (floating point)
  %\global\let#1\pgfmathresult pt% does not recognize pt.
  \global\edef#1{\pgfmathresult\ pt}
  %\pgfmathprintnumber{\pgfmathresult}%
}

%- https://tex.stackexchange.com/questions/33703/extract-x-y-coordinate-of-an-arbitrary-point-in-tikz
\newcommand{\gettikzxy}[3]{%
%- Syntax: <node/point name> <xcoord. definition name> <ycoord. definition name>
  \tikz@scan@one@point\pgfutil@firstofone#1\relax
  \edef#2{\the\pgf@x}%
  \edef#3{\the\pgf@y}%
}

%----- Dealing with shapes and anchors: interesting readings
%- 1. First and for reference, read the pgfmoduleshapes.code.tex file (.../tex/generic/pgf/modules)
%-    As a starting point, try to mimic the rectangle shape definition
%- 2.  https://tex.stackexchange.com/questions/33150/creating-node-shapes
%- 3. https://tex.stackexchange.com/questions/303295/
%- 4. https://tex.stackexchange.com/questions/294876/pgf-tikz-node-custom-shape
%- 5. https://tex.stackexchange.com/questions/226322/ (flowchart-decision-shape-enforce-aspect) +1!
%-----

%- Defining more anchors to existing node shapes
%- Original answer from Martin Scharrer: https://tex.stackexchange.com/a/14772/16595
%- Extended version by "Qrrbrbirlbel" to be able to use \savedanchor, \nodeparts and
%- \pgfnodepartstextbox: https://tex.stackexchange.com/questions/29874/
\def\pgfaddtoshape#1#2{%
  \begingroup
  \def\shape@name{#1}
  \let\savedanchor=\pgf@sh@savedanchor
  \let\anchor=\pgf@sh@anchor
  \let\nodeparts=\pgf@sh@boxes
  \nodeparts{text}%
  #2%
  \endgroup
}

%-- Compilation of some PGF/TikZ shapes (see also texjazz-forest.sty TODO → More clever arrangement)

%-- Shapes add-ons: square, superellipse, etc. FIXME TODO harmonizing this stuff with a package

%\input{texjazz-tikz-shapes.def}% Old fashion
%\RequirePackage{texjazz-tikz-shapes}% EXPERIMENTAL TODO → FIXME

%-- Superellipse shape
%---------------------

%- From:
%- /https://tex.stackexchange.com/questions/87740/how-do-i-make-a-superellipse-node-shape-in-tikz
%- https://tex.stackexchange.com/questions/179590/connected-balloons
%- For now, the below macro is redefined in texjazz-modelling.sty as \superellipsedomain
\newcommand*{\superellipse}[3][draw]{% #1 = styles, #2 = node, #3 = superness
  \coordinate (ne) at ($(#2.center)!#3!(#2.north east)$);
  \coordinate (nw) at ($(#2.center)!#3!(#2.north west)$);
  \coordinate (sw) at ($(#2.center)!#3!(#2.south west)$);
  \coordinate (se) at ($(#2.center)!#3!(#2.south east)$);
  \pgfmathparse{-9.6*#3*#3 + 14.4*#3 - 4.8}   % <--------- Magic numbers!
  \xdef\tension{\pgfmathresult}
  \path[#1]
    plot[smooth cycle, tension=\tension] coordinates{
      (#2.east) (ne) (#2.north) (nw) (#2.west) (sw) (#2.south) (se)};
  %\node {\tension};
}

%-- Chamfered splitted rectangle (to be applied in texjazz-modelling.sty?)
%-------------------------------

%- New shape, different from the one given with the shapes.misc library
%- https://tex.stackexchange.com/questions/58389/
%- (db-diagrams-entity-relationship-tikz-chamfered-rectangle-with-split-zones)


%- Cool links to zoom a part of text as in a lens
%------------------------------------------------
%- https://tex.stackexchange.com/questions/184911/magnify-text-using-spy-library/
%- https://tex.stackexchange.com/questions/59705/magnifying-part-of-a-picture-similar-to-tikz-spy-library


%- Full width note (stolen to Paul Gaborit, `ocgx' package)
\newcounter{linewidthnote}
\newenvironment{linewidthnote}{% A priori non breakable, take care!
  \vspace{6pt}
  \noindent
  \tikzpicture
  \node[%draw=black,line width=.1pt,
    rounded corners=0.5em,%1em,
    inner xsep=1.3em, inner ysep=.8em,
    text width=\linewidth-2.6em-\pgflinewidth,
    align=justify,
    %draw=cyan!50!black,
    draw=firstcolor,
    fill=black!3,%white,
    %fill=yellow!20,
    line width=1pt,
    %drop shadow={fill=cyan!50!black},
    drop shadow={fill=firstcolor},
  ] (linewidthnote) \bgroup%
}{%
  \egroup;
  \node[circle, overlay,
    %fill=white,draw=cyan!50!black,
    draw=white,
    %fill=cyan!50!black,
    fill=firstcolor,
    text=white,
    line width=2pt,
    %drop shadow={fill=cyan!50!black},
    drop shadow={fill=firstcolor},
    font=\small\bfseries,inner sep=4pt]
    at ([yshift=-2pt]linewidthnote.north west){\stepcounter{linewidthnote}\arabic{linewidthnote}};
  \endtikzpicture\par\vspace{.1em}%
}

%- Color map (see also the `pgfplots' package)
%---------------------------------------------
%- https://tex.stackexchange.com/questions/141448/creating-a-line-separated-gradient-bar-in-tikz

\newcommand{\jazzcolorbar}[3]{% height,width,colors
  \begin{tikzpicture}
    \foreach \x [count=\c] in {#3}{\xdef\numcolo{\c}}
    \pgfmathsetmacro{\pieceheight}{#1/(\numcolo-1)}
    \xdef\lowcolo{}
    \foreach \x [count=\c] in {#3} {%
      \ifthenelse{\c = 1}
        {}
        {\fill[bottom color=\lowcolo,top color=\x] 
            (0,{(\c-2)*\pieceheight}) rectangle (#2,{(\c-1)*\pieceheight});}
      \xdef\lowcolo{\x}
    }
  \end{tikzpicture}
}

\newcommand{\mycolorbar}[3]{% height,width,colors
  \begin{tikzpicture}
  \foreach \x [count=\c] in {#3}{\xdef\numcolo{\c}}
  \pgfmathsetmacro{\pieceheight}{#1/(\numcolo-1)}
    \xdef\lowcolo{}
    \foreach \x [count=\c] in {#3} {%
      \ifnum\c=1\relax
      \else
        \fill[bottom color=\lowcolo,top color=\x] 
          (0,{(\c-2)*\pieceheight}) rectangle (#2,{(\c-1)*\pieceheight});
      \fi
      \xdef\lowcolo{\x}
    }
  \end{tikzpicture}
}

\newcommand{\tickscolorbar}[6]{% height,width,colors,label min,label max,label step
  \begin{tikzpicture}
    \foreach \x [count=\c] in {#3}{\xdef\numcolo{\c}}
    \pgfmathsetmacro{\pieceheight}{#1/(\numcolo-1)}
    \xdef\lowcolo{}
    \foreach \x [count=\c] in {#3} {%
      \ifthenelse{\c = 1}
        {}
        {\fill[bottom color=\lowcolo,top color=\x] 
            (0,{(\c-2)*\pieceheight}) rectangle (#2,{(\c-1)*\pieceheight});}
      \xdef\lowcolo{\x}
    }
    \draw (0,0) rectangle (#2,#1);
    \pgfmathsetmacro{\secondlabel}{#4+#6}
    \pgfmathsetmacro{\lastlabel}{#5+0.01}
    \pgfkeys{/pgf/number format/.cd,fixed,precision=2}
    \foreach \x in {#4,\secondlabel,...,\lastlabel} {
      \draw (#2,{(\x-#4)/(#5-#4)*#1}) -- ++ (0.05,0) node[right] {\pgfmathprintnumber{\x}};}
  \end{tikzpicture}
}


%- https://tex.stackexchange.com/questions/197793/how-to-draw-gradient-arrows-with-tikz/

\def\createshadingfromlist#1#2#3{%
  \pgfutil@tempcnta=0\relax
  \pgfutil@for\pgf@tmp:={#3}\do{\advance\pgfutil@tempcnta by1}%
  \ifnum\pgfutil@tempcnta=1\relax%
    \edef\pgf@spec{color(0)=(#3);color(100)=(#3)}%
  \else%
    \pgfmathparse{50/(\pgfutil@tempcnta-1)}\let\pgf@step=\pgfmathresult%
    %
    \pgfutil@tempcntb=1\relax%
    \pgfutil@for\pgf@tmp:={#3}\do{%
      \ifnum\pgfutil@tempcntb=1\relax%
        \edef\pgf@spec{color(0)=(\pgf@tmp);color(25)=(\pgf@tmp)}%
      \else%
        \ifnum\pgfutil@tempcntb<\pgfutil@tempcnta\relax%
          \pgfmathparse{25+\pgf@step/4+(\pgfutil@tempcntb-1)*\pgf@step}%
          \edef\pgf@spec{\pgf@spec;color(\pgfmathresult)=(\pgf@tmp)}%
        \else%
          \edef\pgf@spec{\pgf@spec;color(75)=(\pgf@tmp);color(100)=(\pgf@tmp)}%
        \fi%
      \fi%
      \advance\pgfutil@tempcntb by1\relax%
    }%
  \fi%
  \csname pgfdeclare#2shading\endcsname{#1}{100}\pgf@spec%
}

\createshadingfromlist{shading1}{vertical}{red,yellow,green,cyan,blue}
\createshadingfromlist{shading2}{vertical}{red,yellow}
\createshadingfromlist{shading3}{vertical}{black,blue,cyan,white}
\createshadingfromlist{shading4}{vertical}%
  {matlabdarkblue,matlabblue,matlabcyan,matlabyellow,matlabred,matlabdarkred}
%\createshadingfromlist{matlabjet}{vertical}%
%  {matlabdarkblue,matlabblue,matlabcyan,matlabyellow,matlabred,matlabdarkred}



%- Pie charts
%---------------------------------------------

%\RequirePackage{pgf-pie}
\RequirePackage{texjazz-piechart}

%\RequirePackage{datapie}

%-- Customed pie charts with plain PGF-Tikz
%------------------------------------------

%- From: https://tex.stackexchange.com/questions/135393/how-to-draw-bar-pie-chart
%-       https://tex.stackexchange.com/questions/407883/pie-chart-labels
%-       https://tex.stackexchange.com/questions/151078/how-to-give-different-color-to-each-pie
%-       https://tex.stackexchange.com/questions/312153/[...]
%-         [..]how-to-use-colors-from-a-pgfplots-colormap-in-pie-chart
%-       https://tex.stackexchange.com/questions/82727/create-a-ring-diagram-in-tex
%-       https://tex.stackexchange.com/questions/195093/customed-pie-chart

\definecolor{rosso}{RGB}{220,57,18}
\definecolor{giallo}{RGB}{255,153,0}
\definecolor{blu}{RGB}{102,140,217}
\definecolor{verde}{RGB}{16,150,24}
\definecolor{viola}{RGB}{153,0,153}

\newcounter{piestart}
\newcounter{piestop}

\newcommand{\slicechart}[5]{ %% use 5 arguments here
  \pgfmathparse{0.5*#1+0.5*#2}
  \let\midangle\pgfmathresult

  % slice %% I changed !10 to !30 to get darker color
  % use the fifth argument #5 to pass the color  
  \draw[thick,fill=#5] (0,0) -- (#1:1) arc (#1:#2:1) -- cycle;

  % outer label
  \node[label=\midangle:#4] at (\midangle:0.8) {};

  % inner label
  \pgfmathparse{min((#2-#1-10)/110*(-0.3),0)}
  \let\temp\pgfmathresult
  \pgfmathparse{max(\temp,-0.5) + 0.8}
  \let\innerpos\pgfmathresult
  \node at (\midangle:\innerpos) {#3};
}

\newcommand{\piechart}[1]{%
  \foreach \p/\t/\c in {#1}
  {
    \setcounter{piestart}{\value{piestop}}
    \addtocounter{piestop}{\p}
    %countstart=\value{piestart} --- countstop=\value{piestop}
    \slicechart{\thepiestart/100*360}
          {\thepiestop/100*360}
          {\p\%}{\t}{\c}  %% here we use the fifth variable
  }%
}


%---------------------------------------------------------------------------------------------------
%---- Plotting functions and data visualization
%---------------------------------------------------------------------------------------------------

%-- Plotting mathematical stuff (over/with TikZ)
%-----------------------------------------------

%\let\pgfmathModX=\pgfmathMod@ % Workaround for the bug with forest and FPU
\RequirePackage{pgfplots}
%\let\pgfmathMod@=\pgfmathModX % Workaround for the bug with forest and FPU
%- TAKE CARE! Note that this workaround affects the following operations:
%-             isprime iseven gcd frac random setseed Mod div real
%- TODO: follow new implementation of pgfplots (Ch. Feuersänger knows the bug 2016/09/17)
%\pgfplotsset{compat=1.16}% 2019 1.16 − 2018 1.14
\pgfplotsset{compat=1.17}% 2020 1.17 − 2018 1.14

%- Group plots as a matrix in the same figure (e.g. for comparison)
%\usepgfplotslibrary{groupplots}

%- Creating PDF files of tikzpictures COMPLIQUÉ À METTRE EN ŒUVRE !
%\usepgfplotslibrary{external}

%- For activation or not see the link below (conflict with front page and chapter tikzpictures
%- Try with filehook in the main document or use before each figure to externalize:
%- \tikzset{external/export next=true}
%---
%- https://tex.stackexchange.com/questions/186732/how-can-i-use-the-tikz-external-library

%- Activate externalization - Take care! Must be put before \begin{document}, but also
%- must be deactivate at each non relevant "tikzpicture" environment like front page, chapters...
%\tikzexternalize%
%- In order to activate/deactivate externalization, use the following macros:
%- \tikzexternaldisable - \tikzexternalesable
%- \tikzset{external/export next=true/false} - \tikzset{external/export=true/false}

%\tikzsetexternalprefix{./Figures/}% Folder for Tikz figures

%-- Data visualization (over/with TikZ)

%\RequirePackage{pgfplotstable}


%---------------------------------------------------------------------------------------------------
%---- Graphical layout elements
%---------------------------------------------------------------------------------------------------

%-- TikZ personal library (icons...) and forest folder trees. TODO: simplify and clean the code!

%\RequirePackage{texjazz-forest}% Trees design (amazing and powerful)

%-- Colored margin background of specific pages (eg, chapter page)

%-- Borrowed from the yreport package: useless for now (just for the record)
%---------------------------------------------------------------------------

\newlength{\bigVerticalLineWidth}
\setlength{\bigVerticalLineWidth}{\evensidemargin + 1in + \hoffset}
\newlength{\bigVerticalLinePartOfMarginParSep}
\setlength{\bigVerticalLinePartOfMarginParSep}{\marginparsep/8}
\setlength{\bigVerticalLinePartOfMarginParSep}{5\bigVerticalLinePartOfMarginParSep}
\addtolength{\bigVerticalLineWidth}{-\bigVerticalLinePartOfMarginParSep}
\newcommand{\bigVerticalLine}[1]{
  \strictpagechecktrue
  \checkoddpage
  \ifoddpage%
  \AddToShipoutPictureBG*{% `eso-pic' package command
    \begin{tikzpicture}[remember picture, overlay]
      \fill[fill=#1] (current page.south east) rectangle ++(-\bigVerticalLineWidth, \paperheight);
    \end{tikzpicture}
  }
  \else%
  \AddToShipoutPictureBG*{% `eso-pic' package command
    \begin{tikzpicture}[remember picture, overlay]
      \fill[fill=#1] (current page.south west) rectangle ++(\bigVerticalLineWidth, \paperheight);
    \end{tikzpicture}
  }
  \fi%
}

%- Background vertical margin
\newcommand{\backgroundThisPageGrey}{\bigVerticalLine{bigVerticalLineGrey}}
\newcommand{\backgroundThisPageColor}{\bigVerticalLine{maincolor}}

%- Entire page area
\newcounter{background}[page]
\renewcommand{\thebackground}{\arabic{page}-\arabic{background}}
\newcommand{\backgroundAnchor}[1]{%
  \leavevmode\zsavepos{background-#1}%
}
\newlength{\backgroundInnerTopSpace}

%- space_before_begin space_after_begin counter
\DeclareDocumentCommand{\startBackground}{O{0mm} O{0mm} O{\thebackground}}{%
  \setlength{\backgroundInnerTopSpace}{1em}%
  \addtolength{\backgroundInnerTopSpace}{#2}%
  \vspace*{#1}\newline%
  \backgroundAnchor{begin-#3}%
  \vspace*{\backgroundInnerTopSpace}\\%
}
\DeclareDocumentCommand{\startBackgroundPageTop}{O{\thebackground}}{%
  \tikz[overlay, remember picture]{%
    \node at(current page.north west){\backgroundAnchor{#1}};}%
}
\newlength{\depthLength}
\settodepth{\depthLength}{p}
\newlength{\backgroundInnerBottomSpace}
\newlength{\backgroundOuterBottomSpace}
%- outer_space inner_space counter
\DeclareDocumentCommand{\stopBackground}{O{0mm} O{0mm} O{\thebackground}}{%
  \setlength{\backgroundInnerBottomSpace}{2\depthLength}%
  \addtolength{\backgroundInnerBottomSpace}{#2}%
  \vspace*{\backgroundInnerBottomSpace}%
  \setlength{\backgroundOuterBottomSpace}{1em}%
  \addtolength{\backgroundOuterBottomSpace}{#1}
  \backgroundAnchor{end-#3}%
  \vspace*{\backgroundOuterBottomSpace}%
}
\DeclareDocumentCommand{\stopBackgroundPageBottom}{O{\thebackground}}{%
  \tikz[overlay, remember picture]{%
    \node at (current page.south east){\backgroundAnchor{#1}};}%
}
\tikzset{background/.style = {fill=maincolor!20}}
\newcommand{\drawBackground}[1][\thebackground]{%
  \leavevmode%
  \stepcounter{background}%
  \zsavepos{background-draw-#1}%
  \begin{tikzpicture}[remember picture, overlay, inner sep=0mm]
    \fill[background] let
    \p1=(current page.west),
    \p2=(current page.east) in
    (\x1, \zposy{background-begin-#1}sp - \zposy{background-draw-#1}sp) rectangle
    (\x2, \zposy{background-end-#1}sp   - \zposy{background-draw-#1}sp);
  \end{tikzpicture}%
  \ignorespaces
}


%---------------------------------------------------------------------------------------------------
%---- New macros and elements: commands/environments/shortcuts
%---------------------------------------------------------------------------------------------------

%-- Referenced document elements
%-------------------------------

%\newcounter{video}% Already defined by `newfloat'
%\renewcommand{\thevideo}{\thechapter.\arabic{video}}
\newcounter{document}
\renewcommand{\thedocument}{\thechapter.\arabic{document}}

%---
%- https://tex.stackexchange.com/questions/35310/problem-with-use-of-in-custom-href-command
%- https://tex.stackexchange.com/questions/208808/newcommand-with-href
%- TAKE CARE that new commands based on \href break the absortion of special characters like # or ~
%---

%- For the record, general approach
%\newcommand*{\link}{\begingroup\@makeother\#\@mylink}
%\newcommand*{\@mylink}[2]{\href{#1}{\underline{#2}}\endgroup}

\newcommand{\videolink}{%
  \refstepcounter{video}%
  \begingroup\@makeother\#\@videolink%
}
\newcommand{\@videolink}[3][\faVideoCamera]{%
  \textcolor{secondcolor}{\normalfont\small\faVideoCamera\space}%
  \textsc{\small Vidéo\space\thevideo\space\textcolor{secondcolor}{\textemdash}\space}%
  \href{run:#2}{#3}\endgroup%
  %\addcontentsline{lov}{video}{%
  %  \protect\numberline{\thevideo}#3\enspace\textcolor{secondcolor}{\normalfont\small#1}%
  \addcontentsline{lov}{video}{%
    \protect\numberline{\thevideo}#3\enspace\textcolor{secondcolor}{\normalfont\footnotesize#1}%
  }%
}
\newcommand{\sidevideolink}{%
  \refstepcounter{video}%
  \begingroup\@makeother\#\@sidevideolink%
}
\newcommand{\@sidevideolink}[3][\faVideoCamera]{%
  \textcolor{secondcolor}{\normalfont\footnotesize\faVideoCamera}%
  \textsc{\footnotesize\enspace Vid.\space%
    \thevideo\space\textcolor{secondcolor}{\textemdash}\space}%
  \href{run:#2}{#3}\endgroup%
  \addcontentsline{lov}{video}{%
    \protect\numberline{\thevideo}#3\enspace\textcolor{secondcolor}{\normalfont\footnotesize#1}%
  }%
}
\newcommand*{\textdoc}{%
  \refstepcounter{document}%
  \begingroup\@makeother\#\@textdoc%
}
\newcommand*{\@textdoc}[3][\faFileTextO]{%
  \href{run:#2}{\textcolor{secondcolor}{\normalfont\faFileTextO} #3}\endgroup%
  \addcontentsline{lod}{document}{%
    \protect\numberline{\thedocument}#3\enspace\textcolor{secondcolor}{\normalfont\small#1}%
  }%
}
\newcommand*{\pdfdoc}{%
  \refstepcounter{document}%
  \begingroup\@makeother\#\@pdfdoc%
}
\newcommand*{\@pdfdoc}[3][\faFilePdfO]{%
  \href{run:#2}{\textcolor{secondcolor}{\normalfont\faFilePdfO} #3}\endgroup%
  \addcontentsline{lod}{document}{%
    \protect\numberline{\thedocument}#3\enspace\textcolor{secondcolor}{\normalfont\small#1}%
  }%
}
\newcommand*{\pdfwatch}{%
  \refstepcounter{document}%
  \begingroup\@makeother\#\@pdfwatch%
}
\newcommand*{\@pdfwatch}[4][\faFilePdfO]{%
  \href{run:#2}{#3}\endgroup%
  \addcontentsline{lod}{document}{%
    \protect\numberline{\thedocument}#4\enspace\textcolor{secondcolor}{\normalfont\small#1}%
  }%
}
\newcommand{\pdflink}[1]{%
  \href{run:#1}{\textcolor{secondcolor}{\normalfont\faFilePdfO}}%
}
\newcommand*{\webdoc}{%
  \refstepcounter{document}%
  \begingroup\@makeother\#\@webdoc%
}
\newcommand*{\@webdoc}[3][\faFirefox/\faExternalLink]{%
  %\href{#2}{\textcolor{secondcolor}{\normalfont\faExternalLink} #3}\endgroup%
  \href{#2}{\textcolor{secondcolor}{\normalfont #1} #3}\endgroup%
  %\ifemptyarg{#1}
  %  {\addcontentsline{lod}{document}{\protect\numberline{\thedocument}#3}}%
    {\addcontentsline{lod}{document}{%
      \protect\numberline{\thedocument}#3\enspace\textcolor{secondcolor}{\normalfont\small#1}}%
    }%
}
\newcommand*{\hrefdoc}{%
  \refstepcounter{document}%
  \begingroup\@makeother\#\@hrefdoc%
}
\NewDocumentCommand{\@hrefdoc}{O{\faFirefox} d<> m m}{%
  \href{#3}{#4}\endgroup%
  \IfValueTF{#2}
    {\addcontentsline{lod}{document}{%
      \protect\numberline{\thedocument}#2\enspace\textcolor{secondcolor}{\normalfont\small#1}}%
    }
    {\addcontentsline{lod}{document}{%
      \protect\numberline{\thedocument}#4\enspace\textcolor{secondcolor}{\normalfont\small#1}}%
    }%
}

%-- Positioning and adjusting boxes
%----------------------------------

%\RequirePackage{adjustbox}%


%---------------------------------------------------------------------------------------------------
%----  Margin elements
%---------------------------------------------------------------------------------------------------

%\PassOptionsToPackage{noparboxrestore}{marginnote}
\RequirePackage{marginnote}

%\RequirePackage{texjazz-marginnote}% A clone of marginnote with vertical management
%\let\jazzmarginnote\marginnote

%- Arranges marginpars "intelligently" / Automatically adjust the side material nicely

\RequirePackage{marginfix}

%- LaTex3 implementation of sidenotes, for compatibility (clashes because we use same names commands)

%\RequirePackage{sidenotes}


%--- Sidenotes macros (TODO: implement some ideas)
%- Based on `sidenotes' macros, switching between marginpar and marginote without overlap
%\RequirePackage{sidenotes}% use marginnote (fixed) or marginpar (float)
%---


%--- Sidenotes macros (TODO: implement some ideas)
%- Based on `snotez' macros, switching between marginpar and marginote without overlap
%\RequirePackage{snotez}% use marginnote (fixed) or marginpar (float)
%---

%-- Sidenote command definition (\sidenote) borrowed to Clemens Niederberger `snotez` package
%--------------------------------------------------------------------------------------------

%- `snotez' package is not compatible with `sidenotes' package,
%- but some features seem very interesting to study and may be implement
\RequirePackage{texjazz-sidenotes}
%\setsidenotes{perpage=false}


%-- Sidenote command definition (\sideNote): own traditional way of doing, may be old fashion ;-)
%------------------------------------------------------------------------------------------------

% TODO: SYNTHÉTISER TOUT CE BOUZIN DE COMMANDES POUR CLARIFIER ET SIMPLIFIER LES CHOSES !

%- Sidenote commons (own old fashion way)
\DeclareDocumentCommand{\sideMark}{O{secondcolor} m}{{\color{#1}\normalfont#2.{\:}}}
\DeclareDocumentCommand{\sideTitle}{m}{{\lightboldfont\normalsize#1}}
\DeclareDocumentCommand{\sideTitleColor}{m}{{\color{black!80}\sideTitle{#1}}}

%- Uncomment below to have rigth/left justification of the margin contents
\DeclareDocumentCommand{\marginelement}{m}{%
  \marginpar{%
    \strictpagechecktrue%
    \checkoddpage%
    \ifoddpage%
      \footnotesize%
      %\RaggedRight\footnotesize%
    \else%
      \footnotesize%
      %\RaggedLeft\footnotesize%
    \fi%
    #1%
  }\unskip%
}%

\DeclareDocumentCommand{\margincontent}{m}{%
  \marginpar{%
    \strictpagechecktrue%
    \checkoddpage%
    \ifoddpage%
      \RaggedRight%
    \else%
      \RaggedLeft%
    \fi%
    #1%
  }\unskip%
}%

% TODO: DÉFINIR AUSSI DES \sidecomment AVEC UNE AUTRE PRÉSENTATION  (PICTOGRAMME) ET NUMÉROTATION
%       POUVANT NE PAS ÊTRE AFFICHÉS SUIVANT TEST CONDITIONNEL GLOBAL
%       UTILISER L'ICÔNE FONTAWESOME 'comments" OU AUTRES "callout"

%- Defining a side comment box similar to the side note command: numbering + pictogram + conditional
\newcommand{\commentmark}{\faIcon{comment-alt}}%\faComment
\newcommand{\commentfontsize}{\fontsize{4.0pt}{0pt}\selectfont}
\newlength{\commentmarkwidth}
\newlength{\commentmarkheight}
\settowidth{\commentmarkwidth}{\footnotesize\commentmark}
\settoheight{\commentmarkheight}{\footnotesize\commentmark}
\newcommand{\@commentsuperscript}[1]{% From latex.ltx \@textsuperscript
  %{\m@th\ensuremath{^{\mbox{\hspace*{-1pt}#1}}}}% Original (with math)
  \footnotesize\raisebox{0.20\baselineskip}{\hspace*{-0.75pt}#1\hspace*{-1.5pt}}%
}
\ExplSyntaxOn
\newcounter{sidecomment} % make a counter
%\setcounter{sidecomment}{1} % init the counter − Original
%\setcounter{sidecomment}{0} % init the counter: not needed with our modifications
\NewDocumentCommand{\@sidecomments@thesidecommentmark}{ m }{% See latex.ltx \@footnotemark def.
  \leavevmode
  \ifhmode\edef\@x@sf{\the\spacefactor}\nobreak\fi
  %\hbox {\@textsuperscript {\normalfont #1 }}% Original
  \hbox{% See latex.ltx \@makefnmark def.
    \@commentsuperscript{%
      \color{firstcolor}%
      \footnotesize\commentmark\hspace*{-\commentmarkwidth}%
      \makebox[\commentmarkwidth][c]{%
        \raisebox{0.375\commentmarkheight}{%
          \commentfontsize\textcolor{white}{\textbf{\thesidecomment}}%
        }%
      }%
    }%
  }%
  \ifhmode\spacefactor\@x@sf\fi
  \relax
}
\NewDocumentCommand{\@sidecomments@multisign}{ }{3sp}
\NewDocumentCommand{\@sidecomments@multimarker}{ }{%
  \kern-\@sidecomments@multisign
  \kern\@sidecomments@multisign\relax
}
\NewDocumentCommand{\@sidecomments@multichecker}{ }{%
  \dim_compare:nNnTF \lastkern = \@sidecomments@multisign
  {\@sidecomments@thesidecommentmark{,}}
  %{}% Original: no extra space between text and note numbering
  {\hspace*{0.5pt}}% Adding a small space between text and note numbering
}
\NewDocumentCommand{\@sidecomments@placemarginal}{ m m }{%
  \IfNoValueOrEmptyTF{#1}
    {\marginpar{#2}}
    {\marginnote{#2}[#1]}
}
\NewDocumentCommand{\sidecomment}{ o o +m }{%
  \sidecommentmark[#1]
  \sidecommenttext[#1][#2]{#3}
  \@sidecomments@multimarker
}
\NewDocumentCommand{\sidecommentmark}{ o }{%
  \@sidecomments@multichecker
  \IfNoValueOrEmptyTF{#1}
    {\@sidecomments@thesidecommentmark{\thesidecomment}}
    {\@sidecomments@thesidecommentmark{#1}}
  \@sidecomments@multimarker
}
\NewDocumentCommand{\sidecommenttext}{ o o +m }{%
  \IfNoValueOrEmptyTF{#1}{%
    %\@sidecomments@placemarginal{#2}{\textsuperscript{\thesidecomment}{}~\footnotesize#3}% Original
    \@sidecomments@placemarginal{#2}{% French layout
      %\footnotesize\textcolor{secondcolor}{\thesidecomment.\:}#3%
      \footnotesize\textcolor{secondcolor}{\thesidecomment.~}#3%
    }%
    \refstepcounter{sidecomment}
  }{%
    \@sidecomments@placemarginal{#2}{\textsuperscript{#1}~\footnotesize#3}% To be modified
  }
}
%- Following the idea from: https://tex.stackexchange.com/questions/434023/reference-to-sidenote
%- some adjustments have to be done to \sidenotetext and \sidenote
\RenewDocumentCommand{\sidecomment}{ o o +m }{%
  \@sidecomments@multichecker
  \sidecommenttext[#1][#2]{#3}
  \sidecommentmark[#1]
  \@sidecomments@multimarker
}
\RenewDocumentCommand{\sidecommenttext}{ o o +m }{%
  \IfNoValueOrEmptyTF{#1}{%
    \refstepcounter{sidecomment}
    \@sidecomments@placemarginal{#2}{% French layout
      \textcolor{firstcolor}{%
        \llap{%
          \footnotesize\commentmark\hspace*{-\commentmarkwidth}%
          \makebox[\commentmarkwidth][c]{%
            \raisebox{0.375\commentmarkheight}{%
              \commentfontsize\textcolor{white}{\textbf{\thesidecomment}}%
            }%
          }%
          \hspace*{3pt}%
        }%
      }\footnotesize#3%
    }%
  }{%
    \@sidecomments@placemarginal{#2}{%
      \textsuperscript{#1}~\footnotesize#3}% To be modified
  }
}
\ExplSyntaxOff

% TODO: DÉFINIR AUSSI DES \sideinfo ENCARTS DE MARGE AVEC PICTOGRAMME "i" POUR LES INFOS
%       COMPLÉMENTAIRES DE MARGE DANS TEXTES REPRIS, N'ÉTANT PAS DU/DES RÉDACTEURS (ARTICLES, ECT.)

% TODO: DÉFINIR AUSSI DES \sideinsert ENCARTS DE MARGE AVEC TCOCOLORBOX ET NUMÉROTATION
%       CF. SOMMAIRES D'ENTRÉE DE CHAPITRE

%- Side insert within a tcolorbox (see doc. p.445)
\AtEndOfClass{% → To be obviously define after loading the `tcolorbox` package (because we use it!)
  %\tcbset{%
  %  titlerule/.store in=\kvtcb@title@rule,
  %  titlerule style/.style={% From `tcbskins.code.tex` file, `skin` library
  %  underlay={\iftcb@hasTitle%
  %    \path[draw, line width=\kvtcb@title@rule+1000sp,#1]
  %    %- Original
  %    %([yshift=-\kvtcb@title@rule/2]title.south west)--([yshift=-\kvtcb@title@rule/2]title.south east);
  %    %- Modified
  %    ([xshift=4pt, yshift=-\kvtcb@title@rule/2]title.south west)
  %      -- ([xshift=-4pt, yshift=-\kvtcb@title@rule/2]title.south east);
  %  \fi}},%
  %}
  \newlength{\insertboxHeight}
  \setlength{\insertboxHeight}{40pt}% Just an initialization
  \DeclareTColorBox{marginboxtitled}{ o }{%
    % Usage: #1 = optional title
    width=\marginparwidth,
    enhanced,
    nobeforeafter,
    arc=0pt, outer arc=0pt,
    boxsep=0pt,
    left=5pt, right=5pt,
    top=4pt, bottom=4pt,
    boxrule=0pt,
    colback=black!8,
    %colframe=black!40,
    fontupper=\normalfont\footnotesize,
    IfValueTF={#1}{% Adjusting the titlerule as wanted is not easy, therefore the second definition
      title={% \flqq #1 \frqq, equiv. « », see https://tex.stackexchange.com/questions/482222/
        \spacedlowsmallcaps{#1}%
        \par\vspace{-.5\baselineskip}%
        \textcolor{secondcolor}{\rule{\linewidth}{1pt}}%
        \par%
      },
      fonttitle=\tocfont\normalsize,
      coltitle=secondcolor,
      colbacktitle=black!8,
      %titlerule=1pt,
      %titlerule style=firstcolor,%{secondcolor, xshift=4pt},
      toptitle=8pt, bottomtitle=4pt,
    }{},%
  }%
  \DeclareTColorBox{marginbox}{ o }{%
    width=\marginparwidth,
    enhanced,
    nobeforeafter,
    arc=0pt, outer arc=0pt,
    boxsep=0pt,
    left=5pt, right=5pt,
    top=8pt, bottom=4pt,
    boxrule=0pt,
    colback=black!8,
    %colframe=black!40,
    fontupper=\normalfont\footnotesize,
    IfValueTF={#1}{%
      before upper*={% Without star: spurious leading vertical space. WHY?
        \textcolor{secondcolor}{\normalsize\tocfont\spacedlowsmallcaps{#1}}%
        \par\vspace*{-.5\baselineskip}%
        \textcolor{secondcolor}{\rule{\linewidth}{1pt}}%
        \par\vspace*{2pt}%
      },
    }{},%
  }%
}
\DeclareDocumentCommand{\sideinsert}{o m}{%
  % Usage: #1 = optional title; #2 = stuff/text to include
  \marginnote{%
    \vspace*{-\baselineskip}% Needed manual empirical shift! WHY?
    \begin{measurebox}{\insertboxHeight}
      %\begin{marginboxtitled}[#1]
      %  \ignorespaces%
      %  #2%
      %\end{marginboxtitled}%
      %\ignorespaces%
      \begin{marginbox}[#1]
        %\ignorespaces%
        #2%
      \end{marginbox}%
    \end{measurebox}
  }%\unskip%
  \mparshift{\insertboxHeight}% Shifting down the next margin notes (from `marginfix' package)
  \marginpar{\vspace*{\baselineskip}}% More space: starts next display at the correct position
}

%- Side note (old fashion)
%\DeclareDocumentCommand{\sideNote}{O{secondcolor} m}{% Old fashion
%  {%
%    \hypersetup{linkcolor=secondcolor}%
%    \normalfont%
%    \footnotemark%
%  }%
%  \ignorespaces%
%  \marginelement{%
%    \sideMark[#1]{\thefootnote}%
%    \ignorespaces%
%    #2%
%  }%
%}

%- Side note inside a tcbox
\DeclareDocumentCommand{\sidebox}{O{secondcolor} m}{%
  {%
    \hypersetup{linkcolor=secondcolor}%
    \footnotemark%
  }%
  \ignorespaces%
  \marginpar{%
    \sideMark[#1]{\thefootnote}%
    \ignorespaces%
    #2%
  }%
}

%- Side core
\newcounter{sidecore}% make a counter
%\renewcommand{\thesidecore}{\fnsymbol{sidecore}}
\renewcommand{\thesidecore}{\alph{sidecore}}
%\renewcommand{\thefootnote}{\alph{footnote}}
\def\@makesidecoremark{%
  \hbox{\@textsuperscript{\normalfont\textcolor{secondcolor}{\itshape\@thesidecoremark}}}%
}
\def\sidecoremark{%
  \@ifnextchar[\@xsidecoremark
    {\stepcounter{sidecore}%
    \protected@xdef\@thesidecoremark{\thesidecore}%
    \@sidecoremark}}
\def\@xsidecoremark[#1]{%
  \begingroup
    \c@sidecore #1\relax
      \unrestored@protected@xdef\@thesidecoremark{\thesidecore}%
  \endgroup
  \@sidecoremark}
\def\@sidecoremark{%
  \leavevmode
  \ifhmode\edef\@x@sf{\the\spacefactor}\nobreak\fi
  \@makesidecoremark
  \ifhmode\spacefactor\@x@sf\fi
  \relax}
\DeclareDocumentCommand{\sidecore}{O{secondcolor} m}{% Old fashion but works with just above stuff
  {%
    \hypersetup{linkcolor=secondcolor}% There is a bug with hyperlinks: wrong page key
    \sidecoremark%
  }%
  \ignorespaces%
  %\marginnote{%
  \marginpar{%
    \justifying\footnotesize%
    \textcolor{#1}{\thesidecore.{\:}}%
    \ignorespaces%
    #2%
  }%
}

%- Side note with forced position
\DeclareDocumentCommand{\forcedsidenote}{O{secondcolor} m}{%
  {%
    \hypersetup{linkcolor=maincolor}%
    \normalfont%
    \footnotemark%
  }%
  \ignorespaces%
  \marginnote{
    \strictpagechecktrue
    \checkoddpage
    \ifoddpage%
      \RaggedRight\footnotesize%
    \else%
      \RaggedLeft\footnotesize%
    \fi%
    \sideMark[#1]{\thefootnote}%
    \ignorespaces%
    #2%
  }%
}

%-- Side "fake float" as environments: borrowed to the Tüfte class
%-----------------------------------------------------------------

\newsavebox{\@jazz@margin@floatbox}
\newenvironment{jazz@margin@float}[2][0pt]{%[-1.2ex]{%
  \FloatBarrier% process all floats before this point so the figure/table numbers stay in order.
  \begin{lrbox}{\@jazz@margin@floatbox}%
    \begin{minipage}{\marginparwidth}%
      \captionsetup*{type=#2, font=footnotesize,
        format=plain, indention={1mm+.5em}, list=true}% Fake a figure environment
      \hbox{}\vspace*{#1}%
      \centering%
      \@afterindentfalse\@afterheading%
}{\end{minipage}%
  \end{lrbox}%
  \marginpar{\usebox{\@jazz@margin@floatbox}}%
}

%----- Detecting used environment and command
%- LaTeX has a build-in command '\@currenvir' which detects the current environment. See:
%-  https://tex.stackexchange.com/questions/94058/writing-a-command-to-detect-when-in-mdframed
%-  https://tex.stackexchange.com/questions/39738/command-behavior-depending-on-current-environment
%- For floating environments, one can use the '\ifinner' test, see:
%-  https://tex.stackexchange.com/questions/55863/how-to-detect-if-in-an-exercise-environment
%- Also, one can use etoolbox and flags (boolean or toggle).
%- For command, see:
%-   https://tex.stackexchange.com/questions/391637/[...]
%-    [...]detect-the-last-usage-of-a-custom-command-in-a-custom-environment
%-----

%- Detecting if \caption is used in "margin fake floats": TOO COMPLEX FOR THE MOMENT BEING
%\def\margin@envfig{marginfigure}
%\ifx\@currenvir\margin@envfig in figure \fi

%- Margin figure environment
%\NewDocumentEnvironment{marginfigure}{ g o G{0pt} }{%
%  % Syntax − optional #1 = LoF caption, optional #2 = caption, optional #3 = vertical shift
%  \begin{jazz@margin@float}[#3]{figure}%
%}{\IfValueT{#2}{\captionof{figure}{#2}}% Because in minipage the hypcap anchor setting is correct
%  \end{jazz@margin@float}%
%  \IfValueT{#1}{\sidecaptionlist{figure}{#1}}%
%}
%- First approach with bug in the LoF
\NewDocumentEnvironment{marginfigure}{ O{0pt} }% Syntax − optional #1 = vertical shift
  {\begin{jazz@margin@float}[#1]{figure}}%
  {\end{jazz@margin@float}}

\NewDocumentEnvironment{margingraphic}{ o G{0pt} }{%
  % Syntax − optional #1 = caption, optional #3 = vertical shift
  \begin{jazz@margin@float}[#2]{graphic}%
%}{\IfValueT{#1}{\captionof{figure}{#1}}% Because in minipage the hypcap anchor setting is correct
}{\IfValueT{#1}{\caption{#1}}%
  \end{jazz@margin@float}%
  %\IfValueT{#1}{\sidecaptionlist{figure}{#1}}%
}

%- Margin table environment
\NewDocumentEnvironment{margintable}{ O{0pt} }% Syntax − optional #1 = vertical shift
  {\begin{jazz@margin@float}[#1]{table}}%
  {\end{jazz@margin@float}}

%- Margin video environment
\newsavebox{\@jazz@margin@video}
\newenvironment{jazz@margin@video}[2][0pt]{%[-1.2ex]{%
  \FloatBarrier% process all floats before this point so the figure/table numbers stay in order. Not always WHY?
  \begin{lrbox}{\@jazz@margin@video}%
    \begin{minipage}{\marginparwidth}%
      \captionsetup*{type=#2, font=footnotesize,
        format=plain, indention={1mm+.5em}, list=false}% Fake a figure environment
      \hbox{}\vspace*{#1}%
      \centering%
      \@afterindentfalse\@afterheading%
}{\end{minipage}%
  \end{lrbox}%
  \marginpar{\usebox{\@jazz@margin@video}}%
}
\NewDocumentEnvironment{marginvideo}{ o O{0pt} D<>{\faVideoCamera} }{% optional arg#1 = caption
  \begin{jazz@margin@video}[#2]{video}%
}{\IfValueT{#1}{\captionof{video}{#1}}% Because in minipage the hypcap anchor setting is correct
  \end{jazz@margin@video}%
  %\IfValueT{#1}{\sidecaptionlist{video}{%
  %  #1\enspace\textcolor{secondcolor}{\normalfont\small\faVideoCamera}}}%
  \IfValueT{#1}{% Adding an entry in LoV
    \IfNoValueTF{#3}%
      {\sidecaptionlist{video}{#1}}%
      {\sidecaptionlist{video}{#1\textcolor{secondcolor}{%
        \normalfont\footnotesize\ifblank{#3}{}{\enspace}#3}}}%
  }
}
\NewDocumentEnvironment{marginvideo*}{ o O{0pt} }{% optional arg#1 = caption but not in LoV
  \begin{jazz@margin@video}[#2]{video}%
}{\IfValueT{#1}{\captionof{video}{#1}}% Because in minipage the hypcap anchor setting is correct
  \end{jazz@margin@video}%
}

%-- Side "fake float" as commands
%--------------------------------

%- Side figure
\DeclareDocumentCommand{\sidefigure}{o m}{%
  %\FloatBarrier% process all floats before this point so the figure-like stuff numbers stay in order
  \marginelement{% \subcaptionbox et `subfigure' env. ne passent pas car pour flottants TODO: FIXME
    %\strictpagechecktrue\checkoddpage\ifoddpage\RaggedRight\else\RaggedLeft\fi%
    \setcounter{subfigure}{0}% Must reset the counter for "subSideFigure": WHY? FIXME
    %\centering%
    %\@afterindentfalse\@afterheading%
    %\vspace*{2pt}% compensate an unknown gap TODO: find the issue!
    %#2%
    %\IfValueT{#1}{\sidefigcaptionof{#1}}%
    \begin{minipage}{\marginparwidth}%
      \captionsetup*{type=figure, font=footnotesize,
        format=plain, indention={1mm+.5em}, list=false}%
      %\hbox{}\vspace*{#1}%
      \centering%
      \@afterindentfalse\@afterheading%
      #2%
      \IfValueT{#1}{\captionof{figure}{#1}}%
    \end{minipage}%
  }
  \IfValueT{#1}{\sidecaptionlist{figure}{#1}}%
}

%- Side subfigure INSIDE A SIDEFIGURE
\DeclareDocumentCommand{\sidesubfigure}{o m}{%
    \begingroup\centering%
    #2%
    \addtocounter{figure}{1}% FIXME: understand WHY I have to increment here? ← BIDOUILLE
    \IfValueT{#1}{%
      \vspace*{-2mm}\sidesubfigcaptionof{#1}\vspace*{2pt}}% increment is done at caption
    \addtocounter{figure}{-1}%
    \endgroup
}

%- FIRST ATTEMPT
%\DeclareDocumentCommand{\sideSubFigure}{o m}{% TODO: try with an environment FIXME:
%- http://tex.stackexchange.com/questions/260800/
%- (how-to-get-equivalent-to-subfigure-without-using-floats)
    %\captionsetup[subfigure]{% Global subcaption settings NEED to be overwrited! FIXME: why?
    %  font={scriptsize}, textfont=it, justification=centering,
    %  hypcap=false, list=false,% no LoF entry for subfigure (of course, it solves the problem!)
    %  format=plain, width=\linewidth, labelformat=parens, labelsep=space}%
%    \begingroup\centering%
    %\phantomcaption% NEEDS to be in FLOAT environment
    % Whithout \begingroup...\endgroup, it displays warning: `the caption type was already set
    % to subfigure'. Please see the link below for more "explanations" (it works though)
    % http://tex.stackexchange.com/questions/310330/subfigure-caption-format-differs-for-captionof/
%    #2%
    %\addtocounter{figure}{1}% FIXME: understand WHY I have to increment here? ← BIDOUILLE
%    \refstepcounter{figure}% FIXME: understand WHY I have to increment here? ← BIDOUILLE
    %\IfValueT{#1}{%
    %  \vspace*{-2mm}\captionof{subfigure}{#1}\vspace*{2pt}}% increment is done at caption
%    \IfValueT{#1}{%
%      \vspace*{-2mm}\sidesubfigcaptionof{#1}\vspace*{2pt}}% increment is done at caption
    % "Hack or hook" for correct labelling in LoF: http://tex.stackexchange.com/questions/230335/
    %\ifx#1\@empty%
    %  \addcontentsline{lof}{subfigure}{\hbox to\@tempdima {\thesubfigure\hfil }{\ignorespaces #2}}%
    %\else%
    %  \addcontentsline{lof}{subfigure}{\hbox to\@tempdima {\thesubfigure\hfil }{\ignorespaces #1}}%
    %\fi
    %\addtocounter{figure}{-1}% It works except in the LoF: the subfigure is added to (n-1)th figure
%    \endgroup
    %\captionlistentry[figure]{#1}\caption@addcontentsline{subfigure}{#1}
    %TODO: try phantom caption/section (it seems to occur because it's the first subfigure call)
%}

%- Side two (sub)figures
\DeclareDocumentCommand{\sideTwoFigures}{o o m o m}{%
  \sidefigure[#1]{\addtocounter{figure}{1}%
    \captionsetup{% Global subcaption settings NEED to be overwrited!
      font={scriptsize}, textfont=it, justification=centering, hypcap=false, list=true,
      format=plain, width=\linewidth, labelformat=parens, labelsep=space}%
    #3%
    \IfValueT{#2}{\vspace*{-2mm}\captionof{subfigure}{#2}}
    %\vspace*{2pt}% compensate an unknown gap TODO: find the issue!
    #5%
    \IfValueT{#4}{\vspace*{-2mm}\captionof{subfigure}{#4}}
  }%
  \addtocounter{figure}{-1}
}

%- Side table !!! For the record, use \subcaptionbox for subtable !!! (see `subcaption.sty')
\DeclareDocumentCommand{\sidetable}{o m}{%
  \marginelement{% \subcaptionbox et `subfigure' env. ne passent pas car pour flottants TODO: FIXME
    %\strictpagechecktrue\checkoddpage\ifoddpage\RaggedRight\else\RaggedLeft\fi%
    \begin{minipage}{\marginparwidth}%
      \captionsetup*{type=table, font=footnotesize,
        format=plain, indention={1mm+.5em}, list=false}%
      \IfValueT{#1}{\captionof{table}{#1}}%
      %\hbox{}\vspace*{#1}%
      \centering%
      \@afterindentfalse\@afterheading%
      #2%
    \end{minipage}%
  }
  \IfValueT{#1}{\sidecaptionlist{table}{#1}}%
}

% https://tex.stackexchange.com/questions/3657/get-the-size-that-a-figure-is-being-rendered

%- Applying the same method for \caution command just below to here put the graphic copyright
\newcommand{\graphictikzmark}[1]{%
  \tikz[remember picture,overlay]\node[inner xsep=0pt,outer sep=0pt] (#1) {};}

\newcounter{graphiccount}
\newlength{\graphicheight}
\newlength{\graphicboxhshift}
\newlength{\graphicboxvshift}
\newlength{\graphiccreditshift}
\newcommand{\graphicside}{}
\newcommand{\graphicotherside}{}
\newcommand{\graphicrotateangle}{}

\newlength{\graphicvoffset}
%\setlength{\graphicvoffset}{\dimexpr2mm+3pt+2pt\relax}
%\setlength{\graphicvoffset}{0.3\baselineskip}% Assuming ht=0.7\baselineskip and dp=0.3\baselineskip
\setlength{\graphicvoffset}{4pt}% Arbitrary value. TODO: calculate it precisely

% https://tex.stackexchange.com/questions/203194/measuring-a-part-of-the-page (third solution)
\newcommand{\measuregraphicbox}[4]{%
  % Syntax − #1 = a valid boxname
  %          #2 = a width
  %          #3 = a macro name with will get the total height of the box
  %          #4 = the box content
  \sbox{#1}{\begin{minipage}{#2}#4%
  \end{minipage}}%
  \edef#3{\the\dimexpr\ht#1+\dp#1\relax}%
}

\DeclareDocumentCommand{\sideimage}{s o m g O{0pt}}{%
  % Syntax − #1 = no star = copyright symbol, star = no copyright symbol
  %          #2 = caption text
  %          #3 = margin contents: an image file (or more) included with \includegraphics
  %          #4 = optional copyright/source of the graphic (graphics are different from figures)
  %          #5 = optional voffset
  %\hspace{0pt}%
  \marginnote{% more flexible, but... Lost floats?
  %\marginnote{% Seems to solve the "lost floats" issue. Yes, but... to clarify and be understood
    %\vspace*{2pt}% compensate an unknown gap TODO: find the issue!
    %\vspace*{\baselineskip}% compensate an unknown gap TODO: find the issue!
    \IfValueTF{#4}{%
      \stepcounter{graphiccount}%
      \graphictikzmark{\thegraphiccount}%
      %- Box height measurement is done with the same command used for margin ToC (see below)
      \begin{measurebox}[nobeforeafter]{\graphicboxheight}%, show bounding box
        \centering%
        \@afterindentfalse\@afterheading%
        #3%
      \end{measurebox}%
      \strictpagechecktrue%
      \checkoddpage%
      \ifoddpageoroneside%
        \setlength{\graphicboxhshift}{\marginparsep}%
        \setlength{\graphicboxvshift}{5pt}%
        \renewcommand{\graphicside}{west}%
        \renewcommand{\graphicotherside}{east}%
        \renewcommand{\graphicrotateangle}{90}%
      \else%
        \settowidth{\graphiccreditshift}{%
          \IfBooleanTF{#1}%
            {\scriptsize\space#4}%
            {\scriptsize\faCopyright\space#4}%
        }%
        %\setlength{\graphicboxhshift}{%
        %  -\marginparwidth-.5\marginparsep-.5\graphiccreditshift-0.4pt}%-0.8pt}%-1.6pt}% thick=0.8pt
        \setlength{\graphicboxhshift}{%
          -\marginparwidth-\marginparsep-\graphicboxheight+\graphiccreditshift}%
        \setlength{\graphicboxvshift}{\marginparwidth+5pt}%
        \renewcommand{\graphicside}{east}%
        \renewcommand{\graphicotherside}{west}%
        \renewcommand{\graphicrotateangle}{-90}%
      \fi%
      \begin{tikzpicture}[remember picture,overlay]
        \node[%draw=red, thick,
              anchor=\graphicside,
              %rotate=0,%\graphicrotateangle,
              rotate around={\graphicrotateangle:(\thegraphiccount)},
              xshift=\graphicboxhshift, yshift=\graphicboxvshift,
              inner sep=0pt]
          (graphicbox\thegraphiccount)
          at ([yshift=0pt]current page text area.\graphicotherside|-\thegraphiccount)
          {\IfBooleanTF{#1}{\scriptsize#4}{\scriptsize\faCopyright\space#4}};%
          %{\scriptsize\faCopyright\space#4};%
      \end{tikzpicture}%
    }{\centering%
      \@afterindentfalse\@afterheading%
      #3}%
    \IfValueT{#2}{% Insert in \captionsetup inside the option warning from the `caption' package
      \captionsetup{type=graphic, font=footnotesize, textfont=it, %skip=2pt,
        format=plain, indention={1mm+.5em}, list=false}% To avoid "Unused \captionsetup[graphic]..."
      \captionof{graphic}{#2}%
    }%
  }[#5]%
}

%- Side graphic: environment for unmumbered figure or illustration (with or without a caption)
\DeclareDocumentCommand{\sidegraphic}{s o m g}{%
  % Syntax − #1 = no star = copyright symbol, star = no copyright symbol
  %          #2 = caption text
  %          #3 = margin contents: an image file (or more) included with \includegraphics
  %          #4 = optional copyright/source of the graphic (graphics are different from figures)
  %\hspace{0pt}%
  \leavevmode% https://tex.stackexchange.com/questions/395826 (That's the solution! Marvellous!)
  \marginpar{% more flexible, but... Lost floats?
  %\marginnote{% Seems to solve the "lost floats" issue. Yes, but... to clarify and be understood
    %\vspace*{2pt}% compensate an unknown gap TODO: find the issue!
    %\vspace*{\baselineskip}% compensate an unknown gap TODO: find the issue!
    \IfValueTF{#4}{%
      \stepcounter{graphiccount}%
      \graphictikzmark{\thegraphiccount}%
      %- Box height measurement is done with the same command used for margin ToC (see below)
      \begin{measurebox}[nobeforeafter]{\graphicboxheight}%, show bounding box
        \centering%
        \@afterindentfalse\@afterheading%
        #3%
      \end{measurebox}%
      \strictpagechecktrue%
      \checkoddpage%
      \ifoddpageoroneside%
        \setlength{\graphicboxhshift}{\marginparsep}%
        \setlength{\graphicboxvshift}{5pt}%
        \renewcommand{\graphicside}{west}%
        \renewcommand{\graphicotherside}{east}%
        \renewcommand{\graphicrotateangle}{90}%
      \else%
        \settowidth{\graphiccreditshift}{%
          \IfBooleanTF{#1}%
            {\scriptsize\space#4}%
            {\scriptsize\faCopyright\space#4}%
        }%
        %\setlength{\graphicboxhshift}{%
        %  -\marginparwidth-.5\marginparsep-.5\graphiccreditshift-0.4pt}%-0.8pt}%-1.6pt}% thick=0.8pt
        \setlength{\graphicboxhshift}{%
          -\marginparwidth-\marginparsep-\graphicboxheight+\graphiccreditshift}%
        \setlength{\graphicboxvshift}{\marginparwidth+5pt}%
        \renewcommand{\graphicside}{east}%
        \renewcommand{\graphicotherside}{west}%
        \renewcommand{\graphicrotateangle}{-90}%
      \fi%
      \begin{tikzpicture}[remember picture,overlay]
        \node[%draw=red, thick,
              anchor=\graphicside,
              %rotate=0,%\graphicrotateangle,
              rotate around={\graphicrotateangle:(\thegraphiccount)},
              xshift=\graphicboxhshift, yshift=\graphicboxvshift,
              inner sep=0pt]
          (graphicbox\thegraphiccount)
          at ([yshift=0pt]current page text area.\graphicotherside|-\thegraphiccount)
          {\IfBooleanTF{#1}{\scriptsize#4}{\scriptsize\faCopyright\space#4}};%
          %{\scriptsize\faCopyright\space#4};%
      \end{tikzpicture}%
    }{\centering%
      \@afterindentfalse\@afterheading%
      #3}%
    \IfValueT{#2}{% Insert in \captionsetup inside the option warning from the `caption' package
      \captionsetup{type=graphic, font=footnotesize, textfont=it, %skip=2pt,
        format=plain, indention={1mm+.5em}, list=false}% To avoid "Unused \captionsetup[graphic]..."
      \captionof{graphic}{#2}%
    }%
  }%
}

%- Side movie/video (full margin environment with the video counter)
\DeclareDocumentCommand{\sideVideo}{o m m D<>{\faVideoCamera}}{%
  %\FloatBarrier% process all floats before this point so the figure-like stuff numbers stay in order
  \marginelement{%
    %\strictpagechecktrue\checkoddpage\ifoddpage\RaggedRight\else\RaggedLeft\fi%
    %\refstepcounter{video}%
    \begin{minipage}{\marginparwidth}%
      \captionsetup*{type=video, font=footnotesize,
        format=plain, indention={1mm+.5em}, list=false}%
      %\hbox{}\vspace*{#1}%
      \centering%
      \@afterindentfalse\@afterheading%
      \href{run:#2}{#3}%
      \IfValueT{#1}{\captionof{video}{#1}}%
    \end{minipage}%
  }
  %\IfValueT{#1}{\sidecaptionlist{video}{#1}}%
  \IfValueT{#1}{%
    \IfNoValueTF{#4}%
      {\sidecaptionlist{video}{#1}}%
      {\sidecaptionlist{video}{#1\textcolor{secondcolor}{%
        \normalfont\footnotesize\ifblank{#4}{}{\enspace}#4}}}%
  }
}

%--- Caution margin boxes
%------------------------
%- One more time, the idea comes from TeX.SX. With adding tikzmark, it is reused for the display
%- of partial chapter ToCs. See:
%- create-a-framed-environment-for-a-margin-note
%-   http://tex.stackexchange.com/questions/120224/
%- prevent-overlap-in-margins-by-blocking-some-vertical-space?
%-   http://tex.stackexchange.com/questions/258437/
%---
%- More largely, see also:
%- margin-notes-with-a-pointing-arrow-that-are-automatically-vertically-adjusted
%-   http://tex.stackexchange.com/questions/78193/
%- tikz-node-in-margin-right-to-other-node-interacts-with-tcbtheorem
%-   http://tex.stackexchange.com/questions/257731/
%---

\newcommand\jazztikzmark[1]{%
  \tikz[remember picture,overlay]\node[inner xsep=0pt,outer sep=0pt] (#1) {};}

\newcommand{\defaultcautionboxname}{}
\ifdoc@english
  \renewcommand{\defaultcautionboxname}{Caution!}
\else% French
  \renewcommand{\defaultcautionboxname}{Attention !}
\fi

%- Gonzalo Medina's code inserted in a `\marginnote'
\newcounter{cautioncount}
\NewDocumentCommand{\cautionright}{O{\defaultcautionboxname} m}{%
  \stepcounter{cautioncount}%
  \jazztikzmark{\thecautioncount}%
  %\begingroup
  % Original code with `sidenotes' package
  %\let\thesidenote\relax
  %\let\refstepcounter\@gobble
  %\sidenote{%
  \marginnote{%
    \begin{tikzpicture}[remember picture, overlay]
    \node[draw=secondcolor,thick,anchor=west,xshift=\marginparsep,yshift=0pt,inner sep=4pt]
      (cautionbox\thecautioncount)
      at ([yshift=3pt]current page text area.east|-\thecautioncount)
      {\parbox{\marginparwidth-8pt}{\footnotesize#2}};
    \node[fill=white,font=\color{secondcolor},anchor=west,inner sep=1.8pt,xshift=7pt,yshift=0pt]
      at (cautionbox\thecautioncount.north west)
      {\scriptsize\enspace\textcolor{black}{\textsc{#1}}\enspace};
    \fill[secondcolor]
      ([yshift=3pt]cautionbox\thecautioncount.west) --
      ([xshift=-3pt]cautionbox\thecautioncount.west) --
      ([yshift=-3pt]cautionbox\thecautioncount.west) -- cycle;
    \end{tikzpicture}%
  }%
  %\endgroup
}

%- Extended code for two-side documents (http://tex.stackexchange.com/questions/78193/)
\newcounter{xcautioncount}
\newlength\trianglexshift
\newlength\boxhshift
\newlength\boxvshift
\newlength\noteheight
\newlength\uppertrianglecorner
\newcommand\side{}
\newcommand\boxanchor{}
\newcommand\otherside{}
\newcommand\pointeranchor{}

\newcommand\cautiontikzmark[1]{%
  \tikz[remember picture,overlay]\node[inner xsep=0pt,outer sep=0pt] (#1) {};}

\NewDocumentCommand{\caution}{O{c} D<>{secondcolor} m G{\defaultcautionboxname}}{%
  \checkoddpage
  \ifoddpageoroneside
    \setlength\trianglexshift{-3pt}%
    \setlength\boxhshift{\marginparsep}%
    \renewcommand{\side}{west}%
    \renewcommand{\otherside}{east}%
  \else
    \setlength\trianglexshift{3pt}%
    \setlength\boxhshift{-\marginparsep}%
    \renewcommand{\side}{east}%
    \renewcommand{\otherside}{west}%
  \fi%
  \settoheight{\noteheight}{\parbox{\marginparwidth-8pt}{\footnotesize#3}}%
  \stepcounter{xcautioncount}%
  \cautiontikzmark{\thexcautioncount}%
  \if#1b\relax
    \renewcommand\pointeranchor{xcautionbox\thexcautioncount.south \side}%
    \renewcommand\boxanchor{south \side}%
    \setlength\boxvshift{\noteheight}%
    \addtolength\boxvshift{-.6\baselineskip}% Adjust the vertical shift with the text line
    \setlength\uppertrianglecorner{13pt}%
  \else
    \if#1t\relax
      \renewcommand\pointeranchor{xcautionbox\thexcautioncount.north \side}%
      \renewcommand\boxanchor{north \side}%
      \setlength\boxvshift{-\noteheight}%
      \addtolength\boxvshift{.6\baselineskip}% Adjust the vertical shift with the text line
      \setlength\uppertrianglecorner{-7pt}%
    \else
      \if#1c\relax
        \renewcommand\pointeranchor{xcautionbox\thexcautioncount.\side}%
        \renewcommand\boxanchor{\side}%
        %\setlength\boxvshift{\baselineskip}% No vertical shift, just centered with the text line
        \setlength\uppertrianglecorner{3pt}%
      \fi%
    \fi%
  \fi%
  %- To avoid overlapings between with \sideNote the tikzpicture itself is wrapped into a \sidenote
  %- inside the definition of \caution and the numbering must be disabled, see:
  %- https://tex.stackexchange.com/questions/258437/[...]
  %-   [...]prevent-overlap-in-margins-by-blocking-some-vertical-space
  %\begingroup
  %\let\thefootnote\relax% This doesn't work with the footnote counter (may be with sidenotes.sty?)
  %\let\refstepcounter\@gobble
  \marginnote{% Original
  %\sideNote{% TODO: FIX THE REMAINED BUGS − For the moment being \caution must be ajusted manually
    \begin{tikzpicture}[remember picture, overlay]% Original
    % Note that the 'overlay' option has to be canceled out in this case.
    %\begin{tikzpicture}[remember picture]% It roughly works, but horizontal gap must be corrected
      \node[draw=#2,thick,anchor=\side,xshift=\boxhshift,yshift=\boxvshift,inner sep=4pt]
        (xcautionbox\thexcautioncount)
        at ([yshift=3pt]current page text area.\otherside|-\thexcautioncount)
        {\parbox{\marginparwidth-8pt}{\vskip4pt\footnotesize#3\vskip2pt}};
        %{\parbox{\marginparwidth}{\vskip10pt\RaggedRight\small#3}};
      \node[fill=white,font=\color{#2}\sffamily,anchor=west,inner sep=2pt,xshift=7pt,yshift=0pt]
        at (xcautionbox\thexcautioncount.north west)
        {\footnotesize\enspace\textcolor{black}{\textsc{#4}}\enspace};
      \fill[#2]
        ([yshift=\uppertrianglecorner]\pointeranchor) --
        ([yshift=\uppertrianglecorner-3pt,xshift=\trianglexshift]\pointeranchor) --
        ([yshift=\uppertrianglecorner-6pt]\pointeranchor) -- cycle;
    \end{tikzpicture}%
  }%
  %\endgroup
}

%--- "To do" marginal notes
%------------------------

%- This section must be completed to use so-called "todo-notes"
%- For the moment beeing, this package is used to allow margin graphic displaying from a tcolorbox
%- (see "glossary" section below)

%\RequirePackage{todonotes}


%---------------------------------------------------------------------------------------------------
%---- Loading the "zref" referencing system to be used by all positionning and graphical stuff
%---------------------------------------------------------------------------------------------------

\RequirePackage{zref-savepos}
\RequirePackage{zref-user}
\RequirePackage{zref-abspage}


%---------------------------------------------------------------------------------------------------
%----    Highlighting
%---------------------------------------------------------------------------------------------------

%--- SEE ALSO THE `tikzpagelayer' PACKAGE

%--- Highlighting part of text with marginal comment
%---------------------------------------------------
%- Still an idea stolen to Gonzalo Medina
%- highlighting-arbitrary-chunks-of-text-connected-to-quotes-in-margins
%-   http://tex.stackexchange.com/questions/49832/
%-----

%----- Highlighting/underlying the text with zref and TikZ
%- See the cool links:
%- https://tex.stackexchange.com/questions/203299/draw-tikz-highlighting-on-the-background-of-text
%- https://tex.stackexchange.com/questions/5959/cool-text-highlighting-in-latex
%- https://tex.stackexchange.com/questions/334528/the-current-state-of-the-art-tikz-underliner
%- https://tex.stackexchange.com/questions/335232/stacking-lengths-and-pop-them-off
%- https://tex.stackexchange.com/questions/176111/mixing-underline-and-strike-out
%- https://tex.stackexchange.com/questions/57537/[...]
%-    [...]issues-and-potentiality-of-the-tikzmark-macro-dynamic-box-adaptation
%-----

%----- Highlighting a paragraph with vertical lines/decoration in the margin
%- See for example:
%- https://tex.stackexchange.com/questions/86693/[...]
%-     [...]is-it-possible-to-use-tikz-to-draw-a-background-on-the-printed-page
%- https://tex.stackexchange.com/questions/52561/[...]
%-     [...]mark-highlight-a-paragraph-item-with-a-squiggly-line-for-later-attenti
%- https://tex.stackexchange.com/questions/10606/putting-a-bar-in-the-margin
%- https://tex.stackexchange.com/questions/175755/vertical-line-next-to-a-block-with-no-margins
%- https://tex.stackexchange.com/questions/436250/colored-bar-next-to-text-over-multiple-pages
%- https://tex.stackexchange.com/questions/1559/adding-a-large-brace-next-to-a-body-of-text
%- https://tex.stackexchange.com/questions/24140/[...]
%-     [...]installing-background-and-foreground-page-layers-with-tikz
%-----

%-- Coloured text background shortcuts

\RequirePackage{cancel}
\RequirePackage{soul}
%\RequirePackage{soulutf8}
%\RequirePackage{soulpos}% by Javier Bezos (TODO: see doc. in order to use it, may be better way)

\colorlet{emphColor}{black!10}
%\colorlet{emphColor}{darkelectricblue}
\colorlet{highlightColor}{darkelectricblue}
%\colorlet{highlightColor}{yellow}
%\sethlcolor{highlightColor!25}
%\sethlcolor{emphColor}
\sethlcolor{yellow}

%-- Corrected code for `soul' package
%- From: http://tex.stackexchange.com/questions/48501/soul-broken-highlighting-with-xcolor
\newdimen\SOUL@dimen %new
\def\SOUL@ulunderline#1{{%
  \setbox\z@\hbox{#1}%
  \SOUL@dimen=\wd\z@ %new
  \dimen@i=\SOUL@uloverlap
  \advance\SOUL@dimen2\dimen@i %\dimen@ exchanged too
  \rlap{%
    \null
    \kern-\dimen@i
    \SOUL@ulcolor{\SOUL@ulleaders\hskip\SOUL@dimen}% new
  }%
  \unhcopy\z@
}}

%-- Coloured paragraph shortcuts
\newcommand{\emphpar}[2][]{% colored background, optional margin stuff (symbol, icon)
  \ifemptyarg{#1}
    {\setlength{\fboxsep}{1pt}\fcolorbox{firstcolor!25!white}{firstcolor!25!white}{%
      \parbox{\dimexpr \linewidth-2\fboxsep-2\fboxrule}{#2}}}
    {\llap{\textcolor{firstcolor}{#1}~}%
    %{\vskip\parskip\llap{\textcolor{firstcolor}{#1}~}\vspace{-3\parskip}%
      \fcolorbox{firstcolor}{firstcolor!25!white}{%
        \parbox{\dimexpr \linewidth-2\fboxsep-2\fboxrule}{#2}}}%
}

%\def\SOUL@hlpreamble{%
%    \setul{}{3.5ex}% increased by 1ex
%    \let\SOUL@stcolor\SOUL@hlcolor
%    \dimen@\SOUL@ulthickness
%    \dimen@i=-.75ex % increased by -0.25ex
%    \advance\dimen@i-.5\dimen@
%    \edef\SOUL@uldepth{\the\dimen@i}%
%    \let\SOUL@ulcolor\SOUL@stcolor
%    \SOUL@ulpreamble
%}
%\newcommand{\boxemph}[1]{{\hl{~#1~}}}
%\newcommand{\codebox}[1]{{\ttfamily\hyphenchar\font=45\relax\hl{~#1~}}}

\newcommand\markText[3][1cm]{%
  \marginnote{\jazztikzmark{e}\color{highlightColor}\scriptsize\itshape#3}[#1]\jazztikzmark{s}\hl{#2}
  \begin{tikzpicture}[remember picture, overlay]
  \draw[highlightColor] let \p1=(s), \p2=(e) in ($(\x2,\y1)-(\marginparsep,0)$) -- (e);
  \end{tikzpicture}
}

%-- Souligner du texte avec césure (\underline tjrs disponible en mode math)

\RequirePackage[normalem]{ulem}% Mises en exergue étendues (sans redéfinir \emph{})

% Commandes :  \uline{important}=underline + \uuline{urgent}=double-underline
%  + \uwave{boat}=wavy-underline +  \sout{wrong}=line through words + \xout{removed}=marked-over
%   + \dashuline{dashing}=dashed underline + \dotuline{dotty}=dotted underline
%- TODO: Définir des commandes \uemph{}, \uuemph{}, \delword{}, etc.

%-- Gestion de boites encadrées
%------------------------------

%\RequirePackage{fancybox}

%-- Filling lines: custom \hrulefill (Herbert Voß)
%-------------------------------------------------

%- cf. http://tex.stackexchange.com/questions/17124/what-is-the-rule-equivalent-to-hrule
%\RequirePackage{xhfill}% Usage:


%---------------------------------------------------------------------------------------------------
%---- Caption management / Gestion des légendes des environnements `figure', `table' et autres...
%---------------------------------------------------------------------------------------------------

%-- Gestion des légendes de flottants
%------------------------------------

%- Powerful helper package for setting caption layouts
\RequirePackage{caption}% To be loaded *after* french-babel

%-- Format des légendes / Captions formating
%-------------------------------------------

%- Caption layout
\newcommand{\captionlayout}{%
  \raisebox{-.25\baselineskip}{\tikz\fill[secondcolor] (0,0) rectangle (1mm, \baselineskip);}%
}

%- Defining a 'jazz caption' style
\DeclareCaptionLabelFormat{jazzcaptionlabelfmt}{% name=#1 and number=#2
  \captionlayout\enspace\textcolor{black!80}{\textsc{#1}}\space#2%
}
\DeclareCaptionLabelSeparator{jazzcaptionlabelsep}{% "French" label separator
  %\textcolor{secondcolor}{\enspace\textemdash{}\enspace}%
  \space\textcolor{secondcolor}{\textemdash}\space%
}
\DeclareCaptionTextFormat{jazzcaptiontext}{%
  \color{black}#1%\hskip 1pt #1%
}
\DeclareCaptionStyle{jazzcaptionstyle}{%
  labelsep=jazzcaptionlabelsep,
  labelformat=jazzcaptionlabelfmt,
  textformat=jazzcaptiontext,
  format=hang,
  % format=plain,
  singlelinecheck=false,
  justification=justified,
  %indention={1mm+0.5em},% layout width + \enspace
  font=footnotesize,
  textfont=it,
  width=\linewidth,
  list=true,
  skip=5pt,
  %hypcap=true, %hypcapspace=\baselineskip,
}

%- Defining a 'jazz caption basic' style
\DeclareCaptionLabelFormat{jazzcaptionbasiclabelfmt}{% no name=#1 and no number=#2
  \captionlayout%
}
\DeclareCaptionLabelSeparator{jazzcaptionbasiclabelsep}{% no label separator just horizontal space
  \enspace% \enspace = 0.5em
}
\DeclareCaptionTextFormat{jazzcaptionbasictext}{%
  \color{black}#1%\hskip 1pt #1%
}
\DeclareCaptionStyle{jazzcaptionbasicstyle}{%
  labelsep=jazzcaptionbasiclabelsep,
  labelformat=jazzcaptionbasiclabelfmt,
  textformat=jazzcaptionbasictext,
  format=hang,
  % format=plain,
  singlelinecheck=false,
  justification=justified,
  %indention={1mm+0.5em},% layout width + \enspace
  font=footnotesize,
  textfont=it,
  width=\linewidth,
  list=true,
  skip=5pt,
  %hypcap=true, %hypcapspace=\baselineskip,
}

%- Application selon le type de flottants
\captionsetup[figure]{% Figure
  style=jazzcaptionstyle, position=bottom, %justification=raggedleft,
  width=\linewidth,
  %aboveskip=8pt, belowskip=\parskip
}
%\captionsetup[subfigure]{% Figure TODO properly!
%  style=jazzcaptionstyle, format=plain, position=bottom, justification=justified,% RaggedRight,
%  %aboveskip=8pt, belowskip=\parskip
%}
\captionsetup[table]{% Table
  style=jazzcaptionstyle, position=top,% justification=justified,
  width=\linewidth,
  %aboveskip=\parskip, skip=8pt% belowskip=8pt
}
\captionsetup[video]{% Video
  style=jazzcaptionstyle, position=bottom,
  width=\linewidth,
  %aboveskip=8pt, belowskip=\parskip
}
\captionsetup[graphic]{% Graphic
  style=jazzcaptionbasicstyle, position=bottom,
  %style=jazzcaptionstyle, position=bottom,
  width=\linewidth,
  %aboveskip=8pt, belowskip=\parskip
}
\captionsetup[duplicata]{% Document externe (PDF) inséré
  style=jazzcaptionstyle, position=top,
  width=\linewidth,
  %aboveskip=8pt, belowskip=\parskip
}
\captionsetup[training]{% Training = Formation (cf. classe de CV)
  style=jazzcaptionstyle, position=top,
  width=\linewidth,
  %aboveskip=8pt, belowskip=\parskip
}
\captionsetup[code]{% Code
  style=jazzcaptionstyle, position=top,% justification=justified,
  width=\linewidth,
  %aboveskip=\parskip, skip=8pt% belowskip=8pt
}
%- For the time being, please do not use "listing" environment inside "exercise" environments:
%- the captions are not yet correctly implemented. Use "code" and "code*" environments.
%- However, you can use the "listingbox" environment as such.
\captionsetup[listing]{% Listing − The listing environment is defined by the `minted' package
  style=jazzcaptionstyle, position=top,% justification=justified,
  width=\linewidth,
  %aboveskip=\parskip, skip=8pt% belowskip=8pt
}

%-- Commandes de mise en forme pour certains environnements flottants supplémentaires
%------------------------------------------------------------------------------------

%- wrapfig : options spécifiques
\captionsetup[wrapfigure]{format=plain, indention={1mm+.5em}}
\captionsetup[wraptable]{format=plain, indention={1mm+.5em}}
\captionsetup[wrapgraphic]{format=plain, indention={1mm+.5em}}
\captionsetup[wrapvideo]{format=plain, indention={1mm+.5em}}
\captionsetup[wrapcode]{format=plain, indention={1mm+.5em}}
%\captionsetup[wraplisting]{format=plain, indention={1mm+.5em}}
%\captionsetup[wrapfigure]{name=Fig., format=hang}%  wrapfig : options spécifiques
%\captionsetup[wrapfigure]{name=Fig.,format=plain}%  wrapfig : options spécifiques
%\captionsetup[wraptable]{name=Tab.}%  wrapfig : options spécifiques à cette extention
%\captionsetup[longtable]{}    %  longtable : options spécifiques à cette extention
%\captionsetup[figwindow]{}    %  picinpar : options spécifiques à cette extention
%\captionsetup[tabwindow]{}    %  picinpar : options spécifiques à cette extention
%\captionsetup[parpic]{}      %  picsin : options spécifiques à cette extention
%\captionsetup[SCfigure]{}    %  sidecap : options spécifiques à cette extention
%\captionsetup[SCtable]{}      %  sidecap : options spécifiques à cette extention

%----- Namely
%- Star version: \caption*{} typeset the caption without label and without entry in LoF or LoT
%-----
%\captionsetup*[SCtable]{style=jazzSideCaptionStyle, justification=raggedouter}
%\captionsetup*[SCfigure]{style=jazzSideCaptionStyle, justification=raggedouter}
%\captionsetup[SCtable]{style=jazzSideCaptionStyle, justification=raggedouter}
%\captionsetup[SCfigure]{style=jazzSideCaptionStyle, justification=raggedouter}
%\captionsetup*[figure]{style=jazzcaptionstyle, justification=RaggedRight, position=bottom}
%\captionsetup*[table]{style=jazzcaptionstyle, justification=RaggedRight, position=bottom}

%-- Gestion des figures multiples et des légendes / Multiple figures and captions management
%-------------------------------------------------------------------------------------------

%- Comptabilisation des subfigures et subtables dans LoF et LoT
\RequirePackage{subcaption}%

%- Configuration modifiable ensuite à l'intérieur d'un flottant particulier (cf. subcaption.sty)
\captionsetup[sub]{%
  font=footnotesize, textfont=it, justification=centering, hypcap=false, list=false,
  format=plain, width=\linewidth, labelformat=parens, labelsep=space}%

%-- Ajustement de l'espace vertical autour des environnements « flottants » (\@endfloat latex.ltx)

%---
%- As a reminder, the skips around captions have default values in article, report and book classes.
%- The `caption' package reset and balance automatically the skips (even *after* these settings,
%- it seems impossible to take control -set/add- on these lengths with tradionnal (La)TeX commands)
%\setlength{\abovecaptionskip}{1.5\parskip}% default=10pt
%\setlength{\belowcaptionskip}{1.5\parskip}% default={0\p@}
%- To control space around floating environments, a solution is `etoolbox' (see below)
%---

%- https://tex.stackexchange.com/questions/88001/when-to-use-letltxmacro
%- https://tex.stackexchange.com/questions/17504/[...]
%-   [...]how-to-redefine-the-caption-command-with-optional-arguments

\AtBeginEnvironment{figure}{%
  \vspace{.75\baselineskip}%
}
\AtEndEnvironment{figure}{%
  \vspace{.75\baselineskip plus 1pt minus 1pt}%
}
\AtBeginEnvironment{table}{%
  \vspace{.75\baselineskip plus 1pt minus 1pt}%
}
\AtEndEnvironment{table}{%
  \vspace{.75\baselineskip}%
}
\AtBeginEnvironment{graphic}{%
  \vspace{.75\baselineskip plus 1pt minus 1pt}%
}
\AtEndEnvironment{graphic}{%
  \vspace{.75\baselineskip}%
}
%\AtBeginEnvironment{video}{%
%  \LetLtxMacro\originalcaption\caption%
%  \renewcommand*{\caption}[2][]{%
%    \originalcaption[#1\enspace\textcolor{secondcolor}{\normalfont\small\faVideoCamera}]{#2}%
%}
\newcommand{\videosymbol}{\faVideoCamera}
\AtBeginEnvironment{video}{%
  \LetLtxMacro\originalcaption\caption%
  \RenewDocumentCommand{\caption}{ o m O{\videosymbol} }{%
    \IfValueTF{#1}{
      \IfValueTF{#3}%
        {\originalcaption[#1\enspace\textcolor{secondcolor}{\normalfont\footnotesize#3}]{#2}}%
        {\originalcaption[#1]{#2}}%
    }{\IfValueTF{#3}%
        {\originalcaption[#2\enspace\textcolor{secondcolor}{\normalfont\footnotesize#3}]{#2}}%
        {\originalcaption[#2]{#2}}%
    }%
  }
  \vspace{.75\baselineskip plus 1pt minus 1pt}%
}
\AtEndEnvironment{video}{%
  \vspace{\baselineskip}%
}
\AtBeginEnvironment{wrapvideo}{%
  \LetLtxMacro\originalcaption\caption%
  \RenewDocumentCommand{\caption}{ o m O{\videosymbol} }{%
    \IfValueTF{#1}{
      \IfValueTF{#3}%
        {\originalcaption[#1\enspace\textcolor{secondcolor}{\normalfont\footnotesize#3}]{#2}}%
        {\originalcaption[#1]{#2}}%
    }{\IfValueTF{#3}%
        {\originalcaption[#2\enspace\textcolor{secondcolor}{\normalfont\footnotesize#3}]{#2}}%
        {\originalcaption[#2]{#2}}%
    }%
  }
}
\newcommand{\codesymbol}{\faCode}
\AtBeginEnvironment{listing}{%
  \LetLtxMacro\originalcaption\caption%
  \RenewDocumentCommand{\caption}{ o m O{\codesymbol} }{%
    \IfValueTF{#1}{
      \IfValueTF{#3}%
        {\originalcaption[#1\enspace\textcolor{secondcolor}{\normalfont\small#3}]{#2}}%
        {\originalcaption[#1]{#2}}%
    }{\IfValueTF{#3}%
        {\originalcaption[#2\enspace\textcolor{secondcolor}{\normalfont\small#3}]{#2}}%
        {\originalcaption[#2]{#2}}%
    }%
  }
  \vspace{.75\baselineskip plus 1pt minus 1pt}%
}
\AtEndEnvironment{listing}{%
  \vspace{0.75\baselineskip}%
}
\AtBeginEnvironment{code}{%
  \LetLtxMacro\originalcaption\caption%
  \RenewDocumentCommand{\caption}{ o m O{\codesymbol} }{%
    \IfValueTF{#1}{
      \IfValueTF{#3}%
        {\originalcaption[#1\enspace\textcolor{secondcolor}{\normalfont\small#3}]{#2}}%
        {\originalcaption[#1]{#2}}%
    }{\IfValueTF{#3}%
        {\originalcaption[#2\enspace\textcolor{secondcolor}{\normalfont\tiny#3}]{#2}}%
        {\originalcaption[#2]{#2}}%
    }%
  }
  \vspace{.75\baselineskip plus 1pt minus 1pt}%
}
\AtEndEnvironment{code}{%
  \vspace{0.75\baselineskip}%
}

%-- Centrage des contenus des flottants / Centering the contents of floats (cf. TeX.SE)

%- All of the floats with `etoolbox' -> OK with/without arg but not for `wrapfigure' (logical TODO)
%\addto\@floatboxreset{\centering}% etoolbox way
%\g@addto@macro\@floatboxreset{\centering}% pure TeX way


%--- Side and margin captions
%----------------------------

%-- Margin caption (Will Robertson) / Also see the `floatrow' package but the doc. is obscure
%-- http://tex.stackexchange.com/questions/2547/margin-figures-captions/

% Will Robertson original
%\newcommand\margincaption[1]{%
%  \par
%  \setbox\@tempboxa=\hbox{\parbox{\marginparwidth}{\caption{#1}}}
%  \@tempdima=\dimexpr\ht\@tempboxa+\dp\@tempboxa\relax
%  \par\null\hfill\usebox\@tempboxa\par
%  \vspace*{\dimexpr-\@tempdima-\baselineskip\relax}
%}

%- Ideas and definitions are here borrowed to the `sidenotes` package
%\DeclareCaptionStyle{sidecaption}{font=footnotesize}
%  style=jazzcaptionbasicstyle, font=footnotesize, width=\marginparwidth}
\captionsetup[margingraph]{
    labelsep=jazzcaptionbasiclabelsep,
    labelformat=jazzcaptionbasiclabelfmt,
    format=plain,
    singlelinecheck=false,
    justification=justified,
    indention={1mm+0.5em},% layout width + \enspace
    font=footnotesize, textfont=it, textformat=jazzcaptiontext,
    width=\marginparwidth,
    list=false,
    skip=5pt,
    hypcap=true,% hypcapspace=\baselineskip,
  }
\NewDocumentCommand{\sidegraphcaption}{m}{%
  \marginnote{%
    \captionsetup[graphic]{
      style=jazzcaptionbasicstyle,
      font=footnotesize,
      width=\marginparwidth,
      list=false,
      aboveskip=0pt, belowskip=\parskip, skip=0pt,
    }%
    \captionof{graphic}{#1}%
  }[-1.25\baselineskip]% Vertical offset: see above the \captionlayout definition
}
\NewDocumentCommand{\sidecaption}{m m}{% side/margin caption
  % Syntax − #1 = type of content or fake "float"
  %          #2 = caption text
  \marginnote{%
    \ifstrequal{#1}{graphic}{%
      \captionsetup[#1]{
        style=jazzcaptionbasicstyle,
        font=footnotesize,
        width=\marginparwidth,
        list=false,
        aboveskip=0pt, belowskip=\parskip, skip=0pt,
      }%
    }{%
      \captionsetup[#1]{
        style=jazzcaptionstyle,
        font=footnotesize,
        width=\marginparwidth,
        format=plain,
        %list=false,
        aboveskip=0pt, belowskip=\parskip, skip=0pt,
      }%
    }%
    \captionof{#1}{#2}%
  }[-1.25\baselineskip]% Vertical offset: see above the \captionlayout definition
}
%\NewDocumentCommand{\sidecaption}{s o o m}{%
  %\marginnote{\captionof{graphic}{#1}}[-2.0\baselineskip]
  %\IfBooleanTF{#1}{% starred
  %  \IfNoValueOrEmptyTF{#2}
  %  {\marginnote{\caption*{#4}}}
  %  {\marginnote{\caption*{#4}}[#2]}
  %}{% unstarred
  %\IfNoValueOrEmptyTF{#2}
  %  {\def\@sidenotes@sidecaption@tof{#4}}
  %  {\def\@sidenotes@sidecaption@tof{#2}}
  %\IfNoValueOrEmptyTF{#3}
  %  {\marginnote{\caption[\@sidenotes@sidecaption@tof]{#4}}}
  %  {\marginnote{\caption[\@sidenotes@sidecaption@tof]{#4}}[#3]}
  %}
%}

\newcommand{\margingraphcaption}[1]{%
  \captionsetup*{type=graphic, font=footnotesize,
    format=plain, indention={1mm+.5em}, hypcap=true,% hypcapspace=-10.0\baselineskip,
    list=false}% Fake a graphic environment
  \marginpar{%
    \captionof{graphic}{#1}%
  }%
}

%-- Other solutions

%\RequirePackage{mcaption}% DOES NOT WORK!

%\RequirePackage[margincaption,outercaption]{sidecap}
%\sidecaptionvpos{figure}{t}
%\sidecaptionvpos{table}{t}

%----- Side caption note
%- Unfortunately, the '\captionof' command from the 'caption' package can't be used directly
%- in \marginpar and \marginelement: it leads to wrong placement in the "List of..."
%- A simple workaround is to add an entry in the "list of..." after margin caption typesetting.
%- This is done using the "list=false" option for the '\captionof' command and defining an entry
%- after the margin stuff displaying: namely the '\sidecaptionlist' command.
%-----

%-- Usefull commands for side captions to distinguish use case (automatical detection)
%------------------------------------------------------------------------------------

%- Margin figure caption
\newcommand{\sidefigcaptionof}[1]{%
  \captionsetup*{type=figure, font=footnotesize,
    format=plain, indention={1mm+.5em}, hypcap=true, hypcapspace=-10.0\baselineskip,
    list=false}% Fake a figure environment
  %\vspace*{-\baselineskip}%
  \captionof{figure}{#1}%
}
\newcommand{\sidesubfigcaptionof}[1]{%
  \captionsetup{type=subfigure, font=scriptsize,
    textfont=it, justification=centering,
    hypcap=false, list=false,% no LoF entry for subfigure (of course, it solves the problem!)
    format=plain, width=\linewidth,
    labelformat=parens, labelsep=space}% Fake a subfigure environment
  \captionof{subfigure}{#1}%
}

%- Margin table caption
\newcommand{\sidetabcaptionof}[1]{%
  \captionsetup*{type=table, font=footnotesize,
    format=plain, indention={1mm+.5em},
    list=false, hypcap=false}% Fake a table environment
  \captionof{table}{#1}%
}

%- Margin video caption
\newcommand{\sidevidcaptionof}[1]{%
  \captionsetup*{type=video, font=footnotesize,
    format=plain, indention={1mm+.5em},
    list=false, hypcap=false}% Fake a movie/video environment
  \captionof{video}{#1}%
}

%- Margin code caption − CAN'T BE USED IF NO CODE FLOATING ENVIRONMENT IS DEFINED
\newcommand{\sidecodecaptionof}[1]{%
  \captionsetup*{type=code, font=footnotesize,
    format=plain, indention={1mm+.5em},
    list=false, hypcap=false}% Fake a code environment
  \captionof{code}{#1}%
}

%- Margin listing caption
\newcommand{\sidelistingcaptionof}[1]{% Listing environment is defined below by the `minted' package
  \captionsetup*{type=listing, font=footnotesize,
    format=plain, indention={1mm+.5em},
    list=false, hypcap=false}% Fake a listing environment
  \captionof{listing}{#1}%
}

%- Margin 'fake float' environment caption content in "List of..."
\newcommand{\sidecaptionlist}[2]{% See contents insert with 'caption.sty'
  %\refstepcounter{#1}%
  \addcontentsline{\csname ext@#1\endcsname}{#1}%
    {\protect\numberline{\csname the#1\endcsname}{\ignorespaces #2}}%
}


%---------------------------------------------------------------------------------------------------
%----  Quotation
%---------------------------------------------------------------------------------------------------

%\renewenvironment{quote}
%  {\list{}{\rightmargin=2\parindent \leftmargin=2\parindent}\item\relax\guillemotleft\itshape}
%  {\guillemotright\endlist}



%-- Configuring the `displayquote' environment from the csquotes package

%- https://tex.stackexchange.com/questions/166173 (hanging-punctuation-with-quotation-marks)
%\renewcommand{\mkbegdispquote}[2]{\strut\llap{«}\itshape}
% #1 is closing punctuation, #2 is citation.
% We don't use them in this instance, but they
% need to be "catered for"
%\renewcommand{\mkenddispquote}[2]{#1''\ifblank{#2}{}{#2}}
% #1 is closing punctuation, #2 is citation.
% again, we provide for them if needed

%-- Quotation add-ons

\newcommand{\quoteStart}{
  \fontsize{3cm}{0mm}\selectfont%
  \color{middleGrey}%
  {\fontspec{Lora Bold Italic}“}
}
\NewDocumentCommand{\blockquotation}{o m}{% \blockquote already defined! Where?
  \vskip \baselineskip
  \hfill\begin{minipage}{.92\linewidth}
    \mbox{}%
    \setlength{\parindent}{0pt}%
    \setlength{\parskip}{\baselineskip}%
    \llap{\raisebox{-1.5cm}[0mm][0mm]{\quoteStart\hspace*{-16mm}}}
    {\itshape#2}
    \IfValueT{#1}{
      \setlength{\parskip}{\baselineskip/2}%
      \begingroup\setlength\topsep{0pt}
      \begin{flushright}
        --- #1
      \end{flushright}
      \endgroup
    }
  \end{minipage}
  \vskip \baselineskip
}

\DeclareDocumentCommand{\sidequote}{o m}{%
  \margincontent{%
    \llap{\raisebox{-1.8cm}[0mm][0mm]{\quoteStart\hspace*{-16mm}}}%
    %\llap{\raisebox{-1.8cm}[0mm][0mm]{\quoteStart\hspace*{-16mm}\isOddPage{}{\hspace*{-7mm}}}}%
    {\small\itshape#2}%
    \IfValueT{#1}{%
      \setlength{\parskip}{\baselineskip/2}%
      \begingroup\setlength\topsep{0pt}%
      \begin{flushright}%
        \small --- #1%
      \end{flushright}%
      \endgroup%
    }%
  }%
}

\DeclareDocumentCommand{\sideQuote}{o m}{%
  \marginelement{%
    \llap{\raisebox{-1.8cm}[0mm][0mm]{\quoteStart\hspace*{-16mm}}}%
    %\llap{\raisebox{-1.8cm}[0mm][0mm]{\quoteStart\hspace*{-16mm}\isOddPage{}{\hspace*{-7mm}}}}%
    {\itshape#2}%
    \IfValueT{#1}{%
      \setlength{\parskip}{\baselineskip/2}%
      \begingroup\setlength\topsep{0pt}%
      \begin{flushright}%
        --- #1%
      \end{flushright}%
      \endgroup%
    }%
  }%
}

\DeclareDocumentCommand{\fullQuote}{o m}{
  \vskip \baselineskip
  \begin{whole}
    \mbox{}
    \llap{\quoteStart}
    {\itshape#2}
    \IfValueT{#1}{
      \setlength{\parskip}{\baselineskip/2}%
      \begingroup\setlength\topsep{0pt}
      \begin{flushright}
        --- #1
      \end{flushright}
      \endgroup
    }
  \end{whole}
  \vskip \baselineskip
}

%-- With package `quoting' (egreg)
%- http://tex.stackexchange.com/questions/162782/how-to-configure-redefine-the-quotation-environment-to-cite
\RequirePackage{quoting}
\NewDocumentEnvironment{citequote}{m}
 {%
  \begin{quoting}[indentfirst=false,font=itshape]
  \bigquotes{r}{``}\ignorespaces
 }
 {%
  \unskip\bigquotes{l}{''}%
  \item\relax\hspace*{\fill}\citeauthor{#1}\ \textup{\cite{#1}}%
   \end{quoting}
 }
\newcommand{\bigquotes}[2]{%
  \makebox[0pt][#1]{%
    \raisebox{\dimexpr\fontcharht\font`A-\height}{\Large\bfseries#2}%
  }%
}


%---------------------------------------------------------------------------------------------------
%---- Elegant and fancy tables
%---------------------------------------------------------------------------------------------------

%-- New implementation of LaTeX's tabular and array
\RequirePackage{array}% mainly extending the control of columns (loaded by `colortbl' below)

%- Adding extra-height to the normal height of every row of the table (depth unchanged)
%\setlength{\extrarowheight}{1pt}% TODO: understanding the effects
%- Ajout global à la hauteur des lignes
%\renewcommand*{\arraystretch}{1.2}% stretch vertical heigth of lines

%-- New colum types shortcuts
\newcolumntype{=}{>{\global\let\currentrowstyle\relax}}
\newcolumntype{^}{>{\currentrowstyle}}
%\newcolumntype{=}{>{\rule[-2mm]{0pt}{4mm}\global\let\currentrowstyle\relax}}
%\newcolumntype{^}{>{\rule[-2mm]{0pt}{4mm}\currentrowstyle}}
\newcommand{\rowfontstyle}[1]{\gdef\currentrowstyle{#1}%
  #1\ignorespaces
}

%-- Others tabular extensions

\RequirePackage{tabularx}% extending tabular* for modifying certain width column
%\RequirePackage{delarray}% surrounding an array (math) with delimiters: parentheses, braces, etc.
\RequirePackage{xltabular}% Extend tabularx to pagebreaking the tabularx env.

%- New column type to center the values
%- http://tex.stackexchange.com/questions/89166/centering-in-tabularx-and-x-columns
\newcolumntype{Y}{>{\centering\arraybackslash}X}
\newcolumntype{Z}{>{\leavevmode\color{white}\columncolor{maincolor}}X}
%\newcolumntype{W}{>{\color{white}\columncolor{darkelectricblue}}c}% ALREADY DEFINED!! WHERE?

%- From: https://tex.stackexchange.com/questions/104544/vertically-center-text-in-tabularx-table
%\renewcommand\tabularxcolumn[1]{m{#1}}% for vertical centering text in X column

%-- Rotating side text column
\newsavebox{\tabularx@sideways@box}
\newenvironment{tabularxsideways}
  {\begin{lrbox}{\tabularx@sideways@box}}
  {\end{lrbox}\rotatebox[origin=c]{90}{\usebox{\tabularx@sideways@box}}}
\newcolumntype{R}{>{\begin{tabularxsideways}}c<{\end{tabularxsideways}}}

%-- Experimental table extensions (not traditional)

%\RequirePackage{ctable}% TODO: try and test

%-- Add colors to LaTeX tables: coloringrows, columns, and cells within table (minimally lines)

\RequirePackage{colortbl}% already loaded by the `xcolor' package option `table'

%- Commands: \columncolor[color-model]{color}[left-overhang][right-overhang]
%-          + \newcolumntype{name} + \rowcolor[color]{percentage-(ex:.75)}
%-          + \arrayrulecolor{color} + \doublerulesepcolor{color}
%- Table option: \rowcolors[commands]{row}{odd-row-color}{even-row-color} (before a table start)
%-
%- Colored lines: set color of ALL horizontal and vertical rules
%\arrayrulecolor{red}
%- New command to set rowfont without the `tabu' package
%\newcommand{\myrowfonttype}{}% Current row font
%\newcommand{\myrowfont}[1]{% Set current row font
%   \gdef\myrowfonttype{#1}#1%
%}
%\newcolumntype{L}{>{\myrowfonttype}l}
%\newcommand\setrowfont[1]{\noalign{\gdef\jazzrowfont{#1}}}
%\gdef\jazzrowfont{}
%- Il semble y avoir un problème entre \rowcolor(s) et \tabcolsep, voir :
%- http://tex.stackexchange.com/questions/35170/colortbl-rowcolor-in-tables-with-begintabularccc
%- http://tex.stackexchange.com/questions/262375/rowcolors-when-space-is-removed-with @{}
%- http://tex.stackexchange.com/questions/292503/remove-space-between-columns-in-longtabu-with-rowcolors
%- http://tex.stackexchange.com/questions/266255/table-with-multirow-and-rowcolors
%- http://tex.stackexchange.com/questions/294579/why-does-rowcolors-cut-matrix-delimiter
%- Solutions :
%- \newcolumntype{C}{c<{\kern\tabcolsep}@{}} + \begin{tabular}{@{}CCc@{}}
%- \begin{tabular}{@{}>{\columncolor{white}[0pt][\tabcolsep]}lll>{\columncolor{white}[\tabcolsep][0pt]}l@{}}

%-- Tableau étendu sur plusieurs pages / Multi-page version of tabular

\RequirePackage{longtable}% longtable environment

%- \rowcolors{<start-number>}{<color-odd-line>}{<color-even-line>} doesn't work properly with
%- the `longtable' package. Some adjustments have to be done (Heiko Oberdiek) see the link below
%- Usage: cf. http://tex.stackexchange.com/questions/170637/restarting-rowcolors
%- "To some degree the "resetting" is working, if it is done in the previous row. However the first
%- row should be white not lightgray according to \rowcolors and the row numbering is not working correctly.
%\@ifundefined{c@rownum}{%
%  \let\c@rownum\rownum
%}{}
%\@ifundefined{therownum}{%
%  \def\therownum{\@arabic\rownum}%
%}{}
%\newcommand*{\restartrowcolors}{%
%  \ifhmode\unskip\fi
%  \vadjust{\global\rownum=0}%
%}

\RequirePackage{ltxtable}% longtable environment for using with the `tabularx' package
%\RequirePackage{ltablex}% Extending the `tabularx' package environment to longtable
                         % Ça fout le bouzin sur les légendes et la numérotation, donc à oublier
%\RequirePackage{supertabular}% extended tabular over several page

%- Improvement version of supertabular: incompatible! Because `glossaries` package is loading
%- `glossary-super.sty' which is based on `supertabular` package (see below)
%\RequirePackage{xtab}% 

%-- Spaces in tables

\RequirePackage{makecell}% helper package to create common layout for tabular material
%\setcellgapes{5pt}

%-- Extension of tabular environment: coloured cell-line, math-verbatim and new environment, etc.
%-- + `longtabu' env. if `longtable' loaded, compatibility with colortbl, delarray
%-- !!! Take care: this package is no more maintained (but seems powerful and useful too)

\RequirePackage{tabu}% requires `array' and `varwidth' packages + others if loaded

%- New length to set tabu width
\newlength{\tabuwidth}
%\setlength{\tabuwidth}{\textwidth+\marginparwidth+\marginparsep-\tabcolsep}
%- Fancy coloured tabular
\colorlet{tableLineOne}{black!15}
\colorlet{tableLineTwo}{black!25}
\colorlet{tableBackTitleColor}{maincolor}
%\rowcolors[\hline]{3}{green!25}{yellow!50}
%\rowcolors[\hline]{2}{tableLineOne}{tableLineTwo}
%\taburowcolors[2] 2{tableLineOne .. tableLineTwo}
%\tabulinesep = ^4mm_3mm
%\tabulinesep = ^2.5mm_2mm
%\everyrow{\tabucline[1mm  orange]-}
%\everyrow{\midrule}
\newcommand{\jazzTabHeaderStyle}{%
%  \rowfont{\bfseries\sffamily\leavevmode\color{white}}
%\noalign{\gdef\fontcolor{\color{blue}}}
  \rowcolor{tableBackTitleColor}
  %\Gape[3.5mm][1.5mm]{}% makecell cmd
}
%- yReport set-up
\everyrow{\tabucline[.4mm  white]{}}
\taburowcolors[2] 2{tableLineOne .. tableLineTwo}
\tabulinesep = ^2.5mm_2mm
\newcommand{\tableHeaderStyle}{
  \rowfont{\bfseries\sffamily\leavevmode\color{white}}
  \rowcolor{secondcolor}
  \Gape[3.5mm][1.5mm]{}
}

%-- Composition de tableaux esthétiques / Composing aesthetical tables

\RequirePackage{booktabs}% elegant tabulars TODO: trying colored lines with colortbl

%\RequirePackage{booktabscolor}% ejazz tiny add-on to the `booktabs' package: colored rules
%- Setting color rule with `booktabscolor' : BUG with cmidrule!!!
%\booktabsrulecolor{secondcolor}
%- Setting vertical space around rules
%- Setting rule width
%\setlength{\heavyrulewidth}{.08em}                %défaut=.08em
%\setlength{\lightrulewidth}{.05em}                %défaut=.5em
%\setlength{\cmidrulewidth}{.03em}                %défaut=.3em
%\setlength{\belowrulesep}{.55ex}                  %défaut=.65ex
%\setlength{\aboverulesep}{.45ex}                  %défaut=.4ex
%\setlength{\defaultaddspace}{.05em}              %défaut=.5em
%\setlength{\cmidrulekern}{.25em}                  %défaut=.25em
%\abovetopsep=0pt
%\cmidrulesep=\doublerulesep
%\cmidrulekern=.5em
%\defaultaddspace=.5em

%-- Combinaison de booktabs et colortbl : redéfinition des espaces à zéro

%-- Cf.: how-do-i-eliminate-the-vertical-realignment-when-using-arrayrulecolor-with-cmidrule
%-- → https://tex.stackexchange.com/questions/32362/

\setlength{\aboverulesep}{0pt}
\setlength{\belowrulesep}{0pt}
%\setlength{\extrarowheight}{0.25ex}

\newcommand*{\ruletabfiller}{%
  \arrayrulecolor[gray]{0.8}% change to cell colour
  \specialrule{\heavyrulewidth}{0pt}{-\heavyrulewidth}% "invisible" rule
  \arrayrulecolor{black}% revert to regular line colour
}

\colorlet{tableheadcolor}{gray!35} % Table header colour = 25% gray
\newcommand{\topline}{%
  \arrayrulecolor{black}%
  \specialrule{\heavyrulewidth}{\abovetopsep}{0pt}%
  \arrayrulecolor{tableheadcolor}%
  \specialrule{\belowrulesep}{0pt}{0pt}%
  \arrayrulecolor{black}%
}
\newcommand{\midline}{%
  \arrayrulecolor{tableheadcolor}%
  \specialrule{\aboverulesep}{0pt}{0pt}%
  \arrayrulecolor{black}%
  \specialrule{\lightrulewidth}{0pt}{0pt}%
  \arrayrulecolor{white}%
  \specialrule{\belowrulesep}{0pt}{0pt}%
  \arrayrulecolor{black}%
}

%-- Autre astuce (David Carslisle)

%- http://tex.stackexchange.com/questions/129713/tabular-environment-for-specified-width-bg-and-font-colorings-by-row
% >{\fontcolor}c  >{\fontcolor}l  >{\fontcolor}X
%\newcommand\fontcolor{}
%- Usage: \noalign{\gdef\fontcolor{\color{blue}}}

%-- Autre astuce pour gérer les fontes par ligne (Werner) avec `array.sty'
%\g@addto@macro{\endtabular}{\rowfont{}}% Clear row font
%\newcommand{\rowfonttype}{}% Current row font
%\newcommand{\rowfont}[1]{% Set current row font
%   \gdef\rowfonttype{#1}#1%
%}

%-- Adding "footnote" like notes after a paragraph, a table, a section, etc.

%- Restart option: reset numeration with each \parnotes display
%- Breakwithin: insert a line break after every parnote displaying
\PassOptionsToPackage{restart,breakwithin}{parnotes}
\RequirePackage{parnotes}%

%- Parnotes configuration
\renewcommand{\theparnotemark}{\fnsymbol{parnotemark}}% parnotemark is the counter of parnotes
%\renewcommand{\theparnotemark}{\textit{\alph{parnotemark}}}
\renewcommand{\parnotevskip}{0pt}%\smallskipamount
\renewcommand{\parnotecusmarkfmt}[1]{\textsuperscript{#1}}
\renewcommand{\parnotefmt}[1]{%
  % \narrower = left and right margins like in quote environment
  %\vskip -6pt\narrower\footnotesize\sffamily\itshape
  \vskip -6pt\footnotesize\sffamily\itshape
  %\hspace*{-\parindent}%
  \noindent\textcolor{firstcolor}{\rule{.3333\linewidth}{.4pt}}\\
  #1\par
  %\noindent\rule{\linewidth}{1pt}
}
%- Sets the parnote mark (included as a MANDATORY argument) -> from source `parnotes.sty'
\renewcommand\parnotemark[1]{%
    \leavevmode
    \ifhmode
        % Save the spacefactor, like \footnote
        \edef\@x@sf{\the\spacefactor}%
        \FN@mf@check
        \nobreak
    \fi
    \parnotecusmarkfmt{#1}% Original
    %#1{.}\space% Avoid \textsuperscript in \parnotes but put it in the call also! FIXME
    \FN@mf@prepare
    \ifhmode\spacefactor\@x@sf\fi
    \relax
}

%- Defining a mark for identical parnotes text (no incrementing): only the last parnote is displayed
%\newcommand{\jazzparnotemark}{\fnsymbol{1}}

%- Add-on to use with tabularx: \parnoteclear % tabularx will otherwise add each note thrice
%TODO: ne fonctionne pas avec tabularx !!!!!!!!!!
%- The below command `\parnoteclear' is now included in the package (2016-08-15)
%\def\parnoteclear{%
%    \gdef\PN@text{}%
%    \parnotereset
%}

\RequirePackage{threeparttable}
\def\TPTnoteLabel#1{\llap{#1.}\hfil}
%\def\TPTnoteLabel#1{\llap{\small\tnote{#1}}\hfil}
%\def\TPTnoteLabel#1{\llap{\normalsize\tnote{#1}}}

%-- Gestion de boîtes dans les tableaux (cf. `makecell' qui semble mieux intégrer ces possibilités)

%- Deux commandes :  \backslashbox{bas}{haut} (-\-} et \slashbox{bas}{haut} (-/-}
%- slasbox.sty n'est plus dans TeXLive (pb de licence), inclu et remplacé par diagbox.sty
%\RequirePackage{diagbox}


%--------------------------------------------------------------------------------------------------
%---- Footnotes management / Gestion des notes de bas de page
%--------------------------------------------------------------------------------------------------

%--- TODO: Please have a look to the Clemens Niederberger's `fnpct' and `snotez' package s!

\RequirePackage{fnpct}

%- Appel des notes de bas de page : application de couleur adéquate
%\def\@makefnmark{\hbox{\@textsuperscript{\normalfont\textcolor{secondcolor}{\@thefnmark}}}}

%- Contrôle des espaces verticales entre notes de bas de page
%\newlength{\jazzfootnotesep}
%\setlength{\jazzfootnotesep}{\baselineskip}
%\addtolength{\jazzfootnotesep}{-.25\footnotesep}
%\setlength{\footnotesep}{\jazzfootnotesep}

\renewcommand{\thefootnote}{\alph{footnote}}% footnotes a, b, c... (sidenote 1, 2, 3...)

%- Ligne séparatrice de footnotes aux couleurs du document
\newif\iffootnote@rule
%\footnote@ruletrue
\footnote@ruletrue

\renewcommand\footnoterule{% Redefining from book.cls
  \iffootnote@rule
    \kern-3\p@
    {\color{firstcolor}\hrule\@width.3333\columnwidth}% Default thickness=0.4pt
    \kern2\p@
  \else% https://tex.stackexchange.com/questions/312793/toggle-presence-of-footnote-rule
    \advance\skip\footins 4\p@\@plus2\p@\relax%
  \fi
}
\interfootnotelinepenalty=10000% pour éviter l'extension des footnotes sur plusieurs pages

%- Reprise et généralisation de la définition de French Babel
\ifdoc@polyglossia% Pour polyglossia
  \newcommand*{\dotFFN}{.}
  \newcommand*{\kernFFN}{\kern .5em}
  \long\def\@makefntextFB#1{
    %\parindent=\parindentFFN
    \parindent=\z@
    \rule\z@\footnotesep
    \setbox\@tempboxa\hbox{\@thefnmark}%
    \ifdim\wd\@tempboxa>\z@
      \llap{\@thefnmark\dotFFN\kernFFN}%
    \fi #1
  }%
  \AtBeginDocument{%
    \long\def\@makefntext#1{\@makefntextFB{#1}}%
  }%
%\else% Pour French Babel, reprise afin d'être sûr...
  % NON PROBANT AT ALL !!! FIX ME!
  %\renewcommand*{\dotFFN}{.}%
  %\renewcommand*{\kernFFN}{\kern .5em}%
  %\settowidth{\FBfnindent}{\dotFFN\kernFFN}%
  %\providecommand\localleftbox[1]{}%
  %\addtolength{\FBfnindent}{\parindentFFN}%
  %\setlength{\parindentFFN}{0pt}%}%\FBfnindent
  %\providecommand*{\insertfootnotemarkFB}{%
  %  \parindent=\parindentFFN
  %  \textcolor{green}{\rule\z@\footnotesep}
  %  \setbox\@tempboxa\hbox{\@thefnmark}%
  %  \ifdim\wd\@tempboxa>\z@
  %    \llap{\@thefnmark}\dotFFN\kernFFN
  %  \fi%
  %}
  %\providecommand\@makefntextFB[1]{\insertfootnotemarkFB #1}%
%  \long\def\@makefntext#1{%
%    \localleftbox{}%
%    \let\FBeverypar@save\FBeverypar@quote
%    \let\FBeverypar@quote\relax
%    \ifFBFrenchFootnotes
%      \@makefntextFB{#1}%
%    \else
%      \@makefntextORI{#1}%
%    \fi
%    \let\FBeverypar@quote\FBeverypar@save
%    \localleftbox{\FBeveryline@quote}%
%  }%
%  \long\def\@makefntextFB#1{%
%    \vspace*{-\baselineskip}%
%    \localleftbox{}%
    % French layout
%    \parindent=\parindentFFN
%    \parindent=\z@%
%    %\rule\z@\footnotesep
%    %\textcolor{darkelectricblue}{\hrule\@width.3333\columnwidth}%
%    \setbox\@tempboxa\hbox{\@thefnmark}%
%    \ifdim\wd\@tempboxa>\z@
%      %\llap{\@thefnmark}\dotFFN\kernFFN
%      \llap{\textcolor{secondcolor}{\@thefnmark\dotFFN\kernFFN}}%
%    \fi
%    \vspace*{-2.0\baselineskip}%
    %\llap{\color{secondcolor}\@thefnmark\dotFFN\kernFFN}%
%    #1%
%  }%
%  \AtBeginDocument{%
%    \long\def\@makefntext#1{\@makefntextFB{#1}}%
%  }%
\fi

%- Notes de bas de page dans un environnement `minipage'
%\long\def\@makefntextMP#1{% Temporary command used just below
%  %\parindent=\parindentFFN
%  \parindent=\z@
%  \addtolength{\footnotesep}{-2pt}
%  \rule\z@\footnotesep
%  % letter class like definition
%  \noindent
%  \hangindent 10\p@
%  %\hb@xt@5\p@{\hss\@makefnmark}#1% Original definition
%  \hb@xt@10\p@{\hss\@thefnmark\dotFFN\kernFFN}#1%
%}%
%%\skip\@mpfootins = \skip\footins% from letter.cls
%\skip\@mpfootins=\medskipamount
%%\skip\footins=\bigskipamount % space added when footnote is present
%\long\def\@mpfootnotetext#1{% Minipage footnotes redefining from latex.ltx
%  \global\setbox\@mpfootins\vbox{%
%    \unvbox\@mpfootins
%    \reset@font\footnotesize
%    %\reset@font\scriptsize
%    %\addtolength{\columnwidth}{.5em}
%    \hsize\columnwidth
%    %\hsize\linewidth
%    \@parboxrestore
%    \protected@edef\@currentlabel
%      {\csname p@mpfootnote\endcsname\@thefnmark}%
%    \color@begingroup
%      %\@makefntext{%
%      \@makefntextMP{%
%        \rule\z@\footnotesep\ignorespaces#1\@finalstrut\strutbox}%
%    \color@endgroup%
%  }%
%}

%- Framed footnotes (like caution notes, but for footnote displaying)
%- See: https://tex.stackexchange.com/questions/312793/toggle-presence-of-footnote-rule
\newcommand\footnotetikzmark[1]{%
  \tikz[remember picture,overlay]\node[inner xsep=0pt,outer sep=0pt] (#1) {};}

\newcounter{boxedfootnotecount}

%- Reprise de la définition de French Babel (Gonzalo Medina's adapted code)
\newcommand*{\dotboxedfnt}{.}
\newcommand*{\kernboxedfnt}{\kern 1.25em}
\long\def\@makefntextBox#1{
  \footnote@rulefalse% See `texjazz-frlayout.def`
  \stepcounter{boxedfootnotecount}%
  \footnotetikzmark{\theboxedfootnotecount}%
  \setbox\@tempboxa\hbox{\@thefnmark}%
  \ifdim\wd\@tempboxa>\z@
    %\llap{\@thefnmark\dotboxedfnt\kernboxedfnt}%
    \hspace*{-6pt}
    \begin{tikzpicture}
      \node[
        draw=firstcolor,
        thick,
        anchor=north,
        inner xsep=4pt,
        inner ysep=0pt,
        text width={\linewidth-8pt}]
        (footnotebox\theboxedfootnotecount)
        at ([yshift=3pt]current page text area.west|-\theboxedfootnotecount)
        {\llap{\textcolor{secondcolor}{\@thefnmark\dotboxedfnt\kernboxedfnt}}%
          \parbox{\linewidth}{\footnotesize#1}};
      \fill[firstcolor]
        ([yshift=3pt]footnotebox\theboxedfootnotecount.west) --
        ([xshift=-3pt]footnotebox\theboxedfootnotecount.west) --
        ([yshift=-3pt]footnotebox\theboxedfootnotecount.west) -- cycle;
    \end{tikzpicture}
  \fi
}%
%\AtBeginDocument{%
  %\newcommand{\boxedfootnote}[1]{\long\def\@makefntext#1{\@makefntextBox{#1}}}%
  %\newcommand{\boxedfootnote}[1]{\@makefntextBox{#1}}%
  %\long\def\@makefntext#1{\@makefntextBox{#1}}%
  %\renewcommand\@makefntext[1]{%
  %  %\parindent 1em\noindent\hb@xt@1.8em{\hss\@makefnmark}#1}% Original from latex.ltx
  %  \llap{\@makefnmark\dotboxedfnt\kernboxedfnt}#1%
  %}
%}

%-- Gestion de boîtes dans les tableaux (cf. `makecell' qui semble mieux intégrer ces possibilités)
%--------------------------------------------------------------------------------------------------

%- Deux commandes :  \backslashbox{bas}{haut} (-\-} et \slashbox{bas}{haut} (-/-}
%- slasbox.sty n'est plus dans TeXLive (pb de licence), inclu et remplacé par diagbox.sty
%\RequirePackage{diagbox}


%--------------------------------------------------------------------------------------------------
%---- Itemize, enumerate, description and other lists
%--------------------------------------------------------------------------------------------------

%-- Customizing lists environments (adaptation of Babel-french layout)

\ifdoc@polyglossia
  %- French itemize, enumerate and other list environments
  %- TODO→ Harmonizing and condensing with the texjazz-typography package
  \input{texjazz-frlayout.def}% From French Babel package (TODO workaround=enumitem package)
\else
  %- Ajustements des espaces verticaux (reprise commandes frenchb)
  \newlength{\listendsep}% personal length for end of lists (see below redefinition of trivlist)
  \def\FB@listVsettings{% Adapted from french-babel 2020/04/18 v3.5h
    \setlength{\itemsep}{.5\parskip}%
    \setlength{\parsep}{\z@}%
    \setlength{\topsep}{\z@}%
    \setlength{\partopsep}{\z@}%
    \@tempdima=\parskip
    \addtolength{\topsep}{-.5\@tempdima}%
    \addtolength{\partopsep}{\@tempdima}%
    \setlength{\listendsep}{\@tempdima - \itemsep + \topsep}%
  }
  \def\FB@listHsettings{% Adapted from french-babel 2020/04/18 v3.5h
    \ifFBListItemsAsPar
      \itemindent=\labelindentFB
      \advance\itemindent by \labelwidthFB
      \advance\itemindent by \labelsep
      \leftmargini\z@
      \bbl@for\FB@dp {2, 3, 4, 5, 6}%
        {\csname leftmargin\romannumeral\FB@dp\endcsname =
          \labelindentFB}%
    \else
      \leftmarginFB=\labelwidthFB
      \advance\leftmarginFB by \labelsep
      \bbl@for\FB@dp {1, 2, 3, 4, 5, 6}%
        {\csname leftmargin\romannumeral\FB@dp\endcsname =
          \leftmarginFB}%
      \advance\leftmargini by \listindentFB
    \fi
    \leftmargin=\csname leftmargin%
      \ifnum\@listdepth=\@ne i\else ii\fi\endcsname
  }
  %- French itemize environment
  \def\FB@itemizesettings{% Updated to french-babel 2020/04/18 v3.5h
    \ifFBStandardListSpacing
    \else
      \setlength{\itemsep}{\z@}% +vspace between items (\itemsep + \parsep)
      \setlength{\parsep}{\z@}% vspace between items
      %\setlength{\parsep}{0.5pt plus 0.5pt minus 0.5pt}% vspace between items
      \setlength{\topsep}{\z@}% +vspace before list (\topsep + \partopsep)
      \setlength{\partopsep}{\z@}% +vspace before list if empty line
      \@tempdima=\parskip
      %\addtolength{\topsep}{-\@tempdima}% valeur initiale FB
      %\addtolength{\topsep}{-.5\@tempdima}%
      \addtolength{\partopsep}{-0.25\@tempdima}%
      %\setlength{\listendsep}{\@tempdima - \topsep}%
      \setlength{\listendsep}{\z@}%
    \fi
    \settowidth{\labelwidth}{\csname\@itemitem\endcsname}%
    \ifFBListOldLayout
      \setlength{\leftmargin}{\labelwidth}%
      \addtolength{\leftmargin}{\labelsep}%
      \addtolength{\leftmargin}{\parindent}%
    \else
      \FB@listHsettings
    \fi
  }
  %- French enumerate environment: same definition as french-babel 2020/04/18 v3.5h (NO CHANGE)
  %- Description environnement: same definition as french-babel 2020/04/18 v3.5h (NO CHANGE)
  \renewcommand*\descriptionlabel[1]{\hspace\labelsep\normalfont\lightboldfont #1}
\fi

%-- More list commands

%- Keep the Babel-French definitions alive (if lists env. are redefined with `enumitem' package)

\NewDocumentEnvironment{fritemize}{   }%
  {\itemizeFB}%
  {\enditemizeFB}
  
\NewDocumentEnvironment{frenumerate}{   }%
  {\enumerateFB}%
  {\endenumerateFB}

\NewDocumentEnvironment{frdescription}{   }%
  {\descriptionFB}%
  {\enddescriptionFB}

\newcommand*{\jazzitem}[1][]{%
  \ifemptyarg{#1}
    {\renewcommand{\FrenchLabelItem}{\textcolor{itemcolor}{\normalfont\faCaretRight}}}
    {\renewcommand{\FrenchLabelItem}{\textcolor{itemcolor}{\normalfont #1}}}%
}
\newcommand*{\jazzcaret}{%
  \textcolor{itemcolor}{\normalfont\faCaretRight}%
}

%-- Side, tabular and check itemized environments (no/small indentation)

\newenvironment{jazzitemize}{%
  \renewcommand*{\FrenchLabelItem}{\textcolor{maincolor}{\normalfont\faCaretRight}}
  \settowidth{\labelwidthFB}{\normalfont\faCaretRight}
  \setlength{\listindentFB}{0pt}
  \itemizeFB}
  {\enditemizeFB}
\newenvironment{sideitemize}{%
  \renewcommand*{\FrenchLabelItem}{\textcolor{maincolor}{\normalfont\faCaretRight}}
  \setlength{\listindentFB}{4pt}
  \itemizeFB}
  {\enditemizeFB}
\newenvironment{tabitemize}{%
  \renewcommand*{\FrenchLabelItem}{\textcolor{secondcolor}{\normalfont\faCaretRight}}
  \setlength{\listindentFB}{0pt}
  \itemizeFB}
  {\enditemizeFB}
\newenvironment{checkitemize}{%
  \renewcommand*{\FrenchLabelItem}{\faSquareO}
  \setlength{\listindentFB}{6pt}
  \itemizeFB}
  {\enditemizeFB}
\newenvironment{tabuitemize}{%
  \renewcommand*{\FrenchLabelItem}{\textcolor{secondcolor}{\normalfont\faCaretRight}}
  \renewcommand*{\FrenchLabelItem}{}
  \setlength{\listindentFB}{0pt}
  \setlength{\leftmarginFB}{0pt}
  \itemizeFB}
  {\enditemizeFB}

%- Idcard environment (based on description without indentation) EXPERIMENTAL/OBSOLETE/DEPRECATED
\newenvironment{idcard}% original definition of `description' from `book.cls'
               {\list{}{\labelwidth\z@ \itemindent-\leftmargin
                        \let\makelabel\descriptionlabel}}
               {\endlist}

%-- Étendre les possibilités de numération des enumérations

%- Ne modifie pas les espaces verticales (contrairement à enumitem)

\RequirePackage{enumerate}% Options de numérotation [i], [I], [a], [A], etc.

%- NE PAS UTILISER POUR LE MOMENT ! → CELA MODIFIE TOUTES LES LISTES ÉTABLIES
%- TODO TODO: REPRENDRE TOUS LES PARAMÈTRES DE RÉGLAGES DES MACROS DE LISTES AVEC CETTE EXTENSION
%- Exemple de possibilité :
%- https://tex.stackexchange.com/questions/6360/refer-to-customized-enumerate-counter
%\RequirePackage{enumitem}% Reprise complète des possibiltés de listes et d'énumération (puissant)

%- https://tex.stackexchange.com/questions/1669/resuming-a-list
%- Dans l'immédiat, la fonctionnalité intéressante est de pouvoir continuer l'énumération
%- d'une liste d'un environnement à un autre. D'où l'extension ci-dessous
%\RequirePackage{mdwlist}% GNU Licence → TODO: insérer dans `texjazz-frlayout.def' ou autre
%- ÇA FOUT LE BOUZIN AUSSI !

%- BIDOUILLE MANUELLE EN ATTENDANT : ÇA FONCTIONNE NICKEL !
%- Bref, on s'en remet à David Carlisle et on fait une petite manip. pour sauver les compteurs
%- d'un environnement à l'autre :
%- https://tex.stackexchange.com/questions/53102/how-to-have-the-same-counter-in-two-enumerate-lists
\def\saveenum{\xdef\@savedenum{\the\c@enumi\relax}}
\def\resetenum{\global\c@enumi\@savedenum}
%- Usage: (with or whithout label)
%- \begin{enumerate}
%- \item\label{condition1}the first condition,
%- \item\label{condition2}the second condition,
%- \end{enumerate}
%- [...]
%- \saveenum
%- \begin{enumerate}\resetenum
%- \item\label{condition3}the third condition.
%- \end{enumerate}

%-- Customizing lists environments (with the `enumitem' package)
%-- The following is correct, but this package is too complex to understand at now. As for now,
%-- we prefer the use of Babel-French, mostly because it is easier to set with other packages
%-- like, for example, our `assignpoints' and `askreply' packages

%\RequirePackage{enumitem}% Reprise complète des possibiltés de listes et d'énumération (puissant)

%\newcommand*{\itemizelabel}{\textemdash}  % ou \textendash (tiret plus court)
%\newlength\itemizelabelwidth
%\settowidth{\itemizelabelwidth}{\itemizelabel}

%\setlist[itemize]{label=\itemizelabel, nosep}
%\setlist[itemize]{
%  label=\itemizelabel,
%  labelwidth=\itemizelabelwidth, 
%  leftmargin=!,
%}
%\setlist[enumerate]{
%  label=\arabic*,
%  labelwidth=\itemizelabelwidth, 
%  leftmargin=!,
%}
%\setlist[1]{labelindent=\parindent}
%\setlist{% For all lists: itemize, enumerate, description
%  %labelwidth=\itemizelabelwidth, 
%  %leftmargin=!,
%  itemsep=.25\parskip,
%  parsep=\z@,
%  topsep=-.5\parskip,
%  partopsep=\parskip
%}


%---------------------------------------------------------------------------------------------------
%---- Specific extended environments (with the `tcolorbox' package)
%---------------------------------------------------------------------------------------------------

%-- `tcolorbox' package loads `pgf', `verbatim', `etoolbox' and `environ' packages

%- UBUNTU MATE 20.04: A LINK FROM PYTHON TO PYTHON3 *MUST BE DONE* IN /bin (AND MAYBE /usr/bin)
%- IN ORDER TO USE minted, tcolorbox with minted AND PythonTeX WITH PYTHON3:
%-   > sudo ln -s /bin/python3 /bin/python

\RequirePackage{tcolorbox}% Really amazing and versatile package (more robust than `mdframed')
%\RequirePackage{mdframed}% Deprecated: only for us! Good package too! →  Change to tcolorbox (DONE)

%-- Libraries in use

%\PassOptionsToPackage{chapter,newfloat=true}{minted}% Already loaded by the `minted' package

\tcbuselibrary{%
  breakable,% provides support for automatic box breaking from one page to another
  fitting,%
  listings,% loads 'listings' package to typeset code programming languages
  %listingsutf8,% loads 'listings' package to typeset code programming languages
  minted,% loads `minted' package, for the time being, only for Python (see PythonTeX below)
  raster,% aligns several colored boxes in a regular way
  skins,% loads `tikz' package and provides additionals (skins) for the colored boxes
  theorems,% provides support for mathematical contents (also loads `amsmath' package)
  xparse,% provides additional keys to extend the design of boxes and environments
  hooks,% provides additional keys to extend the control of the boxes display
  %poster,% supports creation of single page posters with `tcolorbox' boxes
  %magazine,% stores a `tcolorbox' into an array of box registers for later usage
  %vignette,% defines vignette from shapes and 'widgets' (loads skins and fadings TikZ libraries)
  %external,% supports externalization of snippets like graphics or boxes to be stand-alone compiled
}

%----- Important note about `tcolorbox'
%--------------------------------------
%- The first layer of a `tcolorbox' maybe breakable through pages (thanks to the `breakable'
%- library), but embedded `tcolorboxes' inside another `tcolorbox' are unbreakable. Consequently,
%- if one wants to be able to stack and use the features of the `tcolorbox' package inside a boxed
%- environment, the first layer must be designed with TikZ. This use case occurs for example with
%- an exercise environment defined within a `tcolorbox' (see below).
%- The second thing to notice is that floating environments are not allowed inside a `tcolorbox'.
%- Nevertheless, a floating environment (figure, table, etc.) may be embedded in a `tcolorbow'.
%-----

%-- Fullwidth environment other pages (twoside layout)
%-----------------------------------------------------

%----- Note about fullwidth environments
%---------------------------------------
%- The `fullwidth' package is not 100% compatible with embendded "tcolorboxes" and, moreover it's 
%- easier to define and manage (same syntax) a fullwidth environment with the `tcolorbox' package
%-----

%- Fullwidth over twoside several pages (derived from `mdframed.sty')
%\RequirePackage{fullwidth}% fullwidth over twoside several pages (derived from `mdframed.sty')

%- Setting up the `fullwidth' environment (Marco Daniel, derived from the `mdframed' package)
%- Cf. http://tex.stackexchange.com/questions/34368/how-to-switch-between-two-margin-sizes
%\fullwidthsetup{% The lengths MUST be calculated with dimexpr!!! cf. doc.
%  width=\dimexpr\textwidth+\marginparwidth+\marginparsep\relax,
%  skipabove=0pt, %skipbelow=0pt,% default=\topskip
%  leftmargin=0pt, rightmargin=0pt,% default = 0pt
%  %innertopmargin=1.5pt, innerbottommargin=8pt,% default=.4\baselineskip
%  twosidemode=true,% default=true
%  outermargin=\dimexpr-\marginparwidth-\marginparsep\relax,% default=0pt (only in twoside mode)
%  innermargin=0pt,% default=0pt (only in twoside mode)
%  %splittopskip=0pt,% default = \topsep,
%  %splitbottomskip=0pt,
%  %needspace=0pt,%default=0pt (sets a minimum height before the environment should be splitted)
%  %footnotedistance=10pt,%default=\bigskipamount (distance end fullwidth env. <> \footnoterule)
%}

%- Lengths and dimension layout
\setlength{\marginparpush}{\baselineskip}% vertical space of consecutive sidenotes
\setlength{\columnsep}{\marginparsep}

%- Saving some useful lengths
\newlength{\wholemargin}
\setlength{\wholemargin}{\marginparwidth}
\addtolength{\wholemargin}{\marginparsep}
\newlength{\entirewidth}
\setlength{\entirewidth}{\textwidth}
\addtolength{\entirewidth}{\wholemargin}

%-- Theorem environments
%-----------------------

%\newtcbtheorem[number within=chapter, crefname={théorème}{théorèmes}]%
%  {theorem}{Théorème}%
%  {colback=green!5, colframe=green!35!black, label separator=\faCaretRight}{th}
   %label separator=\faCaretRight, fonttitle=\lightboldfont}{th}

%\newtcbtheorem[number within=chapter]{theorem}{Théorème}%
%  {colback=green!5, colframe=green!35!black, label separator=\faCaretRight}{th}








%-- Full width environments
%--------------------------

%- Cf. http://tex.stackexchange.com/questions/2547/margin-figures-captions/2561#2561
\newenvironment{fullbreadth}{%
  \begin{adjustwidth*}{0pt}{\wholemargin}
    \strictpagechecktrue%
    \checkoddpage%
    \ifoddpage%
      \captionsetup{margin={0pt,-\wholemargin}}% margin={<left>,<right>} OR width=<length>
    \else%
      \captionsetup{margin={-\wholemargin,0pt}}% margin={<left>,<right>} OR width=<length>
    \fi%
}{\end{adjustwidth*}}

%- Cf. https://tex.stackexchange.com/questions/396660/ and doc. v.4.30 p.46
\NewTColorBox{fullwidth}{ o }{%
  enhanced, 
  breakable,
  blank,
  check odd page, 
  toggle left and right, 
  grow to right by=\marginparwidth+\marginparsep, 
  toggle enlargement=evenpage, 
  notitle after break,
  nobeforeafter,
  boxsep=0pt,
  top=4pt, bottom=4pt,% middle = 2pt,% additional to boxsep
  arc=0pt,% Default: arc=1mm
  boxrule=0pt,
  left=0pt, right=0pt,
  IfValueTF={#1}{#1}{}% More options comma separated
}

%- Encadré pleine largeur
\NewTColorBox{fullinsert}{ o g }{%
  enhanced, 
  breakable,
  %blank,
  parbox=false,
  check odd page, 
  toggle left and right, 
  grow to right by=\marginparwidth+\marginparsep, 
  toggle enlargement=evenpage, 
  %notitle after break,
  %nobeforeafter,
  boxsep = 0pt,% default=1mm
  toptitle=5pt, bottomtitle=3pt,% additional to boxsep, default=0mm
  lefttitle = 6pt, righttitle = 6pt,% additional to boxsep, default=4mm
  IfValueTF={#2}{%
    title=\strut\textsc{\boxtitlefont #2~\hrulefill}%  
  }{title={}},
  top = 6pt, bottom = 4pt,% additional to boxsep, default=2mm
  left = 6pt, right = 6pt,% additional to boxsep, default=4mm
  before skip=10pt,
  after skip=2pt,
  %arc=0pt,% Default: arc=1mm
  colbacktitle=black!75,%secondcolor,
  colback=gray!20,
  arc = 0pt, outer arc = 0pt,
  boxrule = 0pt,
  %IfValueTF={#2}{title=\textttl{#2}}{title={}},
  IfValueTF={#1}{#1}{}% More options comma separated
}


%----- Note about `tcolorbox' counting, labeling and listing (§4.21 p.101, §5.1 p.111, §5.2 p.118)
%-------------------------------------------------------------------------------------------------
%--- Counting
%- Coloured boxes can be numbered by applying *initialization* options. It is strongly recommended
%- to use these options in the preamble, so in style and class extensions too. Counters assigned
%- using the initialization options are administrated automatically. Especially,they are increased
%- for each new box.
%- Independent from the real counter name, the counter value can be referenced by \thetcbcounter,
%- e.g. inside the title of the box. The real counter name is stored inside \tcbcounter.
%- Possible options are:
%-   auto counter, use counter from=<another-tcolorbox>, use counter=<latex-counter> (if the LaTeX
%-   counter is name linked to c@name, the internal counter is tcb@cnt@name/c@tcb@cnt@name),
%-   no counter (default), number within=<counter> (chapter, section, etc.),
%-   number format=<format-macro> (\arabic, \roman, etc.), number freestyle=<code> (full control)
%-   crefname={<singular>}{<plural>} and Crefname={<singular>}{<plural>} (need `cleveref' package)
%-   blend into=<name> (standard or defined environments where caption becomes title).
%--- Labeling
%- An automatical labeling can be easily done with the counters and the following options:
%-   label=<marker> (called with \ref{<marker>), e.g. <marker>=<name>:\thetcbcounter),
%-   label type=<type> (to be used in conjuction with the `cleveref' package which *must* be loaded
%-   separately, if not it leads to a compilation error).
%- Besides numbering and labeling, one may have a look to the options: "phantom", "nophantom",
%- "phantomlabel", "step" and "step and label".
%--- Listing
%- One may manage coloured boxes like LaTeX for the figures and tables (and their associated
%- \listoffigures and \listoftables commands and .lof and .lot files of entries). These features
%- are dependent to the following actions:
%-   1. Assign to the box a list <name> file extension (\listof<names> command and jobname.<name>
%-      file)) by the *initialization* option /tcb/new/list inside.
%-   2. Optionally, a new <type> for list entries in the file jobname.<name> may be assigned by
%-      the *initialization* option /tcb/new/list type. This type is used for titles and captions,
%-      typically the environment name.
%-   3. List entries are generated automatically within each box using the above initialization,
%-        a. If /tcb/list entry is set, the entry is generated with it.
%         b. Otherwise, if/tcb/title is set, the entry is generated with it.
%-        c. Otherwise, the entry is generated with the current number and the environment name.
%-   4. By default, the generated list is displayed by the \tcblistof command:
%-      \tcblistof[\section]{<name>}{<title>}
%- These settings are active if the box is numbered. Moreover, additional options may be used:
%- list text=<text> (shortcut for /tcb/list entry \protect\numberline{\thetcbcounter}<text>),
%- add to list={<list>}{<type>} (enforce an entry to the given <list> with the given <type>
%- \addcontentsline{<list>}{<type>}{<entry text>}).
%- Other options are available (see the documentation): nameref=<text>, hypertarget=<marker>,
%- bookmark=<text> and bookmark={<options>}{<text>}, index=<entry> and index={<name>}{<entry>}.
%-----

%- For the record, below is the definition of the `tcolorbox' package "addcontentsline" command
%- TAKE CARE that list entries are settled with "list entry" but also with "title" and "titletext"
%- The following redefinition avoid a solely "name + delimiter" ugly entry to be generated if
%- the "titletext" field is empty (see above point 3.c.)

\def\tcb@addcontentsline#1#2{%
  \ifx\kvtcb@listentry\@empty%
    \ifx\kvtcb@title\@empty%
      \ifx\tcbtitletext\@empty%
        %\addcontentsline{#1}{#2}{% Disabling a empty `texttitle' entry in the list of something
        %  \protect\numberline{\thetcbcounter}{\ignorespaces\kvtcb@savedelimiter}}%
      \else%
        \addcontentsline{#1}{#2}{\protect\numberline{\thetcbcounter}{\ignorespaces\tcbtitletext}}%
      \fi%
    \else%
      \addcontentsline{#1}{#2}{\protect\numberline{\thetcbcounter}{\ignorespaces\kvtcb@title}}%
    \fi%
  \else%
    \addcontentsline{#1}{#2}{\kvtcb@listentry}%
  \fi%
}

%----- Note about key value system obtained with the `pgfkeys` package
%- To have key value options for a command/environment (fisrt steps with the `pgfkeys' package,
%- which seems to be a good system and used by many packages already loaded such as the `tcolorbox'
%- package or with LaTeX3 syntax), see:
%-   https://tex.stackexchange.com/questions/34312/how-to-create-a-command-with-key-values
%-   https://tex.stackexchange.com/questions/506426/how-can-i-set-boolean-pgfkeys
%-   https://tex.stackexchange.com/questions/115017/defining-extensible-macros/115019#115019
%-   https://tex.stackexchange.com/questions/361402/execute-a-macro-given-in-a-key-value-in-expl3
%-----

%-- Surrounding codes and listings display with a `tcolorbox'/`tcblisting'
%-------------------------------------------------------------------------

%-- Resetting the display of code lines numbering column

\renewcommand{\theFancyVerbLine}{% See `minted' documentation
  %\sffamily\textcolor[rgb]{0.5,0.5,1.0}{\scriptsize\oldstylenums{\arabic{FancyVerbLine}}}}
  %\ttfamily\textcolor{black!50}{\tiny\oldstylenums{\arabic{FancyVerbLine}}}}%\listingfont
  \normalfont\textcolor{black!80}{\tiny\oldstylenums{\arabic{FancyVerbLine}}}%
}

%-- Defining new `tcolorbox' keys to set the `minted' options easily within a `tcblisting', see:
%--   https://tex.stackexchange.com/questions/124657/combine-minted-and-tcolorbox − Thomas F. Sturm

%-- The solution just below is given in case one wants to have a different environment for each code
%-- language, e.g. \begin{python} ... \end{python} (it calls \newminted command from `minted' pkg)

\newif\ifeachcode@environment\eachcode@environmentfalse

\ifeachcode@environment
  %- Defining new language code environments (not useful here: argument of "code" environment)
  \newcommand{\jazzmintedcode}[4]{% With this way, a "<code-language>" environment is created
    % Usage − [<environment-name-tcbpgfkeyvalue>]; {<minted-language>}; {<minted-options>}
    \newminted[#1]{#2}{#3}% It defines a #1=<name> environment
    % Usage − [<environment-name>]; {<minted-language>}; {<minted-options>} (cf. `minted' doc.)
    \tcbset{%
      jazz minted code layout/#1/.style = {%
        code={\renewcommand{\codesymbol}{#4}},
        minted language=#2,
        minted options={#3}%
      }%
    }%
  }
  %- Setting each language code environment
  \jazzmintedcode{python}{python}{% Defining a "python" environment and setting the layout
    tabsize=2, fontsize=\small, breaklines, autogobble,
    linenos=true, numbersep=4pt, xleftmargin=0pt, python3%
  }{\faPython}
  \jazzmintedcode{bash}{bash}{tabsize=2, fontsize=\small}{\faCode}% \mfShell or \mfScript?
  \jazzmintedcode{text}{text}{tabsize=2, fontsize=\small}{\faCode}% \mfShell or \mfScript?
\fi

%-- The second solution below is defining new "tcb-pgfkeys" for the language and layout options

%- Code language symbols dimensions

\newlength{\codesymbolheight}
\newlength{\codesymbolwidth}


%- Setting up new tcb/pgf keys for the code layout options

\tcbset{
  code box layout/.style={%
    enhanced,
    breakable,
    colback=black!5,
    colframe=firstcolor,
    boxsep=0pt,
    top=4pt, bottom=4pt,% middle = 2pt,% additional to boxsep
    arc=2pt,% Default: arc=1mm
    % outer arc=0pt,% No default: outer arc=unset
    boxrule=0.6pt,
    drop fuzzy shadow,
  },
  minted preset options/.style={% Defined to not erase but append other `minted` options
    minted options={%
      tabsize=2, breaklines, autogobble, 
      fontsize=\small, xleftmargin=0pt, 
      escapeinside=§§, %texcl=true, 
      #1}
  },
  code layout/.style={%
    listing only,
    listing engine=minted,
    minted style=default,% Set "spyder"/"eclipse" styles or an own style (between default and trac)
  },
  %code symbol/.is choice,
  %code symbol/.default=\faCode,
  code symbol/.style={%
    %- Caution! With `fontmfizz' package, a trailing space seems to be introduced after icons
    %- Please take care to use `fontawesome' packages instead, e.g.: \faPython vs \mfPython
    code={%
      \renewcommand{\codesymbol}{#1}%
      \settoheight{\codesymbolheight}{\large\codesymbol}%
      \settowidth{\codesymbolwidth}{\large\codesymbol}%
    },
    underlay={%
      \begin{tcbinvclipframe}
        \node[%xshift=-0.5\marginparsep,% middle of the margin separation
              xshift=(-0.5\codesymbolwidth-4pt),% always at top left of the frame
              yshift=(-0.5\codesymbolheight-1.2pt)]% 0.6pt = boxrule => 2*boxrule = 1.2pt
          at (frame.north west) {% \codesymbol has been defined above with \caption
            \textcolor{firstcolor}{\large\codesymbol}%
            %\setlength{\fboxsep}{0pt}\fbox{\textcolor{firstcolor}{\large\codesymbol}}%
          };%
      \end{tcbinvclipframe}
    },
  },
  code symbol only at title/.style={%
    %- Caution! With `fontmfizz' package, a trailing space seems to be introduced after icons
    %- Please take care to use `fontawesome' packages instead, e.g.: \faPython vs \mfPython
    code={%
      \renewcommand{\codesymbol}{#1}%
      \settoheight{\codesymbolheight}{\large\codesymbol}%
      \settowidth{\codesymbolwidth}{\large\codesymbol}%
    },
    %- https://tex.stackexchange.com/questions/511005/[...]
    %-    [...]tcolorbox-break-and-icon-only-at-the-left-of-the-title
    overlay unbroken app={%
      \begin{tcbinvclipframe}
        \node[%xshift=-0.5\marginparsep,% middle of the margin separation
              xshift=(-0.5\codesymbolwidth-4pt),% always at top left of the frame
              yshift=(-0.5\codesymbolheight-1.2pt)]% 0.6pt = boxrule => 2*boxrule = 1.2pt
          at (frame.north west) {% \codesymbol has been defined above with \caption
            \textcolor{firstcolor}{\large\codesymbol}%
            %\setlength{\fboxsep}{0pt}\fbox{\textcolor{firstcolor}{\large\codesymbol}}%
          };%
      \end{tcbinvclipframe}
    },
    overlay first app={%
      \begin{tcbinvclipframe}
        \node[%xshift=-0.5\marginparsep,% middle of the margin separation
              xshift=(-0.5\codesymbolwidth-4pt),% always at top left of the frame
              yshift=(-0.5\codesymbolheight-1.2pt)]% 0.6pt = boxrule => 2*boxrule = 1.2pt
          at (frame.north west) {% \codesymbol has been defined above with \caption
            \textcolor{firstcolor}{\large\codesymbol}%
            %\setlength{\fboxsep}{0pt}\fbox{\textcolor{firstcolor}{\large\codesymbol}}%
          };%
      \end{tcbinvclipframe}
    },
  },
  code symbol no flag/.style={%
    %- Caution! With `fontmfizz' package, a trailing space seems to be introduced after icons
    %- Please take care to use `fontawesome' packages instead, e.g.: \faPython vs \mfPython
    code={%
      \renewcommand{\codesymbol}{#1}%
      \settoheight{\codesymbolheight}{\large\codesymbol}%
      \settowidth{\codesymbolwidth}{\large\codesymbol}%
    },
  },
  numbering lines/.is choice,
  numbering lines/.default=true,
  numbering lines/true/.style={
    left=16pt, right=2pt,% additional to boxsep
    minted preset options={% To be added here not to erase the previous `minted` options setting
      linenos=true, numbersep=8pt, escapeinside=§§,
    },
    underlay={%
      \begin{tcbclipinterior}
        \fill[color=black!15]
          (frame.south west) rectangle ([xshift=12.0pt]frame.north west);
      \end{tcbclipinterior}
    },
  },
  numbering lines/false/.style={
    left=4pt, right=2pt,% additional to boxsep
    minted preset options={% To be added here not to erase the previous `minted` options setting
      linenos=false, numbersep=4pt, escapeinside=§§,
    },
    underlay={%
      \begin{tcbclipinterior}
        \fill[color=tcbcolback]
          (frame.south west) rectangle ([xshift=12.0pt]frame.north west);
      \end{tcbclipinterior}
    },
  },
}

%\NewDocumentCommand{\jazzmintedlanguage}{ m m o }{% Useless because erase the last `minted` options
\newcommand{\jazzmintedlanguage}[2]{%
  \tcbset{%
    %- Setting the language code option with a corresponding symbol at frame front
    code language/#1/.style={%
      minted language=#1,
      code symbol only at title=#2,
      %IfValueTF={#3}{%
      %  minted options={#3}% More code layout options, e.g. +python3 − NO! ERASE PREVIOUS SETTINGS
      %}{},
    }%
  }%
}

%- Initializing the code language and layout options

%\renewcommand{\codesymbol}{\faCode}% To be sure (already defined with \caption for code, see above)
\jazzmintedlanguage{python}{\xfaPython}%\mfUbuntu\faPython
%\jazzmintedlanguage{python}{\faPython}[python3]
%\jazzmintedlanguage{java}{\bfseries\faJava}% \mfJavaBold
\jazzmintedlanguage{java}{\xfaJavaBold}% \xfaJava\mfJavaBold\faJava\faJava
\jazzmintedlanguage{javascript}{\faJs}
\jazzmintedlanguage{cpp}{\xfaCplusplus}
\jazzmintedlanguage{c}{\xfaC}

\newcommand{\jazzmintedlanguagenosymbol}[2]{% No symbol in margin, but in List of Codes
  \tcbset{%
    %- Setting the language code option without a corresponding symbol at frame front
    code language no symbol/#1/.style={%
      minted language=#1,
      code symbol no flag=#2,
    }%
  }%
}
\jazzmintedlanguagenosymbol{python}{\xfaPython}%\mfUbuntu\faPython
%\jazzmintedlanguagenosymbol{python}{\faPython}[python3]
%\jazzmintedlanguagenosymbol{java}{\bfseries\faJava}% \mfJavaBold
\jazzmintedlanguagenosymbol{java}{\xfaJavaBold}% \xfaJava\mfJavaBold\faJava\faJava
\jazzmintedlanguagenosymbol{javascript}{\faJs}
\jazzmintedlanguagenosymbol{cpp}{\xfaCplusplus}
\jazzmintedlanguagenosymbol{c}{\xfaC}


%- Shebang commands (escaped because a comment character as first character leads to an error)

\definecolor{pyshebangcolor}{RGB}{119, 41, 83}% HTML: 772953 (radiant MATE)
\gdef\pyshebang{\color{pyshebangcolor}\bfseries\itshape\ttfamily\#{!}/usr/bin/env python3}

\definecolor{pyfirstcommentcolor}{RGB}{64, 128, 128}% HTML: 408080 (pygment/minted Python comment)
%\gdef\pyfirstcomment#1{\color{pyfirstcommentcolor}\itshape\ttfamily\# #1}


%- IDEA! For non floating environments, define a fake caption style and put it before the optional
%- title with an entry in the list of "environments name". Interesting to understand (La)TeX
%- internals, but far too complex compared to the definition of a new environment!

%----- Note about curved paths
%-----------------------------
%- For the record and inspiration, see:
%-  https://tex.stackexchange.com/questions/33607/easy-curves-in-tikz/33610#33610
%-  https://tex.stackexchange.com/questions/53445/how-to-draw-spherical-geometries-with-tex
%-  https://tex.stackexchange.com/questions/54771/[...]
%-   [...]curve-through-a-sequence-of-points-with-metapost-and-tikz
%-  https://tex.stackexchange.com/questions/255234/[...]
%-   [...]how-does-one-pick-control-points-to-control-b%c3%a9zier-curves-in-tikz
%-----

%-- Defining a new versatile code environment

%- Starred environments − Because the `minted' package interprets the star as a code language
%- character, the `xparse' syntax with starred arguments can't be used here.
%- So, two "code" environments are defined:
%-   1. A numbered "code" environment which has a entry in the "list of codes", either optionally
%-      given by a title or a caption. If both a caption and a title are given, only the caption is
%-      displayed. By default, the lines of code are numbered. If no title nor caption is settled,
%-      the "code" environment is equivalent to "code*" environment except the numbering of lines.
%-   2. A unumbered "code*" environment (previously defined by `minted` package when defining its
%-      corresponding unstarred "code" environment) without entry in the "List of Codes". A title
%-      may be optionally set for the "code*" box. By default, the lines of code are unnumbered.

%-- Adding a customised box to the "listing" environment: adapted clone from `tcolorbox' doc. p.319

\NewTCBListing{listingbox}{ o m }{% Code without symbol
  % Usage − \begin{listingbox}[<more-options>]{<code-language>}
  %           ...
  %         \end{listingbox}
  %before skip=\baselineskip,% Do not set it! It overwrites the `before' field below
  before={%
    \par\pagebreak[0]\parindent=0pt% Default autoparskip option (see doc. §4.14 p.81)
    %\vspace{4pt}%
  },
  %after skip=\baselineskip,% Do not set it! It overwrites the `after' field below
  after={\par\vspace{1.0\parskip}},
  code box layout,
  code layout,
  notitle,
  code language no symbol/#2,% Code language without `symbol`
  numbering lines=true,% Default=true
  box align=top,
  IfValueTF={#1}{#1}{}% More options comma separated
}

\NewTCBListing{listingbox*}{ o m }{% Code without symbol but fullwidth
  % Usage − \begin{listingbox}[<more-options>]{<code-language>}
  %           ...
  %         \end{listingbox}
  check odd page, 
  toggle left and right, 
  grow to right by=\marginparwidth+\marginparsep, 
  toggle enlargement=evenpage, 
  %before skip=\baselineskip,% Do not set it! It overwrites the `before' field below
  before={%
    \par\pagebreak[0]\parindent=0pt% Default autoparskip option (see doc. §4.14 p.81)
    %\vspace{4pt}%
  },
  %after skip=\baselineskip,% Do not set it! It overwrites the `after' field below
  after={\par\vspace{1.0\parskip}},
  code box layout,
  code layout,
  %notitle,
  %notitle after break,
  code language no symbol/#2,% Code language without `symbol`
  numbering lines=true,% Default=true
  box align=top,
  IfValueTF={#1}{#1}{}% More options comma separated
}

%-- Redefining the "code" environment (previously defined by the `newfloat`/`minted` package)

\NewTCBListing{codebox}{ o m }{% Code with symbol
    % Usage − \begin{code}[<more-options>]{<code-language>}
    %           ...
    %         \end{code}
    %before skip=\baselineskip,% Do not set it! It overwrites the `before' field below
    before={%
      \par\pagebreak[0]\parindent=0pt% Default autoparskip option (see doc. §4.14 p.81)
      \vspace{4pt}%
    },
    %after skip=\baselineskip,% Do not set it! It overwrites the `after' field below
    after={\par\vspace{2.0\parskip}},
    code box layout,
    code layout,
    code language/#2,% Code language and `symbol`
    numbering lines=true,% Default=true
    box align=top,
    IfValueTF={#1}{#1}{}% More options comma separated
}

\NewTCBListing{codebox*}{ o m }{% Code with symbol and full width
    % Usage − \begin{code}[<more-options>]{<code-language>}
    %           ...
    %         \end{code}
    %before skip=\baselineskip,% Do not set it! It overwrites the `before' field below
    before={%
      \par\pagebreak[0]\parindent=0pt% Default autoparskip option (see doc. §4.14 p.81)
      \vspace{4pt}%
    },
    %after skip=\baselineskip,% Do not set it! It overwrites the `after' field below
    after={\par\vspace{2.0\parskip}},
    check odd page, 
    toggle left and right, 
    grow to right by=\marginparwidth+\marginparsep, 
    toggle enlargement=evenpage, 
    %notitle after break,
    code box layout,
    code layout,
    code language/#2,% Code language and `symbol`
    numbering lines=true,% Default=true
    box align=top,
    IfValueTF={#1}{#1}{}% More options comma separated
}

\RenewTCBListing[
  use counter=code,
  list inside=loc,% to have a list of exercice with \tcblistof[\section]{<name>}{<title>}
  %- With "list type" field, a \l@code command must be defined OR done with `titletoc' package
  %- See: change-tcolorbox-tcblistof-font-formatting-to-match-documents-other-lists:
  %          https://tex.stackexchange.com/questions/353947/
  list type=code,% By default → Layout is done by \l@tcolorbox command
  ]{code}{ o m o g }{%
    % Usage − \begin{code}[<more-options>]{<code-language>}[<optional-title>]{<optional-caption>}
    %           ...
    %         \end{code}
    %before skip=\baselineskip,% Do not set it! It overwrites the `before' field below
    before={%
      \par\pagebreak[0]\parindent=0pt% Default autoparskip option (see doc. §4.14 p.81)
      %\vspace{4pt}
      \vspace{-\baselineskip}% WHY?
      %\vspace*{2.5\parskip}%
      %\vspace*{2pt}%
    },
    code box layout,
    code layout,
    code language/#2,% Code language and `symbol`
    numbering lines=true,% Default=true
    IfValueTF={#4}{% Adding a code caption with an entry in the "list of code" (LoC)
      before pre={%
        \addtocounter{code}{-1}% To avoid double increment: from the tcbox and from the captionof
        \captionof{code}{#4}%
      },
      IfValueTF={#3}{notitle}{notitle},% If a caption exists, no title at all is displayed
      label type={code},% To be used in cunjonction to the `cleveref' package
      label={code:\Roman{chapter}.\thetcbcounter},
    }{IfValueTF={#3}{% No caption but a title
        fonttitle=\footnotesize\lightboldfont,%\lightboldfont,%\titlingfont,
        coltitle=white,% Default=white
        attach boxed title to top right={% Title placement + options (doc. p.159-161)
          yshift=-\tcboxedtitleheight, yshifttext=-2pt,%-\tcboxedtitleheight/3,
          %yshift*=-\tcboxedtitleheight,% yshifttext is only set if necessary
        },
        boxed title style={% original code borrowed to `tcolorbox' (see doc. p.165)
          empty,
          boxsep=0pt,
          toptitle=0pt, bottomtitle=0pt,% default=0pt
          lefttitle=0pt, righttitle=0pt,% Default=4mm (additional to boxsep)
          left=6pt, right=4pt,% Default=4mm (additional to boxsep)
          top=1pt, bottom=0pt,% Default=2mm (additional to boxsep)
        },
        underlay boxed title={% Only drawn if a boxed title is given (cf. doc. §10.2.3 p.162)
          %- Bézier curve .. control .. don't work! Why? FIX ME!
          \path[draw=black!20, fill=firstcolor!75!black, line width=0.4pt]
            ([xshift=-\tcboxedtitleheight/2, yshift=0.0mm]title.north west)
            to [bend left=30] ([xshift=2pt, yshift=-1pt]title.west)
            [rounded corners=2pt]% arc=2pt − default
            -- ([xshift=4pt,yshift=0.0mm]title.south west)
            -- ([yshift=0.0mm]title.south east)
            -- ([yshift=0.0mm]title.north east)
            [sharp corners] -- cycle;
        },
        before title app={%
          \ifdoc@appendix
            \strut \textsc{Code \theappendixchapter.\thetcbcounter}%
          \else
            \strut \textsc{Code \thechapter.\thetcbcounter}%  
          \fi
        },
        title={\strut\space\textemdash\space #3},
        label={code:\Roman{chapter}.\thetcbcounter},
        %label={code:\Roman{chapter}.\string\c@code}},
        label type={code},% To be used in cunjonction to the `cleveref` package
        list entry={% Adding a code symbol in the "list of codes" entries
          \ifdoc@appendix    
            \protect\numberline{\theappendixchapter.\thetcbcounter}#3%
            \enspace\textcolor{secondcolor}{\normalfont\footnotesize\codesymbol}%
          \else
            \protect\numberline{\thechapter.\thetcbcounter}#3%
            \enspace\textcolor{secondcolor}{\normalfont\footnotesize\codesymbol}%
          \fi      
        },
      }{notitle},
    },
    %after skip=\baselineskip,% Do not set it! It overwrites the `after' field below
    %after={\par\vspace*{1.0\parskip}},
    IfValueTF={#1}{#1}{}% More options comma separated
}

\RenewTCBListing[
  use counter=code,
  list inside=loc,% to have a list of exercice with \tcblistof[\section]{<name>}{<title>}
  %- With "list type" field, a \l@code command must be defined OR done with `titletoc' package
  %- See: change-tcolorbox-tcblistof-font-formatting-to-match-documents-other-lists:
  %          https://tex.stackexchange.com/questions/353947/
  list type=code,% By default → Layout is done by \l@tcolorbox command
  ]{listing}{ o m o g }{%
    % Usage − \begin{code}[<more-options>]{<code-language>}[<optional-title>]{<optional-caption>}
    %           ...
    %         \end{code}
    %before skip=\baselineskip,% Do not set it! It overwrites the `before' field below
    before={%
      \par\pagebreak[0]\parindent=0pt% Default autoparskip option (see doc. §4.14 p.81)
      %\vspace{4pt}
      \vspace{-\baselineskip}% WHY?
      %\vspace*{2.5\parskip}%
      %\vspace*{2pt}%
    },
    code box layout,
    code layout,
    code language no symbol/#2,% Code language without `symbol`
    numbering lines=true,% Default=true
    IfValueTF={#4}{% Adding a code caption with an entry in the "list of code" (LoC)
      before pre={%
        \addtocounter{code}{-1}% To avoid double increment: from the tcbox and from the captionof
        \captionof{code}{#4}%
      },
      IfValueTF={#3}{notitle}{notitle},% If a caption exists, no title at all is displayed
      label type={code},% To be used in cunjonction to the `cleveref' package
      label={code:\Roman{chapter}.\thetcbcounter},
    }{IfValueTF={#3}{% No caption but a title
        fonttitle=\footnotesize\lightboldfont,%\lightboldfont,%\titlingfont,
        coltitle=white,% Default=white
        attach boxed title to top right={% Title placement + options (doc. p.159-161)
          yshift=-\tcboxedtitleheight, yshifttext=-2pt,%-\tcboxedtitleheight/3,
          %yshift*=-\tcboxedtitleheight,% yshifttext is only set if necessary
        },
        boxed title style={% original code borrowed to `tcolorbox' (see doc. p.165)
          empty,
          boxsep=0pt,
          toptitle=0pt, bottomtitle=0pt,% default=0pt
          lefttitle=0pt, righttitle=0pt,% Default=4mm (additional to boxsep)
          left=6pt, right=4pt,% Default=4mm (additional to boxsep)
          top=1pt, bottom=0pt,% Default=2mm (additional to boxsep)
        },
        underlay boxed title={% Only drawn if a boxed title is given (cf. doc. §10.2.3 p.162)
          %- Bézier curve .. control .. don't work! Why? FIX ME!
          \path[draw=black!20, fill=firstcolor!75!black, line width=0.4pt]
            ([xshift=-\tcboxedtitleheight/2, yshift=0.0mm]title.north west)
            to [bend left=30] ([xshift=2pt, yshift=-1pt]title.west)
            [rounded corners=2pt]% arc=2pt − default
            -- ([xshift=4pt,yshift=0.0mm]title.south west)
            -- ([yshift=0.0mm]title.south east)
            -- ([yshift=0.0mm]title.north east)
            [sharp corners] -- cycle;
        },
        before title app={%
          \ifdoc@appendix
            \strut \textsc{Code \theappendixchapter.\thetcbcounter}%
          \else
            \strut \textsc{Code \thechapter.\thetcbcounter}%  
          \fi
        },
        title={\strut\space\textemdash\space #3},
        label={code:\Roman{chapter}.\thetcbcounter},
        %label={code:\Roman{chapter}.\string\c@code}},
        label type={code},% To be used in cunjonction to the `cleveref` package
        list entry={% Adding a code symbol in the "list of codes" entries
          \ifdoc@appendix    
            \protect\numberline{\theappendixchapter.\thetcbcounter}#3%
            \enspace\textcolor{secondcolor}{\normalfont\footnotesize\codesymbol}%
          \else
            \protect\numberline{\thechapter.\thetcbcounter}#3%
            \enspace\textcolor{secondcolor}{\normalfont\footnotesize\codesymbol}%
          \fi      
        },
      }{notitle},
    },
    %after skip=\baselineskip,% Do not set it! It overwrites the `after' field below
    %after={\par\vspace*{1.0\parskip}},
    IfValueTF={#1}{#1}{}% More options comma separated
}


%- Redefining the "code*" environment (previously defined by the `minted` package)

\RenewTCBListing{code*}{ o m o }{% star = no referencing in the list of codes
    %before skip=\baselineskip,% Do not set it! It overwrites the `before' field below
    before={%
      \par\pagebreak[0]\parindent=0pt% Default autoparskip option (see doc. §4.14 p.81)
      %\vspace{-\baselineskip}% WHY?
      \vspace{4pt}%
      %\noindent Before → Code : \thecode ; TCBcounter : \thetcbcounter\par%
    },
    IfValueTF={#3}{% No caption but a unumbered title
      fonttitle=\footnotesize\lightboldfont,%\lightboldfont,%\titlingfont,
      coltitle=white,% Default=white
      %colbacktitle=black!65,% Default: black!50!white
      attach boxed title to top right={% Title placement + options (doc. p.159-161)
        yshift=-\tcboxedtitleheight, yshifttext=-2pt,%-\tcboxedtitleheight/3,
        %yshift*=-\tcboxedtitleheight,% yshifttext is only set if necessary
      },
      boxed title style={% original code borrowed to `tcolorbox' (see doc. p.165)
        empty,
        boxsep=0pt,
        toptitle=0pt, bottomtitle=0pt,% default=0pt
        lefttitle=0pt, righttitle=0pt,% Default=4mm (additional to boxsep)
        left=6pt, right=4pt,% Default=4mm (additional to boxsep)
        top=1pt, bottom=0pt,% Default=2mm (additional to boxsep)
      },
      underlay boxed title={% Only drawn if a boxed title is given (cf. doc. §10.2.3 p.162)
        %- Bézier curve .. control .. don't work! Why? FIX ME!
        \path[draw=black!20, fill=firstcolor!75!black, line width=0.4pt]
          ([xshift=-\tcboxedtitleheight/2,yshift=0.0mm]title.north west)
          to [bend left=30] ([xshift=2pt,yshift=-1pt]title.west)
          [rounded corners=2pt]% arc=2pt − default
          -- ([xshift=4pt,yshift=0.0mm]title.south west)
          -- ([yshift=0.0mm]title.south east)
          -- ([yshift=0.0mm]title.north east)
          [sharp corners] -- cycle;
      },
        title={\strut #3},
    }{notitle},
    code box layout,% General code box layout options
    code language/#2,% Code language options
    code layout,% Common code `minted` layout options
    numbering lines=false,% Default=true
    %after skip=\baselineskip,% Do not set it! It overwrites the `after' field below
    after={%
      \vspace*{2.0\parskip}%
      %\par La dernière référence de code numéroté est : \ref{code:\thecode}.\par%
    },
    IfValueTF={#1}{#1}{}% More/reset/change options comma separated
}


%-- Defining "shell" environment to simulate a terminal console (with `listings' package)
%----------------------------------------------------------------------------------------

\definecolor{shellusercolor}{RGB}{138, 226, 52}% HTML: #8AE234
\definecolor{shelldircolor}{RGB}{81, 135, 203}% HTML: #5187CB
\definecolor{shellbgcolor}{RGB}{55, 54, 51}% HTML: #373633
\definecolor{shelltitlebgcolor}{RGB}{63, 62, 58}% HTML: #3F3E3A

%- SVG icons are into: /usr/share/themes/Ambiant-MATE/unity
%- Install SVG2TikZ: https://github.com/kjellmf/svg2tikz/blob/master/docs/install.rst

\newfontfamily{\shellfont}{Ubuntu-R.ttf}[
  Scale=0.95,
  %Numbers=Lining,
  %Ligatures=TeX,
  ItalicFont={Ubuntu-RI.ttf},
  BoldFont={Ubuntu-M.ttf},
  BoldItalicFont={Ubuntu-MI.ttf},
  ]

%\newfontfamily{\shellttfont}{UbuntuMono-R.ttf}[
\newfontfamily{\shellttfont}{UbuntuXMono-R.ttf}[
  %Scale=0.95,
  %Numbers=Lining,
  %Ligatures=TeX,
  ItalicFont={UbuntuMono-RI.ttf},
  BoldFont={UbuntuMono-B.ttf},
  BoldItalicFont={UbuntuMono-BI.ttf},
  ]

\lstdefinelanguage{shell}{%
  morekeywords={},% No emphasis of keywords at all: text
  morecomment=[l]\#,%
  morestring=[d]",%
  morestring=[d]'%
  }[keywords,comments,strings]%

\lstdefinestyle{shellstyle}{%
  basicstyle={\small\shellttfont},
  numbers=none, %frame=lines, backgroundcolor=\color{\@layoutcolor!2}, 
  aboveskip=0pt, belowskip=0pt,% default=\medskipamount
  columns=flexible,
  breaklines=true, 
  breakindent=0pt, 
  %breakatwhitespace=true,
}

%- From: https://tex.stackexchange.com/questions/517976/[...]
%-          [...]drawing-realistic-linux-command-shell-windows-with-tcolorbox
%-       https://tex.stackexchange.com/questions/518202/tcbuselibrary-redefining-every-listing-line

%\newtcblisting{ubuntu}{%
%\NewTCBListing{ubuntu}{ O{user{@}host:\char`~} }{%
\NewTCBListing{ubuntu}{ O{Terminal} }{%
  enhanced, breakable, boxsep=0pt,
  top=1pt, bottom=1pt,% middle = 2pt,% additional to boxsep
  left=1pt, right=1pt, arc=2pt,% Default: arc=1mm
  toptitle=1pt, bottomtitle=1pt,
  boxrule=1.6pt,
  %colback=violet!50!black,
  colbacktitle=shelltitlebgcolor,
  coltitle=white,
  fonttitle=\shellfont,
  colback=shellbgcolor, 
  colupper=white, 
  fontupper=\shellttfont,
  %colframe=gray!65!black,
  colframe=shelltitlebgcolor,
  fuzzy halo=1.2pt with gray,
  sharp corners=south,
  before skip=2pt,
  after skip=2pt,
  listing only, 
  listing engine=listings,
  listing options={
    style=shellstyle,
    language=shell,
    escapeinside=§§,
  },
  title={%
    \hspace*{1.5pt}\includegraphics[scale=0.2]{ubuntu-close.png}\hspace*{1.5pt}%
    \includegraphics[scale=0.2]{ubuntu-minimize.png}\hspace*{1.5pt}%
    \includegraphics[scale=0.2]{ubuntu-maximize.png}%
    \hspace*{4pt}\raisebox{1.5pt}{\footnotesize#1}\newline%
    \raisebox{3pt}{\footnotesize%
      Fichier\hspace*{5pt}Éditer\hspace*{5pt}Affichage\hspace*{5pt}%
      Rechercher\hspace*{5pt}Terminal\hspace*{5pt}Aide%
    }\vspace*{-2pt}%
  },
  every listing line={\shellprompt}
}

\pgfkeys{%
  /ubuntu/.cd,
  shuser/.code={\gdef\shelluser{#1}},
  shuser={},
  shhost/.code={\gdef\shellhost{#1}},
  shhost={},
  shcolor/.code={\gdef\shellcolor{#1}},
  shcolor=shellusercolor,
  shprompt char/.code={\gdef\shellpromptchar{#1}},
  shprompt char=\#,
  shdirectory/.code={\gdef\shelldirectory{#1}},
  shdirectory=\char`~,
  root/.style={shuser=root, shhost=host, shcolor=white, shprompt char=\#},
  user/.style={shuser=user, shhost=host, shcolor=shellusercolor, shprompt char=\$},
}

\newcommand{\shmult}{\raisebox{0.2ex}{*}}

\newcommand{\setuser}[1]{% `su' Unix command stands for `substitute user'
  \pgfkeys{/ubuntu/.cd, #1}%
  \ifdoc@english
    \gdef\shellprompt{%
      \textcolor{\shellcolor}{%
        \small\shellttfont\shelluser{@}\shellhost{\color{white}:}%
        {\color{shelldircolor}\shelldirectory}{\color{white}\shellpromptchar} }%
    }%
  \else
    \gdef\shellprompt{%
      \textcolor{\shellcolor}{%
        \small\shellttfont\shelluser{@}\shellhost{\NoAutoSpacing\color{white}:}%
        {\color{shelldircolor}\shelldirectory}{\color{white}\shellpromptchar} }%
    }%
  \fi
}

\newcommand{\startconsole}{\gdef\shellprompt{}}


%-- Defining "ipython" environment to simulate a terminal console (with `listings' package)
%------------------------------------------------------------------------------------------

\definecolor{ipythonkeywordcolor}{RGB}{1, 135, 0}% HTML: #018700
\definecolor{ipythonpromptincolor}{RGB}{1, 135, 0}% HTML: #018700
\definecolor{ipythonpromptinlinecolor}{RGB}{138, 226, 52}% HTML: #8AE234
\definecolor{ipythonpromptoutcolor}{RGB}{126, 1, 0}% HTML: #7E0100
\definecolor{ipythonpromptoutlinecolor}{RGB}{239, 41, 41}% HTML: #EF2929

\lstdefinelanguage{ipython}{%
  morekeywords={access, and, break, class, continue, def, del, elif, else,%
    except, exec, finally, for, from, global, if, import, in, is, lambda,%
    not, or, pass, print, raise, return, try, while},%
  % Built-ins
  morekeywords=[2]{abs, all, any, basestring, bin, bool, bytearray,%
    callable, chr, classmethod, cmp, compile, complex, delattr, dict, dir,%
    divmod, enumerate, eval, execfile, file, filter, float, format,%
    frozenset, getattr, globals, hasattr, hash, help, hex, id, input, int,%
    isinstance, issubclass, iter, len, list, locals, long, map, max,%
    memoryview, min, next, object, oct, open, ord, pow, property, range,%
    raw_input, reduce, reload, repr, reversed, round, set, setattr, slice,%
    sorted, staticmethod, str, sum, super, tuple, type, unichr, unicode,%
    vars, xrange, zip, apply, buffer, coerce, intern},%
  sensitive=true,%
  morecomment=[l]\#,%
  morestring=[b]',%
  morestring=[b]",%
  morecomment=[s]{'''}{'''},% used for documentation text
                            % (mulitiline strings)
  morecomment=[s]{"""}{"""},% added by Philipp Matthias Hahn
  morestring=[s]{r'}{'},% `raw' strings
  morestring=[s]{r"}{"},%
  morestring=[s]{r'''}{'''},%
  morestring=[s]{r"""}{"""},%
  morestring=[s]{u'}{'},% unicode strings
  morestring=[s]{u"}{"},%
  morestring=[s]{u'''}{'''},%
  morestring=[s]{u"""}{"""}%
}%

\lstdefinestyle{ipythonstyle}{%
  basicstyle={\small\shellttfont},
  numbers=none,
  aboveskip=0pt, belowskip=0pt,% default=\medskipamount
  columns=flexible,
  breaklines=true, 
  breakindent=0pt, 
  %breakatwhitespace=true,
  keywordstyle={\color{red}\bfseries},
  stringstyle=\color{blue},
  identifierstyle=\color{green},
}

\NewTCBListing{ipythonshell}{  }{%
  enhanced, breakable, boxsep=0pt,
  top=1pt, bottom=1pt,% middle = 2pt,% additional to boxsep
  left=1pt, right=1pt, 
  arc=0pt,% Default: arc=1mm
  toptitle=1pt, bottomtitle=1pt,
  boxrule=1.6pt,
  %colback=violet!50!black,
  colbacktitle=shelltitlebgcolor,
  coltitle=white,
  fonttitle=\shellfont,
  colback=shellbgcolor, 
  colupper=white, 
  fontupper=\shellttfont,
  colframe=shelltitlebgcolor,
  fuzzy halo=1.2pt with gray,
  before skip=8pt,
  after skip=8pt,
  listing only, 
  listing engine=listings,
  listing options={
    style=ipythonstyle,
    language=ipython,
    escapeinside=§§,
  },
  notitle,
  %every listing line={\ipythonprompt}
}

%\pgfkeys{%
%  /ipython/.cd,
%  ipythonprompt/.code={\gdef\ipythonpromptnum{#1}},
%  ipythonpromptnum={},
%  ipyprompt/.style={ipycolor=green},
%}

%\newcommand{\setipythonprompt}[1]{%
%  \pgfkeys{/ipython/.cd, #1}%
%  \gdef\ipythonprompt{%
%    \textcolor{\ipythoncolor}{\small\shellttfont In [1]: }%
%  }%
%}

%\newcommand{\ipythonconsole}{\gdef\ipythonprompt{}}

\NewTCBListing{ipythonminted}{ O{Terminal} }{%
  enhanced, breakable, boxsep=0pt,
  top=1pt, bottom=1pt,% middle = 2pt,% additional to boxsep
  left=1pt, right=1pt, arc=2pt,% Default: arc=1mm
  toptitle=1pt, bottomtitle=1pt,
  boxrule=1.6pt,
  colbacktitle=shelltitlebgcolor,
  coltitle=white,
  fonttitle=\shellfont,
  colback=shellbgcolor, 
  colupper=white, 
  fontupper=\shellttfont,
  %colframe=gray!65!black,
  colframe=shelltitlebgcolor,
  fuzzy halo=1.2pt with gray,
  sharp corners=south,
  before skip=4pt,
  after skip=4pt,
  listing only, 
  listing engine=minted,
  minted style=ipythonjazz,
  minted language=ipython3,
  minted options={
    fontsize=\small,
    breaklines,
    autogobble,
    tabsize=2,
    escapeinside=§§,
    texcomments,
  },
  title={%
    \hspace*{1.5pt}\includegraphics[scale=0.2]{ubuntu-close.png}\hspace*{1.5pt}%
    \includegraphics[scale=0.2]{ubuntu-minimize.png}\hspace*{1.5pt}%
    \includegraphics[scale=0.2]{ubuntu-maximize.png}%
    \hspace*{4pt}\raisebox{1.5pt}{\footnotesize#1}\newline%
    \raisebox{3pt}{\footnotesize%
      Fichier\hspace*{5pt}Éditer\hspace*{5pt}Affichage\hspace*{5pt}%
      Rechercher\hspace*{5pt}Terminal\hspace*{5pt}Aide%
    }\vspace*{-2pt}%
  },
  %every listing line={\shellprompt}
}

\newcommand{\ipythonuserprompt}[4]{%
  \textcolor{white}{%
    \small\shellttfont{\color{shellusercolor}#1@#2}{\NoAutoSpacing\color{white}:}%
    {\color{shelldircolor}#3}{\color{white}#4} }%
}

\newcommand{\ipythontext}[1]{\textcolor{white}{\small\shellttfont #1}}

\newcommand{\ipythonpromptin}[1]{%
  \textcolor{ipythonpromptincolor}{%
    \small\shellttfont In [\textcolor{ipythonpromptinlinecolor}{#1}]:}%
}

\newcommand{\ipythonpromptdots}{%
  \textcolor{ipythonkeywordcolor}{\small\shellttfont\hphantom{In} ...{:}}%
}

\newcommand{\ipythonpromptout}[1]{%
  \textcolor{ipythonpromptoutcolor}{%
    \small\shellttfont Out[\textcolor{ipythonpromptoutlinecolor}{#1}]:}%
}

\newcolumntype{T}{>{\small\color{black}\shellttfont}l}
%\newcolumntype{T}{>{\footnotesize\color{black}\shellttfont%
%  \columncolor[gray]{0.8}[0.5\tabcolsep][0.5\tabcolsep]}l}

\newcommand{\ipythonmathfunctions}{%
\setlength{\tabcolsep}{3pt}
\begin{tabular}{TTTTTTTTTT}
\rowcolor{lightgray}
acos() & atan() & comb() & degrees() & erfc() & factorial() & fsum() & inf & isnan() & log() \\   
\rowcolor{lightgray}
acosh() & atan2() & copysign() & dist() & exp() & floor() & gamma() & isclose() & isqrt() & log10() \\ 
\rowcolor{lightgray}
asin() & atanh() & cos() & e & expm1() & fmod() & gcd() & isfinite() & ldexp() & log1p() \\
\rowcolor{lightgray}
asinh() & ceil() & cosh() & erf() & fabs() & frexp() & hypot() & isinf() & lgamma() & log2()
\end{tabular}}


%-- Defining "notebook In[]" environment to simulate a Jupyter notebook code cell
%--------------------------------------------------------------------------------

\definecolor{pynbcodeinbgcolor}{RGB}{225, 223, 220}% HTML: #e1dfdc
\definecolor{pynbcodefalsebgcolor}{RGB}{235, 207, 207}% HTML: #ebcfcf
\definecolor{pynbcodetruebgcolor}{RGB}{206, 230, 197}% HTML: #cee6c5

\NewTCBListing{nbjupyterin}{ o m }{%
  enhanced, breakable, boxsep=0pt,
  top=2pt, bottom=1pt,% middle = 2pt,% additional to boxsep
  left=2pt, right=2pt, arc=0pt,% Default: arc=1mm
  boxrule=0.2pt,
  colback=pynbcodeinbgcolor, 
  %colupper=white, 
  %fontupper=\shellttfont,
  fontupper=\ttfamily,
  colframe=gray,
  sharp corners,
  before skip=1pt,
  after skip=1pt,
  width=\linewidth,
  notitle,
  listing only, 
  listing engine=minted,
  minted style=python,
  minted language=python,
  minted options={
    fontsize=\small,
    breaklines,
    autogobble,
    tabsize=2,
    escapeinside=§§,
    %formatcom=\bashprompt,
  },
  underlay={%
    \begin{tcbinvclipframe}
      \node[anchor=east, xshift=-4pt, yshift=(-.5\baselineskip-1pt)]
        at (frame.north west) {\textcolor{firstcolor}{\texttt{In[#2]}}};%
    \end{tcbinvclipframe}
  },
  IfValueTF={#1}{#1}{},
}

%\NewTCBListing{nbipythonout}{ o m }{%nbcodeoutjupyter
\NewTCBListing{nbjupyterout}{ o m }{%nbcodeoutjupyter
  enhanced, breakable, boxsep=0pt,
  top=2pt, bottom=1pt,% middle = 2pt,% additional to boxsep
  left=2pt, right=2pt, arc=0pt,% Default: arc=1mm
  boxrule=0.0pt,
  colback=white, 
  %colupper=white, 
  fontupper=\shellttfont,
  colframe=white,
  sharp corners,
  before skip=1pt,
  after skip=1pt,
  width=\linewidth,
  notitle,
  listing only, 
  listing engine=minted,
  minted style=python,
  minted language=python,
  minted options={
    fontsize=\small,
    breaklines,
    autogobble,
    tabsize=2,
    escapeinside=§§,
    %formatcom=\bashprompt,
  },
  underlay={%
    \begin{tcbinvclipframe}
      \node[anchor=east, xshift=-4pt, yshift=(-.5\baselineskip-1pt)]
        at (frame.north west) {\textcolor{secondcolor}{\texttt{Out[#2]}}};%
    \end{tcbinvclipframe}
  },
  IfValueTF={#1}{#1}{},
}

%-- Defining "idle" environment to simulate a interpretor console (with `listings' package)
%------------------------------------------------------------------------------------------

%- From: https://tex.stackexchange.com/questions/269928/[...]
%-          [...]formatting-certain-texts-in-fancyvrb-environments-automatically/

\input{listings-python.prf}% Implemented separately (to be known!)

%\lstset{
\lstdefinestyle{idlestyle}{%
  style=python-idle-code,
  basicstyle={\small\shellttfont},
  numbers=none,
  aboveskip=0pt, belowskip=0pt,% default=\medskipamount
  columns=flexible,
  breaklines=true, 
  breakindent=0pt, 
  %breakatwhitespace=true,
  showstringspaces=false,  % true by default for python
  tabsize=2,
  %otherkeywords={>>>},    % used only because >>> is not an identifier
  %morekeywords=[3]{>>>},
  %keywordstyle={[3]\color{blue}},
}

% Blue prompts 
%\lstset{
%  otherkeywords={>>>},    % used only because >>> is not an identifier
%  morekeywords=[3]{>>>},
%  keywordstyle={[3]\color{blue}},
%}

\NewTCBListing{idle}{ O{Python 3.8.2 Shell} }{%
  enhanced, breakable, boxsep=0pt,
  top=1pt, bottom=1pt,% middle = 2pt,% additional to boxsep
  left=1pt, right=1pt, arc=2pt,% Default: arc=1mm
  toptitle=1pt, bottomtitle=1pt,
  boxrule=1.6pt,
  %colback=violet!50!black,
  colbacktitle=shelltitlebgcolor,
  coltitle=white,
  fonttitle=\shellfont,
  %colback=shellbgcolor, 
  %colupper=white, 
  fontupper=\shellttfont,
  %colframe=gray!65!black,
  colframe=shelltitlebgcolor,
  fuzzy halo=1.2pt with gray,
  sharp corners=south,
  before skip=2pt,
  after skip=2pt,
  listing only, 
  listing engine=listings,
  listing options={
    style=idlestyle,
    language=python,
    escapeinside=§§,
  },
  title={%
    \hspace*{1.5pt}\includegraphics[scale=0.2]{ubuntu-close.png}\hspace*{1.5pt}%
    \includegraphics[scale=0.2]{ubuntu-minimize.png}\hspace*{1.5pt}%
    \includegraphics[scale=0.2]{ubuntu-maximize.png}%
    \hspace*{4pt}\raisebox{1.5pt}{\footnotesize#1}\newline%
    \raisebox{3pt}{\footnotesize%
      File\hspace*{5pt}Edit\hspace*{5pt}Shell\hspace*{5pt}%
      Debug\hspace*{5pt}Options\hspace*{5pt}Window\hspace*{5pt}Help%
    }\vspace*{-2pt}%
  },
  %every listing line={\shellprompt}
}

%-- Defining "pseudocode" environment for algoritms (with `listings' package)
%----------------------------------------------------------------------------

%- Pseudo-code and algorithm listings
\lstdefinelanguage{pseudocode}{%
  morekeywords={Répéter, Pour, Si, Alors, Sinon, SinonSi, FinSi, FinPour, Jusque, FinTri, 
                allant_de, à, À, de, variant_de, Variant_de, Suivant, Pas,
                TantQue, FinTantQue, Faire, Écrire, Lire, Début, Fin,
                Variable, Variables, Tableau, Tableaux, REM, 
                Ou, Et, Non, Or, And, Not, OU, ET, NON, OR, AND, NOT, XOR,
                Fonction, FinFonction, Procédure, FinProcédure,
                Ouvrir, Fermer, LireFichier,
                Dimmensionner, ReDimensionner,
                Return, Renvoyer,
                If, ElseIf, Else, if, elseif, else, 
                Switch, switch, case, break, default,
                For, for, var,
                While, while, Do, do,
                function, return,
                },
  morekeywords=[2]{
    % Fonctions génériques
    Len, Mid, Find, Mod, Modulo, Sum, Ent, Aléa, Lecture,
    % Instructions et mots-clefs génériques
    Public, Private,
  },
  sensitive=true,% Case sentitive or not
  showtabs=false, showstringspaces=true, showspaces=false,
  morecomment=[l]{//},
  morecomment=[s]{/*}{*/},
  morestring=[b]", morestring=[s]{«}{»}, morestring=[s]{“}{”},
  %morestring=[s]{(}{)},
}

%- Algorithms style (basic output: sophistications later... TODO)
\lstdefinestyle{lstalgostyle}{% needed syntax for colors: \color{<name>} (due to key-value system)
  aboveskip=0pt, belowskip=0pt,% default=\medskipamount
  basicstyle={\small\shellttfont},
  %linewidth=.9\linewidth,% default=\linewidth
  % frame settings
  %backgroundcolor=\color{\@layoutcolor!0},%\color{orange!20},
  frame=l,% adds a line to the left (used for line numbers)
  framesep=8pt,
  framerule=0pt,% default=0.4pt,
  %fillcolor=\color{\@layoutcolor!2},% frame-fill color (lines numbering column)
  %framextopmargin=4pt,% default=0pt
  %framexbottommargin=4pt,% default=0pt
  %frameround=tttt,% default ffff for false
  %rulecolor=\color{orange},% frame-rule-color
  % line numbering
  numbers=left,% line numbers on the left
  numbersep=6pt,% numbers-code distance
  numberstyle={\tiny\sffamily\itshape\color{black!80}},
  % code display
  language=pseudocode,
  identifierstyle=\color{black},
  stringstyle=\color{algostringcolor},
  commentstyle=\color{idecommentcolor},
  keywordstyle=\color{secondcolor}\bfseries\upshape,
  keywordstyle={[2]\color{idesyntaxcolor}\bfseries\itshape},
  emphstyle=\color{black}\itshape\bfseries,% emphasized style
  emph={Tri_Bulle,Tri_Selection,Tri_Insertion,Tri_Shell},% emphasizes particular identifiers
  otherkeywords={--,-->,<--,::},
  %escapeinside = {\%*}{*},% useful for adding LaTeX within the code
  %keepspaces=true,% tab to spaces: default=false
  %showspaces=false,% all blank spaces appear (underscore bracket): default=false
  %showtabs=false,% shows tabs within strings (underscore bracket): default=true
  %showstringspaces=false,
  breaklines=true,
  breakatwhitespace=true,
  %escapechar=\%, 
  tabsize=2, extendedchars=true, captionpos=t,
  % adjusting margins
  xleftmargin=12pt,% framesep + framerule + 4pt (numbersep-4pt=indentation) % default=0pt
  %xrightmargin=-2.4pt,% numbersep + framerule % default=0pt
}

\newcounter{algorithm}

\NewTCBListing[
  use counter=algorithm,
  list inside=loc,% to have a list of exercice with \tcblistof[\section]{<name>}{<title>}
  %- With "list type" field, a \l@code command must be defined OR done with `titletoc' package
  %- See: change-tcolorbox-tcblistof-font-formatting-to-match-documents-other-lists:
  %          https://tex.stackexchange.com/questions/353947/
  list type=code,% By default → Layout is done by \l@tcolorbox command
  ]{algorithm}{ o g o }{%
    % Usage − \begin{algorithm}[<more-options>]{<code-language>}[<optional-title>]{<optional-caption>}
    %           ...
    %         \end{algorithm}
    %before skip=\baselineskip,% Do not set it! It overwrites the `before' field below
    before={%
      \par\pagebreak[0]\parindent=0pt% Default autoparskip option (see doc. §4.14 p.81)
      %\vspace{-\baselineskip}% WHY?
      \vspace*{1.5\parskip}%
      %\vspace*{2pt}%
    },
    enhanced,
    breakable,
    colback=black!5,
    colframe=firstcolor,
    boxsep=0pt,
    top=4pt, bottom=4pt,% middle = 2pt,% additional to boxsep
    arc=2pt,% Default: arc=1mm
    % outer arc=0pt,% No default: outer arc=unset
    boxrule=0.6pt,
    left=0pt, right=4pt,
    drop fuzzy shadow,
    listing only, 
    listing engine=listings,
    listing options={
      style=lstalgostyle,
      language=pseudocode,
      escapeinside=§§,
    },
    IfValueTF={#3}{% Adding a algoritm caption with an entry in the "list of listings" (LoL)
      before pre={%
        \addtocounter{algorithm}{-1}% To avoid double increment: from the tcbox and from the captionof
        \captionof{algorithm}{#3}%
      },
      IfValueTF={#2}{notitle}{notitle},% If a caption exists, no title at all is displayed
      label type={algorithm},% To be used in cunjonction to the `cleveref' package
      label={algo:\Roman{chapter}.\thetcbcounter},
    }{IfValueTF={#2}{% No caption but a title
        fonttitle=\footnotesize\lightboldfont,%\lightboldfont,%\titlingfont,
        coltitle=white,% Default=white
        attach boxed title to top right={% Title placement + options (doc. p.159-161)
          yshift=-\tcboxedtitleheight, yshifttext=-2pt,%-\tcboxedtitleheight/3,
          %yshift*=-\tcboxedtitleheight,% yshifttext is only set if necessary
        },
        boxed title style={% original code borrowed to `tcolorbox' (see doc. p.165)
          empty,
          boxsep=0pt,
          toptitle=0pt, bottomtitle=0pt,% default=0pt
          lefttitle=0pt, righttitle=0pt,% Default=4mm (additional to boxsep)
          left=6pt, right=4pt,% Default=4mm (additional to boxsep)
          top=1pt, bottom=0pt,% Default=2mm (additional to boxsep)
        },
        underlay boxed title={% Only drawn if a boxed title is given (cf. doc. §10.2.3 p.162)
          %- Bézier curve .. control .. don't work! Why? FIX ME!
          \path[draw=black!20, fill=firstcolor!75!black, line width=0.4pt]
            ([xshift=-\tcboxedtitleheight/2,yshift=0.0mm]title.north west)
            to [bend left=30] ([xshift=2pt,yshift=-1pt]title.west)
            [rounded corners=2pt]% arc=2pt − default
            -- ([xshift=4pt,yshift=0.0mm]title.south west)
            -- ([yshift=0.0mm]title.south east)
            -- ([yshift=0.0mm]title.north east)
            [sharp corners] -- cycle;
        },
        before title app={%
          \ifdoc@appendix
            \strut \textsc{Algorithme \theappendixchapter.\thetcbcounter}%
          \else
            \strut \textsc{Algorithme \thechapter.\thetcbcounter}%  
          \fi
        },
        title={\strut\space\textemdash\space #2},
        label={algo:\Roman{chapter}.\thetcbcounter},
        %label={code:\Roman{chapter}.\string\c@code}},
        label type={algorithm},% To be used in cunjonction to the `cleveref` package
        list entry={% Adding a code symbol in the "list of codes" entries
          \ifdoc@appendix    
            \protect\numberline{\theappendixchapter.\thetcbcounter}#2%
            \enspace\textcolor{secondcolor}{\normalfont\footnotesize\codesymbol}%
          \else
            \protect\numberline{\thechapter.\thetcbcounter}#2%
            \enspace\textcolor{secondcolor}{\normalfont\footnotesize\codesymbol}%
          \fi      
        },
      }{notitle},
    },
    %after skip=\baselineskip,% Do not set it! It overwrites the `after' field below
    after={\par\vspace*{1.0\parskip}},
    IfValueTF={#1}{#1}{}% More options comma separated
}


\NewTCBListing{algorithm*}{ o g }{% star = no referencing in the list of codes/listings
    %before skip=\baselineskip,% Do not set it! It overwrites the `before' field below
    before={%
      \par\pagebreak[0]\parindent=0pt% Default autoparskip option (see doc. §4.14 p.81)
      \vspace{-\baselineskip}% WHY?
      %\vspace*{2.5\parskip}%
      %\noindent Before → Code : \thecode ; TCBcounter : \thetcbcounter\par%
    },
    IfValueTF={#2}{% No caption but a unumbered title
      fonttitle=\footnotesize\lightboldfont,%\lightboldfont,%\titlingfont,
      coltitle=white,% Default=white
      %colbacktitle=black!65,% Default: black!50!white
      attach boxed title to top right={% Title placement + options (doc. p.159-161)
        yshift=-\tcboxedtitleheight, yshifttext=-2pt,%-\tcboxedtitleheight/3,
        %yshift*=-\tcboxedtitleheight,% yshifttext is only set if necessary
      },
      boxed title style={% original code borrowed to `tcolorbox' (see doc. p.165)
        empty,
        boxsep=0pt,
        toptitle=0pt, bottomtitle=0pt,% default=0pt
        lefttitle=0pt, righttitle=0pt,% Default=4mm (additional to boxsep)
        left=6pt, right=4pt,% Default=4mm (additional to boxsep)
        top=1pt, bottom=0pt,% Default=2mm (additional to boxsep)
      },
      underlay boxed title={% Only drawn if a boxed title is given (cf. doc. §10.2.3 p.162)
        %- Bézier curve .. control .. don't work! Why? FIX ME!
        \path[draw=black!20, fill=firstcolor!75!black, line width=0.4pt]
          ([xshift=-\tcboxedtitleheight/2,yshift=0.0mm]title.north west)
          to [bend left=30] ([xshift=2pt,yshift=-1pt]title.west)
          [rounded corners=2pt]% arc=2pt − default
          -- ([xshift=4pt,yshift=0.0mm]title.south west)
          -- ([yshift=0.0mm]title.south east)
          -- ([yshift=0.0mm]title.north east)
          [sharp corners] -- cycle;
      },
        title={\strut #2},
    }{notitle},
    code box layout,% General code box layout options
    %code language/#2,% Code language options
    %code layout,% Common code `minted` layout options
    %numbering lines=false,% Default=true
  listing only, 
  listing engine=listings,
  listing options={
    style=lstalgostyle,
    language=pseudocode,
    escapeinside=§§,
  },
    %after skip=\baselineskip,% Do not set it! It overwrites the `after' field below
    after={%
      \vspace*{2.0\parskip}%
      %\par La dernière référence de code numéroté est : \ref{code:\thecode}.\par%
    },
    IfValueTF={#1}{#1}{}% More/reset/change options comma separated
}

%-- Defining "assembler" environment for x86 assembler (with `listings' package)
%-------------------------------------------------------------------------------

%- Algorithms style (basic output: sophistications later... TODO)
\lstdefinestyle{lstassemblerstyle}{% needed syntax for colors: \color{<name>} (due to key-value system)
  aboveskip=0pt, belowskip=0pt,% default=\medskipamount
  basicstyle={\small\shellttfont},
  %linewidth=.9\linewidth,% default=\linewidth
  % frame settings
  %backgroundcolor=\color{\@layoutcolor!0},%\color{orange!20},
  backgroundcolor=\color{black!5},
  %frame=l,% adds a line to the left (used for line numbers)
  framerule=0pt,% default=0.4pt,
  %fillcolor=\color{orange},% frame-fill color (lines numbering column)
  %xleftmargin=4pt,
  %xrightmargin=4pt,
  framesep=4pt,
  framextopmargin=4pt,% default=0pt
  framexbottommargin=4pt,% default=0pt
  %frameround=tttt,% default ffff for false
  %rulecolor=\color{orange},% frame-rule-color
  % line numbering
  numbers=left,% line numbers on the left
  numbersep=6pt,% numbers-code distance
  numberstyle={\tiny\sffamily\itshape\color{black!80}},
  % code display
  language={[x86masm]Assembler},
  identifierstyle=\color{black},
  stringstyle=\color{algostringcolor},
  commentstyle=\color{idecommentcolor},
  keywordstyle=\color{secondcolor}\bfseries\upshape,
  keywordstyle={[2]\color{idesyntaxcolor}\bfseries\itshape},
  emphstyle=\color{black}\itshape\bfseries,% emphasized style
  %otherkeywords={--,-->,<--,::},
  %escapeinside = {\%*}{*},% useful for adding LaTeX within the code
  %keepspaces=true,% tab to spaces: default=false
  %showspaces=false,% all blank spaces appear (underscore bracket): default=false
  %showtabs=false,% shows tabs within strings (underscore bracket): default=true
  %showstringspaces=false,
  breaklines=true,
  breakatwhitespace=true,
  %escapechar=\%, 
  tabsize=2, extendedchars=true, captionpos=t,
  % adjusting margins
  xleftmargin=12pt,% framesep + framerule + 4pt (numbersep-4pt=indentation) % default=0pt
  %xrightmargin=-2.4pt,% numbersep + framerule % default=0pt
  morekeywords={addl,cmpl,movl}
}

%-- Defining "(La)TeX" listing styles to be used for documentation (with `listings' package)
%-------------------------------------------------------------------------------------------

%- New colors
\definecolor{texcsdoccolor}{RGB}{119, 41, 83}% From Radiant-MATE theme: #772953 or other : RGB(172,53,53) #ac3535
\definecolor{emphdoccolor}{RGB}{38, 107, 189}% approximative Crayola NavyBlue -> #266BBD, the real one is #0066CC
%\definecolor{commentdoccolor}{RGB}{59, 125, 37}% #3B7D25 Kind of green
%\definecolor{commentdoccolor}{RGB}{118, 111, 100}% "Bis" kind of brown #766f64
\definecolor{commentdoccolor}{RGB}{118, 94, 47}% "Café au lait" / #785e2f
\definecolor{keyworddoccolor}{RGB}{128, 128, 0}% #808000 Olive #c0be51 espèce de jaune-vert

\lstdefinestyle{lstlatexstyle}{%
	language=[LaTeX]TeX,
	tabsize=2,
	aboveskip={\dimexpr\parskip+2pt\relax},
	belowskip=0pt,
	%belowskip=\parskip,
	lineskip=0.25pt,
	showstringspaces=false,
	breaklines=true,%
	backgroundcolor=\color{black!5},
	numbers=none,
	xleftmargin=1ex,
	xrightmargin=1ex,
	frame=lines,
	rulesep=0pt,
	framesep=2pt,
	framerule=0.0pt,
	framexleftmargin=1pt,
	framexrightmargin=1pt,
	framextopmargin=1pt,
	framexbottommargin=0pt,
	numbersep=1ex,
	numberstyle=\small\ttfamily, 
	basicstyle=\small\ttfamily,
	texcsstyle=*\color{texcsdoccolor}\bfseries,
	keywordstyle=\color{keyworddoccolor}\bfseries,
	identifierstyle=\color{black}\normalfont\ttfamily,
	commentstyle=\itshape\color{commentdoccolor},%
	stringstyle=,%\color{magenta},
	emphstyle=\color{emphdoccolor}\bfseries,%\emphstyle,
	keywords={% Mainly the environment names in use (within parenthesis)
		equal,
 		tabular,
 		enumerate,
		itemize,
		table,
		figure,
		assignpoints,
		exercisepoints,
		exercise,
		quiz,
		subexercise,
		quizquestion,
		cleveref,
		caption,
		tcolorbox
	},%
	alsoletter={*},
	moretexcs={
		newcommand*,
		newcommand*,
		renewcommand,
		renewcommand*,
		providecommand,
		section,
		subsection,
		texorpdfstring,
		iftoggle,
		if@assignpoints@usefrenchlanguage,
	},
	literate=*%
		{-}{{\textcolor{texcsdoccolor}{-}}}{1}
		{<}{{\textcolor{texcsdoccolor}{<}}}{1}
		{>}{{\textcolor{texcsdoccolor}{>}}}{1}
		{/}{{\textcolor{texcsdoccolor}{/}}}{1}
		{\&}{{\textcolor{texcsdoccolor}{\&}}}{1}
		{\{}{{\textcolor{texcsdoccolor}{\{}}}{1}
		{\}}{{\textcolor{texcsdoccolor}{\}}}}{1}
		{[}{{\textcolor{texcsdoccolor}{[}}}{1}
		{]}{{\textcolor{texcsdoccolor}{]}}}{1}
		{\\\\}{{\textcolor{texcsdoccolor}{\textbackslash{}\textbackslash{}}}}{1},
	emph={% Mainly the new command names with a preceeding backslash
		AtBeginExercise,
		AtEndExercise,
		AtBeginSubexercise,
		AtEndSubexercise,
		AtBeginQuiz,
		AtEndQuiz,
		AtBeginQuizquestion,
		AtEndQuizquestion,
		assignpointsdecimalsep,
		assignpointsunitsingular,
		assignpointsunitplural,
		points,
		displaypoints,
		itempoints,
		itempoints*,
		getpoints,
		getpoints*,
		getbonuspoints,
		getbounuspoints*,
		numberofexercises,
		exercisetotalpoints,
		exercisetotalpoints*,
		numberofquizzes,
		quiztotalpoints,
		quiztotalpoints*,
		%currentexercisepoints,
		%currentsubexercisepoints,
		currentexercisenumber,
		currentexercisetitle,
		currentsubexercisenumber,
		currentsubexercisetitle,
		currentquiznumber,
		currentquiztitle,
		currentquizquestionnumber,
		currentquizquestiontitle,
		bonuspoints,
		getbonuspoints,
		getbonuspoints*,
		customlayout,
		%totalpointswithbonus,
		exercisetotalpointswithbonus,
		exercisetotalpointswithbonus*,
		quiztotalpointswithbonus,
		quiztotalpointswithbonus*,
		exercisename,
		quizname,
		totalpointsname,
		showcaseexercise,
		showcasequiz,
		showcaseexercise*,
		showcasequiz*,
		setitempointsunit
	}
}

%- "Re-hook" literate char table

\lst@AddToHook{SelectCharTable}
    {\ifx\lst@literate\@empty\else
         \expandafter\lst@Literate\lst@literate{}\relax\z@
     \fi}

%- Defining some shortcuts (see also `ltxdoc' package)

\newcommand*{\cs}[1]{\texttt{\textbackslash#1}}
\newcommand*{\dir}[1]{\texttt{\textbackslash#1}}

\newcommand{\lstltx}[1]{% emph fout le bouzin avec texcs ! (cf. doc.)
	\lstinline[%
		language={[LaTeX]{TeX}},
		numberstyle=\small\ttfamily, 
		basicstyle=\ttfamily,
		%texcsstyle=\color{texcsdoccolor}\bfseries\textbackslash{},
		keywordstyle=\color{keyworddoccolor}\bfseries,
		identifierstyle=\color{black}\normalfont\ttfamily,
		%stringstyle=,%\color{magenta},
		emphstyle=\color{texcsdoccolor}\bfseries\textbackslash{},
		alsoletter={*},
		literate=*%
			{-}{{\textcolor{texcsdoccolor}{-}}}{1}
			{<}{{\textcolor{texcsdoccolor}{<}}}{1}
			{>}{{\textcolor{texcsdoccolor}{>}}}{1}
			{/}{{\textcolor{texcsdoccolor}{/}}}{1}
			{\&}{{\textcolor{texcsdoccolor}{\&}}}{1}
			{\{}{{\textcolor{texcsdoccolor}{\{}}}{1}
			{\}}{{\textcolor{texcsdoccolor}{\}}}}{1}
			{[}{{\textcolor{texcsdoccolor}{[}}}{1}
			{]}{{\textcolor{texcsdoccolor}{]}}}{1},
		keywords={% Mainly the environment names in use (within parenthesis)
			tabular,
			enumerate,
			itemize,
			assignpoints,
			exercisepoints,
			exercise,
			quiz,
			subexercise,
			quizquestion,
			cleveref,
			caption,
			},
		emph={% Mainly the new command names with a preceeding backslash
			usepackage,
			newcommand
		}
	]!#1!
}

\newcommand{\lstcs}[1]{%
	\lstinline[%
		language={[LaTeX]{TeX}},%
		numberstyle=\small\ttfamily, 
		basicstyle=\ttfamily,
		texcsstyle=*\color{texcsdoccolor}\bfseries,
		keywordstyle=\color{keyworddoccolor}\bfseries,
		identifierstyle=\color{black}\normalfont\ttfamily,
		commentstyle=\color{commentdoccolor}\itshape,%
		stringstyle=,%\color{magenta},
		emphstyle=\color{emphdoccolor}\bfseries\textbackslash{},
		alsoletter={*},%
		literate=*%
			{-}{{\textcolor{texcsdoccolor}{-}}}{1}
			{<}{{\textcolor{texcsdoccolor}{<}}}{1}
			{>}{{\textcolor{texcsdoccolor}{>}}}{1}
			{/}{{\textcolor{texcsdoccolor}{/}}}{1}
			{\&}{{\textcolor{texcsdoccolor}{\&}}}{1}
			{\{}{{\textcolor{texcsdoccolor}{\{}}}{1}
			{\}}{{\textcolor{texcsdoccolor}{\}}}}{1}
			{[}{{\textcolor{texcsdoccolor}{[}}}{1}
			{]}{{\textcolor{texcsdoccolor}{]}}}{1},
		keywords={% Mainly the environment names in use (within parenthesis)
			equal,
			tabular,
			enumerate,
			itemize,
			assignpoints,
			exercisepoints,
			exercise,
			quiz,
			subexercise,
			quizquestion,
			cleveref,
			caption,
		},%
		emph={% Mainly the new command names with a preceeding backslash
			AtBeginExercise,
			AtEndExercise,
			AtBeginSubexercise,
			AtEndSubexercise,
			AtBeginQuiz,
			AtEndQuiz,
			AtBeginQuizquestion,
			AtQuizquestion,
			AtEndQuizquestion,
			assignpointsdecimalsep,
			assignpointsunitsingular,
			assignpointsunitplural,
			points,
			displaypoints,
			itempoints,
			itempoints*,
			getpoints,
			getpoints*,
			getbonuspoints,
			getbounuspoints*,
			numberofexercises,
			exercisetotalpoints,
			exercisetotalpoints*,
			numberofquizzes,
			quiztotalpoints,
			quiztotalpoints*,
			currentexercisenumber,
			currentexercisetitle,
			currentsubexercisenumber,
			currentsubexercisetitle,
			currentquiznumber,
			currentquiztitle,
			currentquizquestionnumber,
			currentquizquestiontitle,
			bonuspoints,
			getbonuspoints,
			getbonuspoints*,
			customlayout,
			totalpointswithbonus,
			exercisetotalpointswithbonus,
			exercisetotalpointswithbonus*,
			quiztotalpointswithbonus,
			quiztotalpointswithbonus*,
			exercisename,
			quizname,
			totalpointsname,
			setitempointsunit,
			currentexercisepoints,
			showcaseexercise,
			showcasequiz,
			showcaseexercise*,
			showcasequiz*
		}
	]!#1!%
}

\newcommand{\lstenv}[1]{%
  \lstinline[%
		language={[LaTeX]{TeX}},%
		basicstyle=\ttfamily,%
		texcsstyle=*\color{texcsdoccolor}\bfseries,
		keywordstyle=\color{keyworddoccolor}\bfseries,%
		identifierstyle=\color{black}\normalfont\ttfamily,%
		alsoletter={*},
		literate=*%
			{/}{{\textcolor{keyworddoccolor}{/}}}{1},
		keywords={% Mainly the environment names in use (within parenthesis)
			equal,
			tabular,
			enumerate,
			itemize,
			assignpoints,
			exercisepoints,
			exercise,
			quiz,
			subexercise,
			quizquestion,
			cleveref,
			caption,
			TikZ,
			PGF,
			tcolorbox,
			breakable,
			etoolbox
		},%
	]!#1!%
}


%-- Setting general layout of the colored boxes used in the document (first level)
%---------------------------------------------------------------------------------

%----- TODO: SIMPLIFY ALL THIS STUFF! ONE BOX WITH OPTIONS FOR THE LAYOUT AND ASSOCIATED ICON

%-- Defining some style box layouts

\tcbset{%noparskip/.style={before={\par\pagebreak[0]\parindent=0pt},after={\par}},
  jazztcblayout/.style 2 args={% generic style of colored boxes
    colframe = {#1}, colback = {#2},% colupper=red,
    colbacktitle=\@titlingcolor,% initially=black!50!white
    fonttitle=\normalsize\sffamily\bfseries, coltitle=\@layoutcolor!0,% default=white
    bottomtitle=1pt, toptitle=1pt,% default=0pt
    enhanced jigsaw,
    arc = 2pt,% outer arc = 0pt,
    boxrule = 0.6pt,
    boxsep = 0pt,% default=1mm
    left = 2pt, right = 2pt,% additional to boxsep, default=4mm
    top = 2pt, bottom = 2pt,% default=2mm
    %middle = 2pt,% additional to boxsep
    %halign=center, valign=bottom,
    %capture=hbox,% default=minipage
    breakable,
  },
  jazztcbtoclayout/.style={% style of the box displaying the ToC contents
    title={Sommaire},
    %adjusted title=flush center,
    %halign title={flush left\hspace{5pt}},%flush center,
    opacityframe=1.0, opacityback=1.0,
    colframe = \@layoutcolor!10, colback = white,%\@layoutcolor!5,
    colbacktitle=\@titlingcolor,% initially=black!50!white
    fonttitle=\large\sffamily\bfseries, coltitle=\@layoutcolor!0,% default=white
    bottomtitle=2pt, toptitle=2pt,% default=0pt
    arc = 2pt,% outer arc = 0pt,
    boxrule = 0.6pt, boxsep = 1pt,
    left = 10pt, right = 1pt,% additional to boxsep
    top = 5pt, bottom = 5pt, middle = 2pt,% additional to boxsep
    %leftrule=5pt, rightrule=5pt, %colupper=blue!25!black,
  },
  %jazztcbsectlayout/.style{% style of the box displaying sections contents (level 2)
    %colframe = \@layoutcolor!10, colback = white,%\@layoutcolor!5,
    %bottomtitle=1pt, toptitle=1pt,% default=0pt
    %arc = 2pt,% outer arc = 0pt,
    %boxrule = 0pt, boxsep = 1pt,
    %left = 1pt, right = 1pt,% additional to boxsep
    %top = 5pt, bottom = 5pt, middle = 2pt,% additional to boxsep
    %leftrule=5pt,% rightrule=5pt, %colupper=blue!25!black,
  %}
}

%-- End-users boxes (coloured background and optional icon)

\NewTColorBox{tcbcontents}{o m}{% #1 = more options; #2 = title; #3 = title color bg O{firstcolor}
%\newtcolorbox{tcbcontents}[2][]{% optional arg = more options list
  breakable,
  enhanced jigsaw,
  check odd page,
  width=\linewidth,
  %parbox=false,
  %colframe=firstcolor,
  colbacktitle=firstcolor,
  colback=gray!20,
  arc = 0pt, outer arc = 0pt,
  boxrule = 0pt,
  %leftrule = 2pt, rightrule = 2pt,
  %toprule=0pt, bottomrule = 0pt,
  boxsep = 2pt,% default=1mm
  toptitle=2pt, bottomtitle=0pt,% additional to boxsep, default=0mm
  lefttitle = 4pt, righttitle = 4pt,% additional to boxsep, default=4mm
  %title=\spacedsmallcaps{\strut\lightbf{#2}~\hrulefill},
  title=\strut\textsc{\boxtitlefont #2~\hrulefill},%  
  top = 2pt, bottom = 2pt,% additional to boxsep, default=2mm
  left = 4pt, right = 4pt,% additional to boxsep, default=4mm
  before skip=8pt,
  after skip=8pt,
  IfValueTF={#1}{#1}{},
}

\NewTColorBox{gofurther}{o g}{% #1 = more options; #2 = another title
%\newtcolorbox{gofurther}[1][]{% optional arg = more options list
  breakable,
  enhanced jigsaw,
  check odd page,
  width=\linewidth,
  %parbox=false,
  %colframe=secondcolor,
  colbacktitle=secondcolor,
  colback=gray!20,
  arc = 0pt, outer arc = 0pt,
  boxrule = 0pt,
  %leftrule = 2pt, rightrule = 2pt,
  %toprule=0pt, bottomrule = 0pt,
  boxsep = 0pt,% default=1mm
  toptitle=5pt, bottomtitle=3pt,% additional to boxsep, default=0mm
  lefttitle = 6pt, righttitle = 6pt,% additional to boxsep, default=4mm
  IfValueTF={#2}{%
    title=\strut\textsc{\boxtitlefont #2~\hrulefill}%  
  }{%
    title=\strut\textsc{\boxtitlefont Pour aller plus loin...~\hrulefill}%
  },
  top = 6pt, bottom = 4pt,% additional to boxsep, default=2mm
  left = 6pt, right = 6pt,% additional to boxsep, default=4mm
  before skip=10pt,
  after skip=2pt,
  %overlay={% There is a bug: the title "logo/picture" is sometimes displayed twice! WHY?
  %  \checkoddpage
  %  \ifoddpageoroneside
  %  %\ifoddpage
  %    %- Original
  %    %\node[overlay,anchor=west] at ([xshift=\marginparsep]title.east) {\LARGE\faBook};
  %    %- Modified
  %    \node[overlay,anchor=west] at ([xshift=2.0pt]title.east)
  %      {\textcolor{secondcolor}{\Large\faBook}};
  %  \else
  %    %- Original
  %    %\node[overlay,anchor=east] at ([xshift=-\marginparsep]title.west) {\LARGE\faBook};
  %    %- Modified
  %    \node[overlay,anchor=east] at ([xshift=-2.0pt]title.west)
  %      {\textcolor{secondcolor}{\Large\faBook}};
  %  \fi
  %},
  IfValueTF={#1}{#1}{},
}

\NewTColorBox{gofurther*}{o g}{% #1 = more options; #2 = another title
%\newtcolorbox{gofurther}[1][]{% optional arg = more options list
  breakable,
  enhanced jigsaw,
  check odd page,
  check odd page, 
  toggle left and right, 
  grow to right by=\marginparwidth+\marginparsep, 
  toggle enlargement=evenpage, 
  %width=\linewidth,
  %parbox=false,
  %colframe=secondcolor,
  colbacktitle=secondcolor,
  colback=gray!20,
  arc = 0pt, outer arc = 0pt,
  boxrule = 0pt,
  %leftrule = 2pt, rightrule = 2pt,
  %toprule=0pt, bottomrule = 0pt,
  boxsep = 0pt,% default=1mm
  toptitle=5pt, bottomtitle=3pt,% additional to boxsep, default=0mm
  lefttitle = 6pt, righttitle = 6pt,% additional to boxsep, default=4mm
  IfValueTF={#2}{%
    title=\strut\textsc{\boxtitlefont #2~\hrulefill}%  
  }{%
    title=\strut\textsc{\boxtitlefont Pour aller plus loin...~\hrulefill}%
  },
  top = 6pt, bottom = 4pt,% additional to boxsep, default=2mm
  left = 6pt, right = 6pt,% additional to boxsep, default=4mm
  before skip=10pt,
  after skip=2pt,
  IfValueTF={#1}{#1}{},
}

%- For more tests and trials, see `texjazz-art.sty'
\newcommand{\warnbox}[2][]{% with white background and an "warn" icon
  %\textcolor{\@titlingcolor}{\faExclamationTriangle~}\nobreak
  \begingroup
    \centering
    \begin{tcolorbox}[
      enhanced jigsaw,
      %skin=enhancedmiddle jigsaw,% setting middle to have textmark (cf. doc. pp. 204-207)
      %marker,
      width=.95\linewidth,
      breakable,
      %parbox=false,
      colframe=\@layoutcolor!20, colback = \@layoutcolor!0,
      %colbacktitle=\@titlingcolor,% initially=black!50!white
      arc = 0pt, outer arc = 0pt,
      leftrule = 0pt, rightrule = 0pt,
      bottomrule = 0pt, toprule=0pt,
      boxrule = 0pt,
      boxsep = 0pt,% default=1mm
      left = 8pt, right = 0pt,% additional to boxsep, default=4mm
      top = 0pt, bottom = 4pt,% default=2mm
      %middle = 2pt,% additional to boxsep
      %halign=center, valign=bottom,
      %capture=hbox,% default=minipage
      %noparskip,
      beforeafter skip=2.5\parskip,
      %before={\llap{\textcolor{\@titlingcolor}{\faExclamationTriangle}~}\vspace{-\baselineskip}},
      before={\hspace*{.025\linewidth}},
      %title={\textcolor{\@titlingcolor}{\faExclamationTriangle}},
      overlay unbroken={%
        \node[anchor=north east,% fill=red, below right,
              minimum height=\baselineskip, align=right,% text width=1em,
              ] %
          at ([left]frame.north west) %
          %at ([xshift=-0pt]frame.north west) %
          {\textcolor{\@titlingcolor}{\faExclamationTriangle}};%
        \draw[\@layoutcolor!10,line width=.2pt,rounded corners=2pt]
          ([yshift=-1pt]frame.north west)%--([xshift=-0.5pt,yshift=-1pt]frame.north-|frame.east)
          --([xshift=-0.5pt]frame.south west)--(frame.south east);
        },
      overlay first={%
        \node[anchor=north east,% fill=red, below right,
              minimum height=\baselineskip, align=right,% text width=1em,
              ] %
          at ([left]frame.north west) %
          %at ([xshift=-0pt]frame.north west) %
          {\textcolor{\@titlingcolor}{\faExclamationTriangle}};%
        \draw[gray,line width=1pt,rounded corners=2pt]
          ([yshift=-1pt]frame.north west)%--([xshift=-0.5pt,yshift=-1pt]frame.north-|frame.east)
          --([xshift=-0.5pt]frame.south west);
        },
      overlay middle={%
        \draw[gray,line width=1pt]
          ([xshift=-0.5pt]frame.north west)--([xshift=-0.5pt]frame.south west);
        },
      overlay last={%
        \draw[gray,line width=1pt]
        ([xshift=-0.5pt]frame.north west)
        --([xshift=-0.5pt]frame.south west)--(frame.south east);
        },
      #1
      ]
    #2\end{tcolorbox}%
  \endgroup
}

%-- End-users environments (coloured background and optional icon)

%- For more tests and trials, see `texjazz-art.sty'
\newtcolorbox{jazzenv}[1][]{% optional arg = logo, icon
  breakable,
  parbox=false,
  colframe=boxbackgroundcolor!20, colback = boxbackgroundcolor!5,
  colbacktitle=boxtitlecolor,% initially=black!50!white
  enhanced jigsaw,
  arc = 2pt,% outer arc = 0pt,
  boxrule = 0.6pt,
  boxsep = 0pt,% default=1mm
  left = 0pt, right = 0pt,% additional to boxsep, default=4mm
  top = 0pt, bottom = 0pt,% default=2mm
  %middle = 2pt,% additional to boxsep
  %halign=center, valign=bottom,
  %capture=hbox,% default=minipage
  %noparskip,
  beforeafter skip=2.5\parskip,
  before={\llap{\textcolor{framecolor}{#1}~}\vspace{-\baselineskip}},
  }
\newtcolorbox{emphenv}[1][]{% optional arg = more options list
  breakable,
  parbox=false,
  colframe=framecolor, colback = boxbackgroundcolor,
  colbacktitle=boxtitlecolor,% initially=black!50!white
  enhanced jigsaw,
  arc = 2pt,% outer arc = 0pt,
  boxrule = 0.6pt,
  boxsep = 4pt,% default=1mm
  left = 0pt, right = 0pt,% additional to boxsep, default=4mm
  top = 0pt, bottom = 0pt,% default=2mm
  %middle = 2pt,% additional to boxsep
  %halign=center, valign=bottom,
  %capture=hbox,% default=minipage
  %noparskip,
  beforeafter skip=2.5\parskip,
  %before={\llap{\textcolor{boxtitlecolor}{#1}~}\vspace{-\baselineskip}},
  %#1
}
\newtcolorbox{oldeyeenv}[1][]{% optional arg = more options list
  breakable, parbox=false,
  colframe=framecolor, colback = boxbackgroundcolor!0,
  colbacktitle=framecolor!50!white,% initially=black!50!white
  enhanced jigsaw,
  arc = 2pt,% outer arc = 0pt,
  boxrule = 0.6pt, boxsep = 4pt,% default=1mm
  left = 0pt, right = 0pt,% additional to boxsep, default=4mm
  top = 0pt, bottom = 0pt,% default=2mm
  %middle = 2pt,% additional to boxsep
  %halign=center, valign=bottom,
  %capture=hbox,% default=minipage
  %noparskip,
  %before={\vspace{\parskip}\llap{\textcolor{framecolor}{\faEye}~}\vspace{-\baselineskip}},
  beforeafter skip=2.5\parskip,
  #1
}
\AtBeginEnvironment{oldeyeenv}{%
  \llap{\textcolor{framecolor}{\faEye}~}\vspace{-\baselineskip}%
}
\NewTColorBox{eyeenv}{ o g }{% optional args: #1 = title ; #2 = more options list whithin braces {}
  colframe=framecolor, colback = boxbackgroundcolor!0,
  colbacktitle=framecolor!50!white,% initially=black!50!white
  enhanced jigsaw,
  breakable, parbox=false,
  bottomtitle=2pt, toptitle=2pt,% default=0pt
  boxrule = 0.6pt, boxsep = 0pt,% default=1mm
  %left=4pt, top=2pt,
  left = 4pt, right = 4pt,% additional to boxsep, default=4mm
  top = 4pt, bottom = 4pt,% default=2mm
  arc = 2pt,% outer arc = 0pt,
  IfValueTF={#1}{%
    adjusted title={#1},%{\hspace{10pt}{#1}},
    fonttitle=\normalsize\titlingfont,%\lightboldfont,%\sffamily\bfseries,
    halign title=flush left,%flush center,
    colbacktitle=black!65,%\@titlingcolor,% initially=black!50!white
    coltitle=white,%\@layoutcolor!0,% default=white
  }{},
  %beforeafter skip=4pt,
  ignore nobreak=true,% In case it follows a heading. Must be set with `before' (see doc p.79)
  before={\vspace{\parskip}\llap{\textcolor{framecolor}{\faEye}~}\vspace{-\baselineskip}},
  after skip=2.5\parskip,
  IfValueTF={#2}{#2}{},
}
\newtcolorbox{questionenv}[1][]{% optional arg = more options list
  breakable,
  parbox=false,
  colframe=framecolor, colback = boxbackgroundcolor!0,
  colbacktitle=framecolor!50!white,% initially=black!50!white
  enhanced jigsaw,
  arc = 2pt,% outer arc = 0pt,
  boxrule = 0.6pt,
  boxsep = 4pt,% default=1mm
  left = 0pt, right = 0pt,% additional to boxsep, default=4mm
  top = 0pt, bottom = 0pt,% default=2mm
  %middle = 2pt,% additional to boxsep
  %halign=center, valign=bottom,
  %capture=hbox,% default=minipage
  %noparskip,
  beforeafter skip=2.5\parskip,
  before={\llap{\textcolor{framecolor}{\faQuestionCircle}~}\vspace{-\baselineskip}},
  #1
}
\newtcolorbox{oldwarnenv}[1][]{% optional arg = more options list
  breakable,
  parbox=false,
  colframe=boxbackgroundcolor!20, colback = boxbackgroundcolor!0,
  colbacktitle=boxtitlecolor,% initially=black!50!white
  enhanced jigsaw,
  arc = 2pt,% outer arc = 0pt,
  boxrule = 0.6pt,
  boxsep = 4pt,% default=1mm
  left = 0pt, right = 0pt,% additional to boxsep, default=4mm
  top = 0pt, bottom = 0pt,% default=2mm
  %middle = 2pt,% additional to boxsep
  %halign=center, valign=bottom,
  %capture=hbox,% default=minipage
  %noparskip,
  beforeafter skip=2.5\parskip,
  before={\vspace{\parskip}%
          \llap{\textcolor{boxtitlecolor}{\faExclamationTriangle}~}\vspace{-\baselineskip}},
  #1
}
\NewTColorBox{warnenv}{ o g }{% optional args: #1 = title ; #2 = more options list whithin braces {}
  colframe=framecolor, colback = boxbackgroundcolor!0,
  colbacktitle=framecolor!50!white,% initially=black!50!white
  enhanced jigsaw,
  breakable, parbox=false,
  bottomtitle=2pt, toptitle=2pt,% default=0pt
  boxrule = 0.6pt, boxsep = 0pt,% default=1mm
  %left=4pt, top=2pt,
  left = 4pt, right = 4pt,% additional to boxsep, default=4mm
  top = 4pt, bottom = 4pt,% default=2mm
  arc = 2pt,% outer arc = 0pt,
  IfValueTF={#1}{%
    adjusted title={#1},%{\hspace{10pt}{#1}},
    fonttitle=\normalsize\titlingfont,%\lightboldfont,%\sffamily\bfseries,
    halign title=flush left,%flush center,
    colbacktitle=black!65,%\@titlingcolor,% initially=black!50!white
    coltitle=white,%\@layoutcolor!0,% default=white
  }{},
  %beforeafter skip=4pt,
  ignore nobreak=true,% In case it follows a heading. Must be set with `before' (see doc p.79)
  before={\vspace{\parskip}\llap{\textcolor{framecolor}{\faExclamationTriangle}~}\vspace{-\baselineskip}},
  after skip=2.5\parskip,
  IfValueTF={#2}{#2}{},
}
\NewTColorBox{defenv}{ s o g }{% optional args: #1 = icon ; #2 = title ;
  breakable, parbox=false,     % #3 = more options list whithin braces {}
  enhanced jigsaw,
  colframe=secondcolor, colback = {firstcolor!25!white},
  colbacktitle=framecolor!50!white,% initially=black!50!white
  bottomtitle=1pt, toptitle=1pt,% default=0pt
  %middle = 2pt,% additional to boxsep
  %boxrule = 0.6pt, boxsep = 0pt,% default=1mm
  arc = 0pt, outer arc = 0pt,
  titlerule=0pt,% boxrule=0pt,
  leftrule = 2pt, rightrule = 0pt,
  bottomrule = 0pt, toprule=0pt,
  left = 4pt, right = 4pt,% additional to boxsep, default=4mm
  top = 2pt, bottom = 2pt,% default=2mm
  IfValueTF={#2}{%
    adjusted title={\textttl{#2}},%{\hspace{10pt}{#2}},
    fonttitle=\normalsize\titlingfont,%\lightboldfont,%\sffamily\bfseries,
    halign title=flush left,%flush center,
    colbacktitle=black!65,%\@titlingcolor,% initially=black!50!white
    coltitle=white,%\@layoutcolor!0,% default=white
    ignore nobreak=true,% In case it follows a heading (e.g. mainly \overparagraph or \paragraph)
  }{},
  %beforeafter skip=4pt,
  IfBooleanTF={#1}%
    {before={\vspace{\parskip}%
              \llap{\textcolor{framecolor}{\faTag}~}\vspace{-\baselineskip}}}% faKey, faPaperlip
    {before={}},
  after skip=2.5\parskip,
  IfValueTF={#3}{#3}{},
}
\NewTColorBox{infoenv}{ o g }{% optional args: #1 = title ; #2 = more options list whithin braces {}
  colframe=framecolor, colback = boxbackgroundcolor!0,
  colbacktitle=framecolor!50!white,% initially=black!50!white
  enhanced jigsaw,
  breakable, parbox=false,
  bottomtitle=2pt, toptitle=2pt,% default=0pt
  boxrule = 0.6pt, boxsep = 0pt,% default=1mm
  %left=4pt, top=2pt,
  left = 4pt, right = 4pt,% additional to boxsep, default=4mm
  top = 4pt, bottom = 4pt,% default=2mm
  arc = 2pt,% outer arc = 0pt,
  IfValueTF={#1}{%
    adjusted title={#1},%{\hspace{10pt}{#1}},
    fonttitle=\normalsize\titlingfont,%\lightboldfont,%\sffamily\bfseries,
    halign title=flush left,%flush center,
    colbacktitle=black!65,%\@titlingcolor,% initially=black!50!white
    coltitle=white,%\@layoutcolor!0,% default=white
  }{},
  %beforeafter skip=4pt,
  ignore nobreak=true,% In case it follows a heading. Must be set with `before' (see doc p.79)
  before={\vspace{\parskip}\llap{\textcolor{framecolor}{\faInfoCircle}~}\vspace{-\baselineskip}},
  after skip=2.5\parskip,
  IfValueTF={#2}{#2}{},
}
\newtcolorbox{oldinfoenv}[1][]{% optional arg = more options list
  breakable,
  parbox=false,
  colframe=framecolor, colback = boxbackgroundcolor!0,
  colbacktitle=framecolor!50!white,% initially=black!50!white
  enhanced jigsaw,
  arc = 2pt,% outer arc = 0pt,
  boxrule = 0.6pt,
  boxsep = 4pt,% default=1mm
  left = 0pt, right = 0pt,% additional to boxsep, default=4mm
  top = 0pt, bottom = 0pt,% default=2mm
  %middle = 2pt,% additional to boxsep
  %halign=center, valign=bottom,
  %capture=hbox,% default=minipage
  %noparskip,
  before={\vspace{\parskip}\llap{\textcolor{framecolor}{\faInfoCircle}~}\vspace{-\baselineskip}},
  beforeafter skip=2.5\parskip,
  #1
}
\newtcolorbox{javaenv}[1][]{% optional arg = more options list
  breakable,
  parbox=false,
  colframe=\@layoutcolor!20, colback = \@layoutcolor!0,
  colbacktitle=\@titlingcolor,% initially=black!50!white
  enhanced jigsaw,
  arc = 2pt,% outer arc = 0pt,
  boxrule = 0.6pt,
  boxsep = 4pt,% default=1mm
  left = 0pt, right = 0pt,% additional to boxsep, default=4mm
  top = 0pt, bottom = 0pt,% default=2mm
  %middle = 2pt,% additional to boxsep
  %halign=center, valign=bottom,
  %capture=hbox,% default=minipage
  %noparskip,
  beforeafter skip=2.5\parskip,
  before={\vspace{\parskip}\llap{\textcolor{boxtitlecolor}{\mfJava}~}\vspace{-\baselineskip}},
  #1
}
\newtcolorbox{idcardbox}[2][]{%
  breakable,
  adjusted title={\hspace{0pt}{#2}},
  halign title=flush left,%flush center,
  colframe=\@layoutcolor!20, colback = \@layoutcolor!0,
  colbacktitle=\@layoutcolor!15,% initially=black!50!white
  fonttitle=\normalsize\lightboldfont\scshape, coltitle=black,%\@titlingcolor,% default=white
  fontupper=\small, fontlower=\small,
  bottomtitle=-2pt, toptitle=-2pt,% cause boxsep=4pt % default=0pt
  enhanced jigsaw,
  arc = 2pt,% outer arc = 0pt,
  boxrule = 0.6pt,
  boxsep = 4pt,% default=1mm
  left = 0pt, right = 0pt,% additional to boxsep, default=4mm
  top = 0pt, bottom = 0pt,% default=2mm
  %middle = 2pt,% additional to boxsep
  %halign=center, valign=bottom,
  %capture=hbox,% default=minipage
  %noparskip,
  beforeafter skip=2.5\parskip,
  #1
}


%---------------------------------------------------------------------------------------------------
%---- PythonTeX
%---------------------------------------------------------------------------------------------------

%--- PythonTeX forewords
%-----------------------
%- For the time being, only Python language is exploited with PythonTeX; mainly for its interactive
%- abilities. May be it will be used in the future for other supported languages such as Bash
%- or JavaScript. For other languages than Python, the `listings' package is used (see above)
%-----

%--- PythonTeX configuration (Debian based OS like Ubuntu. For other platforms, refer to doc.)
%---------------------------------------------------------------------------------------------
%- Pygments coloured style schemes
%-----
%- Pygments Python module must be installed to use PythonTeX. See, e.g.:
%-   https://zoomadmin.com/HowToInstall/UbuntuPackage/python-pygments
%-   > sudo apt-get update -y
%-   > sudo apt-get install -y python-pygments
%- Configuring a TeX IDE: LaTeXila/Gnome LaTeX (Gtk+) or TeXmaker (Qt)
%-   In order to run external applications from a TeX IDE (e.g. like for glossaries with `xindy'
%-   Perl script or `bib2gls' Java application, or here for PythonTeX the `pythontex.py' script),
%-   ONE MUST ADD SYMBOLIC LINKS IN /usr/bin/.
%-   Go inside the /usr/bin/ repository, open a terminal and type in:
%-   > sudo ln -s /opt/texlive/2019/bin/x86_64-linux/xindy xindy (OK: FINE!)
%-   > sudo ln -s /opt/texlive/2019/texmf-dist/scripts/pythontex/pythontex.py pythontex (OK: FINE!)
%- UBUNTU MATE 20.04: A LINK FROM PYTHON TO PYTHON3 *MUST BE DONE* IN /bin (AND MAYBE /usr/bin)
%- IN ORDER TO USE minted, tcolorbox with minted AND PythonTeX WITH PYTHON3:
%-   > sudo ln -s /bin/python3 /bin/python
%- Then in LaTeXila/Gnome LaTeX, open:
%-  Construction > Gérer les outils de construction > add a new one
%-  or double click on Python → LaTeX if already defined
%-  In the "Commandes" field, type in:
%-   /opt/texlive/2019/texmf-dist/scripts/pythontex/pythontex.py $shortname
%- Now when clicking the choosen icon from the main LaTeXila/Gnome LaTeX interface, it launchs
%- PythonTeX script. Take care of indentation, not to have stupid errors! Then, rerun LaTeX twice
%-
%- Sympy module
%----
%- As for Pygments, the Sympy module must be installed to be used with PythonTeX:
%-   > sudo apt-get update -y
%-   > sudo apt-get install -y python-sympy
%-
%-----

%--- Note − Pygments, Sympy and Pylab
%-------------------
%- PythonTeX uses the powerful Pygments library for syntax highlighting (see `minted' package
%- created by Konrad Rudolph and now maintained by the same author of PythonTeX: Geoffrey M. Poore)
%-
%- Pygments coloured style schemes
%---------------------------------
%- Pygments includes directly a LaTeX formatter, associated with color scheme. See:
%-   https://pygments.org/docs/styles/
%- To list buildin styles, open an IDLE console and type in the following lines:
%-   >>> from pygments.styles import get_all_styles
%-   >>> styles = list(get_all_styles())
%-   >>> styles
%- The Pygments style schemes are:
%-   ['default', 'emacs', 'friendly', 'colorful', 'autumn', 'murphy', 'manni', 'monokai', 'perldoc',
%-    'pastie', 'borland', 'trac', 'native', 'fruity', 'bw', 'vim', 'vs', 'tango', 'rrt', 'xcode',
%-    'igor', 'paraiso-light', 'paraiso-dark', 'lovelace', 'algol', 'algol_nu', 'arduino',
%-    'rainbow_dash', 'abap']
%- The `tango' style seems to be a good temporary solution
%- TODO: Set a colored Python code scheme corresponding to the IDE in use (Spyder, etc.)
%- The Pygments styles are in the repository: /usr/lib/python3/dist-packages/pygments/styles
%- Copy e.g. the `default` style and change the color scheme to whatever you want (in Spyder, the
%- coloured scheme is given with the color codes: Spyder > Outils > Preferences > Coloration
%- syntaxique > Modifier)
%- To choose a Pygments style, see: https://help.farbox.com/pygments.html
%-
%- Basic usage and options
%------------------------
%- From a LaTeX file, Pygments is called with the `pygments' environment:
%-   \begin{pygments} ... <stuff> ... \end{pygments}
%- This environment may be launched with optional arguments, such as style (see above) or orther
%- layout add-ons. For a complete list, see: https://pygments.org/docs/formatters/. These options
%- have to be given to PythonTeX with pygopt={<option name>=<value>, ...}. After some trials,
%- it seems that some of them are leading to errors with PythonTeX (humm... Really?).
%- Reading the examples given by pythontex_gallery.tex, one has to take care between options
%- from Pygments, from PythonTeX and surrounding environments (mdframed or tcolorbox).
%- In order to have a stable solution for Python code listings, the `minted' and `tcolorbox'
%- are used together, deriving from a solution given in the `tcolorbox' package documentation
%- (p.319, v.4.22). May be in the future, all the code listings (Java, HTML, Php, etc.) will be
%- switched to Pygments/minted/tcolorbox as it is done above with `listings/tcolorbox' packages.
%- By the way, the color styles will have to correspond to each used IDE, i.e.: Eclipse for Java,
%- Spyder or whatever other IDEs for Python, Eclipse/Bluefish for HTML/Php and so on.
%- In order to have the same colored syntax as for Ubuntu MATE Radiant (Pluma), we redefine
%- the Tango style and call it `jazzcode.py' (there is some differences between minted 
%- and PythonTeX for example for `print' (TO BE FIXED). Thus, we load PythonTeX 
%- with this new Tango style. By the way we set Minted to have the same style for Python 
%- and not the default one (see above the `minted' package loading).
%-----

\RequirePackage[%
  usefamily=python,% Programming language
  gobble=auto,% Managing the leading whitespace in code
  pygopt={style=jazzcode, texcomments=true, mathescape=false},% Pygments options
  ]{pythontex}

\setpythontexworkingdir{PythonTeX}


%- See: https://tex.stackexchange.com/questions/213048/how-to-make-breaklines-the-result-from-pythontex
%\RequirePackage{fvextra}% To have breaklines (loaded by default with new versions)

%\fvset{breaklines, breakafter=0123456789}% wrapping a long number


%\setpythontexpygopt[python]{style=jazz,texcomments=true,mathescape=true}% Pygments options


%- IPython console is not yet available, only the IDLE one is given, see:
%- https://tex.stackexchange.com/questions/224526/can-i-make-ipython-notebook-from-pythontex



%\newcounter{code}% Already defined by `newfloat'

%- PythonTeX
%-   https://tex.stackexchange.com/questions/129657/pythontex-importing-python-files
%-   https://tex.stackexchange.com/questions/195078/beamer-and-pause-with-pythontex


%- Code indentation, see:
%-   https://tex.stackexchange.com/questions/249755/showing-nice-indentation-of-python-code

%\setpythontexfv{numbers=left, firstnumber=last}
%\setpythontexlistingenv{listing}

%- https://tex.stackexchange.com/questions/448212/how-to-perform-a-global-renewenvironment/
%\global\let\code\pythoncode%
%\global\let\endcode\endpythoncode%
%\renewenvironment{code}{%
%  \begin{pythoncode}%
%  }{%
%  \end{pythoncode}%
%}

\definecolor{idleshellbgcolor}{RGB}{248, 248, 248}% HTML: #f8f8f8 (see Pygments)
\definecolor{idleshellbgmenu}{RGB}{242, 241, 240}% HTML: #f2f1f0
\definecolor{idleoutputcolor}{RGB}{0, 0, 207}% HTML: #0000cf
\definecolor{idleerrorcolor}{RGB}{255, 0, 0}% HTML: #ff0806 (pure red)

\NewTColorBox{idleshell}{ o G{Python 3.8.2 Shell} }{% To surround "pyconsole" environment
  enhanced, breakable, boxsep=0pt,
  top=16pt, bottom=4pt,% middle = 2pt,% additional to boxsep
  left=2pt, right=2pt, arc=2pt,% Default: arc=1mm
  toptitle=1pt, bottomtitle=1pt,
  boxrule=0.8pt,
  %colback=violet!50!black,
  colbacktitle=shelltitlebgcolor,
  coltitle=white,
  fonttitle=\shellfont,
  colback=idleshellbgcolor, 
  colupper=black, 
  fontupper=\small\shellttfont,
  colframe=shelltitlebgcolor,
  fuzzy halo=1.2pt with gray,
  sharp corners=south,
  lowerbox=ignored,
  before skip=6pt,
  after skip=6pt,
  attach boxed title to top,
  title={%
    \hspace*{1.5pt}\includegraphics[scale=0.2]{ubuntu-close.png}\hspace*{1.5pt}%
    \includegraphics[scale=0.2]{ubuntu-minimize.png}\hspace*{1.5pt}%
    \includegraphics[scale=0.2]{ubuntu-maximize.png}%
    \hspace*{4pt}\raisebox{1.5pt}{\footnotesize#2}%\newline%
  },
  boxed title style={%
    colback=shelltitlebgcolor,
    interior code={%
      \path[draw=gray, line width=1.2pt, fill=idleshellbgmenu] 
        (interior.south west) rectangle ([yshift=-12pt]interior.south east);
      \node[anchor=west, font=\footnotesize\shellfont] 
        at ([xshift=0.5pt, yshift=-6pt]interior.south west) {%
          \uline{F}ile\hspace*{5pt}\uline{E}dit\hspace*{5pt}\uline{S}hell\hspace*{5pt}%
          \uline{D}ebug\hspace*{5pt}\uline{O}ptions\hspace*{5pt}\uline{W}indow\hspace*{5pt}%
          \uline{H}elp%
      };
    },
  },
  IfValueTF={#1}{#1}{}
}

\NewTColorBox{idleshell*}{ o G{Python 3.8.2 Shell} }{% To surround "pyconsole" environment (full width)
  enhanced, breakable, 
  check odd page, 
  toggle left and right, 
  grow to right by=\marginparwidth+\marginparsep, 
  toggle enlargement=evenpage, 
  notitle after break,
  boxsep=0pt,
  top=16pt, bottom=4pt,% middle = 2pt,% additional to boxsep
  left=2pt, right=2pt, arc=2pt,% Default: arc=1mm
  toptitle=1pt, bottomtitle=1pt,
  boxrule=0.8pt,
  %colback=violet!50!black,
  colbacktitle=shelltitlebgcolor,
  coltitle=white,
  fonttitle=\shellfont,
  colback=idleshellbgcolor, 
  colupper=black, 
  fontupper=\small\shellttfont,
  colframe=shelltitlebgcolor,
  fuzzy halo=1.2pt with gray,
  sharp corners=south,
  lowerbox=ignored,
  before skip=6pt,
  after skip=6pt,
  attach boxed title to top,
  title={%
    \hspace*{1.5pt}\includegraphics[scale=0.2]{ubuntu-close.png}\hspace*{1.5pt}%
    \includegraphics[scale=0.2]{ubuntu-minimize.png}\hspace*{1.5pt}%
    \includegraphics[scale=0.2]{ubuntu-maximize.png}%
    \hspace*{4pt}\raisebox{1.5pt}{\footnotesize#2}%\newline%
  },
  boxed title style={%
    colback=shelltitlebgcolor,
    interior code={%
      \path[draw=gray, line width=1.2pt, fill=idleshellbgmenu] 
        (interior.south west) rectangle ([yshift=-12pt]interior.south east);
      \node[anchor=west, font=\footnotesize\shellfont] 
        at ([xshift=0.5pt, yshift=-6pt]interior.south west) {%
          \uline{F}ile\hspace*{5pt}\uline{E}dit\hspace*{5pt}\uline{S}hell\hspace*{5pt}%
          \uline{D}ebug\hspace*{5pt}\uline{O}ptions\hspace*{5pt}\uline{W}indow\hspace*{5pt}%
          \uline{H}elp%
      };
    },
  },
  IfValueTF={#1}{#1}{}
}

\NewTColorBox{idleconsole}{ o }{% To surround "pyconsole" environment
  enhanced, breakable, boxsep=0pt,
  top=4pt, bottom=4pt,% middle = 2pt,% additional to boxsep
  left=2pt, right=2pt, arc=2pt,% Default: arc=1mm
  boxrule=0.8pt,
  colback=idleshellbgcolor, 
  colupper=black, 
  fontupper=\small\shellttfont,
  colframe=shelltitlebgcolor,
  fuzzy halo=1.2pt with gray,
  sharp corners,
  lowerbox=ignored,
  before skip=6pt,
  after skip=6pt,
  notitle,
  IfValueTF={#1}{#1}{},
}

\NewTColorBox{idleconsole*}{ o }{% To surround "pyconsole" environment → fullwidth
  enhanced, breakable, 
  check odd page, 
  toggle left and right, 
  grow to right by=\marginparwidth+\marginparsep, 
  toggle enlargement=evenpage, 
  notitle after break,
  boxsep=0pt,
  top=4pt, bottom=4pt,% middle = 2pt,% additional to boxsep
  left=2pt, right=2pt, arc=2pt,% Default: arc=1mm
  boxrule=0.8pt,
  colback=idleshellbgcolor, 
  colupper=black, 
  fontupper=\small\shellttfont,
  colframe=shelltitlebgcolor,
  fuzzy halo=1.2pt with gray,
  sharp corners,
  lowerbox=ignored,
  before skip=6pt,
  after skip=6pt,
  notitle,
  IfValueTF={#1}{#1}{},
}


%---------------------------------------------------------------------------------------------------
%---- Figure/table inside a tcolorbox (floats are forbidden → \captionof{})
%---------------------------------------------------------------------------------------------------

%----- WARNING: Within a tcolorbox, floating environments like figures and tables are forbidden.
%- \includegraphics macro (graphicx package) or \tikzpicture environment (TikZ package) may be
%- used directly, and the captions, if any, must be given with the help of the \captionof macro.
%- To mimic the figure and table environments, exfigure and extable environments are defined
%- with their counterpart \tcbfigcaptionof and \tcbtabcaptionof macros.
%--- FOR NOW, THE FOLLOWING WORKAROUND DOESN'T WORK ← TODO FIXME
%- Furthermore, in order to use the same syntax inside and outside a exercise/solution environment,
%- the figure and table environments are settled to exfigure and extable environments inside
%- the exercise/solution environment. The same is applied to \caption and \captionof with their
%- counterpart \tcbfigcaptionof and \tcbtabcaptionof. This workaround, besides the syntax issue,
%- is to be able to reuse the stand alone solutions files without modifications of the figure
%- and table syntaxes.
%-----

%-- See:
%-- https://tex.stackexchange.com/questions/116670/duplicating-environments
%-- https://tex.stackexchange.com/questions/47351/can-i-redefine-a-command-to-contain-itself
%-- https://tex.stackexchange.com/questions/75692/different-margins-for-text-and-figures
%-- https://tex.stackexchange.com/questions/287837/how-to-patch-a-starred-environment
%-- https://tex.stackexchange.com/questions/88001/when-to-use-letltxmacro
%-- https://tex.stackexchange.com/questions/82859/redefine-environment-to-be-a-synonym-for-another
%-- https://tex.stackexchange.com/questions/300688/
%- From article.cls or book.cls
%\newenvironment{figure}
%               {\@float{figure}}
%               {\end@float}
%\newenvironment{figure*}
%               {\@dblfloat{figure}}
%               {\end@dblfloat}
%\LetLtxMacro\originalfigure\figure% must be used for macros with optional arguments (letltxmacro)
%\let\endoriginalfigure\endfigure% \let is sufficient here
%\LetLtxMacro\originalcaptionof

\tcbset{%
  tcbfigstyle/.style={%
    enhanced,
    capture=hbox,
    every float=\centering,
  },
  tcbfloatexercicestyle/.style={%
    blank,
    beforeafter skip=8pt,
    halign=flush center,
    width=\linewidth,
  },
}

\newcounter{exfigurecounter}
\newcounter{extablecounter}
\newcounter{exlistingcounter}
\newcounter{excodecounter}

\newcounter{exfigurecaptioncounter}% For counting exercise statement and solution figures
\newcounter{extablecaptioncounter}% For counting exercise statement and solution tables
\newcounter{exlistingcaptioncounter}% For counting exercise statement and solution tables
\newcounter{excodecaptioncounter}% For counting exercise statement and solution tables

\newtcolorbox[use counter=exfigurecounter]{exfigure}{% New figure environment within exercises
  tcbfloatexercicestyle,
}
\newtcolorbox[use counter=extablecounter]{extable}{% New table environment within exercises
  tcbfloatexercicestyle,
}
\newtcolorbox[use counter=exlistingcounter]{exlisting}{% New listing environment within exercises
  tcbfloatexercicestyle,
}
\newtcolorbox[use counter=excodecounter]{excode}{% New code environment within exercises
  tcbfloatexercicestyle,
}
%\NewDocumentEnvironment{<env name without leading slash>}{<arg spec>}{<begin env code>}{<end env code>}
%\NewDocumentEnvironment{excode}{ m }
%  {\begin{listingbox}{#1}}{\end{listingbox}}
\newcommand{\tcbfigcaptionof}[1]{% Just an alias taking into account \tcolorbox figures "captions"
  \stepcounter{exfigurecaptioncounter}
  \vspace*{2pt}
  \captionof{figure}{#1}
}
\newcommand{\tcbtabcaptionof}[1]{% Just an alias taking into account \tcolorbox tables "captions"
  \stepcounter{extablecaptioncounter}
  \captionof{table}{#1}
  \vspace*{2pt}
}
\newcommand{\tcblstcaptionof}[1]{% Just an alias taking into account \tcolorbox listings "captions"
  \stepcounter{exlistingcaptioncounter}
  \captionof{listing}{#1}
  \vspace*{2pt}
}
\newcommand{\tcbcodecaptionof}[1]{% Just an alias taking into account \tcolorbox codes "captions"
  \stepcounter{excodecaptioncounter}
  \captionof{code}{#1}
  \vspace*{2pt}
}


%---------------------------------------------------------------------------------------------------
%---- Exercise/solution environment/macro (adapted from the `tcolorbox' package documentation)
%---------------------------------------------------------------------------------------------------

%----- IMPORTANT NOTE (OLD FASHION: see `askreply' and `assignpoints' packages after hyperref)
%- Of course, in the meantime of this class implementation, other people adressed the same issue...
%- So, please have a look to the `xsim` package, which gives (and certainly better) solutions
%- when dealing with exercises/solutions environments and features.
%- In a next release of the TeXjazz-handbook class, some ideas from the `xsim' package will
%- certainly be "stolen", in particular the point counting algorithm.
%-----

%-- Temporaly/auxiliary counters within an exercise environments

\newcounter{tmpfigurecounter}% Temporary counter of figures
\newcounter{tmptablecounter}% Temporary counter of tables
\newcounter{tmplistingcounter}% Temporary counter of listings
\newcounter{tmpcodecounter}% Temporary counter of codes
\newcounter{tmpvideocounter}% Temporary counter of videos
\newcounter{tmpdocumentcounter}% Temporary counter of documents

\newcounter{tcbexercise}% Reset within appendixchapter explicitely at \appendix command (see below)
\newcounter{examination}% Reset within appendixchapter explicitely at \appendix command (see below)

%-- Initialization and counting

\AtEndEnvironment{figure}{% Store figure number before tcolorbox exercise/solution environments
  \setcounter{tmpfigurecounter}{\c@figure}
}
\AtEndEnvironment{table}{% Store figure number before tcolorbox exercise/solution environments
  \setcounter{tmptablecounter}{\c@table}
}
\AtEndEnvironment{listing}{% Store figure number before tcolorbox exercise/solution environments
  \setcounter{tmplistingcounter}{\c@listing}
}
\AtEndEnvironment{code}{% Store figure number before tcolorbox exercise/solution environments
  \setcounter{tmpcodecounter}{\c@code}
}

%----- Warning: \apptocmd (etoolbox) fails and \xapptocmd (xpatch) works, WHY?
%- Patching \@video, \@pdfdoc, \@pdfwatch, \@webdoc fails with \apptocmd but works with \xapptocmd
%- In both cases, patching \@hrefdoc fails (catcode 12?). These macros definitions are specials.
%- Apart from that, the first part of these macros: \video, \pdfdoc, \pdfwatch, \webdoc and \hrefdoc
%- are patchable both with \patchcmd and \xpatchcmd.
%-----

%\xapptocmd{\@video}{%
%  %\setcounter{tmpvideocounter}{\c@video}% Store video number before exercise/solution environments
%  \ifnum\c@tcbexercise > 0
%    \stepcounter{tmpvideocounter}% Count videos in exercise/solution environment
%  \fi
%}{}{}
%- No side videos within exercises
%\xapptocmd{\@sidevideo}{% It fails with \apptocmd (etoolbox) and works with \xapptocmd (xpatch)
%  %\setcounter{tmpvideocounter}{\c@video}% Store video number before exercise/solution environments
%  \ifnum\c@tcbexercise > 0
%    \stepcounter{tmpvideocounter}% Count videos in exercise/solution environment
%  \fi
%}{}{}
%\xapptocmd{\@pdfdoc}{% It fails with \apptocmd (etoolbox) and works with \xapptocmd (xpatch), WHY?
%  \ifnum\c@tcbexercise > 0
%    \stepcounter{tmpdocumentcounter}% Count documents in exercise/solution environment
%  \fi
%}{}{}
%\xapptocmd{\@pdfwatch}{% It fails with \apptocmd (etoolbox) and works with \xapptocmd (xpatch), WHY?
%  \ifnum\c@tcbexercise > 0
%    \stepcounter{tmpdocumentcounter}% Count documents in exercise/solution environment
%  \fi
%}
%{}{}
%\xapptocmd{\@webdoc}{% It fails with \apptocmd (etoolbox) and works with \xapptocmd (xpatch), WHY?
%  \ifnum\c@tcbexercise > 0
%    \stepcounter{tmpdocumentcounter}% Count documents in exercise/solution environment
%  \fi
%}
%{}{}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%\patchcmd{\video}% Counting videos in exercise/solution environment
%  {\refstepcounter{video}}
%  {\refstepcounter{video}\ifnum\c@tcbexercise > 0\stepcounter{tmpvideocounter}\fi}
%  {}{}
\patchcmd{\pdfdoc}% Counting documents in exercise/solution environment
  {\refstepcounter{document}}
  {\refstepcounter{document}\ifnum\c@tcbexercise > 0\stepcounter{tmpdocumentcounter}\fi}
  {}{}
% {\ClassWarning{texjazz-handbook.cls}{Succeeded to append code to pdfdoc macro.}}
% {\ClassWarning{texjazz-handbook.cls}{Failed to append code to pdfdoc macro.}}
\patchcmd{\pdfwatch}% Counting documents in exercise/solution environment
  {\refstepcounter{document}}
  {\refstepcounter{document}\ifnum\c@tcbexercise > 0\stepcounter{tmpdocumentcounter}\fi}
  {}{}
\patchcmd{\webdoc}% Counting documents in exercise/solution environment
  {\refstepcounter{document}}
  {\refstepcounter{document}\ifnum\c@tcbexercise > 0\stepcounter{tmpdocumentcounter}\fi}
  {}{}
\patchcmd{\hrefdoc}% Counting documents in exercise/solution environment
  {\refstepcounter{document}}
  {\refstepcounter{document}\ifnum\c@tcbexercise > 0\stepcounter{tmpdocumentcounter}\fi}%
  {}{}
%  {\ClassWarning{texjazz-handbook.cls}{Succeeded to patch hrefdoc macro.}}
%  {\ClassWarning{texjazz-handbook.cls}{Failed to patch hrefdoc macro.}}

%-- Tcolorbox settings for exercise/solution environment/macro

\tcbset{
  exercisestyle/.style={
    breakable, enhanced,
    parbox=false,% To have indentation
    %colframe=green!20!black,colback=yellow!10!white,coltitle=green!40!black,
    colframe=darkelectricblue, colback=black!10!white,
    coltitle=secondcolor!90!black,
    fonttitle=\scshape\fontsize{11.2pt}{13.4pt}\selectfont\titlingspacedfont,
    boxrule = 2pt,% default=0.5mm
    boxsep = 2pt,% default=1mm
    left = 20pt,
    right = 20pt,% additional to boxsep, default=4mm
    %top = 0pt, bottom = 0pt,% default=2mm
    %middle = 2pt,% additional to boxsep
    underlay={%
      \begin{tcbclipinterior}
        \shade[inner color=darkelectricblue!80!black,outer color=black!10!white]
          (interior.north west) circle (2cm);
        %\draw[help lines,step=5mm,white!80!black,shift={(interior.north west)}]
        %  (interior.south west) grid (interior.north east);
      \end{tcbclipinterior}},
    attach title to upper={\par\vspace{2pt}},
    beforeafter skip=2.5\parskip,
  },
  examinationstyle/.style={
    breakable, enhanced,
    parbox=false,% To have indentation
    colframe=darkgray,% black!60!white, % black!75!white,
    colback=black!5!white,
    coltitle=secondcolor,
    fonttitle=\scshape\fontsize{11.2pt}{13.4pt}\selectfont\titlingspacedfont,
    arc=0pt,
    boxrule = 2pt,% default=0.5mm
    boxsep = 2pt,% default=1mm
    left = 20pt, right = 20pt,% additional to boxsep, default=4mm
    %top = 0pt, bottom = 0pt,% default=2mm
    %middle = 2pt,% additional to boxsep
    underlay={%
      \begin{tcbclipinterior}
        \shade[inner color=black!5!white,outer color=black!5!white]% No shade, we overwrite it
          (interior.north west) circle (2cm);
        %\draw[help lines,step=5mm,white!80!black,shift={(interior.north west)}]
        %  (interior.south west) grid (interior.north east);
      \end{tcbclipinterior}},
    attach title to upper={\par\vspace{2pt}},
    beforeafter skip=2.5\parskip,
  }
}

%-- Environment exercise/solution definition

\NewTColorBox[%
  %auto counter,% With this option, the internal counter is \tcb@cnt@exercise (not \c@tcbexercise)
  use counter=tcbexercise,
  number within=appendixchapter,
  list inside=loe,% to have a list of exercice with \tcblistof[\section]{<name>}{<title>}
  % With list type a \l@exercise command must be defined OR manually done with `titletoc' package
  % See: change-tcolorbox-tcblistof-font-formatting-to-match-documents-other-lists:
  %       https://tex.stackexchange.com/questions/353947/
  list type=exercise,% By default → Layout is done by \l@tcolorbox command
  %crefname={exercise}{exercises},% DOES NOT WORK!! WHY? TODO
  %Crefname={Exercise}{Exercises},%
  ]
  {tcbexercise}{s +O{} g}{% What "+" means? From doc.: long argument (allows paragraph tokens)
    exercisestyle,
    label={exercise:\thetcbcounter},% Original label is with `@': \ref{exercise@1}
    %label type=exercise,% To fit with cleveref package (see tcolorbox doc. p.357)
    IfBooleanTF={#1}{% With star: exercise without solution (recording is an empty file)
      no recording,
      after upper={
        %- Counters setting for the exercise statement part
        \ifnum\c@figure > \c@tmpfigurecounter% The statement part has figure(s)
          \addtocounter{tmpfigurecounter}{\c@exfigurecaptioncounter}%
        \fi
        \setcounter{exfigurecaptioncounter}{0}% Reset figure caption counter for the solution part
        \ifnum\c@table > \c@tmptablecounter% The statement part has table(s)
          \addtocounter{tmptablecounter}{\c@extablecaptioncounter}%
        \fi
        \setcounter{extablecaptioncounter}{0}% Reset table caption counter for the solution part
        \ifnum\c@listing > \c@tmplistingcounter% The statement part has listing(s)
          \addtocounter{tmplistingcounter}{\c@exlistingcaptioncounter}%
        \fi
        \setcounter{exlistingcaptioncounter}{0}% Reset listing caption counter for the solution part
        \ifnum\c@code > \c@tmpcodecounter% The statement part has code(s)
          \addtocounter{tmpcodecounter}{\c@excodecaptioncounter}%
        \fi
        \setcounter{excodecaptioncounter}{0}% Reset code caption counter for the solution part
        \ifnum\c@tmpvideocounter > 0% The statement part has video(s)
          %\setcounter{video}{\c@tmpvideocounter}%
          \addtocounter{video}{\c@tmpvideocounter}%
        \fi
        \ifnum\c@tmpdocumentcounter > 0% The statement part has document(s)
          \addtocounter{document}{\c@tmpdocumentcounter}%
        \fi
      },
      IfValueTF={#3}{
        title={\llap{\textcolor{secondcolor}{\normalfont\large\faPencil\space\hskip 3pt}}%
          \exercisetitlefont{\exercisename~\thetcbcounter\enspace---\enspace #3}},
        list entry={\protect\numberline{\thetcbcounter}#3}
      }{% TAKE CARE THAT LIST ENTRIES ARE SETTED WITH "list entry" BUT ALSO "title" and "titletext"
        % See above the refinition of \tcb@addcontentsline and below the "fake title" definition
        % with "before upper" option: no text title implies no entry in the list of exercises
        before upper={\llap{\textcolor{secondcolor}{\normalfont\large\faPencil\space\hskip 3pt}}%
          \textcolor{secondcolor}{\exercisetitlefont{\exercisename~\thetcbcounter}}%
          \smallskip%
        },
        code={% See \tcb@addcontentsline definition above: No entry in LoE if star without title
          \let\kvtcb@listentry\@empty%
          \let\kvtcb@title\@empty%
          \let\tcbtitletext\@empty%
        }
      },
    }{% Without star: exercise with solution file recording
      lowerbox=ignored,
      savelowerto=solution-\thetcbcounter.tex,
      after upper={%
        \par\hfill\textcolor{secondcolor}%
        {\itshape\footnotesize{\normalfont\faSquare}%
        \enspace Solution page~\pageref{solution:\thetcbcounter}}%
        %- Counters setting for the exercise statement part
        \ifnum\c@figure > \c@tmpfigurecounter% The statement part has figure(s)
          \addtocounter{tmpfigurecounter}{\c@exfigurecaptioncounter}%
        \fi
        \setcounter{exfigurecaptioncounter}{0}% Reset figure caption counter for the solution part
        \ifnum\c@table > \c@tmptablecounter% The statement part has table(s)
          \addtocounter{tmptablecounter}{\c@extablecaptioncounter}%
        \fi
        \setcounter{extablecaptioncounter}{0}% Reset table caption counter for the solution part
        \ifnum\c@listing > \c@tmplistingcounter% The statement part has listing(s)
          \addtocounter{tmplistingcounter}{\c@exlistingcaptioncounter}%
        \fi
        \setcounter{exlistingcaptioncounter}{0}% Reset listing caption counter for the solution part
        \ifnum\c@code > \c@tmpcodecounter% The statement part has code(s)
          \addtocounter{tmpcodecounter}{\c@excodecaptioncounter}%
        \fi
        \setcounter{excodecaptioncounter}{0}% Reset code caption counter for the solution part
        \ifnum\c@tmpvideocounter > 0% The statement part has video(s)
          \addtocounter{video}{\c@tmpvideocounter}%
        \fi
        \ifnum\c@tmpdocumentcounter > 0% The statement part has document(s)
          \addtocounter{document}{\c@tmpdocumentcounter}%
        \fi
        %\textcolor{violet}{% DEBUG
        %  FIGCNT: \thefigure~
        %  TCBFIGCAPCNT: \theexfigurecaptioncounter~
        %  FIGTMPCNT: \thetmpfigurecounter~}
      },
      IfValueTF={#3}{% With text title, so implies an entry in list of exercices
        title={\llap{\textcolor{secondcolor}{\normalfont\large\faPencil\space\hskip 3pt}}%
          \exercisetitlefont{\exercisename~\thetcbcounter\enspace---\enspace#3}},
        list entry={\protect\numberline{\thetcbcounter}#3\
          (solution p.~\pageref{solution:\thetcbcounter})},
        record={\string\tcbsolution{#2}[#3]{\thetcbcounter}{solution-\thetcbcounter.tex}}
      }{% Without title, so without entry in the list of exercises, but a solution recording.
        % Like for star option, define a "fake title" with "before upper" option coming from
        % the `tcolorbox' package and set all concerned fields to \@empty
        before upper={\llap{\textcolor{secondcolor}{\normalfont\large\faPencil\space\hskip 3pt}}%
          \textcolor{secondcolor}{\exercisetitlefont{\exercisename~\thetcbcounter}}%
          \smallskip%
        },
        code={% See \tcb@addcontentsline definition: No entry in LoE if no star but without title
          \let\kvtcb@listentry\@empty%
          \let\kvtcb@title\@empty%
          \let\tcbtitletext\@empty%
        },
        record={\string\tcbsolution{#2}{\thetcbcounter}{solution-\thetcbcounter.tex}%
        },
      },
    },% End of star/no star version
  %before upper app={\renewenvironment{figure}{\begin{exfigure}}{\end{exfigure}}},
  %after={\renewenvironment{figure}{\originalfigure}{\endoriginalfigure}},
  #2% More options
}
\AfterEndEnvironment{tcbexercise}{%
  %- Adjust the figure/table numbering within "exercise" and "exfigure/extable" environments
  %- Reset counters due to storing of solutions in separate TeX files: It applies to "captionof"
  %- commands which increments figures numbering for statement and solution.
  %- These counters are also resettled at each appendixchapter (where exercises are proposed).
  \ifnum\c@exfigurecaptioncounter > 0
    \addtocounter{figure}{-\c@exfigurecaptioncounter}%
  \fi
  \ifnum\c@extablecaptioncounter > 0
    \addtocounter{table}{-\c@extablecaptioncounter}
  \fi
  \ifnum\c@exlistingcaptioncounter > 0
    \addtocounter{listing}{-\c@exlistingcaptioncounter}
  \fi
  \ifnum\c@excodecaptioncounter > 0
    \addtocounter{code}{-\c@excodecaptioncounter}
  \fi
%  \ifnum\c@tmpfigurecounter > 0
%    \addtocounter{figure}{-\c@tmpfigurecounter}
%  \fi
%  \ifnum\c@tmptablecounter > 0
%    \addtocounter{table}{-\c@tmptablecounter}
%  \fi
  \ifnum\c@tmpvideocounter > 0
    \addtocounter{video}{-\c@tmpvideocounter}
  \fi
  \ifnum\c@tmpdocumentcounter > 0
    \addtocounter{document}{-\c@tmpdocumentcounter}
  \fi
}
%- Solution part/file of an exercise
\NewTotalTColorBox{\tcbsolution}{ o o m m }{%
%- Syntax: {#1} = options list, [#2] = optional title, {#3} = label, {#4} = file name of solution
  exercisestyle,
  IfValueTF={#2}
    {title={\llap{\textcolor{secondcolor}{\normalfont\large\faInfoCircle\space\hskip 3pt}}%
            \exercisetitlefont{Solution exercice~\ref{exercise:#3}
                page~\pageref{exercise:#3}\enspace---\enspace #2}}}
    {title={\llap{\textcolor{secondcolor}{\normalfont\large\faInfoCircle\space\hskip 3pt}}%
            \exercisetitlefont{Solution exercice~\ref{exercise:#3} page~\pageref{exercise:#3}}}},
  phantomlabel={solution:#3},%
  code={%
    \setcounter{tmpvideocounter}{0}% Reset tmp video counter for solution part
    \setcounter{tmpdocumentcounter}{0}% Reset tmp document counter for solution part
    \setcounter{tcbquestion}{0}% Reset question numbering for answers environment below (? Old?)
  },
  before upper app={%
    \ifnum\c@figure = 0% An exercise starts a chapter with no figure in the statement/upper part
      \global\toggletrue{noFigs}
    \fi
    \ifnum\c@table = 0% An exercise starts a chapter with no table in the statement/upper part
      \global\toggletrue{noTabs}
    \fi
    \ifnum\c@listing = 0% An exercise starts a chapter with no listing in the statement/upper part
      \global\toggletrue{noListings}
    \fi
    \ifnum\c@code = 0% An exercise starts a chapter with no code in the statement/upper part
      \global\toggletrue{noCodes}
    \fi
    \ifnum\c@video = 0% An exercise starts a chapter with no video in the statement/upper part
      \global\toggletrue{noVids}
    \fi
    \ifnum\c@document = 0% An exercise starts a chapter with no document in the statement/upper part
      \global\toggletrue{noDocs}
    \fi
  },
  IfValueTF={#1}{#1}{},% More options
}{\input{#4}}% File of solution

%-- Statement environment ("Énoncé" in French)

\NewTColorBox{statement}{ o g }{%
  breakable,
  enhanced,
  parbox=false,% To have indentation
  colframe=darkelectricblue,
  colback=black!10!white,
  boxrule = 2pt,% default=0.5mm
  boxsep = 2pt,% default=1mm
  left = 20pt, right = 20pt,% additional to boxsep, default=4mm
  %top = 0pt, bottom = 0pt,% default=2mm
  %middle = 2pt,% additional to boxsep
  beforeafter skip=2.5\parskip,
  underlay={%
    \begin{tcbclipinterior}
      \shade[inner color=darkelectricblue!80!black,outer color=black!10!white]
        (interior.north west) circle (2cm);
    \end{tcbclipinterior}},
  after upper={\hfill\textcolor{secondcolor!90!black}%
                {\itshape\scriptsize\normalfont\faSquare}},
  lowerbox=ignored,
  attach title to upper=\par\vspace{2pt},
  coltitle=secondcolor!90!black,
  fonttitle=\scshape\titlingspacedfont\normalsize,
  IfValueTF={#2}%
    {title={\llap{\textcolor{secondcolor}{\normalfont\faPencil\space\hskip 3pt}}#2}}%
    {title={\llap{\textcolor{secondcolor}{\normalfont\faPencil\space\hskip 3pt}}Énoncé}},
  #1
}

%-- Examination/Answer environment (same as exercise/solution environment with a different layout)
%-- Examinations are special case of exercise, only another design is applied: see examinationstyle


%---------------------------------------------------------------------------------------------------
%---- Questions/answers environments (with the 'tcolorbox' package)
%---------------------------------------------------------------------------------------------------

\tikzset{%
  show curve controls/.style={% Show Bezier points of control along the curve/path
    postaction={
      decoration={
        show path construction,
        curveto code={
          \draw [blue]
            (\tikzinputsegmentfirst) -- (\tikzinputsegmentsupporta)
            (\tikzinputsegmentlast) -- (\tikzinputsegmentsupportb);
          \fill [red, opacity=0.5]
            (\tikzinputsegmentsupporta) circle [radius=.5ex]
            (\tikzinputsegmentsupportb) circle [radius=.5ex];
        }
      },
      decorate
    }
  },
}

\tcbset{%
  %jazzbox/.style={
  %  }
  curled paper/.style={% Curled paper page, see:
    % https://tex.stackexchange.com/questions/251802/simulating-the-look-of-curled-paper
    %- Original
    %drop fuzzy shadow,
    %sharp corners, rounded corners=southeast, arc is angular, arc=9mm,
    %underlay={%
    %  \path [fill=firstcolor!80!black, draw=tcbcol@frame, shorten <=-0.05mm, shorten >=-0.05mm]
    %    ([yshift=9mm]interior.south east) .. controls +(-.25,-.25)
    %    and +(.5,-.35) ..  ++(-1.2,-.2) .. controls +(.5,-.4)
    %    and +(.1,.15) .. ([xshift=-9mm]interior.south east);
    %},
    %- Adapted i.e. reduced effect
    drop fuzzy shadow,
    sharp corners,
    rounded corners=southeast,
    arc is angular,
    arc=4mm,
    underlay={%
      \path [fill=firstcolor!80!black, draw=tcbcol@frame,
        shorten <=-0.05mm, shorten >=-0.05mm,
        %show curve controls
        ]
        ([yshift=4mm]interior.south east)
        .. controls +(-.2,-.2) and +(-.1,.1)
        .. ++(-.4,.0)
        .. controls +(.05,-.1) and +(.1,.1)
        .. ([xshift=-4mm]interior.south east);
    }
  },
  returned paper corner/.style={% Stolen to tcolorbox documentation: see "marker" environment below
    sharp corners, rounded corners=southeast, arc is angular, arc=3mm,
    underlay={%
      \path[fill=firstcolor!80!black]
        ([yshift=3mm]interior.south east) -- ++(-0.4,-0.1) -- ++(0.1,-0.2);
      \path[draw=tcbcol@frame,shorten <=-0.05mm,shorten >=-0.05mm]
        ([yshift=3mm]interior.south east) -- ++(-0.4,-0.1) -- ++(0.1,-0.2);
      %\path[fill=darkelectricblue,draw=none]
      %  (interior.south west)
      %    rectangle node[white]{\normalfont\large#1}
      %  ([xshift=4mm]interior.north west);
    },
    drop fuzzy shadow,
  },
  frontmark/.style={
    underlay={%
      \path[fill=darkelectricblue,draw=none]
        (interior.south west)
          rectangle node[white]{\normalfont\large#1}
        ([xshift=4mm]interior.north west);
    }
  },
  underlined title/.style={% For underline style, see:
    % https://tex.stackexchange.com/questions/377161/
    overlay={% Only works with top title
      \fill[left color=secondcolor, right color=white]
        (title.south west) rectangle ([yshift=-1pt]title.south east);
    },
  }
}

\newlength{\questionTitleWidth}
\settowidth{\questionTitleWidth}{Question 99}%

\newcounter{tcbquestion}[tcbexercise]% Question counter within tcbexercise
\renewcommand{\thetcbquestion}{\arabic{tcbquestion}}

\AtBeginEnvironment{questionBox}{%
  % Displaying the parnotes with no indentation and without \narrower: strange behaviour FIXME
  \renewcommand{\parnotefmt}[1]{%
    %\vskip -4pt\narrower\footnotesize\sffamily\itshape
    \vskip -6pt\footnotesize\sffamily\itshape
    \noindent\textcolor{firstcolor}{\rule{.3333\linewidth}{.4pt}}\\
    \noindent #1\par
    %\noindent\rule{\linewidth}{1pt}
  }
}
\NewTColorBox[use counter=tcbquestion]{questionBox}{ +o }{%number within=tcbexercise
  %code={},
  %label={question:\thetcbcounter},
  enhanced, breakable, parbox=false,
  sidebyside=true,
  lefthand width=\questionTitleWidth,
  sidebyside align=top seam,
  sidebyside gap=5mm,
  %sidebyside adapt=left,
  %lower separated=false,% no dashed separation line
  before skip=2mm, after skip=2mm,
  boxsep=1mm,% Default=1mm
  top = 4pt, bottom = 2pt,% default=2mm
  %left={16pt-1mm}, right={16pt-1mm},% Default=4mm; 16pt=\parindent and boxsep=1mm
  left={4pt}, right={4pt},
  oversize,
  segmentation engine = path,
  segmentation style={% Like leftbar of captions (width=1mm) or ToC
    secondcolor, solid, opacity=1, line width=1mm,
    shorten <={1mm+4pt}, shorten >={1mm+2pt},% boxsep+top and boxsep+bottom
    %shorten <=\totalLineHeight, shorten >=2pt
  },
  colframe=framecolor,
  boxrule=0.2mm,
  %bicolor, colbacklower=white,
  fonttitle=\lightboldfont,
  coltitle=black,
  detach title,
  before upper={\tcbtitle\quad},
  before upper app={\tcblower},% No upper part (just the title): question text is in lower part
  title={Question\space\thetcbcounter},
  sharp corners,
  drop fuzzy shadow,
  %returned paper corner,
  %frontmark={\faQuestion},
  %after lower={\par\parnotes},% ← Display parnotes, if any
  IfValueTF={#1}{#1}{},% More options
  code={\parnotereset}% ← parnotes reset, if any (NEEDED to have the normal layout of parnotes)
}

\AtBeginEnvironment{answerBox}{%
  % Displaying the parnotes with no indentation and without \narrower: strange behaviour FIXME
  \renewcommand{\parnotefmt}[1]{%
    %\vskip -4pt\narrower\footnotesize\sffamily\itshape
    \vskip -6pt\footnotesize\sffamily\itshape
    \noindent\textcolor{firstcolor}{\rule{.3333\linewidth}{.4pt}}\\
    \noindent #1\par
    %\noindent\rule{\linewidth}{1pt}
  }
}

\NewTColorBox[use counter=tcbquestion]{answerBox}{ +o }{%
  %code={},
  %label={answer:\thetcbcounter},
  enhanced, breakable, parbox=false,
  opacityframe=1.0, opacityback=1.0,
  %opacitybacktitle=0.5, opacitytitle=1.0,
  before skip=2mm, after skip=2mm,
  boxsep=1mm,% Default=1mm
  top = 4pt, bottom = 2pt,% default=2mm
  %left={16pt-1mm}, right={16pt-1mm},% Default=4mm; 16pt=\parindent and boxsep=1mm
  left={4pt}, right={4pt},
  oversize,
  %colback=boxbackgroundcolor,
  colframe=framecolor, boxrule=0.2mm,
  %- Initial code (doc. p. 157)
  %attach boxed title to top left={xshift=1cm,yshift*=1mm-\tcboxedtitleheight},%
  attach boxed title to top left={xshift={1mm+8pt+2mm},yshift*=1mm-\tcboxedtitleheight},
  %underlay={% Just to verify the correct left margin → xshift amount
  %  \path[fill=darkelectricblue,draw=none]
  %    (interior.south west)
  %      rectangle node[white]{\hrulefill}
  %    ([xshift={1mm+4pt}]interior.north west);
  %},
  varwidth boxed title,
  %varwidth boxed title*=-3cm,
  boxed title style={%- Initial code (doc. p. 162)
    frame code={
      \path[fill=firstcolor!30!black]
        ([yshift=-1mm,xshift=-1mm]frame.north west)
          arc[start angle=0,end angle=180,radius=1mm]
        ([yshift=-1mm,xshift=1mm]frame.north east)
          arc[start angle=180,end angle=0,radius=1mm];
      \path[left color=firstcolor!60!black, right color=firstcolor!60!black,
            middle color=firstcolor!80!black]
        ([xshift=-2mm]frame.north west)
        -- ([xshift=2mm]frame.north east)
        [rounded corners=1mm]
        -- ([xshift=1mm, yshift=-1mm]frame.north east)
        -- (frame.south east) -- (frame.south west)
        -- ([xshift=-1mm, yshift=-1mm]frame.north west)
        [sharp corners] -- cycle;
    },
    interior engine=empty,
  },
  fonttitle=\lightboldfont,
  fontlower = {\itshape},
  title={Question\space\thetcbcounter},
  sharp corners,
  drop fuzzy shadow,
  before upper={\indent},
  IfValueTF={#1}{#1}{}% More options
}

\newtcolorbox[use counter=tcbquestion]{answerBoxUp}[1][]{%
  enhanced, breakable, parbox=false,
  opacityframe=1.0, opacityback=1.0,
  %opacitybacktitle=0.5, opacitytitle=1.0,
  before skip=2mm, after skip=2mm,
  boxsep=1mm,% Default=1mm
  top = 4pt, bottom = 2pt,% default=2mm
  %left={16pt-1mm}, right={16pt-1mm},% Default=4mm; 16pt=\parindent and boxsep=1mm
  left={4pt}, right={4pt},
  oversize,
  %colback=boxbackgroundcolor,
  colframe=framecolor, boxrule=0.2mm,
  bottomrule=0pt, sharp corners=south,
  %- Initial code (doc. p. 157)
  %attach boxed title to top left={xshift=1cm,yshift*=1mm-\tcboxedtitleheight},%
  attach boxed title to top left={xshift={1mm+8pt+2mm},yshift*=1mm-\tcboxedtitleheight},
  %underlay={% Just to verify the correct left margin → xshift amount
  %  \path[fill=darkelectricblue,draw=none]
  %    (interior.south west)
  %      rectangle node[white]{\hrulefill}
  %    ([xshift={1mm+4pt}]interior.north west);
  %},
  varwidth boxed title,
  %varwidth boxed title*=-3cm,
  boxed title style={%- Initial code (doc. p. 162)
    frame code={
      \path[fill=firstcolor!30!black]
        ([yshift=-1mm,xshift=-1mm]frame.north west)
          arc[start angle=0,end angle=180,radius=1mm]
        ([yshift=-1mm,xshift=1mm]frame.north east)
          arc[start angle=180,end angle=0,radius=1mm];
      \path[left color=firstcolor!60!black, right color=firstcolor!60!black,
            middle color=firstcolor!80!black]
        ([xshift=-2mm]frame.north west)
        -- ([xshift=2mm]frame.north east)
        [rounded corners=1mm]
        -- ([xshift=1mm, yshift=-1mm]frame.north east)
        -- (frame.south east) -- (frame.south west)
        -- ([xshift=-1mm, yshift=-1mm]frame.north west)
        [sharp corners] -- cycle;
    },
    interior engine=empty,
  },
  fonttitle=\lightboldfont,
  fontlower = {\itshape},
  title={Question\space\thetcbcounter\space\footnotesize [...]},
  sharp corners,
  drop fuzzy shadow,
  before upper={\indent},
  #1
}

\newtcolorbox[use counter=tcbquestion]{answerBoxDown}[1][]{%
  code={\addtocounter{tcbquestion}{-1}},
  enhanced, breakable, parbox=false,
  opacityframe=1.0, opacityback=1.0,
  %opacitybacktitle=0.5, opacitytitle=1.0,
  before skip=2mm, after skip=2mm,
  boxsep=1mm,% Default=1mm
  top = 4pt, bottom = 2pt,% default=2mm
  %left={16pt-1mm}, right={16pt-1mm},% Default=4mm; 16pt=\parindent and boxsep=1mm
  left={4pt}, right={4pt},
  oversize,
  %colback=boxbackgroundcolor,
  colframe=framecolor, boxrule=0.2mm,
  toprule=0pt, sharp corners=north,
  %- Initial code (doc. p. 157)
  %attach boxed title to top left={xshift=1cm,yshift*=1mm-\tcboxedtitleheight},%
  attach boxed title to top left={xshift={1mm+8pt+2mm},yshift*=1mm-\tcboxedtitleheight},
  %underlay={% Just to verify the correct left margin → xshift amount
  %  \path[fill=darkelectricblue,draw=none]
  %    (interior.south west)
  %      rectangle node[white]{\hrulefill}
  %    ([xshift={1mm+4pt}]interior.north west);
  %},
  varwidth boxed title,
  %varwidth boxed title*=-3cm,
  boxed title style={%- Initial code (doc. p. 162)
    frame code={
      \path[fill=firstcolor!30!black]
        ([yshift=-1mm,xshift=-1mm]frame.north west)
          arc[start angle=0,end angle=180,radius=1mm]
        ([yshift=-1mm,xshift=1mm]frame.north east)
          arc[start angle=180,end angle=0,radius=1mm];
      \path[left color=firstcolor!60!black, right color=firstcolor!60!black,
            middle color=firstcolor!80!black]
        ([xshift=-2mm]frame.north west)
        -- ([xshift=2mm]frame.north east)
        [rounded corners=1mm]
        -- ([xshift=1mm, yshift=-1mm]frame.north east)
        -- (frame.south east) -- (frame.south west)
        -- ([xshift=-1mm, yshift=-1mm]frame.north west)
        [sharp corners] -- cycle;
    },
    interior engine=empty,
  },
  fonttitle=\lightboldfont,
  fontlower = {\itshape},
  title={Question\space\thetcbcounter\space\footnotesize (suite)},
  sharp corners,
  drop fuzzy shadow,
  before upper={\indent},
  #1
}

\newtcolorbox{commentBox}[1][]{
  enhanced,
  before skip=1mm, after skip=2mm,
  boxrule=0.4pt, left=8mm, right=2mm, top=0mm, bottom=0mm,
  %colback=yellow!50,
  colback=white,
  %colframe=yellow!20!black,
  colframe=secondcolor,
  sharp corners, rounded corners=southeast, arc is angular, arc=3mm,
  underlay={%
    \path[fill=firstcolor!80!black]
      ([yshift=3mm]interior.south east) -- ++(-0.4,-0.1) -- ++(0.1,-0.2);
    \path[draw=tcbcol@frame,shorten <=-0.05mm,shorten >=-0.05mm]
      ([yshift=3mm]interior.south east) -- ++(-0.4,-0.1) -- ++(0.1,-0.2);
    %\path[fill=yellow!50!black,draw=none]
    \path[fill=firstcolor,draw=none]
      (interior.south west)
        rectangle node[white]{\normalfont\large\faComments}
      ([xshift=6mm]interior.north west);
  },
  drop fuzzy shadow,
  fontupper=\small,
  before upper={\indent},
  #1
}

\newtcolorbox{anchorBox}[1][]{
  enhanced,
  before skip=1mm, after skip=2mm,
  boxrule=0.4pt, left=8mm, right=2mm, top=0mm, bottom=0mm,
  %colback=yellow!50,
  colback=white,
  %colframe=yellow!20!black,
  colframe=firstcolor,
  sharp corners, rounded corners=southeast, arc is angular, arc=3mm,
  underlay={%
    \path[fill=firstcolor!80!black]
      ([yshift=3mm]interior.south east) -- ++(-0.4,-0.1) -- ++(0.1,-0.2);
    \path[draw=tcbcol@frame,shorten <=-0.05mm,shorten >=-0.05mm]
      ([yshift=3mm]interior.south east) -- ++(-0.4,-0.1) -- ++(0.1,-0.2);
    %\path[fill=yellow!50!black,draw=none]
    \path[fill=secondcolor,draw=none]
      (interior.south west)
        rectangle node[white]{\normalfont\large\faAnchor}
      ([xshift=6mm]interior.north west);
  },
  drop fuzzy shadow,
  fontupper=\small,
  before upper={\indent},
  #1
}


%---------------------------------------------------------------------------------------------------
%---- Side by side boxes environments and commands (with the 'tcolorbox' package)
%---------------------------------------------------------------------------------------------------

%-- Marker/note box: stolen to Thomas F. Sturm (tcolorbox documentation)

\newtcolorbox{marker}[1][]{
  enhanced,
  before skip=2mm, after skip=3mm,
  boxrule=0.4pt, left=5mm, right=2mm, top=1mm, bottom=1mm,
  colback=yellow!50,
  colframe=yellow!20!black,
  sharp corners, rounded corners=southeast, arc is angular, arc=3mm,
  underlay={%
    \path[fill=firstcolor!80!black]
      ([yshift=3mm]interior.south east) -- ++(-0.4,-0.1) -- ++(0.1,-0.2);
    \path[draw=tcbcol@frame,shorten <=-0.05mm,shorten >=-0.05mm]
      ([yshift=3mm]interior.south east) -- ++(-0.4,-0.1) -- ++(0.1,-0.2);
    \path[fill=yellow!50!black,draw=none]
      (interior.south west)
        rectangle node[white]{\Huge\bfseries !}
      ([xshift=4mm]interior.north west);
  },
  drop fuzzy shadow,
  before upper={\indent},
  #1
}

%-- "Centerline one column like" environment

\DeclareTColorBox{centeredBox}{ +o g }{%
  blank,
  beforeafter skip=5pt,
  halign=flush center,
  lower separated=false,% no dashed separation line
  width=\linewidth,
  IfValueTF={#2}{title=\textttl{#2}, fonttitle={\color{black}\normalsize}, bottomtitle=6pt}{},
  IfValueTF={#1}{#1}{}% More options
}

%\NewTotalTCBox{\centeredBox}{O{5pt} o m}{% "centered" like command
%  blank,
%  beforeafter skip=#1,
%  halign=flush center,
%  lower separated=false,% no dashed separation line
%  attach title to upper=\par\vspace{2pt},
%  center title,
%  fonttitle={\color{black}\normalsize},
%  IfValueTF={#2}{title=\textttl{#2}}{title={}},%
%  width=\linewidth,
%  }{\centerline{#3}}

%-- "Centerline one column" like environment

\NewTColorBox{centerBox}{ O{5pt} g }{%
    blank,
    beforeafter skip=#1,
    halign=flush center,
    %lower separated=false,% no dashed separation line
    attach title to upper=\par\vspace{2pt},
    fonttitle={\color{black}\normalsize},
    IfValueTF={#2}{title=\textttl{#2}}{title={}},
}
\NewTColorBox{linedBox}{ o m }{
    blank,
    %before=\vspace*{10pt},
    before skip=10pt,
    after skip=10pt,
    halign=flush center,
    %lower separated=false,% no dashed separation line
    attach title to upper=\par\vspace{2pt},
    fonttitle={\color{black}\normalsize},
    IfValueTF={#1}%
      {title=\textttl{#1}}%
      {title={}},
    %beforeafter skip=5pt,
}
%\NewTColorBox{hlinedBoxes}{O{5pt} g m m}% +m}{% +m = \long mandatory argument
%    blank,
%    beforeafter skip=#1,
%    %sidebyside=true,
    %sidebyside align=center,
    %lefthand width=.5\linewidth,
%    center title,
%    fonttitle={\color{black}\normalsize},
%    IfValueTF={#2}{title=\textttl{#2}}{title={}},%
%}

%-- Side by side horizontal boxes command (example by cfr on TeX-SE)
%-- From http://tex.stackexchange.com/questions/291888/creating-a-multi-line-colored-box-in-latex/

\newlength\nameboxtempa
\newlength\nameboxtempb

\tcbset{%
  name box/.style={%
    colback=black,
    lower separated=false,
    coltext=white,
    fontupper=\nameboxfont,
    fontlower=\nameboxfont,
    halign=center,
    halign lower=center,
    sharpish corners,
    middle=.75mm,
  },
  two by two/.style={%
    sidebyside gap=1mm,
    boxrule=0pt,
    boxsep=0pt,
    lower separated=false,
    halign upper=left,
    halign lower=left,
    sidebyside adapt=left,
    empty,
    size=minimal,
  },
}

\NewDocumentCommand \namebox { m m +m }{%
  \settowidth\nameboxtempa{\nameboxfont #1}%
  \settowidth\nameboxtempb{\nameboxfont #2}%
  \ifdim\nameboxtempa<\nameboxtempb\setlength\nameboxtempa{\nameboxtempb}\fi%
  \tcbsidebyside[two by two]{%
    \begin{tcolorbox}[%
      name box,
      text width=\nameboxtempa,
      ]
      #1
      \tcblower
      #2
    \end{tcolorbox}%
  }{%
    #3
  }
}

%-- Side by side horizontal boxes environments and commands (with `tcolorbox' package)

%- xparse optional arguments way
\DeclareTColorBox{centeredBoxes}{ o g }{% "Two columns" like environment
  %skin=enhanced jigsaw,% "enhanced jigsaw" to have full access to transparency options
  %blank,
  %opacityframe=0.0, opacitytitle=1.0, opacitybacktitle=0.0,
  blank,% All drawing operations are hidden and all margins are set to 0pt
  %parbox=false,% No indentation, otherwise uncomment
  sidebyside=true,
  %lefthand width=0.5\linewidth,
  lefthand ratio=0.5,% Default=0.5
  %sidebyside adapt=right,% options: none (no measurment), left, right, both
  lower separated=false,% no dashed separation line
  sidebyside gap=0pt,
  sidebyside align=top seam, halign=center, halign lower=center,
  beforeafter skip=8pt,
  IfValueTF={#2}{title=\textttl{#2}, fonttitle={\color{black}\normalsize}, bottomtitle=6pt}{},
  IfValueTF={#1}{#1}{}% More options
}

\DeclareTColorBox{alignedBoxes}{ o g }{% "Two columns" like environment
  skin=enhanced jigsaw,% "enhanced jigsaw" to have full access to transparency options
  %parbox=false,% No indentation, otherwise uncomment
  boxsep=0pt, boxrule=0pt,
  left=0pt, right=0pt, top=0pt, bottom=0pt, middle=0pt,
  sidebyside=true,
  sidebyside adapt=right,% options: none (no measurment), left, right, both
  lower separated=false,% no dashed separation line
  sidebyside gap=10pt,
  sidebyside align=top seam,
  halign lower=center,
  beforeafter skip=8pt,
  %colbacktitle=framecolor!50!white,
  fonttitle={\color{black}\normalsize},
  bottomtitle=6pt,
  blank,
  opacitytitle=1.0, opacitybacktitle=0.0,
  IfValueTF={#2}{title=\textttl{#2}}{},
  IfValueTF={#1}{#1}{}% More options
}

\NewDocumentCommand{\linedBoxes}{ O{5pt} o m m }{% "two columns" like command
  \tcbsidebyside[parbox=false,% sidebyside=true,
    blank,%  No background lines, etc. but spacing
    %empty,% No background lines, etc. and no spacing
    %size=minimal,% Don't add extra spacing
    beforeafter skip=#1,
    %lefthand ratio=.475,
    %sidebyside adapt=both,
    lefthand width=.5\linewidth,
    sidebyside gap={.05\linewidth},
    sidebyside align=top seam,
    lower separated=false,% no dashed separation line
    attach title to upper=\par\vspace{2pt},
    %center title,
    valign=center,
    fonttitle={\color{black}\normalsize},
    IfValueTF={#2}{title=\textttl{#2}}{title={}},%
    ]
    {#3}{#4}
}

\NewDocumentCommand{\linedBoxesBis}{ o O{0.65} m m }{\noindent%
  %\begin{tcolorbox}[parbox=false,
  \tcbsidebyside[parbox=false,% sidebyside=true,
    blank,
    beforeafter skip=5pt,
    lefthand ratio=#2,%sidebyside adapt=both,
    sidebyside align=center seam,
    sidebyside gap={.05\linewidth},
    lower separated=false,% no dashed separation line
    attach title to upper=\par\vspace{2pt},
    fonttitle={\color{black}\normalsize},
    IfValueTF={#1}{title=\textttl{#1}}{title={}},%
    ]{#3}{#4}%
  %\end{tcolorbox}
}

%-- Simple framed box environment (for including in another box)

\newtcolorbox{inOneBox}[2][]{% optional arg = more options list
  breakable,
  parbox=false,
  opacityframe=1.0, opacityback=0.0,
  opacitybacktitle=0.0, opacitytitle=1.0,
  %colframe=framecolor, colback = boxbackgroundcolor!0,
  %colbacktitle=framecolor!50!white,% initially=black!50!white
  enhanced jigsaw,
  arc = 2pt,% outer arc = 0pt,
  boxrule = 0.6pt,
  boxsep = 2pt,% default=1mm
  left = 6pt, right = 6pt,% additional to boxsep, default=4mm
  top = 6pt, bottom = 0pt,% default=2mm
  %middle = 2pt,% additional to boxsep
  %halign=center, valign=bottom,
  %capture=hbox,% default=minipage
  %noparskip,
  beforeafter skip=2.5\parskip,
  %before={\vspace{\parskip}\llap{\textcolor{framecolor}{\faInfoCircle}~}\vspace{-\baselineskip}},
  lowerbox=ignored,
  lefttitle=16pt,
  attach boxed title to top left={xshift=16pt,yshift=-6pt},
  title={#2},
  #1
}

%\tcbset{%
%  fancy box/.style={%
%  },
%}

\NewTColorBox{fancyBox}{+o m}{%
  %code={},
  enhanced, breakable, parbox=false,
  opacityframe=1.0, opacityback=1.0,
  %opacitybacktitle=0.5, opacitytitle=1.0,
  before skip=2mm, after skip=2mm,
  top = 4pt, bottom = 2pt,% default=2mm
  boxsep=1mm,% Default=1mm
  %left={16pt-1mm}, right={16pt-1mm},% Default=4mm; 16pt=\parindent and boxsep=1mm
  left={4pt}, right={4pt},
  oversize,
  %colback=boxbackgroundcolor,
  colframe=framecolor, boxrule=0.2mm,
  %- Initial code (doc. p. 157)
  %attach boxed title to top left={xshift=1cm,yshift*=1mm-\tcboxedtitleheight},%
  attach boxed title to top left={xshift={1mm+8pt+2mm},yshift*=1mm-\tcboxedtitleheight},
  %underlay={% Just to verify the correct left margin → xshift amount
  %  \path[fill=darkelectricblue,draw=none]
  %    (interior.south west)
  %      rectangle node[white]{\hrulefill}
  %    ([xshift={1mm+4pt}]interior.north west);
  %},
  varwidth boxed title,
  %varwidth boxed title*=-3cm,
  boxed title style={%- Initial code (doc. p. 162)
    frame code={
      \path[fill=firstcolor!30!black]
        ([yshift=-1mm,xshift=-1mm]frame.north west)
          arc[start angle=0,end angle=180,radius=1mm]
        ([yshift=-1mm,xshift=1mm]frame.north east)
          arc[start angle=180,end angle=0,radius=1mm];
      \path[left color=firstcolor!60!black, right color=firstcolor!60!black,
            middle color=firstcolor!80!black]
        ([xshift=-2mm]frame.north west)
        -- ([xshift=2mm]frame.north east)
        [rounded corners=1mm]
        -- ([xshift=1mm, yshift=-1mm]frame.north east)
        -- (frame.south east) -- (frame.south west)
        -- ([xshift=-1mm, yshift=-1mm]frame.north west)
        [sharp corners] -- cycle;
    },
    interior engine=empty,
  },
  %segmentation engine = path,
  %segmentation style={secondcolor,solid,opacity=0.2,line width=2pt},
  fonttitle=\lightboldfont,
  fontlower = {\itshape},
  sharp corners,
  drop fuzzy shadow,
  before upper={\indent},%{\smallskip}
  title={#2},
  IfValueTF={#1}{#1}{}% More options
}

\newtcolorbox{fancyBoxUp}[2][]{%
  enhanced, breakable, parbox=false,
  opacityframe=1.0, opacityback=1.0,
  %opacitybacktitle=0.5, opacitytitle=1.0,
  before skip=2mm, after skip=2mm,
  top = 4pt, bottom = 2pt,% default=2mm
  boxsep=1mm,% Default=1mm
  left={4pt}, right={4pt},
  oversize,
  %colback=boxbackgroundcolor,
  colframe=framecolor, boxrule=0.2mm,
  bottomrule=0pt, sharp corners=south,
  %- Initial code (doc. p. 157)
  %attach boxed title to top left={xshift=1cm,yshift*=1mm-\tcboxedtitleheight},%
  attach boxed title to top left={xshift={1mm+8pt+2mm},yshift*=1mm-\tcboxedtitleheight},
  %attach boxed title to top left={xshift=1cm,yshift*=1mm-\tcboxedtitleheight},
  varwidth boxed title,
  %varwidth boxed title*=-3cm,
  boxed title style={frame code={
    \path[fill=firstcolor!30!black]
      ([yshift=-1mm,xshift=-1mm]frame.north west)
        arc[start angle=0,end angle=180,radius=1mm]
      ([yshift=-1mm,xshift=1mm]frame.north east)
        arc[start angle=180,end angle=0,radius=1mm];
    \path[left color=firstcolor!60!black,right color=firstcolor!60!black,
      middle color=firstcolor!80!black]
      ([xshift=-2mm]frame.north west) -- ([xshift=2mm]frame.north east)
      [rounded corners=1mm]-- ([xshift=1mm,yshift=-1mm]frame.north east)
      -- (frame.south east) -- (frame.south west)
      -- ([xshift=-1mm,yshift=-1mm]frame.north west)
      [sharp corners]-- cycle;
    },interior engine=empty,
  },
  fonttitle=\lightboldfont,
  fontlower = {\itshape},
  sharp corners,
  drop fuzzy shadow,
  before upper={\indent},
  title={#2},%
  #1
}

\newtcolorbox{fancyBoxDown}[2][]{%
  enhanced, breakable, parbox=false,
  opacityframe=1.0, opacityback=1.0,
  %opacitybacktitle=0.5, opacitytitle=1.0,
  before skip=2mm, after skip=2mm,
  top = 4pt, bottom = 2pt,% default=2mm
  boxsep=1mm,% Default=1mm
  left={4pt}, right={4pt},
  oversize,
  %colback=boxbackgroundcolor,
  colframe=framecolor, boxrule=0.2mm,
  toprule=0pt, sharp corners=north,
  %- Initial code (doc. p. 157)
  %attach boxed title to top left={xshift=1cm,yshift*=1mm-\tcboxedtitleheight},%
  attach boxed title to top left={xshift={1mm+8pt+2mm},yshift*=1mm-\tcboxedtitleheight},
  %attach boxed title to top left={xshift=1cm,yshift*=1mm-\tcboxedtitleheight},
  varwidth boxed title,
  %varwidth boxed title*=-3cm,
  boxed title style={frame code={
    \path[fill=firstcolor!30!black]
      ([yshift=-1mm,xshift=-1mm]frame.north west)
        arc[start angle=0,end angle=180,radius=1mm]
      ([yshift=-1mm,xshift=1mm]frame.north east)
        arc[start angle=180,end angle=0,radius=1mm];
    \path[left color=firstcolor!60!black,right color=firstcolor!60!black,
      middle color=firstcolor!80!black]
      ([xshift=-2mm]frame.north west) -- ([xshift=2mm]frame.north east)
      [rounded corners=1mm]-- ([xshift=1mm,yshift=-1mm]frame.north east)
      -- (frame.south east) -- (frame.south west)
      -- ([xshift=-1mm,yshift=-1mm]frame.north west)
      [sharp corners]-- cycle;
    },interior engine=empty,
  },
  fonttitle=\lightboldfont,
  fontlower = {\itshape},
  sharp corners,
  drop fuzzy shadow,
  before upper={\indent},
  title={#2},%
  #1
}


%---------------------------------------------------------------------------------------------------
%---- Other TikZ/tcolorbox particular environments
%---------------------------------------------------------------------------------------------------

%-- Side-margin element with coloured background
%\newcommand{\captionlayout}{%
%  \raisebox{-.25\baselineskip}{\tikz\fill[secondcolor] (0,0) rectangle (1mm, \baselineskip);}%
%}
\NewDocumentCommand{\sideStuff}{ o m }{%
  \marginelement{% optional#2=title, mandatory#3=text TODO: optional margin symbol
    \begin{tcolorbox}[
      %enhanced jigsaw,
      %skin=enhancedmiddle jigsaw,% setting middle to have textmark (cf. doc. pp. 204-207)
      %marker,
      %width=.95\linewidth,
      %breakable,
      %parbox=false,
      %colframe=firstcolor,
      colback = black!10,
      colbacktitle=black!10,% initially=black!50!white
      arc = 0pt, outer arc = 0pt,
      leftrule = 0pt, rightrule = 0pt,
      bottomrule = 0pt, toprule=0pt, boxrule = 0pt, boxsep = 0pt,% default=1mm
      left = 8pt, right = 8pt,% additional to boxsep, default=4mm
      top = 6pt, bottom = 6pt,% default=2mm
      toptitle = 6pt, bottomtitle = 0pt,
      %middle = 2pt,% additional to boxsep
      %halign=center, valign=bottom,
      %capture=hbox,% default=minipage
      %noparskip,
      %beforeafter skip=2.5\parskip,
      %before={\llap{\textcolor{\@titlingcolor}{\faExclamationTriangle}~}\vspace{-\baselineskip}},
      %before={\hspace*{.025\linewidth}},
      %\IfValueTF{#1}{\def\sideSymbol#1}{\def\sideSymbol\relax}%
      %  \IfValueTF{#2}%
      %  {title={\textcolor{secondcolor}{%
      %         \llap{\textcolor{firstcolor}{\normalsize\sideSymbol}\space\hskip 10pt}%
      %         \spacedlowsmallcaps{\sideTitle{#2}}\\[-.5\baselineskip]\rule{\linewidth}{1pt}}}%
      %  {title={}},
      ]
      %\vspace{-.5\baselineskip}%
      %\hypersetup{linkcolor=secondcolor}% please take care of the hyperref default set-up
      %\textcolor{secondcolor}{\hfill\rule{\linewidth}{1pt}}\newline%
      %\vspace{-.5\baselineskip}%
      #2%
    \end{tcolorbox}%
  }
}

\NewDocumentCommand{\sideQuestion}{ o m }{% optional#1=title, mandatory#2=text
  \marginelement{%
    \begin{tcolorbox}[
      %enhanced jigsaw,
      %skin=enhancedmiddle jigsaw,% setting middle to have textmark (cf. doc. pp. 204-207)
      %marker,
      %width=.95\linewidth,
      %breakable,
      %parbox=false,
      %colframe=firstcolor,
      colback = black!10,
      colbacktitle=black!10,% initially=black!50!white
      arc = 0pt, outer arc = 0pt,
      leftrule = 0pt, rightrule = 0pt,
      bottomrule = 0pt, toprule=0pt, boxrule = 0pt, boxsep = 0pt,% default=1mm
      left = 8pt, right = 8pt,% additional to boxsep, default=4mm
      top = 6pt, bottom = 6pt,% default=2mm
      toptitle = 6pt, bottomtitle = 0pt,
      %middle = 2pt,% additional to boxsep
      %halign=center, valign=bottom,
      %capture=hbox,% default=minipage
      %noparskip,
      %beforeafter skip=2.5\parskip,
      %before={\llap{\textcolor{\@titlingcolor}{\faExclamationTriangle}~}\vspace{-\baselineskip}},
      %before={\hspace*{.025\linewidth}},
      title={\textcolor{secondcolor}{%
            \llap{\textcolor{firstcolor}{\normalsize\faQuestionCircle}\space\hskip 10pt}%
            \spacedlowsmallcaps{\sideTitle{#1}}%
            \\[-.5\baselineskip]\rule{\linewidth}{1pt}}%
            },
      ]
      #2%
    \end{tcolorbox}%
  }
}
\NewDocumentCommand{\sideEye}{ o m }{% optional#1=title, mandatory#2=text
  \marginelement{%
    \begin{tcolorbox}[
      %enhanced jigsaw,
      %skin=enhancedmiddle jigsaw,% setting middle to have textmark (cf. doc. pp. 204-207)
      %marker,
      %width=.95\linewidth,
      %breakable,
      %parbox=false,
      %colframe=firstcolor,
      colback = black!10,
      colbacktitle=black!10,% initially=black!50!white
      arc = 0pt, outer arc = 0pt,
      leftrule = 0pt, rightrule = 0pt,
      bottomrule = 0pt, toprule=0pt, boxrule = 0pt, boxsep = 0pt,% default=1mm
      left = 8pt, right = 8pt,% additional to boxsep, default=4mm
      top = 6pt, bottom = 6pt,% default=2mm
      toptitle = 6pt, bottomtitle = 0pt,
      %middle = 2pt,% additional to boxsep
      %halign=center, valign=bottom,
      %capture=hbox,% default=minipage
      %noparskip,
      %beforeafter skip=2.5\parskip,
      %before={\llap{\textcolor{\@titlingcolor}{\faExclamationTriangle}~}\vspace{-\baselineskip}},
      %before={\hspace*{.025\linewidth}},
      title={\textcolor{secondcolor}{%
            \llap{\textcolor{firstcolor}{\normalsize\faEye}\space\hskip 10pt}%
            \spacedlowsmallcaps{\sideTitle{#1}}%
            \\[-.5\baselineskip]\rule{\linewidth}{1pt}}%
            },
      ]
      #2%
    \end{tcolorbox}%
  }
}


%---------------------------------------------------------------------------------------------------
%---- Additional or casual utilities / Utilitaires complémentaires ou occasionnels
%---------------------------------------------------------------------------------------------------

%-- Multicolumn management
%-------------------------

%--- Explanations about the multicol package balancing system and solutions
%--------------------------------------------------------------------------
%- multicol-column-balancing-only-after-a-minimum-number-of-lines:
%- https://tex.stackexchange.com/questions/241094
%- multicol-unpredictable-column-placement-of-items:
%- https://tex.stackexchange.com/questions/358130/
%-----

\RequirePackage{multicol}

%- Controling the balancing of columns with a minimum of lines (Franck Mittelbach)
%- Usage: \setcounter{multicolminlines}{3} before the multicols environment
\newcounter{multicolminlines}
\setcounter{multicolminlines}{1}

\xpatchcmd\balance@columns
   {\ifnum\dimen@<\topskip
     \mult@info\@ne
       {Start value
          \the\dimen@  \space ->
          \the\topskip \space (corrected)}%
     \dimen@\topskip
   \fi}
   {\skip@\c@multicolminlines\baselineskip
   \advance\skip@-\baselineskip
   \advance\skip@\topskip
   \ifnum\dimen@<\skip@
     \mult@info\@ne
       {Start value
          \the\dimen@  \space ->
          \the\skip@ \space (corrected)}%
     \dimen@\skip@
   \fi
   }
   {\typeout{Success!}}{\patchFAILED}

%\setcounter{unbalance}{2}% See: https://tex.stackexchange.com/questions/358130
%\setcounter{columnbadness}{9999}% See: https://tex.stackexchange.com/questions/358130

%- Default values:  \premulticols = 50pt ; \postmulticols= 20pt
%-                  \multicolsep = 12pt plus 4pt minus 3pt ; \multicolbaselineskip=0pt

%\setlength{\columnseprule}{0.25pt}
\setlength{\premulticols}{0pt}% espace verticale disponible avant l'environnement `multicols'
\setlength{\postmulticols}{0pt}% espace verticale disponible après l'environnement `multicols'
\setlength{\multicolsep}{0pt}% espace verticale minimale autour de l'env. `multicols' -> pagebreak
\setlength{\multicolbaselineskip}{0pt}
\setlength{\multicolbaselineskip}{0pt}
\setlength{\columnsep}{18pt}% not specific to "multicol.sty"

%-- Multirow management
%----------------------

%- Usage: \multirow[<vposi>]{<nrows>}[<bigstruts>]{<width>}[<vmove>]{<text>}

\RequirePackage{multirow}

%-- Controling the width of the columns and margins: useful for two sided layout

%\RequirePackage{adjmulticol}% extension of the "multicol.sty" adjusting margins in twosided doc.

%-- Variable-width multiple text columns: ONLY for single page text

%\RequirePackage{vwcol}%

%-- External PDF files inclusion
%-------------------------------

\RequirePackage{pdfpages}

%-- Needspace: prevents pagebreak - Usage: \needspace{5\baselineskip}
%--------------------------------------------------------------------

%\RequirePackage{needspace}
%- Other solution (Ulrike Fischer)
%- cf. http://tex.stackexchange.com/questions/7230/
\def\mynobreakpar{\par\nobreak\@afterheading}% -> efficient solution!
\def\mynobreakline{\par\nobreak\vspace{-\parskip}\@afterheading\noindent}

%-- Positioning and adjusting boxes
%----------------------------------

%\RequirePackage{adjustbox}

%-----
%- To have two minipages side by side and top aligned, an hack is to insert \vspace{Opt}
%- at the top of each minipage:
%- http://tex.stackexchange.com/questions/11630/aligning-image-and-text-on-top-with-minipages
%- http://tex.stackexchange.com/questions/34166/understanding-minipages-aligning-at-top/34172#34172
%---

%-- TikZ gadgets (TODO: put that stuff elsewhere)
%---------------

%-- Points some piece of text for comment add-ons
%- Borrowed from: http://tex.stackexchange.com/questions/38805/simple-speech-bubbles-arrows-or-balloon
%- Usage: \speechthis{my text}{my comment}
%- Needs tikz libraries: shape.callouts, decorations.text
%\newcommand{\speechthis}[2]{% #1 is the text that is pointed, #2 the comment
%                            % #3 x-coordinate, #4 y-coordinate
%  \tikz[remember picture,baseline]{
%    \node[anchor=base, inner sep=0, outer sep=0] (#1) {#1};
%    \node[overlay, ellipse callout, fill=blue!50] at ($(#1.north)+(-.5cm,1.8cm)$)
%    {\footnotesize\begin{minipage}{.75\marginparwidth}#2\end{minipage}};
%  }%
%}%
\NewDocumentCommand{\speechthis}{ m m O{4cm} O{1.5cm} O{black} O{east}}{%
  % #1 is the text that is pointed, #2 the comment #3 x-coordinate, #4 y-coordinate, #5 text color
  \tikz[remember picture, baseline]{
    \node[anchor=base, inner sep=0pt, outer sep=0pt, text=#5] (#1) {#1};
    \node[overlay, ellipse callout, text=black, text width=3.7cm, align=center,
          font=\normalfont\footnotesize,
          fill=firstcolor!25!white,% opacity=.5,
          callout absolute pointer={(#1.#6)}]
      at ($(#1.north)+(#3,#4)$) {#2};
      %at ($(#1.north)+(#3,#4)$) {\begin{varwidth}{3.7cm}#2\end{varwidth}};
  }%
}%

\newcommand{\bubblethis}[2]{
  \tikz[remember picture,baseline]{\node[anchor=base,inner sep=0pt,outer sep=0pt]%
    (#1) {#1};\node[overlay,cloud callout,callout relative pointer={(0.2cm,-0.7cm)},%
    aspect=2.5,fill=yellow!90] at ($(#1.north)+(-0.5cm,1.6cm)$) {#2};
  }%
}%


%---------------------------------------------------------------------------------------------------
%---- Sectioning and titling
%---------------------------------------------------------------------------------------------------

%-- Powerful tool redefining LaTeX sectionning commands (rather difficult code to understand)
%- option: loading `titleps' for header and footer (see next §)
\RequirePackage[pagestyles,newparttoc]{titlesec}

%--- Package options and explanations:
%- pagestyles: load `titleps' for header and footer (see next § below)
%- newparttoc/oldparttoc (from doc.): Standard parts write the toc entry number in a non standard
%-    way. You may change that with newparttoc so that titletoc or a similar package can manipulate
%-    the entry. (That works only if \part has been redeﬁned.). See part definition below.
%-    This implies that \numberline for parts in the ToC is similar to the other sectioning
%-    commands. Besides, due to `polyglossia/gloss-french' package interferences (see below),
%-    the access to the part counter (\thepart or \c@part values) in the ToC MUST be done with the
%-    \thecontentslabel command from the `titletoc' package (see \parttoclayout definition below).
%---

%--- Sectioning definitions
%--------------------------
%- egreg advice on TeX.SE: don't use the explicit option, but define a new command with one
%- variable as the sectioning title (#1) and include all the formating macros (and others)
%- in this command. Then, call it at the rigth place, i.e. in the <before-code> group.
%---
%- Usage of the `titlesec' package syntax:
%- \titleformat{<levelsect>}[<option>]
%- {<shape>}{<format>}{<label>}{<sep>}{<before-code>#1}[<after-code-ifany>]
%-
%- Options: hang (default), block, display, runing, leftmargin, rightmargin, drop, wrap, frame
%-    The star option kills the indentation after sectioning command
%-    Parts with automatic labelling (for etoc localtableofcontents display option: TODO)
%---

%--- TODO TODO TODO
%- Modifying titlesec commands to have \section[toc entry]{title}[header entry]
%- 1. separate-sectioning-titles-for-main-text-headings-and-toc-for-line-breaking-purposes
%- http://tex.stackexchange.com/questions/150561/
%- 2. how-to-set-rightmark-after-section-command
%- http://tex.stackexchange.com/questions/42981/
%-- Modifying titlesec sectioning default commands to have more options
%- From: http://tex.stackexchange.com/questions/150561/
%- The argument R[]{} is a required argument delimited by [..] with an empty {} default;
%- O{} would work just as well here. However, the inclusion of o now allows us to use either
%- of the following usages: DOESN'T WORK FOR CHAPTERS
%- 1. \section[<header>][<ToC>]{<title>}
%- 2. \section[<header>]{<ToC-and-title>}
%- 3. \section{<header-ToC-and-title>}
%\RenewDocumentCommand{\ttl@straight@i}{m R[]{} o m}{%
%  \def\@currentlabelname{#2}% for nameref
%  \gdef\ttl@savemark{\csname#1mark\endcsname{#4}}%
%  \let\ttl@savewrite\@empty
%  \IfNoValueTF{#3}
%    {\def\ttl@savetitle{#4}}% Optional #3 argument NOT supplied
%    {\def\ttl@savetitle{#3}}% Optional #3 argument supplied
%  \gdef\thetitle{\csname the#1\endcsname}%
%  \if@noskipsec \leavevmode \fi
%  \par
%  \ttl@labelling{#1}{#2}%
%  \ttl@startargs\ttl@straight@ii{#1}{#4}}
%-- Adding current section title to sectionning commands
%- From http://tex.stackexchange.com/questions/35684/current-section-title-macro-using-titlesec
%\apptocmd{\ttl@straight@i}{\global\let\currtitle\ttl@savetitle}{}{}% (sub)sections
%\pretocmd{\@part}{\gdef\currtitle{#1}}{}{}% parts
%\pretocmd{\@spart}{\gdef\currtitle{#1}}{}{}% sparts
%- If not going to hide titles in groups:
%\newcommand{\currentTitle}{\ttl@savetitle}
%--- TODO TODO TODO

%--- Remove extra spacing above sectionning command at a page start with the `titlesec' package
%----------------------------------------------------------------------------------------------
%- From: http://tex.stackexchange.com/questions/79232/remove-spacing-above-section-in-titlesec
%- and: http://tex.stackexchange.com/questions/358235/space-at-the-start-of-page-on-new-section
%--- Explanations
%- The package `titlesec' adds \strut in some places. As this is a zero-width rule rather
%- than a vertical space, it isn't dropped at a page break. The package ought to use a special
%- version of \strut that is not expanded by the baselinestretch, that way it gives consistent
%- spacing if accented or other large letters are used, without giving this bad spacing if
%- baseline is stretched.
%- E. Gregorio: (delete \strut but not replace it with a correct one, see D. Carlisle solution)
%\patchcmd{\ttl@select}{\strut}{}{}{}% One \strut in the macro
%\patchcmd{\ttlh@hang}{\strut}{}{}{}% First \strut of the macro
%\patchcmd{\ttlh@hang}{\strut}{}{}{}% Second \strut of the macro
%\patchcmd{\ttl@runing}{\strut}{}{}{}% One \strut in the macro
%\patchcmd{\ttlh@display}{\strut}{}{}{}% First \strut of the macro
%\patchcmd{\ttlh@display}{\strut}{}{}{}% Second \strut of the macro
%- D. Carlisle solution (just for hang sections) TODO: generalize!
%- Remark: For the time being, we mainly use the hang option for (sub)sections
%- and the runing option for (sub)paragraphs. So, it should be sufficient.
%\input{texjazz-ttlstrut}

%- Numbering typesetting / Composition de la numérotation (à modifier selon convenances)
\renewcommand{\thepart}{\Roman{part}}% default is Roman
\ifdoc@article\else
  \renewcommand{\thechapter}{\arabic{chapter}}
\fi
\renewcommand{\thesection}{\arabic{section}}
\renewcommand{\thesubsection}{\thesection.\arabic{subsection}}
\renewcommand{\thesubsubsection}{\thesubsection.\arabic{subsubsection}}
\renewcommand{\theparagraph}{\roman{paragraph}}
\renewcommand{\thesubparagraph}{\alph{subparagraph}}

%-- Initialize chapter headings (vertical spaces)
%---
%- The `titlesec' packages continues to use the default \@makechapterhead macro for typesetting
%- the chapter title when the chapter style is display. It adds 50pt above and 40pt below.
%---
%- Traditional LaTeX way to reset the chapter vertical spaces
%- See: http://tex.stackexchange.com/questions/63390/how-to-decrease-spacing-before-chapter-title/
%\def\@makechapterhead#1{%
%  %%%%\vspace*{50\p@}% %%% removed!
%  {\parindent \z@ \raggedright \normalfont
%    \ifnum \c@secnumdepth >\m@ne
%      \huge\bfseries \@chapapp\space \thechapter
%      \par\nobreak
%      \vskip 20\p@
%    \fi
%    \interlinepenalty\@M
%    \Huge \bfseries #1\par\nobreak
%    \vskip 40\p@
%  }}
%\def\@makeschapterhead#1{%
%  %%%%%\vspace*{50\p@}% %%% removed!
%  {\parindent \z@ \raggedright
%    \normalfont
%    \interlinepenalty\@M
%    \Huge \bfseries  #1\par\nobreak
%    \vskip 40\p@
%  }}
%- New way with the internals of the `titlesec' package: IT WORKS! THAT'S IT!
%- From http://tex.stackexchange.com/questions/17299/removing-vertical-space-before-chapter-headings/

%- Chapter layout initializing with the `titlesec' macro (Remove default 50pt vertical shift)
\def\ttl@mkchap@i#1#2#3#4#5#6#7{%
  \ttl@assign\@tempskipa#3\relax\beforetitleunit
  \vspace{\@tempskipa}%<<<<<< REMOVE THE * AFTER \vspace: this is the KEY POINT!
  \global\@afterindenttrue
  \ifcase#5 \global\@afterindentfalse\fi
  \ttl@assign\@tempskipb#4\relax\aftertitleunit
  \ttl@topmode{\@tempskipb}{%
    \ttl@select{#6}{#1}{#2}{#7}}%
  \ttl@finmarks  % Outside the box!
  \@ifundefined{ttlp@#6}{}{\ttlp@write{#6}}
}

%--- The problem seems to come from \titlespacing stretchable/glue at start page
%--- because we use a larger font for labels: THAT'S IT!
%http://tex.stackexchange.com/questions/19200/titlesec-remove-space-after-empty-margin-section
%http://tex.stackexchange.com/questions/91443/how-can-i-make-titlespacing-not-omit-the-top-spacing
%http://tex.stackexchange.com/questions/148738/titlesec-problem-defining-space-before-section-with-titlespacing

%-- Sectionning layouts
%----------------------
%- This approach comes from the use of the implicit option of the `titlesec' package AND also to
%- record a second ToC into the file jobname.tdm (tdm stands for "table des matières" in French).
%- This second ToC is necessary to be able to have different layouts for the main and partial ToCs.
%---

%- Layout lengths (transitional help)
\newlength{\secLabelWidth}% adjusting label width / horizontal space
\newlength{\secLabelHeigth}% adjusting label heigth / vertical space
\newlength{\secLabelDepth}% adjusting label depth / vertical space
\newlength{\secLabelGap}
\newlength{\secTitleHeigth}
\newlength{\secTitleDepth}
\newlength{\secLabelSep}
\setlength{\secLabelSep}{\parindent}
\newlength{\chapterHeaderHeigth}
\setlength{\chapterHeaderHeigth}{9.5cm}

%- Utilities
\newcommand{\noHyphen}{\hyphenpenalty10000\exhyphenpenalty10000\righthyphenmin62\lefthyphenmin62}

%https://tex.stackexchange.com/questions/117222/
%(issue-with-titlesec-page-styles-and-appendix-in-book-class)
%\newtitlemark{\chaptertitlename}

%- Take care that `polyglossia/gloss-french.ldf' package sets \partname to empty: \def\partname{}
\newcommand*{\jazzpartname}{partie}

%- Parts: adding new counter 'jazzpart' to have "Deuxième vs Seconde" for ToC/TdM parts (see below)
\newtotcounter{jazzpart}% To select 'Deuxième' if max part > 2 or 'Seconde' if max part = 2

%- Modifying ordinal numbering to better fit French convention:
%- if only two parts -> 'Seconde partie' instead of 'Deuxième partie'
\newcommand{\frenchtextnumberpart}[1]{% #1 = jazzpart counter (féminin : partie)
  \ifcase\value{#1}\or Première\or
    \ifnum\totvalue{jazzpart} > 2 Deuxième\else Seconde\fi\or
    Troisième\or Quatrième\or Cinquième\or Sixième\or
    Septième\or Huitième\or Neuvième\or Dixième\or Onzième\or
    Douzième\or Treizième\or Quatorzième\or Quinzième\or
    Seizième\or Dix-septième\or Dix-huitième\or Dix-neuvième\or Vingtième
  \fi%\space
}

%---
%- Below the following macros are coming from the `geometry' package:
%- `\Gm@lmargin}' `\Gm@rmargin}' `\Gm@tmargin}' `\Gm@bmargin}'
%- For the record, to verify and display lengths one can use:
%- a. \the\dimexpr\hoffset+\oddsidemargin\relax (\dimexpr is an eTeX macro)
%- b. \the\chapterHeaderHeigth
%---
%- Numbered part layout
\newcommand{\numberedPartLayout}[1]{%
  \begin{tikzpicture}[remember picture, overlay]
    %- Main page background rectangle
    \fill[maincolor, fill opacity=1] (current page.north west) rectangle (current page.south east);
    %- Bottom header rectangle
    \fill[maincolor, fill opacity=1] (current page.south west) rectangle
      ([yshift=\footskip]current page.south east);
    %- Separation lines
    \node[inner sep=0pt, anchor=north west] at
      ([yshift=-\chapterHeaderHeigth]current page.north west)
        {\color{firstcolor}\rule{\paperwidth}{.6mm}};
    \node[inner sep=0pt, anchor=north west] at
      ([yshift=-\Gm@tmargin]current page.north west)
        {\color{firstcolor}\rule{\paperwidth}{.6mm}};
    \node[inner sep=0pt, anchor=south west] at
      ([yshift=\footskip]current page.south west)
        {\color{firstcolor}\rule{\paperwidth}{.6mm}};
    %- Part title
    %\node[inner sep=0pt, anchor=east, font=\fontsize{50pt}{60pt}\selectfont\titlefont]
    %  (title) at ([yshift=-.4\chapterHeaderHeigth]current page marginpar area.north east)
    %  {\begin{varwidth}{\entirewidth}\FlushRight\noHyphen\textcolor{secondcolor}{#1}\end{varwidth}};
    %\pagebookmark[level=-1]{part:\thepart}{Coucou ! Partie : \thepart}%
    \node[inner sep=0pt, anchor=east, font=\fontsize{50pt}{60pt}\selectfont\titlefont]
      (title) at ([yshift=-.4\chapterHeaderHeigth]current page marginpar area.north east) {%
        \noHyphen\textcolor{secondcolor}{#1}%
      };
    %\pagebookmark[level=-1]{part:\thepart}{Coucou ! Partie : \thepart}
    %- Part label and numbering - Take care that French Polyglossia sets \partname to empty!!!
    \node[inner sep=0pt, anchor=north east] (label) at
      ([yshift=-10pt]current page marginpar area.north east)
        %- Display "Seconde partie" in French if only two parts (jazzpart counter is total)
        {\normalfont\huge\textcolor{white}{\textsc{\frenchtextnumberpart{part} \jazzpartname}}};%
    \node[anchor=west] at
      ([xshift=-1.05\entirewidth,yshift=-.4\chapterHeaderHeigth]current page marginpar area.north east)
        %{\color{firstcolor}\fontsize{150}{180}\sffamily\bfseries\@Roman\c@part};% A little bit too big
        %{\color{firstcolor}\fontsize{130}{144}\sffamily\bfseries\@Roman\c@part};% Still too big in some cases
        %{\color{firstcolor}\fontsize{110}{132}\sffamily\bfseries\@Roman\c@part};
        {\color{firstcolor}\fontsize{100}{120}\sffamily\bfseries\@Roman\c@part};
    %- Partial part ToC: only chapters and sections
    \node[anchor=south east] at
      ([xshift=0.0\entirewidth,yshift=-0pt]current page marginpar area.south east)
        %{\parbox[b][][b]{\entirewidth}{% \parbox or minipage MUST BE used
        %  \hypersetup{linkcolor=white}
        %  \color{firstcolor}\printcontents[parts]{p}{0}{\setcounter{tocdepth}{1}}}};
        {\hypersetup{linkcolor=white}
         \begin{minipage}{.6\entirewidth}%
           \color{firstcolor}\printcontents[parts]{p}{0}{\setcounter{tocdepth}{0}}%
           %\par\Large Partie : \thepart \qquad Jazzpart : \thejazzpart% Test
         \end{minipage}
        };
    %- Book title in footer
    \node[inner sep=0pt, anchor=south] at ([yshift=.5\footskip]current page.south)
        {\small\color{secondcolor}
          \spacedsmallcaps{\@doctitle}
          \ifdefempty{\@doctitle}{}{\ifdefempty{\@subtitle}{}{ \textemdash{} }}\textsc{\@subtitle}
          \ifdoc@licence% adding licence information if needed
            \ifdefempty{\@copyrightname}{}{\quad\@copyrightsymbol\ }\@copyrightname
            \ifdefempty{\@versiondate}{}{ \textendash{} }\@versiondate
            \ifdefempty{\@docversion}{}{\ifdefempty{\@versiondate}{ \textendash{} }{, }}\@docversion
          \fi};%
  \end{tikzpicture}
}
%- Unumbered part layout
\newcommand{\numberlessPartLayout}[1]{%
  \begin{tikzpicture}[remember picture, overlay]
    %- Main page background rectangle
    \fill[maincolor, fill opacity=1] (current page.north west) rectangle (current page.south east);
    %- Bottom header rectangle
    \fill[maincolor, fill opacity=1] (current page.south west) rectangle
      ([yshift=\footskip]current page.south east);
    %- Separation lines
    \node[inner sep=0pt, anchor=north west] at
      ([yshift=-\chapterHeaderHeigth]current page.north west)
        {\color{firstcolor}\rule{\paperwidth}{.6mm}};
    \node[inner sep=0pt, anchor=north west] at
      ([yshift=-\Gm@tmargin]current page.north west)
        {\color{firstcolor}\rule{\paperwidth}{.6mm}};
    \node[inner sep=0pt, anchor=south west] at
      ([yshift=\footskip]current page.south west)
        {\color{firstcolor}\rule{\paperwidth}{.6mm}};
    %- Part title
    %\node[inner sep=0pt, anchor=east, font=\fontsize{50pt}{60pt}\selectfont\titlefont]
    %  (title) at ([yshift=-.4\chapterHeaderHeigth]current page marginpar area.north east)
    %  {\begin{varwidth}{\entirewidth}\FlushRight\noHyphen\textcolor{secondcolor}{#1}\end{varwidth}};
    \node[inner sep=0pt, anchor=east, font=\fontsize{50pt}{60pt}\selectfont\titlefont]
      (title) at ([yshift=-.4\chapterHeaderHeigth]current page marginpar area.north east)
      {\noHyphen\textcolor{secondcolor}{#1}};
    %- Book title in footer
    \node[inner sep=0pt, anchor=south] at ([yshift=.5\footskip]current page.south)
        {\small\color{secondcolor}
          \spacedsmallcaps{\@doctitle}
          \ifdefempty{\@doctitle}{}{\ifdefempty{\@subtitle}{}{ \textemdash{} }}\textsc{\@subtitle}
          \ifdoc@licence% adding licence information if needed
            \ifdefempty{\@copyrightname}{}{\quad\@copyrightsymbol\ }\@copyrightname
            \ifdefempty{\@versiondate}{}{ \textendash{} }\@versiondate
            \ifdefempty{\@docversion}{}{\ifdefempty{\@versiondate}{ \textendash{} }{, }}\@docversion
          \fi};%
  \end{tikzpicture}
}
%- Numbered chapter layout
\newcommand{\numberedChapterLayout}[1]{%
  \begin{tikzpicture}[remember picture, overlay]
    %- Main header rectangle
    \fill[maincolor, fill opacity=1]
      ([yshift=-\Gm@tmargin]current page.north west) rectangle
      ([yshift=-\chapterHeaderHeigth]current page.north east);
    %- Bottom header rectangle
    \fill[maincolor, fill opacity=1] (current page.south west) rectangle
      ([yshift=\footskip]current page.south east);
    %- Separation lines
    \node[inner sep=0pt, anchor=north west] at
      ([yshift=-\chapterHeaderHeigth]current page.north west)
        {\color{firstcolor}\rule{\paperwidth}{.6mm}};
    \node[inner sep=0pt, anchor=north west] at
      ([yshift=-\Gm@tmargin]current page.north west)
        {\color{firstcolor}\rule{\paperwidth}{.6mm}};
    \node[inner sep=0pt, anchor=south west] at
      ([yshift=\footskip]current page.south west)
        {\color{firstcolor}\rule{\paperwidth}{.6mm}};
    %- Chapter title
    \node[inner sep=0pt, anchor=south west,
          font=\fontsize{50pt}{60pt}\selectfont\titlefont] (title) at
          ([yshift=-.8\chapterHeaderHeigth]current page text area.west|-current page.north)
          {\begin{varwidth}{\entirewidth}%
            \FlushLeft%
            \noHyphen\textcolor{secondcolor}{#1}%
          \end{varwidth}};
    %- Chapter label and numbering
    \node[inner sep=10pt, anchor=south] (label) at (current page marginpar area.north)
        {\normalfont\huge\textcolor{firstcolor}{\textsc{\chaptertitlename}~\thechapter}};
    %- Book title in footer
    \node[inner sep=0pt, anchor=south east] at
      ([xshift=\marginparsep+\marginparwidth,
        yshift=-.5\footskip]current page footer area.south east)
        {\small\color{white}
          \spacedsmallcaps{\@doctitle}
          \ifdefempty{\@doctitle}{}{\ifdefempty{\@subtitle}{}{ \textemdash{} }}\textsc{\@subtitle}
          \ifdoc@licence% adding licence information if needed
            \ifdefempty{\@copyrightname}{}{\quad\@copyrightsymbol\ }\@copyrightname
            \ifdefempty{\@versiondate}{}{ \textendash{} }\@versiondate
            \ifdefempty{\@docversion}{}{\ifdefempty{\@versiondate}{ \textendash{} }{, }}\@docversion
          \fi};%
  \end{tikzpicture}
}
%- Unnumbered chapter layout
\newcommand{\numberlessChapterLayout}[1]{%
  \begin{tikzpicture}[remember picture, overlay]
    %- Main header rectangle
    \fill[maincolor, fill opacity=1]
      ([yshift=-\Gm@tmargin]current page.north west) rectangle
      ([yshift=-\chapterHeaderHeigth]current page.north east);
    %- Bottom header rectangle
    \fill[maincolor, fill opacity=1] (current page.south west) rectangle
      ([yshift=\footskip]current page.south east);
    %- Separation lines
    \node[inner sep=0pt, anchor=north west] at
      ([yshift=-\chapterHeaderHeigth]current page.north west)
        {\color{firstcolor}\rule{\paperwidth}{.6mm}};
    \node[inner sep=0pt, anchor=north west] at
      ([yshift=-\Gm@tmargin]current page.north west)
        {\color{firstcolor}\rule{\paperwidth}{.6mm}};
    \node[inner sep=0pt, anchor=south west] at
      ([yshift=\footskip]current page.south west)
        {\color{firstcolor}\rule{\paperwidth}{.6mm}};
    %- Chapter title
    \node[inner sep=0pt, anchor=south west,
          font=\fontsize{50pt}{60pt}\selectfont\titlefont] (title) at
          ([yshift=-.8\chapterHeaderHeigth]current page text area.west|-current page.north)
          {\begin{varwidth}{\entirewidth}%
            \FlushLeft%
            \noHyphen\textcolor{secondcolor}{#1}%
          \end{varwidth}};
    %- Book title in footer
    \node[inner sep=0pt, anchor=south east] at
      ([xshift=\marginparsep+\marginparwidth,
        yshift=-.5\footskip]current page footer area.south east)
        {\small\color{white}
          \spacedsmallcaps{\@doctitle}
          \ifdefempty{\@doctitle}{}{\ifdefempty{\@subtitle}{}{ \textemdash{} }}\textsc{\@subtitle}
          \ifdoc@licence% adding licence information if needed
            \ifdefempty{\@copyrightname}{}{\quad\@copyrightsymbol\ }\@copyrightname
            \ifdefempty{\@versiondate}{}{ \textendash{} }\@versiondate
            \ifdefempty{\@docversion}{}{\ifdefempty{\@versiondate}{ \textendash{} }{, }}\@docversion
          \fi};%
  \end{tikzpicture}
}
%- Sections
\newcommand{\sectionLayout}[1]{%
  % Automatically added by redefined \ttl@addcontentsline (see above)
  %  \addcontentsline{tdm}{section}{\protect\numberline{\thesection}#1}%
  \raisebox{\secLabelGap}[0pt][0pt]{%
    \parbox[c]{\linewidth-\secLabelSep}{\Large\titlingfont\color{titlingcolor}#1}%
  }%
}
%- Subsections
\newcommand{\subsectionLayout}[1]{%
  \raisebox{\secLabelGap}[0pt][0pt]{\large\titlingfont\color{titlingcolor}#1}}
  %\large\titlingfont\color{titlingcolor}#1}
%- Subsubsections
\newcommand{\subsubsectionLayout}[1]{%
  \raisebox{\secLabelGap}[0pt][0pt]{\normalsize\titlingfont\color{titlingcolor}#1}}
  %\normalsize\titlingfont\color{titlingcolor}#1}
%- Paragraphs
\newcommand{\paragraphLayout}[1]{%
  \titlingspacedfont\spacedlowsmallcaps{#1}}
%- Subparagraphs
\newcommand{\subparagraphLayout}[1]{%
  \spacedlowsmallcaps{#1}}

%-- Sectionning display

%- ToC multicolums setup (tricky to automatically tune: see doc. and TeX.SE links above)
\newcommand{\setuptocmulticols}{%
  %- Setting multicolumns parameters (see the `multicol' package documentation)
  \protect\setlength{\columnsep}{-24pt}%
  \protect\setlength{\columnseprule}{0pt}%{.4pt} No need of column separation
  \protect\raggedcolumns% Default = \flushcolumns INDISPENSABLE POUR ALIGNEMENT CORRECT COLONNES !
  %\protect\tolerance=200% Default = 200 → TeX \fussy, \sloppy → = 10000
  %\protect\multicoltolerance=9999% Default = 9999
  %\protect\setlength{\multicolovershoot}{1pt}% Default = 0pt, stretch tolerance of the column height
  %\protect\setlength{\multicolundershoot}{2pt}% Default = 2pt, shrink tolerance of the column height
  %\protect\setlength{\maxbalancingoverflow}{24pt}% Default = 12pt
  %\protect\setcounter{columnbadness}{9999}% Default = 10000
  %\protect\setcounter{finalcolumnbadness}{9999}% Default = 9999
  \protect\setcounter{collectmore}{-1}% Default = 0; Global → has to bet reset
  %\protect\setcounter{unbalance}{2}% Local → reset automatically to zero after the environment
  \protect\setcounter{multicolminlines}{1}% Min. numb. of lines: \baselineskip (auto reset)
}
%- ToC multicolums resetting (to ensure that the settings don't propagate)
\newcommand{\resettocmulticols}{%
  %\protect\raggedcolumns% Default = \flushcolumns
  %\protect\tolerance=200% Default = 200 → TeX \fussy, \sloppy → = 10000
  %\protect\multicoltolerance=9999% Default = 9999
  %\protect\setlength{\multicolovershoot}{1pt}% Default = 0pt, stretch tolerance of the column height
  %\protect\setlength{\multicolundershoot}{3pt}% Default = 2pt, shrink tolerance of the column height
  %\protect\setlength{\maxbalancingoverflow}{14pt}% Default = 12pt
  %\protect\setcounter{columnbadness}{9999}% Default = 10000
  %\protect\setcounter{finalcolumnbadness}{9999}% Default = 9999
  \protect\setcounter{collectmore}{0}% Default = 0; Global → has to bet reset
  %\protect\setcounter{unbalance}{2}% Local → reset automatically to zero after the environment
  %\protect\setcounter{multicolminlines}{2}% Min. numb. of lines: \baselineskip
}

%- Part and chapter layout
\ifdoc@article\else
  %- Adding a new counter jazzpart for Deuxième vs Seconde in ToC/TdM: VERY STRANGE BUT WORKS!
  \titleformat{\part}[display]{}{}{0pt}{%
    %\addtocounter{jazzpart}{1}% NO, NOT HERE!!!
    \numberedPartLayout}
    % THE FOLLOWING MUST BE DONE TO HAVE THE PART NUMBER DISPLAYING IN THE TOC/TDM!
    % See e.g. https://tex.stackexchange.com/questions/414493/[...]
    %   [...]failure-of-if-condition-inside-titlecontents
    [\ifnum\value{part}>0
       \addtocontents{toc}{\protect\addtocounter{jazzpart}{1}}%
       \addtocontents{tdm}{\protect\addtocounter{jazzpart}{1}}%
     \fi
    ]
  \titleformat{name=\part,numberless}[display]{}{}{0pt}{\numberlessPartLayout}[]
  \titlespacing*{\part}{0pt}{0pt}{0pt}
  %- Chapters: two columns main ToC display of the sections
  %\renewcommand{\columnseprulecolor}{\color{secondcolor}
  \titleformat{\chapter}[display]{}{}{0pt}{\numberedChapterLayout}
    [% Chapter after code to display ToC (sub)sections in two columns for mainmatter
      \ifnum\value{chapter}>0
        \addtocontents{tdm}{%
          \protect\vspace{\aftertocchapterspace}%
          \protect\setuptocmulticols\protect\begin{tocmulticols}{2}\protect\multicolsusedtrue}%
        %\addtocontents{lof}{%
        %  \protect\vspace{\afterlofchapterspace}}%
      \fi%
     % Deleting spurious spaces for LoF, LoT, LoE, LoV, LoD
      %\addtocontents{lof}{\protect\addvspace{-\baselineskip}}
      %\addtocontents{lot}{\protect\addvspace{-\baselineskip}}
      %\addtocontents{lod}{\protect\addvspace{-\baselineskip}}
      %\addtocontents{loe}{\protect\addvspace{-\baselineskip}}
      %\addtocontents{lov}{\protect\addvspace{-\baselineskip}}
    ]
  \titleformat{name=\chapter,numberless}[display]{}{}{0pt}{\numberlessChapterLayout}[]
  \titlespacing*{\chapter}{0pt}{0pt}{\chapterHeaderHeigth+1.5cm-\Gm@tmargin-40pt}
\fi
%- Sections
\titleformat{\section}
  [hang]% shape
  {}% format applied to label+text
  {%
    \fontsize{1.6cm}{1.8cm}%
    \sectionnumberfont\color{titlingnumbercolor}%
    \setlength{\secLabelWidth}{\widthof{\textsc{\thesubsection}}}%
    \setlength{\secLabelHeigth}{\heightof{\textsc{\thesubsection}}}%
    \setlength{\secLabelDepth}{\depthof{\textsc{\thesubsection}}}%
    \ifdoc@sectionappendix%
      \setlength{\secLabelGap}{.75\secLabelHeigth}%\secLabelDepth}%
    \else%
      \setlength{\secLabelGap}{\secLabelHeigth}%
      %\setlength{\secLabelGap}{\secLabelHeigth-\secLabelDepth}%
    \fi%
    \global\secLabelGap=\secLabelGap% Assignments of lengths are local by default
    \llap{\raisebox{\secLabelGap-3mm}[0pt][0pt]{%
      \textsc{\thesection}}\hspace*{-.125\secLabelWidth}}%
    %\rlap{\hspace*{-0.6\secLabelWidth}\raisebox{-3mm}[0pt][0pt]{\textsc{\thesection}}}%
  }% label
  {\secLabelSep}% horizontal (with hang) separation between label and title body
  {\sectionLayout}% implicit {#1} before the title body
  [\vspace*{-\secLabelGap}\vspace*{-3mm}]% after the title body
\titleformat{name=\section,numberless}
  [hang]% shape
  {}% format applied to label+text
  {}% label
  {0pt}% horizontal (with hang) separation between label and title body
  {\Large\titlingfont\color{titlingcolor}}% implicit {#1} before the title body
  []% after the title body
%- Subsections
\titleformat{\subsection}
  [hang]% shape block?
  {}% format applied to label+text
  {\fontsize{.8cm}{1cm}%
    \sectionnumberfont\color{titlingnumbercolor}%
    \setlength{\secLabelWidth}{\widthof{\textsc{\thesubsection}}}%
    \setlength{\secLabelHeigth}{\heightof{\textsc{\thesubsection}}}%
    \setlength{\secLabelDepth}{\depthof{\textsc{\thesubsection}}}%
    %\setlength{\secLabelGap}{\secLabelHeigth-\secLabelDepth}%
    \setlength{\secLabelGap}{.75\secLabelHeigth}%
    \global\secLabelGap=\secLabelGap% Assignments of lengths are local by default
    \llap{\raisebox{\secLabelGap-1mm}[0pt][0pt]{%
      \textsc{\thesubsection}}\hspace*{-.35\secLabelWidth}}%
    %- First displaying attempt (no vertical correction for section at start of new page)
    %\llap{\raisebox{-1mm}[0pt][0pt]{\textsc{\thesubsection}}\hspace*{-.35\secLabelWidth}}%
    %\rlap{\hspace*{-.65\secLabelWidth}\raisebox{-1mm}[0pt][0pt]{\textsc{\thesubsection}}}%
  }% label
  %{\textsc{\MakeTextLowercase{\thesubsection}}}% label
  {\secLabelSep}% horizontal (with hang) separation between label and title body
  {\subsectionLayout}% implicit {#1} before the title body
    %{\large 2.3}\subsectionLayout}% implicit {#1} before the title body
  [\vspace*{-\secLabelGap}\vspace*{-1mm}]% after the title body
\titleformat{name=\subsection,numberless}
  [hang]% shape
  {}% format applied to label+text
  {}% label
  {0pt}% horizontal (with hang) separation between label and title body
  {\large\titlingfont\color{titlingcolor}}% implicit {#1} before the title body
  %{\scalebox{1.075}{\titlingfont\normalsize\color{titlingcolor}}}% {#1}before the title body
  []% after the title body
%- Subsubsections
\titleformat{\subsubsection}
  [hang]% shape
  {}% format applied to label+text
  {\fontsize{.6cm}{.8cm}%
    \sectionnumberfont\color{titlingnumbercolor}%
    \setlength{\secLabelWidth}{\widthof{\textsc{\thesubsection}}}%
    \setlength{\secLabelHeigth}{\heightof{\textsc{\thesubsection}}}%
    \setlength{\secLabelDepth}{\depthof{\textsc{\thesubsection}}}%
    \setlength{\secLabelGap}{\secLabelHeigth-\secLabelDepth}%
    \global\secLabelGap=\secLabelGap% Assignments of lengths are local by default
    \llap{\raisebox{\secLabelGap-.5mm}[0pt][0pt]{%
      \textsc{\thesubsubsection}}\hspace*{-.5\secLabelWidth}}%
    %\llap{\raisebox{-.5mm}[0pt][0pt]{\textsc{\thesubsubsection}}\hspace*{-.5\secLabelWidth}}%
    %\rlap{\hspace*{-1.25\secLabelWidth}\raisebox{-.5mm}[0pt][0pt]{\textsc{\thesubsubsection}}}%
  }% label
  {\secLabelSep}% horizontal (with hang) separation between label and title body
  {\subsubsectionLayout}% implicit {#1} before the title body
  %{\scalebox{1.075}{\titlingfont\normalsize\color{titlingcolor}}}% {#1}before the title body
  [\vspace*{-\secLabelGap}\vspace*{-.5mm}]% after the title body
\titleformat{name=\subsubsection,numberless}
  [hang]% shape
  {}% format applied to label+text
  {}% label
  {0pt}% horizontal (with hang) separation between label and title body
  {\normalsize\titlingfont\color{titlingcolor}}% implicit {#1} before the title body
  %{\scalebox{1.075}{\titlingfont\normalsize\color{titlingcolor}}}% {#1}before the title body
  []% after the title body
%- Paragraphs
\titleformat{\paragraph}
  [runin]% shape
  {\titlingfont}% format applied to label+text
  {\llap{\color{titlingnumbercolor}\theparagraph\,\textendash\space}}% label
  {0pt}% horizontal (with runin) separation between label and title body
  {\paragraphLayout}% implicit {#1} before the title body
  [\normalfont\normalsize\enspace\textemdash{}\enspace]% after the title body
\titleformat{name=\paragraph,numberless}
  [runin]% shape
  {\titlingfont}% format applied to label+text
  {\theparagraph}% label (cf. doc le déclarer quand même)
  {0pt}% horizontal (with runin) separation between label and title body
  {\titlingspacedfont\spacedlowsmallcaps}% {#1}before the title body
  [\normalfont\normalsize\enspace\textemdash{}\enspace]% after the title body
%- Subparagraphs
\titleformat{\subparagraph}%
  [runin]% shape
  {\normalfont\normalsize\sffamily\itshape}% format applied to label+text
  {\thesubparagraph.}% label
  %{\textsc{\MakeTextLowercase{\thesubparagraph}}}% label
  {4pt}% horizontal (with runin) separation between label and title body
  %{\titlingspacedfont\scshape}% {#1}before the title body
  {\subparagraphLayout}% {#1}before the title body
  [\space\textemdash\space\normalfont\normalsize\enspace]% after the title body
\titleformat{name=\subparagraph,numberless}%
  [runin]% shape
  {\normalfont\normalsize\sffamily\itshape}% format applied to label+text
  {}% label
  %{\textsc{\MakeTextLowercase{\thesubparagraph}}}% label
  {0pt}% horizontal (with runin) separation between label and title body
  %{\titlingspacedfont\scshape}% {#1}before the title body
  {\spacedlowsmallcaps}% {#1}before the title body
  [\space\textemdash\space\normalfont\normalsize\enspace]% after the title body

%-- New sectioning commands
%--------------------------
%- Usage: \titleclass{<name>}{<class>}[<super-level-cmd>]
%- Example: \titleclass{\subchapter}{straight}[\chapter]
%-          \newcounter{subchapter}
%-          \renewcommand{\thesubchapter}{\Alph{subchapter}}
%---
%- !!! WARNING! A new numbering level is inserted between \subsubsection and \paragraph,
%- so \overparagraph becomes level 4 and \paragraph is shifted to level 5. By the way,
%- the numbering level of sectioning commands must be redefined and the numbering depth
%- must be change, say: \setcounter{secnumdepth}{6} (see below in ToC §)
%- One more time see Enrico Gregorio suggestion:
%- http://tex.stackexchange.com/questions/148827/how-to-count-part-in-chapter/148842#148842
%- See also Gonzalo Medina usefull practical explanations:
%- http://tex.stackexchange.com/questions/60209/how-to-add-an-extra-level-of-sections
%- As the `titlesec' documentation underlines, the `remreset' package may be usefull, see:
%- /opt/texlive/2016/texmf-dist/tex/latex/carlisle/remreset.sty
%---

%-- Overparagraphs: between subsubsection and paragraph in order to have a different layout
\titleclass{\overparagraph}{straight}[\subsubsection]%
\newcounter{overparagraph}[subsubsection]
\renewcommand{\theoverparagraph}{\Alph{overparagraph}}
%\def\thickhrulefill{\leavevmode\leaders\hrule height 2pt\hfill\kern\z@}
\newcommand{\overparagraphlayout}[1]{%
  %\addcontentsline{tdm}{overparagraph}{\protect\numberline{\theoverparagraph}#1}% NO MORE NEEDED
  \itshape\spacedsmallcaps{#1}\space\textcolor{titlingnumbercolor}{\hrulefill}}
\titleformat{\overparagraph}
  [hang]% shape
  {\vspace{2pt}}% format applied to label+text
  {\llap{\textcolor{titlingnumbercolor}{%
         \large\spacedsmallcaps{\theoverparagraph.}}}}% label
  {.5\secLabelSep}% horizontal separation between label and title body
  {\overparagraphlayout}% implicit {#1} before the title body
  []% after the title body
\titleformat{name=\overparagraph,numberless}
  [hang]% shape
  {\vspace{2pt}}% format applied to label+text
  %{\theoverparagraph}% label (cf. doc le déclarer quand même pour comptabilisation)
  {}% label
  {0pt}% horizontal separation between label and title body
  {\overparagraphlayout}% {#1} before the title body
  []% after the title body
\pretocmd{\overparagraph}{\setcounter{paragraph}{0}}{}

%--- Appendix extensions (per chapter/section subappendices as sections or subsections)
%----------------------
%- Borrowed ideas/macros of a simple `subappendices' environment from the `appendix' package
%---

%\RequirePackage[titletoc]{appendix}% helper package

%- Appendix use
\newif\ifdoc@sectionappendix
%\pretocmd{\subappendices}{\global\doc@sectionappendixtrue}{}{}
%\apptocmd{\subappendices}{\global\doc@sectionappendixfalse}{}{}

\newif\if@pphyper
  \@pphyperfalse
\AtBeginDocument{%
  \@ifpackageloaded{hyperref}{\@pphypertrue}{}}

\newcounter{subappends}
\providecommand{\theH@pps}{\alph{subappends}}

\newenvironment{subappendices}{\par
  \stepcounter{subappends}
  \doc@sectionappendixtrue
  \ifdoc@article% Section subappendices
    \setcounter{subsection}{0}
    \renewcommand{\thesubsection}{\thesection.\Alph{subsection}}%
    \if@pphyper
      \renewcommand{\theHsubsection}{\theH@pps.\Alph{section}}%
    \fi
    \@redotocentryAppendix{subsection}
  \else% Chapter subappendices
    \setcounter{section}{0}
    \renewcommand{\thesection}{\Alph{section}}%
    \if@pphyper
      \renewcommand{\theHsection}{\theH@pps.\Alph{section}}% Needed for correct hyp. ref pages
    \fi
    \@redotocentryAppendix{section}
  \fi
  }{% Close the multicols if needed (redundant, so useless)
    %\addtocontents{tdm}{\protect\ifmulticolsused\protect\end{multicols}\protect\fi}%
    \doc@sectionappendixfalse
}

%- Redefining ToC entries
%- Takes care of the page number. If not, sets the page number to the one of chapters.
%- See: https://tex.stackexchange.com/questions/195831/problem-with-titlesec-and-appendix
\newcommand{\@redotocentryAppendix}[1]{% #1 = ToC level (section, subsection, etc.)
  \let\oldacl@pp=\addcontentsline
  \def\addcontentsline##1##2##3{%
    \def\@pptempa{##1}\def\@pptempb{toc}%
    \ifx\@pptempa\@pptempb
      \def\@pptempa{##2}\def\@pptempb{#1}%
      \ifx\@pptempa\@pptempb
        \oldacl@pp{##1}{##2}{##3}% ##3 = section title
      \else
        \oldacl@pp{##1}{##2}{##3}%
      \fi
    \else
       \oldacl@pp{##1}{##2}{##3}%
    \fi
  }
}

%- Controling the layout of subappendices
\BeforeBeginEnvironment{subappendices}{\clearpage\symmetricalpage}%\clearmargin
\AfterEndEnvironment{subappendices}{\asymmetricalpage}

%-- Chapter replacement for appendices and back matter

%- Numbered appendix chapter layout
\newcommand{\numberedAppendixLayout}[1]{%
  \begin{tikzpicture}[remember picture, overlay]
    %- Main header rectangle
    \fill[maincolor, fill opacity=1]
      ([yshift=-\Gm@tmargin]current page.north west) rectangle
      ([yshift=-\chapterHeaderHeigth]current page.north east);
    %- Bottom header rectangle
    \fill[maincolor, fill opacity=1] (current page.south west) rectangle
      ([yshift=\footskip]current page.south east);
    %- Separation lines
    \node[inner sep=0pt, anchor=north west] at
      ([yshift=-\chapterHeaderHeigth]current page.north west)
        {\color{firstcolor}\rule{\paperwidth}{.6mm}};
    \node[inner sep=0pt, anchor=north west] at
      ([yshift=-\Gm@tmargin]current page.north west)
        {\color{firstcolor}\rule{\paperwidth}{.6mm}};
    \node[inner sep=0pt, anchor=south west] at
      ([yshift=\footskip]current page.south west)
        {\color{firstcolor}\rule{\paperwidth}{.6mm}};
    %- Chapter title
    \node[inner sep=0pt, anchor=south west,
          font=\fontsize{50pt}{60pt}\selectfont\titlefont] (title) at
          ([yshift=-.8\chapterHeaderHeigth]current page text area.west|-current page.north)
          {\begin{varwidth}{\entirewidth}%
            \FlushLeft%
            \noHyphen\textcolor{secondcolor}{#1}%
          \end{varwidth}};
    %- Chapter label and numbering
    %\node[inner sep=10pt, anchor=south] (label) at (current page marginpar area.north)
    \node[inner sep=0pt, anchor=east] (label) at
      ([xshift=-10mm,yshift=-10mm]current page marginpar area.north east)
        {\normalfont\huge\textcolor{white}{\textsc{\appendixname}~\theappendixchapter}};
    %- Book title in footer
    \node[inner sep=0pt, anchor=south east] at
      ([xshift=\marginparsep+\marginparwidth,
        yshift=-.5\footskip]current page footer area.south east)
        {\small\color{white}
          \spacedsmallcaps{\@doctitle}
          \ifdefempty{\@doctitle}{}{\ifdefempty{\@subtitle}{}{ \textemdash{} }}\textsc{\@subtitle}
          \ifdoc@licence% adding licence information if needed
            \ifdefempty{\@copyrightname}{}{\quad\@copyrightsymbol\ }\@copyrightname
            \ifdefempty{\@versiondate}{}{ \textendash{} }\@versiondate
            \ifdefempty{\@docversion}{}{\ifdefempty{\@versiondate}{ \textendash{} }{, }}\@docversion
          \fi};%
  \end{tikzpicture}
}

%-- New sectioning commands for appendix and back chapters (much more easier ToC/LoF/LoT management)
% https://tex.stackexchange.com/questions/328157/why-does-titleclass-remove-my-sections-from-the-toc
\ifdoc@article\else
  %- Appendix chapter
  \titleclass{\appendixchapter}[0]{top}
  %\titleclass{\appendixchapter}{straight}[\part]
  \newcounter{appendixchapter}%[part]
  \renewcommand{\theappendixchapter}{\Alph{appendixchapter}}
  \titleformat{\appendixchapter}[display]
    {\cleardoublepage}{}{0pt}{\numberedAppendixLayout}
    [% Chapter after code to display ToC (sub)sections in two columns for mainmatter and appendices
      \ifnum\value{appendixchapter}>0
        \addtocontents{tdm}{%
          \protect\vspace{\aftertocchapterspace}%
          \protect\setuptocmulticols\protect\begin{tocmulticols}{2}\protect\multicolsusedtrue}%
      \fi%
     % Deleting spurious spaces for LoF, LoT, LoE, LoV, LoD
      %\addtocontents{lof}{\protect\addvspace{-\baselineskip}}
      %\addtocontents{lot}{\protect\addvspace{-\baselineskip}}
      %\addtocontents{lod}{\protect\addvspace{-\baselineskip}}
      %\addtocontents{loe}{\protect\addvspace{-\baselineskip}}
      %\addtocontents{lov}{\protect\addvspace{-\baselineskip}}
    ]
  \titleformat{name=\appendixchapter,numberless}[display]
    {\cleardoublepage}{}{0pt}{\numberlessChapterLayout}[]
  \titlespacing*{\appendixchapter}{0pt}{0pt}{\chapterHeaderHeigth+1.5cm-\Gm@tmargin-40pt}
  %- Back matter style: numberless layout (references, glossaries, index, etc.)
  \titleclass{\backchapter}[0]{top}
  %\titleclass{\backchapter}{straight}[\part]
  \newcounter{backchapter}%[part]
  %\renewcommand{\thebackchapter}{\Roman{backchapter}}
  %\renewcommand{\thebackchapter}{}
  \titleformat{\backchapter}[display]
    {\cleardoublepage}{}{0pt}{\numberlessChapterLayout}
    [\addtocontents{tdm}{\protect\vspace{\aftertocchapterspace}}]
  %\titleformat{name=\chapter,numberless}[display]{}{}{0pt}{\numberlessChapterLayout}[]
  \titleformat{name=\backchapter,numberless}[display]
    {\cleardoublepage}{}{0pt}{\numberlessChapterLayout}
    [\addtocontents{tdm}{\protect\vspace{\aftertocchapterspace}}]
  \titlespacing*{\backchapter}{0pt}{0pt}{\chapterHeaderHeigth+1.5cm-\Gm@tmargin-40pt}
\fi

%https://tex.stackexchange.com/questions/51351/modifying-mini-toc-content
%\let\ttl@savel@appendix\l@appendix
%\def\l@appendix{\let\ttl@savel@chapter\ttl@savel@appendix\ttl@lselect{chapter}

%-- Setting the counters properly
%\RequirePackage{chngcntr}% helper package
%- Usage: \counterwithin{<ctr>}{<within>}
%- star `*' version doesn't redefine the style (by default) to \the<within>.\arabic{<ctr>}
%- Pas nécessaire semble-t-il ou mal placé (ToC et Bookmark)
%\counterwithin*{paragraph}{overparagraph}% Resetting the paragraph counter within overparagraph


%---------------------------------------------------------------------------------------------------
%---- Sectioning spaces management / Arrangement des espaces des commandes de sectionnement
%---------------------------------------------------------------------------------------------------

%--- Spacing before and after sectionning stuff (with `titlesec' package)
%----------------------------------------------
%- Usage: \titlespacing{<sectioning-command>}{<leftsep>}{<beforesep>}{<aftersep>}{<right-sep>}
%- The <right-sep> option is only available to "hang", "block", "display" shapes.
%- The starred version kills the indentation of the paragraph following the title.
%- Adding tolerance may be done in <beforesep> and <aftersep>.
%---

\ifdoc@english% English style: No indentation after a sectioning command
  %\titlespacing*{\chapter}{0pt}{0pt}{\chapterHeaderHeigth+1.5cm-\Gm@tmargin-40pt}
  \titlespacing*{\section}{0pt}{\baselineskip}{0pt}
  \titlespacing*{\subsection}{0pt}{\baselineskip}{2\parskip}
  \titlespacing*{\subsubsection}{0pt}{.5\baselineskip}{\parskip}
  \titlespacing*{\overparagraph}{0pt}{.5\baselineskip}{\parskip}
  \titlespacing*{\paragraph}{0pt}{2pt}{0pt}
  \titlespacing*{\subparagraph}{0pt}{0pt}{0pt}
\else% French style
  %\titlespacing*{\chapter}{0pt}{0pt}{\chapterHeaderHeigth+1.5cm-\Gm@tmargin-40pt}
  \titlespacing{\section}{0pt}{20pt plus 2pt minus 2pt}{12pt plus 2pt minus 4pt}%
  \titlespacing{\subsection}{0pt}{16pt plus 2pt minus 2pt}{6pt plus 2pt minus 2pt}
  \titlespacing{\subsubsection}{0pt}{12pt plus 2pt minus 2pt}{1pt plus 1pt minus 1pt}
  \titlespacing{\overparagraph}{0pt}{3pt plus 1.5pt minus 1.5pt}{\parskip}
  \titlespacing{\paragraph}{0pt}{2pt plus .75pt minus .75pt}{0pt}
  \titlespacing{\subparagraph}{0pt}{0pt}{0pt}
\fi


%---------------------------------------------------------------------------------------------------
%---- Table of contents, figures, tables, etc.
%---------------------------------------------------------------------------------------------------

\RequirePackage{titletoc}% `titlesec' package companion for ToCs, `List of...', ect.

%-- Syntax of `titletoc' package: (very powerful, but complex code and redefine standard commands)
%-- \titlecontents{ section }[ left-margin ]{ above-code }
%-- { numbered-entry-format }{ numberless-entry-format }
%-- { filler-page-format }[ below-code ][ end code ]
%-- \titlecontents* (star version) displays the contents in a paragraphed mode
%---

%--- For the record:
%- Échelle de profondeur [-2;5] (avec etoc, niveau -2 pour book) : -2=book (memoir.cls), -1=part,
%- 0=chapter, 1=section, 2=subsection, 3=subsubsection, 4=paragraph, 5=subparagraph
%---

\setcounter{secnumdepth}{6}% profondeur de numérotation des sections
\setcounter{tocdepth}{3}% profondeur de la table des matières principale : 3 = subsubsection

%---
%- The desired default behaviour is to display (sub)sections in two colums for the main ToC, with
%- the help of the `multicols' package. To access to others partial ToC in one column without
%- interfering with the main ToC, this latter is store in a separate file "jobname.tdm", where
%- "tdm" stands for "Table des matières" in French. For one column main Toc, nothing is modified.
%---
%- Working solution (without partial ToCs) is given by Christian Hupfer after posting to TeX.SE:
%- Cf. http://tex.stackexchange.com/questions/355285/two-columns-book-toc-misunderstood-behaviour
%- For using also partial ToCs, a standalone main ToC file is defined separately (because of
%- an issue with the `titletoc' package).
%- After posting to TeX-SE, the solution is given by 'touhami' by redefining \addcontentsline
%- See: http://tex.stackexchange.com/questions/359603/
%- Personal old attempt (works only for sections but not chapters):
%  \def\ttl@addcontentsline#1#2{%
%    \addcontentsline{toc}{#1}{\ifttl@toclabel\ttl@a\fi#2}%
%    \addcontentsline{tdm}{#1}{\ifttl@toclabel\ttl@a\fi#2}%
%    \nobreak}
%---

%-- Two columns main ToC
\newcommand\twocolumnstableofcontents{%
  \ifdoc@article% From article.cls
    \renewcommand*{\contentsname}{\textcolor{secondcolor}{\large\tocfont\spacedsmallcaps{Sommaire}}}
    \setlength{\columnseprule}{.4pt}
    \renewcommand{\columnseprulecolor}{\color{secondcolor}}
    \begingroup\centering
    \begin{tcolorbox}[
      width=.9\linewidth,
      enhanced, breakable,
      %blank,
      nobeforeafter,
      %arc=0pt, outer arc=0pt,
      %boxsep=0pt,
      left=8pt, right=8pt,
      top=8pt, bottom=4pt,
      %boxrule=0pt,
      colback=black!5,%black!10,
      colframe=firstcolor,
      %toptitle=4pt, bottomtitle=4pt,
      %colbacktitle=black!10, coltitle=secondcolor,
      %titlerule=1pt,
      %fonttitle=\large\tocfont,
      %title={},
      %overlay={
      %  \node[anchor=west,fill=white,inner xsep=6pt]
      %    at ([xshift=10pt]frame.north west) {Sommaire};
       %}
     ]
     \contentsname\space\textcolor{firstcolor}{\hrulefill}\par
     \vspace{\baselineskip}
    \begin{multicols}{2}
      \@starttoc{toc}%
    \end{multicols}
    \vspace{.5\baselineskip}\textcolor{firstcolor}{\hrule}
    \end{tcolorbox}
    \par\endgroup
  \else
    %- Two columns main ToC: loading "jobname.tdm" with two columns inside
    %- Also had a bookmark in the definition (see below)
    \chapter*{\contentsname\@mkboth{\MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
    \@starttoc{tdm}% TDM stands for "Table des matières" in French
  \fi
  %\addtocontents{tdm}{% Resetting to default values after the multicolumns ToC
  %  \protect\resettocmulticols% Default = 0; Global → has to bet reset
  %}%
}
%\ifdoc@article
  \let\tableofcontents\twocolumnstableofcontents
%\fi

%- One column main ToC
\newcommand{\sommaire}{%
  \chapter*{\contentsname\@mkboth{\MakeUppercase{\contentsname}}{\MakeUppercase{\contentsname}}}%
  \@starttoc{toc}
}


%-- Partial chapter ToC utilities (see \sideChapterToc definition below)

\newlength{\tocboxHeight}
\setlength{\tocboxHeight}{40pt}% default: must be recalculated below

%- Box height measurement of the partial ToC
\newtcolorbox{measurebox}[2][]{% From http://tex.stackexchange.com/questions/203194/
  blank, parbox=false,%show bounding box,
  overlay={\xdef#2{\tcb@height}},
  #1
}

%-- Designing the partial ToC with `mdframed' (Old fashion: `tcolorbox' is definitively adopted)
%\newcommand{\toc@mdframed}{%
%  \begin{measurebox}{\tocboxHeight}
%    \begin{mdframed}[
%      userdefinedwidth=\marginparwidth,
%      skipabove=0pt, skipbelow=0pt,%\baselineskip,
%      innertopmargin=8pt, innerbottommargin=8pt,
%      innerleftmargin=8pt, innerrightmargin=8pt,%4mm,
%      leftmargin=0mm, rightmargin=0mm,
%      leftline=false, rightline=false, topline=false, bottomline=false,
%      linewidth=1pt,%\color|secondcolor}
%      backgroundcolor={black!10}]
%      \ifdoc@english
%        {\tocfont\large\textcolor{secondcolor}{In brief}\hfill}%
%      \else
%        {\tocfont\large\textcolor{secondcolor}{\spacedlowsmallcaps{Sommaire}}\hfill}%
%      \fi
%      \vspace{-.5\baselineskip}%
%      %\setcounter{tocdepth}{2}% set globaly (see above)
%      %\hypersetup{linkcolor=black}% take care of the hyperref default set-up
%      {\color{secondcolor}\hfill\rule{\linewidth}{1pt}}%
%      \par
%      %\vspace{-.5\baselineskip}%
%      %\vspace*{-2mm}%
%      %\startcontents[chapters]
%      %\hypersetup{linkcolor=black}
%      \renewcommand{\baselinestretch}{1.1}% Different setting with tcolorbor: why? 1.1 ~ 1.4
%      \printcontents[chapters]{s}{1}{\setcounter{tocdepth}{3}}
%      \vspace*{0pt}% fitting vertical space: why? Strange...
%    \end{mdframed}
%  \end{measurebox}
%}

%- Defining a command for line stretching into side chapter ToCs
\newcommand*{\sidetocbaselinestretch}{1.2}

%- Designing the partial ToC with tcolorbox
\newcommand{\chaptertoc@tcolorbox}{%
  \begin{measurebox}{\tocboxHeight}
    \begin{tcolorbox}[
      width=\marginparwidth,
      enhanced,
      nobeforeafter,
      arc=0pt, outer arc=0pt,
      boxsep=0pt,
      left=8pt, right=8pt,
      top=8pt, bottom=4pt,
      boxrule=0pt,
      colback=black!10, %colframe=black!40,
      %toptitle=4pt, bottomtitle=4pt,
      colbacktitle=black!10, coltitle=secondcolor,
      %titlerule=1pt,
    ]
    \ifdoc@english
      {\tocfont\large\textcolor{secondcolor}{In brief}}%
    \else
      {\tocfont\large\textcolor{secondcolor}{\spacedlowsmallcaps{Sommaire}}}%
    \fi
    \par\vspace{-.5\baselineskip}%
    \textcolor{secondcolor}{\rule{\linewidth}{1pt}}%
    \par
    \renewcommand{\baselinestretch}{\sidetocbaselinestretch}
    %\printcontents[chapters]{c}{1}{\setcounter{tocdepth}{3}}% For 2016/03/21 version
    %- New usage: \printcontents[<name>]{<prefix>}{<start-level>}[<toc-depth>]{<toc-code>}
    \printcontents[chapters]{c}{1}[3]{}% New update 2019/09/09
    %\printcontents{}{1}[3]{}% New update 2019/09/09
    \end{tcolorbox}%
  \end{measurebox}
}

%\pretocmd{\chaptertoc@tcolorbox}{%
%
%}{}{}

%-- Chapter margin mini-ToC
\newcommand{\sideChapterToC}{%
  \startcontents[chapters]% For 2016/03/21 version and new update 2019/09/09
  %\marginelement{% Based on floating LaTeX marginpar: DOESN'T WORK with multicol ToC
  %\marginpar{%
  \marginnote{% Much more efficient for the margin vertical space management
    \chaptertoc@tcolorbox
  }\unskip% Needed for vertical alignment. See: http://tex.stackexchange.com/questions/117695/
  \mparshift{\tocboxHeight}% Shifting down the next margin notes (from `marginfix' package)
  \marginpar{\vspace*{\baselineskip}}% More space / starts margin display at the correct position
}

%-- Conditional on multicolumn use in ToC/TdM

%- First working attempt from Christian Hupfer to my question:
%- https://tex.stackexchange.com/questions/355285/two-columns-book-toc-misunderstood-behaviour
\newif\ifmulticolsused
%\pretocmd{\multicols}{\global\multicolsusedtrue}{}{}
%\apptocmd{\endmulticols}{\global\multicolsusedfalse}{}{}

%- Redefining multicolumns environments to fit our needs for the ToC (unbalanced: multicols* like)
%- The approach is definitly not straightforward and traditional because of the internal definition
%- adopted by Franck Mittelbach for multicols environment. A solution is proposed by egreg, see:
%- https://tex.stackexchange.com/questions/351389/
%- (re-newenvironment-that-contains-environment-itself-with-an-argument-in-latex)

%- Keep copies of the original to be on the safe side
\let\jazzmulticols\multicols
\let\endjazzmulticols\endmulticols
\letcs\jazzmulticolsstar{multicols*}
\letcs\endjazzmulticolsstar{endmulticols*}
\patchcmd{\jazzmulticolsstar}{\begin{multicols}}{}{}{}
\patchcmd{\endjazzmulticolsstar}{\end{multicols}}{}{}{}

%- Wow! May be one day I'd be able to really understand this code... Read TeXbook!
\newcommand{\newmulticolsenvironment}[3]{%
  \newenvironment{#1}{#2\jazzmulticols}{}%
  \toks@=\expandafter{\endjazzmulticols#3}%
  \expandafter\edef\csname end#1\endcsname{\the\toks@}%
  \expandafter\patchcmd\csname end#1\endcsname
    {\@checkend{multicols}}
    {\@checkend{#1}}
    {}{}%
  \newenvironment{#1*}
    {#2\jazzmulticolsstar\begin{#1}}
    {\endjazzmulticolsstar\end{#1}#3}%
}

%- For an unknown reason multicol* give errors and without star it works!!! Very strange! FIXME TODO
\newmulticolsenvironment{tocmulticols}
  {\global\multicolsusedtrue}%<some stuff before>
  {\global\multicolsusedfalse}%<some stuff after>

%-- If part(s) exist(s)

\newif\ifdoc@parts
\pretocmd{\part}{\global\doc@partstrue}{}{}

%-- Partial part and chapter ToC management (appendices and so on)
\pretocmd{\appendixchapter}{%
  \ifnum\value{appendixchapter}=0
    \stopcontents[chapters]%
  \fi
}{}{}
\pretocmd{\backmatter}{%
  \ifdoc@parts
    \stopcontents[parts]%
  \fi
}{}{}

%https://tex.stackexchange.com/questions/10291/
% addtocontents-at-end-of-document-not-getting-written-to-toc-file (Martin Scharrer)
%https://tex.stackexchange.com/questions/13914/toc-numbering-problem/
%https://tex.stackexchange.com/questions/116001/
%write-information-on-aux-file-when-using-include-to-build-document
%\newcommand\immediateaddtocontents[2]{{%
%   \let\protect\@unexpandable@protect
%   \immediate\write\@auxout{\noexpand\@writefile{#1}{#2}}%
%}}
%https://tex.stackexchange.com/questions/52746/include-chapters-in-list-of-figures-with-titletoc
%https://tex.stackexchange.com/questions/139247/chapter-titles-as-hyperlinks-in-the-list-of-figures
%https://tex.stackexchange.com/questions/253223/
%add-both-part-and-chapter-titles-to-list-of-figures-with-formatting-and-line-wra
%https://tex.stackexchange.com/questions/211980/problem-with-automatic-chapters-parts-in-list-of-figures-and-list-of-tables

%-- Automatic detection of figures/tables/etc. for LoF/LoT/etc. within chapters (see TeX.SE links)

%- Initial definitions of the chapter info (name and number)
\def\thischaptertitle{}
\def\thischapternumber{}
\def\thischapterpage{}
\def\thisappendixchaptertitle{}
\def\thisappendixchapternumber{}% See above hook for \appendixchapter
%- It seems that we have to define the same settings for the part sectioning (FIXME)
\def\thisparttitle{}
\def\thispartnumber{}
%- Toogle (= bascule in French) to detect if there are figures and so forth in each chapter
\newtoggle{noFigs}
\newtoggle{noTabs}
\newtoggle{noExos}
\newtoggle{noQuiz}
\newtoggle{noDocs}
\newtoggle{noVids}
\newtoggle{noCodes}
\newtoggle{noListings}
%- See: https://tex.stackexchange.com/questions/106587/how-to-include-appendices-name-in-lof
\newbool{appendices}% Equivalent to \doc@appendix? YES FIXME
\setbool{appendices}{false}

%-- Redefining macros to add part and side partial ToCs + automatic numbering of figures/etc.
\ifdoc@article\else
  \let\originalpart\part
  \renewcommand{\part}{
    \startcontents[parts]%
    \originalpart
  }
  \apptocmd{\@part}{%
    \gdef\thisparttitle{#1}\gdef\thispartnumber{\thepart}%
    \global\toggletrue{noFigs}\global\toggletrue{noTabs}%
    \global\toggletrue{noExos}\global\toggletrue{noQuiz}%
    \global\toggletrue{noVids}\global\toggletrue{noDocs}%
    \global\toggletrue{noCodes}\global\toggletrue{noListings}%
  }{}{}
%  \RenewDocumentCommand{\part}{s o m}{% DOES NOT WORK. WHY? FIXME
%    \IfBooleanTF{#1}{%
%      \originalpart*{#3}\gdef\thisparttitle{#3}}{%
%      \IfNoValueTF{#2}%
%        {\originalpart{#3}\gdef\thisparttitle{#3}}
%        {\originalpart[#2]{#3}\gdef\thisparttitle{#2}}%
%    %\startcontents[parts]%
%  }
  \let\originalchapter\chapter
  \RenewDocumentCommand{\chapter}{s o m}{%
    \IfBooleanTF{#1}{%
      \originalchapter*{#3}\gdef\thischaptertitle{#3}}{%
      \IfNoValueTF{#2}%
        {\originalchapter{#3}\gdef\thischaptertitle{#3}}
        {\originalchapter[#2]{#3}\gdef\thischaptertitle{#2}}%
      % Automatic control of figures/tables/etc. numbering for LoF/LoT/etc.
      \ifnum\value{secnumdepth} > -1
        \gdef\thischapternumber{\thechapter}%
      \else
        \global\let\thischapternumber\@empty%
      \fi
      \global\let\thischapterHref\@currentHref % hyperref
      \global\toggletrue{noFigs}\global\toggletrue{noTabs}%
      \global\toggletrue{noExos}\global\toggletrue{noQuiz}%
      \global\toggletrue{noDocs}\global\toggletrue{noVids}%
      \global\toggletrue{noCodes}\global\toggletrue{noListings}%
      %\addtocontents{lof}{\protect\addvspace{-24\p@}}
      %\addtocontents{lot}{\protect\addvspace{-10\p@}}
      %\addtocontents{lod}{\protect\addvspace{-10\p@}}
      %\addtocontents{loe}{\protect\addvspace{-10\p@}}
      %\addtocontents{loq}{\protect\addvspace{-10\p@}}
      %\addtocontents{lov}{\protect\addvspace{-10\p@}}
      %%% BELOW IS A STUPID IDEA!
      %\addtocontents{lof}{\protect\vfill}% Try to correctly balance the LoF
      %\addtocontents{lot}{\protect\vfill}% Try to correctly balance the LoT
      %\addtocontents{loe}{\protect\vfill}% Try to correctly balance the LoE
      %\addtocontents{lov}{\protect\vfill}% Try to correctly balance the LoV
      %\addtocontents{lod}{\protect\vfill}% Try to correctly balance the LoD
      \sideChapterToC
    }%
  }%
  \let\originalappendixchapter\appendixchapter
  \RenewDocumentCommand{\appendixchapter}{s o m}{%
    \IfBooleanTF{#1}{%
      \originalappendixchapter*{#3}\gdef\thisappendixchaptertitle{#3}}{%
      \IfNoValueTF{#2}%
        {\originalappendixchapter{#3}\gdef\thisappendixchaptertitle{#3}}
        {\originalappendixchapter[#2]{#3}\gdef\thisappendixchaptertitle{#2}}%
      % Automatic control of figures/tables/etc. numbering for LoF/LoT/etc.
      \ifnum\value{secnumdepth}>-1 %
        \gdef\thisappendixchapternumber{\theappendixchapter}%
      \else
        \global\let\thisappendixchapternumber\@empty
      \fi
      \global\let\thisappendixchapterHref\@currentHref % hyperref
      \global\toggletrue{noFigs}\global\toggletrue{noTabs}%
      \global\toggletrue{noExos}\global\toggletrue{noQuiz}%
      \global\toggletrue{noDocs}\global\toggletrue{noVids}%
      \global\toggletrue{noCodes}\global\toggletrue{noListings}%
      %\addtocontents{lof}{\protect\addvspace{-10\p@}}
      %\addtocontents{lot}{\protect\addvspace{-10\p@}}
      %\addtocontents{lod}{\protect\addvspace{-10\p@}}
      %\addtocontents{loe}{\protect\addvspace{-10\p@}}
      %\addtocontents{loq}{\protect\addvspace{-10\p@}}
      %\addtocontents{lov}{\protect\addvspace{-10\p@}}
      %%% BELOW IS A STUPID IDEA!
      %\addtocontents{lof}{\protect\vfill}% Try to correctly balance the LoF
      %\addtocontents{lot}{\protect\vfill}% Try to correctly balance the LoT
      %\addtocontents{loe}{\protect\vfill}% Try to correctly balance the LoE
      %\addtocontents{lov}{\protect\vfill}% Try to correctly balance the LoV
      %\addtocontents{lod}{\protect\vfill}% Try to correctly balance the LoD
    }%
  }%
  \let\originalsection\section
  \RenewDocumentCommand{\section}{s o m}{%
    \IfBooleanTF{#1}
      {\originalsection*{#3}}
      {\IfNoValueTF{#2}
        {\originalsection{#3}}
        {\originalsection[#2]{#3}}}%
  }%
  %- Taking into account a two colums main ToC with entries in the file jobname.tdm
  \pretocmd{\part}{%
    % Close the multicols if needed in the Toc/TdM file
    \addtocontents{tdm}{%\protect\vspace*{\fill}
      %\protect\ifmulticolsused\protect\vspace{\fill}\protect\end{tocmulticols}\protect\fi%
      \protect\ifmulticolsused\protect\end{tocmulticols}\protect\fi%
      \protect\vspace{\beforetocpartspace}%
    }%
  }{}{}
  \pretocmd{\chapter}{%
    % Close the multicols if needed in the Toc/TdM file
    \addtocontents{tdm}{%
      %\protect\ifmulticolsused\protect\vspace{\fill}\protect\end{tocmulticols}\protect\fi
      \protect\ifmulticolsused\protect\end{tocmulticols}\protect\fi
      \protect\vspace{\beforetocchapterspace}%
      }%
  }{}{}
  \pretocmd{\appendixchapter}{%
    % Close the multicols if needed in the Toc/TdM file
    \addtocontents{tdm}{%
      \protect\ifmulticolsused\protect\end{tocmulticols}\protect\fi
      \protect\vspace{\beforetocchapterspace}%
      }%
  }{}{}
  \pretocmd{\backchapter}{%
    % Close the multicols if needed in the Toc/TdM file
    \addtocontents{tdm}{%
      \protect\ifmulticolsused\protect\end{tocmulticols}\protect\fi
      \protect\vspace{\beforetocchapterspace}%
      }%
  }{}{}
  %\AtEndDocument{% Close the multicols if needed in the Toc/TdM file
    %\immediateaddtocontents{tdm}{\protect\ifmulticolsused\protect\end{multicols}\protect\fi}%
    %\addtocontents{tdm}{\protect\ifmulticolsused\protect\end{multicols}\protect\fi}%
    %\addtocontents{tdm}{\protect\ifmulticolsused\protect\end{multicols}\protect\fi\protect\vfill}
    %\hbox{}% add a new page with the \include way to insert material (obviously OK with \input))
  %}
  \AfterLastShipout{% Close the multicols if needed in the Toc/TdM file
    % Must be after \AtEndDocument hook and \clearpage but before the main .aux file is closed
    \immediate\write\@auxout{\noexpand\@writefile{tdm}{%
      \noexpand\ifmulticolsused\noexpand\vspace{\fill}%
      \noexpand\end{tocmulticols}\noexpand\fi\noexpand\vspace*{\fill}}}%
    \immediate\write\@auxout{\noexpand\@writefile{tdm}{%
      \noexpand\contentsfinish}}% must close the ToC file with the titletoc package and partial ToCs
  }
  %\unexpanded{\ifmulticolsused\end{multicols}\fi}% equivalent alternative for long text/variable?
  %\pretocmd{\include}{%
  %  \addtocontents{tdm}{\protect\ifmulticolsused\protect\end{multicols}\protect\fi}%
  %}{}{}
  %\pretocmd{\appendix}{% Close the multicols if needed in the Toc/TdM file
  %  \addtocontents{tdm}{\protect\ifmulticolsused\protect\end{multicols}\protect\fi}
  %}
  %\pretocmd{\enddocument}{% Close the multicols if needed in the Toc/TdM file
  %  \addtocontents{tdm}{\protect\ifmulticolsused\protect\end{multicols}\protect\fi}
  %}
  %\let\oldend\enddocument
  %\renewcommand{\enddocument}{%
  %  \addtocontents{tdm}{\protect\ifmulticolsused\protect\end{multicols}\protect\fi}\oldend}
\fi

%-- Automatic control of the ToCs entries (ToC and TdM files)

%- Another approach for automatic numering of figures, tables, etc. is to patch \addcontentsline
%- See: https://tex.stackexchange.com/questions/52746/include-chapters-in-list-of-figures-with-titletoc
%- DOES NOT WORK: FIXME
%\newcommand{\DeclareDividedList}[1]{%
%  \newcounter{#1@chapter}\setcounter{#1@chapter}{0}%
%  \newcounter{#1@appendixchapter}\setcounter{#1@appendixchapter}{0}%
%}
%  \pretocmd{\addcontentsline}{%
%    \ifltxcounter{#1@chapter}{%
%      \ifnumgreater{\thischapternumber}{\value{#1@chapter}}{%
%        \setcounter{#1@chapter}{\thischapternumber}%
%        \addtocontents{#1}{\protect\contentsline{chapter}{%
%          \protect\numberline {\thischapternumber} {\thischaptertitle}}%
%          {}{}%
%        }%
%      }{}%
%    }{}%
%    \ifltxcounter{#1@appendixchapter}{%
%      \ifnumgreater{\thisappendixchapternumber}{\value{#1@appendixchapter}}{%
%        \setcounter{#1@appendixchapter}{\thisappendixchapternumber}%
%        \addtocontents{#1}{\protect\contentsline{appendixchapter}{%
%          \protect\numberline {\thisappendixchapternumber} {\thisappendixchaptertitle}}%
%          {}{}%
%        }%
%      }{}%
%    }{}%
%  }{}{}%
%  \DeclareDividedList{lof}

\AtEndOfClass{% → Redefinition of \addcontentsline MUST be done AFTER the `hyperref' package
  \let\oldaddcontentsline\addcontentsline
  \renewcommand{\addcontentsline}[3]{%
    \def\tmp{toc}\def\ttmp{#1}%
    \oldaddcontentsline{#1}{#2}{#3}%
    \ifx\tmp\ttmp
      \oldaddcontentsline{tdm}{#2}{#3}%
    \fi
  }
}

%-- General handbook ToC, LoF, LoT, etc. layout

\RequirePackage{framed}% helper package

%-- Lengths
\newlength{\tocnumberWidth}
\settowidth{\tocnumberWidth}{\Huge\bfseries\scshape 999}
\newlength{\tocnumberSep}
\setlength{\tocnumberSep}{10pt}

%-- Utility for chapter and part ToC layout
%-- From G. Medina settings: http://tex.stackexchange.com/questions/35825/pretty-table-of-contents

%- Original layout by G. Medina (see http://tex.stackexchange.com/questions/35825 for using)
\renewenvironment{leftbar}{% Used for partial part ToC layout
  \def\FrameCommand{%
    \hspace{1.5\tocnumberWidth}%\hspace{6em}%
    {\color{secondcolor}\vrule width 2pt depth 6pt}\hspace{1em}%
  }%\hspace{10pt}}%
  %\MakeFramed {\advance\hsize-\width \FrameRestore}%\vskip2pt
  \MakeFramed{\parshape 1 0cm \dimexpr\textwidth-1.5\tocnumberWidth\relax\FrameRestore}\vskip2pt%
}{\endMakeFramed}
%- Adapted layout
\newenvironment{tocleftbar}{% Used for ToC chapter layout
  \def\FrameCommand{%
    \hspace{\tocnumberWidth}% Page chapter number width
    \hspace{\tocnumberSep}% Separation from page chapter number to left bar
    \textcolor{secondcolor}{\vrule width 2pt depth 6pt}%
    \hspace{\tocnumberSep}% Separation between left bar and "framed" text contents
    %\hspace{2pt}% Compensated bar width to align the chapter title with the section title
  }
  %- \hsize = measured text width (see framed.sty source file)
  %- \width = measured extra width added by the frame via \fb@frw macro (see framed.sty source file)
  \MakeFramed{\advance\hsize-\width \FrameRestore}\vskip 2pt%
  %\MakeFramed{\parshape 1 0cm \dimexpr\textwidth-1.5\tocnumberWidth\relax\FrameRestore}\vskip2pt%
}{\endMakeFramed}

%-- New macros to manually ajust (in the core document) the vertical space between ToC entries

%-- https://tex.stackexchange.com/questions/119730/ (global-scope-or-permanent-length-or-savebox)
%-- https://tex.stackexchange.com/questions/406015/ (defining-macro-gsetlength-as-global-setlength)

%-- For \deflength see `etoolbox' doc. (like \setlength but support glue and global assignment)

\def\globalpgfsetlength#1#2{%
  \expandafter\pgfmath@onquick#2\pgfmath@%
    {%
      % Ok, quick version:
      \begingroup%
        \pgfmath@selectfont%
        \pgfmath@x#2\unskip%
        \pgfmath@returnone\pgfmath@x%
      \endgroup%
      \global#1\pgfmathresult pt\relax% here add \global before #1
    }%
    {%
      \pgfmathparse{#2}%
      \global#1\pgfmathresult pt\relax% and here
    }%
    \ignorespaces%
}

%- Lengths as command (for redefining in the core document)
\newcommand{\beforetocpartspace}{0pt}
\newcommand{\aftertocpartspace}{0pt}
\newcommand{\beforetocchapterspace}{0pt}
\newcommand{\aftertocchapterspace}{0pt}
\newcommand{\beforelofchapterspace}{0pt}
\newcommand{\afterlofchapterspace}{0pt}
\newcommand{\beforelotchapterspace}{0pt}
\newcommand{\afterlotchapterspace}{0pt}
\newcommand{\beforelovchapterspace}{0pt}
\newcommand{\afterlovchapterspace}{0pt}
\newcommand{\beforelodchapterspace}{0pt}
\newcommand{\afterlodchapterspace}{0pt}
\newcommand{\beforeloqchapterspace}{0pt}
\newcommand{\afterloqchapterspace}{0pt}
\newcommand{\beforelocchapterspace}{0pt}
\newcommand{\afterlocchapterspace}{0pt}
\newcommand{\beforelolchapterspace}{0pt}
\newcommand{\afterlolchapterspace}{0pt}
\newcommand{\beforeloechapterspace}{0pt}
\newcommand{\afterloechapterspace}{0pt}

%-- Part ToC layout

%\newcommand{\parttoclayoutbasic}[1]{%
%  \parbox{\linewidth}{\centering\Large\tocfont\spacedsmallcaps{#1}}
%  \par\vspace{.5\baselineskip}\pgfornament[width=.4\linewidth,color=secondcolor]{89}
%}
\newcommand{\parttoclayout}[1]{%
  \begin{tcolorbox}[
    enhanced jigsaw,
    colframe=darkelectricblue, colback=maincolor!20,
    fontupper={\Huge\titlefont},
    arc = 0pt, boxrule = 0pt, boxsep = 0pt,
    left = 16pt, right = 16pt, top = 4pt, bottom = 4pt,
    %drop shadow=firstcolor,
    %drop fuzzy shadow=firstcolor,
    shadow={4pt}{-4pt}{0pt}{firstcolor},
    %before skip={4pt plus 2pt minus 2pt},
    %after skip={4pt plus 1pt minus 2pt},
    %after skip={2pt plus 1pt minus 1pt},
    before skip={4pt plus 1pt minus 1pt},
    after skip={0pt plus 1pt minus 1pt},
    %nobeforeafter,
    oversize]
    \hypersetup{linkcolor=secondcolor}
    \textcolor{black}{\spaceskip .25em%
      \frenchtextnumberpart{jazzpart} \jazzpartname\space\textemdash\space}%
    %- Below \spaceskip is given for inter-word spacing (no more inter-word spacing with fontspec)
    %- Other solutions may be settled with \textsl microtype macro or \parskipfill redefining
    %- See, e.g.: https://tex.stackexchange.com/questions/270906/
    %\addtracked[16]{\spaceskip .5em\relax#1}\textcolor{firstcolor}{\enspace\hrulefill}
    \addtracked[14]{\spaceskip .36em\relax#1}\textcolor{firstcolor}{~~\hrulefill}%
  \end{tcolorbox}%
}

%-- Chapter ToC layout

%- Define original Medina's \chaptertoclayout with the `framed' package (leads to page break issues)
\newcommand*{\jazzchaptername}{}
\newcommand{\leftbarchaptertoclayout}[1]{%
  \setlength{\fboxsep}{0pt}
  \parbox{\tocnumberWidth}{\hfill\Huge\bfseries\scshape\color{secondcolor}\thecontentspage}%
  \vspace*{-2.5\baselineskip}%
  \begin{tocleftbar}
    \ifdefempty{\jazzchaptername}{}{% \ifdefempty is defined by the `etoolbox' package
      \textsc{\small\tocfont\textcolor{black!55}{\jazzchaptername~\normalfont\thecontentslabel}}%
      \newline}
    \Large\tocfont\spacedsmallcaps{#1}
  \end{tocleftbar}
  \addvspace{-2\baselineskip}
}
%- Define \chaptertoclayout with the `tcolorbox' package (no page break issue)
\newcommand{\tcboxchaptertoclayout}[1]{%
  \begin{tcolorbox}[
    %use height from group=chaptertocLayout,% this option needs two LaTeX runs
    colframe=white, colback=white,
    fontupper={\Huge\bfseries\scshape\color{secondcolor}},
    arc=0pt, boxrule=0pt, boxsep=0pt,% default=1mm
    left=0pt, right=0pt,% additional to boxsep, default=4mm
    top=4pt, bottom=0pt,% default=2mm
    halign=flush right, valign=center,
    width=\tocnumberWidth,%-\tocnumberSep
    before={}, after=\hspace{\tocnumberSep},
    box align=top,% See p.79
    before skip={4pt plus 2pt minus 2pt},
    ]\thecontentspage%
  \end{tcolorbox}%
  \begin{tcolorbox}[% \tcbox macro can't be used here: line breaks are not allowed (see doc. p.14)
    enhanced,
    %height=2.25cm, %add to height=10pt, %equal height group=chaptertocLayout,
    add to natural height=6pt,
    colframe=secondcolor, colback=white,
    fontupper={\tocfont},
    arc=0pt, boxrule=0pt, boxsep=0pt,% default=1mm
    left=\tocnumberSep, right=0pt, % additional to boxsep, default=4mm
    top=0pt, bottom=0pt,% default=2mm
    %leftrule=2pt, %rightrule=6mm, %middle = 2pt,% additional to boxsep
    frame hidden,
    borderline west={2pt}{0pt}{secondcolor},
    %drop shadow=firstcolor,
    %drop fuzzy shadow=firstcolor,
    %shadow={4pt}{-4pt}{0pt}{firstcolor},
    before={}, after={},% after={\newline},
    after skip={0pt plus 2pt minus 2pt},
    halign=flush left, valign=top,
    %text width=\textwidth-\tocnumberWidth-2\tocnumberSep-2pt,% 2pt = left rule width
    width=\textwidth-\tocnumberWidth-\tocnumberSep,
    box align=top,% See p.79
    ]\ifdefempty{\jazzchaptername}
      {\small ~~\\% for backmatter, other way: use \if@mainmatter \ifdoc@appendix conditionals
        \Large\spacedsmallcaps{#1}}
      {\scshape\small\textcolor{black!55}{\jazzchaptername~\normalfont\thecontentslabel}\\
        \Large\spacedsmallcaps{#1}}%
  \end{tcolorbox}%
}
%\let\chaptertoclayout=\leftbarchaptertoclayout
\let\chaptertoclayout=\tcboxchaptertoclayout

%- Avoid page break after chapter ToC heading (ToC, LoF, etc.)
%- The mdframed and tcolorbox have their own page break algorithm. For solution, see:
%- https://tex.stackexchange.com/questions/348095/how-to-get-nonbreaking-vertical-space
%- https://tex.stackexchange.com/questions/348994/understanding-needspace
%- https://tex.stackexchange.com/questions/80080/
%- (how-to-avoid-defined-para-from-appearing-at-bottom-of-page)

\newlength{\nobreakskip}
\newlength{\targetspace} %debugging artifact, so I could output
\newsavebox\needspacebox
\newenvironment{needspaceeval}[1][0pt]{%
  \setlength{\nobreakskip}{#1}%
  \begin{lrbox}{\needspacebox}%
  }{%
  \end{lrbox}
  \setlength{\targetspace}{\dimexpr\ht\needspacebox+\dp\needspacebox+\nobreakskip\relax}%
  \needspace{\targetspace}%
  \noindent\usebox\needspacebox%
}
%\newcommand{\chaptertoclayout}[1]{%
%  \begin{needspaceeval}[\baselineskip]\tcboxchaptertoclayout{#1}\end{needspaceeval}}

%-- Entries styles of the main ToC

%- ÇA FOUT UN BOUZIN INOMMABLE ! → "overfull \hbox (?pt too wide) in paragraph..." TODO TODO FIXME!
%- GRAND DÉLIRE ! POUR LE MOMENT, SEULE SOLUTION VIABLE → \contentsmargin{0pt} À CHAQUE ENTRÉE
%- Global setting, but may be setted locally (see documentation), without = spurious overfull
%\contentsmargin{0pt}% Right margin of the table of contents

\newcommand\toccontentspage[1][\thecontentspage]{% Derived from `titletoc' package
  \hb@xt@\@pnumwidth{\hfil\footnotesize\textit{#1}}%
  \hspace*{-\@pnumwidth}}

%- Main traditional "full page chapter" ToC (conditional between "Workbook" and "Handbook")
\ifdoc@article
  %- Workbook/article main ToC: no chapter entry
  \titlecontents{section}
    [10pt]% left indentation
    {\contentsmargin{0pt}\addvspace{.5ex}\small\tocfont}
    {\contentslabel{12pt}}% numbered entry format
    {}% numberless entry format
    %{\hspace{0.5em}\nobreak\textcolor{jazzgray}{\small\itshape\thecontentspage}}% page number
    {}% no page numbering
  \titlecontents{subsection}
    [26pt]% left indentation
    {\contentsmargin{0pt}\small\normalfont}% above code
    {\contentslabel{16pt}}% numbered entry format
    {}% numberless entry format
    {\hspace{0.5em}\nobreak\textcolor{maincolor}{\normalfont\small\textit{\thecontentspage}}}
    %{}% no page numbering
  \titlecontents*{subsubsection}
    [24pt]% left indentation
    {\contentsmargin{0pt}\footnotesize\normalfont}
    %{\makebox[16pt][l]{\thecontentslabel}}% box = trop rigide
    {\thecontentslabel\hskip.5em plus .1em minus .25em}
    %{\thecontentslabel\spaceskip=.75em plus .25em minus .25em}
    {}
    {\normalfont\small}
    %\spaceskip=.9\fontdimen2\font plus .2\fontdimen3\font minus 2.2\fontdimen4\font}
    [\allowbreak\hskip.333em plus .15em minus .3em\textcolor{maincolor}{\textemdash{}}%
                \hskip.333em plus .15em minus .2em\allowbreak]
    [\parfillskip 0pt plus 1fil\relax]
  \titlecontents*{overparagraph}
    [5pt]
    {\scriptsize}%\contentsmargin{0pt}}
    {\thecontentslabel.\hskip.5em}
    {}
    {\hskip.33em\allowbreak\normalfont\footnotesize\allowbreak}%
    [\allowbreak\hskip.33em]%
    [\parfillskip 0pt plus 1fil\relax]
\else
  %- Handbook/book main ToC
  \titlecontents{part}[0pt]
    {\contentsmargin{0pt}}
    {\parttoclayout}
    {}{}[]
  \titlecontents{chapter}[0pt]
    {\contentsmargin{0pt}}
    {\let\jazzchaptername=\chaptertitlename\chaptertoclayout}
    {}{}[\nopagebreak]
    %\addtocontents{tdm}{\protect\setcounter{unbalance}{0}}
  \titlecontents{appendixchapter}[0pt]
    {\contentsmargin{0pt}}
    {\let\jazzchaptername=\appendixname\chaptertoclayout}
    {}{}[\nopagebreak]
  \titlecontents{backchapter}[0pt]
    {\contentsmargin{0pt}}
    {\chaptertoclayout}
    {}{}[\nopagebreak]
  \titlecontents{section}[\tocnumberWidth+\tocnumberSep+12pt]
    {\vskip 4pt plus 1pt minus 2.5pt\small\tocfont}
    {\contentslabel{12pt}}
    {}{}[\vskip .75ex plus .25ex minus .25ex]
  \titlecontents{subsection}[\tocnumberWidth+\tocnumberSep+12pt+16pt]
    {\vskip 1pt plus 1pt minus 1pt\small}
    {\contentslabel{16pt}}%{\makebox[20pt][l]{\normalfont\thecontentslabel}}
    {}{\nobreak\color{darkgray}\toccontentspage}
    %[\vspace{.1\baselineskip plus .05\baselineskip minus .05\baselineskip}]
  \titlecontents*{subsubsection}[\tocnumberWidth+\tocnumberSep+12pt+16pt]
    {\addvspace{-.25ex}\contentsmargin{0cm}\footnotesize}
    {\thecontentslabel\hskip.5em plus .25em minus .1em}{}
    {}%
    %{\hskip.33em\allowbreak\normalfont
    % \textcolor{jazzgray}{\scriptsize[\itshape\thecontentspage\upshape]}\allowbreak}%
    [\allowbreak\hskip.333em plus .15em minus .3em\textcolor{maincolor}{\textemdash{}}%
                \hskip.333em plus .15em minus .2em\allowbreak]
    %[\parfillskip=0pt plus 1fil\relax]% LuaTeX: fi, fil, fill, filll TeX.SE: /questions/350669/
    %[\parfillskip=0pt plus .75\textwidth\relax]
    %[\hfill]
  \titlecontents*{overparagraph}[5pt]
    {\contentsmargin{0pt}\footnotesize}
    {\thecontentslabel.\hskip.5em}{}
    {\hskip.33em\allowbreak\normalfont\footnotesize\allowbreak}%
    [\allowbreak\hskip.33em]%
    [\parfillskip 0pt plus 1fil\relax]
\fi% article-workbook/book-handbook ToC

%-- Redefining ToC entry from the `titletoc' package to add control of the layout for partial ToCs
%-- https://tex.stackexchange.com/questions/57202/

%\AtBeginDocument{%
%  \g@addto@macro{\tableofcontents}{\let\l@lastnumber\relax}
%  \let\old@ttl@tocentry\ttl@tocentry
%  \def\ttl@tocentry#1#2#3#4#5#6#7#8{%
%    \edef\l@thisnumber{#8}% store current page number
%    \old@ttl@tocentry{#1}{#2}{#3}{#4}{#5}{#6}{#7}{%
%      \ifnum\ttl@b>1\relax% the value here determines which levels will ALWAYS have page numbers
%        \ifx\l@thisnumber\l@lastnumber% if the numbers are the same
%          \leavevmode\phantom{\l@thisnumber}%
%        \else% if the numbers differ
%          \l@thisnumber
%        \fi
%      \else% if the level has to have the page number always
%        \l@thisnumber
%      \fi%
%    }%
%    \edef\l@lastnumber{#8}% save the page number for the next ToC line
%  }
%}

%-- For controling \numberline see:
%-- https://tex.stackexchange.com/questions/45569/inline-table-of-contents

%-- Redefining the style to match the needs of the partial side chapter Tocs

\titlecontents{csection}
  [8pt]% left indentation
  {\addvspace{.5ex}\contentsmargin{0pt}\tocfont\footnotesize}% contentsmargin = rigth margin
  {\contentslabel{8pt}}% numbered entry format
  {}% numberless entry format
  %{\hspace{0.5em}\nobreak\textcolor{jazzgray}{\small\itshape\thecontentspage}}% page number
  {}% no page numbering
\titlecontents{csubsection}
  [20pt]% left indentation
  {\contentsmargin{0pt}\normalfont\scriptsize}% above code
  {\contentslabel{12pt}}% numbered entry format
  {}% numberless entry format
  {\hspace{0.5em}\nobreak\textcolor{maincolor}{\normalfont\scriptsize\textit{\thecontentspage}}}
  %{}% no page numbering
\titlecontents*{csubsubsection}
  [20pt]% left indentation
  {\contentsmargin{0pt}%
   \normalfont\fontsize{6.4pt}{7pt}\selectfont
   \setlength{\RaggedRightLeftskip}{20pt}% From ragged2e.sty: left margin
   \setlength{\RaggedRightRightskip}{0pt plus 4em}% Right margin tolerance, default=2em
   \RaggedRight%
  }
  %{\makebox[16pt][l]{\thecontentslabel}}% with makebox = too rigid
  {\thecontentslabel\nobreak\hskip 2pt plus .4pt minus .4pt}% if fill right
  {}{}
  %\spaceskip=.9\fontdimen2\font plus .2\fontdimen3\font minus 2.2\fontdimen4\font}
  [\hskip 2pt plus .4pt minus .4pt%
   \raisebox{.75pt}{\color{maincolor}\normalfont\fontsize{3pt}{0pt}\selectfont\faSquare}%
   \hskip 2pt plus .4pt minus .4pt\allowbreak]
  %[\parfillskip 0pt plus 1filll\relax]

%-- Redefining the style to match the needs of the partial part Tocs

\titlecontents{pchapter}
  [0pt]% Indenting
  {\vspace{\baselineskip}\contentsmargin{0pt}}%
  {\parbox{\tocnumberWidth}{\hfill\large\bfseries\scshape\color{secondcolor}\thecontentspage}%
    \vspace*{-2.3\baselineskip}%
    \leftbar\textsc{\footnotesize\tocfont\textcolor{firstcolor}{%
                    \chaptertitlename~\normalfont\thecontentslabel\\}}%
                    \normalsize\tocfont\spacedsmallcaps}%
  {}%
  {\endleftbar\addvspace{-.5\baselineskip}}
  [\vspace{0pt}]
\titlecontents{pappendixchapter}
  [0pt]% Indenting
  {\vspace{\baselineskip}\contentsmargin{0pt}}%
  {\parbox{\tocnumberWidth}{\hfill\large\bfseries\scshape\color{secondcolor}\thecontentspage}%
    \vspace*{-2.3\baselineskip}%
    \leftbar\textsc{\footnotesize\tocfont\textcolor{firstcolor}{%
                    \appendixname~\normalfont\thecontentslabel\\}}%
                    \normalsize\tocfont\spacedsmallcaps}%
  {}%
  {\endleftbar\addvspace{-.5\baselineskip}}
  [\vspace{0pt}]
\titlecontents{pbackchapter}
  [0pt]% Indenting
  {\vspace{\baselineskip}\contentsmargin{0pt}}%
  {\parbox{\tocnumberWidth}{\hfill\large\bfseries\scshape\color{secondcolor}\thecontentspage}%
    \vspace*{-2.3\baselineskip}%
    \leftbar\normalsize\tocfont\spacedsmallcaps}%
  {}%
  {\endleftbar\addvspace{-.5\baselineskip}}
  [\vspace{0pt}]
\titlecontents{psection}
  [1.5\tocnumberWidth+20pt]%[\tocnumberWidth]%[23pt]
  {\addvspace{.5ex}\small\tocfont}
  {\contentslabel{14pt}}
  {}
  {}%{\hspace{0.5em}\nobreak\normalfont\itshape\color{darkgray}\contentspage}


%---------------------------------------------------------------------------------------------------
%---- Lists of figures, tables, etc.
%---------------------------------------------------------------------------------------------------

%- \patchcmd{<cmd>}{<search>}{<replace>}{<success>}{<failure>}
%\patchcmd{\@chapter}{\addtocontents{lof}{\protect\addvspace{10\p@}}}{}{}{LoF Patch failed}% LoF
%\patchcmd{\@chapter}{\addtocontents{lot}{\protect\addvspace{10\p@}}}{}{}{LoT Patch failed}% LoT
%\apptocmd{\@chapter}{\addtocontents{lof}{\protect\addvspace{-5\p@}}}{}{}% LoF

%https://tex.stackexchange.com/questions/96969/
%add-the-word-algorithm-before-each-entry-in-the-list-of-algorithms
%\let\oldlistoffigures\listoffigures
%\renewcommand{\listoffigures}{%
%  \begingroup%
%  \let\oldnumberline\numberline%
%  \renewcommand{\numberline}{Fig.~\oldnumberline}%
%  \oldlistoffigures%
%  \endgroup}

%-- Shortcut for "List of..." references

%- Tcolorbox definition
%\newcommand{\tcblistof}[3][\section]{%
%  #1{#3}%
%  \@starttoc{#2}%
%}

\newcommand{\listofexercises}{%
  %\tcblistof[\chapter*]{loe}{\listexercisename}%
  \chapter*{\listexercisename}
  %\hypertarget{listofexercises}{}
  \@starttoc{loe}
}
\newcommand{\listofquizzes}{%
  %\tcblistof[\chapter*]{loq}{\listquizname}%
  \chapter*{\listquizname}
  %\hypertarget{listofquizzes}{}
  \@starttoc{loq}
}
\renewcommand{\listofvideos}{% There is a side effect with the 'newfloat' package (see doc. p.4)
  %\tcblistof[\chapter*]{lov}{\listvideoname}%
  \chapter*{\listvideoname}
  \@starttoc{lov}
}
\renewcommand{\listofcodes}{% \renewcommand if defined with the 'newfloat' package
  %\tcblistof[\chapter*]{loc}{\listcodename}%
  \chapter*{\listcodename}
  \@starttoc{loc}
}
\renewcommand{\listoflistings}{% \renewcommand because defined by the 'minted' package
  %\tcblistof[\chapter*]{loc}{\listlistingname}%
  \chapter*{\listlistingname}
  \@starttoc{lol}
}
\newcommand{\listofdocuments}{%
  %\tcblistof[\chapter*]{lod}{\listdocumentname}%
  \chapter*{\listdocumentname}
  \@starttoc{lod}
}

%-- Layout of lists of something (the same as ToC, i.e. chapters)

%-- With titletoc package, see: https://tex.stackexchange.com/questions/353947/
%-- (change-tcolorbox-tcblistof-font-formatting-to-match-documents-other-lists)

\newcommand\listcontentspage[1][\thecontentspage]{% Derived from `titletoc' package
  \hb@xt@\@pnumwidth{\hfil\footnotesize[\textit{#1}]}%
  \hspace*{-\@pnumwidth}}

\ifdoc@article\else
  \titlecontents{figure}[\tocnumberWidth+\tocnumberSep+2pt]
    {\small}
    {\contentspush{\figurename\space\makebox[18pt][l]{\small\thecontentslabel}\textemdash\enspace}}
    {}
    {\nobreak\hspace{.5em}\textcolor{darkgray}{\footnotesize[\textit{\thecontentspage}]}\allowbreak}
    [\vskip 0pt plus .5pt minus .5pt]
  \titlecontents{table}[\tocnumberWidth+\tocnumberSep+2pt]
    {\small}
    {\contentspush{\tablename\space\makebox[18pt][l]{\small\thecontentslabel}\textemdash\enspace}}
    {}
    {\nobreak\hspace{.5em}\textcolor{darkgray}{\footnotesize[\textit{\thecontentspage}]}\allowbreak}
    [\vskip 0pt plus .5pt minus .5pt]
  \titlecontents{exercise}[\tocnumberWidth+\tocnumberSep+2pt]
    {\small}
    {\contentspush{\exercisename\space\makebox[18pt][l]{\small\thecontentslabel}\textemdash\enspace}}
    {}
    {\nobreak\hspace{.5em}\textcolor{darkgray}{\footnotesize[\textit{\thecontentspage}]}\allowbreak}
    [\vskip 0pt plus .5pt minus .5pt]
  % Below it leads to an error with update 2019/09/09 of the `titlesec' package: "already defined"
  %\newcommand{\ttll@exercise}{-1000}
  \titlecontents{quiz}[\tocnumberWidth+\tocnumberSep+2pt]
    {\small}
    {\contentspush{\quizname\space\makebox[18pt][l]{\small\thecontentslabel}\textemdash\enspace}}
    {}
    {\nobreak\hspace{.5em}\textcolor{darkgray}{\footnotesize[\textit{\thecontentspage}]}\allowbreak}
    [\vskip 0pt plus .5pt minus .5pt]
  % Below it leads to an error with update 2019/09/09 of the `titlesec' package: "already defined"
  %\newcommand{\ttll@quiz}{-1000}
  \titlecontents{video}[\tocnumberWidth+\tocnumberSep+2pt]
    {\small}
    {\contentspush{\videoname\space\makebox[18pt][l]{\small\thecontentslabel}\textemdash\enspace}}
    {}
    {\nobreak\hspace{.5em}\textcolor{darkgray}{\footnotesize[\textit{\thecontentspage}]}\allowbreak}
    [\vskip 0pt plus .5pt minus .5pt]
  % Below it leads to an error with update 2019/09/09 of the `titlesec' package: "already defined"
  %\newcommand{\ttll@video}{-1000}
  \titlecontents{code}[\tocnumberWidth+\tocnumberSep+2pt]
    {\small}
    {\contentspush{\codename\space\makebox[18pt][l]{\small\thecontentslabel}\textemdash\enspace}}
    {}
    {\nobreak\hspace{.5em}\textcolor{darkgray}{\footnotesize[\textit{\thecontentspage}]}\allowbreak}
    [\vskip 0pt plus .5pt minus .5pt]
  % Below it leads to an error with update 2019/09/09 of the `titlesec' package: "already defined"
  %\newcommand{\ttll@code}{-1000}
  \titlecontents{listing}[\tocnumberWidth+\tocnumberSep+2pt]
    {\small}
    {\contentspush{\listingname\space\makebox[18pt][l]{\small\thecontentslabel}\textemdash\enspace}}
    {}
    {\nobreak\hspace{.5em}\textcolor{darkgray}{\footnotesize[\textit{\thecontentspage}]}\allowbreak}
    [\vskip 0pt plus .5pt minus .5pt]
  % Below it leads to an error with update 2019/09/09 of the `titlesec' package: "already defined"
  %\newcommand{\ttll@listing}{-1000}
  \titlecontents{document}[\tocnumberWidth+\tocnumberSep+2pt]
    {\small}
    {\contentspush{\documentname\space\makebox[18pt][l]{\small\thecontentslabel}\textemdash\enspace}}
    {}
    {\nobreak\hspace{.5em}\textcolor{darkgray}{\footnotesize[\textit{\thecontentspage}]}\allowbreak}
    [\vskip 0pt plus .5pt minus .5pt]
  % Below it leads to an error with update 2019/09/09 of the `titlesec' package: "already defined"
  %\newcommand{\ttll@document}{-1000}
\fi

%-- List of exercises (with `tcolorbox' package: old fashion)

%\newlength{\exerciseindent}
%\setlength{\exerciseindent}{1.25\tocnumberWidth}
%\addtolength{\exerciseindent}{16pt}

%- It works, but we want the same list of exercise layout as for figure and table (using titletoc)
%\renewcommand*{\l@tcolorbox}[2]{%
%  % #1 is the exercise number and its caption text
%  % #2 is the page number on which the exercise appears
%  \leftskip 0em
%  \rightskip 0em
%  \parfillskip 0em plus 1fil
%  %\parindent 16pt
%  \parindent \exerciseindent
%  %\parindent 0.0em
%  \@afterindenttrue
%  \interlinepenalty\@M
%  \leavevmode
%  \@tempdima 12pt
%  %\@tempdima 2.0em
%  \advance\leftskip\@tempdima
%  \null\nobreak\hskip -\leftskip
%  \small{#1}\nobreak\qquad\nobreak#2%
%  \par%
%}

%---
%- The figure/table/etc. environment/command does the job: the first time it is used after
%- a \chapter command, it writes the information of the chapter to the LoF/LoT/etc.
%---

%--- FIXME TODO TAKE CARE!!! Grosse bidouille !!!
%- Tel quel, l'environnement exfigure avec le flag noFigs n'affiche pas le chapître dans la liste
%- des figures, si la première occurence de exfigure est située dans la partie solution/tcblower
%- d'un environnement "exercise". Grace au compteur indépendant exfigure, on corrige cela.
%---

\newif\ifdoc@appendix
%\pretocmd{\appendixchapter}{\global\doc@appendixtrue}{}{}

\ifdoc@article\else
  \ifdoc@appendix
    \@addtoreset{exfigurecaptioncounter}{appendixchapter}
    \@addtoreset{extablecaptioncounter}{appendixchapter}
    \@addtoreset{exlistingcaptioncounter}{appendixchapter}
    \@addtoreset{excodecaptioncounter}{appendixchapter}
    \@addtoreset{exfigurecounter}{appendixchapter}
    \@addtoreset{extablecounter}{appendixchapter}
    \@addtoreset{exlistingcounter}{appendixchapter}
    \@addtoreset{excodecounter}{appendixchapter}
    \@addtoreset{tmpfigurecounter}{appendixchapter}
    \@addtoreset{tmptablecounter}{appendixchapter}
    \@addtoreset{tmplistingcounter}{appendixchapter}
    \@addtoreset{tmpcodecounter}{appendixchapter}
    \@addtoreset{tmpvideocounter}{appendixchapter}
    \@addtoreset{tmpdocumentcounter}{appendixchapter}
  \else
    \@addtoreset{exfigurecaptioncounter}{chapter}
    \@addtoreset{extablecaptioncounter}{chapter}
    \@addtoreset{exlistingcaptioncounter}{chapter}
    \@addtoreset{excodecaptioncounter}{chapter}
    \@addtoreset{exfigurecounter}{chapter}
    \@addtoreset{extablecounter}{chapter}
    \@addtoreset{exlistingcounter}{chapter}
    \@addtoreset{excodecounter}{chapter}
    \@addtoreset{tmpfigurecounter}{chapter}
    \@addtoreset{tmptablecounter}{chapter}
    \@addtoreset{tmplistingcounter}{chapter}
    \@addtoreset{tmpcodecounter}{chapter}
    \@addtoreset{tmpvideocounter}{chapter}
    \@addtoreset{tmpdocumentcounter}{chapter}
  \fi
\fi

\AtBeginDocument{%
  \AtBeginEnvironment{figure}{%
    \iftoggle{noFigs}{%
      %\addtocontents{lof}{\protect\addvspace{-6pt plus 2pt minus 2pt}}% Before chapter LoF heading
      \ifdoc@appendix
        \addtocontents{lof}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lof}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
            }{}{%
            \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noFigs}%
      %\addtocontents{lof}{\protect\addvspace{-6pt plus 1.5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{jazzfigure}{%
    \iftoggle{noFigs}{%
      %\addtocontents{lof}{\protect\addvspace{-6pt plus 2pt minus 2pt}}% Before chapter LoF heading
      \ifdoc@appendix
        \addtocontents{lof}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lof}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
            }{}{%
            \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noFigs}%
      %\addtocontents{lof}{\protect\addvspace{-6pt plus 1.5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{jazzfigure*}{%
    \iftoggle{noFigs}{%
      %\addtocontents{lof}{\protect\addvspace{-6pt plus 2pt minus 2pt}}% Before chapter LoF heading
      \ifdoc@appendix
        \addtocontents{lof}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lof}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
            }{}{%
            \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noFigs}%
      %\addtocontents{lof}{\protect\addvspace{-6pt plus 1.5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{wrapfigure}{%
    \iftoggle{noFigs}{%
      %\addtocontents{lof}{\protect\addvspace{-6pt plus 2pt minus 2pt}}% Before chapter LoF heading
      \ifdoc@appendix
        \addtocontents{lof}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lof}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
            }{}{%
            \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noFigs}%
      %\addtocontents{lof}{\protect\addvspace{-6pt plus 1.5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{marginfigure}{%
    \iftoggle{noFigs}{%  BUT THERE IS STILL A BUG if it is the first one in a chapter WHY?
      %\addtocontents{lof}{\protect\addvspace{-6pt plus 2pt minus 2pt}}% Before chapter LoF heading
      \ifdoc@appendix
        \addtocontents{lof}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lof}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
            }{}{%
            \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noFigs}%
      %\addtocontents{lof}{\protect\addvspace{-6pt plus 1.5pt minus 1.5pt}}%
    }{}%
  }
  % Side figure command must be patched (using \captionof to be at the right place in the LoF)
  \pretocmd{\sidefigure}{% Patching \sidefigure doesn't detect the first chapter margin figure
    \iftoggle{noFigs}{%  BUT THERE IS STILL A BUG: with a preceeding subfigure ? with a tikzpicture?
      %\addtocontents{lof}{\protect\addvspace{-6pt plus 2pt minus 2pt}}% Before chapter LoF heading
      \ifdoc@appendix
        \addtocontents{lof}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lof}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
            }{}{%
            \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noFigs}%
      %\addtocontents{lof}{\protect\addvspace{-6pt plus 1.5pt minus 1.5pt}}%
    }{}%
  }{}{}
  \AtBeginEnvironment{table}{%
    \iftoggle{noTabs}{%
      %\addtocontents{lot}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoT heading
      \ifdoc@appendix
        \addtocontents{lot}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lot}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noTabs}%
      \addtocontents{lot}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{margintable}{%
    \iftoggle{noTabs}{%
      %\addtocontents{lot}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoT heading
      \ifdoc@appendix
        \addtocontents{lot}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lot}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noTabs}%
      \addtocontents{lot}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{jazztable}{%
    \iftoggle{noTabs}{%
      %\addtocontents{lot}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoT heading
      \ifdoc@appendix
        \addtocontents{lot}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lot}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noTabs}%
      \addtocontents{lot}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{jazztable*}{%
    \iftoggle{noTabs}{%
      %\addtocontents{lot}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoT heading
      \ifdoc@appendix
        \addtocontents{lot}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lot}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noTabs}%
      \addtocontents{lot}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{wraptable}{%
    \iftoggle{noTabs}{%
      %\addtocontents{lot}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoT heading
      \ifdoc@appendix
        \addtocontents{lot}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lot}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noTabs}%
      \addtocontents{lot}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{margintable}{%
    \iftoggle{noTabs}{%
      %\addtocontents{lot}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoT heading
      \ifdoc@appendix
        \addtocontents{lot}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lot}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noTabs}%
      \addtocontents{lot}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }
  % Side table command must be patched (using \captionof to be at the right place in the LoT)
  \pretocmd{\sidetable}{%
    \iftoggle{noTabs}{%
      %\addtocontents{lot}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoT heading
      \ifdoc@appendix
        \addtocontents{lot}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lot}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noTabs}%
      \addtocontents{lot}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }{}{}
  \AtBeginEnvironment{video}{%
    \iftoggle{noVids}{%
      %\addtocontents{lov}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoV heading
      \ifdoc@appendix
        \addtocontents{lov}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lov}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noVids}%
      \addtocontents{lov}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{wrapvideo}{%
    \iftoggle{noVids}{%
      %\addtocontents{lov}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoV heading
      \ifdoc@appendix
        \addtocontents{lov}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lov}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noVids}%
      \addtocontents{lov}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{marginvideo}{%
    \iftoggle{noVids}{%
      \addtocontents{lov}{\protect\addvspace{-10pt plus 2pt minus 2pt}}% Before chapter LoV heading
      \ifdoc@appendix
        \addtocontents{lov}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lov}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noVids}%
      \addtocontents{lov}{\protect\addvspace{-4pt plus 1.5pt minus 1.5pt}}%
    }{}%
  }
  % Side video command must be patched (using \captionof to be at the right place in the LoV)
  \pretocmd{\sideVideo}{%
    \iftoggle{noVids}{%
      %\addtocontents{lov}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoT heading
      \ifdoc@appendix
        \addtocontents{lov}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lov}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noVids}%
      \addtocontents{lov}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }{}{}
  \AtBeginEnvironment{algorithm}{%
    \iftoggle{noCodes}{%
      %\addtocontents{loc}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoC heading
      \ifdoc@appendix
        \addtocontents{loc}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{loc}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noCodes}%
      \addtocontents{loc}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{code}{%
    \iftoggle{noCodes}{%
      %\addtocontents{loc}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoC heading
      \ifdoc@appendix
        \addtocontents{loc}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{loc}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noCodes}%
      \addtocontents{loc}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{jazzcode}{%
    \iftoggle{noCodes}{%
      %\addtocontents{loc}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoC heading
      \ifdoc@appendix
        \addtocontents{loc}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{loc}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noCodes}%
      \addtocontents{loc}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{jazzcode*}{%
    \iftoggle{noCodes}{%
      %\addtocontents{loc}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoC heading
      \ifdoc@appendix
        \addtocontents{loc}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{loc}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noCodes}%
      \addtocontents{loc}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{listing}{%
    \iftoggle{noListings}{%
      %\addtocontents{loc}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoC heading
      \ifdoc@appendix
        \addtocontents{lol}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lol}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noListings}%
      \addtocontents{lol}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{jazzlisting}{%
    \iftoggle{noListings}{%
      %\addtocontents{loc}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoC heading
      \ifdoc@appendix
        \addtocontents{lol}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lol}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noListings}%
      \addtocontents{lol}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{jazzlisting*}{%
    \iftoggle{noListings}{%
      %\addtocontents{loc}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoC heading
      \ifdoc@appendix
        \addtocontents{lol}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lol}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noListings}%
      \addtocontents{lol}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{tcbexercise}{%
    \iftoggle{noExos}{% If no tcbexercise before
      %\addtocontents{loe}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoE heading
      \ifdoc@appendix
        \addtocontents{loe}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{loe}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
            }{}{%
            \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noExos}%
      \addtocontents{loe}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{exercise}{%
    \iftoggle{noExos}{% If no exercise before
      %\addtocontents{loe}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoE heading
      \ifdoc@appendix
        \addtocontents{loe}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{loe}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
            }{}{%
            \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noExos}%
      \addtocontents{loe}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{quiz}{%
    \iftoggle{noQuiz}{% If no quiz before
      %\addtocontents{loq}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoQ heading
      \ifdoc@appendix
        \addtocontents{loq}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{loq}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
            }{}{%
            \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noQuiz}%
      \addtocontents{loq}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }
% Tcolorbox figure/table environments are also patched at \captionof for completeness
  \AtBeginEnvironment{exfigure}{%
    \iftoggle{noFigs}{%
      %\addtocontents{lof}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoF heading
      \ifdoc@appendix
        \addtocontents{lof}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lof}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
            \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
            }{}{%
            \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noFigs}%
      \addtocontents{lof}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{extable}{%
    \iftoggle{noTabs}{%
      %\addtocontents{lot}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoT heading
      \ifdoc@appendix
        \addtocontents{lot}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lot}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noTabs}%
      \addtocontents{lot}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{exlisting}{%
    \iftoggle{noListings}{%
      %\addtocontents{lol}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoT heading
      \ifdoc@appendix
        \addtocontents{lol}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lol}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noListings}%
      \addtocontents{lol}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }
  \AtBeginEnvironment{excode}{%
    \iftoggle{noCodes}{%
      %\addtocontents{loc}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoT heading
      \ifdoc@appendix
        \addtocontents{loc}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{loc}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noCodes}%
      \addtocontents{loc}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }
  % The two document commands \webdoc and \hrefdoc must be patched (to be at the right place in LoD)
  \pretocmd{\webdoc}{%
    \iftoggle{noDocs}{%
      %\addtocontents{lod}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoD heading
      \ifdoc@appendix
        \addtocontents{lod}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lod}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noDocs}%
      \addtocontents{lod}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }{}{}
  \pretocmd{\hrefdoc}{%
    \iftoggle{noDocs}{%
      %\addtocontents{lod}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoD heading
      \ifdoc@appendix
        \addtocontents{lod}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lod}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noDocs}%
      \addtocontents{lod}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }{}{}
  \pretocmd{\textdoc}{%
    \iftoggle{noDocs}{%
      %\addtocontents{lod}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoD heading
      \ifdoc@appendix
        \addtocontents{lod}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lod}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noDocs}%
      \addtocontents{lod}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }{}{}
  \pretocmd{\pdfdoc}{%
    \iftoggle{noDocs}{%
      %\addtocontents{lod}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoD heading
      \ifdoc@appendix
        \addtocontents{lod}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lod}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noDocs}%
      \addtocontents{lod}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }{}{}
  \pretocmd{\pdfwatch}{%
    \iftoggle{noDocs}{%
      %\addtocontents{lod}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoD heading
      \ifdoc@appendix
        \addtocontents{lod}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lod}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noDocs}%
      \addtocontents{lod}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }{}{}
  \pretocmd{\videolink}{%
    \iftoggle{noVids}{%
      %\addtocontents{lov}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoV heading
      \ifdoc@appendix
        \addtocontents{lov}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lov}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noVids}%
      \addtocontents{lov}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }{}{}
  \pretocmd{\sidevideolink}{%
    \iftoggle{noVids}{%
      %\addtocontents{lov}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoV heading
      \ifdoc@appendix
        \addtocontents{lov}{%
          \protect\contentsline{appendixchapter}{%
            \ifx\thisappendixchapternumber\@empty
            \else
              \protect\numberline{\thisappendixchapternumber}%
            \fi
            \thisappendixchaptertitle
          }{}{%
          \thisappendixchapterHref % hyperref support
          }%
        }%
      \else
        \addtocontents{lov}{%
          \protect\contentsline{chapter}{%
            \ifx\thischapternumber\@empty
            \else
              \protect\numberline{\thischapternumber}%
            \fi
            \thischaptertitle
          }{}{%
          \thischapterHref % hyperref support
          }%
        }%
      \fi
      \global\togglefalse{noVids}%
      \addtocontents{lov}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
    }{}%
  }{}{}
  %\pretocmd{\caption}{%
  %  \iftoggle{noFigs}{%
  %    %\addtocontents{lof}{\protect\addvspace{-4pt plus 2pt minus 2pt}}% Before chapter LoF heading
  %    \ifdoc@appendix
  %      \addtocontents{lof}{%
  %        \protect\contentsline{appendixchapter}{%
  %          \ifx\thisappendixchapternumber\@empty
  %          \else
  %            \protect\numberline{\thisappendixchapternumber}%
  %          \fi
  %          \thisappendixchaptertitle
  %        }{}{%
  %        \thisappendixchapterHref % hyperref support
  %        }%
  %      }%
  %    \else
  %      \addtocontents{lof}{%
  %        \protect\contentsline{chapter}{%
  %          \ifx\thischapternumber\@empty
  %          \else
  %            \protect\numberline{\thischapternumber}%
  %          \fi
  %          \thischaptertitle
  %          }{}{%
  %          \thischapterHref % hyperref support
  %        }%
  %      }%
  %    \fi
  %    \global\togglefalse{noFigs}%
  %    \addtocontents{lof}{\protect\addvspace{-2pt plus .5pt minus 1.5pt}}%
  %  }{}%
  %}{}{}
}

%---------------------------------------------------------------------------------------------------
%---- Headers and footers / Entêtes et pieds de page
%---------------------------------------------------------------------------------------------------

%-- It's better to load the `titleps'' package as an option of the `titlesec'' package
%\RequirePackage{titleps}% if without `titlesec' package, else already loaded (see previous §)

%https://tex.stackexchange.com/questions/313080/modify-page-layout-using-titleps
\ifdoc@article
  \settitlemarks{part,section,subsection,subsubsection}
\else
  \settitlemarks{part,chapter,section,subsection}
  %\settitlemarks{part,chapter,appendixchapter,backchapter,section,subsection}
\fi

%-- Main style for book/handbook
\newpagestyle{main}[\small]{%
  %\setheadrule{.55pt}%
  % Usage: \widenhead[<even-left>][<even-right>]{<odd-left>}{<odd-right>}
  \widenhead[\marginparwidth+\marginparsep][0pt]{0pt}{\marginparwidth+\marginparsep}
  \sethead[\mbox{\llap{\small\thepage\quad\color{black!20}%
              \vline height .75\baselineskip  depth .25\baselineskip}%
              \color{black!50}\quad\spacedlowsmallcaps{\chaptertitle}\hfil}]% even-left
          []% even-center
          []% even-right
          {}%  odd-left
          {}% odd-center
          {\mbox{\hfil{\color{black!50}%
            \spacedlowsmallcaps{\thesection.~~\sectiontitle}\quad}%
            \rlap{\textcolor{black!20}{%
                  \vline height .75\baselineskip  depth .25\baselineskip}%
                  \quad\small\thepage}}% odd-right
          }%
}

%-- "Paper" style for article/workbook
\newpagestyle{paper}[]{%
  %\setheadrule{1pt}%
  %\setfootrule{2pt}%
  \widenhead[\marginparwidth+\marginparsep][0pt]{0pt}{\marginparwidth+\marginparsep}
  \sethead[\mbox{\llap{\small\thepage\quad\color{black!20}%
              \vline height .75\baselineskip  depth .25\baselineskip}%
              \color{black!50}\quad\spacedlowsmallcaps{\@doctitle}\hfil}]% even-left
          []% even-center
          []% even-right
          {}%  odd-left
          {}% odd-center
          {\mbox{\hfil{\color{black!50}%
            \spacedlowsmallcaps{\thesection.~~\sectiontitle}\quad}%
            \rlap{\textcolor{black!20}{%
                  \vline height .75\baselineskip  depth .25\baselineskip}%
                  \quad\small\thepage}}% odd-right
          }
  %\renewcommand\makeheadrule{\color{red}\rule[-1\baselineskip]{\linewidth}{1.4pt}}
}

%-- Redefining plain style for book/handbook
\renewpagestyle{plain}[\small]{%
  %\setheadrule{.55pt}%
  % Usage: \widenhead[<even-left>][<even-right>]{<odd-left>}{<odd-right>}
  \widenhead[0pt][0pt]{0pt}{0pt}
  \sethead[]% even-left
          []% even-center
          []% even-right
          {}%  odd-left
          {}% odd-center
          {}%  odd-right
  \setfoot[]% even-left
          [\raisebox{1.5\baselineskip}{\thepage}]% even-center
          []% even-right
          {}%  odd-left
          {\raisebox{1.5\baselineskip}{\thepage}}% odd-center
          {}% odd-right
}

%-- Back matter style for book/handbook
\newpagestyle{back}[\small]{%
  \settitlemarks{backchapter,section}% MUST BE HERE see tex.stackexchange.com/questions/313080
  %\setheadrule{.55pt}%
  % Usage: \widenhead[<even-left>][<even-right>]{<odd-left>}{<odd-right>}
  \widenhead[\marginparwidth+\marginparsep][0pt]{0pt}{\marginparwidth+\marginparsep}
  \sethead[\mbox{\llap{\small\thepage\quad\color{black!20}%
              \vline height .75\baselineskip  depth .25\baselineskip}%
              \color{black!50}\quad\spacedlowsmallcaps{\backchaptertitle}\hfil}]% even-left
          []% even-center
          []% even-right
          {}%  odd-left
          {}% odd-center
          {\mbox{\hfil{\color{black!50}%
            \spacedlowsmallcaps{\backchaptertitle}\quad}%
            \rlap{\textcolor{black!20}{%
                  \vline height .75\baselineskip  depth .25\baselineskip}%
                  \quad\small\thepage}}% odd-right
          }%
}

%-- Appendix style for book/handbook
\newpagestyle{appendix}[\small]{%
  \settitlemarks{appendixchapter,section}% MUST BE HERE see tex.stackexchange.com/questions/313080
  %\setheadrule{.55pt}%
  % Usage: \widenhead[<even-left>][<even-right>]{<odd-left>}{<odd-right>}
  \widenhead[\marginparwidth+\marginparsep][0pt]{0pt}{\marginparwidth+\marginparsep}
  \sethead[\mbox{\llap{\small\thepage\quad\color{black!20}%
              \vline height .75\baselineskip  depth .25\baselineskip}%
              \color{black!50}\quad\spacedlowsmallcaps{\appendixchaptertitle}\hfil}]% even-left
          []% even-center
          []% even-right
          {}%  odd-left
          {}% odd-center
          {\mbox{\hfil{\color{black!50}%
            \spacedlowsmallcaps{\sectiontitle}\quad}%
            \rlap{\textcolor{black!20}{%
                  \vline height .75\baselineskip  depth .25\baselineskip}%
                  \quad\small\thepage}}% odd-right
          }%
}

%-- Applying document headers and footers
\ifdoc@article
  \AtBeginDocument{\pagenumbering{arabic}\pagestyle{paper}}%
  %\AtBeginDocument{\pagenumbering{arabic}\pagestyle{plain}}%
\else
  \assignpagestyle{\part}{empty}
  \renewcommand{\frontmatter}{% the frontmatter is plain with roman page numbering
                \cleardoublepage\@mainmatterfalse\pagenumbering{roman}\pagestyle{plain}%
               }
  \renewcommand{\mainmatter}{% mainmatter with arabic page numbering
                \assignpagestyle{\chapter}{plain}
                \cleardoublepage\asymmetricalpage%
                \@mainmattertrue\pagenumbering{arabic}\pagestyle{main}%
                % Explicitly reset the counters
                %\@addtoreset{sidenote}{chapter}
                \@addtoreset{figure}{chapter}
                \@addtoreset{table}{chapter}
                \@addtoreset{code}{chapter}
                \renewcommand{\thecode}{\thechapter.\arabic{code}}
                \@addtoreset{listing}{chapter}
                \renewcommand{\thelisting}{\thechapter.\arabic{listing}}
                \@addtoreset{video}{chapter}
                %\@addtoreset{exercise}{chapter}
                %\renewcommand{\theexercise}{\thechapter.\arabic{exercise}}
                %\@addtoreset{quiz}{chapter}
                %\renewcommand{\thequiz}{\thechapter.\arabic{quiz}}
                \@addtoreset{tcbexercise}{chapter}
                \@addtoreset{examination}{chapter}
                \@addtoreset{document}{chapter}
               }%
  \renewcommand{\backmatter}{%
                \assignpagestyle{\backchapter}{plain}
                \cleardoublepage\asymmetricalpage%
                \@mainmatterfalse\pagestyle{back}
                %\@addtoreset{sidenote}{backchapter}
                \@addtoreset{section}{backchapter}
                \@addtoreset{figure}{backchapter}
                \@addtoreset{table}{backchapter}
                \@addtoreset{code}{backchapter}
                \@addtoreset{listing}{backchapter}
                \@addtoreset{footnote}{backchapter}
                \@addtoreset{tcbexercise}{backchapter}
                %\@addtoreset{exercise}{backchapter}
                %\@addtoreset{quiz}{backchapter}
                \@addtoreset{examination}{backchapter}
                \@addtoreset{document}{backchapter}
                \@addtoreset{video}{backchapter}
               }
  %https://tex.stackexchange.com/questions/231872/
  % (how-to-replace-the-word-chapter-for-appendix-items-with-appendix-in-book-usi)
  %https://tex.stackexchange.com/questions/313209/toc-chapter-toc-and-appendix-misfunctions
  %\g@addto@macro{\appendix}{%
  \apptocmd{\appendix}{%
    \global\doc@appendixtrue
    \setbool{appendices}{true}
    \assignpagestyle{\appendixchapter}{plain}
    \pagestyle{appendix}
    %\@addtoreset{sidenote}{appendixchapter}
    \@addtoreset{footnote}{appendixchapter}
    \@addtoreset{section}{appendixchapter}
    \@addtoreset{figure}{appendixchapter}
    \renewcommand{\thefigure}{\theappendixchapter.\arabic{figure}}
    \@addtoreset{table}{appendixchapter}
    \renewcommand{\thetable}{\theappendixchapter.\arabic{table}}
    %- Explicitly reset tcbexercise counter within appendixchapter, if not: A.1, A.2, B.3, B.4, etc.
    \@addtoreset{tcbexercise}{appendixchapter}
    %- Explicitly reset exercise counter within appendixchapter, if not: A.1, A.2, B.3, B.4, etc.
    %\@addtoreset{exercise}{appendixchapter}
    %\renewcommand{\theexercise}{\theappendixchapter.\arabic{exercise}}
    %- Explicitly reset quiz counter within appendixchapter, if not: A.1, A.2, B.3, B.4, etc.
    %\@addtoreset{quiz}{appendixchapter}
    %\renewcommand{\thequiz}{\theappendixchapter.\arabic{quiz}}
    %- Explicitly reset examination counter within appendixchapter
    \@addtoreset{examination}{appendixchapter}
    %- Reset the other counters
    \@addtoreset{document}{appendixchapter}
    \renewcommand{\thedocument}{\theappendixchapter.\arabic{document}}
    \@addtoreset{video}{appendixchapter}
    \renewcommand{\thevideo}{\theappendixchapter.\arabic{video}}
    \@addtoreset{code}{appendixchapter}
    \renewcommand{\thecode}{\theappendixchapter.\arabic{code}}
    %\@addtoreset{tcb@cnt@code}{appendixchapter}
    %\renewcommand{\thetcb@cnt@code}{\theappendixchapter.\arabic{tcb@cnt@code}}
    \@addtoreset{listing}{appendixchapter}
    \renewcommand{\thelisting}{\theappendixchapter.\arabic{listing}}
    %- When the table of contents is being typeset, \ifappendix returns false. We need to pass
    %- \appendixtrue also to the ToC file. See: https://tex.stackexchange.com/questions/414493
    %\addtocontents{tdm}{\protect\doc@appendixtrue}%\addtocontents{tdm}{\protect\appendixtrue}
  }{}{}
\fi


%---------------------------------------------------------------------------------------------------
%---- Writing to an auxiliary file (for the record)
%---------------------------------------------------------------------------------------------------
%- Cf. http://tex.stackexchange.com/questions/85982/write-on-a-file-and-input-it
%\RequirePackage{catchfile}
%\newwrite\sommaire

%\AtBeginDocument{\immediate\openout\sommaire=\jobname.som }
%\AtEndDocument{\immediate\closeout\sommaire}

%\newcommand{\sommaireline}[1]{%
%  \immediate\write\sommaire{#1}

%\IfFileExists{\jobname.som}%
%  {\CatchFileDef\mysommaire{\jobname.som}{}}
%  {\def\mysommaire{\message{No file \jobname.som}}}

%-- Miscellaneous
%\newcommand{\keywordsdisplay}[1]{% TODO: recode with tcolorbox
%  %\vspace*{.75\baselineskip}
%  \begin{mdframed}[
%    skipabove=\baselineskip,
%    skipbelow=\baselineskip,
%    innertopmargin=2pt,
%    innerbottommargin=2pt,
%    innerleftmargin=4pt,
%    innerrightmargin=4pt,
%    leftmargin=0mm,
%    rightmargin=0mm,
%    rightline=false,
%    topline=false,
%    bottomline=false,
%    leftline=true,
%    linewidth=1pt,%1mm,
%    backgroundcolor=maincolor!20]
%    \llap{\textcolor{secondcolor}{\faKey}\quad\vspace*{-\baselineskip}}
%    #1
%  \end{mdframed}
%}


%---------------------------------------------------------------------------------------------------
%---- Front-title page
%---------------------------------------------------------------------------------------------------

%-- Typo helper package to have extended contoured/outlined fonts
\RequirePackage{contour}

%-- Provides \EveryShipout and \AtNextShipout macros (applied at end of page)
%\RequirePackage{everyshi}%

%-- Better implementation of `everyshi' by Heiko Hoberdiek
\RequirePackage{atbegshi}% Provides \AtBeginShipout, \AtBeginShipoutNext, \AtBeginShipoutFirst

%-- Utilities

%\newlength{\titlepageTitleLength}
%\newif\ifSymmetrical\Symmetricalfalse

%-- Defining a "afterstuff" macro like afterpage
%- See: http://tex.stackexchange.com/questions/276448/after-minipage-like-afterpage
%\newcommand{\afterstuff}[1]{%
%  \gdef\@afterstuffhook{#1}%
%}
%%- It is used for synopsis and ToC
%\AfterEndEnvironment{synopsis}{%
%  \@ifundefined{@afterstuffhook}{%
%  }{%
%    \@afterstuffhook%
%  }
%  \global\let\@afterstuffhook\relax
%}

%-- Synopsis environment for workbook

\NewTColorBox{synopsis}{ o }{% optional arg #1 = more options list
  breakable,
  parbox=false,
  colframe=darkelectricblue, colback=maincolor!20,
  %colbacktitle=\@titlingcolor,% initially=black!50!white
  %colframe=boxbackgroundcolor!20, colback = boxbackgroundcolor!0,
  %colbacktitle=boxtitlecolor,% initially=black!50!white
  enhanced jigsaw,
  %sharpish corners,
  sharp corners = uphill,
  fontupper={\normalfont\small\color{black}},
  %fontupper=\keyFont\Large\color{black},
  arc = 20pt, %outer arc = 2pt,
  boxrule = 0pt,
  boxsep = 0pt,% default=1mm
  left = 20pt, right = 10pt,% additional to boxsep, default=4mm
  top = 4pt, bottom = 4pt,% default=2mm
  %middle = 2pt,% additional to boxsep
  %halign=center, valign=bottom,
  %capture=hbox,% default=minipage
  %noparskip,
  beforeafter skip=2.5\parskip,
  %after={\rlap{\raisebox{9\baselineskip}{\quad\textcolor{secondcolor}{\Huge\faKey}}}},
  %width=\linewidth
  before={\vspace{\parskip}%
          \llap{\textcolor{boxtitlecolor}{\faThumbTack}~}\vspace{-\baselineskip}},
  %after=,
  %{ --- #1}
  title={\textcolor{secondcolor}{\titlefont\Large\addtracked[6]{Synopsis}}},
  attach title to upper={\ ---\ },
  \IfValueT{#1}{#1}
}

%-- Workbook front title page

%\newlength{\titlepageHeaderHeightWorkbook}
%\setlength{\titlepageHeaderHeightWorkbook}{10cm}

\newlength{\titlepageHeaderHeightWorkbook}
\setlength{\titlepageHeaderHeightWorkbook}{10cm}

\newlength{\maintitlexoffsetWB}
\setlength{\maintitlexoffsetWB}{0.0cm}

\newlength{\maintitleyoffsetWB}
\setlength{\maintitleyoffsetWB}{-2.5cm}

\newlength{\titlepageTitleLength}

\RequirePackage{footnotehyper}% Useful for footnotes in title page

%- From latex.ltx file
\def\jazzfnsymbol#1{\expandafter\@jazzfnsymbol\csname c@#1\endcsname}
\def\@jazzfnsymbol#1{%
   \ifcase#1\or \textasteriskcentered\or
   \textasteriskcentered\textasteriskcentered\or
   \textasteriskcentered\textasteriskcentered\textasteriskcentered\or
   \textdagger\or
   \textdaggerdbl\else
   \@ctrerr \fi
}%

%\NewDocumentCommand{\maketitleWorkbook}{ o }{%
\NewDocumentCommand{\maketitleWorkbook}{ }{%
  %\thispagestyle{empty}
  \null
  \tikzset{
    fitting node/.style={
      inner sep=0pt,
      fill=none,
      draw=none,
      reset transform,
      fit={(\pgf@pathminx,\pgf@pathminy) (\pgf@pathmaxx,\pgf@pathmaxy)}
    },
    reset transform/.code={\pgftransformreset}
  }
  %\let\footnote\thanks
  %\let\dotFFNjazz\dotFFN
  \renewcommand*{\dotFFN}{}%
  \renewcommand{\thefootnote}{\jazzfnsymbol{footnote}}
  %- Appel des notes de bas de page : application de couleur adéquate
  \contourlength{.5pt}% how thick each copy is
  \contournumber{20}%
  \savenotes% Begining to store footnotes if any
  \begin{tikzpicture}[remember picture, overlay]
    % Some coordinates
    \coordinate[yshift=-\titlepageHeaderHeightWorkbook](rectangleEnd) at (current page.north east);
    \coordinate[xshift=-4cm](dateCenter) at (rectangleEnd);
    % Cover color rectangle
    \fill[black!45] (current page.north west) rectangle (rectangleEnd)
      node[fitting node] (headerRectangle) {};
    % Title page text (title, rule, subtitle and author)
    % Title
    \draw (\leftmargin + \maintitlexoffsetWB, \maintitleyoffsetWB) node[align=left, inner sep=0mm,
      anchor=south west, font=\fontsize{2.3cm}{1.8cm}\selectfont\titlefont] (title) {%
      \begin{varwidth}{\textwidth}%
        \FlushLeft%
        \noHyphen\textcolor{secondcolor}{\@title}%
      \end{varwidth}%
    };
    % Rule
    \getwidthofnode{\titlepageTitleLength}{title}
    \node[inner xsep=0mm, text width=\titlepageTitleLength, anchor=north west, yshift=-2mm] (rule)
      at (title.south west) {{\color{white}\rule{\linewidth}{.6mm}}};
    % Subtitle, document version and date version
    \def\@makefnmark{\hbox{\@textsuperscript{\normalfont\textcolor{white}{\@thefnmark}}}}
    \ifdefempty{\@versiondate}{%
      \ifdefempty{\@docversion}{%
        \ifdefempty{\@subtitle}{}{%
          \node[inner xsep=0mm, text width=\linewidth, anchor=north west, yshift=-2mm] (subtitle)
            at (rule.south west) {{%
              %\fontsize{1.2cm}{1.44cm}\selectfont\subtitlefont\color{white}\@subtitle}};
              \fontsize{1.0cm}{1.2cm}\selectfont\subtitlefont\color{white}\@subtitle}};
        }%
      }{%
        \node[inner xsep=0mm, text width=\linewidth, anchor=north west, yshift=-2mm] (subtitle)
          at (rule.south west) {{%
            \fontsize{1.0cm}{1.2cm}\selectfont\subtitlefont%
              \color{white}\@subtitle\space\@docversion}};
      }%
    }{%
      \node[inner xsep=0mm, text width=\linewidth, anchor=north west, yshift=-2mm] (subtitle)
        at (rule.south west) {{%
          \fontsize{1.0cm}{1.2cm}\selectfont\subtitlefont%
            \color{white}\@subtitle\space\@docversion\space\@versiondate}};
    }
      \ifdefempty{\@subtitle}{}{%
      \node[inner xsep=0mm, text width=\linewidth, anchor=north west, yshift=-2mm] (subtitle)
        at (rule.south west) 
          {{\fontsize{1.0cm}{1.2cm}\selectfont\subtitlefont\color{white}\@subtitle}};
    }
    % Author
    \def\@makefnmark{\hbox{\@textsuperscript{\normalfont\contour{fourthcolor}{\@thefnmark}}}}
    \ifdefempty{\@authorref}{%
      \node[anchor=south east, font=\fontsize{10mm}{6mm}\selectfont\subtitlefont]
        at ($(current page.north east)+(-15mm, -0.95\titlepageHeaderHeightWorkbook)$) {%
        \contourlength{.5pt}% how thick each copy is
        \contournumber{20}%
        \contour{fourthcolor}{\@author}
      };
    }{%
      \node[anchor=south east, font=\fontsize{10mm}{6mm}\selectfont\subtitlefont]
        at ($(current page.north east)+(-15mm, -0.95\titlepageHeaderHeightWorkbook)$) {%
        \contourlength{.5pt}% how thick each copy is
        \contournumber{20}%
        \contour{fourthcolor}{\@author}\footnote{\@authorref}
      };
    }
  \end{tikzpicture}
  \null
  \vfill
  \spewnotes% Displaying the title footnotes
  \setcounter{footnote}{0}% Resetting the footnote counter fot main text
  \renewcommand{\thefootnote}{\alph{footnote}}
  \renewcommand*{\dotFFN}{.}%
  \def\@makefnmark{\hbox{\@textsuperscript{\normalfont\textcolor{black}{\@thefnmark}}}}
  %\newpage%\thispagestyle{empty}
  %\vspace*{\fill}
  %\@typesettinginfo
}

%-- Textbook/handbook front title page

\newlength{\titlepageHeaderHeightHandbook}
\setlength{\titlepageHeaderHeightHandbook}{11cm}
\newlength{\maintitlexoffsetHB}
\setlength{\maintitlexoffsetHB}{0.0cm}

%- TODO: Improve the interface to add logos and other stuffs
\NewDocumentCommand{\maketitleHandbook}{ o }{%
  \thispagestyle{empty}
  \symmetricalpage
  \null
  \tikzset{
    fitting node/.style={
      inner sep=0pt,
      fill=none,
      draw=none,
      reset transform,
      fit={(\pgf@pathminx,\pgf@pathminy) (\pgf@pathmaxx,\pgf@pathmaxy)}
    },
    reset transform/.code={\pgftransformreset}
  }
  \begin{tikzpicture}[remember picture, overlay]
    % some coordinates
    \coordinate[yshift=-\titlepageHeaderHeightHandbook](rectangleEnd) at (current page.north east);
    \coordinate[xshift=-4cm](dateCenter) at (rectangleEnd);
    % display an image if one is provided
    \IfValueTF{#1}{%
      \draw (current page.center)[yshift=-\titlepageHeaderHeightHandbook/2]
        node[align=center, inner sep=0mm, anchor=center]
          {\includegraphics[height=\paperheight-\titlepageHeaderHeightHandbook]{#1}};%
    }{\draw (current page.center)[yshift=-\titlepageHeaderHeightHandbook/2]
        node[align=center, inner sep=0mm, anchor=center]
          {Please consider adding a image to this cover!};%
    }%
    % Cover color rectangle
    \fill[covercolor] (current page.north west) rectangle (rectangleEnd)
      node[fitting node] (headerRectangle) {};
    % Title page text (title, rule, subtitle and author)
    % Title
    %\draw (\leftmargin, -3.5cm) node[align=left, inner sep=0mm, anchor=south west,
    \draw (\leftmargin + \maintitlexoffsetHB, -3.5cm) node[align=left, inner sep=0mm,
      anchor=south west, font=\fontsize{2.3cm}{1.8cm}\selectfont\titlefont] (title) {%
      %\hspace*{-16mm}%
      \hspace*{-.8mm}%
      \begin{varwidth}{\textwidth}%
        \FlushLeft%
        \noHyphen\textcolor{titlecovercolor}{\@title}%
      \end{varwidth}%
    };
    % Rule
    \getwidthofnode{\titlepageTitleLength}{title}
    \node[inner xsep=0mm, text width=\titlepageTitleLength, anchor=north west, yshift=-2mm] (rule)
      at (title.south west) {{\color{white}\rule{\linewidth}{.6mm}}};
    % Subtitle
    \node[inner xsep=0mm, text width=\linewidth, anchor=north west, yshift=-2mm] (subtitle)
      at (rule.south west) {{\fontsize{.6cm}{.72cm}\selectfont\color{white}\@subtitle}};
    % Author
    \node[anchor=south east, font=\fontsize{10mm}{6mm}\selectfont\subtitlefont]
      at ($(current page.south east)+(-15mm, 5mm)$) {%
      %\fontsize{10mm}{6mm}\selectfont\subtitlefont
      \contourlength{.5pt}% how thick each copy is
      \contournumber{20}%
      \contour{authorcovercolor}{\@author}%
    };
    % Logo if one is provided
    \node[anchor=south west, align=center, inner sep=0mm]
      at ($(current page.south west)+(15mm, 7.5mm)$) {\displaylogo};%
    % Added logo if one is provided
    \node[anchor=south east, align=right, inner sep=0mm]
      at ($(current page.south east)+(-15mm, \paperheight-\titlepageHeaderHeightHandbook-25mm)$)
        {\displayaddlogo};%
%    }%
  \end{tikzpicture}
  \null
  \vfill
  \newpage\thispagestyle{empty}%\asymmetricalpage
  \vspace*{\fill}
  \@typesettinginfo
}

%-- Front page layout settings

\ifdoc@article
  %\LetLtxMacro{\maketitle}{\maketitleWorkbook}
  \let\maketitle\maketitleWorkbook% Why is there a difference between title workbook and handbook? FIX ME
\else
  \LetLtxMacro{\maketitle}{\maketitleHandbook}
  %\let\maketitle\maketitleHandbook
  \cleardoublepage
\fi


%---------------------------------------------------------------------------------------------------
%----  Identity blocks
%---------------------------------------------------------------------------------------------------

\newcommand{\extraVerticalSpace}{%
  \rule{0pt}{2.5ex}%
}
\newcommand{\emaillink}[1]{%
  {\hypersetup{urlcolor=darkelectricblue}\href{mailto:#1}{\texttt{#1}}}%
}
\newcommand{\addVerticalSpace}{%
  \rule{0pt}{8pt}%
}
\newlength{\fitNodeWidth}
%\setlength{\fitNodeWidth}{\marginparwidth}
\newcommand\findwidthofnode[2]{%
  \pgfextractx{#1}{\pgfpointanchor{#2}{east}}%
  % \pgf@xa = length defined by PGF for temporary storage: no need to create a new temporary length
  \pgfextractx{\pgf@xa}{\pgfpointanchor{#2}{west}}%
  \addtolength{#1}{-\pgf@xa}%
  \global#1=#1% to reuse the length in another tikz picture
}
\newcommand{\settowidthofnode}[2]{%
  \pgfpointanchor{#2}{center}%
  \unskip
  \setlength{#1}{\pgf@x}%
  \pgfpointanchor{#2}{text}
  \unskip
  \addtolength{#1}{-\pgf@x}%
  \addtolength{#1}{#1}%
}%
\newcommand{\shrinktowidthofnode}[2]{%
  \begingroup
  \settowidthofnode{\pgf@xb}{#2}%
  \resizebox{\pgf@xb}{!}{#1}%
  \endgroup
}%
%\begin{tikzpicture}[every node/.style={draw,rectangle}]
%  \draw[step=0.5cm,gray,very thin] (-3,-3) grid (3,3);
%  \node (n) {blah};
%  \node (m) [below of=n] {\shrinktowidthofnode{AAAAAAAA}{n}};
%  \node (o) [below of=m] {\scalebox{0.43259}{AAAAAAAA}};
%\end{tikzpicture}
\DeclareDocumentCommand{\identityBlockLine}{m m}{#1 \& #2\\}
\DeclareDocumentCommand{\identityName}{m O{\faUser}}{
  \identityBlockLine{}{\bfseries#1}%
}
\DeclareDocumentCommand{\identityAdressLineOne}{m O{\addVerticalSpace\faHome}}{
  \identityBlockLine{#2}{#1}%
}
\DeclareDocumentCommand{\identityAdressLineTwo}{m O{\phantom{\fontsize{2mm}{2mm}\faHome}}}{
  \identityBlockLine{#2}{#1}%
}
\DeclareDocumentCommand{\identityAdressLineThree}{m O{\phantom{\fontsize{2mm}{2mm}\faHome}}}{
  \identityBlockLine{#2}{#1}%
}
\DeclareDocumentCommand{\identityPhone}{m O{\addVerticalSpace\fontsize{5mm}{4mm}\faMobile}}{
  \identityBlockLine{#2}{#1}%
}
\DeclareDocumentCommand{\identityMail}{m O{\addVerticalSpace\faEnvelopeO}}{
  \identityBlockLine{#2}{\emaillink{#1}}%
}
\DeclareDocumentCommand{\identityWebsite}{m O{\addVerticalSpace{\FA\symbol{"F245}}}}{
  \identityBlockLine{#2}{\href{#1}{\color{black}#1}}%
}
%- Saving the width of a node for later use
%- cf. §101.2.3 “Deferred Node Positioning” TikZ v3.01a manual (TeX.SE: /questions/8691/)
\newlength{\distanceMatrixWidth}
\newlength{\identityMatrixWidth}
\setlength{\identityMatrixWidth}{\marginparwidth}
%\newcommand{\identityMatrixWidth}
%\newlength{\minxIdentityBlock}
%\newlength{\maxxIdentityBlock}
%\newcommand{\identityHPosition}{%
%  \global\let\minxIdentityBlock=\pgfpositionnodelaterminx%
%  \global\let\maxxIdentityBlock=\pgfpositionnodelatermaxx%
%}%
% Arguments: 1afterCode 2matrixArgument 3columnOneCode 4columnTwoCode 5text
\DeclareDocumentCommand{\identityBlockSkeleton}{O{} O{inner sep=5mm,} O{} O{} m}{
  \begin{tikzpicture}
  \matrix (identityBlock)[
    %matrix anchor=center,
    matrix of nodes, ampersand replacement=\&,
    nodes={inner ysep=.7mm, inner xsep=0mm, anchor=south west},%, inner xsep=2mm},
    column 1/.style={nodes={anchor=south,#3}},%
    column 2/.style={nodes={#4}},
    #2
    ]{#5};
    #1
%    \findwidthofnode{\distanceMatrixWidth}{identityBlock}
  \end{tikzpicture}
}
\newcommand{\identityBlockLineWidth}{.9mm}
\newcommand{\identityBlockLineLength}{4mm}
\newlength{\identityInnerSep}
\setlength{\identityInnerSep}{2.5mm}
\setlength{\identityMatrixWidth}{\marginparwidth}
%\setlength{\identityInnerSep}{.5\marginparwidth-.5\identityMatrixWidth-\identityBlockLineLength}
%\setlength{\identityInnerSep}{.5\marginparwidth-.5\identityMatrixWidth-\identityBlockLineLength}
\DeclareDocumentCommand{\identityBlock}{m O{inner xsep=\identityInnerSep}}{
  \identityBlockSkeleton[
  \begin{scope}[darkGrey, line width=\identityBlockLineWidth, rounded corners=1pt]
    \draw ($(identityBlock.north east)+(-\identityBlockLineLength, 0)$)
      -- ++(\identityBlockLineLength, 0) -- ++(0, -\identityBlockLineLength);
    \draw ($(identityBlock.south west)+(0, \identityBlockLineLength)$)
      -- ++(0, -\identityBlockLineLength) -- ++(\identityBlockLineLength, 0);
    \draw ($(identityBlock.south east)+(-\identityBlockLineLength, 0)$)
      -- ++(\identityBlockLineLength, 0) -- ++(0, \identityBlockLineLength);
%    \draw ($(identityBlock.north west)+(\identityBlockLineLength, 0)$)
%      -- ++(-\identityBlockLineLength, 0) -- ++(0, -\identityBlockLineLength);
    \node[font=\fontsize{0.6cm}{.4cm}, text=secondcolor, anchor=north, yshift=.4cm]
      (userIcon) at (identityBlock.north west) {\faUser};
  \end{scope}
  ]
  [outer sep=0pt, inner ysep=2mm, #2]
  %[text width=\identityMatrixWidth, #2]
  [text=secondcolor,inner ysep=2pt,inner xsep=2pt,font=\scriptsize]
  [inner ysep=2pt,inner xsep=4pt,font=\scriptsize]{#1}
}
\DeclareDocumentCommand{\identityBlockLarge}{m m O{inner xsep=\identityInnerSep}}{
\begin{tabular}{cc}
  \identityBlockSkeleton[
  \begin{scope}[darkGrey, line width=\identityBlockLineWidth, rounded corners=1pt]
%    \draw ($(identityBlock.north east)+(-\identityBlockLineLength, 0)$)
%      -- ++(\identityBlockLineLength, 0) -- ++(0, -\identityBlockLineLength);
%    \draw ($(identityBlock.south east)+(-\identityBlockLineLength, 0)$)
%      -- ++(\identityBlockLineLength, 0) -- ++(0, \identityBlockLineLength);
    \draw ($(identityBlock.south west)+(0, \identityBlockLineLength)$)
      -- ++(0, -\identityBlockLineLength) -- ++(\identityBlockLineLength, 0);
%    \draw ($(identityBlock.north west)+(\identityBlockLineLength, 0)$)
%      -- ++(-\identityBlockLineLength, 0) -- ++(0, -\identityBlockLineLength);
    \node[font=\fontsize{0.6cm}{.4cm}, text=secondcolor, anchor=north, yshift=.4cm]
      (userIcon) at (identityBlock.north west) {\faUser};
  \end{scope}
  ]
  [outer sep=0pt, inner ysep=2mm, #3]
  [text=secondcolor,inner ysep=2pt,inner xsep=2pt,font=\scriptsize]
  [inner ysep=2pt,inner xsep=4pt,font=\scriptsize]{#1}
  &
  \identityBlockSkeleton[
  \begin{scope}[darkGrey, line width=\identityBlockLineWidth, rounded corners=1pt]
    \draw ($(identityBlock.north east)+(-\identityBlockLineLength, 0)$)
      -- ++(\identityBlockLineLength, 0) -- ++(0, -\identityBlockLineLength);
    \draw ($(identityBlock.south east)+(-\identityBlockLineLength, 0)$)
      -- ++(\identityBlockLineLength, 0) -- ++(0, \identityBlockLineLength);
%    \draw ($(identityBlock.south west)+(0, \identityBlockLineLength)$)
%      -- ++(0, -\identityBlockLineLength) -- ++(\identityBlockLineLength, 0);
%    \draw ($(identityBlock.north west)+(\identityBlockLineLength, 0)$)
%      -- ++(-\identityBlockLineLength, 0) -- ++(0, -\identityBlockLineLength);
%    \node[font=\fontsize{0.6cm}{.4cm}, text=secondcolor, anchor=north, yshift=.4cm]
%      (userIcon) at (identityBlock.north west) {\faUser};
  \end{scope}
  ]
  [outer sep=0pt, inner ysep=2mm, #3]
  [text=secondcolor,inner ysep=2pt,inner xsep=2pt,font=\scriptsize]
  [inner ysep=2pt,inner xsep=4pt,font=\scriptsize]{#2}
  \end{tabular}
}
%---------------------------------------------------------------------------------------------------
\newcommand{\makeIdentityLarge}{%
  \begin{tikzpicture}[remember picture, overlay]
    \node[outer sep=0mm, inner sep=0mm, anchor=south]
      (identityblock) at ([outer sep=0pt, inner sep=0pt, yshift=0pt,
        xshift=(0pt)]current page footer area.south) {
      \identityBlockLarge{%
        \identityName{\textcolor{secondcolor}{Vincent Doutaut}}
        \identityAdressLineOne{45 rue Léo Ferré}[\addVerticalSpace\faHome]
        \identityAdressLineTwo{72000, Le Mans --- France}[]
        }{
        \identityBlockLine{~}{~}
        \identityBlockLine{\faSignIn}{Id.~7253144}% / 16 novembre 2014}
        \identityPhone{+33 (0)6\,14\,10\,80\,32}[\addVerticalSpace\faMobile]
        \identityMail{vincent.doutaut@gmail.com}[\addVerticalSpace\faEnvelopeO]
        }
      };
  \end{tikzpicture}
}
\newcommand{\makeIdentity}{%
  \begin{tikzpicture}[remember picture, overlay]
    \node[outer sep=0mm, inner sep=0mm, anchor=south west]
      (identityblock) at ([outer sep=0pt, inner sep=0pt,% yshift=-.5cm,
        xshift=(\marginparsep-2mm)]current page footer area.south east) {%-2mm sans \parindent ?
      \identityBlock{
        \identityName{\textcolor{secondcolor}{Vincent Doutaut}}
        \identityBlockLine{\addVerticalSpace\faSignIn}{Id.~72553144}% / 16 novembre 2014}
        \identityAdressLineOne{45 rue Léo Ferré}[\addVerticalSpace\faHome]
        \identityAdressLineTwo{72000, Le Mans --- France}[]
        \identityPhone{+33 (0)6\,14\,10\,80\,32}[\addVerticalSpace\faMobile]
        \identityMail{vincent.doutaut@gmail.com}[\addVerticalSpace\faEnvelopeO]
        }
      };
  \end{tikzpicture}
}
%\ifLightEdition\let\makeIdentity\makeIdentityLarge
%  \else\let\makeIdentity\makeIdentity
%\fi


%---------------------------------------------------------------------------------------------------
%---- Extra front matter environments and stuff
%---------------------------------------------------------------------------------------------------

%-- Introduction environments (VERY OLD FASHION! → TO BE DELETED SOON!)

\def\resumename{Résumé -- Guide de lecture}
\newenvironment{sumup}{%
  \if@twocolumn
    \section*{\resumename}%
  \else
    \noindent\textsc{\resumename}~\textcolor{\@layoutcolor!20}{\hrulefill}\par
    \begin{minipage}[t]{.9\linewidth}%
    \small
  \fi}%
  {\if@twocolumn\else\end{minipage}\fi\par
    \ifdoc@Ref
       \noindent\makebox[0.75\linewidth]{\textcolor{\@layoutcolor!20}{\hrulefill}}%
       ~\@copyrightsymbol~\scriptsize~\@copyrightname%
       ~\scriptsize\@versiondate\@docversion~\textcolor{\@layoutcolor!20}{\hrulefill}%
     \else
      \noindent\makebox[\linewidth]{\textcolor{\@layoutcolor!20}{\hrulefill}}%
    \fi
}
\newenvironment{introduction}{%
  \noindent\llap{\textcolor{\@titlingcolor}{\faThumbTack~}}%
      \textcolor{\@layoutcolor!20}{\hrulefill}\par
  \centering\begin{minipage}[t]{.9\linewidth}\small}%
  {\end{minipage}\par
    \ifdoc@Ref
      \noindent\makebox[0.6\linewidth]{\textcolor{\@layoutcolor!20}{\hrulefill}}%
      ~\textcolor{\@layoutcolor!50}{\@copyrightsymbol~\footnotesize~\@copyrightname%
      ~\scriptsize\@versiondate\@docversion~}\textcolor{\@layoutcolor!20}{\hrulefill}%
    \else
      \noindent\makebox[\linewidth]{\textcolor{\@layoutcolor!20}{\hrulefill}}%
    \fi
}


%---------------------------------------------------------------------------------------------------
%----    Bibliography
%---------------------------------------------------------------------------------------------------

\RequirePackage[% Powerful and up to date extension for bibliography
  citestyle=authoryear, bibstyle=authoryear, dashed=false, labeldateparts=true,
  mincitenames=1, minbibnames=1, maxcitenames=2, maxbibnames=99,
  sorting=nyt, hyperref=true, backend=biber,
  language=autobib,% See the warning below
  autolang=other,% Enclose the entry in a hyphenation/extras environment (see langid/langidopts)
]{biblatex}

%-- Redefining the itemize environment layout for bibliographic fields, mainly abstract

\pretocmd{\printbibliography}{%
  \renewcommand*{\FrenchLabelItem}{\textcolor{maincolor}{\faCaretRight}}%
  \setlength{\listindentFB}{0pt}%
  }{}{}

%-- Customizing bibliography style
%---------------------------------

%-- WARNING: All modifications have been revised to match the 3.9 biblatex version (2017/12/09)

%----- Useful readings (obviously in addition to the documentation!)
%- https://tex.stackexchange.com/questions/12806/guidelines-for-customizing-biblatex-styles
%- https://tex.stackexchange.com/questions/10682/suppress-in-biblatex
%- https://tex.stackexchange.com/questions/174349/customizing-the-biblatex-style-authoryear
%-----

%----- Localization bibliographic entries
%- To have language sensitive typesettings of bibliographic entries, i.e. hyphenation, quotes
%- (with the csquotes package), space punctuation, key translation such as `editor' or `volume'
%- given by the "language.lbx" files, several options must be setted:
%- 1. The language package Babel, or here Polyglossia, must be loaded and set the main and other
%-    languages (here French and English). See beginning of class § "Document localization language"
%- 2. The `csquotes' package has to be loaded too (more efficient and recognized by biblatex)
%- 3. The "langid" of each entry must be set in the bibliographic file "xyz.bib".
%- 4. The `biblatex' package options `language' and `autolang' must be obviously given (see above).
%-----

%----- WARNING: Dilemma when setting multilanguage bibliographic entries
%- The two language options of the biblatex package (doc. §3.1.2.1 p.48) seem to be in conflict.
%- On one hand, when setting language=auto, i.e. `autobib' + `autocite', and autolang=other, then
%- the calling citation label adds spurious spaces bullshit after the open and before the closed
%- parenthesis. On the other hand, when setting language=autobib, citation label is correct
%- but another spurious space is added before the final dot in the English citations displays.
%----- ADOPTED SOLUTION
%- Despite the fact we redefine the calling citation label to suit our needs (between brackets and
%- with a hyperlink) and that we merely use the \fullcite and derived macros, the choice is here the
%- second solution. We let BibLaTeX take control of the displays and we take care of the \fullcite
%- macro definition. This choice is definitely not the best but it works!
%-----

%-- French and English terms (cf. /opt/texlive/20xy/texmf-dist/tex/latex/biblatex/lbx/french.lbx)

\DefineBibliographyStrings{french}{%
  urlseen = {consulté le},
  edition = {éd\adddot\addcomma},
}
\DefineBibliographyStrings{english}{%
  edition = {ed\adddot\addcomma},
}

\AtEveryBibitem{\clearfield{month}}% Do not show month in the bibliography
\AtEveryCitekey{\clearfield{month}}% Do not show month in citations
\AtEveryBibitem{\clearlist{language}}% Do not show language in the bibliography
\AtEveryCitekey{\clearlist{language}}% Do not show language in citations
\AtEveryBibitem{\clearfield{doi}}% Do not show DOI in the bibliography
\AtEveryCitekey{\clearfield{doi}}% Do not show DOI in citations


%-- Customizing citation style
%-----------------------------

%-- Author-year style \parencite command with square brackets instead of parenthesis
%-- https://tex.stackexchange.com/questions/16765/biblatex-author-year-square-brackets

\newrobustcmd*{\parentexttrack}[1]{%
  \begingroup
  \blx@blxinit%
  \blx@setsfcodes%
  \blx@bibopenparen#1\blx@bibcloseparen%
  \endgroup%
}
\AtEveryCite{%
  \let\parentext=\parentexttrack%
  \let\bibopenparen=\bibopenbracket%
  \let\bibcloseparen=\bibclosebracket%
}

%-- Applying a link to authoryear citation labels and moreother almost of the citation calls
%-- https://tex.stackexchange.com/questions/1687/hyperlink-name-with-biblatex-authoryear
%-- https://tex.stackexchange.com/questions/15951/hyperlink-name-with-biblatex-authoryear-biblatex
%-- https://tex.stackexchange.com/questions/387281/how-to-use-biblatex-with-square-brackets-and-hyperref

\DeclareFieldFormat{citehyperref}{%
  \DeclareFieldAlias{bibhyperref}{noformat}% Avoid nested links
  \bibhyperref{#1}%
}
\DeclareFieldFormat{textcitehyperref}{%
  \DeclareFieldAlias{bibhyperref}{noformat}% Avoid nested links
  \bibhyperref{%
    #1%
    \ifbool{cbx:parens}
      {\bibcloseparen\global\boolfalse{cbx:parens}}
      {}%
  }%
}
\savebibmacro{cite}
\savebibmacro{textcite}
\renewbibmacro*{cite}{%
  \printtext[citehyperref]{%
    \restorebibmacro{cite}%
    \usebibmacro{cite}}%
}
\renewbibmacro*{textcite}{%
  \ifboolexpr{
    ( not test {\iffieldundef{prenote}} and
      test {\ifnumequal{\value{citecount}}{1}} )
    or
    ( not test {\iffieldundef{postnote}} and
      test {\ifnumequal{\value{citecount}}{\value{citetotal}}} )
  }
  {\DeclareFieldAlias{textcitehyperref}{noformat}}
  {}%
  \printtext[textcitehyperref]{%
    \restorebibmacro{textcite}%
    \usebibmacro{textcite}%
  }%
}

%-- Spurious spaces within brackets of \parencite and multilanguage: the following seems to work
%-- THE ISSUE COMES FROM THE LANGUAGE=AUTOCITE OPTION OF THE PACKAGE: BULLSHIT! SEE:
%-- https://tex.stackexchange.com/questions/299050/macro-for-hyperlinked-citation-in-parentheses

%-- Citation de tous les auteurs/éditeurs : redéfinition de \fullcite et \footfullcite
%-- http://tex.stackexchange.com/questions/126226/fullcite-to-use-maxbibnames-rather-than-maxcitenames

%-- https://tex.stackexchange.com/questions/43196/
%-- (biblatex-fullcite-produces-different-result-from-bibliography-entry)
%-- From the above link: "Like bibliography entries and \footfullcite, \fullcite is generated by the
%-- bibliography driver. The only difference is that \fullcite doesn't set \finentrypunct".
%-- We can apply edits to the `finentry' bibliography macro to resolve this difference.
%-- See below: \renewbibmacro*{finentry}{...} (last macro of this bibliographic paragraph)

\DeclareCiteCommand{\fullcite}% Abstract field is redefined: see below last macros of this section
  %{\usebibmacro{prenote}} ← Original
  {\defcounter{maxnames}{\blx@maxbibnames}\usebibmacro{prenote}}% ← Modified
  {\usedriver{\DeclareNameAlias{sortname}{default}}{\thefield{entrytype}}}
  {\multicitedelim}
  {\usebibmacro{postnote}}%
\pretocmd{\fullcite}{%
  \llap{\textcolor{secondcolor}{\normalfont\faBook}}}%\faClipboard%\faThumbTack\faPaperclip
  {}{}
\DeclareCiteCommand{\footfullcite}[\mkbibfootnote]
  %{\usebibmacro{prenote}} ← Original
  {\defcounter{maxnames}{\blx@maxbibnames}\usebibmacro{prenote}}% ← Modified
  {\usedriver{\DeclareNameAlias{sortname}{default}}{\thefield{entrytype}}}
  {\multicitedelim}
  {\usebibmacro{postnote}}%

%-- Affichage de tous les champs uniquement dans la bibliographie, mais pas dans les citations
%-- http://tex.stackexchange.com/questions/278890/biblatex-suppressing-urldate-does-not-work-clearfield
%-- Adapted from \fullcite and generic commands in biblatex.def and in standard.bbx

\DeclareCiteCommand{\jazzfullcite}
  %{\usebibmacro{prenote}} ← Original
  {\defcounter{maxnames}{\blx@maxbibnames}\usebibmacro{prenote}}% ← Modified
  {\usedriver
    {\DeclareNameAlias{sortname}{default}}%
    {jazzcite:\thefield{entrytype}}% See doc. p.248: links on titles, but no e-field (URL, DOI...)
  }%
  {\multicitedelim}
  {\usebibmacro{postnote}}
\DeclareBibliographyDriver{jazzcite:article}{%
  \usebibmacro{bibindex}%
  \usebibmacro{begentry}%
  \usebibmacro{author/translator+others}%
  \setunit{\printdelim{nametitledelim}}\newblock
  \usebibmacro{title}%
  \newunit
  \usebibmacro{journal+issuetitle}%
  \newunit
  \usebibmacro{note+pages}%volume+number+eid? Better?
  \newunit\newblock
  \usebibmacro{finentry}%
}
\DeclareBibliographyDriver{jazzcite:book}{%
  \usebibmacro{bibindex}%
  \usebibmacro{begentry}%
  \usebibmacro{author/editor+others/translator+others}%
  \setunit{\printdelim{nametitledelim}}\newblock
  \usebibmacro{maintitle+title}%
  \newunit\newblock
  \iffieldundef{maintitle}
    {\printfield{volume}%
     \printfield{part}}
    {}%
  \newunit
  \printfield{volumes}%
  \newunit\newblock
  \usebibmacro{series+number}%
  \newunit\newblock
  \usebibmacro{publisher+location+date}% Reordered and redefined, see below
  \newunit\newblock
  %\printfield{note}%
  %\newunit\newblock
  \usebibmacro{finentry}%
}
\DeclareBibliographyDriver{jazzcite:report}{% Borrowed and adapted from standard.bbx
  \usebibmacro{bibindex}%
  \usebibmacro{begentry}%
  \usebibmacro{author}%
  \setunit{\printdelim{nametitledelim}}\newblock
  \usebibmacro{title}%
  \newunit
  \printlist{language}%
  \newunit\newblock
  \usebibmacro{byauthor}%
  \newunit\newblock
  \printfield{type}%
  \setunit*{\addcomma\addspace}%
  \printfield{number}%
  \newunit\newblock
  \printfield{version}%
  \newunit
  \printfield{note}%
  \newunit\newblock
  %\usebibmacro{institution+location+date}% ← Original
  \usebibmacro{institution+location}% ← Modified: see the new definition below
  \newunit\newblock
  \usebibmacro{chapter+pages}%
  \newunit
  %\setunit*{\addsemicolon\addspace}% ← Added
  \printfield{pagetotal}%
  \newunit\newblock
  \iftoggle{bbx:isbn}
    {\printfield{isrn}}
    {}%
  \newunit\newblock
  \usebibmacro{doi+eprint+url}%
  \newunit\newblock
  \usebibmacro{addendum+pubstate}%
  \setunit{\bibpagerefpunct}\newblock
  \usebibmacro{pageref}%
  \newunit\newblock
  \iftoggle{bbx:related}
    {\usebibmacro{related:init}%
     \usebibmacro{related}}
    {}%
  \usebibmacro{finentry}%
}
\DeclareBibliographyDriver{jazzcite:inproceedings}{%
  \usebibmacro{bibindex}%
  \usebibmacro{begentry}%
  \usebibmacro{author/editor+others/translator+others}%
  \setunit{\printdelim{nametitledelim}}\newblock
  \usebibmacro{maintitle+title}%
  \newunit\newblock
  \iffieldundef{maintitle}
    {\printfield{volume}%
     \printfield{part}}
    {}%
  \newunit
  \printfield{volumes}%
  \newunit\newblock
  \usebibmacro{series+number}%
  \newunit\newblock
  \usebibmacro{publisher+location+date}% Reordered and redefined, see below
  \newunit\newblock
  \usebibmacro{note+pages}%
  %\printfield{note}%
  %\newunit\newblock
  \usebibmacro{finentry}%
}
\DeclareBibliographyDriver{jazzcite:online}{%
  \usebibmacro{bibindex}%
  \usebibmacro{begentry}%
  \usebibmacro{author/editor+others/translator+others}%
  \setunit{\printdelim{nametitledelim}}\newblock
  \usebibmacro{title}%
  \newunit\newblock
  \printfield{version}%
  \newunit
  \printfield{note}%
  \newunit\newblock
  \printlist{organization}%
  \newunit\newblock
  \usebibmacro{date}%
  \newunit\newblock
  \iftoggle{bbx:eprint}
    {\usebibmacro{eprint}}
    {}%
  \newunit\newblock
  \usebibmacro{url+urldate}%
  \newunit\newblock
  \usebibmacro{addendum+pubstate}%
  \setunit{\bibpagerefpunct}\newblock
  \usebibmacro{pageref}%
  \newunit\newblock
  \iftoggle{bbx:related}
    {\usebibmacro{related:init}%
     \usebibmacro{related}}
    {}%
  \usebibmacro{finentry}%
}
%%%%% TODO TODO → TO BE CONTINUED FOR OTHER DRIVERS IF THE NEED ARISES


%- Sélection des champs affichés (ou plutôt non affichés) dans les citations
%\AtEveryCitekey{%
  %\clearfield{abstract}% TO BE KNOWN: \fullcite also displays the abstract
  %\clearfield{doi}%
  %\clearfield{url}%
  %\clearfield{urlyear}%
  %\clearfield{urldate}%
  %\clearfield{eprint}%
%}

%-- Personal/adapted macros to print customized citation (\fullcite minus URL, URLdate, etc.)

\newcommand{\jazzcite}[1]{%
  \AtNextCitekey{%
    \clearfield{abstract}% No abstract. To also display the abstract, use \fullcite
    %\clearfield{doi}% Must be set to have hyperlinks on the title field (see below)
    %\clearfield{url}% Must be set to have hyperlinks on the title field (see below)
    %\clearfield{urlyear}%
    %\clearfield{urldate}%
    %\clearfield{eprint}%
    \clearfield{edition}%
    %§\clearfield{pagetotal}%
    %\clearfield{pages}%
    \clearfield{addendum}%
    %\clearfield{isbn}% Must be set to have hyperlinks on the title field (see below)
    %\clearfield{issn}% Must be set to have hyperlinks on the title field (see below)
  }
  %- \unskip or \unspace? See for example: https://tex.stackexchange.com/questions/104034
  %\unskip\fullcite{#1}% ← \unskip is needed to avoid unwanted extra space before the citation
  %- Delete the spurious space at end of \fullcite and add a dot as final punctuation: see finentry
  %\hspace*{-1ex}{.}% ← A really very bad workaround, but it works! ONLY WITH language=autobib
  \unskip\jazzfullcite{#1}% ← \unskip is needed to avoid unwanted extra space before the citation
}

\newcommand{\sideCite}[1]{\sidenote{\jazzcite{#1}}}% Just a shortcut alias

%- Redefining \citeauthor command to get a hyperlink to the bibliography. From:
%-   https://tex.stackexchange.com/questions/75902/[...]
%-     [...]hyperlinking-author-names-in-biblatex-when-using-citeauthor
\DeclareCiteCommand{\citeauthor}{% From biblatex.def file
  \boolfalse{citetracker}%
  \boolfalse{pagetracker}%
    \usebibmacro{prenote}%
  }{\ifciteindex
      {\indexnames{labelname}}
      {}%
    %\printnames{labelname}}% Original
    \printtext[bibhyperref]{\printnames{labelname}}}
  {\multicitedelim}
  {\usebibmacro{postnote}}

%- Redefining \citetitle command to get a hyperlink to the bibliography. From:
%-   https://tex.stackexchange.com/questions/75902/[...]
%-     [...]hyperlinking-author-names-in-biblatex-when-using-citeauthor
\DeclareCiteCommand{\citetitle}{% From biblatex.def file
  \boolfalse{citetracker}%
  \boolfalse{pagetracker}%
    \usebibmacro{prenote}%
  }{\ifciteindex
      {\indexfield{indextitle}}
      {}%
    %\printfield[citetitle]{labeltitle}}% Original
    \printtext[bibhyperref]{\printfield[citetitle]{title}}}% Full title, not shorthand
  {\multicitedelim}
  {\usebibmacro{postnote}}

%- Defining a command to print title and subtitle within quotes (\citetile command gives only tile)
%- and to get a hyperlink to the bibliography
\DeclareCiteCommand{\titlecite}{%
  \boolfalse{citetracker}%
  \boolfalse{pagetracker}%
    \usebibmacro{prenote}%
  }{\ifciteindex{\indexfield{indextitle}}{}%
    \mkbibquote{%
      \printtext[bibhyperref]{%
        %\printfield[citetitle]{labeltitle}}% Original
        \printfield[citetitle]{title}%
        \iffieldundef{subtitle}{}{%
          \adddotspace\mkbibitalic{\printfield[subtitle]{subtitle}}%
        }%
      }%
    }%
  }
  {\multicitedelim}
  {\usebibmacro{postnote}}

%- Defining a command to print title and subtitle without quotes and hyperlink to the bibliography
\DeclareCiteCommand*{\titlecite}{%
  \boolfalse{citetracker}%
  \boolfalse{pagetracker}%
    \usebibmacro{prenote}%
  }{\ifciteindex{\indexfield{indextitle}}{}%
    %\printfield[citetitle]{labeltitle}}% Original
    \printfield[citetitle]{title}%
    \iffieldundef{subtitle}{}{%
      \adddotspace\mkbibitalic{\printfield[subtitle]{subtitle}}%
    }%
  }
  {\multicitedelim}
  {\usebibmacro{postnote}}

%- Like \titlecite command, but with a direct hyperlink (URL) to the document (Web or local tree)
\NewDocumentCommand{\jazztitlecite}{o m}{%
  \IfValueTF{#1}{%
    \mkbibquote{\href{#1}{\titlecite*{#2}}}%
  }{%
    \titlecite{#2}%
  }%
}


%-- Hyperref warning: "Suppressing link with empty target on input line xx"
%-- https://tex.stackexchange.com/questions/345764/

%\let\oldpageref\pageref
%\renewcommand{\pageref}{\oldpageref*}


%-- Customizing bibliography style
%---------------------------------

\setlength{\bibitemsep}{2pt}% Vertical separation between bibitems
\setlength{\bibhang}{\parindent}% Horizontal hang of entries (not with \fullcite macro, WHY?)

%-- Rajout d'un bloc d'appel de citation devant chaque entrée
%-- http://tex.stackexchange.com/questions/11827/adding-an-authoryear-block-at-the-beginning-of-entries

\newcounter{jazzmaxcitenames}
\AtBeginDocument{%
  \setcounter{jazzmaxcitenames}{\value{maxnames}}%
}
\renewbibmacro*{begentry}{%
  %\hspace*{-1ex}%\unskip% ← \unskip is needed to avoid unwanted extra space before the citation
  \printtext[brackets]{%
    \begingroup
    \defcounter{maxnames}{\value{jazzmaxcitenames}}%
    %\printnames{labelname}% ← Original
    \printtext[bibhyperref]{%
      \printnames{labelname}% ← Having a hyperlink on author (not only year)
      \setunit{\nameyeardelim}% Original and general
      %\usebibmacro{cite:labelyear+extrayear}% ← Original: Deprecated since v.3.8 2017-11-04
      \usebibmacro{cite:labeldate+extradate}% New names since v.3.8 (see: authoryear.cbx file)
    }%
    \endgroup
    }%
  \addspace\textemdash\addspace% OK, may be also \quad or simple \addspace
}

%-- Nom-prénom pour tous les auteurs (par défaut Nom-Prénom / Prénom-Nom)

%- Prénom + Nom ou Nom + Prénom (forename/last name)
%- http://tex.stackexchange.com/questions/244047/biblatex-different-name-order-for-author-editor
%\DeclareNameAlias{sortname}{last-first}% This yelds to be deprecated: `family-given' instead
%\DeclareNameAlias{sortname}{first-last}% This yelds to be deprecated: `given-family' instead
\DeclareNameAlias{sortname}{given-family}% It works but not availiable in the documentation...
% See: https://tex.stackexchange.com/questions/299036/biblatex-3-3-name-formatting
%      https://tex.stackexchange.com/questions/151820/how-to-reverse-name-and-first-name
\renewcommand*{\mkbibnamefamily}[1]{\textsc{#1}}% Smallcaps for family name
\renewcommand*{\revsdnamepunct}{}% no comma between lastname and firstname

%-- Remove the parentheses around the year in authoryear style

%\xpatchbibmacro{date+extrayear}{% Deprecated since v.3.8 2017-11-04 and renamed to `extradate'
\xpatchbibmacro{date+extradate}{% This patch is working with the new date+extradate field
  \printtext[parens]%
}{%
  \setunit{\addcomma\space}%\setunit{\addperiod\space}%
  \printtext%
}{}{}

%-- Delimiters

%- Commas as separators
%\renewcommand*{\newunitpunct}{\addcomma\space}

%- Comma instead of colon as location separator
%\xpatchbibmacro{publisher+location+date}{\addcolon}{\addcomma}{}{}

%- Between author/editor and the year by author-year citation styles
\renewcommand*{\nameyeardelim}{\addcomma\space}% default = interword space
%\renewcommand*{\postnotedelim}{\space\textendash\space}% default = comma + space

%- Champ des auteurs : tiret cadratin après la liste des auteurs (default = \addcomma)
\renewcommand*{\labelnamepunct}{\space\textemdash\space}

%\renewcommand*{\nametitledelim}{\textcolor{violet}{\space\textemdash\space}}

%- From: https://tex.stackexchange.com/questions/163966/citation-style-pages-punctuation
%\bibpagespunct% separator printed before the pages field
%\renewcommand*{\postnotedelim}{!\textemdash{}\space}
%\bibpagerefpunct% separator printed before the pageref field

%\renewcommand*{\bibpagespunct}{%
%  \ifentrytype{article}{%
%    \iffieldundef{volume}{\addcomma\space}{\addcolon\space}%
%  }{\addperiod\addspace}%
%}

%-- Prefixes for journal/book volume, number and pages (article)

%\DeclareFieldFormat[article]{journaltitle}{#1}
\DeclareFieldFormat[article]{volume}{vol.~#1}
\DeclareFieldFormat[article]{number}{n°#1}
\DeclareFieldFormat[article]{pages}{pp.~#1}

%\DeclareFieldFormat{pages}{\mkpageprefix[bookpagination]{#1}}% From biblatex.def file
%\DeclareFieldFormat{pagetotal}{\mkpagetotal[bookpagination]{#1}}% From biblatex.def file

%\DeclareFieldFormat{page}{p. #1}% French prefix for the `page` field in the bibliography
%\DeclareFieldFormat{pages}{pp. #1}% French prefix for the `pages` field in the bibliography

%\DeclareFieldFormat[book]{pagetotal}{\space\textemdash{}\space#1 pages}
\DeclareFieldFormat[book]{pagetotal}{\mkpagetotal[bookpagination]{#1~pages}}
\DeclareFieldFormat[report]{pagetotal}{\mkpagetotal[bookpagination]{#1~pages}}

%\DeclareFieldFormat{postnote}{#1}
%\DeclareFieldFormat{multipostnote}{#1}

%-- Comma instead period after "byeditor+others" bibmacro (with a patch)

\xpatchbibmacro{byeditor+others}% Original macro in `biblatex.def' file
  {\newunit}
  {\addcomma\space}
  {}
  {\ClassWarning{texjazz-handbook.cls}{Bibliography customizing:\MessageBreak
    Failed to change punctuation at end of editor names.}}

%-- Comma before and after journal volume
%-- https://tex.stackexchange.com/questions/11677/biblatex-custom-articles-and-books
%-- https://tex.stackexchange.com/questions/6743/biblatex-changing-the-order-of-entries

\renewbibmacro*{volume+number+eid}{%
  \setunit*{\addcomma\space}% NEW
  \printfield{volume}%
  \setunit*{\addcomma\space}% NEW
  \printfield{number}%
  \setunit{\addcomma\space}%
  \printfield{eid}%
}

%-- Just make sure that the page range field is displayed before the note one.
%-- The "note+page" bibmacro is only defined for article type (see "standard.bbx" file)

\renewbibmacro*{note+pages}{% Seems to be OK → TODO: verify if there is no side effect
  %\printfield{note}% ← deleted
  \setunit{\bibpagespunct}%
  \printfield{pages}%
  \newunit%
  \printfield{note}% ← added
}

%-- No "in:" before journal or proceedings name of the articles
%-- https://tex.stackexchange.com/questions/10682/suppress-in-biblatex

\renewbibmacro{in:}{%
  %--- Tests non concluants pour le moment... À suivre
  %\ifentrytype{article}{}{\printtext{\bibstring{in}:\addthinspace}}%\addcolon
  %\ifentrytype{article}{}{\printtext{\bibstring{in}\intitlepunct\hspace*{-0.5em}}}
  %---
  %\ifentrytype{article}{}{\printtext{\bibstring{in}\intitlepunct}}
  \ifboolexpr{%
    test {\ifentrytype{article}}%
    or
    test {\ifentrytype{inproceedings}}%
  }{}{\printtext{\bibstring{in}\intitlepunct}}%
}

%-- A smaller font for URL display (see doc. p.120 for the \mkbibacro macro)

\DeclareFieldFormat{url}{\mkbibacro{URL}\addcolon\space\small\url{#1}}
%\DeclareFieldFormat{url}{\newline\mkbibacro{URL}\addcolon\space\footnotesize\url{#1}}% à la ligne
%\DeclareFieldFormat{urldate}{\footnotesize\mkbibparens{\bibstring{urlseen}\space#1}}

%-- URL + URLdate after a line break
%-- http://tex.stackexchange.com/questions/27953/linebreak-before-url-with-biblatex-alphabetic

%\renewbibmacro*{url+urldate}{%
%  \printfield[url]{url}%
%  \iffieldundef{urlyear}{}
%  {\setunit*{\addspace}%
%  \printtext[urldate]{\printurldate}}}

%-- Présentation par blocs (URL, DOI, etc.), uniquement dans la bibliographie
%-- cf. http://tex.stackexchange.com/questions/29802/biblatex-and-new-line-for-doi-url-and-eprint
%-- Nouveau bloc (\setunit is an alternative to \newunit that allows to set punctuation instead of
%-- \newunitpunct (which is typically a period plus a space)

\newbibmacro*{bbx:parunit}{%
  \ifbibliography{%
    \setunit{\bibpagerefpunct}\newblock
    \usebibmacro{pageref}%
    \clearlist{pageref}%
    \setunit{\adddot\par\nobreak}%
  }{}%
}
\renewbibmacro*{doi+eprint+url}{%
  \usebibmacro{bbx:parunit}% Added
  \iftoggle{bbx:doi}
    {\printfield{doi}}
    {}%
  \iftoggle{bbx:eprint}
    {\usebibmacro{eprint}}
    {}%
  %\iftoggle{bbx:url}% !!! USELESS IF LINKED TO THE TITLE !!!
  %  {\usebibmacro{url+urldate}}
  %  {\small\usebibmacro{url+urldate}}
  %  {}%
}
%- eprint
\renewbibmacro*{eprint}{%
  \usebibmacro{bbx:parunit}% Added
  \iffieldundef{eprinttype}
    {\printfield{eprint}}
    {\printfield[eprint:\strfield{eprinttype}]{eprint}}%
}
% URL + Date !!! USELESS IF LINKED TO THE TITLE !!!
%\renewbibmacro*{url+urldate}{%
%  \usebibmacro{bbx:parunit}% Added
%  \printfield{url}%
%  \iffieldundef{urlyear}
%    {}
%    {\setunit*{\addspace}%
%     %\printtext[urldate]{\printurldate}}}% rajoute deux fois le label why?
%     \footnotesize\printtext{\printurldate}}}

%-- New bibmacro for only institution+location insted of institution+location+date (see report)

\newbibmacro*{institution+location}{% Borrowed and adapted from standard.bbx: deleting date macro
  %--- Original
  %\printlist{location}
  %\iflistundef{institution}
    %{\setunit*{\addcomma\space}}
    %{\setunit*{\addcolon\space}}%
  %\printlist{institution}%
  %\setunit*{\addcomma\space}%
  %\usebibmacro{date}%
  %\newunit
  %--- Modified
  \iflistundef{institution}
    {\setunit*{\adddot\space}}
    {\setunit*{\adddot\space}}%
  \printlist{institution}%
  \iflistundef{location}
    {\setunit*{\addcomma\space}}
    {\setunit*{\addcolon\space}}%
  \printlist{location}%
  \newunit
}

%-- Reordering the electronic references at the end of bibitem (url, doi...)
%-- https://tex.stackexchange.com/questions/46804/can-i-reorder-the-fields-in-a-biblatex-bibliography
%-- https://tex.stackexchange.com/questions/6743/biblatex-changing-the-order-of-entries

\newbibmacro*{addendum+pubstate+pageref}{%
  \usebibmacro{addendum+pubstate}%
  \clearfield{addendum}%
  \clearfield{pubstate}%
  \setunit{\bibpagerefpunct}\newblock
  \usebibmacro{pageref}%
  \clearlist{pageref}%
  \newunit\newblock%
}
\xpretobibmacro{doi+eprint+url}{\usebibmacro{addendum+pubstate+pageref}}{}{}
\xpretobibmacro{eprint}{\usebibmacro{addendum+pubstate+pageref}}{}{}
\xpretobibmacro{url+urldate}{\usebibmacro{addendum+pubstate+pageref}}{}{}

%\newbibmacro{string+doi}[1]{%
%  \iffieldundef{doi}{#1}{\href{http://dx.doi.org/\thefield{doi}}{#1}}
%}
%\DeclareFieldFormat{title}{\usebibmacro{string+doi}{\mkbibemph{#1}}}
%\DeclareFieldFormat[article]{title}{\usebibmacro{string+doi}{\mkbibquote{#1}}}
%\DeclareFieldFormat{title}{\mkbibquote{\textit{#1}\isdot}}

%-- Linked title to the URL, DOI, and WorldCat search depending on their presence in the .bib file
%-- Hyperlien sur le titre renvoyant aux URL, DOI, WorldCat selon leur présence dans le fichier .bib
%-- http://tex.stackexchange.com/questions/48400/biblatex-make-title-hyperlink-to-dois-url-or-isbn
%-- http://tex.stackexchange.com/questions/23832/biblatex-make-title-hyperlink-to-doi-url-if-available

%- URL prefix for WorldCat query
\def\worldcatsearch{http://www.worldcat.org/search?qt=worldcat_org_all&q=}

%- First approach: \newbibmacro
\newbibmacro{string+url+doi+issn+isbn}[1]{%
  \iffieldundef{url}{%
    \iffieldundef{doi}{%
      \iffieldundef{isbn}{%
        \iffieldundef{issn}{%
          #1%
        }{%
          \href{\worldcatsearch\thefield{issn}}{#1}%
          %\href{http://books.google.com/books?vid=ISSN\thefield{issn}}{#1}%
        }%
      }{%
        \href{\worldcatsearch\thefield{isbn}}{#1}%
        %\href{http://books.google.com/books?vid=ISBN\thefield{isbn}}{#1}%
      }%
    }{%
      \href{http://dx.doi.org/\thefield{doi}}{#1}%
    }%
  }{%
    \href{\thefield{url}}{#1}%
  }%
}

%-- Putting title field inside quotation mark (with the csquotes package for language dependency)

%- All driver options are:
%- [article,book,booklet,collectioninbook,incollection,inproceedings,manual,misc,online,patent,
%-  periodical,proceedings,report,thesis,unpublished]
\DeclareFieldFormat[%
  article,book,inproceedings,online,report,video%
  ]{title}{%
  \usebibmacro{string+url+doi+issn+isbn}{\mkbibquote{\mkbibitalic{#1}}}%
}
%\DeclareFieldFormat[article,inbook,incollection,inproceedings,patent,thesis,unpublished]{title}{%
%  \mkbibquote{#1\isdot}%
%}


%-- Patching/redefining title bibmacro to change the punctuation (comma instead of period)
%-- See definition in "biblatex.def": https://tex.stackexchange.com/questions/194557/
%-- (no-period-between-article-name-and-journal-article-only-authoryear-ibid)

%\xpatchbibmacro{title}% From biblatex.def file
%  {\printfield[titlecase]{subtitle}}
%  {\printfield[titlecase]{subtitle}
%    \ifentrytype{online}{\addperiod}{\addcomma\space}% OK
%    %\ifentrytype{article}{\addcolon}{}% OK
%    %\ifentrytype{book}{\addsemicolon}{}% OK
%  }{}{}%

%- Redefining the `title' bibmacro may be more direct and flexible for further modifications
\renewbibmacro*{title}{%
  \ifboolexpr{ test {\iffieldundef{title}} and test {\iffieldundef{subtitle}} }
    {}{%
      \printtext[title]{%
        \printfield[titlecase]{title}%
        \setunit{\subtitlepunct}%
        \printfield[titlecase]{subtitle}%
        %\ifentrytype{online}{\addperiod}{\addcomma\space}% If title inside quotes
      }%
      \newunit%
      \ifentrytype{online}{\addperiod}{\addcomma\space}%
      %\ifentrytype{online}{\setunit{\addperiod}}{\setunit{\addcomma\space}}%
    }%
  \printfield{titleaddon}%
}

%\DeclareFieldFormat[article,book,incollection]{title}{%
%  \usebibmacro{string+doi+url+issn+isbn}{\mkbibitalic{#1}}
%}

%---
%- Second approach: defining and applying a new format `linked'
% Define new format that applies a hypertext reference
%\DeclareFieldFormat{linked}{%
%  \ifboolexpr{ test {\ifhyperref} and not test {\ifentrytype{online}} }
%    {\iffieldundef{doi}
%      {\iffieldundef{url}
%        {\iffieldundef{isbn}
%          {\iffieldundef{issn}
%              {#1}
%          {\href{\worldcatsearch\thefield{issn}}{#1}}}
%        {\href{\worldcatsearch\thefield{isbn}}{#1}}}
%      {\href{\thefieldfirstword{url}}{#1}}}
%    {\href{http://dx.doi.org/\thefield{doi}}{#1}}}
%  {#1}}
% Define new command that returns the first word of a given field
%\def\thefieldfirstword#1{%
%  \expandafter\expandafter
%  \expandafter\firstword
%  \expandafter\expandafter
%  \expandafter{\csname abx@field@#1\endcsname}}
%\def\firstword#1{\firstword@i#1 \@nil}
%\def\firstword@i#1 #2\@nil{#1}
% Declaring several fields in file.bib, i.e. with URL:
% url = {http://www.chicagomanualofstyle.org http://www.chicagomanualofstyle.org/16/contents.html},
%---
%- Below is the original application of the second approach to hyperlinked title and subtitle
% Redefine url format to print only first URL, omit URL prefix
%\DeclareFieldFormat{url}{\url{\firstword{#1}}}
%\renewbibmacro*{title}{% Based on generic definition from biblatex.def
%  \ifboolexpr{ test {\iffieldundef{title}} and test {\iffieldundef{subtitle}} }
%    {}
%    {\printtext[title]{\printtext[linked]{%
%      \printfield[titlecase]{title}%
%      \setunit{\subtitlepunct}%
%      \printfield[titlecase]{subtitle}}}%
%    \newunit}%
%  \printfield{titleaddon}}
%\renewbibmacro*{periodical}{% Based on generic definition from biblatex.def
%  \iffieldundef{title}
%    {}
%    {\printtext[title]{\printtext[linked]{%
%      \printfield[titlecase]{title}%
%      \setunit{\subtitlepunct}%
%      \printfield[titlecase]{subtitle}}}}}
%- The `library' field is not enabled in the standard styles => redef. "addendum+pubstate",
%- if needed: http://tex.stackexchange.com/questions/243340/include-call-number-for-books-in-reference
%- For example:
%\renewbibmacro*{addendum+pubstate}{%
%  \printfield{addendum}%
%  \newunit\newblock
%  \printfield{pubstate}%
%  \newunit\newblock
%  \printfield{library}}
%---

%-- Linked publisher name with library field: applying the second approach

\DeclareFieldFormat{linkedpublisher}{%
  \ifboolexpr{ test {\ifhyperref} and not test {\ifentrytype{online}} }
  {\iflistundef{publisher}{#1}{\href{\thefield{library}}{#1}}}
  {#1}%
}
%\DeclareFieldFormat{library}{\bibstring{library}\addcolon\space #1}
%\DeclareFieldFormat{publisher}{\url{\firstword{#1}}}
%\DeclareFieldFormat{publisher}{\url{#1}}

%-- Moving the pagetotal field (used by the book driver and others) in the "standard.bbx" file
%-- https://tex.stackexchange.com/questions/269999/biblatex-biber-put-series-volume-and-number-at-the-end

\newcommand*\patchpagetotalfield[1]{%
  \xpatchbibdriver{#1}
  {\newunit\printfield{pagetotal}}
  {}
  {}
  {\ClassWarning{texjazz-handbook.cls}{Bibliography customizing:\MessageBreak
    Failed to remove pagetotal field from driver #1.}}
}
\patchpagetotalfield{book}
\patchpagetotalfield{booklet}
\patchpagetotalfield{collection}
\patchpagetotalfield{manual}
\patchpagetotalfield{proceedings}
%\patchpagetotalfield{report}
\patchpagetotalfield{thesis}

%- Reordering, linking publisher and adding the pagetotal field to the publisher+location+date macro
\renewbibmacro*{publisher+location+date}{% Based on generic definition from `standard.bbx'
  %\printlist{location}% ← Removed
  \iflistundef{publisher}
    {\setunit*{\addcomma\space}}% ← Original: {\setunit*{\addcomma\space}}
    {\setunit*{\addcomma\space}}% ← Original: {\setunit*{\addcolon\space}}%
  \printtext[linkedpublisher]{\printlist{publisher}}% ← Original: \printlist{publisher}%
  \setunit*{\addcomma\space}%
  \printlist{location}% ← Added
  \setunit*{\addcomma\space}% ← Added
  \printfield{pagetotal}% ← Added
  \usebibmacro{date}%
  \newunit%
}

%-- Setting the separation between bibitem and addendum (isbn/issn, addendum, etc.)

\newcommand*\patchbibitemsep[1]{%
  \xpatchbibdriver{#1}
  {\newunit\newblock\iftoggle{bbx:isbn}}
  {\setunit{\addspace\textemdash\addspace}\newblock\iftoggle{bbx:isbn}}
  {}
  {\ClassWarning{texjazz-handbook.cls}{Bibliography customizing:\MessageBreak
    Failed to add emdash at end of bibitem for driver #1.}}
}
\patchbibitemsep{article}\patchbibitemsep{book}\patchbibitemsep{collection}
\patchbibitemsep{inbook}\patchbibitemsep{incollection}\patchbibitemsep{inproceedings}
\patchbibitemsep{manual}\patchbibitemsep{periodical}
\patchbibitemsep{proceedings}\patchbibitemsep{report}\patchbibitemsep{thesis}

%-- Rajout et mise en forme du champ de résumé/quatrième de couverture s'il existe (en fin d'entrée)
%-- https://tex.stackexchange.com/questions/301993/create-custom-note-environment-with-tcolorbox

\newlength{\bibabstractWidth}
\setlength{\bibabstractWidth}{0pt}
\newcommand*{\bibabstractTagColor}{secondcolor}

\DeclareFieldFormat{abstract}{%
  \begin{tcolorbox}[
    enhanced jigsaw, % better frame drawing
    %borderline west={2pt}{0pt}{red}, % straigh vertical line at the left edge
    %sharp corners, % No rounded corners
    boxrule=0pt, % no real frame,
    breakable, notitle,
    fontupper={\fontsize{8.5pt}{10pt}\selectfont\itshape},%\footnotesize\itshape,
    halign=justify,
    colback=darkgray!20, colframe=firstcolor,
    boxrule=0pt, leftrule=1mm, arc=0pt, boxsep=0pt,
    left=4pt, right=4pt, top=4pt, bottom=4pt,
    beforeafter skip=2pt,% left skip=\settowidth{\normalfont\faTags\quad},
    before upper=\llap{\textcolor{\bibabstractTagColor}{\normalfont\faTags}%
                       \hspace*{1.25em}\vspace*{-\baselineskip}},
    width=\linewidth-\bibabstractWidth,
    enlarge left by=\bibabstractWidth,
    %show bounding box,
    ]#1
  \end{tcolorbox}
}
\renewbibmacro*{finentry}{%
  \iffieldundef{abstract}
    {\finentry\addperiod}% Adding a final dot for the \fullcite macro too
    {\ifboolexpr{ test {\ifcitation} }
      {\setlength{\bibabstractWidth}{\parindent}%
       \renewcommand*{\bibabstractTagColor}{firstcolor}%
       \printfield{abstract}\nopunct\finentry}% If citation (\fullcite) lesser \linewidth (for tag)
      {\printfield{abstract}\nopunct\finentry}% No spurious last dot added after the abstract field
    }%
}


%---------------------------------------------------------------------------------------------------
%---- Electronic circuits typesetting
%---------------------------------------------------------------------------------------------------

%\RequirePackage{circuitikz}% Not needed: TikZ circuit library is sufficient


%---------------------------------------------------------------------------------------------------
%---- Modelling typesetting tools for Merise and UML
%---------------------------------------------------------------------------------------------------

\ifdoc@modelling

%-- Aggregation of the `pgf-umlcd' and `pgf-umlcd' packages + personal add-ons for Merise
\RequirePackage{texjazz-modelling}

%\tikzset{jazzumlactor/.style={font=\Large}}

%-----
%- See:
%-    https://tex.stackexchange.com/questions/56029/[...]
%-      [...]on-a-problem-related-to-uml-class-diagram-using-pgf-umlcd
%-   https://tex.stackexchange.com/questions/291833/[...]
%-      [...]pgf-umlcd-underscore-in-class-name-failing
%-----

%-----
%- See also: https://tex.stackexchange.com/questions/130124/crash-of-tikz-uml-and-pgf-umlcd
%- The two packages pgf-umlcd and tikz-uml use \umlnote command
%\let\umlnotepgfumlcd\umlnote% Store the command from pgf-umlcd package
%\let\umlnote\relax% Let \umlnote command be defined by the tikz-uml package
%-----

%- Modified/extended version of the `tikz-uml' package by N. Kielbasiewicz v1.0 (29 March 2016):
%-   https://perso.ensta-paristech.fr/~kielbasi/tikzuml/
\RequirePackage{texjazz-tikz-uml}% Custom and extended version of the `tikz-uml' package

%- Setting default document TikZ-UML (TeXjazz modified) package options and parameters
\tikzumlset{
  text=black,% Default = black
  font=\footnotesize,% Default = \footnotesize
  draw=secondcolor,% Default = black
  package type=tikzumlEmpty,% Default = tikzumlEmpty
  fill package=blue!20,% Default = blue!20
  class width=5ex,% Default = 10ex
  simple interface width=4ex,% Default = 4ex
  class type=class,% Default = class
  fill class=yellow!30,% Default = yellow!20
  fill template=yellow!2,% Default = yellow!2
  narynode width=6ex,% Default = 6ex
  relation geometry=--,% Default = --
  relation angle1=-30,% Default = -30
  relation angle2=30,% Default = 30
  relation loopsize=3em,% Default = 3em
  relation weight=0.5,% Default = 0.5
  relation pos1=0.2,% Default = 0.2
  relation pos2=0.8,% Default = 0.8
  relation pos stereo=0.5,% Default = 0.5
  note width=3cm,% Default = 3cm
  fill note=green!20,% Default = green!20
  fill system=firstcolor!20,% Default = white
  fill usecase=yellow!30,% Default = blue!20
  actor below=3ex,% Default = 0.5cm,
  state join width=3ex,% Default = 3ex
  state decision width=3ex,% Default = 3ex
  state initial width=14pt,% Default = 5ex
  state final width=14pt,% Default = 5.5ex
  state enter width=5ex,% Default = 5ex
  state exit width=5ex,% Default = 5ex
  state end width=5ex,% Default = 5ex
  state history width=2.0ex,% Default = 5ex
  state deep history width=5ex,% Default = 5ex
  state width=0.25cm,% Default = 8ex
  fill state=yellow!30,% Default = yellow!20
  object stereo=object,% Default = object
  fill object=yellow!30,% Default = yellow!20
  call dt=tikzumlEmpty,% Default = tizumlEmpty
  call padding=2,% Default = 2
  call type=synchron,% Default = synchron
  fill call=firstcolor!20,% Default = white
  fragment type=opt,% Default = opt
  fragment inner xsep=1,% Default = 1
  fragment inner ysep=1,% Default = 1
  fill fragment= none,% Default = none
  create call dt=4,% Default = 4
  component width=8ex,% Default = 8ex
  fill component= yellow!30,% Default = yellow!20
  required interface distance=2.5cm,% Default = 2.5cm
  required interface width=1em,% Default = 1em
  required interface padding=1cm,% Default = 1cm
  provided interface distance=3cm,% Default = 3cm
  provided interface width=1em,% Default = 1em
  provided interface padding=1cm,% Default = 1cm
  port width=1ex,% Default = 1ex
  fill port= yellow!30,% Default = yellow!20
  fill assembly connector/.initial= white,% Default = white
  %- TeXjazz control options add-ons / modifications
  line width=0.6pt,% New control, default = 0.6pt
  %- Class
  class inner xsep=4pt,% Inner xsep for the `umlclass' commands/diagrams
  class inner ysep=2pt,% Inner ysep for the `umlclass' commands/diagrams
  class attribute font=\scriptsize,% New TeXjazz control, default = \scriptsize
  class operation font=\scriptsize,% New TeXjazz control, default = \scriptsize
  %-System
  system inner xsep=6pt,% Use case background frame inner xsep aka 'umlsystem' env.
  system inner ysep=6pt,% Use case background frame inner ysep aka 'umlsystem' env.
  %- Collaboration (new diagram)
  collaboration inner xsep=4pt,% Inner xsep for the `umlcollaboration' command/diagram
  collaboration inner ysep=2.5pt,% Inner ysep for the `umlcollaboration' command/diagram
  collaboration attribute font=\scriptsize,% New TeXjazz control, default = \scriptsize
  %- Object
  scale object=0.6,% Default = 1 (pictured object scale like actor, database, etc.) → \umlobject cmd
  scale actor=0.5,% Default = 1 (alone/independent pictured actor scale) → \umlactor command
  object inner xsep=4pt,% Inner xsep for the `umlobject/umlsimpleobject' commands/diagrams
  object inner ysep=2.5pt,% Inner ysep for the `umlobject/umlsimpleobject' commands/diagrams
  simple object attribute font=\scriptsize,% New TeXjazz control, default = \scriptsize
  %- Activity (new diagram)
  activity inner xsep=4pt,% Inner xsep for the `umlactivity' commands/diagrams
  activity inner ysep=2.5pt,% Inner ysep for the `umlactivity' commands/diagrams
  activity rounded corners=0.6\baselineskip,
  width activity=1cm,% New TeXjazz activity diagram (\umlactivity command), default = 0.75cm
  fill activity=yellow!30,% New TeXjazz activity diag. (\umlactivity command), default = yellow!20
  node distance activity=0.6cm,% New TeXjazz activity diag. (\umlactivity command), default = 0.6cm
  %- State-transition diagram
  state inner xsep=4pt,% Inner xsep for the `umlactivity' environment/command/diagram
  state inner ysep=2.5pt,% Inner ysep for the `umlactivity' environment/command/diagram
  state action font=\scriptsize,% New TeXjazz control, default = \scriptsize
  %- Deployment diagram
  fill deployment=white,
  %deployment font=\footnotesize,
  deployment attribute font=\scriptsize,
  deployment minimum width=1.0cm,
  deployment inner xsep=4pt,% Front face
  deployment inner ysep=2.5pt,% Front face
  deployment zangle=25,
  deployment zscale=0.5,
}

\fi


%---------------------------------------------------------------------------------------------------
%---- Counters and associated calculations
%---------------------------------------------------------------------------------------------------

%\RequirePackage{refcount}% Need to be loaded?
%- Cf. http://tex.stackexchange.com/questions/179824/tufte-style-table-of-contents-in-article-class
%- For having bookmarks to the referenced page, see also:
%-   https://tex.stackexchange.com/questions/11962/how-to-determine-current-page-number


%-- Count of the sectioning elements (and potentialy other elements)
%---
%- Here, the aim is first to be able to count and control the display of ToC depending of the number
%- of sections in each chapter. To access the total number of "counter element", the helper package
%- is `totcount', but may be 'xassoccnt' has to be considered. If so, this later package must be
%- loaded after `calc' and related packages (e.g. mathtools) and before 'hyperref' and 'cleveref'
%- below (see doc. p. 8-9).
%---
%\RequirePackage{totcount,assoccnt}% Deprecated
%- Below the `assoccnt.sty' extended version
%- (much more obscure code to understand for us, but more powerful and without noted side effects)
%\RequirePackage{xassoccnt}%

%-- Count of main chapters, appendix chapters and total chapters
%---
%- From egreg: http://tex.stackexchange.com/questions/339439/counting-chapters-and-appendices/
%- It works fine in a separate document but not with this class... ???
%- With the new `xassoccnt' package (v1.1--2016/10), it works like a charm!
%---

%\newcounter{truechapters}
%\regtotcounter{truechapters}

%\newcounter{totalchapters}
%\newcounter{appendixchapters}
%\DeclareAssociatedCounters{chapter}{totalchapters,appendixchapters}
%\regtotcounter{totalchapters}
%\regtotcounter{appendixchapters}

%\preto\appendix{%
%  % save the number of true chapters
%  \setcounter{truechapters}{\value{chapter}}%
%  % reset the number of chapters
%  \setcounter{appendixchapters}{0}%
%}


%\NewTotalDocumentCounter{xmainchapters}
%\NewTotalDocumentCounter{xappendixchapters}
%\NewTotalDocumentCounter{xtotalchapters}
%%\NewTotalDocumentCounter{countchapters}% It works when I print it! Otherwise not!!! WHY?
%\DeclareAssociatedCounters{chapter}{xtotalchapters,xappendixchapters}%
%\RegisterTotalDocumentCounter{chapter}
%\RegisterTotalDocumentCounter{section}
%\RegisterTotalDocumentCounter{page}
%\RegisterTotalDocumentCounter{figure}
%\RegisterTotalDocumentCounter{table}

%- Redefining the appendix macro
%\preto\appendix{%
%  % save the number of main chapters
%  \setcounter{mainchapters}{\value{chapter}}%
%  % reset the number of chapters
%  \setcounter{appendixchapters}{0}%
%}


%---------------------------------------------------------------------------------------------------
%---- Navigation with hyperlinks
%---------------------------------------------------------------------------------------------------

%-- Appel en fin préambule/extension car redéfini beaucoup de chose et problèmes possibles
\RequirePackage{hyperref}% bookmarks option or OK with hypersetup? TODO: verify

\colorlet{webjazz}{black!40!secondcolor}
\hypersetup{%
  unicode,% Encoded PDF string: NEEDED to have correct accented bookmarks in French (signets)
  %pdfborder=0 0 0,% no border to links
  %linktocpage=true,% true: link on the page number, false (default): link on the text entry
  %linktoc=both,% links on TOC, LOF, etc. as text (section), page (page), both (all), nothing (none)
  pdfstartpage=1,%
  pdfstartview=FitB,
  breaklinks=true,% allows line break for links
  %pdfpagemode=UseNone,% warning: already been used -> commented
  pageanchor=true,%
  plainpages=false,%
  %bookmarks=true,% make bookmarks: already set → no effect warning
  bookmarksnumbered,% Put section numbers in bookmarks / Numérotation des signets des sections
  bookmarksopen=true,% Open up the bookmark tree / ouverture de l'arborescence dans le visionneur
  bookmarksopenlevel=1,% max level to which bookmarks are open: overparagraph=4 / subsubsection=3
  bookmarksdepth=6,% subparagraph=6
  hypertexnames=true,%
  %pdfhighlight=/O,%
  %hyperfootnotes=true,% warning: already been used (defaut?) -> commented
  colorlinks=true,%
  %allcolor=firstcolor,%darkelectricblue,% default=none (without border and field options)
  linkcolor=firstcolor,%maincolor,% default=red
  anchorcolor=firstcolor,% default=black
  citecolor=firstcolor,% default=green
  filecolor=firstcolor,% default=cyan
  menucolor=firstcolor,% default=red
  runcolor=firstcolor,% default=filecolor
  urlcolor=firstcolor,%webjazz,% default=magenta
  %pdfpagelabels,% warning: already been used (defaut?) -> commented
  %pdfsubject={},% Set in main file
  %pdfkeywords={},% Set in main file
  pdfcreator={LuaTeX},%
  pdfproducer={LaTeX with hyperref and TeXjazz bundle}%
}
%- !!! TIP !!! To get the name of a targered label (sections, etc.) use \nameref{<label>}
%- The `nameref' package is part of the 'hyperref' package bundle. No need to load it.

%\RequirePackage{memhfixc} %fix some problem with hyperref

% Breaking line also on hyphens inside the \url command (it's the url.sty add-on)
%\def\UrlBreaks{\do\.\do\@\do\\\do\/\do\!\do\_\do\|\do\;\do\>\do\]%
%  \do\)\do\,\do\?\do\'\do+\do\=\do\#\do-}

% A fix for \href{}{} colors not working with fontspec TODO: updates the need
%\def\HyColor@@@@UseColor#1\@nil{\addfontfeatures{Color=#1}}

%-- Gestion des hyperliens / Hyperlinks management (extensions of the `hyperref' package)
%- Line breaks in URLs

\PassOptionsToPackage{hyphens,obeyspaces,spaces}{url}% allows hyphenation in URLs and at spaces too
\RequirePackage{url}% formatting different styles of URL: hypertext links, email adresses, etc.

%- See: https://tex.stackexchange.com/questions/3033/forcing-linebreaks-in-url
\g@addto@macro{\UrlBreaks}{\UrlOrds}

%\renewcommand\UrlFont{\color{red}\ttfamily}% same as urlcolor=setcolor if only color is changed
\renewcommand\UrlFont{\upshape\ttfamily}% sets upright font in all contexts
%\let\urlorig\url
%\renewcommand{\url}[1]{\begin{otherlanguage}{english}\urlorig{#1}\end{otherlanguage}}

%-- Avoiding not supported commands in bookmarks (typography and formating)
%-- https://tex.stackexchange.com/questions/10555/hyperref-warning-token-not-allowed-in-a-pdf-string

%-- The other solution is to use \texorpdfstring{<TeX version>}{<PDF version>}
%-- https://tex.stackexchange.com/questions/159438

%\pdfstringdefDisableCommands{%
%  \def\newline{}%
%  \def\\{}%
%  \def\texttt#1{<#1>}%
%}

\newcommand{\tophyperref}[1]% #1 = label
{\hyperlink{page.\getpagerefnumber{#1}}{\getrefnumber{#1}}}

%- https://tex.stackexchange.com/questions/230577/[...]
%-   [...]hyperref-chapter-in-twocolumn-mode-without-using-multicols/

%- Add extra hyper target for chapter: chapter..\thechapter
%\renewcommand*{\chapterformat}{%
%  \mbox{\raisebox{25pt}[0pt][0pt]{\hypertarget{chapter..\thechapter}{}}% Add
%    \chapappifchapterprefix{\nobreakspace}\thechapter\autodot\enskip}%
%}
%- Update \addcontentsline to jump to new hyper target _only_ if \part is used
%\patchcmd{\addcontentsline}% <cmd>
%  {\Hy@writebookmark}% <search>
%  {\ifnum\pdfstrcmp{part}{#2}=-1 % Part mark
%     \edef\@currentHref{part..\thepart}%
%   \fi
%   \Hy@writebookmark}% <replace>
%  {}{}% <success><failure>


%---------------------------------------------------------------------------------------------------
%---- Crossed references
%---------------------------------------------------------------------------------------------------

%-- Gestion des références de pages

%\RequirePackage{varioref}% Fonctionnalités présentes dans `cleveref'

%-- Gestion des références croisées / Automatic management of cross-references

%- The `cleveref' package must be the last loaded package
%\RequirePackage[french]{cleveref}% No language setting with Polyglossia: overrides the settings
\RequirePackage[french,nameinlink]{cleveref}% hyperlinks all the cross-reference (nameref+label)

%-- Customizing refnames

%\ifdoc@english
%\else
\Crefname{figure}{Fig.}{Fig.}
\crefname{figure}{figure}{figures}
\Crefname{table}{Tab.}{Tab.}
\crefname{table}{table}{tables}% \crefname{table}{tableau}{tableaux}% polyglossia default
\Crefname{section}{{\S}}{{\S}}
\crefname{section}{{\S}}{{\S}}
\Crefname{part}{Partie}{Parties}
\crefname{part}{partie}{parties}
\Crefname{chapter}{Chap.}{Chap.}
\crefname{chapter}{chapitre}{chapitres}
\Crefname{appendixchapter}{Annexe}{Annexes}
\crefname{appendixchapter}{annexe}{annexes}
\Crefname{exercise}{Exercice}{Exercices}
\crefname{exercise}{exercice}{exercices}
\Crefname{quiz}{Quiz}{Questionnaires}
\crefname{quiz}{quiz}{questionnaires}
%\Crefname{examination}{Examen}{Examens}
%\crefname{examination}{examen}{examens}
\Crefname{video}{Vid.}{Vid.}
\crefname{video}{vidéo}{vidéos}
\Crefname{document}{Doc.}{Doc.}
\crefname{document}{document}{documents}
\Crefname{code}{Code}{Codes}% Defined with tcolorbox environment? NO! DOES NOT WORK! WHY?
\crefname{code}{code}{codes}% Defined with tcolorbox environment? NO! DOES NOT WORK! WHY?
\Crefname{listing}{Listing}{Listings}
\crefname{listing}{listing}{listings}
\Crefname{algorithm}{Algorithm}{Algorithms}
\crefname{algorithm}{algorithm}{algorithms}
\Crefname{formation}{Form.}{Form.}% adds ref. for `Formation' environment
\crefname{formation}{formation}{formations}% adds ref. for `Formation' environment
%\fi

%---
%- From: https://tex.stackexchange.com/questions/332251/nameref-does-not-work-with-stylisharticle
%- where from `titlesec' documentation, Heiko Oberdiek recalls that:
%- "`nameref' supports `titlesec', but `hyperref''
%- missing with unnumbered section, perhaps problems with page breaks with numbered ones)."
%---
%- See also: https://tex.stackexchange.com/questions/123666/
%- (nameref-breaks-for-star-versions-of-section-paragraph-when-titlesec-is-loaded)
%\def\ttl@useclass#1#2{%
%  \@ifstar
%    {\ttl@labelfalse\@dblarg{#1{#2}}}% {\ttl@labelfalse#1{#2}[]}%
%    {\ttl@labeltrue\@dblarg{#1{#2}}}}
%---

%---
%- BUG WITH PART CALL/LABEL: FIXME → BUG FROM `titlesec' and `hyperref'
%- IS THE FOLLOWING REFERENCE THE SOLUTION? (David Carlisle answer) YES, IT WORKS! SIDE EFFECTS?
%- YES THERE ARE SIDE EFFECTS BECAUSE ONLY THE TITLE IS HERE CONSIDERED, NOT THE OPTIONAL ARGUMENT
%- WRONG RESULT IS OBTAINED IF IT IS USED. SO, THE \part COMMAND MUST BE CHANGE ABOVE... SAD :-(
%- https://tex.stackexchange.com/questions/211035/[...]
%-   [...]problems-with-nameref-not-refering-to-the-correct-label-x-titlesec
%\let\oldpart\part
%\def\part#1{\def\@currentlabelname{#1}\oldpart{#1}}
%- THE SOLUTION WITHOUT SIDE EFFECTS IS JUST BELOW
%---

%---
%- With `titlesec' and `hyperref' packages, \nameref link name is wrong and must be updated:
%-  "\@currentlabelname internal command which holds the section name is not updated,
%-   for some reason, when redefining part with titlesec. A way to get around this is to redefine
%-   the \part command to force this updating."
%- See: https://tex.stackexchange.com/questions/6609/problems-with-part-labels-using-titlesec
%- This incompatibility occurs with self sectioning command \appendixchapter, but may be
%- the below fix has to be applied to other commands. YES! IT MUST ALSO BE APPLIED TO PART COMMAND!
%---

\let\titlesec@part\part
\renewcommand{\part}{\@ifstar\part@star\part@nostar}
\def\part@star#1{\NR@gettitle{#1}\titlesec@part*{#1}}
\def\part@nostar{\@ifnextchar[\part@nostar@opt\part@nostar@nopt}
\def\part@nostar@nopt#1{\NR@gettitle{#1}\titlesec@part{#1}}
\def\part@nostar@opt[#1]#2{\NR@gettitle{#2}\titlesec@part[#1]{#2}}

\ifdoc@article\else
  \let\titlesec@appendixchapter\appendixchapter
  \renewcommand{\appendixchapter}{\@ifstar\appendixchapter@star\appendixchapter@nostar}
  \def\appendixchapter@star#1{\NR@gettitle{#1}\titlesec@appendixchapter*{#1}}
  \def\appendixchapter@nostar{\@ifnextchar[\appendixchapter@nostar@opt\appendixchapter@nostar@nopt}
  \def\appendixchapter@nostar@nopt#1{\NR@gettitle{#1}\titlesec@appendixchapter{#1}}
  \def\appendixchapter@nostar@opt[#1]#2{\NR@gettitle{#2}\titlesec@appendixchapter[#1]{#2}}
\fi

%- Nameref in quotes (egreg: http://tex.stackexchange.com/questions/258358/nameref-with-quotes)
\NewDocumentCommand{\qnameref}{s m}{% BUG WITH PART CALL/LABEL: THE FIX IS GIVEN JUST ABOVE
  % Usage − with star = no hyperlink
  \enquote{\IfBooleanTF{#1}{\nameref*{#2}}{\nameref{#2}}}%
}
%\AtBeginDocument{\LetLtxMacro{\oldnameref}{\nameref}%
%  \RenewDocumentCommand{\nameref}{s m}{%
%    \enquote{%
%      \IfBooleanTF{#1}{\oldnameref*{#2}}{\oldnameref{#2}}%
%    }%
%  }%
%}

%- Warning/Take care: \fullref is defined by the `varioref' package
\newcommand{\fullRef}[1]{\Cref{#1}\enspace\qnameref{#1}}

%- Having reference to the label + text (D. Carlisle)
%- http://tex.stackexchange.com/questions/235608/repeat-the-entire-labeled-text-upon-referencing
%- See also
%- http://tex.stackexchange.com/questions/308125/associate-dynamic-text-to-a-label
%\newcommand\refText[2]{%
%  \expandafter\gdef\csname item#1\endcsname{#2}%
%  \label{#1}#2}
%\newcommand\useitemtext[2]{\csname item#1\endcsname}


%---------------------------------------------------------------------------------------------------
%---- Bookmarks − extending/improving utilities from the 'hyperref' package / Gestion des signets
%---------------------------------------------------------------------------------------------------

%- Bookmark management: still "experimental", but efficient improvement of the `hyperref' package
\RequirePackage{bookmark}% Better management of bookmarks (layout and less restriction on levels)

%----- Dealing with bookmarks
%- At a first glance, setting bookmarks is automatic when using the 'hyperref' package, but when
%- one wants to fine tune the bookmarks that's not an obvious task. Moreover, when the 'titlesec'
%- package is used − as here −, it seems that supplementary issues may occur (see 'hyperref'
%- documentation p.44: "'nameref' support 'titlesec' but hyperref' does not").
%- An overall advice is to use the 'bookmark' package, which redefines some 'hyperref' commands
%- like \pdfbookmark in terms of the new command '\bookmark' and improves the bookmark management.
%- But for a unknown reason beyond our skills (certainly coming from the defined layouts − parts,
%- chapters, etc. − with Tikz), the target bookmarks are wrong placed.
%- About that, an efficient solution is to explicitely set the anchors bookmarks at the beginning
%- of a part or chapter page.
%- The working (equivalent) solutions are given by Heiko Oberdiek and Martin Scharrer:
%-   https://tex.stackexchange.com/questions/67396/[...]
%-     [...]probem-with-bookmarks-and-linking-and-page-numbering
%-   https://tex.stackexchange.com/questions/11962/how-to-determine-current-page-number
%- It introduces the use of the Heiko Oberdiek 'zref' package.
%-----

%--- New update 2019/06/04
%- It seems now that styled and colored bookmarks can now be set for all PDF viewers. Let's try!
%-----

%----- Redefining ToC levels for correct layouts of ToCs and bookmarks
%---------------------------------------------------------------------
%- From: http://tex.stackexchange.com/questions/67132/
%-   \providecommand*{\toclevel@overparagraph}{4}
%- From: http://tex.stackexchange.com/questions/244263/bookmark-issues/
%-   \@namedef{toclevel@overparagraph}{4}
%-----

%- Setting/redefining the different bookmark levels (as for ToC levels): from 'hyperref.sty'
\def\toclevel@book{-2}% \booknumberline? It seems to be the reason: cf. bookmark.sty and memoir.cls
\def\toclevel@part{-1}%
\def\toclevel@chapter{0}%
\def\toclevel@section{1}%
\def\toclevel@subsection{2}%
\def\toclevel@subsubsection{3}%
\def\toclevel@overparagraph{4}% titletoc with hyperref doesn't define \toclevel@...
\def\toclevel@paragraph{5}% To be sure (must be settled automatically by titlesec)
\def\toclevel@subparagraph{6}% To be sure (must be settled automatically by titlesec)
%- First setting: not satisfaying with several \appendixchapter and \backchapter?
\def\toclevel@appendixchapter{-5}%{0}% titletoc with hyperref doesn't define \toclevel@...
\def\toclevel@backchapter{-6}%{0}% titletoc with hyperref doesn't define \toclevel@...
%- New attempt
%\def\toclevel@appendixchapter{0}%{0}% titletoc with hyperref doesn't define \toclevel@...
%\def\toclevel@backchapter{0}%{0}% titletoc with hyperref doesn't define \toclevel@...

\bookmarksetup{%
  open,
  numbered,
  openlevel=2,% Bookmarks are opened up to sections (level=1), subsections (level=2), etc.
  depth=6,% subparagraph=6 / paragraph=5 / overparagraph=4 / subsubsection=3
  color=firstcolor,% OK for Adobe Reader but not for Evince
  %view={FitH - \calc{paperheight-\topmargin-1in}},
  addtohook={% OK for Adobe Reader but not for Evince
    \ifnum\bookmarkget{level}=-2 % book
      \bookmarksetup{bold, italic, color={black}}%
    \fi
    \ifnum\bookmarkget{level}=-1 % part
      \bookmarksetup{bold, italic, color={secondcolor}}%
    \fi
    \ifnum\bookmarkget{level}=0 % chapter
      \bookmarksetup{bold, color={firstcolor}}%
    \fi
    \ifnum\bookmarkget{level}=-5 % appendixchapter
      \bookmarksetup{bold, color={firstcolor}}%
    \fi
    \ifnum\bookmarkget{level}=-6 % backchapter
      \bookmarksetup{bold, color={firstcolor}}%
    \fi
  },
  addtohook={% https://tex.stackexchange.com/questions/156530/how-to-change-the-pdfbookmark-titles
    %- Change numbering layout of parts in bookmarks: ordinal to Roman
    \ifnum\toclevel@part=\bookmarkget{level}\relax
      %\bookmarksetup{bold,italic,color={secondcolor}}%
      \renewcommand*{\numberline}[1]{\Roman{part} \textemdash{} }%
    \fi
    %- Change numbering layout of chapters in bookmarks
    \ifnum\toclevel@chapter=\bookmarkget{level}\relax
      %\renewcommand*{\numberline}[1]{#1 \textendash{} }%
      \renewcommand*{\numberline}[1]{\arabic{chapter} \textendash{} }%
      %\renewcommand*{\numberline}[1]{\arabic{#1} \textendash{} }%
      %\renewcommand*{\numberline}[1]{Chapitre #1 \textendash{} }%
    \fi
    %- Change numbering layout of sections in bookmarks
    \ifnum\toclevel@section=\bookmarkget{level}\relax
      \renewcommand*{\numberline}[1]{\arabic{section}. }%
      %\renewcommand*{\numberline}[1]{#1 }%
    \fi
    %- Change numbering layout of subsections in bookmarks
    \ifnum\toclevel@subsection=\bookmarkget{level}\relax
      %\renewcommand*{\numberline}[1]{#1 }%
    \fi
    %- Change numbering layout of appendix chapter in bookmarks (as chapter)
    \ifnum\toclevel@appendixchapter=\bookmarkget{level}\relax
      %\bookmarksetup{rellevel=1}% Level relative to the previous one: value > 0 => child (here part)
      \bookmarksetup{level=0}% Wanted absolute level (here chapter)
      \renewcommand*{\numberline}[1]{\Alph{appendixchapter} \textendash{} }%
    \fi
    %- No numbering layout of back chapters − no star needed − in bookmarks
    \ifnum\toclevel@backchapter=\bookmarkget{level}\relax
      %\bookmarksetup{rellevel=-1}% Backmatter, so same level than parts (if no part before)
      %\bookmarksetup{rellevel=1}% Backmatter, so same level than parts (if part before)
      \bookmarksetup{level=0}% Wanted absolute level (here chapter)
      \renewcommand*{\numberline}[1]{}% No numbering at all
    \fi
  },
}
%\bookmarkdefinestyle{top}{% https://tex.stackexchange.com/questions/348044/ (H. Oberdiek answer)
%  level=0,
%  rawaction={%
%    /S/JavaScript%
%    /JS(event.target.open=!event.target.open)%
%  },
%}

%-- Detecting and applying an absolute referenced page number

%- As other packages by Heiko Oberdiek: essential and awesome!
%\RequirePackage{zref-user}% Already loaded (see above)
%\RequirePackage{zref-abspage}% Already loaded (see above)

%- Defining a new bookmark command referring to the absolute page number (Martin Scharrer)
%- https://tex.stackexchange.com/questions/11962/how-to-determine-current-page-number
\newcommand{\pagebookmark}[3][]{%
  \zlabel{#2}%
  \bookmark[page=\zref@extractdefault{#2}{abspage}{1},#1]{#3}%
}

%- Defining a new bookmark command referring to the absolute page number (Heiko Oberdiek)
%- https://tex.stackexchange.com/questions/67396/[...]
%-    [...]probem-with-bookmarks-and-linking-and-page-numbering/
\newcounter{zpage}
\renewcommand*{\thezpage}{pagelabel\the\value{zpage}}
\newcommand*{\linkpagebookmark}[2][]{%
  \stepcounter{zpage}%
  \zref@labelbyprops{\thezpage}{abspage}%
  \zref@refused{\thezpage}%
  \bookmark[{%
    page=\zref@extractdefault{\thezpage}{abspage}{1},%
    view={XYZ},%
    #1%
  }]{#2}%
}

%----- Setting correct bookmarks
%-------------------------------
%- See also:
%- From Heiko Oberdiek himself :
%-   https://tex.stackexchange.com/questions/67396/[...]
%-     [...]probem-with-bookmarks-and-linking-and-page-numbering
%-   https://tex.stackexchange.com/questions/81687/hyperref-generated-bookmarks-pointing-too-low
%-   https://tex.stackexchange.com/questions/116982/[...]
%-     situation-dependent-bookmark-level-of-subsubsection
%-   https://tex.stackexchange.com/questions/156530/how-to-change-the-pdfbookmark-titles-hyperref
%- From Christian Hupfer
%-   https://tex.stackexchange.com/questions/300099 (get-sections-with-no-numbers)
%- See also:
%-   https://tex.stackexchange.com/questions/58810/[...]
%-     [...]automatic-target-here-with-bookmark-as-with-pdfbookmark
%-   http://tex.stackexchange.com/questions/274212/correct-hierarchy-levels-of-pdf-bookmarks
%-   Warning: http://tex.stackexchange.com/questions/60209/how-to-add-an-extra-level-of-sections
%-   https://tex.stackexchange.com/questions/398143/creating-bookmarks-in-pdf-files
%-   http://tex.stackexchange.com/questions/318015/split-table-of-contents-on-part-page
%-   https://tex.stackexchange.com/questions/113132/[...]
%-     [...]change-format-of-hyperref-generated-pdf-bookmarks
%-   https://tex.stackexchange.com/questions/97024/[...]
%-     [...]how-to-add-the-pdf-bookmark-of-toc-without-its-name-contents-in-toc
%-----

%- Redefining/adding bookmarks taking into account an absolute page reference for parts, chapters...
%- https://tex.stackexchange.com/questions/113132/change-format-of-hyperref-generated-pdf-bookmarks
\def\Hy@writebookmark#1#2#3#4#5{% From 'bookmark.sty'
  \ifnum#4>\BKM@depth\relax
  \else
    \def\BKM@type{#5}%
    \ifx\BKM@type\Hy@bookmarkstype
      \begingroup
        \ifBKM@numbered
          \let\numberline\Hy@numberline
          \let\booknumberline\Hy@numberline
          \let\partnumberline\Hy@numberline
          \let\chapternumberline\Hy@numberline
        \else
          \let\numberline\@gobble
          \let\booknumberline\@gobble
          \let\partnumberline\@gobble
          \let\chapternumberline\@gobble
        \fi
        \ifnum#4<1% Part, chapter, appendixchapter, backchapter bookmarks
          \linkpagebookmark[level=#4]{#2}% Added
        \else
           \bookmark[level=#4,dest={#3}]{#2}% Original
         \fi
      \endgroup
    \fi
  \fi
}

%- Adding bookmarks in the PDF document, but not in the (printed) Table of Contents itself
\ifdoc@article\else
  %- Bookmark for the cover "title page"
  \pretocmd{\maketitle}{%
    %\pdfbookmark[-2]{\@doctitle}{titlebookmark}% Old fashion and wrong placement
    %\bookmark[level=-2,page=1]{\@doctitle}% No need of M. Scharrer's '\pageboomark' here
    \label{coverbookmark}
    \pagebookmark[level=-2]{coverbookmark}{\@doctitle}%
  }{}{}
  %- Bookmark for the table of contents
  \pretocmd{\tableofcontents}{%
    \if@openright\cleardoublepage\else\clearpage\fi%
    %\pdfbookmark[0]{\contentsname}{tdmbookmark}% Old fashion and wrong placement
    \label{tdmbookmark}
    \pagebookmark[level=0]{tdmbookmark}{\contentsname}%
  }{}{}
  %- Bookmark for the list of figures
  \pretocmd{\listoffigures}{%
    \if@openright\cleardoublepage\else\clearpage\fi%
    %\pdfbookmark[0]{\listfigurename}{lofbookmark}% Old fashion and wrong placement
    \label{lofbookmark}
    \pagebookmark[level=0]{lofbookmark}{\listfigurename}%
  }{}{}
  %- Bookmark the list of tables
  \pretocmd{\listoftables}{%
    \if@openright\cleardoublepage\else\clearpage\fi%
    %\pdfbookmark[0]{\listtablename}{lotbookmark}% Old fashion and wrong placement
    \label{lotbookmark}
    \pagebookmark[level=0]{lotbookmark}{\listtablename}%
  }{}{}
  %- Bookmark for the list of exercises
  \pretocmd{\listofexercises}{%
    \if@openright\cleardoublepage\else\clearpage\fi%
    %\pdfbookmark[0]{\listexercisename}{loebookmark}% Old fashion and wrong placement
    \label{loebookmark}
    \pagebookmark[level=0]{loebookmark}{\listexercisename}%
   }{}{}%
  %- Bookmark for the list of quizzes
  \pretocmd{\listofquizzes}{%
    \if@openright\cleardoublepage\else\clearpage\fi%
    %\pdfbookmark[0]{\listquizname}{loqbookmark}% Old fashion and wrong placement
    \label{loqbookmark}
    \pagebookmark[level=0]{loqbookmark}{\listquizname}%
   }{}{}%
  %- Bookmark for the list of videos
  \pretocmd{\listofvideos}{%
    \if@openright\cleardoublepage\else\clearpage\fi%
    %\pdfbookmark[0]{\listvideoname}{lovbookmark}% Old fashion and wrong placement
    \label{lovbookmark}
    \pagebookmark[level=0]{lovbookmark}{\listvideoname}%
  }{}{}%
  %- Bookmark for the list of codes
  \pretocmd{\listofcodes}{%
    \if@openright\cleardoublepage\else\clearpage\fi%
    %\pdfbookmark[0]{\listcodename}{locbookmark}% Old fashion and wrong placement
    \label{locbookmark}
    \pagebookmark[level=0]{locbookmark}{\listcodename}%
  }{}{}%
  %- Bookmark for the list of listings
  \pretocmd{\listoflistings}{%
    \if@openright\cleardoublepage\else\clearpage\fi%
    %\pdfbookmark[0]{\listlistingname}{lolbookmark}% Old fashion and wrong placement
    \label{lolbookmark}
    \pagebookmark[level=0]{lolbookmark}{\listlistingname}%
  }{}{}%
  %- Bookmark for the list of documents
  \pretocmd{\listofdocuments}{%
    \if@openright\cleardoublepage\else\clearpage\fi%
    %\pdfbookmark[0]{\listdocumentname}{lodbookmark}% Old fashion and wrong placement
    \label{lodbookmark}
    \pagebookmark[level=0]{lodbookmark}{\listdocumentname}%
  }{}{}%
\fi


%---------------------------------------------------------------------------------------------------
%---- Exercise/solution environments (with the 'xsim` package)
%---------------------------------------------------------------------------------------------------

%-- Exercise/solution/grading environments
%-----------------------------------------

%-- Far too complex for the time being (LaTeX3 syntax!)

%- Maybe too slow to compile with external files access, see:
%-  https://tex.stackexchange.com/questions/435390/xsim-slow-with-external-files

%\RequirePackage{xsim}% Really powerful, but not straightforward to fill our − customized − needs

%-- Exercise/solution/grading environments

%- Other exercise/solution/handling points packages which seems easier to manage (to be tested)
%\RequirePackage{exercisebank}%
%\RequirePackage{exframe}%
%\RequirePackage{exframe}%
%\RequirePackage{exframe}%
%\RequirePackage{exframe}%


%---------------------------------------------------------------------------------------------------
%---- Exercise/solution environments (with a TikZ first layer and `tcolorbox` nested contents)
%---------------------------------------------------------------------------------------------------

%----- Note about framed/coloured (un)breakable boxes over pages
%---------------------------------------------------------------
%- A review about the possible solutions is − one more time − given by Gonzalo Medina:
%-   https://tex.stackexchange.com/questions/59340/how-to-highlight-an-entire-paragraph/
%- Sum up:
%-   * mdframed, breakable (only for the first level of nested boxes), no float
%-   * tcolorbox, breakable (only for the first level of nested boxes), no float
%-   * adjustbox, no beakable, no float
%-   * fancypar, no beakable, no float
%-   * framed, breakable, no float
%- Other are refering to todonotes. See also:
%-   https://tex.stackexchange.com/questions/59175/boxes-overflow-column
%-   https://tex.stackexchange.com/questions/180343/[...]
%-       [...]how-to-make-adjustbox-work-correctly-with-wrapfigure
%-----
%- Tikzmark and `zref` advanced referencing system solution
%----------------------------------------------------------
%- Because no package allows nested breakable environments, the solely solution is to use the
%- "TikZ/tikzmark/zref approach". We need it in order to keep the same nested and boxed environment
%- definitions as for the main text paragraphs and, futhermore, to have nested breakable boxes for
%- embendded contents like code listings or figures, tables, and whatever other floats.
%- The main advantage of such an approach is also to get rid of complicated machinery to manage the
%- counters of the different contents within the exercises and solutions if designed with "tcboxes".
%- The same way of doing is applied for `exercise` and `quiz` environments. See:
%-   https://tex.stackexchange.com/questions/21521/test-if-a-paragraph-has-a-page-break-in-it
%- Needed packages (already loaded): zref-abspage, zref-user, tikz, atbegshi, tikz calc
%- For combining tcolorbox and tikzmark, one can see:
%-   https://tex.stackexchange.com/questions/512017/z-index-tcolorbox-tikz-and-overlays
%-   https://tex.stackexchange.com/questions/512016/[...]
%-       [...]tcolorbox-tikzmark-and-distances-to-the-borders-of-a-tcolorbox
%-----

%-- FOR HISTORY SEE THE ARCHIVES

%-- First attempts only putting a bar into the margin (without TikZ)
%-------------------------------------------------------------------

%-- Defining a "bar" environment (the `changebar` package defines a "changebar" environment)

%\PassOptionsToPackage{leftbars,xcolor}{changebar}% Does not work with LuaLaTeX? (driver issue)
%\RequirePackage{changebar}% The nesting of multiple changebars is allowed%%

%\setlength{\changebarwidth}{2pt}
%\setlength{\changebarsep}{0.25\marginparsep}
%\cbcolor{firstcolor}

%-- Defining a "bar" environment with the `framed` package (see below its use for ToC)

%\RequirePackage{framed}% Helper package → Does not work: no float is allowed


%-- Defining a TikZ framed environment (as a background layer with the `zref` referencing system)
%------------------------------------------------------------------------------------------------




%---------------------------------------------------------------------------------------------------
%---- Exercise/solution environments (with a TikZ first layer and `tcolorbox` nested contents)
%---------------------------------------------------------------------------------------------------

%- Setting a `exercise` environment with TikZ/tikzmark (in order to have inside breakable boxes)
%- The same approch is adopted for the "quiz" environment (see below).
%- See: https://tex.stackexchange.com/questions/21521/test-if-a-paragraph-has-a-page-break-in-it
%- Needed packages (already loaded): zref-abspage, zref-user, tikz, atbegshi, tikz calc


%-- Applying a frame around contents, titling and numbering the exercise/quiz environments
%-----------------------------------------------------------------------------------------

%\newcounter{exercise}% Reset within appendixchapter explicitely at \appendix command (see below)

%\newcommand{\exercisetitlefont}[1]{%
%  %\scshape\fontsize{10pt}{12pt}\selectfont\titlingspacedfont\strut#1%
%  \scshape\fontsize{10pt}{0pt}\selectfont\titlingspacedfont\strut#1%
%}


%-- Counting points system for the exercises/quizzes and setting the environments layouts
%----------------------------------------------------------------------------------------

%-- Points counting with the `assignpoints` package

%\ifdoc@assignpoints
%  \ifdoc@askreply
%    \RequirePackage[french]{texjazz-assignpoints}% Assigning/calculating points within exercises/quizzes
%    \RequirePackage[french]{texjazz-askreply}% To be loaded *after* `assignpoints` and `hyperref' pkgs
%    \typeout{*** Both TeXjazz assignpoints and askreply packages are loaded ***}
%  \else
%    \RequirePackage[french]{texjazz-assignpoints}% Assigning/calculating points within exercises/quizzes
%    \typeout{*** Only the TeXjazz assignpoints package is loaded ***}
%  \fi
%\else
%  \typeout{*** None of TeXjazz assignpoints and askreply packages are loaded ***}
%\fi

%\ifbool{doc@assignpoints}{%
%  \ifbool{doc@askreply}{%
  \ifdoc@english
    \RequirePackage{texjazz-assignpoints}% Assigning/calculating points within exercises/quizzes
    \RequirePackage{texjazz-askreply}% To be loaded *after* `assignpoints` and `hyperref' pkgs
    \typeout{*** Both TeXjazz assignpoints and askreply packages are loaded ***}
  \else
    \RequirePackage[french]{texjazz-assignpoints}% Assigning/calculating points within exercises/quizzes
    \RequirePackage[french]{texjazz-askreply}% To be loaded *after* `assignpoints` and `hyperref' pkgs
    \typeout{*** Both TeXjazz assignpoints and askreply packages are loaded ***}
  \fi
%  }{%
%    \RequirePackage[french]{texjazz-assignpoints}% Assigning/calculating points within exercises/quizzes
%    \typeout{*** Only the TeXjazz assignpoints package is loaded ***}
%  }%
%}{%
%  \typeout{*** None of TeXjazz assignpoints and askreply packages are loaded ***}
%}


%\RequirePackage[french]{texjazz-askreply-light}% To be loaded *after* `assignpoints` and `hyperref' pkgs

%-- Default style with possible points counting (commands: \points, \itempoints)

%- See:
%- https://tex.stackexchange.com/questions/315270/strippt-textwidth-gives-undefined-control-sequence
%- https://tex.stackexchange.com/questions/198954/scaling-a-glue-in-tex
%- https://tex.stackexchange.com/questions/15001/getting-length-as-number
%- https://tex.stackexchange.com/questions/171620/how-to-get-float-numbers-as-parameter-of-newcommand



%---------------------------------------------------------------------------------------------------

% https://tex.stackexchange.com/questions/225069/exporting-a-timed-presentation-automatic-slideshow-to-image-sequence-video-w



% Animation :

% https://tex.stackexchange.com/questions/235139/using-the-animate-package-without-adobe
% https://tex.stackexchange.com/questions/455709/animate-package-on-linux-which-pdf-reader
% https://tex.stackexchange.com/questions/429/animation-in-pdf-presentations-without-adobe-reader/



%https://tex.stackexchange.com/questions/152358/animations-in-latex
%https://tex.stackexchange.com/questions/1574/embedding-videos-and-animations
%https://tex.stackexchange.com/questions/442851/is-there-a-way-to-display-both-videos-and-javascript-animations-on-a-beamer-gene/446179#446179
%https://tex.stackexchange.com/questions/345431/how-to-include-multimedia-files-in-beamer
%https://tex.stackexchange.com/questions/69991/thumbnails-of-other-frames-in-beamer
%https://tex.stackexchange.com/questions/286280/textfield-and-animateinline/
%https://tex.stackexchange.com/questions/116461/print-answer-key-to-multiple-choice-questions
%https://tex.stackexchange.com/questions/12592/creating-multiple-choice-questions-without-using-exam-class

%Annotation:
%https://tex.stackexchange.com/questions/208473/is-there-a-better-package-to-add-comment-annotations-into-your-latex-pdf-than
%https://tex.stackexchange.com/questions/6306/how-to-annotate-pdf-files-generated-by-pdflatex
%https://dl.winehq.org/wine-builds/ubuntu/
%https://tex.stackexchange.com/questions/155518/tooltip-that-works-with-all-pdf-readers


%Wine+AR
%https://askubuntu.com/questions/1047686/install-the-latest-version-of-the-adobe-reader-in-ubuntu-or-wine
%https://linuxconfig.org/how-to-install-latest-adobe-acrobat-reader-dc-on-ubuntu-18-04-bionic-beaver-linux-with-wine
%https://doc.ubuntu-fr.org/wine
%https://wiki.winehq.org/Mono
%

%Attach files
%https://tex.stackexchange.com/questions/434186/how-to-embed-plain-text-data-into-a-pdf-with-latex
%
%

%Poster/Tikz
%https://tex.stackexchange.com/questions/451457/create-page-layout-with-beautiful-boxes-tcolorbox/451560#451560
%https://tex.stackexchange.com/questions/281375/inspired-beautiful-box-from-indesign/340938#340938

%https://tex.stackexchange.com/questions/444917/the-tikz-game-package-a-tex-sx-project/444956#444956

% Package forloop








%- Pour mémoire, accessoire (mobile sympa avec la date) :
%- https://tex.stackexchange.com/questions/195923/tikz-how-to-create-and-reuse-a-picture




%---------------------------------------------------------------------------------------------------
%---- Tooltip with mouse hover / Infobulles avec survol de la souris
%---------------------------------------------------------------------------------------------------

%\RequirePackage{texjazz-tooltip}
%\RequirePackage{texjazz-tooltip2}
%\RequirePackage{texjazz-zoom}% DOES NOT WORK → \pdfdest issue

%----- Tooltips issue
%- Traditional tooltips may be display according to PDF specifications and JavaScript code.
%- Unfortunately, Open sources PDF viewer like Evince do not support JavaScript. Thus, the
%- working solution is to introduce tooltips by mean of OCGs (see the quizzes codes above).
%- To have an overview on this topic, one can read the following:
%-   https://tex.stackexchange.com/questions/119988/[...]
%-     [...]pdftooltip-from-pdfcomment-package-using-latex-code-in-tooltip
%-   https://tex.stackexchange.com/questions/428074/[...]
%-     [...]is-it-possible-to-have-hyperlinks-with-a-menu-to-select-from-a-choice-of-links
%- Tooltips reading that works with Evince:
%-   https://tex.stackexchange.com/questions/155518/tooltip-that-works-with-all-pdf-readers
%-   https://tex.stackexchange.com/questions/200143/mouseover-with-hyperref-internal-links
%-   https://tex.stackexchange.com/questions/83783/explanatory-bubbles-in-beamer
%-   https://tex.stackexchange.com/questions/84681/interactive-pdf-latex-and-article-of-the-future
%-   https://tex.stackexchange.com/questions/111859/[...]
%-     [...]interactive-pdf-latex-and-article-of-the-future-with-opentype-truetype-fonts
%-   https://tex.stackexchange.com/questions/107247/move-around-box-in-pdf-display
%-----

\newcommand{\jazztooltiptikzmark}[1]{%
  %\tikz[overlay, baseline, remember picture] \coordinate (#1);% Original
  \tikz[overlay, baseline, remember picture] \coordinate[yshift=0.65\baselineskip] (#1);%
}

\newlength{\tooltipbasewidth}
\newlength{\tooltiptextwidth}
\newlength{\tooltiptextmaxwidth}
\newsavebox{\tooltipbox}

%- If first/left/even page or last/right/odd page tooltip
\setlength{\tooltiptextmaxwidth}{\marginparwidth+\marginparsep}

\newcommand{\tooltiptextbox}[1]{% https://tex.stackexchange.com/questions/284314
  % Syntax − #1 = tooltip text (texte de l'infobulle)
  \savebox{\tooltipbox}{#1}% get tooltip width
  \setlength{\tooltiptextwidth}{\widthof{\footnotesize #1}}%
  \ifdim\wd\tooltipbox<\tooltiptextmaxwidth\relax
    \makebox[\tooltiptextwidth]{\usebox{\tooltipbox}}% Short tooltip text
  \else
    \begin{varwidth}{\tooltiptextmaxwidth}% YES, THAT'S IT!
      \Centering #1%
    \end{varwidth}
  \fi%
}

\newcounter{tooltip}
\definecolor{tooltipcolor}{rgb}{0,0,1}

\tikzset{% https://tex.stackexchange.com/questions/83783
  tooltip odd page style/.style={%
    inner xsep=4pt, inner ysep=4pt, %outer sep=0pt,
    rectangle callout, anchor=pointer,
    callout relative pointer={(225:0.75cm)},
    rounded corners=1.5pt,
    general shadow={fill=gray, opacity=0.5, shadow xshift=1.5pt, shadow yshift=-1.5pt}, %drop shadow,
    draw=gray, fill=yellow!20,% yellow!50!white,% firstcolor,
    opacity=1, text opacity=1,
    align=center, %text width=3cm,% Ça fout un boxon monstre ! Utiliser minimum width=\mylength
    font=\footnotesize,
  },
  tooltip even page style/.style={%
    inner xsep=4pt, inner ysep=4pt, %outer sep=0pt,
    rectangle callout, anchor=pointer,
    callout relative pointer={(315:0.75cm)},
    rounded corners=1.5pt,
    general shadow={fill=gray, opacity=0.5, shadow xshift=1.5pt, shadow yshift=-1.5pt}, %drop shadow,
    draw=gray, fill=yellow!20,% yellow!50!white,% firstcolor,
    opacity=1, text opacity=1,
    align=center, %text width=3cm,% Ça fout un boxon monstre ! Utiliser minimum width=\mylength
    font=\footnotesize,
  },
}

\newcommand{\jazztooltip}[2]{% https://tex.stackexchange.com/questions/84681 (Paul Gaborit)
  \stepcounter{tooltip}%
  \hypersetup{linkcolor=thirdcolor!75!black}%firstcolor
  % Only "onmouseup" trigger option works with Evince (one has to click to display the tooltip)
  \switchocg[onmouseup]{tooltip@\thetooltip}{#1}%
  \strictpagechecktrue%
  \checkoddpage%
  \ifoddpage%
    \jazztooltiptikzmark{tooltip@\thetooltip}%
    \begin{tikzpicture}[overlay, remember picture]%
      \begin{scope}[ocg={ref=tooltip@\thetooltip, status=invisible, name={#2}}]
        \node[tooltip odd page style]
          at (tooltip@\thetooltip) {\tooltiptextbox{#2}};
      \end{scope}%
    \end{tikzpicture}%
   \else%
     \setlength{\tooltipbasewidth}{\widthof{#1}}%
    \jazztooltiptikzmark{tooltip@\thetooltip}%
    \begin{tikzpicture}[overlay, remember picture]%
      \begin{scope}[ocg={ref=tooltip@\thetooltip, status=invisible, name={#2}}]
        \node[tooltip even page style, xshift=-\tooltipbasewidth]
          at (tooltip@\thetooltip) {\tooltiptextbox{#2}};
      \end{scope}%
    \end{tikzpicture}%
  \fi%
}


%---------------------------------------------------------------------------------------------------
%---- Multimedia tools (sounds and videos)
%---------------------------------------------------------------------------------------------------

%----- Note
%- To introduce multimedia stuff into a PDF document three main packages are availiable:
%-  − 'multimedia' package (coming from the 'beamer' package, but may be used independently),
%-  − 'movie15' package by Alexander Grahn (only PDFTeX not LuaTeX),
%-  − 'media9' package by Alexander Grahn too.
%- See (in French), the differences between these three methods:
%-   https://linuxfr.org/users/gouttegd/journaux/integrer-des-videos-dans-des-fichiers-pdf
%-
%- Specifically for presentation (and for the record), one can have a look at the
%- 'pdfpc/pdf-presenter-console' software (Gtk+ interface) and the 'pdfpc-movie' package.
%- One can also have a look to 'impressive' software: http://impressive.sourceforge.net/
%- As all of these softwares, really impressive!
%-
%- Effective solution with Linux, see:
%-   https://tex.stackexchange.com/questions/345431/how-to-include-multimedia-files-in-beamer
%- For the moment being, the main issue under Linux is the viewer.
%- 1. To be able to insert multimedia stuff with the Evince/Atril viewer (plopper library), one
%-    must use the 'movie15' package. Despite the author warning (A. Grahn), this is the only
%-    working solution (Acrobat Reader 9.1.4 for Linux gives awful rendering, in particular
%-    with x64 computers). Because it does not work with the LuaTeX engine, it is not a solution.
%- 2. As far as the 'media9' package is concerned, the viewer must still be Acrobat Reader. At this
%     time, it can be installed and ran via wine:
%-      https://tex.stackexchange.com/questions/442851/[...]
%-        [...]is-there-a-way-to-display-both-videos-and-javascript-animations-on-a-beamer-gene
%- 3. Therefore, the only working solution is to use the 'multimedia' package AND THE OKULAR viewer,
%-    EVINCE/ATRIL DO NOT WORK (may be someone could implement the Okular code in Evince/Atril?)
%-----

%-- Inserting/embedding external multimedia elements

%- Beamer 'multimedia.sty' WELL... OK with LuaLaTeX, but ONLY WORKS with Okular/AR (OCG OK 20.04)
\RequirePackage{multimedia}%
%\RequirePackage{texjazz-multimedia}% Just change \movie to \playmovie and \sound to \playsound

%- External video launching when clicking an icon (from left or right margin): for Evince
\DeclareDocumentCommand{\launchvideo}{m}{% #1 video name
  \strictpagechecktrue%
  \checkoddpage%
  \ifoddpage%
    \rlap{\href{#1}{\hspace*{4mm}\LARGE\faTv}}%
  \else%
    \llap{\href{#1}{\LARGE\faTv\hspace*{\marginparwidth}\hspace*{4mm}}}%
  \fi%
}%

%\RequirePackage{movie15}% Does not work with LuaTeX

%- Up-to-date package but only for Acrobat Reader ≥ 9  (9.4.1 for Linux: NOT STABLE!)
%\RequirePackage{media9}

%- http://abarry.org/the-complete-guide-to-embedded-videos-in-beamer-under-linux/#more-61

%- For presentation, see:
%-   http://abarry.org/the-complete-guide-to-embedded-videos-in-beamer-under-linux/#more-61
%- https://linuxfr.org/users/gouttegd/journaux/integrer-des-videos-dans-des-fichiers-pdf

%- FFMPEG
%- https://doc.ubuntu-fr.org/ffmpeg
%-  https://stackoverflow.com/questions/8504923/[...]
%-   [...]how-to-convert-mp4-video-file-into-flv-format-using-ffmpeg
%- https://blog.superuser.com/2012/02/24/ffmpeg-the-ultimate-video-and-audio-manipulation-tool/
%- Convertion to flv: ffmpeg -i input.mp4 -c:v libx264 -crf 19 output.flv

%- For independency with the 'beamer' package, we define a fork as 'texjazz-multimedia.sty'
%- ONLY USABLE WITH OKULAR!!!
%\RequirePackage{multimedia}% Must be put AFTER 'graphicx' and 'hyperref' loading
%\RequirePackage{texjazz-multimedia}% Must be put AFTER 'graphicx' and 'hyperref' loading

%-- Optional Content Group: switch on/off the display of PDF layers: https://gitlab.com/agrahn/ocgx2

%\RequirePackage[tikz]{ocgx2}
%\RequirePackage[ocgcolorlinks,tikz]{ocgx2}% Change hyperref link color: to deep in deep!

%\RequirePackage{multido}% Test

%- MUST BE READ: https://tex.stackexchange.com/questions/477878/[...]
%-   [...]ocgx-and-hyperref-visibility-and-clickability-of-overlapping-links

\NewDocumentCommand{\evinceviewer}{ m m }{%
  \begin{ocg}{evince}{evinceocgref}{on}
    \href{run:#1}{\includegraphics[scale=0.75]{#2}}
    %\includegraphics[scale=0.75]{#2}
  \end{ocg}
%  \begin{tikzpicture}
%    \node[button on=evinceocgref](evincebutton){};
%    \node[right=0 of evincebutton]{Switch to Evince};
%  \end{tikzpicture}
  %\switchocg{evinceocgref}{\href{run:#1}{Launch with Evince}}
  \switchocg{evinceocgref}{Launch with Evince}
}

\NewDocumentCommand{\pdfviewerocg}{ m }{%
  \begin{ocg}{evince}{evinceocgref}{on}
    \href{run:#1}{\includegraphics[scale=0.75]{./Images/Pictograms/film-strip-dark-electric-blue.png}}
  \end{ocg}
  \begin{ocg}{acrobatreader}{acrobatreaderocgref}{off}
    \href{run:#1}{\includegraphics[scale=0.75]{./Images/Pictograms/film-strip-red-brown.png}}
    %\includegraphics[scale=0.75]{#2}
  \end{ocg}\newline
  \switchocg{acrobatreaderocgref, evinceocgref}{Launch with Evince}\qquad
  \switchocg{evinceocgref, acrobatreaderocgref}{Launch with Acrobat Reader}
%  \showocg{acrobatreaderocgref}{Launch with Acrobat Reader}
}

\NewDocumentCommand{\pdfviewer}{ m m }{%
  \begin{tikzpicture}
    \begin{scope}[xshift=0.0cm,ocg={name=evince, ref=evinceocgref, status=visible}]
      \node[draw, line width=1pt] (pdfevince) {%
        \href{#1}%
          {\includegraphics[scale=0.75]{./Images/Pictograms/film-strip-dark-electric-blue.png}}%
        %\includegraphics[scale=0.75]{./Images/Pictograms/film-strip-dark-electric-blue.png}%
      };
    \end{scope}
    \begin{scope}[xshift=0.0cm,ocg={name=acrobatreader, ref=acrobatreaderocgref, status=invisible}]
      \node[draw, line width=1pt] (pdfacrobatreader) {%
        \href{#2}%
          {\includegraphics[scale=0.75]{./Images/Pictograms/film-strip-red-brown.png}}%
        %\includegraphics[scale=0.75]{./Images/Pictograms/film-strip-red-brown.png}%
        };
    \end{scope}
  \end{tikzpicture}
  \begin{tikzpicture}
    \node[
      draw,circle,drop shadow,
      line width=1pt,
      fill=black!50,
      switch ocg with mark on={evinceocgref}{evinceocgref, acrobatreaderocgref},
      ] (buttonevince) {};
    \node[right=0 of buttonevince]{Evince};
    \node[
      below=3pt of buttonevince,
      draw,circle,drop shadow,
      line width=1pt,
      fill=black!50,
      switch ocg with mark off={acrobatreaderocgref}{acrobatreaderocgref, evinceocgref},
      ] (buttonacrobatreader) {};
    \node[right=0 of buttonacrobatreader]{Acrobat Reader};
  \end{tikzpicture}
}


%---------------------------------------------------------------------------------------------------
%---- Setting the document tree: absolute and relative path, input/output, etc.
%---------------------------------------------------------------------------------------------------

%-- Input files (all solutions below are based on the LaTeX commands \input@path + \filename@parse)
%-- Traditional way to manage inputs in (La)TeX, but seemingly slowed the compiling process
%-- for large documents (pp. > 500), cf. l2tabu.pdf, l2tabufr.pdf (clearly not the case here)

%-- Importing specific files: good for class, style and (La)TeX files
%\RequirePackage{import}% only for single file, if needed
%- Usage: `*' = avoid TEXINPUTS searching (avoids conflicts with the same file name in TeX tree)
%- \import{<absolute path ended with a `/'>}{<file>}
%- \subimport{<relative path extension ended with `/'>}{<file>}
%\subimport*{}{}

%- Extends accepted file names: blank spaces, multidots, but NOT underscores
%\RequirePackage{grffile}% mainly for graphic files

%-- Extensions of LaTeX \input@path command, Heiko Oberdiek proposal:
%-- cf. http://tex.stackexchange.com/questions/79058/can-a-default-path-be-set-globally-for...
%\providecommand*{\input@path}{}% for the case that \input@path is undefined (default in LaTeX)
%- Generic input path for the document hierarchy
%\def\input@path{{./Codes/}}%{./Codes/Algorithms/}{./Codes/Java/}}% generic input

%\def\input@path{% add here generic input paths
%  {./Images/}{./Codes/}{./Videos}{./Sounds/}{./Documents}
%  {./Images/}{./Images/Chapter01/}{./Images/Chapter02/}{./Images/Chapter03/}% for <filname>.eps_tex
%  {./Images/Chapter04/}{./Images/Chapter05/}{./Images/Chapter06/}%             and <filname>.pdf_tex
%  {./Images/Chapter07/}{./Images/Chapter08/}{./Images/Chapter09/}% redundant with graphic paths?
%  {./Codes/}{./Codes/Chapter01/}{./Codes/Chapter02/}{./Codes/Chapter03/}%
%  {./Codes/Chapter04/}{./Codes/Chapter05/}{./Codes/Chapter06/}%
%  {./Codes/Chapter07/}{./Codes/Chapter08/}{./Codes/Chapter09/}%
%  {./Videos/}{./Videos/Chapter01/}{./Videos/Chapter02/}{./Videos/Chapter03/}%
%  {./Videos/Chapter04/}{./Videos/Chapter05/}{./Videos/Chapter06/}%
%  {./Videos/Chapter07/}{./Videos/Chapter08/}{./Videos/Chapter09/}%
%  {./Sounds/}{./Sounds/Chapter01/}{./Sounds/Chapter02/}{./Sounds/Chapter03/}%
%  {./Sounds/Chapter04/}{./Sounds/Chapter05/}{./Sounds/Chapter06/}%
%  {./Sounds/Chapter07/}{./Sounds/Chapter08/}{./Sounds/Chapter09/}%
%  {./Documents/}{./Documents/Chapter01/}{./Documents/Chapter02/}{./Documents/Chapter03/}%
%  {./Documents/Chapter04/}{./Documents/Chapter05/}{./Documents/Chapter06/}%
%  {./Documents/Chapter07/}{./Documents/Chapter08/}{./Documents/Chapter09/}%
%}
%- Append directories to the path
%\g@addto@macro\input@path{{./Codes/Algorithms/}{./Codes/Java/}}
%- Prepend directories to the path
%\edef\input@path{{./Codes/Algorithms/}{./Codes/Java/}\input@path}

%-- Graphics input files path and shortcut (`graphics' package)
\AtBeginDocument{%
  \graphicspath{% add here every search subdir
    {./Images/}{./Images/Logotype/}{./Images/Pictograms/}%
    {./Images/Chapter01/}{./Images/Chapter02/}{./Images/Chapter03/}%
    {./Images/Chapter04/}{./Images/Chapter05/}{./Images/Chapter06/}%
    {./Images/Chapter07/}{./Images/Chapter08/}{./Images/Chapter09/}%
    {./Images/AppendixA/}{./Images/AppendixB/}{./Images/AppendixC/}%
    {./Images/AppendixD/}{./Images/AppendixE/}{./Images/AppendixF/}%
  }%
}

%-- Inputs for listings package TODO
%- Adaptation/reprise du paquet `listings'

\ifx\Jazz@inputpath\@undefined
  \let\Jazz@inputpath\input@path
\fi

\newcommand\CurrentPathName{./}

%\let\Jazzlst@path\lst@inputpath
%\newcommand\Jazz@newpath{\CurrentPathName\Jazzlst@path}
%\renewcommand\lst@inputpath\Jazz@newpath

%\renewcommand\lst@inputlisting[2][]{inactive for the time being (Buggy!) TODO
\newcommand\Jazzlst@inputlisting[2][]{
\typeout{^^J This is TeXJazz message: \lst@inputpath#2, Where [\CurrentPathName]^^J}%
    \endgroup
    \def\lst@set{#1}%
    \IfFileExists{\lst@inputpath#2}%
        {\expandafter\lst@InputListing{\lst@inputpath#2}}%
        %{\expandafter\lst@InputListing{\Jazzlst@path#2}}%
        {\filename@parse{\lst@inputpath#2}%
         \edef\reserved@a{\noexpand\lst@MissingFileError
             {\filename@area\filename@base}%
             {\ifx\filename@ext\relax tex\else\filename@ext\fi}}% Gérer les extensions ? TODO
         \reserved@a}%
    \lst@doendpe \@newlistfalse \ignorespaces}


%---------------------------------------------------------------------------------------------------
%---- Animations
%---------------------------------------------------------------------------------------------------

%--- Note about animations
%-------------------------
%- Animations may be built with TikZ library and/or the `animate' package (Alexander Grann).
%- They can be exported to PDF or SVG formats. For SVG format see the `media4svg' package (also from 
%- Alexander Grann). For PDF, we use the `animate' package, but the PDF viewer must support
%- JavaScript. Evince does not, but since 20.04 the are very good news! Okular viewer supports
%- JavaScript and animations, but also OCGs! So, under Linux, one can use Okular to read PDF with
%- quizzes (i.e. OCGs, that was not possible before) and animations. One can also play movies and
%- sounds with the help of `multimedia' package from `beamer' package, but with ugly results (this
%- latter feature must be dig more in deep).

%- See:
%-   https://tex.stackexchange.com/questions/235139/using-the-animate-package-without-adobe
%-   https://tex.stackexchange.com/questions/536376/
%-   https://tex.stackexchange.com/questions/429/animation-in-pdf-presentations-without-adobe-reader
%-   https://tex.stackexchange.com/questions/136666/exporting-animation-created-with-animate-package

\RequirePackage{animate}% Take care that the description field use "&" 
%- Edit and change the ampersand to something else, see below and `\jazzfilelist'
%- It's important not to get an error when one wants to list used packages in a longtable
%\ProvidesPackage{animate}[\@anim@version\space PDF and SVG animations from files & inline graphics]
%\ProvidesPackage{animate}[\@anim@version\space PDF and SVG animations from files and inline graphics]



%---------------------------------------------------------------------------------------------------
%---- Miscellaneous (add-ons packages, shortcuts and personal typesetting commands)
%---------------------------------------------------------------------------------------------------

%-- Searchable hidden text or abbreviations expansion (TODO: test it)
%-- https://tex.stackexchange.com/questions/427585/hiding-searchable-content-in-a-pdf

%\RequirePackage{accsupp}% Utilities for replacement texts or expansions of abbreviations

%-- New center environments (without or with control of extra spaces above and below)
\newenvironment{nscenter}
 {\parskip=0pt\par\nopagebreak\centering}
 {\par\ignorespacesafterend}
\newenvironment{incenter}
 {\setlength{\topsep}{2pt}\trivlist\item\relax\centering}
 {\endtrivlist}

%-- Poursuivre la numération des listes (voir TeX.SE ci-dessous enumcount introuvable ?)
\newcounter{enumcount}% pour continuer la numérotation des listes
% je l'ai défini à l'arache dans nfe108_book (à peaufiner correctement) TODO
%\newenvironment{enumcont}
%  {\renewcommand{\usecounter}[1]
%     {\@nmbrlisttrue\def\@listctr{##1}}
%   \enumerate}
%  {\endlist}

%-- Typesetting shortcuts
\newcommand{\tgtextcolor}[1]{\textcolor{\@layoutcolor}{#1}}% application de la couleur du document
\newcommand*{\tgbullet}{\tgtextcolor{\faCaretRight}}
\newcommand*{\tgforward}{\tgtextcolor{\faCaretRight\faCaretRight}}
\newcommand{\tgemph}[1]{\textsl{\uline{#1}}}

%-- Mathematical shortcuts
%- Very old shortcut (~1994-1995), use \dfrac{}{} from AMS
\newcommand{\fractext}[2]{\displaystyle \frac{\displaystyle #1}{\displaystyle #2}}
%\newcommand{\Real}[1]{\Re e\left(#1\right)}
%\newcommand{\Imag}[1]{\Im m\left(#1\right)}
%\newcommand{\der}[1]{\mbox{\em \tiny #1}}

% Already defined?
%\newcommand{\var}[1]{\scalebox{0.9}{(}#1\scalebox{0.9}{)}}

\newcommand{\vars}[1]{\mbox{\footnotesize (} #1 \mbox{\footnotesize )}}
\newcommand{\var}[1]{\mbox{\small (} #1 \mbox{\small )}}
%\newcommand{\varl}[1]{\mbox{\normalsize (} #1 \mbox{\normalsize )}}
%\newcommand{\varL}[1]{\mbox{\large (} #1 \mbox{\large )}}

%\newcommand{\var}[1]{\scalebox{0.9}{$($}#1\scalebox{0.9}{$)$}}
%\newcommand{\vars}[1]{\mbox{\small (} #1 \mbox{\small )}}
%\newcommand{\Ocroch}{\mbox{\huge [}}
%\newcommand{\Fcroch}{\mbox{\huge ]}}
\newcommand{\doublint}{\int\!\!\!\int}
\newcommand{\triplint}{\int\!\!\!\int\!\!\!\int}

%-- Other shortcuts
%\newcommand*{\mail}[1]{\href{mailto:#1}{\texttt{#1}}}
%\newcommand*{\pkg}[1]{\texttt{#1}}

%-- Symbols and logos
\newcommand{\Csharp}{% egreg: http://tex.stackexchange.com/questions/44528/
  {\settoheight{\dimen0}{C}C\kern-.05em \resizebox{!}{\dimen0}{\raisebox{\depth}{\#}}}}
%- Old fashion commands (since 1995!), just for the record and compatybility with old documents
\def\myLaTeX{L\kern-.36em\raise.5ex\hbox{\scriptsize{\MakeUppercase{a}}}%
              \kern-.15em\TeX}%
\def\myAllTeX{(L\kern-.2em\raise.4ex\hbox{\scriptsize{\MakeUppercase{a}}}%
              \kern-.10em)\TeX}%
%              \kern-.15em)T\kern-.1667em\lower.7ex\hbox{E}\kern-.125emX\@}% original from Frenchb

%-- (La)TeX logos
%-- From http://tex.stackexchange.com/questions/60499/custom-latex-logo
%\RequirePackage{metalogo}
%\RequirePackage{metalogox}% There also exist a `metalogox` package
%\setlogokern{La}{-.24em}% default value = -.36em (see doc.)

%- New way (2010-2016: Heiko Oberdiek himself!), working also in bookmark
%- Usage: \hologo{(La)TeX} and \Hologo{(La)TeX} (starts with uppercase) → DOES NOT WORK! WHY?
%\RequirePackage{hologo}% TODO: adjusting spacing with the current font → TOO COMPLEX UGLY RESULTS
%\hologoSetup{break=true,hyphenbreak,spacebreak,discretionarybreak}
%\def\AllTeX{\hologo{(La)TeX}}

%-- From http://tex.stackexchange.com/questions/60499/custom-latex-logo
%\RequirePackage{metalogo}% There also exist a `metalogox` package
%\setlogokern{La}{-.24em}% default value = -.36em (see doc.)
%\newcommand{\BibTeX}{B\kern-.10em\textsc{i}\kern-.10em\textsc{b}\kern-.15em\TeX}
%% TODO: Add a Biber logo
\DeclareRobustCommand\AllTeX{%
  \@xl@everylogo
  (\kern\xl@kern@LaTeX@aT L\kern\xl@kern@La@La
    {\ifxetex
    \XeTeXuseglyphmetrics\@ne
    \fi
    \sbox\z@ T%
    \sbox\@ne{\xl@LaTeX@a}%
    \vbox to\ht\z@{%
      \hbox{%
        \ltx@sh@ft{\ht\z@}%
        \xl@sh@ft{\ht\@ne}%
        \xl@LaTeX@a
        \xl@sh@ft{\ht\z@}%
        \ltx@sh@ft{\ht\@ne}}%
      \vss}}%
  \kern\xl@kern@LaTeX@aT)\TeX%
}

\RequirePackage{metalogox}%
\setlogokern{Te}{-.10em}% default value = -.36em (see doc.)
\setlogokern{eX}{-.05em}% default value = -.36em (see doc.)

\RequirePackage{lipsum}% For illustrations and tests


%---------------------------------------------------------------------------------------------------
%---- Barcodes ISBN, ISSN, etc.
%---------------------------------------------------------------------------------------------------

%---
%- A solution could be a PNG file from: https://www.bookow.com/resources.php
%- Another full solution is the `pst-barcode' package, complete but with PsTricks: need convertion)
%---

\RequirePackage{ean13isbn}% For ISBN13 and EAN13, seems to be sufficient
%- Usage: \EANisbn[SC5b,ISBN=978-80-7340-097-2], SCxx stands for scaling option (see doc.)


%---------------------------------------------------------------------------------------------------
%---- Embedding non-PDF external files: source files (bibliography, classes/styles, graphics, etc.
%---------------------------------------------------------------------------------------------------


%----- Embedded files reading
%- Mainly possible with AR, see:
%- https://tex.stackexchange.com/questions/260430/opening-a-non-pdf-file-clicking-on-a-bookmark
%- https://tex.stackexchange.com/questions/434186/how-to-embed-plain-text-data-into-a-pdf-with-latex
%- https://tex.stackexchange.com/questions/418606/[...]
%-   [...]embed-non-pdf-files-e-g-bibtex-into-pdf-with-hyperlink-in-the-pdf
%-
%- As far as working packages are concerned, it seems for the moment beeing that:
%-  − 'embedfile.sty' is only for PdfTeX ≥ 1.30 and AR (compile with LuaTeX but DOES NOT WORK),
%-  − 'attachfile.sty' (Scott Pakin) works with LuaTeX/Evince, but with ugly results (to be tuned)
%-  − 'attachfile2.sty' (Heiko Oberdiek) is an improvement of Scott Pakin's 'attachfile'
%-----

%- Helper package to attach non-PDF files to the current PDF document
%\RequirePackage{luatex85}
%\RequirePackage{attachfile}
%\RequirePackage{attachfile2}% To be able to e.g. set the colorx specifications

%\RequirePackage{texjazz-attachfile}% Fork of "attachfile2.sty' (adding Fontawesome icons?)

%\attachfilesetup{%
  %appearance=false,
  %author={},%ejazz,
  %color=1 0.9255 0.7765,%firstcolor,%RGB
  %created=<PDFdate>,
  %date=<PDFdate>,
  %description=,
  %icon=PushPin,
  %mimetype=,
  %modified=,
  %print=true,
  %size=,
  %subject=,
  %timezone=,
  %zoom=true,
  %scale=0.5
%}
%\attachfilesetup{author=ejazz, icon={\faThumbTack}}
% Commented annotation: description={Jazz way for an attached file}


%\RequirePackage{intopdf}%
%\RequirePackage{embedall}%


% SEE `embedall` package



%---------------------------------------------------------------------------------------------------
%---- Glossaries, notations, symbols and index / Glossaires et autres listes indexées
%---------------------------------------------------------------------------------------------------

%--- Different ways to build glossaries and alike
%------------------------------------------------
%- See the user manual: a bit hard to understand... A lot of time has been spent to read this doc.!
%- Really great package, but too much information for a beginner... It's OK after a while!
%-
%- Option 1 (TeX)
%----------------
%- Simplest but ineficient, the sorting is done according to the English alphabet: No accent.
%- Only TeX is used (no external application), straightforward but slow and ineficient
%- Unable to manage large glossary and to sort extended Latin characters (accents)
%-  \makenoidxglossaries% In the preamble before defining entries
%-
%- Option 2 (makeindex)
%----------------------
%- Uses CLI application `makeindex' but can’t sort accents and fails with UTF-8 characters: avoid!
%-  \makeglossaries% In the preamble before defining entries
%-
%- Option 3 (xindy)
%------------------
%- Uses CLI application `xindy', more flexible for accents, but needs Perl and have drawbacks
%- TEST FAILS WITH EXTERNAL SCRIPT:
%-   → libncurses.so.5: cannot open shared object file: No such file or directory
%- THE SOLUTION IS to install the libncurse5'/`libncursew5' packages (in Ubuntu repositories) YES!!!
%- TRYING THE `automake' option FOR CONVENIENCE: we fail with that for the moment being :-(
%-  \usepackage[xindy]{glossaries}
%-  \makeglossaries% In the preamble before defining entries
%- Configuring a TeX IDE: LaTeXila/Gnome LaTeX (Gtk+) or TeXmaker (Qt)
%-   In order to run external applications from a TeX IDE (e.g. for glossaries with `xindy'
%-   Perl script or `bib2gls' Java application), ONE MUST ADD SYMBOLIC LINKS IN /usr/user/bin/:
%-   > sudo ln -s /opt/texlive/2019/bin/x86_64-linux/xindy xindy (OK: FINE!)
%-
%- Option 4 (bib2gls − Only available with the extension package `glossaries-extra')
%-----------------------------------------------------------------------------------
%-  Uses the CLI external application `bib2gls' to both fetch entry definitions from a .bib files
%-  and to hierarchically sort and collate (with at least Java 8). It supports Unicode. This option
%-  needs the `glossaries-extra' package and seems to be the more powerful way but not obvious
%-  to configure with LaTexila (TODO); OK with CLI using.
%-  \usepackage[record=only]{glossaries-extra}
%-  \GlsXtrLoadResources[src={entries}]% file name entries.bib with definitions as @entry{...}
%-
%- Option 5 (no sorting − Only available with the extension package `glossaries-extra')
%--------------------------------------------------------------------------------------
%-  no indexing application is required
%-
%- Conclusion
%------------
%- For options 2 and 3, a external script (Perl `makeglossaries' or Lua `makeglossaries-lite')
%- simplifies the build process. As for now, the Perl script is better to use because it provides
%- additional diagnostics if things go wrong (see documentation).
%- For example, a buil-in command has been configured in LaTeXila.
%----- Xindy indexing
%- Besides the possibility to manage the extended Latin languages (like French), the `xindy' option
%- is the best choice for having glossaries with displaying refered text from labels when calling
%- the \gls{<label>} and alike commands from the first LaTeX run. This means that, as a first step,
%- one can write and manage its document without building and displaying the glossaries.
%- The advantage is also just loading the `glossaries' package (no need of the `glossaries-extra'
%- package). But one of the drawback is when wanting the entry locations list (location pages):
%- a spurious and weird page number is added, corresponding to the \gls{<label>} call in the main
%- glossary itself. This is not an unacceptable issue using the command `\glsaddallunused[main]`
%- The CLI command to be ran are, for each glossary (Perl script):
%-   > xindy -L french -C utf8 -I xindy -M jobname -t jobname.glg -o jobname.gls jobname.glo
%- and for all glossaries at once (Perl script):
%-   > makeglossaries jobname
%----- Bib2gls indexing
%- The `bib2gls' Java script is the most powerful tool for indexing, but needs, like Biber, to be
%- run after the first LaTeX run to have the refered texts printed. It also need the `glossaries-
%- extra' package to be loaded. One of the drawbacks is to have Java installed.
%- The CLI command to be run is (Java application) − typeset "bib2gls --help" for options:
%-   > bib2gls --group jobname
%-----

%-------------
%- AFTER TESTING ALL THE SOLUTIONS, THE CHOICE SHOULD BE THE `bib2gls' OPTION FOR FINAL DOCUMENT.
%- The reasons:
%-   * Managing the extended Latin/non Latin characters
%-   * Printing correctly the entry/page locations
%-   * Using the new and/or up-to-date extensions and commands from the `glossaries-extra' package
%- NEVERTHELESS, IN THE PROCESS OF WRITING A DOCUMENT AND/OR THE GLOSSARIES ARE LATER PRINTED,
%- THE `xindy' OPTION IS MORE CONVENIENT AND MORE THAN ENOUGH IN MOST CASES OF USE.
%- The reasons:
%-   * Managing the extended Latin/non Latin characters
%-   * Giving the referenced/labelled text term after the first LaTeX run
%-   * Printing correctly the entry/page locations (with the help of \glsaddallunused command)
%-   * Using the new and/or up-to-date extensions and commands from the `glossaries-extra' package
%- THE `xindy' OPTION IS THUS USED BY DEFAULT. A CLASS OPTION IS DEFINED TO MAKE THE CHOICE EASIER.
%-------------

%-----
%- IF USING `xindy`, ONE MUST HAVE A LOOK TO (in French):
%-  http://geekographie.maieul.net/169 − Un outil d’indexation plus efficace que `makeindex`
%-  http://geekographie.maieul.net/170 − Premier pas avec xindy
%-  http://geekographie.maieul.net/171 − Régler l’apparence des index avec xindy
%-  http://geekographie.maieul.net/172 − xindy et hyperref
%-  http://geekographie.maieul.net/174 − xindy, eledmac et hyperref
%-  http://geekographie.maieul.net/176 − Tri personnalisé des entrées avec xindy
%-  http://geekographie.maieul.net/190 − xindy, hyperref et |see
%-  http://geekographie.maieul.net/200 − xindy et bibleref
%-----
%- FOR SPURIOUS WARNINGS FROM `hyperref' WITH `xindy` WITH LuaTeX:
%-  https://tex.stackexchange.com/questions/333255/[...]
%-   [...]strange-atbegshioutput-warning-in-case-of-special-xdy-style-file-that-is-supp
%- SEE ALSO THE `glossaries` PACKAGE DOCUMENTATION: p.
%-----

%- Xindy or Bib2gls − TODO: make a real option for the document (for the moment being: `xindy')
\newif\ifdocglossary@xindy\docglossary@xindytrue%\docglossary@xindyfalse

%- Setting the glossaries indexing engine
\ifdocglossary@xindy
  \newcounter{localglossary}% See `glossaries-extra` doc. p. 74, 76 for details
  \ifdoc@glossnowarn
    \RequirePackage[% Take care that \PassOptionsToPackage command seems not to work here... WHY?
      toc=false,% No ToC adding: a \backchapter is previously settled (bug with `titletoc' package?)
      %toc=true,% ToC adding = wrong: there is really a bug with the `titletoc' package
                % Moreover, the ToC display is not designed correctly and the page marks also
      nopostdot,% No final dot added to the description field: manually inserted in each entry
      %nonumberlist,% No entry locations if the sorting engine `xindy' is used
      %nogroupskip,% No vertical space after one logical group but before the next one
      xindy,% AKA option 3: Uses `xindy' Perl script for sorting (`makeindex' leads to weird errors)
            % CAUTION: As for september 2019, with Ubuntu MATE 18.10, the installed `libncurse' is
            % `libncurse6/libncursew6', but`xindy' script explicitly requires `libncurse5/libncursew5'
            % thus these packages HAVE TO BE INSTALLED (they are in the Ubuntu repositories).
            % Things are then much more easy... Enjoy `xindy'!
       section=subsection,% Set the glossaries as \subsection* unit (not \chapter* book default)
                         % This can be also set within the document with \setglossarysection
      %automake,% Only works (NO! JUST COMPILES: WHY?) with `makeindex/xindy' options, not `bib2gls'
                 % No need to explicitly call the `xindy' nor the `makeglossaries' Perl scripts
                 % (uses the LaTeX `write18' functionality which obviously must be allowed)
      %nostyles,% No style loaded: not works...
      %counter=subsection,% Just to test if it works for the moment being
      counterwithin={localglossary},% See `glossaries` doc. p. 71
    ]{glossaries}%
  \else
    \RequirePackage[% Take care that \PassOptionsToPackage command seems not to work here... WHY?
      nowarn,% Suppressing all the warnings generated by the `glossaries` package (final document)
      toc=false,% No ToC adding: a \backchapter is previously settled (bug with `titletoc' package?)
      %toc=true,% ToC adding = wrong: there is really a bug with the `titletoc' package
                % Moreover, the ToC display is not designed correctly and the page marks also
      nopostdot,% No final dot added to the description field: manually inserted in each entry
      %nonumberlist,% No entry locations if the sorting engine `xindy' is used
      %nogroupskip,% No vertical space after one logical group but before the next one
      xindy,% AKA option 3: Uses `xindy' Perl script for sorting (`makeindex' leads to weird errors)
            % CAUTION: As for september 2019, with Ubuntu MATE 18.10, the installed `libncurse' is
            % `libncurse6/libncursew6', but`xindy' script explicitly requires `libncurse5/libncursew5'
            % thus these packages HAVE TO BE INSTALLED (they are in the Ubuntu repositories).
            % Things are then much more easy... Enjoy `xindy'!
       section=subsection,% Set the glossaries as \subsection* unit (not \chapter* book default)
                         % This can be also set within the document with \setglossarysection
      %automake,% Only works (NO! JUST COMPILES: WHY?) with `makeindex/xindy' options, not `bib2gls'
                 % No need to explicitly call the `xindy' nor the `makeglossaries' Perl scripts
                 % (uses the LaTeX `write18' functionality which obviously must be allowed)
      %nostyles,% No style loaded: not works...
      %counter=subsection,% Just to test if it works for the moment being
      counterwithin={localglossary},% See `glossaries` doc. p. 71
    ]{glossaries}%
  \fi
  %- The `glossaries-extra' package adds much more functionalities
  %- Default options for the `glossaries-extra' package: toc, nopostdot
  %\PassOptionsToPackage{%
    %toc=false,% No ToC adding: a \backchapter is previously inserted (bug with `titletoc' package?)
              % Note also that one must type in \printunsrtglossary[title={}] to print the glossary
              % to avoid the title print (as section: see below)
    %nopostdot,% Althought it's the default, we explicitely add this option for clarity (doesn't work)
    %nostyles,% Don't load default style packages, but add the ones used
    %stylemods={listgroup},% Loads the used styles only (with glossaries-extra-stylemods.sty)
    %style=listhypergroup,% To have the navigation bar, compile the document twice
    %record=only,% To have the benefit of the external JAVA 8 indexing engine `bib2gls':
                 % run CLI "bib2gls --group finame" (without extension) in master file directory
    %record=nameref,% Like record=only but records the information given by \@currentlabel
                   % and \@currentHref, which provides a more reliable way for location
    %xindy,% Uses the external `xindy' Perl script as sorting engine
    %automake,% Only works with `makeindex' and `xindy' options, not with `bib2gls'
  %}{glossaries-extra}% For options 2, 3 and 4: see the user guide Tab. 1.1
  %\RequirePackage{glossaries-extra}% No loading, the needed commands are (re)defined
  %- Adding the prefix p. (only one page or pp. several pages before the page number referenced
  %- The following command needs the `glossaries-extra' package to work
  %\GlsXtrEnablePreLocationTag% It works! Needs a minimum of two/three compilations
  %  {\raisebox{.15ex}{\textcolor{maincolor}{\tiny\faSquare}}\space{p.~}}%
  %  {\raisebox{.15ex}{\textcolor{maincolor}{\tiny\faSquare}}\space{pp.~}}
  %{\textemdash{} p.~}{\textemdash{} pp.~}
  %\pretocmd{\GlsXtrEnablePreLocationTag}{\hspace*{-0.5em}}{}{}
  %\AtEndOfClass{% Just a shortcut to mimic biber process
  %  \newcommand{\addglossressource}[1]{%
  %    \makeglossaries% Open glossary files
  %    \loadglsentries{#1}% File name with the entry definitions (option 1, 2 or 3)
  %  }
  %}
\else% TODO: Load the `glossaries-extra` package too and configure the options
\fi

\RequirePackage{glossaries-extra}
%\RequirePackage[automake]{glossaries-extra}

%- Workaround to circonvent an issue of \imediate\write16 from `supp-pdf.mkii' file
%- See our question and Ulrike FRischer comments/answer:
%- https://tex.stackexchange.com/questions/541191/[...]
%-    [...]tcolorbox-with-minted-option-glossaries-biblatex-limitation-incompatibilit...

\newcommand\writestatus[2]{}% <-- Essential

\newcommand{\glsmain}[1]{\gls{#1-main}}% For main glossary references

%- Avoid the following until you understand the real consequences of using this command
%- Dealing with this thing seems to be a bit complex for a beginner. See doc. and for example:
%-  https://tex.stackexchange.com/questions/89107/glossary-per-chapter-or-section
%-  https://tex.stackexchange.com/questions/325434/glossary-per-chapter-not-by-section
%\GlsSetXdyMinRangeLength{0}
%\GlsSetXdyMinRangeLength{1}

%--- Capitalizing the first letter of glossary list of terms
%- See:
%-   https://tex.stackexchange.com/questions/69567/uppercase-word-in-glossary-lowercase-in-text
%-   https://tex.stackexchange.com/questions/79907/[...]
%-     [...]howto-achieve-capitalized-description-in-glossary-table
%-   https://tex.stackexchange.com/questions/294473/title-case-an-acronym
%-   https://latex.org/forum/viewtopic.php?f=5&t=9966
%-   https://latex.org/forum/viewtopic.php?p=94372#p94372
%-----
%\RequirePackage{titlecaps}% Capitalizes the first letter of argument (each word)
%\RequirePackage{mfirstuc}% Capitalizes the first letter of argument (first word if several)

%- Default glossary uses the description env. to display the entry list: a try to customize it
%\renewcommand*{\glsnamefont}[1]{% Capitalizing the first letter of ALL words of the term definition
%  \lightbf{\textsc{\titlecap{#1}}}
%}
\renewcommand*{\glsnamefont}[1]{% Capitalizing the first letter for ONLY THE FIRST WORD of the term
  \lightbf{\scshape\makefirstuc{#1}\space\textemdash\hspace*{-0.5em}}
}

%- Although the entrycounter − glossaryentry counter − is activated, its displaying is not wanted
\renewcommand*{\glsentryitem}[1]{%
  \ifglsentrycounter
    \glsstepentry{#1}%\glsentrycounterlabel
  \else
    \glsresetsubentrycounter
  \fi
}

%- Explicitely setting the glossary term color (not needed with `hyperref' package)
%- See: https://tex.stackexchange.com/questions/38544/glossary-links-color
%\renewcommand*{\glstextformat}[1]{\textcolor{secondcolor}{#1}}% Default `hyperref' = firstcolor

%-- Configuring the navigation bar line (if used by the applied style)

%--- Note
%- As september 2019, we don't have find a better way than redefining the \glsnavigation command
%- to set the hyperlinks color of group titles in the navigation line. By default and for a unknown
%- reason, this color is a kind of pastel green which is not settled by the `hyperref' package
%- (all links are colored with the so-called `firstcolor', corresponding to `darkelectricblue',
%- see the settings above). To have a better understanding, may be we'll ask a question to TeX.SE
%-----

%- Setting the navigation bar hyperlinks color to match the hyperlinks color of the document
\renewcommand*{\glsnavigation}{%
  \def\@gls@between{}%
  \ifcsundef{@gls@hypergrouplist@\@glo@type}%
  {%
    \def\@gls@list{}%
  }%
  {%
    \expandafter\let\expandafter\@gls@list
      \csname @gls@hypergrouplist@\@glo@type\endcsname
  }%
  \@for\@gls@tmp:=\@gls@list\do{%
    \@gls@between% Separator between each group title in the navigation bar line
    \@gls@getgrouptitle{\@gls@tmp}{\@gls@grptitle}%
    %\glsnavhyperlink{\@gls@tmp}{\@gls@grptitle}% Original
    \glsnavhyperlink{\@gls@tmp}{\textcolor{firstcolor}{\@gls@grptitle}}%
    \let\@gls@between\glshypernavsep
  }%
}

%--- Note (from Nicola Talbot's answer: https://tex.stackexchange.com/questions/348610/)
%- By default the navigation line/bar in "hypergroup" styles is in the optional argument of \item
%- which aligns it with the entries and group headers. This is fine as long as there's enough room
%- on the line. If there isn't, the \glslistnavigationitem command needs to be redefined. See:
%-   https://tex.stackexchange.com/questions/389443/tweak-altlisthypergroup-glossary-style
%-   https://tex.stackexchange.com/questions/348610/can-package-glossaries-work-in-two-column-mode
%-----

%- Putting the navigation bar in the description text rather than in the label
%\renewcommand*{\glslistnavigationitem}[1]{\item[#1]}% Original
\renewcommand*{\glslistnavigationitem}[1]{% No description item label and no gap with its core text
  \labelsep0pt\relax% No space before the navigation bar: no indent/labelsep from the left margin
  \begin{fullwidth}% Avoid horizontal overfull
    \item #1%
    \vspace*{-0.5\baselineskip}% 
    \item {\color{secondcolor}\rule{\entirewidth}{0.8pt}}\par% Adding a separation line
  \end{fullwidth}
  % Resetting a standard \labelsep for the following list items
  \labelsep0.5em\relax% \labelsep=0.5em as defined in the `book' class
}

%- Retrieving a standard gap between label and description core text after the navigation bar
%\apptocmd{\glslistnavigationitem}{% Resetting a standard \labelsep for the following list items
%  \vspace*{-0.5\baselineskip}%
%  %\item {\color{secondcolor}\rule{\textwidth}{0.4pt}}\par% Adding a separation line
%  \item {\color{secondcolor}\rule{\entirewidth}{0.8pt}}\par% Adding a separation line
%  \labelsep0.5em\relax% \labelsep=0.5em as defined in the `book' class
%}{}{}

%- Compressing the gap between letters in the navigation bar, if used by the applied style
%\renewcommand*{\glshypernavsep}{\space\textbar\space}% Original
%\renewcommand*{\glshypernavsep}{\textbar}%
\renewcommand*{\glshypernavsep}{% Modifying the navigation bar separator and layout
  %\textcolor{secondcolor}{\normalfont\textbar}% If \glossaryheaderfont doesn't have a pipe symbol
  \textcolor{secondcolor}{\,\textbar\,}% If \glossaryheaderfont has the pipe/textbar symbol
}%

%-- As for the navigation bar, setting the location/page(s) color hyperlink (not pastel green!)

%- Setting the link color of location/page(s) to the one of the document (firstcolor)
%- See: https://tex.stackexchange.com/questions/431766/[...]
%-   [...]formatting-back-references-in-glossary-same-as-in-bibliography
%\renewcommand{\glsnumberformat}[1]{\textcolor{green}{$\uparrow$\glshypernumber{#1}}}
\renewcommand{\glshypernumber}[1]{\textcolor{firstcolor}{#1}}% THAT'S IT! Putain, on y est arrivé...

%--- Note about extra macros and command sequences for glossaries
%----------------------------------------------------------------
%- The `glossaries-extra' package adds a lot of usefull extensions to the `glossaries` package.
%- But because only a few of them are used, just the required macros and command sequences
%- are defined, borrowing/stealing the code to the `glossaries-extra` package.
%- Loading the `glossaries-extra` package is therefore not necessary and its a good
%- pedagogical way to understand more in deep the internals of the package and also
%- to learn the `etoolbox' package using!
%- In order to be able to load the `glossaries-extra` package for future needs, all
%- the "xtr" prefixes are replaced with "jazz" as for the other specific commands
%- defined for the `texjazz` bundle extension files, class or styles.
%-----

%- Adding the prefix p. (only one page) or pp. (several pages) before the referenced page number
%- The following command is a clone of \GlsXtrEnablePreLocationTag from `glossaries-extra' package
\GlsXtrEnablePreLocationTag% It works! Needs a minimum of two/three compilations
  {\raisebox{.15ex}{\textcolor{maincolor}{\tiny\faSquare}}\space{p.~}}%
  {\raisebox{.15ex}{\textcolor{maincolor}{\tiny\faSquare}}\space{pp.~}}
  %{\textemdash{} p.~}{\textemdash{} pp.~}
%\pretocmd{\JazzGlsXtrEnablePreLocationTag}{\hspace*{-0.5em}}{}{}


%-- Setting the main glossary style and commands occurring at the end of the document
%------------------------------------------------------------------------------------

%- Defining a new helper (vertical) length to use with the main glossary style
\newlength{\glossgroupheadheight}
\settoheight{\glossgroupheadheight}{\glossaryheaderfont\huge{Q}}% See font definitions above

%- After trying many ways to solve the issue of putting correct margin group header, let's use TikZ!
%- See: https://tex.stackexchange.com/questions/411557/draw-on-margin-of-page-with-tikz
%- See: https://tex.stackexchange.com/questions/229934/anchor-tikz-at-the-left-margin
%- See also Gonzalo Medina's code inserted in a `\marginnote' (and see also \caution above)
%- A toggle between right/left margin is not necessary because outpout is wanted in the left margin
\newcounter{mainglossgroup}
\newcommand{\mainglossgroupheader}[1]{% Applying a style with Fractur font to the header group title
  \stepcounter{mainglossgroup}%
  \jazztikzmark{\themainglossgroup}% See def. above: e.g. `\caution' command definition
  \begin{tikzpicture}[remember picture, overlay]
    \node[draw=none, thick,
          xshift=0pt, yshift=-0.5\glossgroupheadheight,
          inner sep=0pt, anchor=north east]
      (glossgroupheader\themainglossgroup)
      at ([xshift=-0.3\marginparsep, yshift=5pt]current page text area.west|-\themainglossgroup)
      {\glossaryheaderfont\huge\textcolor{secondcolor}{#1}};%\nopagebreak[4]
  \end{tikzpicture}%
}

%- Defining a new glossary style for the main glossary (with a line bar navigation)
\newglossarystyle{jazzhypergroup}{% Based on the `listhypergroup' style (cf. glossaries-code.pdf)
  %\setglossarystyle{list}%
  \renewenvironment{theglossary}% Use the description environment
    {\begin{description}}%
    {\end{description}}%
  \renewcommand*{\glossentry}[2]{% Main (level 0) entries start a new item in the list
    \item[\glsentryitem{##1}\glstarget{##1}{\glossentryname{##1}}]
      \glossentrydesc{##1}\glspostdescription\space ##2%
  }%
  \renewcommand*{\subglossentry}[3]{%Sub-entries continue on the same line
    \glssubentryitem{##2}%
    \glstarget{##2}{\strut}\space\glossentrydesc{##2}\glspostdescription\space ##3.%
  }%
  \renewcommand*{\glossaryheader}{% See \glossarypreamble to add something BEFORE the glossary
    %\glslistnavigationitem{\glsnavigation}% Original
    % Adding navigation links extended to whole width but without \glslistnavigationitem
    % See: https://tex.stackexchange.com/questions/296202/list-of-letter-not-folding-in-glossaries
    %\glslistnavigationitem{\parbox{\textwidth}{\huge\glsnavigation}}%
    \glslistnavigationitem{% Full width main glossary navigation bar (from `changepage' package)
      \begin{adjustwidth*}{0em}{-\wholemargin}%
        \RaggedRight\glossaryheaderfont\large\glsnavigation%
      \end{adjustwidth*}%
    }%
  }
  \renewcommand*{\glsgroupheading}[1]{% Each group has a heading with a hypertarget
    %\item[\glslistgroupheaderfmt{\glsnavhypertarget{##1}{\glsgetgrouptitle{##1}}}]% Original
    \Needspace{2\baselineskip}% Verifying/reserving a minimum of two lines space before a page break
    \item[% Modified
      \glslistgroupheaderfmt{% Formatting the group header title
        \glsnavhypertarget{##1}{% Setting the group header as a hyperlink target for the navigation
          \mainglossgroupheader{% Applying the group header style defined just above
            \glsgetgrouptitle{##1}% Getting the group header title to print/display
          }%
        }%
      }%
    ]%
    % The above \Needspace command seems to do the trick! May be further settings would be necessary
    %\nobreak% No break between group header and the first glossary entry definition (horizontal)
    %\nopagebreak[4]%
  }%
  \renewcommand*{\glsgroupskip}{% Add vertical space between groups
    %\ifglsnogroupskip\else\indexspace\fi% Original
    \ifglsnogroupskip\else% Modified (if necessary)
      \vspace*{-\baselineskip}% Suppressing the vertical space introduced by \par? Yes, it seems
      %\vspace*{-.5\glossgroupheadheight}% Glossary header letter are \huge
      %\par\vskip -.5\glossgroupheadheight% \@plus 5\p@ \@minus 5\p@ \relax% Modified definition
      \vskip 4\p@ \@plus 2\p@ \@minus 2\p@ \relax% Modified definition
    \fi
  }%
}

%- Defining a command sequence to allow including margin graphics in the glossaries
%- This command may be used in the description field of a glossary entry (preamble or external file)
%- For normal paragraph text layout, this is just a call to the \sideGgraphic command defined above,
%- with conditionals to be settled before glossaries. But for text inside a tcolorbox − as for local
%- glossaries −, one must use a `tikzmark` approach in a way given by the G. Medina's \caution
%- command as defined above too.
\newif\ifallowglossary@graphic
%\allowglossary@graphictrue
\allowglossary@graphicfalse
\newif\ifallowlocalglossary@graphic
%\allowlocalglossary@graphictrue
\allowlocalglossary@graphicfalse


%- Defining a side element command to be used from inside a tcolorbox
%- This a clone of the \caution command above (http://tex.stackexchange.com/questions/78193/)
\newcounter{xsidecount}

\newcommand\sideelementtikzmark[1]{%
  \tikz[remember picture,overlay]\node[inner xsep=0pt,outer sep=0pt] (#1) {};}

%- The `tcolorbox` package redefines \textwidth and \linewidth to be shorter.
%- So, it leads to have a gap for elements to be displayed outside a tcolorbox, and must be corrected
\newcommand{\sideElementRight}[1]{%
  \stepcounter{xsidecount}%
  \sideelementtikzmark{\thexsidecount}%
  \begin{tikzpicture}[remember picture,overlay]
    \node[draw=red, anchor=west, xshift=\marginparsep, yshift=0pt, inner sep=4pt]
      (mybox\thexsidecount)
      at ([yshift=3pt]current page text area.east|-\thexsidecount)
      {\parbox{\marginparwidth-8pt}{\centering\footnotesize#1}};
  \end{tikzpicture}%
}

\newbool{sideElementGraphic}
\newbool{tcbsideElement}

%\newcommand*{\defaultelementboxname}{Note de la rédaction}

\NewDocumentCommand{\tcbsideElement}{s O{c} D<>{secondcolor} m g s}{%
  \IfBooleanTF{#1}{\booltrue{sideElementGraphic}}{\boolfalse{sideElementGraphic}}%
  \IfBooleanTF{#6}{\booltrue{tcbsideElement}}{\boolfalse{tcbsideElement}}%
  \checkoddpage
  \ifoddpageoroneside
    \setlength\trianglexshift{-3pt}%
    \setlength\boxhshift{\marginparsep}%
    \renewcommand{\side}{west}%
    \renewcommand{\otherside}{east}%
  \else
    \setlength\trianglexshift{3pt}%
    \setlength\boxhshift{-\marginparsep}%
    \renewcommand{\side}{east}%
    \renewcommand{\otherside}{west}%
  \fi%
  \settoheight{\noteheight}{\parbox{\marginparwidth-8pt}{\footnotesize#3}}%
  \stepcounter{xsidecount}%
  \sideelementtikzmark{\thexsidecount}%
  \if#2b\relax
    \renewcommand\pointeranchor{xsidebox\thexsidecount.south \side}%
    \renewcommand\boxanchor{south \side}%
    \setlength\boxvshift{\noteheight}%
    \addtolength\boxvshift{-.6\baselineskip}% Adjust the vertical shift with the text line
    \setlength\uppertrianglecorner{13pt}%
  \else
    \if#2t\relax
      \renewcommand\pointeranchor{xsidebox\thexsidecount.north \side}%
      \renewcommand\boxanchor{north \side}%
      \setlength\boxvshift{-\noteheight}%
      \addtolength\boxvshift{.6\baselineskip}% Adjust the vertical shift with the text line
      \setlength\uppertrianglecorner{-7pt}%
    \else
      \if#2c\relax
        \renewcommand\pointeranchor{xsidebox\thexsidecount.\side}%
        \renewcommand\boxanchor{\side}%
        %\setlength\boxvshift{\baselineskip}% No vertical shift, just centered with the text line
        \setlength\uppertrianglecorner{3pt}%
      \fi%
    \fi%
  \fi%
  \marginnote{%
    \begin{tikzpicture}[remember picture,overlay]
      \ifbool{sideElementGraphic}{% Graphic inserting
        \ifbool{tcbsideElement}{% Inside a tcolorbox
          \BeforeBeginEnvironment{displaylocalglossary}{%
            \tikz[remember picture,overlay]
              \node[fit=(current page text area),
                    line width=0, inner sep=0,
                    name=correct current page text area]{};
          }
          \node[draw=#3, thick, anchor=\side,
                xshift=\boxhshift, yshift=\boxvshift, inner sep=0pt]
            (xsidebox\thexsidecount)
            at ([yshift=3pt]correct current page text area.\otherside|-\thexsidecount)
            {\parbox{\marginparwidth}{\centering\footnotesize#4}};
        }{% Normal paragraph
          \node[draw=#3, thick, anchor=\side,
                xshift=\boxhshift, yshift=\boxvshift, inner sep=0pt]
            (xsidebox\thexsidecount)
            at ([yshift=3pt]current page text area.\otherside|-\thexsidecount)
            {\parbox{\marginparwidth}{\centering\footnotesize#4}};
        }%
      }{% Text inserting
        \ifbool{tcbsideElement}{% Inside a tcolorbox
          \BeforeBeginEnvironment{displaylocalglossary}{%
            \tikz[remember picture,overlay]
              \node[fit=(current page text area),
                    line width=0, inner sep=0,
                    name=correct current page text area]{};
          }
          \node[draw=#3, thick, anchor=\side,
                xshift=\boxhshift, yshift=\boxvshift, inner sep=4pt]
            (xsidebox\thexsidecount)
            at ([yshift=3pt]correct current page text area.\otherside|-\thexsidecount)
            {\parbox{\marginparwidth-8pt}{\vskip4pt\footnotesize#4\vskip2pt}};
        }{% Normal paragraph
          \node[draw=#3, thick, anchor=\side,
                xshift=\boxhshift, yshift=\boxvshift, inner sep=4pt]
            (xsidebox\thexsidecount)
            at ([yshift=3pt]current page text area.\otherside|-\thexsidecount)
            {\parbox{\marginparwidth-8pt}{\vskip4pt\footnotesize#4\vskip2pt}};
        }%
      }%
      \IfValueT{#5}{%
        \node[fill=white, font=\color{#3}\sffamily,
              anchor=west, inner sep=2pt,
              xshift=7pt, yshift=0pt]
          at (xsidebox\thexsidecount.north west)
          {\footnotesize\enspace\textcolor{black}{\textsc{#5}}\enspace};
      }%
      \fill[#3]
        ([yshift=\uppertrianglecorner]\pointeranchor) --
        ([yshift=\uppertrianglecorner-3pt, xshift=\trianglexshift]\pointeranchor) --
        ([yshift=\uppertrianglecorner-6pt]\pointeranchor) -- cycle;
    \end{tikzpicture}%
  }%
}

\newcounter{glsgraphiccount}
\newcommand\glssidetikzmark[1]{%
  \tikz[remember picture,overlay]\node[inner xsep=0pt,outer sep=0pt] (#1) {};}

\newcommand*{\glssidenodename}{current page text area}% Default node name for side glossary graphic

\NewDocumentCommand{\glssidegraphic}{m}{%
  \checkoddpage
  \ifoddpageoroneside
    \setlength\boxhshift{\marginparsep}%
    \renewcommand{\side}{west}%
    \renewcommand{\otherside}{east}%
  \else
    \setlength\boxhshift{-\marginparsep}%
    \renewcommand{\side}{east}%
    \renewcommand{\otherside}{west}%
  \fi%
  \settoheight{\noteheight}{\parbox{\marginparwidth}{#1}}%
  \stepcounter{glsgraphiccount}%
  \glssidetikzmark{\theglsgraphiccount}%
  \renewcommand\pointeranchor{glossarysidebox\theglsgraphiccount.north \side}%
  \renewcommand\boxanchor{north \side}%
  \setlength\boxvshift{-\noteheight}%
  \addtolength\boxvshift{.6\baselineskip}% Adjust the vertical shift with the text line
  \marginnote{%
    \begin{tikzpicture}[remember picture,overlay]
      \node[draw=secondcolor, thick, anchor=\side,
            xshift=\boxhshift, yshift=\boxvshift, inner sep=0pt]
        (glossarysidebox\theglsgraphiccount)
        at ([yshift=0pt]\glssidenodename.\otherside|-\theglsgraphiccount)
        {\parbox{\marginparwidth}{\centering#1}};
    \end{tikzpicture}%
  }%
}

%--- Note − Margin contents from a tcolorbox: purpose, issues and solution
%-------------------------------------------------------------------------
%- A ‘tcolorbx’ doesn't manage floats. Because our glossary environments are displayed
%- with tcolorboxes, we can't use the \marginpar command (which defines a special float)
%- and their companion commands from the ‘marginfix’ package to automatically manage
%- the vertical layout of margin contents (see \sidenote and \chapterToC commands above).
%- This issue is corrected by using the ‘marginnote’ package, which defines margin position
%- by mean of PDFTeX, XeTeX and LuaTeX primitives \savepos, \lastxpos, and \lastypos
%- (\pdfsavepos, \pdflastxpos, \pdflastxpos and \pdflastypos), see the documentation and:
%- https://tex.stackexchange.com/questions/427533/savepos-savepos-in-lualatex-why
%- But unfortunately, if several margin notes are called on the same line,
%- or from the next lines if the contents of the first note are too long, a overlapping occurs.
%- This is a feature of ‘marginnote’ package, and not a bug. Nevertheless, this behaviour
%- is not wanted for  automatically managing consecutive margin notes in this context.
%- So, to solve the problem, a new command for this kind of margin contents must be defined.
%-----

%- Defining a ‘glossary’ side note: special treatment inside a ‘tcolorbox’ environment
%- TODO: adding hyperlink properties: an issue occurs with footnote/sidenote hyperlinks

\newcounter{glsnote}
\renewcommand{\theglsnote}{\alph{glsnote}}
\newcounter{glsmarginnotepage}

\def\@makeglssidemark{%
  \hbox{\@textsuperscript{\raisebox{-1.25pt}{\normalfont\textcolor{secondcolor}{\itshape\@theglssidemark}}}}%
}
\def\glssidemark{%
  \@ifnextchar[\@xglssidemark
    {\stepcounter{glsnote}%
    \protected@xdef\@theglssidemark{\theglsnote}%
    \@glssidemark}}
\def\@xglssidemark[#1]{%
  \begingroup
    \c@glsnote #1\relax
      \unrestored@protected@xdef\@theglssidemark{\theglsnote}%
  \endgroup
  \@glssidemark}
\def\@glssidemark{%
  \leavevmode
  \ifhmode\edef\@x@sf{\the\spacefactor}\nobreak\fi%
  \@makeglssidemark%
  \ifhmode\spacefactor\@x@sf\fi%
  \relax}

\newlength{\glsmarginposy}
\newlength{\glsmarginlastposy}
\newlength{\glsmarginposyshift}
\newlength{\glsmarginnoteheight}
\newlength{\glsmarginvoffset}
\newlength{\glsmarginparpush}
\setlength{\glsmarginparpush}{6pt}

%\newcommand*{\@mn@lastcurrpage}{}
%\newcommand*{\textglsmargin}{}

%--- Note: margin notes within a tcolorbox
%-----------------------------------------
%- LaTeX \marginpar(s) are special floats and can't be used within a tcolorbox => \marginnote
%- But a margin note on the same line or spilling on the next one are misplaced (this is a feature
%- and not a bug of the `marginnote' package). A solution with the help of the `zref' bundle
%- is given below (certainly a better way could be found as an extension of the `marginnote'
%- package, but our skills are still too poor to understand all subtilities of some internals).
%- This solution uses the second optional argument of the main command: \marginnote{text}[voffset].
%- With this proposed dirty workaround, one has to take care of margin notes that are displayed
%- at the bottom of a page (there is no automatic adjustment for the moment being).
%- To solve this latter point, may be the following reference could be useful:
%-  https://tex.stackexchange.com/questions/244853/reflowing-marginpars-typeset-using-pdfsavepos
%-----

\NewDocumentCommand{\glssidenote}{O{secondcolor} m}{% Need the `zref-savepos' package module
  {%
    %\ignorespaces%
    \hypersetup{linkcolor=#1}% There is a issue with hyperlinks: wrong page key
    \glssidemark%
  }%
  \renewcommand*{\marginfont}{\footnotesize}%
  \zsaveposy{glsnote:\number\value{glsnote}}%
  \zref@label{glsnotepage:\number\value{glsnote}}%
  %- Applying two \strut before and after (that does the trick), see (original by @egreg):
  %-  https://tex.stackexchange.com/questions/216388/uneven-spacing-between-parbox
  %-  https://tex.stackexchange.com/questions/34971/[...]
  %-    [...]how-to-keep-a-constant-baselineskip-when-using-minipages-or-parboxes
  %- See also the use of \prevdepth:
  %-  https://tex.stackexchange.com/questions/433912/[...]
  %-    [...]marginnote-vertical-alignment-half-length-of-paragraph
  \settototalheight{\glsmarginnoteheight}{%
    \parbox[t]{\marginparwidth}{%
      \normalfont\footnotesize\strut%
      \makebox[1em][l]{\textit{\theglsnote}.}%
      #2\strut% Second \strut = having the depth of the paragraph last line (correct?)
    }%        % If not, we notice a vertical difference for paragraphs with only one line
  }%          % or with several lines
  \setlength{\glsmarginposy}{\zposy{glsnote:\number\value{glsnote}}sp}%
  %\renewcommand*{\marginnotevadjust}{4pt}% if all margin notes are displayed too high
  \ifnum\c@glsnote=1
    \setlength{\glsmarginvoffset}{0pt}%
    \setlength{\glsmarginlastposy}{\glsmarginposy}%
    \setlength{\glsmarginposyshift}{\glsmarginnoteheight+\glsmarginparpush}%
    %\renewcommand*{\@mn@lastcurrpage}{\@mn@currpage}% Current page given by `marginnote' package
    \setcounter{glsmarginnotepage}{\zref@extract{glsnotepage:\number\value{glsnote}}{abspage}}
  \else
    \ifnum\c@glsmarginnotepage<\zref@extract{glsnotepage:\number\value{glsnote}}{abspage}
      %\renewcommand*{\textglsmargin}{newpage}%
      \setlength{\glsmarginvoffset}{0pt}%
      \setlength{\glsmarginlastposy}{\glsmarginposy}%
      \setlength{\glsmarginposyshift}{\glsmarginnoteheight+\glsmarginparpush}%
      \setcounter{glsmarginnotepage}{\zref@extract{glsnotepage:\number\value{glsnote}}{abspage}}
    \else
      \ifdim\glsmarginposy=\glsmarginlastposy% Same line
        %\renewcommand*{\textglsmargin}{equal}%
        \setlength{\glsmarginvoffset}{\glsmarginposyshift}%
        \setlength{\glsmarginlastposy}{\glsmarginlastposy-\glsmarginposyshift}%
        \setlength{\glsmarginposyshift}{\glsmarginnoteheight+\glsmarginparpush}%
      \else
        \ifdimcomp{\glsmarginposy}{>}{\glsmarginlastposy-\glsmarginposyshift}{% `etoolbox' package
          %- Previous margin note spills on the current one
          %\renewcommand*{\textglsmargin}{inf}%
          \setlength{\glsmarginvoffset}{\glsmarginposyshift+\glsmarginposy-\glsmarginlastposy}%
          \setlength{\glsmarginlastposy}{\glsmarginlastposy-\glsmarginposyshift}%
          \setlength{\glsmarginposyshift}{\glsmarginnoteheight+\glsmarginparpush}%
        }{%- Previous margin notes do not interfere with the current one
          %\renewcommand*{\textglsmargin}{sup}%
          \setlength{\glsmarginvoffset}{0pt}%
          \setlength{\glsmarginlastposy}{\glsmarginposy}%
          \setlength{\glsmarginposyshift}{\glsmarginnoteheight+\glsmarginparpush}%
        }%
      \fi
    \fi
  \fi
  % Global lengths to keep their values from one margin note to the next one
  \global\glsmarginposy=\glsmarginposy%
  \global\glsmarginlastposy=\glsmarginlastposy%
  \global\glsmarginposyshift=\glsmarginposyshift%
  \global\glsmarginnoteheight=\glsmarginnoteheight%
  \global\glsmarginvoffset=\glsmarginvoffset%
  \global\glsmarginparpush=\glsmarginparpush%
  \marginnote{%
    \parbox[t]{\marginparwidth}{%
      \normalfont\footnotesize\strut%
      \makebox[1em][l]{\textcolor{#1}{\textit{\theglsnote}.}}% Aligning the margin note label
      %\ignorespaces% ?
      #2\strut%
      %~\textglsmargin~\@mn@currpage~\themn@abspage
      %~\textglsmargin~\theglsmarginnotepage%
    }%
  }[\glsmarginvoffset]%\unskip% ?
}

%- Side glossary graphic for unmumbered figure or illustration (with or without a caption)
\DeclareDocumentCommand{\sideglossarygraphic}{s o m g}{%
  % Syntax − #1 = no star = copyright symbol, star = no copyright symbol
  %          #2 = caption text
  %          #3 = margin contents: an image file included with \includegraphics
  %          #4 = optional copyright/source of the graphic (graphics are different from figures)
  \ifallowglossary@graphic
    \ifallowlocalglossary@graphic
      \glssidegraphic{#3}%
      %\glssideElement*[t]{#3}{correct}%
      %\tcbsideElement{#3}%
      %\caution[t]<secondcolor>{#3}{Graphique}
      %{Put the graphic here!}%
      %\marginpar{Put the graphic here!}%
      %- With marginote there is a horizontal gap:
      %- See: https://tex.stackexchange.com/questions/269426/[...]
      %-        [...]wrong-marginnote-positions-inside-a-tikzpicture-with-xelatex
      %\marginnote{Put the graphic here!}%
    \else
      \IfBooleanTF{#1}{%
        \IfValueTF{#2}{%
          \IfValueTF{#4}{%
            \sidegraphic*[#2]{#3}{#4}%
          }{%
            \sidegraphic*[#2]{#3}%
          }%
        }{%
          \sidegraphic*{#3}%
        }%
      }{%
        \IfValueTF{#2}{%
          \IfValueTF{#4}{%
            \sidegraphic[#2]{#3}{#4}%
          }{%
            \sidegraphic[#2]{#3}%
          }%
        }{%
          \sidegraphic{#3}%
        }%
      }
    %\else
      %\ClassWarning{texjazz-handbook.cls}{Glossary displaying:\MessageBreak
      %The description of this term is associated with a figure in the main glossary}
      %\typeout{TeXjazz handbook:
      %The description of this term is associated with a figure in the main glossary}
    \fi
  \fi
}

%- Defining a shortcut command to display the main glossary (to use with a preceeding \backchapter)
\ifdocglossary@xindy
  \newcommand{\printmainglossary}[1][0pt]{% #1 = adjust vertical space before glossary displaying
    \vspace*{#1}%
    \setcounter{glsnote}{0}%
    \glsresetentrycounter% See `glossaries-extra` doc. p.66
    \setglossarysection{section=section}%
    \glsglossarymark{\glossaryname}%
    \setglossarystyle{jazzhypergroup}% Applied style
    \allowglossary@graphictrue% Allowing margin graphics to be displayed
    \allowlocalglossary@graphicfalse%
    %\glsaddall% consider all entries (not only those cited with \gls and other similar commands)
    % See: https://tex.stackexchange.com/questions/150228/[...]
    %   [...]glossaries-display-the-page-number-but-not-the-current-page/
    \glsaddallunused[main]% consider all entries with location only if used
    % Adjusting the glossary heading: it CAN'T be done in a glossary style
    % Redefining `\glossarysection' command for the main glossary (cf. glossary-code.pdf p.43-44)
    % See also: https://tex.stackexchange.com/questions/446442/[...]
    %  [...]glossaries-acronym-symbols-etc-per-chapter-with-style-super-so-that-descripti?rq=1
    % Because several glossaries are needed and a new `\glossarysection' can't be included in a
    % style, its redefinition is done just before its use
    \renewcommand{\glossarysection}[2][]{\vspace*{-1.5\baselineskip}}% Adjusting the vertical space
    \printglossary[%
      type=main,% Default main glossary explicitly settled
      %title={\vspace*{#1}}% No title printed but compensate too much vertical space
      %title={}% Not printed title
    ]%
  }%
  %\pretocmd{\printmainglossary}{% Modifying the sidenote label for the main glossary (alphabetic)
  %  \renewcommand*{\thefootnote}{\alph{footnote}}%
  %}{}{}
\else% TODO: setting the correct macros and commands for building the glossaries with `bib2gls'
%  \newcommand{\printmainglossary}{%
    %- The sectional unit for partial glossaries MUST BE SET BEFORE \GlsXtrLoadResources
    %- The following command needs `glossaries-extra' package and `record=only/alsoindex' options
    %\GlsXtrRecordCounter{section}
    %\GlsXtrRecordCounter{subsection}
%    \printunsrtglossary[%
%      type=main,% Default main glossary explicitly settled
      %title={\vspace*{-3\baselineskip}}]% not printed title but let too much vertical space
%  }%
\fi

%- Adjusting the glossary heading: it CAN'T be done in a glossary style
%- Redefining the `\glossarysection' command for the main glossary (cf. glossary-code.pdf p.43-44)
%- See also: https://tex.stackexchange.com/questions/446442/[...]
%-   [...]glossaries-acronym-symbols-etc-per-chapter-with-style-super-so-that-descripti?rq=1
%- Because several glossaries are needed and a new `\glossarysection' can't be included in a style,
%- its redefinition is done just before its use by mean of the `\pretocmd' from `etoolbox' package
%\pretocmd{\printmainglossary}{%
%  \renewcommand{\glossarysection}[2][]{}% No section heading for the main glossary
%}{}{}%


%-- Local and/or per chapter, section, subsection glossaries
%-----------------------------------------------------------

%--- Note about local glossaries
%- Well, if you want to "play" with the `glossaries` bundle, you have to be aware that many internal
%- command sequences and macros use the `etoolbox' package. By the way, may be some TeX.SX links
%- can be useful to understand what's happen.
%- For the `glossaries` bundle using:
%-   https://tex.stackexchange.com/questions/89107/glossary-per-chapter-or-section
%-   https://tex.stackexchange.com/questions/446442/
%-   https://tex.stackexchange.com/questions/325434/glossary-per-chapter-not-by-section
%-   https://tex.stackexchange.com/questions/296202/list-of-letter-not-folding-in-glossaries
%-   https://tex.stackexchange.com/questions/99142/customising-glossary-group-titles
%-   https://tex.stackexchange.com/questions/440324/
%-   https://tex.stackexchange.com/questions/474791/
%-   https://tex.stackexchange.com/questions/150228/
%-   https://tex.stackexchange.com/questions/217478/glossary-entries-for-multiple-glossaries
%-   https://tex.stackexchange.com/questions/498166
%-   https://tex.stackexchange.com/questions/384022
%-   https://tex.stackexchange.com/questions/190966/issue-with-glossaries-and-hierarchal-categories
%- For more in deep and fundamental TeX understanding:
%-   https://tex.stackexchange.com/questions/471625/nameuse-as-conditional
%-   https://tex.stackexchange.com/questions/321868/concatenate-macro-string-and-counter
%-   https://tex.stackexchange.com/questions/315365/using-counter-in-csdef
%-   https://tex.stackexchange.com/questions/353900/
%-   https://tex.stackexchange.com/questions/377581/less-than-string-comparison-like-ifstrequal
%-   https://tex.stackexchange.com/questions/478835/how-to-compare-a-string-to-a-cs-from-a-read-properly
%-----

\newcommand\glstwodigits[1]{%
  \ifnum#1<10 0#1\else #1\fi
}

%- Local or contextual glossary name
\ifdoc@english
  \newcommand{\localglossarytitle}{Contextual glossary}
\else
  \newcommand{\localglossarytitle}{Glossaire contextuel}
\fi

%- Adding a new storage key that can be used to indicate a local glossary (like the category field)
%- The default local glossary is local. See the `glossaries-extra` code p. 178
\glsaddstoragekey{localglossary}{local}{\glslocalglossary}

%- Convenient shortcut to determine if an entry belongs to the given local glossary
\newcommand{\ifglslocalglossary}[4]{%
  \ifglsfielddefeq{#1}{localglossary}{#2}{#3}{#4}%
}

%- Defining a systematic prefix for local glossaries label
\newcommand{\localglossaryprefix}{local-}

%- Standalone local glossary − TODO: verify the relevance of that command sequence!!!
%- This seems to be not needed for our purpose...
%\newcommand{\GlsXtrStandaloneGlossaryType}{\glsentrytype{\glscurrententrylabel}}
%\renewcommand{\GlsXtrStandaloneGlossaryType}{% See `glossaries-extra` doc. p. 76
%  standalone.\thelocalglossary.\arabic{glossaryentry}%
%}

%- Defining a new glossary style for local glossaries
\newglossarystyle{jazzlocalglossary}{% Based on the simple `list' style (cf. glossaries-code.pdf)
  \setglossarystyle{list}%
  \renewcommand*{\glossaryheader}{}
  \renewcommand*{\glsgroupheading}[1]{}%
  \renewcommand*{\glsgroupskip}{\ifglsnogroupskip\else\fi}% No vertical space between groups
}

%- Defining a shortcut command to display the local glossaries
\newcommand{\printlocalglossarybasic}[1][0pt]{% #1 = adjust vertical space before the glossary display
  \vspace*{#1}%
  \glsresetentrycounter% See `glossaries-extra` doc. p.66
  \stepcounter{localglossary}% Used to set the local glossary field label
  \edef\tmplocalglossaryname{\localglossaryprefix\number\value{localglossary}}%
  \setglossarystyle{jazzlocalglossary}% Applied style
  \allowglossary@graphictrue% Allowing margin graphics to be displayed
  %\allowlocalglossary@graphictrue
  \allowlocalglossary@graphicfalse
  %- The following gives a error with `xkeyval` package and 'target' option, it works without it
  %- For further details, see the `glossaries-extra` package documentation p.68, p.69 and p.70
  %\printunsrtglossary*[target=false, title={\vspace*{-\baselineskip}}]{%
  \printunsrtglossary*[title={\vspace*{-\baselineskip}}]{%
    \renewcommand{\printunsrtglossaryentryprocesshook}[1]{% See `glossaries-extra` doc. p. 69, 70
      \ifglslocalglossary{##1}{\tmplocalglossaryname}{}{\printunsrtglossaryskipentry}%
      %\ifglsfielddefeq{##1}{localglossary}{\tmplocalglossaryname}{}{\printunsrtglossaryskipentry}%
    }%
  }%
  \allowlocalglossary@graphicfalse
  \allowglossary@graphicfalse% Reset to "False" inclusion of graphics in glossaries
}%

%- See: https://tex.stackexchange.com/questions/494574/todo-notes-inside-tcolorbox
%\newsavebox{\glsgraphicbox}
%\newcommand{\glsmargingraphic}[2][inMargin]{%
%  \marginpar{%
%    \savebox\glsgraphicbox{\todo[inline]{#2}}% measure height
%    \begin{tikzpicture}[remember picture, overlay]
%      \coordinate (#1) at (0pt,0.5\ht\glsgraphicbox);
%    \end{tikzpicture}%
%    \usebox\glsgraphicbox%
%  }%
%}
%\newcommand{\glsmarginmark}{%
%  \begin{tikzpicture}[remember picture, overlay]
%    \draw[orange,thick] (#1) -- ++(-0.5\marginparsep,0) |- (0pt,\lineskip-\dp\strutbox);
%  \end{tikzpicture}
%}

%- Trying to display margin elements within a tcolorbox gives errors (floats or outer...)
%- A first step to solve this issue is to consider G. Medina answer (OK for title environment icon):
%- https://tex.stackexchange.com/questions/214303/framed-environment-with-fixed-image-in-marginpar
%- A second step is to consider J. Kormylo answer (with the `tikzmark/`todonote` packages):
%- https://tex.stackexchange.com/questions/494574/todo-notes-inside-tcolorbox
%- A third one is to use the `tikzmark` approach as decribed for \caution or \sideElement commands
\newtcolorbox{displaylocalglossary}[1][]{% optional arg = more options list
  breakable,
  enhanced jigsaw,
  check odd page,
  width=\linewidth,
  %parbox=false,
  colframe=firstcolor,
  colback=gray!20,
  arc = 0pt, outer arc = 0pt,
  boxrule = 0pt,
  %leftrule = 2pt, rightrule = 2pt,
  %toprule=0pt, bottomrule = 0pt,
  boxsep = 2pt,% default=1mm
  toptitle=4pt, bottomtitle=2pt,% additional to boxsep, default=0mm
  lefttitle = 4pt, righttitle = 4pt,% additional to boxsep, default=4mm
  %title=\spacedsmallcaps{\strut\lightbf{\localglossarytitle}~\hrulefill},
  title={\strut\textsc{\boxtitlefont\localglossarytitle~\hrulefill}},
  top = 0pt, bottom = 2pt,% additional to boxsep, default=2mm
  left = 4pt, right = 4pt,% additional to boxsep, default=4mm
  before skip=10pt,
  after skip=2pt,
  %overlay={% There is a bug: the title "logo/picture" is sometimes displayed twice! WHY?
  %  \checkoddpage
  %  \ifoddpageoroneside
  %  %\ifoddpage
  %    %- Original
  %    %\node[overlay,anchor=west] at ([xshift=\marginparsep]title.east) {\LARGE\faBook};
  %    %- Modified
  %    \node[overlay,anchor=west] at ([xshift=2.0pt]title.east)
  %      {\textcolor{secondcolor}{\Large\faBook}};
  %  \else
  %    %- Original
  %    %\node[overlay,anchor=east] at ([xshift=-\marginparsep]title.west) {\LARGE\faBook};
  %    %- Modified
  %    \node[overlay,anchor=east] at ([xshift=-2.0pt]title.west)
  %      {\textcolor{secondcolor}{\Large\faBook}};
  %  \fi
  %},
  #1,
}

%- If a margin element is called from a tcolorbox, one has to take care about the fact that the
%- `tcolorbox` package redefines \textwidth and \linewidth to be shorter. So, it leads to have
%- a gap for elements displayed outside the tcolorbox, and must be corrected. This is the case here
%- for the displaying of local glossaries. The solution is one more time given by G. Medina, see:
%-   https://tex.stackexchange.com/questions/257731/[...]
%-     [...]tikz-node-in-margin-right-to-other-node-interacts-with-tcbtheorem
\BeforeBeginEnvironment{displaylocalglossary}{% Setting the node name to be correct inside a tcbox
  \vspace*{-\baselineskip}% Needed to avoid spurious vertical space: WHY? TODO: FIND THE REASON!
  \tikz[remember picture,overlay]
    \node[fit=(current page text area),
          line width=0, inner sep=0,
          name=correct current page text area]{};%
  \renewcommand*{\glssidenodename}{correct current page text area}%
}

\AfterEndEnvironment{displaylocalglossary}{% Resetting the node name to default
  \renewcommand*{\glssidenodename}{current page text area}%
}

%- Defining a shortcut command to print the local glossaries with a tcolorbox
%\newcommand{\printlocalglossary}[1][0pt]{% #1 = adjust vertical space before the glossary display
\NewDocumentCommand{\printlocalglossaryold}{O{0pt} g}{% #1 = adjust vertical space before the glossary display
%\NewDocumentCommand{\printlocalglossary}{s O{0pt}}{%
%\NewDocumentCommand{\printlocalglossary}{O{0pt}}{%
  \vspace*{#1}%
  %\setcounter{footnote}{0}%
  %\IfBooleanT{#1}{\allowglossary@graphictrue}%
  %\IfValueT{#2}{\vspace*{#2}}%
  \glsresetentrycounter% See `glossaries-extra` doc. p.66
  \IfNoValueTF{#2}{
    \stepcounter{localglossary}% Used to set the local glossary field label
  }{%
    \setcounter{localglossary}{#2}% Set the wanted local glossary field label: just a integer
  }
  \edef\tmplocalglossaryname{\localglossaryprefix\number\value{localglossary}}%
  \setglossarystyle{jazzlocalglossary}% Applied style
  \allowglossary@graphictrue% Allowing margin graphics to be displayed
  \allowlocalglossary@graphictrue
  \begin{displaylocalglossary}
    %- The following gives a error with `xkeyval` package and 'target' option, it works without it
    %- For further details, see the `glossaries-extra` package documentation p.68, p.69 and p.70
    %\printunsrtglossary*[target=false, title={\vspace*{-\baselineskip}}]{%
    \printunsrtglossary*[title={\vspace*{-\baselineskip}}]{%
      \renewcommand{\printunsrtglossaryentryprocesshook}[1]{% See `glossaries-extra` doc. p. 69, 70
        \ifglslocalglossary{##1}{\tmplocalglossaryname}{}{\printunsrtglossaryskipentry}%
        %\ifglsfielddefeq{##1}{localglossary}{\tmplocalglossaryname}{}{\printunsrtglossaryskipentry}%
      }%
    }%
  \end{displaylocalglossary}%
  \allowlocalglossary@graphicfalse
  \allowglossary@graphicfalse% Reset to "False" inclusion of graphics in glossaries
}%

\NewDocumentCommand{\printlocalglossary}{O{0pt} g}{% #1 = adjust vertical space before the glossary display
  \vspace{#1}%
  %\setcounter{footnote}{0}%
  %\IfBooleanT{#1}{\allowglossary@graphictrue}%
  %\IfValueT{#2}{\vspace*{#2}}%
  \glsresetentrycounter% See `glossaries-extra` doc. p.66
  \IfNoValueTF{#2}{
    \stepcounter{localglossary}% Used to set the local glossary field label
  }{%
    \setcounter{localglossary}{#2}% Set the wanted local glossary field label: just a integer
  }
  \edef\tmplocalglossaryname{\localglossaryprefix\number\value{localglossary}}%
  \edef\glslocalname{local\glstwodigits{\number\value{localglossary}}}%
  \setglossarystyle{jazzlocalglossary}% Applied style
  \allowglossary@graphictrue% Allowing margin graphics to be displayed
  \allowlocalglossary@graphictrue
  \begin{displaylocalglossary}
    %- The following gives a error with `xkeyval` package and 'target' option, it works without it
    %- For further details, see the `glossaries-extra` package documentation p.68, p.69 and p.70
    %\printunsrtglossary*[target=false, title={\vspace*{-\baselineskip}}]{%
    %\printunsrtglossary*[title={\vspace*{-\baselineskip}}]{%
    %  \renewcommand{\printunsrtglossaryentryprocesshook}[1]{% See `glossaries-extra` doc. p. 69, 70
    %    \ifglslocalglossary{##1}{\tmplocalglossaryname}{}{\printunsrtglossaryskipentry}%
    %    %\ifglsfielddefeq{##1}{localglossary}{\tmplocalglossaryname}{}{\printunsrtglossaryskipentry}%
    %  }%
    %}%
    \printunsrtglossary[type=\glslocalname,title={\vspace*{-\baselineskip}}]%
  \end{displaylocalglossary}%
  \allowlocalglossary@graphicfalse
  \allowglossary@graphicfalse% Reset to "False" inclusion of graphics in glossaries
}%





%- For index or multiple indices, see:
%-  http://geekographie.maieul.net/172
%-  https://ctan.org/tex-archive/macros/latex/contrib/imakeidx (Enrico Gregorio)
%-  https://ctan.org/pkg/indextools (Maïeul Rouquette fork from Enrico Gregorio's work)











%---------------------------------------------------------------------------------------------------
%---- List of used packages and classes
%---------------------------------------------------------------------------------------------------

%- Stolen solution to Enrico Gregorio's proposal (we don't understand at all this LaTeX3 syntax
%- for the moment being, but it works fine!):
%-   http://tex.stackexchange.com/questions/265726/embed-nicely-formatted-listfiles-into-document
%-   http://tex.stackexchange.com/questions/75055/print-filelist-to-pdf
%- For table rows numbering see:
%-   https://tex.stackexchange.com/questions/21243/automatic-table-row-numbers
%- For centering longtable see:
%-   https://tex.stackexchange.com/questions/261221/centering-longtable

%\RequirePackage[noshowpages]{dateiliste}% It works fine, but to be hacked... (in German!)
%\RequirePackage[noshowpages]{texjazz-listfiles}%

\ifdoc@printfiles% Activating the option if it is settled
  \listfiles% initialize
  \AtEndDocument{\printfilelist}
  %\AtEndDocument{\mtlistfiles}
\fi

%--
\newcounter{rownumber}
\setcounter{rownumber}{0}
\newcommand\listtwodigits[1]{%
  \ifnum#1<10 0#1\else #1\fi
}
\newcommand{\listnumber}{\stepcounter{rownumber}\ttfamily\listtwodigits{\therownumber}.}
\ExplSyntaxOn
\NewDocumentCommand{\printfilelist}{}% Take care to the `animate' package description with ampersand
 {
  \cleardoublepage\symmetricalpage\pagestyle{empty}
  \noindent\textsc{\titlingspacedfont Liste\ des\ extensions\ \LaTeX\ utilisées}\par%
  %\setlength{\LTleft}{\parindent}% see longtable documentation
  \setlength{\LTleft}{0pt}% see longtable documentation
  \renewcommand{\arraystretch}{1.2}\scriptsize%\Centering
  %\rowcolors{2}{tableLineOne}{tableLineTwo}
  %\begin{longtable}{@{} >{\ttfamily}l l >{\raggedright}p{.6\textwidth} @{}}
  %\begin{longtable}{@{\listnumber\space\textemdash\space} >{\ttfamily}l l >{\raggedright}p{.6\textwidth} @{}}
  \begin{longtable}[c]{@{\makebox[3em][r]{\listnumber\space}} >{\ttfamily}l l >{\raggedright}p{.6\textwidth} @{}}
  %\keepXColumns
  %\begin{tabularx}{\linewidth}[c]%
    {@{\makebox[3em][r]{\listnumber\space}} >{\ttfamily}l l X @{}}
    \toprule
    %\rowcolor{firstcolor}
    %\multicolumn{1}{@{}l}{\lightbf{File\ name}} &
    %\multicolumn{1}{@{\makebox[3em][c]{\lightbf{N\up{o}}~}}l}{\lightbf{File\ name}} &
    \multicolumn{1}{@{\makebox[3em][c]{~~}}l}{\lightbf{File\ name}} &
    \multicolumn{1}{c}{\lightbf{Date}} &
    \lightbf{File\ info / Description}
    \tabularnewline
    \midrule
    \endhead
    \bottomrule
    \endfoot
    \jazz_print_filelist:% egreg solution with l3regex
  %\end{tabularx}
  \end{longtable}
 }

\tl_new:N \l_jazz_filelist_body_tl
\tl_new:N \l_jazz_fileinfo_tl

\cs_new_protected:Npn \jazz_print_filelist:
 {
  \clist_map_inline:cn { @filelist }
   {
    \jazz_print_fileinfo:n { ##1 }
   }
  \tl_use:N \l_jazz_filelist_body_tl
 }

\cs_new_protected:Npn \jazz_print_fileinfo:n #1
 {
  \regex_match:nnT { \.(sty|cls)\Z } { #1 }
   {
    \jazz_print_pkginfo:n { #1 }
   }
 }

\cs_new_protected:Npn \jazz_print_pkginfo:n #1
 {
  \tl_set_eq:Nc \l_jazz_fileinfo_tl { ver@#1 }
  \tl_replace_once:Nnn \l_jazz_fileinfo_tl { ~ } { & }
  \tl_put_right:Nx \l_jazz_filelist_body_tl
   {
    \exp_not:n { #1 }
    &
    \exp_not:V \l_jazz_fileinfo_tl
    \exp_not:N \tabularnewline
   }
 }
\ExplSyntaxOff

%- Old fashion I
\newlength\mtl
\newcommand{\mtlistfiles}{%
  \par\noindent\scriptsize
  %%-- for measuring
  \@for\@currname:=\@filelist\do{%
  \setbox0=\hbox{\@currname}%
  \ifdim\wd0>\mtl\relax\mtl=\wd0\fi}%
  %%-- formating list
  \@for\@currname:=\@filelist\do{%
  \makebox[\mtl][l]{\@currname}
     \expandafter\ifx\csname ver@\@currname\endcsname\relax
     \else\@spaces\csname ver@\@currname\endcsname\fi
     \par\noindent}%
}

%- Old fashion II
\def\mylistoffilesused{%
  \scriptsize
  \begingroup
  \ttfamily%
  \par*File List* \par
  \@for\@currname:=\@filelist\do{%
    \filename@parse\@currname
    \edef\reserved@a{%
      \filename@base.%
      \ifx\filename@ext\relax tex\else\filename@ext\fi}
        \expandafter\let\expandafter\reserved@b
                              \csname ver@\reserved@a\endcsname
       \expandafter\expandafter\expandafter\@listfiles\expandafter
             \filename@area\filename@base\\\\\\\\\\\\\\\\\\\@@
       \filename@area\reserved@a
         \ifx\reserved@b\relax\else\@spaces\reserved@b\fi\par}
     ***********\par
  \endgroup%
}




%---------------------------------------------------------------------------------------------------
%%%%%
\endinput
%%%%%
%% End of file `texjazz-handbook.cls'.
