#!/usr/bin/zsh
## .zshenv - Lin Ma < Lin.Ma@Sun.COM >

# Split word like BASH
setopt SH_WORD_SPLIT

if [[ -z "$CBE_JDS_ENV" ]]; then
    . $HOME/.prv/profile.sh

    if [[ $( /usr/bin/svcs -H -o state nis/client 2>/dev/null ) == "online" ]]; then
	. $HOME/.prv/remote-rc.sh
    fi

    PS1="%n@%m%# "
fi

HISTFILE=$HOME/.histfile
HISTSIZE=1000
SAVEHIST=1000
