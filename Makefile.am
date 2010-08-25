##
## SSP : a simple scheduler written in perl, for driving numerical
## solver in neuronal modeling.
##

##############################################################################
##'
##' SSP
##'
##' Copyright (C) 2007-2008 Hugo Cornelis
##'
##' Hugo Cornelis, hugo.cornelis@gmail.com
##'
##############################################################################


SUBDIRS = perl tests

dist_bin_SCRIPTS = bin/ssp bin/ssp_directory

ssptestdir=$(prefix)/ssp
nobase_dist_ssptest_DATA=@TEST_SPECIFICATION_FILES@

RELEASE_MAJOR=`release-extract --major`
RELEASE_MINOR=`release-extract --minor`
RELEASE_MICRO=`release-extract --micro`

EXTRA_DIST = \
	doxygen.cfg 

CLEANFILES = \
	$(top_srcdir)/docs/doxygen.tag

clean-local:
	$(RM) -rf $(top_srcdir)/docs/html
	$(RM) -rf $(top_srcdir)/tests/html
	$(RM) -rf ~/.genesis3/ssp/InlinePerlCode
	$(RM) -rf $(top_srcdir)/*_BUILD
	$(RM) -f $(top_srcdir)/*.dsc
	$(RM) -f $(top_srcdir)/*.changes
	$(RM) -f $(top_srcdir)/*.deb
	$(RM) -f $(top_srcdir)/build_*.log
	$(RM) -f $(top_srcdir)/ssp-*.tar.gz

show-release-labels:
	echo "Release information (major-minor-micro): $(RELEASE_MAJOR)-$(RELEASE_MINOR)-$(RELEASE_MICRO)"

dist-keywords:
	release-expand ssp $(RELEASE_MAJOR) $(RELEASE_MINOR) $(RELEASE_MICRO) $(RELEASE_MAJOR).$(RELEASE_MINOR) hugo.cornelis@gmail.com --verbose
#	release-expand ssp des 10 0 des-10 hugo.cornelis@gmail.com --verbose


# The variable EXTRA_DIST could also be used here.

dist-hook: 
	if test -n "$$NEUROSPACES_RELEASE" ; then cd $(srcdir) && if test -n "`mtn ls changed `" ; then false ; else true ; fi ; else true ; fi
	cp $(srcdir)/license.txt $(distdir)
	cp -R $(srcdir)/docs $(distdir)
	rm -rf $(distdir)/docs/html
	rm -rf $(distdir)/docs/latex
	rm -rf $(distdir)/docs/man
	rm -rf $(distdir)/docs/html
	rm -rf $(distdir)/docs/rtf
	$(srcdir)/install-sh -d $(distdir)/tests
	$(srcdir)/install-sh -d $(distdir)/tests/html
#	$(srcdir)/install-sh -d $(distdir)/tests/html/algorithms
#	$(srcdir)/install-sh -d $(distdir)/tests/html/code
#	$(srcdir)/install-sh -d $(distdir)/tests/html/specifications
#	$(srcdir)/install-sh -d $(distdir)/tests/html/specifications/algorithms
#	$(srcdir)/install-sh -d $(distdir)/tests/html/specifications/code
	cp -pR $(srcdir)/tests/command_extractor $(distdir)/tests
	cp -pR $(srcdir)/tests/command_extractor.ptkdb $(distdir)/tests
	cp -pR $(srcdir)/tests/tests_2_html $(distdir)/tests
	cp -pR $(srcdir)/tests/tests_2_html.ptkdb $(distdir)/tests
	cp -pR $(srcdir)/tests/tests.config $(distdir)/tests
	cp -pR $(srcdir)/tests.config $(distdir)
#	cp -pR $(srcdir)/tests/code/tests.config $(distdir)/tests/code/tests.config
	cp -pR $(srcdir)/tests/perl $(distdir)/tests
	cp -pR $(srcdir)/yaml $(distdir)
	( cd $(distdir)/tests && chmod -R u+w . && ./tests_2_html --introduction introduction.html )

test: check

html-upload-prepare:
	( cd tests && ./tests_2_html --introduction introduction.html )
	rm -fr html/htdocs/neurospaces_project/ssp/
	mkdir -p html/htdocs/neurospaces_project/ssp
	mkdir -p html/htdocs/neurospaces_project/ssp/html_source
	tar cfh - tests/html | ( cd html/htdocs/neurospaces_project/ssp && tar vxf - )

html-upload: html-upload-prepare
	scp -pr html/htdocs/* hcornelis,neurospaces@web.sourceforge.net:/home/groups/n/ne/neurospaces/htdocs/

##t use $(swigdir) here

#perldir = $(prefix)/glue/swig/perl

#perl_HEADERS = perl/SSP.pm ssp_test.pm

#TESTS = ssp_test.pm

test: check

doxygen: doxygen.cfg
	$(DOXYGEN) doxygen.cfg

docs-level1:

docs-level2:

docs-level3: html-upload-prepare
	echo "Converted the regression tests to HTML"

docs-level4:

docs-level5:

docs-level6: doxygen
	echo "Doxygenized source code"

docs-level7:

docs: docs-level1 docs-level2 docs-level3 docs-level4 docs-level5 docs-level6 docs-level7

TMP_DIR = tmp

# Create a deb package
pkg-deb: dist
	nspkg-deb $(PACKAGE) $(VERSION)

pkg-rpm: dist
	nspkg-rpm $(PACKAGE) $(VERSION)

pkg-osx: 
	nspkg-osx 

