# The _WORKING_DIRECTORY_ value will be replaced with the current working directory
%define _topdir	 	_WORKING_DIRECTORY_/RPM_BUILD
%define _bindir		/usr/local/bin
%define _mandir		/usr/local/share/man/man1

# $Format: "%define name	${package}"$
%define name	ssp
%define release		1


# $Format: "%define version 	${label}"$
%define version 	e222a6380f149a75065afc4e9e74d3dd3dc6668e.0
%define buildroot 	%{_topdir}/%{name}-%{version}-root

BuildRoot:		%{buildroot}

# Since developer is nothing but perl scripts, we use the noarch flag. 
BuildArch:		noarch

Summary: 		Simple Scheduler in Perl
License: 		GPL
Name: 			%{name}
Version: 		%{version}
Release: 		%{release}
Source: 		%{name}-%{version}.tar.gz
Prefix: 		/usr/local
Group: 			Science
Vendor: 		Hugo Cornelis <hugo.cornelis@gmail.com>
Packager: 		Mando Rodriguez <mandorodriguez@gmail.com>
URL:			http://www.neurospaces.org

%description
 SSP is currently the standard scheduler for GENESIS. SSP exploits the sophistication of the Perl scripting language to load software modules on demand, and activate them from a configuration file. It achieves this by loading dynamically those software modules referenced in its configuration. Because the SSP scheduler does not have any computational load, its implementation is very simple and highly configurable. Other configurations will connect SSP to other modeling services or solvers.

# %package developer
# Requires: perl
# Summary: Neurospaces Developer Package
# Group: Science
# Provides: developer

%prep
echo %_target
echo %_target_alias
echo %_target_cpu
echo %_target_os
echo %_target_vendor
echo Building %{name}-%{version}-%{release}
%setup -q

%build
./configure 
make

%install
make install prefix=$RPM_BUILD_ROOT/usr/local

%clean
[ ${RPM_BUILD_ROOT} != "/" ] && rm -rf ${RPM_BUILD_ROOT}

# listing a directory name under files will include all files in the directory.
%files
%defattr(0755,root,root) 
/usr/local/
#/usr/share/


%doc %attr(0444,root,root) docs
#%doc %attr(0444,root,root) /usr/local/share/man/man1/wget.1
# need to put whatever docs to link to here.

%changelog
* Mon Apr  5 2010 Mando Rodriguez <mandorodriguez@gmail.com> - 
- Initial build.

