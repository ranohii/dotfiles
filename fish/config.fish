#  https://fishshell.com/docs/current/index.html

set fish_greeting

# Environment variables - https://fishshell.com/docs/current/cmds/set.html
set -gx EDITOR 'nvim'
set -gx BUNDLER_EDITOR $EDITOR
set -gx MANPAGER 'less -X' # Don’t clear the screen after quitting a manual page
set -gx HOMEBREW_CASK_OPTS '--appdir=/Applications'
set -gx SOURCE_ANNOTATION_DIRECTORIES 'spec'
set -gx RUBY_CONFIGURE_OPTS '--with-opt-dir=/usr/local/opt/openssl:/usr/local/opt/readline:/usr/local/opt/libyaml:/usr/local/opt/gdbm'
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx DOTFILES "$HOME/dotfiles"
set -gx RIPGREP_CONFIG_PATH "$DOTFILES/ripgreprc"
set -gx HOST_NAME (scutil --get HostName)

# FZF specific - https://github.com/junegunn/fzf#key-bindings-for-command-line
set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --no-ignore-vcs'
set -gx FZF_DEFAULT_OPTS '--height 50% --layout=reverse --border'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -gx FZF_ALT_C_COMMAND 'fd --type d . --color=never'

fish_vi_key_bindings

if status is-interactive
  source $XDG_CONFIG_HOME/fish/abbreviations.fish

  # https://github.com/starship/starship#fish
  starship init fish | source

  # https://asdf-vm.com/#/core-manage-asdf-vm?id=add-to-your-shell
  source ~/.asdf/asdf.fish

  if test -e $DOTFILES/machines/$HOST_NAME/colors.fish
    source $DOTFILES/machines/$HOST_NAME/colors.fish
  end

  if test -e $DOTFILES/local/config.fish.local
    source $DOTFILES/local/config.fish.local
  end
end

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /Users/yudaihirano/.asdf/installs/nodejs/14.17.1/.npm/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.fish ]; and . /Users/yudaihirano/.asdf/installs/nodejs/14.17.1/.npm/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.fish
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /Users/yudaihirano/.asdf/installs/nodejs/14.17.1/.npm/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.fish ]; and . /Users/yudaihirano/.asdf/installs/nodejs/14.17.1/.npm/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.fish
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[ -f /Users/yudaihirano/.asdf/installs/nodejs/14.17.1/.npm/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.fish ]; and . /Users/yudaihirano/.asdf/installs/nodejs/14.17.1/.npm/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.fish
# pnpm
set -gx PNPM_HOME "/Users/yudaihirano/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/yudaihirano/google-cloud-sdk/path.fish.inc' ]; . '/Users/yudaihirano/google-cloud-sdk/path.fish.inc'; end
