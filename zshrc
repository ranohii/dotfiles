# ~/.zshrc
. $HOME/dotfiles/zsh/profiler.start

export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.yarn/bin
export EDITOR="nvim"
export BUNDLER_EDITOR=$EDITOR
export MANPAGER="less -X" # Don’t clear the screen after quitting a manual page
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export SOURCE_ANNOTATION_DIRECTORIES="spec"
export DISABLE_AUTO_TITLE=true
export _Z_OWNER=$USER
export ZSH_DISABLE_COMPFIX=true
export RUBY_CONFIGURE_OPTS="--with-opt-dir=/usr/local/opt/openssl:/usr/local/opt/readline:/usr/local/opt/libyaml:/usr/local/opt/gdbm"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export DOTFILES="$HOME/dotfiles"
HOST_NAME=$(scutil --get HostName)
export HOST_NAME

# Locale settings
export LANG="ja_JP.UTF-8"
export LC_ALL="ja_JP.UTF-8"

. $DOTFILES/zsh/oh-my-zsh
. $DOTFILES/zsh/opts
. $DOTFILES/zsh/aliases
# . $DOTFILES/zsh/prompt  # Disabled in favor of starship
. $DOTFILES/zsh/tmux
. $DOTFILES/zsh/functions
. $DOTFILES/zsh/z.sh
. $DOTFILES/zsh/ranger.sh

# Load peco functions if peco is installed
if command -v peco > /dev/null 2>&1; then
  . $DOTFILES/zsh/peco-functions.zsh
fi

cdpath=($HOME/code $DOTFILES $HOME/Developer $HOME/Sites $HOME/Dropbox $HOME)

HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history
HIST_STAMPS="yyyy-mm-dd"

# asdf
. $HOME/.asdf/asdf.sh
# Load asdf completions for zsh if available, otherwise skip bash completions
if [[ -f $HOME/.asdf/completions/_asdf ]]; then
  fpath=(${ASDF_DIR}/completions $fpath)
  autoload -Uz compinit && compinit
fi

# Use vi mode
bindkey -v

# Vi mode settings
# Better searching in command mode
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward

# Beginning search with arrow keys
bindkey "^[OA" up-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

# Visual mode for zsh
bindkey -M vicmd v visual-mode

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

# FZF settings - migrated from fish config
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs'
export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --border'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_ALT_C_COMMAND='fd --type d . --color=never'

# Peco configuration
if command -v peco > /dev/null 2>&1; then
  # History search with peco (Ctrl+R)
  function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r | peco --query "$LBUFFER"`
    CURSOR=$#BUFFER
    zle reset-prompt
  }
  zle -N peco-history-selection
  bindkey '^r' peco-history-selection

  # Directory navigation with peco
  function peco-cdr () {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | peco)
    if [ -n "$selected_dir" ]; then
      BUFFER="cd ${selected_dir}"
      zle accept-line
    fi
    zle clear-screen
  }
  zle -N peco-cdr
  bindkey '^x^d' peco-cdr

  # ghq repository navigation with peco
  function peco-ghq-widget() {
    local selected_dir=$(ghq list | peco --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
      BUFFER="cd $(ghq root)/$selected_dir"
      zle accept-line
    fi
    zle clear-screen
  }
  zle -N peco-ghq-widget
  bindkey '^g' peco-ghq-widget
fi

# RIPGREP config
export RIPGREP_CONFIG_PATH="$DOTFILES/ripgreprc"

# Travis CI
[ -f ~/.travis/travis.sh ] && . ~/.travis/travis.sh

# Include local settings
[[ -f ~/.zshrc.local ]] && . ~/.zshrc.local

# Initialize starship prompt
if command -v starship > /dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Fish-like syntax highlighting and autosuggestions
if [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  # Fish-like autosuggestion colors
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
  # Enable autosuggestion strategy
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

# Better completion system
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

. $HOME/dotfiles/zsh/profiler.stop

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
