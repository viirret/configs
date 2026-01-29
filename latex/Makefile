# Default document name (without .tex extension)
DOCUMENT ?= main

# LaTeX compiler
LATEX = lualatex

# Compiler flags
LATEX_FLAGS = -interaction=nonstopmode -shell-escape -synctex=1

# BibTeX compiler
BIBTEX = biber

# Directory for auxiliary files
AUX_DIR = build

# PDF viewer
PDF_VIEWER = evince

# Targets
# -------

.PHONY: all clean clean-all pdf view view-evince view-xdg view-open watch help compile

# Default target
all: pdf

# Main PDF target
pdf: $(AUX_DIR)/$(DOCUMENT).pdf

# Rule to create PDF
$(AUX_DIR)/$(DOCUMENT).pdf: $(DOCUMENT).tex | $(AUX_DIR)
	@echo "=== Compiling $(DOCUMENT).tex ==="
	@echo "=== First pass (LuaTeX) ==="
	$(LATEX) $(LATEX_FLAGS) -output-directory=$(AUX_DIR) $(DOCUMENT).tex
	
	@if [ -f $(AUX_DIR)/$(DOCUMENT).bcf ]; then \
		echo "=== BibTeX pass ==="; \
		cd $(AUX_DIR) && $(BIBTEX) $(DOCUMENT); \
		cd ..; \
	fi
	
	@echo "=== Second pass (LuaTeX) ==="
	$(LATEX) $(LATEX_FLAGS) -output-directory=$(AUX_DIR) $(DOCUMENT).tex
	
	@echo "=== Third pass (LuaTeX) ==="
	$(LATEX) $(LATEX_FLAGS) -output-directory=$(AUX_DIR) $(DOCUMENT).tex
	
	@echo "=== Copying PDF to current directory ==="
	cp $(AUX_DIR)/$(DOCUMENT).pdf .
	
	@echo "=== Done ==="

# Quick compile
quick: $(DOCUMENT).tex | $(AUX_DIR)
	@echo "=== Quick compile of $(DOCUMENT).tex ==="
	$(LATEX) $(LATEX_FLAGS) -output-directory=$(AUX_DIR) $(DOCUMENT).tex
	cp $(AUX_DIR)/$(DOCUMENT).pdf .

# Create auxiliary directory
$(AUX_DIR):
	mkdir -p $(AUX_DIR)

# View PDF with Evince (default)
view: $(AUX_DIR)/$(DOCUMENT).pdf
	@echo "=== Opening $(DOCUMENT).pdf with Evince ==="
	@if command -v $(PDF_VIEWER) > /dev/null; then \
		$(PDF_VIEWER) $(DOCUMENT).pdf 2>/dev/null & \
		echo "PDF opened in Evince"; \
	else \
		echo "Evince not found. Trying other viewers..."; \
		$(MAKE) view-xdg; \
	fi

# View with Evince
view-evince: $(AUX_DIR)/$(DOCUMENT).pdf
	@echo "=== Opening $(DOCUMENT).pdf with Evince ==="
	evince $(DOCUMENT).pdf 2>/dev/null &

# View with system default (xdg-open)
view-xdg: $(AUX_DIR)/$(DOCUMENT).pdf
	@echo "=== Opening $(DOCUMENT).pdf with system default ==="
	@if command -v xdg-open > /dev/null; then \
		xdg-open $(DOCUMENT).pdf & \
	elif command -v open > /dev/null; then \
		open $(DOCUMENT).pdf & \
	else \
		echo "Could not find PDF viewer. Please open $(DOCUMENT).pdf manually."; \
	fi

# View with Okular (KDE)
view-okular: $(AUX_DIR)/$(DOCUMENT).pdf
	@echo "=== Opening $(DOCUMENT).pdf with Okular ==="
	okular $(DOCUMENT).pdf 2>/dev/null &

# View with Zathura (lightweight)
view-zathura: $(AUX_DIR)/$(DOCUMENT).pdf
	@echo "=== Opening $(DOCUMENT).pdf with Zathura ==="
	zathura $(DOCUMENT).pdf 2>/dev/null &

# View with mupdf (minimal)
view-mupdf: $(AUX_DIR)/$(DOCUMENT).pdf
	@echo "=== Opening $(DOCUMENT).pdf with mupdf ==="
	mupdf $(DOCUMENT).pdf 2>/dev/null &

# Auto-recompile and auto-view (Evince will reload automatically)
autoview: $(AUX_DIR)/$(DOCUMENT).pdf
	@echo "=== Opening with Evince (auto-reload enabled) ==="
	@if command -v evince > /dev/null; then \
		evince $(DOCUMENT).pdf 2>/dev/null & \
		echo "Now watching for changes..."; \
		echo "Evince will auto-reload when PDF is recompiled"; \
		echo "Press Ctrl+C to stop watching"; \
		if command -v inotifywait > /dev/null; then \
			while true; do \
				inotifywait -e modify $(DOCUMENT).tex 2>/dev/null; \
				$(MAKE) quick; \
			done; \
		elif command -v fswatch > /dev/null; then \
			fswatch -o $(DOCUMENT).tex | xargs -n1 -I{} $(MAKE) quick; \
		fi \
	else \
		echo "Evince not found. Using regular view..."; \
		$(MAKE) view-xdg; \
	fi

