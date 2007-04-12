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


SUBDIRS = tests

bin_SCRIPTS = bin/ssp

# the tests are copied overhere.
# the perl library is copied overhere.
#
# The variable EXTRA_DIST could also be used here.

dist-hook:
	find $(distdir) -name _Inline -exec chmod u+w -R \{\} \;
	$(RM) -fr `find $(distdir) -name _Inline`
	cp $(srcdir)/license.txt $(distdir)
	cp -R $(srcdir)/docs $(distdir)
	test -d $(distdir)/tests || mkdir $(distdir)/tests
	test -d $(distdir)/tests/specifications || mkdir $(distdir)/tests/specifications
	cp -R $(srcdir)/tests/run $(distdir)/tests/run
	cp -R $(srcdir)/tests/tests_2_html $(distdir)/tests/tests_2_html
	cp -R $(srcdir)/tests/specifications $(distdir)/tests
#	cp -R $(srcdir)/tests/code/tests.config $(distdir)/tests/code/tests.config
	cp -R $(srcdir)/tests/tests.config $(distdir)/tests/tests.config
	cp -R $(srcdir)/tests.config $(distdir)
	cp -R $(srcdir)/perl $(distdir)
	cp -R $(srcdir)/bin $(distdir)

#	cp -R $(srcdir)/hierarchy $(distdir)
#	cp -R $(srcdir)/library $(distdir)

#! this one breaks the distcheck, because automake makes dist dirs read-only
#	cd $(distdir)/tests && ./tests_2_html

test: check

html-upload-prepare:
	rm -fr html/htdocs/neurospaces_project/ssp/
	mkdir --parents html/htdocs/neurospaces_project/ssp
	mkdir --parents html/htdocs/neurospaces_project/ssp/html_source
	tar cfh - tests/html | ( cd html/htdocs/neurospaces_project/ssp && tar vxf - )

html-upload: html-upload-prepare
	scp -pr html/htdocs/* hcornelis@shell.sourceforge.net:/home/groups/n/ne/neurospaces/htdocs/

#t use $(swigdir) here

perldir = $(prefix)/glue/swig/perl

perl_HEADERS = perl/SSP.pm ssp_test.pm

TESTS = ssp_test.pm

test: check

