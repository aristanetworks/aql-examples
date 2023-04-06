# Simple Makefile to build Sphinx documentation

# You can set these variables from the command line, and also
# from the environment for the first two.
PYTHON3       ?= python3
SPHINX        ?= sphinx-build
SOURCEDIR     = docsrc
BUILDDIR      = _build
SERVEPORT     ?= 8080

all: html

html:
	$(SPHINX) -a -E $(SOURCEDIR) $(BUILDDIR)

serve: html
	$(PYTHON3) -m http.server --directory $(BUILDDIR) $(SERVEPORT)

clean:
	rm -rf $(BUILDDIR)

.PHONY: all html serve clean