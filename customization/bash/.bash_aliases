# Terminal Tools
alias bat='batcat --theme="Dracula"'
alias cls='clear'
alias eza='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions'
alias glow='glow -p'
alias ls='logo-ls -1'
alias tree='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --tree'
alias weather='curl wttr.in'

# Languages
alias py='python3'

# Net Tools
alias ipconfig='ifconfig'

# ZSH
alias edit-bash="nvim ~/.bashrc"
alias reload-bash="source ~/.bashrc"

# Virtualbox
alias ssh_server="ssh serveruser@192.168.2.210"
alias start_server="VBoxManage startvm UbuntuServer"
alias show_nvim_keybinds="glow ~/.config/nvim/key_commands.md"
