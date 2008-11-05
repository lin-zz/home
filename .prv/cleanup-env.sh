lv_env_set=$( /usr/bin/env | /usr/bin/cut -f1 -d= )
for lv_var in ${lv_env_set}
do
	case ${lv_var} in
		PS1|PS2|HZ|TERM|SHELL|OLDPWD|PATH|MAIL|PWD|TZ|SHLVL|HOME|LOGNAME|HOSTNAME|_|EDITOR|SSH_*|DISPLAY|LESS*|LS_COLORS|LS_OPTIONS|TERMINFO|MANPATH)
		;;
	*)
		unset ${lv_var}
		;;
	esac
done

unset lv_env_set lv_var
umask 022
