# ----
# .zshrc
# ilasie 2026
# inspired by:
#   The Rad Lectures @ YouTobe
# ----

# User configuration

# yazi
#function y() {
#  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
#  yazi "$@" --cwd-file="$tmp"
#  IFS= read -r -d '' cwd < "$tmp"
#  [ -n "$cwd" ] && [ "$cwd" != $PWD ] && builtin cd -- "$cwd"
#  rm -f -- "$tmp"
#}
#
# lf
alias lf='lfub'
# ----ilasie
# from /usr/share/doc/lf/examples/lfcd.sh
# ----
# Change working dir in shell to last dir in lf on exit (adapted from ranger).
#
# You need to either copy the content of this file to your shell rc file
# (e.g. ~/.bashrc) or source this file directly:
#
#     LFCD="/path/to/lfcd.sh"
#     if [ -f "$LFCD" ]; then
#         source "$LFCD"
#     fi
#
# You may also like to assign a key (Ctrl-O) to this command:
#
#     bind '"\C-o":"lfcd\C-m"'  # bash
#     bindkey -s '^o' 'lfcd\n'  # zsh
#
lfcd () {
    # `command` is needed in case `lfcd` is aliased to `lf`
    cd "$(command lfub -print-last-dir "$@")"
}
bindkey -s '^o' 'lfcd\n'
 
# cat
alias cat='batcat --color=always -p'

# Keymap
#
_copy_current_terminal_session() {
  alacritty --working-directory "$PWD" >/dev/null 2>&1 &
  disown
}
alias ,.=_copy_current_terminal_session

# Plugin
ZPLUGINDIR="$XDG_DATA_HOME/zsh/plugins"

_zplugin_load() {
  local plugin_path="${ZPLUGINDIR}/${2}"
  if [[ ! -d "$plugin_path" ]]; then
    mkdir -p "$ZPLUGINDIR"
    echo "Installing ${2}..."
    git clone --depth=1 "https://github.com/${1}/${2}" "$plugin_path" \
      || { echo "ERROR: failed to install ${2}" >&2; return 1; }
  fi
  source "${plugin_path}/${2}.plugin.zsh"
}

