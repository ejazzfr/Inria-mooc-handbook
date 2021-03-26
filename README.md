# Inria-mooc-handbook

This project consists of writing an additional hanbook for the three Moocs proposed since several
years by the Inria French institute: 

  − Informatique, création numérique, 
  
  − Sciences numériques et technologie,
  
  − Python 3 : des fondamentaux aux concepts avancés du langage.

These Moocs are dealing with computer sciences, digital culture and Python v.3 learning. 
They are hosted by the Fun platform: France université numérique.

This work may be distributed and/or modified under the conditions of the CC-BY-NC license.


## How to use

**Prerequisites :**

- Recent [Tex Live](https://www.tug.org/texlive/quickinstall.html) installation
- Copy texjazz files and fonts inside `~/.texmf`
- Update tex live using `texhash ~/.texmf`

**Compilation using the makefile :**

1. Se place dans le dossier `/sources`
2. Comment or uncomment chapters you want to compile inside `inria-mooc.tex` (ligne 350)
3. Compile using `make inria-mooc.pdf` (this compile mulitple times so it takes some time)
4. Clean using `make clean`


**Compilation manually :**

1. Se place dans le dossier `/sources`
2. Comment or uncomment chapters you want to compile inside `inria-mooc.tex` (ligne 350)
3. Compile a first time `lualatex -shell-escape inria-mooc.tex`
4. Compile the bibliography `biber inria-mooc`
5. Compile pythontex `pythontex inria-mooc.tex`
6. Compile the glossary ` xindy -L french -C utf8 -I xindy -M "inria-mooc" -t "inria-mooc.glg" -o "inria-mooc.gls" "inria-mooc.glo"`
7. Compile a second time `lualatex -shell-escape inria-mooc.tex`
8. Compile a third time `lualatex -shell-escape inria-mooc.tex`
9. Compile a fourth time `lualatex -shell-escape inria-mooc.tex`



**Complete guide and documentation :**

- [Handbook](./doc/latex/texjazz/texjazz-handbook-fr.pdf)
- [AskReply](./doc/latex/texjazz/texjazz-askreply-fr.pdf)
- [AssignPoints](./doc/latex/texjazz/texjazz-assignpoints-fr.pdf)
