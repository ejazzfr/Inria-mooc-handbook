%%
%% texjazz-handbook.cls
%%
%% A LaTeX class to typeset French/English handbook/workbook.
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
% This work consists of the main file of the `TeXjazz' bundle: `texjazz-handbook.cls'
%
% Its companion packages are: 
%   − textjazz-askreply.sty for exercise and quiz layout
%   − textjazz-assignpoints.sty for points within exercises and quizzes
%   − textjazz-forest.sty based on the `forest' package for tree directories and icons
%   − textjazz-modelling.sty for UML and Merise diagrams
%   − textjazz-piechart.sty which extends a little bit `the pgf-pie.sty' package
%   − xfontawesome.sty witch extends `fontawesome' with some glyphs from `fontmfizz'
%
% Its companion internal files are (the names are self-explanatory):
%   − textjazz-bibliograpy.def
%   − textjazz-bookmark.def
%   − textjazz-caption.def
%   − textjazz-coding.def
%   − textjazz-color.def
%   − textjazz-common.def
%   − textjazz-entry.def
%   − textjazz-glossary.def
%   − textjazz-graphic.def
%   − textjazz-head-foot.def
%   − textjazz-highlight.def
%   − textjazz-listings.def
%   − textjazz-ltxlistings.def
%   − textjazz-margin.def
%   − textjazz-modelling.def
%   − textjazz-reference.def
%   − textjazz-shell.def
%   − textjazz-tabular.def
%   − textjazz-titlepage.def
%   − textjazz-titling.def
%   − textjazz-toclof.def
%   − textjazz-typograhy.def
%
% Its companion file for Pygments Python module (`minted' and `PythonTeX' packages) is:
%   − jazzcode.py which must be copied in the Pygments styles directory. For Linux box:
%     /lib/python3/dist-packages/pygments/styles/.
%
% A few ideas have been borrowed to and originally inspired by Yves Zumbach's YLaTeX bundle (2015)
% − now maintained by Harvey Sheppard (2017+) on GitHub: https://github.com/HarveySheppard/yLaTeX/
% For distribution reasons, some packages have been rewritten and partly integrated in this class.
%---------------------------------------------------------------------------------------------------
% PLEASE TAKE CARE! NO WARRANTY IS GIVEN, USE IT AND BORROW WHATEVER YOU WANT BUT DO NOT DISTRIBUTE 
% THIS CLASS FOR THE MOMENT BEING.
%-  Although the code snippets which have been borrowed are mainly under the LPPL license − LaTeX
%   Project Public License −, the licenses dues have not yet been fine verified.
%   Moreother, please consider that this class and associated files/packages are still
%   *experimental* and may certainly have side effects and be buggy (this is the case of.
%   the `workbook` option) Use it for personal needs: (re)compilation of a document or inspiration
%   for some commands. A amazing amount of things has been resolved thanks to the
%   mutual aid Web site TeX.SX: https://tex.stackexchange.com/
%
% Known bugs:
%    * Overfull\hbox (0.4pt too wide) with \part or \partoclayout or whatever sectionning command
%      --> Comming from the `geometry' package and `showframe' option. Final documents are fine.
%    * "list of figure" order may contain mistakes for `marginfigure' and `sidefigure'.
%    * Make the hyperanchor at the begining of the figure environment and not at the caption command
%      when only using \captionsetup + \caption (because the caption is *after* the display).
%      See how Heiko Oberdiek solves this for standard figure environment. We don't need this
%      feature for captions *before* the environment (see "table", "code" or "listing").
%    * List environments (itemize, enumerate) have indentation issues within exercise/solution
%      environment: see `texjazz-askreply' package.
%    * \nameref and part counter do not work together: bug with `titlesec` package? (solved)
%    * Criptic warning from `titletoc' package: "Unknown TOC type... level -1000" HUMMM...
%    * Sometimes, the vertical space before a subsubsection is zero! A \newline must be added. WHY?
%    * `idleconsole' environment leads to vertical space when used before a sectionning command.
%      One has to manually add a small \vspace (like 1pt) to circumvent the issue. Very strange...
%    * Quiz question title does not support \texttt{} nor \ttfamily.
%    * The 'reset' quiz command does not work if there is a page break (see A. Grahn LaTeX3 code)
%
% Author: ejazz <ejazz.fr@gmail.com>
%---------------------------------------------------------------------------------------------------

%---------------------------------------------------------------------------------------------------
%---- Class identification
%---------------------------------------------------------------------------------------------------

\ProvidesClass{texjazz-handbook}[2021/02/12 v0.1h − Typesetting French/English handbook/workbook]
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
    {LuaLaTeX is required by the TeXjazz bundle:\MessageBreak
     you *must* change your typesetting engine}
\fi

%-- Compilation note
%- To compile a document with this class, one has to allow shell-escape (write18) option, i. e.:
%- /opt/texlive/2020/bin/x86_64-linux/[...]
%-    [...]lualatex -shell-escape -synctex=1 -interaction=nonstopmode <filename.tex>


%---------------------------------------------------------------------------------------------------
%---- (La)TeX programming utilities and basic class options
%---------------------------------------------------------------------------------------------------

%-- Programming utilities
%------------------------

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
     Please run LuaLaTeX with the unrestricted shell escape option}
  \or
  %- 1: Unrestricted shell escape is enabled
  %\message{\string`\jobname.tex' Shell escape is enabled.}
  \ClassInfo{texjazz-handbook}%
    {Unrestricted shell escape is enabled.\MessageBreak
     Fine, let's make the job}
  \or
  %- 1: Restricted shell escape is enabled
  %\message{Restricted shell escape is enabled.}
  \ClassWarningNoLine{texjazz-handbook}%
    {Restricted shell escape is enabled.\MessageBreak
     Please run LuaLaTeX with the unrestricted option}
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
  % To be continued... But how? We don't know Windows commands. Is the following correct?
  \jazzcaptureshell*[\dirstatus]{IF exist PythonTeX (echo Existing) ELSE (echo Missing)}
  \ifdefstring{\dirstatus}{Existing}%
    {\typeout{*** \string`\jobname.tex' *** Directory `PythonTeX' already exists.}}%
    {\ShellEscape{mkdir PythonTeX}
      \typeout{*** \string`\jobname.tex' *** Directory `PythonTeX' has been created.}}
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
\DeclareExpandableDocumentCommand{\IfNoValueOrEmptyTF}{ m m m }%
  {\IfNoValueTF{#1}{#2}{\tl_if_empty:nTF {#1} {#2} {#3}}}
\ExplSyntaxOff


%-- Options (prospectives TODO → key-value system − PGFOpts/PGFkeys? With a \jazzsetup?)
%---------------------------------------------------------------------------------------

\newbool{doc@appendix}
\newbool{doc@article}
\newbool{doc@askreply}
\newbool{doc@assignpoints}
\newbool{doc@embedding}
\newbool{doc@english}
\newbool{doc@glossnowarn}
\newbool{doc@license}
\newbool{doc@modelling}
\newbool{doc@printfiles}
\newbool{doc@showframe}

%- Document type: workbook or handbook
%- See: https://tex.stackexchange.com/questions/36274/[...]
%-         [...]defining-a-wrapper-class-for-a-set-of-document-classes
\DeclareOption{workbook}{
  \booltrue{doc@article}
  \def\jazz@class{article}
}
\DeclareOption{handbook}{
  \boolfalse{doc@article}
  \def\jazz@class{book}
}

%- Language: French or English
\DeclareOption{english}{
  \booltrue{doc@english}
}

%- Document license
\DeclareOption{license}{
  \booltrue{doc@license}
}

%- Layout: invisible or visible
\DeclareOption{showframe}{
  \booltrue{doc@showframe}
}

%- Displaying or not the used packages (at end of document)
\DeclareOption{printfiles}{
  \booltrue{doc@printfiles}
}

%- Modelling tools: UML, Merise, etc.
\DeclareOption{modelling}{
  \booltrue{doc@modelling}
}

%- Embedding files into the PDF: references (.bib), sources (.tex) or images, etc.
\DeclareOption{embedding}{
  \booltrue{doc@embedding}
}

%- Suppressing glossaries package warning for final version (too much warnings to deal with...)
\DeclareOption{glossnowarn}{
  \booltrue{doc@glossnowarn}% DOES NOT WORK! FIX ME
}

%-- Derived from the `article' (workbook) or `book' (hanbook) classes
%--------------------------------------------------------------------

%- See: https://tex.stackexchange.com/questions/36274/defining-a-wrapper-class-for-a-set-of-document-classes
\ifbool{doc@article}{%
  \DeclareOption*{\PassOptionsToClass{\CurrentOption}{\jazz@class}}
  %\ExecuteOptions{a4paper,10pt}
  \ExecuteOptions{workbook,a4paper,twoside}
  \ProcessOptions\relax
  %\LoadClass{article}
  %\LoadClass[a4paper,9pt,twoside]{\jazz@class}
  \LoadClass{\jazz@class}
}{\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\jazz@class}}
  \ExecuteOptions{handbook,a4paper,twoside,openright}
  \ProcessOptions\relax
  %\LoadClass{book}
  \LoadClass{\jazz@class}
}

%-- Tools and facilities
%-----------------------

%- Getting box size
%\RequirePackage{settobox}

%-- Reserving space to keep material from being split over a page break
%\RequirePackage{needspace}


%---------------------------------------------------------------------------------------------------
%---- Referencing of the document / Référencement du document
%---------------------------------------------------------------------------------------------------

\InputIfFileExists{texjazz-reference.def}%
  {\typeout{*** The texjazz-reference.def file has been loaded successfully ***}}%
  {\ClassError{texjazz-handbook}{*** The TeXjazz reference file is required ***}}

%---------------------------------------------------------------------------------------------------
%---- Loading the "zref" referencing system to be used by all positionning and graphical elements
%---------------------------------------------------------------------------------------------------

\RequirePackage{zref-savepos}
\RequirePackage{zref-user}
\RequirePackage{zref-abspage}

%---------------------------------------------------------------------------------------------------
%---- Use of colors / Utilisation des couleurs
%---------------------------------------------------------------------------------------------------

\InputIfFileExists{texjazz-color.def}%
  {\typeout{*** The texjazz-color.def file has been loaded successfully ***}}%
  {\ClassError{texjazz-handbook}{*** The TeXjazz color file is required ***}}


%---------------------------------------------------------------------------------------------------
%---- Typography settings / Paramétrage des éléments typographiques
%---------------------------------------------------------------------------------------------------

\InputIfFileExists{texjazz-typography.def}%
  {\typeout{*** The texjazz-typography.def file has been loaded successfully ***}}%
  {\ClassError{texjazz-handbook}{*** The TeXjazz typography file is required ***}}

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

%---------------------------------------------------------------------------------------------------
%---- Counter management
%---------------------------------------------------------------------------------------------------

\RequirePackage[figure,table,xspace]{totalcount}% Count figures, tables and others...

\RequirePackage{totcount}% Count total value of counters (not only printing but also internal value)

%---------------------------------------------------------------------------------------------------
%---- Document layout and common structure / Agencement et structure générale du document
%---------------------------------------------------------------------------------------------------

\InputIfFileExists{texjazz-common.def}% Must be loaded *before* texjazz-graphic/fullwidth: WHY?
  {\typeout{*** The texjazz-common.def file has been loaded successfully ***}}%
  {\ClassError{texjazz-handbook}{*** The TeXjazz common file is required ***}}

%- Saving some useful lengths
\newlength{\wholemargin}
\setlength{\wholemargin}{\marginparwidth}
\addtolength{\wholemargin}{\marginparsep}
\newlength{\entirewidth}
\setlength{\entirewidth}{\textwidth}
\addtolength{\entirewidth}{\wholemargin}

%---------------------------------------------------------------------------------------------------
%---- Graphic tools
%---------------------------------------------------------------------------------------------------

\InputIfFileExists{texjazz-graphic.def}%
  {\typeout{*** The texjazz-graphic.def file has been loaded successfully ***}}%
  {\ClassError{texjazz-handbook}{*** The TeXjazz graphic file is required ***}}

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

%---------------------------------------------------------------------------------------------------
%----  Margin elements
%---------------------------------------------------------------------------------------------------

%\PassOptionsToPackage{noparboxrestore}{marginnote}
%\RequirePackage{marginnote}% Loaded by the `texjazz-margin` package/file

%- Arranges marginpars "intelligently" / Automatically adjust the side material nicely
%\RequirePackage{marginfix}% Loaded by the `texjazz-margin` package/file

%- LaTex3 implementation of sidenotes, for compatibility (clashes because we use same names)
%\RequirePackage{sidenotes}% TODO: harmonizing sidenote and snotez packages in texjazz-sidenotes


%-- Side note command definition (\sidenote) borrowed to Clemens Niederberger `snotez` package
%---------------------------------------------------------------------------------------------

%- `snotez' package is not compatible with `sidenotes' package,
%- but some features seem very interesting to study and may be implemented
%\RequirePackage{texjazz-sidenotes}
%\RequirePackage{snotez}% Take care: defines \sidefigure and \sidetable
%\setsidenotes{perpage=false}
%\RequirePackage{texjazz-sidenotes}% Take care: defines \sidefigure and \sidetable (commented)


%-- Margin commands and environments definition
%----------------------------------------------

\InputIfFileExists{texjazz-margin.def}% Now including side notes
  {\typeout{*** The texjazz-margin.def file has been loaded successfully ***}}%
  {\ClassError{texjazz-handbook}{*** The TeXjazz margin file is required ***}}

%---------------------------------------------------------------------------------------------------
%----    Highlighting / End-users highlighted commands and environments
%---------------------------------------------------------------------------------------------------

\InputIfFileExists{texjazz-highlight.def}%
  {\typeout{*** The texjazz-highlight.def file has been loaded successfully ***}}%
  {\ClassError{texjazz-handbook}{*** The TeXjazz highlight file is required ***}}

%---------------------------------------------------------------------------------------------------
%---- Caption management / Gestion des légendes des environnements `figure', `table' et autres...
%---------------------------------------------------------------------------------------------------

%-- Gestion des légendes de flottants
%------------------------------------

\InputIfFileExists{texjazz-caption.def}% To be loaded *after* french-babel (here texjazz-common)
  {\typeout{*** The texjazz-caption.def file has been loaded successfully ***}}%
  {\ClassError{texjazz-handbook}{*** The TeXjazz caption file is required ***}}

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
  \vspace{.5\baselineskip}%
}
\AtEndEnvironment{figure}{%
  \vspace{.5\baselineskip plus 1pt minus 1pt}%
}
\AtBeginEnvironment{table}{%
  \vspace{.5\baselineskip plus 1pt minus 1pt}%
}
\AtEndEnvironment{table}{%
  \vspace{.5\baselineskip}%
}
\AtBeginEnvironment{graphic}{%
  \vspace{.5\baselineskip plus 1pt minus 1pt}%
}
\AtEndEnvironment{graphic}{%
  \vspace{.5\baselineskip}%
}
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
  \vspace{.5\baselineskip plus 1pt minus 1pt}%
}
%\AtEndEnvironment{video}{%
%  \vspace{\baselineskip}%
%}
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

%---------------------------------------------------------------------------------------------------
%---- Elegant and fancy tables
%---------------------------------------------------------------------------------------------------

\InputIfFileExists{texjazz-tabular.def}%
  {\typeout{*** The texjazz-tabular.def file has been loaded successfully ***}}%
  {\ClassError{texjazz-handbook}{*** The TeXjazz tabular file is required ***}}

%--------------------------------------------------------------------------------------------------
%---- Footnotes and parnotes management / Gestion des notes de bas de page et de paragraphe
%--------------------------------------------------------------------------------------------------

%\RequirePackage{fnpct}% Compatible with snotez not with sidenotes package

\renewcommand{\thefootnote}{\alph{footnote}}% footnotes a, b, c... (sidenote 1, 2, 3...)

%-- Ligne séparatrice de footnotes aux couleurs du document

\newbool{footnote@rule}
\booltrue{footnote@rule}

\renewcommand\footnoterule{% Redefining from book.cls
  \ifbool{footnote@rule}{%
    \kern-3\p@
    {\color{firstcolor}\hrule\@width.3333\columnwidth}% Default thickness=0.4pt
    \kern2\p@
  }{% https://tex.stackexchange.com/questions/312793/toggle-presence-of-footnote-rule
    \advance\skip\footins 4\p@\@plus2\p@\relax%
  }%
}
\interfootnotelinepenalty=10000% pour éviter l'extension des footnotes sur plusieurs pages

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

%--------------------------------------------------------------------------------------------------
%---- Itemize, enumerate, description and other lists
%--------------------------------------------------------------------------------------------------

\InputIfFileExists{texjazz-list.def}%
  {\typeout{*** The texjazz-list.def file has been loaded successfully ***}}%
  {\ClassError{texjazz-handbook}{*** The TeXjazz list file is required ***}}

%---------------------------------------------------------------------------------------------------
%---- Code listings  / Listings de code de programmation
%---------------------------------------------------------------------------------------------------

%\RequirePackage[french]{texjazz-coding}% DOES NOT WORK! WHY?
\InputIfFileExists{texjazz-coding.def}%
  {\typeout{*** The texjazz-coding.def file has been loaded successfully ***}}%
  {\ClassError{texjazz-handbook}{*** The TeXjazz coding file is required ***}}

%---------------------------------------------------------------------------------------------------
%---- PythonTeX and simulated terminals / shells
%---------------------------------------------------------------------------------------------------

%-- Python console
%-----------------

%- IPython console is not yet available, only the IDLE one is given, see:
%- https://tex.stackexchange.com/questions/224526/can-i-make-ipython-notebook-from-pythontex

%- See: https://tex.stackexchange.com/questions/213048/[...]
%-         [...]how-to-make-breaklines-the-result-from-pythontex
\RequirePackage[%
  usefamily=python,% Programming language
  gobble=auto,% Managing the leading whitespace in code
  pygopt={style=jazzcode, texcomments=true, mathescape=false},% Pygments options
  ]{pythontex}

\setpythontexworkingdir{PythonTeX}
%\setpythontexfv{numbers=left, firstnumber=last}
%\setpythontexlistingenv{listing}

%-- Defining "shell" environment to simulate a terminal/IDLE console (with `listings' package)
%---------------------------------------------------------------------------------------------

\InputIfFileExists{texjazz-shell.def}%
  {\typeout{*** The texjazz-shell.def file has been loaded successfully ***}}%
  {\ClassError{texjazz-handbook}{*** The TeXjazz shell file is required ***}}

\newcolumntype{T}{>{\small\color{black}\shellttfont}l}

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

%---------------------------------------------------------------------------------------------------
%---- Additional or casual utilities / Utilitaires complémentaires ou occasionnels
%---------------------------------------------------------------------------------------------------

%-- Multicolumn management
%-------------------------

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
\def\jazznobreakpar{\par\nobreak\@afterheading}% -> efficient solution!
\def\jazznobreakline{\par\nobreak\vspace{-\parskip}\@afterheading\noindent}

%---------------------------------------------------------------------------------------------------
%---- Sectioning and titling
%---------------------------------------------------------------------------------------------------

\InputIfFileExists{texjazz-titling.def}%
  {\typeout{*** The texjazz-titling.def file has been loaded successfully ***}}%
  {\ClassError{texjazz-handbook}{*** The TeXjazz titling file is required ***}}

%---------------------------------------------------------------------------------------------------
%---- Table of contents, figures, tables, etc.
%---------------------------------------------------------------------------------------------------

\InputIfFileExists{texjazz-toclof.def}%
  {\typeout{*** The texjazz-toclof.def file has been loaded successfully ***}}%
  {\ClassError{texjazz-handbook}{*** The TeXjazz toclof file is required ***}}


%-- Automatic control of the ToCs entries (ToC and TdM files)

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

%---------------------------------------------------------------------------------------------------
%---- Detection of the first entry of an environment (for the "list of...")
%---------------------------------------------------------------------------------------------------

\InputIfFileExists{texjazz-entry.def}%
  {\typeout{*** The texjazz-entry.def file has been loaded successfully ***}}%
  {\ClassError{texjazz-handbook}{*** The TeXjazz entry file is required ***}}

%---------------------------------------------------------------------------------------------------
%---- Headers and footers / Entêtes et pieds de page
%---------------------------------------------------------------------------------------------------

%-- It's better to load the `titleps'' package as an option of the `titlesec'' package
%\RequirePackage{titleps}% if without `titlesec' package, else already loaded (see previous §)
\InputIfFileExists{texjazz-headfoot.def}%
  {\typeout{*** The texjazz-headfoot.def file has been loaded successfully ***}}%
  {\ClassError{texjazz-handbook}{*** The TeXjazz headfoot file is required ***}}

%---------------------------------------------------------------------------------------------------
%---- Front-title page
%---------------------------------------------------------------------------------------------------

\InputIfFileExists{texjazz-titlepage.def}%
  {\typeout{*** The texjazz-titlepage.def file has been loaded successfully ***}}%
  {\ClassError{texjazz-handbook}{*** The TeXjazz titlepage file is required ***}}


%---------------------------------------------------------------------------------------------------
%--    Bibliography
%---------------------------------------------------------------------------------------------------

\InputIfFileExists{texjazz-bibliography.def}%
  {\typeout{*** The texjazz-bibliography.def file has been loaded successfully ***}}%
  {\ClassError{texjazz-handbook}{*** The TeXjazz bibliography file is required ***}}

%---------------------------------------------------------------------------------------------------
%---- Electronic circuits typesetting
%---------------------------------------------------------------------------------------------------

%\RequirePackage{circuitikz}% Not needed: TikZ circuit library is sufficient

%---------------------------------------------------------------------------------------------------
%---- Modelling typesetting tools for Merise and UML
%---------------------------------------------------------------------------------------------------

\ifbool{doc@modelling}{%
  \InputIfFileExists{texjazz-modelling.def}%
    {\typeout{*** The texjazz-modelling.def file has been loaded successfully ***}}%
    {\ClassError{texjazz-handbook}{*** The TeXjazz modelling file is required ***}}
}{}

%---------------------------------------------------------------------------------------------------
%---- Navigation with hyperlinks
%---------------------------------------------------------------------------------------------------

%-- Appel en fin préambule/extension car redéfini beaucoup de chose et problèmes possibles
\RequirePackage{hyperref}% Hyperlink

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

\newcommand{\tophyperref}[1]% #1 = label
{\hyperlink{page.\getpagerefnumber{#1}}{\getrefnumber{#1}}}

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

\ifbool{doc@english}{%
  \Crefname{figure}{Figure}{Figures}
  \crefname{figure}{figure}{figures}
  \Crefname{table}{Table}{Tables}
  \crefname{table}{table}{tables}% \crefname{table}{tableau}{tableaux}% polyglossia default
  \Crefname{section}{{\S}}{{\S}}
  \crefname{section}{{\S}}{{\S}}
  \Crefname{part}{Part}{Parts}
  \crefname{part}{part}{parts}
  \Crefname{chapter}{Chapter}{Chapters}
  \crefname{chapter}{chapter}{chapters}
  \Crefname{appendixchapter}{Appendix}{Appendices}
  \crefname{appendixchapter}{appendix}{appendices}
  \Crefname{exercise}{Exercise}{Exercises}
  \crefname{exercise}{exercise}{exercises}
  \Crefname{quiz}{Quiz}{Quizzes}
  \crefname{quiz}{quiz}{quizzes}
  \Crefname{video}{Video}{Videos}
  \crefname{video}{vidéo}{vidéos}
  \Crefname{document}{Document}{Document}
  \crefname{document}{document}{documents}
  \Crefname{code}{Code}{Codes}% Defined with tcolorbox environment? NO! DOES NOT WORK! WHY?
  \crefname{code}{code}{codes}% Defined with tcolorbox environment? NO! DOES NOT WORK! WHY?
  \Crefname{listing}{Listing}{Listings}
  \crefname{listing}{listing}{listings}
  \Crefname{algorithm}{Algorithm}{Algorithms}
  \crefname{algorithm}{algorithm}{algorithms}
}{\Crefname{figure}{Figure}{Figures}
  \crefname{figure}{figure}{figures}
  \Crefname{table}{Table}{Tables}
  \crefname{table}{table}{tables}% \crefname{table}{tableau}{tableaux}% polyglossia default
  \Crefname{section}{{\S}}{{\S}}
  \crefname{section}{{\S}}{{\S}}
  \Crefname{part}{Partie}{Parties}
  \crefname{part}{partie}{parties}
  \Crefname{chapter}{Chapitre}{Chapitres}
  \crefname{chapter}{chapitre}{chapitres}
  \Crefname{appendixchapter}{Annexe}{Annexes}
  \crefname{appendixchapter}{annexe}{annexes}
  \Crefname{exercise}{Exercice}{Exercices}
  \crefname{exercise}{exercice}{exercices}
  \Crefname{quiz}{Quiz}{Questionnaires}
  \crefname{quiz}{quiz}{questionnaires}
  \Crefname{video}{Vidéo}{Vidéos}
  \crefname{video}{vidéo}{vidéos}
  \Crefname{document}{Document}{Documents}
  \crefname{document}{document}{documents}
  \Crefname{code}{Code}{Codes}% Defined with tcolorbox environment? NO! DOES NOT WORK! WHY?
  \crefname{code}{code}{codes}% Defined with tcolorbox environment? NO! DOES NOT WORK! WHY?
  \Crefname{listing}{Listing}{Listings}
  \crefname{listing}{listing}{listings}
  \Crefname{algorithm}{Algorithme}{Algorithmes}
  \crefname{algorithm}{algorithme}{algorithmes}
}

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

\ifbool{doc@article}{}{%
  \let\titlesec@appendixchapter\appendixchapter
  \renewcommand{\appendixchapter}{\@ifstar\appendixchapter@star\appendixchapter@nostar}
  \def\appendixchapter@star#1{\NR@gettitle{#1}\titlesec@appendixchapter*{#1}}
  \def\appendixchapter@nostar{\@ifnextchar[\appendixchapter@nostar@opt\appendixchapter@nostar@nopt}
  \def\appendixchapter@nostar@nopt#1{\NR@gettitle{#1}\titlesec@appendixchapter{#1}}
  \def\appendixchapter@nostar@opt[#1]#2{\NR@gettitle{#2}\titlesec@appendixchapter[#1]{#2}}
}

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
\newcommand{\jazzfullref}[1]{\Cref{#1}\enspace\qnameref{#1}}

%---------------------------------------------------------------------------------------------------
%---- Bookmarks − extending/improving utilities from the 'hyperref' package / Gestion des signets
%---------------------------------------------------------------------------------------------------

\InputIfFileExists{texjazz-bookmark.def}%
  {\typeout{*** The texjazz-bookmark.def file has been loaded successfully ***}}%
  {\ClassError{texjazz-handbook}{*** The TeXjazz bookmark file is required ***}}

%---------------------------------------------------------------------------------------------------
%---- Exercise/solution environments (with a TikZ first layer and `tcolorbox` nested contents)
%---------------------------------------------------------------------------------------------------

%-- Points counting with the `assignpoints` package

\ifbool{doc@english}{%
  \RequirePackage{texjazz-assignpoints}% Assigning/calculating points within exercises/quizzes
  \RequirePackage{texjazz-askreply}% To be loaded *after* `assignpoints` and `hyperref' pkgs
  \typeout{*** Both TeXjazz assignpoints and askreply packages are loaded ***}
}{\RequirePackage[french]{texjazz-assignpoints}% Assigning/calculating exercises/quizzes points
  \RequirePackage[french]{texjazz-askreply}% To be loaded *after* `assignpoints` and `hyperref' pkgs
  \typeout{*** Both TeXjazz assignpoints and askreply packages are loaded ***}
}

%---------------------------------------------------------------------------------------------------
%---- Multimedia tools (sounds and videos)
%---------------------------------------------------------------------------------------------------

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

%---------------------------------------------------------------------------------------------------
%---- Setting the document tree: absolute and relative path, input/output, etc.
%---------------------------------------------------------------------------------------------------

%-- Graphics input files path and shortcut (`graphics' package)

\AtBeginDocument{%
  \graphicspath{% add here every search subdir
    {./Images/}{./Images/Logotype/}{./Images/Pictograms/}%
    {./Images/Chapter01/}{./Images/Chapter02/}{./Images/Chapter03/}%
    {./Images/Chapter04/}{./Images/Chapter05/}{./Images/Chapter06/}%
    {./Images/Chapter07/}{./Images/Chapter08/}{./Images/Chapter09/}%
    {./Images/Chapter10/}{./Images/Chapter11/}{./Images/Chapter12/}%
    {./Images/Chapter13/}{./Images/Chapter14/}{./Images/Chapter15/}%
    {./Images/AppendixA/}{./Images/AppendixB/}{./Images/AppendixC/}%
    {./Images/AppendixD/}{./Images/AppendixE/}{./Images/AppendixF/}%
  }%
}

%-- Adaptation/reprise du paquet `listings'

\ifx\Jazz@inputpath\@undefined
  \let\Jazz@inputpath\input@path
\fi

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
% Défini à l'arache dans nfe108_book (à peaufiner correctement) TODO
%\newenvironment{enumcount}
%  {\renewcommand{\usecounter}[1]
%     {\@nmbrlisttrue\def\@listctr{##1}}
%   \enumerate}
%  {\endlist}

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

%\RequirePackage{intopdf}% Does not work anymore after update (end of february)

%\NewDocumentCommand{\linktofile}{ o m m m m }{%
%  \leavevmode% WHY? If not → clash and compilation error
%  \attachandlink[#1]{#2}[#3]{#4}{\texcolor{firstcolor}{#5}}% Original command without color
%}

%---------------------------------------------------------------------------------------------------
%---- Glossaries, notations, symbols and index / Glossaires et autres listes indexées
%---------------------------------------------------------------------------------------------------

%\RequirePackage{texjazz-glossary}% to be loaded after hyperref package
\InputIfFileExists{texjazz-glossary.def}%
  {\typeout{*** The texjazz-glossary.def file has been loaded successfully ***}}%
  {\ClassError{texjazz-handbook}{*** The TeXjazz glossary file is required ***}}

%---------------------------------------------------------------------------------------------------
%---- List of used packages and classes
%---------------------------------------------------------------------------------------------------

%-----
%- Stolen solution to Enrico Gregorio's proposal (we don't understand at all this LaTeX3 syntax
%- for the moment being, but it works fine!:-)
%-   http://tex.stackexchange.com/questions/265726/embed-nicely-formatted-listfiles-into-document
%-   http://tex.stackexchange.com/questions/75055/print-filelist-to-pdf
%- For table rows numbering see:
%-   https://tex.stackexchange.com/questions/21243/automatic-table-row-numbers
%- For centering longtable see:
%-   https://tex.stackexchange.com/questions/261221/centering-longtable
%-----

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
  \begin{longtable}[c]{@{\makebox[3em][r]{\listnumber\space}} >{\ttfamily}l l >{\raggedright}p{.5\textwidth} @{}}
  %\keepXColumns
  %\begin{tabularx}{\linewidth}[c]%
    %{@{\makebox[3em][r]{\listnumber\space}} >{\ttfamily}l l X @{}}
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

%---------------------------------------------------------------------------------------------------
\endinput
%%%% End of file `texjazz-handbook.cls'.
