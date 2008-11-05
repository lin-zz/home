#!/usr/bin/sh +xv
#
# Global Variabls
#
# pragma ident   "%Z%%M% %I%     %E% SMI"
#
# Lin Ma
#
. $HOME/.prv/user_sh_include.sh

REAL_NAME='Lin Ma'; export REAL_NAME
EMAIL_ADDRESS='Lin.Ma@Sun.COM'; export EMAIL_ADDRESS
CVS_RSH=ssh; export CVS_RSH
SOCKS5_SERVER=brmea-socks:1080; export SOCKS5_SERVER
DMAKE_ODIR=/home/lm161491/.dmake; export DMAKE_ODIR
DMAKE_MODE=distributed; export DMAKE_MODE
#SPRO_NETBEANS_HOME=/usr/dist/share/sunstudio_${HOSTTYPE}/netbeans/3.5V11; export SPRO_NETBEANS_HOME
#SPRO_DBX_PATH
CODEMGR_DIR_FLG=turbo-dir.flp; export CODEMGR_DIR_FLG
PUTBACK='cm_env -d 10 -o putback'; export PUTBACK
FIGNORE="~"

alias cscope="DISPLAY= EDITOR=vi cscope"
alias cscope-fast="DISPLAY= EDITOR=vi cscope-fast"

#
# EDITOR and editors
#
if which xemacs >/dev/null 2>&1; then
alias xemacsnw="xemacs -nw"
EDITOR="xemacs -nw"
elif which emacs >/dev/null 2>&1; then
alias emacsnw="emacs -nw"
EDITOR="emacs -nw"
else
EDITOR=vi
fi

[ -n "$EDITOR" ] && export EDITOR

if which gdiff >/dev/null 2>&1; then
WXDIFFCMD='gdiff -u'
elif which diff >/dev/null 2>&1; then
WXDIFFCMD='diff -bw -U 5'
fi

[ -n "$WXDIFFCMD" ] && export WXDIFFCMD

user_sh_set_colorful_ls

user_sh_clear_env
