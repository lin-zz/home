#!/usr/bin/sh +xv
#
# Remote path
#
# pragma ident   "%Z%%M% %I%     %E% SMI"
#
# Lin Ma
#
. $HOME/.prv/user_sh_include.sh

#
# Compilers
#
# Note we use dbx here, because there are many cc
if which dbx >/dev/null 2>&1; then
    :
else
    [ "x$USER_SH_DOMAIN_NAME" = "xprc" -a "x$USER_SH_MACH" = "xi386" ] && \
	user_sh_choose_path 1 "/net/lucky.prc/opt/SUNWspro/SS11/bin" || \
	user_sh_choose_path 1 "/ws/onnv-tools$USER_SH_DOMAIN_SUFFIX_NAME/SUNWspro/SS11/bin"
fi

#
# Onbld
#
if which wx >/dev/null 2>&1; then
    :
else
    [ "x$USER_SH_DOMAIN_NAME" = "xprc" -a "x$USER_SH_MACH" = "xi386" ] && \
	user_sh_choose_path 1 "/net/lucky.prc/opt/onbld/bin" || \
	user_sh_choose_path 1 "/ws/onnv-tools$USER_SH_DOMAIN_SUFFIX_NAME/onbld/bin"
fi

#
# Teamware
#
if which bringover >/dev/null 2>&1; then
    :
else
    [ "x$USER_SH_DOMAIN_NAME" = "xprc" -a "x$USER_SH_MACH" = "xi386" ] && \
	user_sh_choose_path 1 "/net/lucky.prc/opt/teamware/bin" || \
	user_sh_choose_path 1 "/ws/onnv-tools$USER_SH_DOMAIN_SUFFIX_NAME/teamware/bin"
fi

#
# Re-export PATH
#
export PATH
