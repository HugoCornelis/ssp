##
## SSP : a simple scheduler written in perl, for driving numerical
## solver in neuronal modeling.
##

##############################################################################
##'
##' SSP
##'
##' Copyright (C) 2007 Hugo Cornelis
##'
##' Hugo Cornelis, hugo.cornelis@gmail.com
##'
##############################################################################


SUBDIRS = perl tests

dist_bin_SCRIPTS = bin/ssp bin/ssp_directory

ssptestdir=$(prefix)/ssp
nobase_dist_ssptest_DATA=@TEST_SPECIFICATION_FILES@

dist-keywords:
	release-expand ssp des 8 0 des-8 hugo.cornelis@gmail.com --verbose

# The variable EXTRA_DIST could also be used here.

dist-hook: dist-keywords
	cd $(srcdir) && if test -n "`mtn ls changed `" ; then false ; else true ; fi
	find $(distdir) -name _Inline -exec chmod u+w -R \{\} \;
	$(RM) -fr `find $(distdir) -name _Inline`
	cp $(srcdir)/license.txt $(distdir)
	cp $(srcdir)/ssp_test.pm $(distdir)
	cp -R $(srcdir)/docs $(distdir)
	$(srcdir)/install-sh -d $(distdir)/tests
	$(srcdir)/install-sh -d $(distdir)/tests/html
#	$(srcdir)/install-sh -d $(distdir)/tests/html/algorithms
#	$(srcdir)/install-sh -d $(distdir)/tests/html/code
#	$(srcdir)/install-sh -d $(distdir)/tests/html/specifications
#	$(srcdir)/install-sh -d $(distdir)/tests/html/specifications/algorithms
#	$(srcdir)/install-sh -d $(distdir)/tests/html/specifications/code
	cp -dp $(srcdir)/tests/{neurospaces_harness,neurospaces_harness.ptkdb,command_extractor,command_extractor.ptkdb,tests_2_html,tests_2_html.ptkdb,tests.config} $(distdir)/tests
	cp -a $(srcdir)/tests.config $(distdir)
#	cp -a $(srcdir)/tests/code/tests.config $(distdir)/tests/code/tests.config
	cp -a $(srcdir)/tests/perl $(distdir)/tests
	cp -a $(srcdir)/yaml $(distdir)
	( cd $(distdir)/tests && chmod -R u+w . && ./tests_2_html --introduction introduction.html )

test: check

html-upload-prepare:
	( cd tests && ./tests_2_html --introduction introduction.html )
	rm -fr html/htdocs/neurospaces_project/ssp/
	mkdir --parents html/htdocs/neurospaces_project/ssp
	mkdir --parents html/htdocs/neurospaces_project/ssp/html_source
	tar cfh - tests/html | ( cd html/htdocs/neurospaces_project/ssp && tar vxf - )

html-upload: html-upload-prepare
	scp -pr html/htdocs/* hcornelis@shell.sourceforge.net:/home/groups/n/ne/neurospaces/htdocs/

##t use $(swigdir) here

#perldir = $(prefix)/glue/swig/perl

#perl_HEADERS = perl/SSP.pm ssp_test.pm

TESTS = ssp_test.pm

test: check

