#@auth ilasie
#@date 05/06/2026

#@credits:
#- The Rad Lectures

# User configuration

# yazi
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != $PWD ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}
#
# lf
#alias lf='lfub'
# 
# cat
alias cat='batcat -p'

# Keymap
#
function copy_current_terminal() {
  alacritty --working-directory "$PWD" >/dev/null 2>&1 &
  disown
}
alias ,.=copy_current_terminal


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
_zplugin_load le0me55i zsh-extract

# Plus
#
eval "$(zoxide init zsh)"

autoload -Uz compinit

compinit -d "$XDG_DATA_HOME/zsh/zcompdump"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# ls

alias ls='eza --icons --git'
alias ll='eza -lh --icons --git'
alias la='eza -lah --icons --git'
alias tree='eza --tree --icons'

# use ls completions for eza
compdef eza=ls

#grep
alias grep='rg --color=auto'

#diff
alias diff='diff --color=auto'

#fzf
export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# prompt
eval "$(starship init zsh)"
