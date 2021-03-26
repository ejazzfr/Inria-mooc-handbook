all: inria-mooc.pdf clean

inria-mooc.pdf: inria-mooc.tex
	@echo "Compilation 1"
	@lualatex -shell-escape -interaction batchmode inria-mooc.tex || echo 'Some errors but keep going'
	@echo "Biber"
	@biber inria-mooc
	@echo "Pythontex"
	@pythontex inria-mooc.tex
	@echo "Xindy"
	@xindy -L french -C utf8 -I xindy -M "inria-mooc" -t "inria-mooc.glg" -o "inria-mooc.gls" "inria-mooc.glo"
	@echo "Compilation 2"
	@lualatex -shell-escape -interaction batchmode inria-mooc.tex || echo 'Some errors but keep going'
	@echo "Compilation 3"
	@lualatex -shell-escape -interaction batchmode inria-mooc.tex || echo 'Some errors but keep going'
	@echo "Compilation 4"
	@lualatex -shell-escape -interaction batchmode inria-mooc.tex || echo 'Some errors but keep going'

clean:
	@rm -f *.aux *.bcf *.blg *.bbl *.fdb_latexmk *.fls *-glg *.glg *-glo *.glo *-gls *.gls *.hd *.idx *.ilg *.ind *.listing *.loc *.lod *.loe *.lof *.lol *.loq *.lot *.lov *.log *.nav *.out *.ptc *.pytxcode *.pyg *.run.xml *.snm *.synctex.gz *.tdm *.toc *.xdy
	@rm -rf Exercises-* _minted-* PythonTeX pythontex-files-* Quizzes-*
