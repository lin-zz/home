#!/usr/bin/sh +xv
#
# Lin Ma
#

user_sh_clear_env() {
    unset \
	USER_SH_PRV_PATH	\
	USER_SH_MACH		\
	USER_SH_DOMAIN_NAME	\
	USER_SH_DOMAIN_SUFFIX_NAME

    unset \
	USER_SH_HOME_BIN_PATH_SET	\
	USER_SH_HIGH_PRIOR_BIN_PATH_SET	\
	USER_SH_MID_PRIOR_BIN_PATH_SET	\
	USER_SH_LOW_PRIOR_BIN_PATH_SET	\
	USER_SH_HIGH_PRIOR_STANDARD_BIN_PATH_SET	\
	USER_SH_LOW_PRIOR_STANDARD_BIN_PATH_SET	\
	USER_SH_COMPILER_BIN_PATH_SET
}

user_sh_set_env() {
    if [ -z "$USER_SH_PRV_PATH" ]; then
	USER_SH_PRV_PATH=$HOME/.prv
	export USER_SH_PRV_PATH
    fi
    
    if [ -z "$USER_SH_MACH" ]; then 
	if [ -n "$MACHTYPE" ]; then
	    USER_SH_MACH=$MACHTYPE
	elif [ -n "$HOSTTYPE" ]; then
	    USER_SH_MACH=$HOSTTYPE
	else
	    USER_SH_MACH=`/usr/bin/uname -p`
	fi
	export USER_SH_MACH
    fi

    USER_SH_HOME_BIN_PATH_SET="$HOME/bin"
    USER_SH_HIGH_PRIOR_BIN_PATH_SET=""
    USER_SH_MID_PRIOR_BIN_PATH_SET="/opt/xemacs/bin"
    USER_SH_LOW_PRIOR_BIN_PATH_SET="/opt/teamware/bin"
    USER_SH_HIGH_PRIOR_STANDARD_BIN_PATH_SET="/usr/bin
/bin
/usr/sbin
/sbin
"
    USER_SH_LOW_PRIOR_STANDARD_BIN_PATH_SET="/usr/gnu/bin
/usr/gnu/sbin
/usr/sfw/bin
/usr/sfw/sbin
/opt/dtbld/bin
/opt/jdsbld/bin
/opt/onbld/bin
/usr/X11/bin
/usr/local/bin
/usr/local/sbin
"
    USER_SH_COMPILER_BIN_PATH_SET="/opt/SUNWspro/SS11/bin"

    export \
	USER_SH_HOME_BIN_PATH_SET	\
	USER_SH_HIGH_PRIOR_BIN_PATH_SET	\
	USER_SH_MID_PRIOR_BIN_PATH_SET	\
	USER_SH_LOW_PRIOR_BIN_PATH_SET	\
	USER_SH_HIGH_PRIOR_STANDARD_BIN_PATH_SET	\
	USER_SH_LOW_PRIOR_STANDARD_BIN_PATH_SET	\
	USER_SH_COMPILER_BIN_PATH_SET
}

#
# The 1st arg could be 0 or 1, which means prepend or append to PATH
# The rest args are pathes.
#
user_sh_compose_path() {
    if [ $# -lt 2 ]; then
	return 0
    fi

    lv_pos=$1
    shift

    if [ -z "$PATH" ]; then
	PATH=$1
	shift
	
	# Platform specific path is in the front if there has
	[ -d $PATH/$USER_SH_MACH ] && \
	    PATH=$PATH/$USER_SH_MACH:$PATH
    fi

    lv_set=$*

    for lv_itr in $lv_set; do
	if [ -d $lv_itr ]; then
	    # Platform specific path is in the front if there has
	    [ -d $lv_itr/$USER_SH_MACH ] && \
		lv_itr=$lv_itr/$USER_SH_MACH:$lv_itr

	    if [ x"$lv_pos" = x"0" ]; then
		PATH=$lv_itr:$PATH
	    else
		PATH=$PATH:$lv_itr
	    fi
	fi
    done

    unset \
	lv_pos	\
	lv_itr	\
	lv_set
}

#
# The 1st arg could be 0 or 1, which means prepend or append to PATH
# The rest args are pathes. The function will immediately return
# if it finds a valid path from the set.
#
user_sh_choose_path() {
    if [ $# -lt 2 ]; then
	return 0
    fi

    lv_pos=$1
    shift

    if [ -z "$PATH" ]; then
	PATH=$1
	shift

	# Platform specific path is in the front if there has
	[ -d $PATH/$USER_SH_MACH ] && \
	    PATH=$PATH/$USER_SH_MACH:$PATH
    fi

    lv_set=$*

    for lv_itr in $lv_set; do
	if [ -d $lv_itr ]; then
	    # Platform specific path is in the front if there has
	    [ -d $lv_itr/$USER_SH_MACH ] && \
		lv_itr=$lv_itr/$USER_SH_MACH:$lv_itr

	    if [ x"$lv_pos" = x"0" ]; then
		PATH=$lv_itr:$PATH
	    else
		PATH=$PATH:$lv_itr
	    fi

	    unset \
		lv_pos	\
		lv_itr	\
		lv_set

	    return 0
	fi
    done

    unset \
	lv_pos	\
	lv_itr	\
	lv_set

    return 1
}

user_sh_domain_name_init() {
    if [ -z "$USER_SH_DOMAIN_NAME" ]; then
	USER_SH_DOMAIN_NAME=`LANG=C; export LANG; LC_ALL=C; export LC_ALL; \
/usr/bin/domainname | /usr/bin/cut -f2 -d . | /usr/bin/tr -s '[:upper:]' '[:lower:]'`
	case "$USER_SH_DOMAIN_NAME" in
	"eng" | "sfbay" )
		USER_SH_DOMAIN_SUFFIX_NAME=""
		;;
	* )
		USER_SH_DOMAIN_SUFFIX_NAME="-$USER_SH_DOMAIN_NAME"
		;;
	esac
	
	export \
	    USER_SH_DOMAIN_NAME	\
	    USER_SH_DOMAIN_SUFFIX_NAME
    fi
}

user_sh_set_colorful_ls() {
    lv_set="
/usr/gnu/bin/ls
/opt/dtbld/bin/ls
/opt/jdsbld/bin/ls
"
    for lv_itr in ${lv_set}; do
	if [ -x ${lv_itr} ]; then
	    alias ls="${lv_itr} --color=auto"
	    alias ll="${lv_itr} --color=auto -l"
	    alias la="${lv_itr} --color=auto -la"
	    break
	fi
    done
    unset \
	lv_itr	\
	lv_set
}

#
# Default Variables
#
user_sh_set_env

#
# Test
#
# PATH=""
# user_sh_compose_path 1 $USER_SH_HIGH_PRIOR_BIN_PATH_SET
# user_sh_compose_path 1 $USER_SH_HIGH_PRIOR_STANDARD_BIN_PATH_SET
# user_sh_compose_path 1 $USER_SH_MID_PRIOR_BIN_PATH_SET
# user_sh_compose_path 1 $USER_SH_COMPILER_BIN_PATH_SET
# user_sh_compose_path 1 $USER_SH_LOW_PRIOR_STANDARD_BIN_PATH_SET
# user_sh_compose_path 1 $USER_SH_LOW_PRIOR_BIN_PATH_SET
# user_sh_clear_env