zplugin-update() {
  local dir
  for dir in ${ZPLUGINDIR}/*/; do
    echo "Updating ${dir:t}..."
    git -C "$dir" pull --ff-only
  done
}

_zplugin_load zdharma-continuum fast-syntax-highlighting
_zplugin_load zsh-users zsh-autosuggestions

_zplugin_load jeffreytse zsh-vi-mode
# desc:
# [ESC] / [C-[]: Enter NORMAL MODE
# [C-p]: Previous command in history
# [C-n]: Next command in history
# [/]: Search backward in history
# [n]: Repeat the last / 
ZVM_SYSTEN_CLIPBOARD_ENABLED=true

# _zplugin_load le0me55i zsh-extract
# TODO: use fork instead
extract() {
	local remove_archive
	local success
	local extract_dir

	if (( $# == 0 )); then
		cat <<-'EOF' >&2
			Usage: extract [-option] [file ...]

			Options:
			    -r, --remove    Remove archive after unpacking.
		EOF
	fi

	remove_archive=1
	if [[ "$1" == "-r" ]] || [[ "$1" == "--remove" ]]; then
		remove_archive=0
		shift
	fi

	while (( $# > 0 )); do
		if [[ ! -f "$1" ]]; then
			echo "extract: '$1' is not a valid file" >&2
			shift
			continue
		fi

		success=0
		extract_dir="${1:t:r}"
		case "${1:l}" in
			(*.tar.gz|*.tgz)
                (( $+commands[pigz] )) \
                && { pigz -dc "$1" | tar xv } \
                || tar zxvf "$1" ;;
			(*.tar.bz2|*.tbz|*.tbz2) tar xvjf "$1" ;;
			(*.tar.xz|*.txz)
				tar --xz --help &> /dev/null \
				&& tar --xz -xvf "$1" \
				|| xzcat "$1" | tar xvf - ;;
			(*.tar.zma|*.tlz)
				tar --lzma --help &> /dev/null \
				&& tar --lzma -xvf "$1" \
				|| lzcat "$1" | tar xvf - ;;
			(*.tar.zst|*.tzst)
				tar --zstd --help &> /dev/null \
				&& tar --zstd -xvf "$1" \
				|| zstdcat "$1" | tar xvf - ;;
			(*.tar) tar xvf "$1" ;;
			(*.tar.lz) (( $+commands[lzip] )) && tar xvf "$1" ;;
			(*.gz) (( $+commands[pigz] )) && pigz -dk "$1" || gunzip -k "$1" ;;
			(*.bz2) bunzip2 "$1" ;;
			(*.xz) unxz "$1" ;;
			(*.lzma) unlzma "$1" ;;
			(*.z) uncompress "$1" ;;
			(*.zip|*.war|*.jar|*.sublime-package|*.ipsw|*.xpi|*.apk|*.aar|*.whl)
                unzip "$1" -d $extract_dir ;;
			(*.rar) unar "$1" ;;
			(*.rpm)
                mkdir "$extract_dir" && \
                cd "$extract_dir" && \
                rpm2cpio "../$1" | cpio --quiet -id && \
                cd .. ;;
			(*.7z) 7za x "$1" ;;
			(*.deb)
				mkdir -p "$extract_dir/control"
				mkdir -p "$extract_dir/data"
				cd "$extract_dir"; ar vx "../${1}" > /dev/null
				cd control; tar xzvf ../control.tar.gz
				cd ../data; extract ../data.tar.*
				cd ..; rm *.tar.* debian-binary
				cd ..
			;;
			(*.zst) unzstd "$1" ;;
			(*)
				echo "extract: '$1' cannot be extracted" >&2
				success=1
			;;
		esac

		(( success = $success > 0 ? $success : $? ))
		(( $success == 0 )) && (( $remove_archive == 0 )) && rm "$1"
		shift
	done
}

# Plus

########## zoxide ##########
eval "$(zoxide init zsh)"

function zc() {
    __zoxide_doctor
    \builtin local result
    result="$(\command zoxide query --interactive -- "$@")" && nvim "${result}"
}

export _ZO_EXCLUDE_DIRS="/tmp:/var:/node_modules"

######### completion ##########

# ZSH_LOCAL_FPATH="$XDG_CONFIG_HOME/zsh/zsh-completions"
ZCOMP_DUMP="$XDG_DATA_HOME/zsh/zcompdump"
# 
# if [[ -d "$ZSH_LOCAL_FPATH" ]]; then
#     fpath=($ZSH_LOCAL_FPATH $fpath)
# fi

autoload -Uz compinit

if [[ -f "$ZCOMP_DUMP" ]] || {
    local -a recorded_fpath
    recorded_fpath=(${(z)"$(sed -n 's/^#fpath=//p' "$ZCOMP_DUMP")"})
    [[ "${recorded_fpath[*]}" != "${fpath[*]}" ]]
}; then
    compinit -d "$ZCOMP_DUMP"
else
    compinit -C -d "$ZCOMP_DUMP"
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

########## ls ##########

alias ls='eza --icons --git'
alias ll='eza -lh --icons --git'
alias la='eza -lah --icons --git'
alias tree='eza --tree --icons'

# use ls completions for eza
compdef eza=ls

########## grep ##########
alias grep='rg --color=auto'

########## diff ##########
alias diff='diff --color=auto'

########## fzf ##########
#source <(fzf --zsh)
#export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --strip-cwd-prefix'
#export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# prompt
#eval "$(starship init zsh)"

# allow using environment variables in the prompt
setopt prompt_subst

domain="%B%F{cyan}%n@%M%f%b"
dir="%B%F{blue}%1~%f%b"
colon="%(?.%F{green}.%F{red})%%%f "

# credits: https://salferrarello.com/zsh-git-status-prompt/
# -U: mark the function for autoloading and suppress alias expansion
# -z: use zsh style for function
autoload -Uz add-zsh-hook vcs_info
add-zsh-hook precmd vcs_info
# use '' to ensure dynamic environment variables
PROMPT='$domain:$dir%B%F{magenta}${vcs_info_msg_0_}%f%b$colon'

# Enable checking for (un)staged changes, enabling use of %u and %c
zstyle ':vcs_info:*' check-for-changes true
# Set custom strings for an unstaged vcs repo changes (*) and staged changes (+)
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
# Set the format of the Git information for vcs_info
#zstyle ':vcs_info:git:*' formats       '(%b%u%c)'
#zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'
