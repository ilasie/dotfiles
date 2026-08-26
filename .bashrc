export SSL_CERT_FILE="$PREFIX/etc/tls/cert.pem"

if [[ -d "$HOME/.bashrc.d" ]]; then
    for rc in "$HOME/.bashrc.d/"*.sh; do
	[[ -r "$rc" ]] && source "$rc"
    done
    unset rc
fi

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_OPTIONAL_LOCKS=0

__local_prompt_command() {
    local p="${PWD/#$HOME/\~}"
    if [[ "$p" == "/" || "$p" == "~" ]]; then
	local __local_prompt_pwd="$p"
    else
	local parent="${p%/*}"
	local grand="${parent%/*}"
	if [[ -n "$grand" ]]; then
	    local __local_prompt_pwd="${p#"$grand/"}"
	else
	    local __local_prompt_pwd="$p"
	fi
    fi

    __git_ps1 "\[\e[32m\]${__local_prompt_pwd}\[\e[33m\]" "\[\e[0m\] \$ " " (%s)"
}
PROMPT_COMMAND="__local_prompt_command"

# vim: set sw=4 :
