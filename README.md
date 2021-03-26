# Inria-mooc-handbook

This project consists of writing an additional hanbook for the three Moocs proposed since several
years by the Inria French institute: 

  − Informatique, création numérique, 
  
  − Sciences numériques et technologie,
  
  − Python 3 : des fondamentaux aux concepts avancés du langage.

These Moocs are dealing with computer sciences, digital culture and Python v.3 learning. 
They are hosted by the Fun platform: France université numérique.

This work may be distributed and/or modified under the conditions of the CC-BY-NC license.


## Quick user guide

**Prerequisites :**

- Recent [TeX Live](https://www.tug.org/texlive/quickinstall.html) installation
- Copy TeXjazz bundle files and fonts inside `~/.texmf`(TeX Directory Structure compliant)
- Update TeX Live local TDS using `texhash ~/.texmf`

**Compilation using the makefile :**

1. Go into the directory named `/sources`
2. Comment or uncomment chapters you want to compile inside the master file `inria-mooc.tex` (line 350)
3. Compile using `make inria-mooc.pdf` (this compile mulitple times so it takes some time)
4. Clean using `make clean`


**Compilation manually :**

1. Go into the directory named `/sources`
2. Comment or uncomment chapters you want to compile inside the master file `inria-mooc.tex` (line 350)
3. Compile a first time `lualatex -shell-escape inria-mooc.tex` (only LuaLaTeX engine is allowed)
4. Compile the bibliography `biber inria-mooc` (master file without extension)
5. Run PythonTeX script `pythontex inria-mooc.tex`
6. Compile the glossary ` xindy -L french -C utf8 -I xindy -M "inria-mooc" -t "inria-mooc.glg" -o "inria-mooc.gls" "inria-mooc.glo"`
7. Compile a second time `lualatex -shell-escape inria-mooc.tex` (cross references)
8. Compile a third time `lualatex -shell-escape inria-mooc.tex` (cross references)
9. Compile a fourth time `lualatex -shell-escape inria-mooc.tex` (cross references)


**Complete guide and documentation :**

- [Handbook](./doc/latex/texjazz/texjazz-handbook-fr.pdf)
- [AskReply](./doc/latex/texjazz/texjazz-askreply-fr.pdf)
- [AssignPoints](./doc/latex/texjazz/texjazz-assignpoints-fr.pdf)
