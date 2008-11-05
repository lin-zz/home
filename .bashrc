#!/bin/bash
## .bashrc - Lin Ma < Lin.Ma@Sun.COM >

###############################################################################
## OS specific
##
case ${OSTYPE} in
solaris* )
	;;

linux* )
	;;
esac

if [[ -z "$CBE_JDS_ENV" ]]; then

    . $HOME/.prv/rc.sh

    PS1="\u@\h\$ "
fi
. $HOME/.prv/global-rc.sh

case ${TERM} in
xterm | dtterm )
	PROMPT_COMMAND='echo -n "]0;${LOGNAME}@${HOSTNAME}:${PWD}"' 
	;;
emacs | dumb )
	unalias ls
	unalias ll
	unalias la
	;;
* )
	printf "%s\n" ${TERM}
	;;
esac
