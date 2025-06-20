# Peco-based utility functions

# Kill process with peco
function peco-kill() {
  ps aux | peco | awk '{print $2}' | xargs kill -9
}

# Git branch selector with peco
function peco-git-branch() {
  local branch=$(git branch -a | peco | sed 's/^\*//g' | awk '{print $1}')
  if [ -n "$branch" ]; then
    if [[ "$branch" =~ "remotes/" ]]; then
      local b=$(echo $branch | awk -F '/' '{print $3}')
      git checkout -b ${b} ${branch}
    else
      git checkout ${branch}
    fi
  fi
}

# Git add files with peco
function peco-git-add() {
  local files=$(git status --short | peco | awk '{print $2}')
  if [ -n "$files" ]; then
    echo $files | xargs git add
    git status --short
  fi
}

# SSH host selector with peco
function peco-ssh() {
  local host=$(grep -iE '^host[[:space:]]+[^*]' ~/.ssh/config | awk '{print $2}' | peco)
  if [ -n "$host" ]; then
    ssh $host
  fi
}

# Docker container selector with peco
function peco-docker-exec() {
  local container=$(docker ps | tail -n +2 | peco | awk '{print $1}')
  if [ -n "$container" ]; then
    docker exec -it $container /bin/bash
  fi
}

# Find file and open in editor with peco
function peco-find-file() {
  local file=$(find . -type f -name "*${1}*" | peco)
  if [ -n "$file" ]; then
    ${EDITOR:-vim} "$file"
  fi
}

# Search with ripgrep and open in editor with peco
function peco-rg() {
  if [ -z "$1" ]; then
    echo "Usage: peco-rg <search_pattern>"
    return 1
  fi
  local selected=$(rg --line-number "$1" | peco)
  if [ -n "$selected" ]; then
    local file=$(echo "$selected" | cut -d: -f1)
    local line=$(echo "$selected" | cut -d: -f2)
    ${EDITOR:-vim} "+$line" "$file"
  fi
}

# Change to recent directory with peco (requires cdr from oh-my-zsh)
function peco-recent-dirs() {
  if command -v cdr > /dev/null 2>&1; then
    local dir=$(cdr -l | sed 's/^[0-9]\+ \+//' | peco)
    if [ -n "$dir" ]; then
      cd "$dir"
    fi
  else
    echo "cdr command not found. Please ensure oh-my-zsh is installed with the cdr plugin."
  fi
}

# Change to ghq managed repository with peco
function peco-ghq() {
  local selected_dir=$(ghq list | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    cd "$(ghq root)/$selected_dir"
  fi
}