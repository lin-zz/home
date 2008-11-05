%include Solaris.inc

Name:                    ccache
Summary:                 Ccache a compiler cache.
Version:                 2.4
Source:                  http://samba.org/ftp/ccache/ccache-%{version}.tar.gz
SUNW_BaseDir:            /
BuildRoot:               %{_tmppath}/%{name}-%{version}-build
%include default-depend.inc

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
#export CPPFLAGS="%cxx_optflags"
export CXXFLAGS="%cxx_optflags"
export LDFLAGS="%_ldflags"
./configure --prefix=${HOME}/bin/%{name}-%{base_arch}	\
	--bindir=${HOME}/bin/%{base_arch}	\
	--sbindir=${HOME}/bin/%{base_arch}

make -j$CPUS

%install
rm -rf ${HOME}/bin/%{name}-%{base_arch}
make install

%clean

%files

%changelog
