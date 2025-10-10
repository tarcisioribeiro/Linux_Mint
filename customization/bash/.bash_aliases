alias cat='batcat --theme="Dracula"'
alias cls='clear'
alias eza='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions'
alias glow='glow -p'
alias ls='logo-ls -1'
alias lg='lazygit'
alias tree='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --tree'
alias weather='curl wttr.in'
alias py='python3'
alias ipconfig='ifconfig'
alias edit-bash="nvim ~/.bashrc"
alias reload-bash="source ~/.bashrc"
alias show_nvim_keybinds="glow ~/.config/nvim/key_commands.md"
alias show_i3-keybinds="glow ~/repos/Ubuntu/README.md"
alias launch_avd="~/Android/Sdk/emulator/emulator -avd Pixel -gpu host"
alias show_aliases='batcat --theme="Dracula" --language .bash_aliases $HOME/.bash_aliases'

alias dps='docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
