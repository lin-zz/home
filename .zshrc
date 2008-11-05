#!/usr/bin/zsh
## .zshrc - Lin Ma ( Lin.Ma@Sun.COM )

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

    PS1="%n@%m%# "
fi
. $HOME/.prv/global-rc.sh

case ${TERM} in
xterm | dtterm )
#	preexec () { print -Pn "]0;%n@%m:%1~" }
	chpwd() { print -Pn "]0;%n@%m:%1~" }
	;;
emacs | dumb )
	unalias ls
	unalias ll
	unalias la
	;;
* )
	print ${TERM}
	;;
esac

###############################################################################
## Zsh settings
##
bindkey -e

#autoload -U compinit
autoload -U select-word-style
select-word-style bash

#compinit

#setopt autocd autopushd
unsetopt	AUTO_MENU
setopt		RM_STAR_SILENT
[[ $EMACS = t ]] && unsetopt zle

