dnl
dnl SSP : a simple scheduler written in perl, for driving numerical
dnl solver in neuronal modeling.
dnl

dnl ##########################################################################
dnl 
dnl SSP
dnl 
dnl Copyright (C) 2007 Hugo Cornelis
dnl 
dnl Hugo Cornelis, hugo.cornelis@gmail.com
dnl 
dnl ##########################################################################

# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.59)

# $Format: "AC_INIT(${package}, ${label}, ${email})"$
AC_INIT(ssp, i64-4, hugo.cornelis@gmail.com)

AC_CONFIG_SRCDIR([ssp_test.pm])

# $Format: "AM_INIT_AUTOMAKE(${package}, ${label})"$
AM_INIT_AUTOMAKE(ssp, i64-4)

# Checks for programs.

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

# determine the test library to install

TEST_SPECIFICATION_FILES=`find tests/specifications -name "*.t" -printf "%p " && find tests/specifications/strings -name "*.txt" -printf "%p "`
AC_SUBST(TEST_SPECIFICATION_FILES)


AC_CONFIG_FILES([Makefile
		 tests/Makefile
		])
AC_OUTPUT

