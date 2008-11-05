#!/usr/bin/sh +xv
#
# Global Variabls
#
# pragma ident   "%Z%%M% %I%     %E% SMI"
#
# Lin Ma
#
. $HOME/.prv/user_sh_include.sh

##
## User Path
##

# Blank PATH
PATH=""
user_sh_compose_path 1 $USER_SH_HIGH_PRIOR_BIN_PATH_SET
user_sh_compose_path 1 $USER_SH_HIGH_PRIOR_STANDARD_BIN_PATH_SET
user_sh_compose_path 1 $USER_SH_MID_PRIOR_BIN_PATH_SET
user_sh_compose_path 1 $USER_SH_COMPILER_BIN_PATH_SET
user_sh_compose_path 1 $USER_SH_LOW_PRIOR_STANDARD_BIN_PATH_SET
user_sh_compose_path 1 $USER_SH_LOW_PRIOR_BIN_PATH_SET

export PATH

user_sh_domain_name_init
[ "x$USER_SH_DOMAIN_NAME" = "xprc" ] && \
    user_sh_compose_path 0 $USER_SH_HOME_BIN_PATH_SET

if which scim >/dev/null 2>&1; then
    GTK_IM_MODULE=scim
fi

export GTK_IM_MODULE

umask 077
