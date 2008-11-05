%include Solaris.inc

Name:                    cscope
Summary:                 cscope - interactive source code examiner
Version:                 15.6
Source:                  http://easynews.dl.sourceforge.net/sourceforge/cscope/cscope-%{version}.tar.gz
URL:                     http://cscope.sourceforge.net/
SUNW_BaseDir:            /
BuildRoot:               %{_tmppath}/%{name}-%{version}-build
%include default-depend.inc
BuildConflicts:	SPROsslnk

%prep
%setup -q -n %{name}-%{version}

%build
CPUS=`/usr/sbin/psrinfo | grep on-line | wc -l | tr -d ' '`
if test "x$CPUS" = "x" -o $CPUS = 0; then
    CPUS=1
fi

%if %cc_is_gcc
%else
%endif
export CFLAGS="%optflags"
export CXXFLAGS="%cxx_optflags"
export LDFLAGS="%_ldflags"
./configure --prefix=${HOME}/bin/%{name}-%{base_arch}	\
	--bindir=${HOME}/bin/%{base_arch}	\
	--sbindir=${HOME}/bin/%{base_arch}

make -j$CPUS 

%install
make uninstall
rm -rf ${HOME}/bin/%{name}-%{base_arch}
make install

%clean

%files

%changelog
