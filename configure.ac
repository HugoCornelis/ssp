dnl
dnl SSP : a simple scheduler written in perl, for driving numerical
dnl solver in neuronal modeling.
dnl

dnl ##########################################################################
dnl 
dnl SSP
dnl 
dnl Copyright (C) 2007-2008 Hugo Cornelis
dnl 
dnl Hugo Cornelis, hugo.cornelis@gmail.com
dnl 
dnl ##########################################################################

# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.59)

# $Format: "AC_INIT(${package}, ${major}.${minor}.${micro}-${label}, ${email})"$
AC_INIT(ssp, 6b4eb26b633a00d90247d65b13d984cb8232f51f.0, hugo.cornelis@gmail.com)

AC_CONFIG_SRCDIR([doxygen.cfg])

# $Format: "AM_INIT_AUTOMAKE(${package}, ${major}.${minor}.${micro}-${label})"$
AM_INIT_AUTOMAKE(ssp, 6b4eb26b633a00d90247d65b13d984cb8232f51f.0)

PERL_MODULES=`(cd perl && find . -name "*.pm" | perl -pe 's/\n/ /g')`
AC_SUBST(PERL_MODULES)

PERL_DATA=`(cd perl && find . -name "numbers-7x11.txt" | perl -pe 's/\n/ /g')`
AC_SUBST(PERL_DATA)

# Checks for programs.

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

# determine the test library to install

TEST_SPECIFICATION_FILES=`/bin/echo -n "tests/introduction.html " && find tests/specifications -name "*.t" | perl -pe 's/\n/ /g' && find tests/specifications/strings -name "*.txt" | perl -pe 's/\n/ /g'`
AC_SUBST(TEST_SPECIFICATION_FILES)

dnl YAML_FILES=`find yaml -name "*.yml" -printf "%p "`
dnl AC_SUBST(YAML_FILES)

AC_PATH_PROGS(DOXYGEN,doxygen,[NULL])
AC_PATH_PROGS(SOURCE_HIGHLIGHT,source-highlight)

AC_CONFIG_FILES([Makefile
		 perl/Makefile
		 tests/Makefile
		])
AC_OUTPUT

