# Simple Makefile to build Sphinx documentation

# You can set these variables from the command line, and also
# from the environment for the first two.
PYTHON3       ?= python3
SPHINX        ?= sphinx-build
SOURCEDIR     = docsrc
BUILDDIR      = _build
SERVEPORT     ?= 8080
TITLE         = "CloudVision Advanced Query Language"

all: latest oldrevisions revisionsindex

latest:
	$(SPHINX) -c $(SOURCEDIR) -a -E $(SOURCEDIR)/revisions/latest $(BUILDDIR)
	cp -r $(SOURCEDIR)/revisions/latest/doc/images $(BUILDDIR)/images

revisionsindex:
	$(SPHINX) -c $(SOURCEDIR) -a -E $(SOURCEDIR)/revisions_index $(BUILDDIR)/revisions_index

serve: latest oldrevisions revisionsindex
	$(PYTHON3) -m http.server --directory $(BUILDDIR) $(SERVEPORT)

oldrevisions:
	SPHINX="${SPHINX}" REVISIONDIR=$${rev} SOURCEDIR=${SOURCEDIR} BUILDDIR=${BUILDDIR} ./build_old_revisions.sh

clean:
	rm -rf $(BUILDDIR)

.PHONY: all html serve clean
