#!/usr/bin/bash
## .bash_profile - Lin Ma < Lin.Ma@Sun.COM >

if [[ -z "$CBE_JDS_ENV" ]]; then
    source $HOME/.prv/profile.sh

    if [[ $( /usr/bin/svcs -H -o state nis/client 2>/dev/null ) == "online" ]]; then
	source $HOME/.prv/remote-rc.sh
    fi

    PS1="\u@\h\$ "
fi
