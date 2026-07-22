export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Expend the $PATH to allow syntax highlighting
for _d in /usr/sbin /sbin /usr/local/sbin ; do
  if [[ -d "$_d" && ":$PATH:" != *":$_d:"* ]]; then
    export PATH="$_d:$PATH"
  fi
done
unset _d

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=zh_CN.UTF-8
export LC_MESSAGE=zh.CN.UTF-8
export LANGUAGE=zh_CN:en_GB

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set proxy for rustup
export RUSTUP_DIST_SERVER=https://rsproxy.cn
export RUSTUP_UPDATE_ROOT=https://rsproxy.cn/rustup

# Set mirrors for lean
export LEAN_UPSTREAM=https://mirrors.sjtug.edu.cn/lean4/

# Set PATH for rust
source $HOME/.cargo/env

# Set PATH for python
case ":${PATH}:" in
  *:"$HOME/.pixi/bin":*)
      ;;
  *)
      export PATH="$HOME/.pixi/bin:$PATH"
      ;;
esac

# Set PATH for local binaries
case ":${PATH}:" in
  *:"$HOME/.local/bin":*)
      ;;
  *)
      export PATH="$HOME/.local/bin:$PATH"
      ;;
esac
