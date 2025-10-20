HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history 
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

export ZSH="$HOME/.oh-my-zsh"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting ssh)

source $ZSH/oh-my-zsh.sh

if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi

eval "$(oh-my-posh init zsh --config ~/.poshthemes/tj-dracula.omp.json)"

source ~/scripts/zsh-syntax-highlighting.sh

export PATH="$PATH:~/.local/bin"

export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
# Dracula theme for Docker BuildKit - https://draculatheme.com/docker
export BUILDKIT_COLORS="run=189,147,249:cancel=241,250,140:error=255,85,85:warning=241,250,140"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export XDG_DATA_DIRS="/home/linuxbrew/.linuxbrew/share:$XDG_DATA_DIRS"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

. /usr/share/doc/fzf/examples/key-bindings.zsh

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --icons --color=always {} | head -200; else batcat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --icons --color=always {} | head -200'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --icons --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

export PATH="$PATH:$HOME/.local/bin"
export EDITOR=nvim
export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable
export PATH="$PATH:$HOME/Development/flutter/bin"
export TERM=xterm-256color
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
eval "$(zoxide init zsh)"
export PATH=$PATH:/home/tarcisio/.spicetify
export PATH="$PATH:$HOME/Development/kitty/kitty/launcher/"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"
export PATH="$HOME/.asdf/shims:$HOME/.asdf/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/home/tarcisio/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
# else
#    if [ -f "/home/tarcisio/miniconda3/etc/profile.d/conda.sh" ]; then
#        . "/home/tarcisio/miniconda3/etc/profile.d/conda.sh"
#    else
#        export PATH="/home/tarcisio/miniconda3/bin:$PATH"
#    fi
# fi
# unset __conda_setup
# <<< conda initialize <<<


# bun completions
[ -s "/home/tarcisio/.local/share/reflex/bun/_bun" ] && source "/home/tarcisio/.local/share/reflex/bun/_bun"

# bun
export BUN_INSTALL="$HOME/.local/share/reflex/bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# opencode
export PATH=/home/tarcisio/.opencode/bin:$PATH
