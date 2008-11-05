#!/usr/bin/sh +xv
#
# Conditional Variabls
#
# pragma ident   "%Z%%M% %I%     %E% SMI"
#
# Lin Ma
#
. $HOME/.prv/user_sh_include.sh

##
## User Python Library Path
##
# lr_set="
# $HOME/.local/lib/python2.4/site-packages
# /opt/onbld/lib/python/onbld
# "
# # Blank PYTHONPATH
# PYTHONPATH=`/usr/bin/python -E -c "import sys; print ':'.join(sys.path[1:])"`
# # Recreate PYTHONPATH
# for lr_itr in $lr_set; do
#     if [ -d $lr_itr ]; then
# 	if [ -n "$PYTHONPATH" ]; then
# 	    PYTHONPATH=$PYTHONPATH:$lr_itr
# 	else
# 	    PYTHONPATH=$lr_itr
# 	fi
#     fi
# done
# unset lr_itr
# unset lr_set

# export PYTHONPATH

alias blastwave="yes | pfexec pkgadd -d http://www.blastwave.org/pkg_get.pkg all"
alias stardict1="/home/lm161491/stardict-${USER_SH_MACH}/bin/stardict"

#
# ON bld and BFU
#
# alias installSUNWonbld="cd ${HOME}; \\
# rm -rf SUNWonbld; \\
# yes | pfexec pkgrm SUNWonbld; \\
# ssh onnv.sfbay \" \\
# cd /export/gate/public/packages/${USER_SH_MACH}; \\
# find SUNWonbld | cpio -o | gzip \" | \\
# gunzip -c | cpio -idm; \\
# yes | pfexec pkgadd -d . SUNWonbld;
# "
alias bfu="/ws/onnv-tools/onbld/bin/bfu"
alias update_nonON="/ws/onnv-gate/public/bin/update_nonON"
alias catkeyword="cat /net/wizard.eng/export/misc/general_docs/keyword_info.txt"
alias clsenv="source ${USER_SH_PRV_PATH}/cleanup-env.sh"

#
# Desktop CBE
#
alias cbe="${USER_SH_PRV_PATH}/cbe_jds_wrapper.sh"

umask 022
