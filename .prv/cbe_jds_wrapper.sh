#!/bin/sh

if which env.sh >/dev/null 2>&1 ; then
    JDS_CBE_ENV_QUIET=1 . env.sh
else
    echo; echo "Can not find env.sh"; echo; exit 1
fi

. $HOME/.prv/user_sh_include.sh

#
# PATH is updated, prepend my staff at the beginning.
#
user_sh_compose_path 0 $USER_SH_MID_PRIOR_BIN_PATH_SET
user_sh_compose_path 0 $USER_SH_HIGH_PRIOR_BIN_PATH_SET

user_sh_domain_name_init
[ "x$USER_SH_DOMAIN_NAME" = "xprc" ] && \
    user_sh_compose_path 0 $USER_SH_HOME_BIN_PATH_SET

if which ccache >/dev/null 2>&1 ; then
    lv_vars=`env | cut -f1 -d '='`
    for lv_var in $lv_vars; do
	case $lv_var in
	CC* | CXX* )
	    eval $lv_var=`which \`eval basename \\\\$$lv_var\``
	    ;;
	esac
    done
    unset lv_var lv_vars
else
    echo; echo "Can not find ccache, source env.sh without ccache"; echo
fi

CBE_JDS_ENV=1; export CBE_JDS_ENV

umask 022

exec $SHELL