# Continuous compilation
watch:
	@echo "=== Watching for changes ==="
	@echo "Press Ctrl+C to stop"
	@if command -v inotifywait > /dev/null; then \
		while true; do \
			inotifywait -e modify $(DOCUMENT).tex 2>/dev/null; \
			$(MAKE) quick; \
		done; \
	elif command -v fswatch > /dev/null; then \
		fswatch -o $(DOCUMENT).tex | xargs -n1 -I{} $(MAKE) quick; \
	else \
		echo "Error: No file watcher found."; \
		echo "Install inotify-tools (Linux) or fswatch (macOS) for auto-compilation."; \
		exit 1; \
	fi

# Clean auxiliary files
clean:
	@echo "=== Cleaning auxiliary files for $(DOCUMENT) ==="
	rm -f $(AUX_DIR)/$(DOCUMENT).aux $(AUX_DIR)/$(DOCUMENT).log \
	      $(AUX_DIR)/$(DOCUMENT).out $(AUX_DIR)/$(DOCUMENT).toc \
	      $(AUX_DIR)/$(DOCUMENT).lof $(AUX_DIR)/$(DOCUMENT).lot \
	      $(AUX_DIR)/$(DOCUMENT).bbl $(AUX_DIR)/$(DOCUMENT).blg \
	      $(AUX_DIR)/$(DOCUMENT).bcf $(AUX_DIR)/$(DOCUMENT).run.xml \
	      $(AUX_DIR)/$(DOCUMENT).synctex.gz $(AUX_DIR)/$(DOCUMENT).fdb_latexmk \
	      $(AUX_DIR)/$(DOCUMENT).fls $(AUX_DIR)/$(DOCUMENT).nav \
	      $(AUX_DIR)/$(DOCUMENT).snm $(AUX_DIR)/$(DOCUMENT).vrb

# Clean all LaTeX auxiliary files in current directory
clean-aux:
	@echo "=== Cleaning ALL LaTeX auxiliary files in current directory ==="
	@echo "Cleaning in current directory (excluding build directory):"
	# Clean common LaTeX auxiliary files
	rm -f *.aux *.log *.out *.toc *.lof *.lot
	rm -f *.bbl *.blg *.bcf *.run.xml
	rm -f *.synctex.gz *.fdb_latexmk *.fls
	rm -f *.nav *.snm *.vrb *.xwm
	rm -f *.glg *.glo *.gls *.ist *.acn *.acr *.alg
	rm -f *.idx *.ilg *.ind
	rm -f *.maf *.mtc *.mtc0 *.mtc1 *.mtc2 *.mtc3 *.mtc4 *.mtc5 *.mtc6 *.mtc7
	rm -f *.mw
	rm -f *.nlo
	rm -f *.pyg
	@echo "Also cleaning other common auxiliary files:"
	rm -f *-blx.bib *.nav *.snm *.vrb
	rm -f *.brf
	rm -f *.dvi
	rm -f *.ent
	rm -f *.fff
	rm -f *.ttt
	rm -f *.upa
	rm -f *.upb
	rm -f *.pdfpc
	@echo "LaTeX auxiliary files cleaned from current directory."

# Clean everything
clean-all: clean
	@echo "=== Cleaning all generated files for $(DOCUMENT) ==="
	rm -f $(DOCUMENT).pdf
	# Note: We don't remove $(AUX_DIR) since it might contain other files

# Help
help:
	@echo "LaTeX Makefile for LuaTeX with Evince"
	@echo "====================================="
	@echo "Usage: make [target] [DOCUMENT=filename]"
	@echo ""
	@echo "Examples:"
	@echo "  make                         # Compile main.tex"
	@echo "  make DOCUMENT=paper          # Compile paper.tex"
	@echo "  make view                    # Open PDF with Evince"
	@echo "  make DOCUMENT=report view    # Compile report.tex and open with Evince"
	@echo "  make autoview                # Open with Evince and auto-recompile on changes"
	@echo ""
	@echo "Available targets:"
	@echo "  pdf          : Compile PDF with multiple passes"
	@echo "  quick        : Quick compile (single pass)"
	@echo "  view         : Open PDF with Evince (default)"
	@echo "  view-evince  : Open PDF with Evince"
	@echo "  view-xdg     : Open PDF with system default viewer"
	@echo "  view-okular  : Open PDF with Okular"
	@echo "  view-zathura : Open PDF with Zathura"
	@echo "  view-mupdf   : Open PDF with mupdf"
	@echo "  autoview     : Open with Evince and auto-recompile on changes"
	@echo "  watch        : Watch for changes and recompile"
	@echo "  clean        : Remove auxiliary files"
	@echo "  clean-all    : Remove all generated files"
	@echo "  help         : Show this help message"
	@echo ""
	@echo "Configuration:"
	@echo "  Main document: $(DOCUMENT).tex"
	@echo "  PDF viewer: $(PDF_VIEWER)"
	@echo "  Change PDF viewer: edit PDF_VIEWER variable in Makefile"
