#!/bin/tcsh

#set echo
if ( -X env.csh ) then
    setenv JDS_CBE_ENV_QUIET 1
    source `which env.csh`
    unsetenv JDS_CBE_ENV_QUIET
else
    echo ""
    echo "Can not find env.csh"
    echo ""
    exit 1
endif

set path = ( ${home}/bin/`/usr/bin/uname -p` ${home}/bin ${path} )
if ( -X ccache ) then
    set vars = `env | cut -f1 -d=`
    foreach var ( $vars )
	switch ($var)
	case CC*:
	case CXX*:
	    eval set compiler = `eval basename '$'$var`
	    eval setenv $var `which $compiler`
	    breaksw
	endsw
    end
    unset var vars compiler
else
    echo ""
    echo "Can not find ccache, source env.csh without ccache"
    echo ""
endif

setenv CBE_JDS_ENV 1
umask 022
exec $SHELL
