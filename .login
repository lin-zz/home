## .login - Lin Ma ( Lin.Ma@Sun.COM )

# setenv TERM `tset -Q -`
umask 077

if ( ! $?prompt ) then
	set prompt = %#
endif

set history = 200
set savehist = 200

