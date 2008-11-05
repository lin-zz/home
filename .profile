## .profile - Lin Ma < Lin.Ma@Sun.COM >
#set -xv

if [ -z "$CBE_JDS_ENV" ]; then
    . $HOME/.prv/profile.sh

    if [ `/usr/bin/svcs -H -o state nis/client 2>/dev/null` = "online" ]; then
	. $HOME/.prv/remote-rc.sh
    fi

fi
