#!/bin/sh
USER=${USER:-$(id -u -n)}

HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"

HOME="${HOME:-$(eval echo ~$USER)}"

custom_zsh=${ZSH:+yes}

zdot="${ZDOTDIR:-$HOME}"

if [ -n "$ZDOTDIR" ] && [ "$ZDOTDIR" != "$HOME" ]; then
  ZSH="${ZSH:-$ZDOTDIR/ohmyzsh}"
fi
ZSH="${ZSH:-$HOME/.oh-my-zsh}"

REPO=${REPO:-ohmyzsh/ohmyzsh}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-master}

CHSH=${CHSH:-yes}
RUNZSH=${RUNZSH:-yes}
KEEP_ZSHRC=${KEEP_ZSHRC:-no}

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

user_can_sudo() {
  command_exists sudo || return 1
  case "$PREFIX" in
  *com.termux*) return 1 ;;
  esac
  ! LANG= sudo -n -v 2>&1 | grep -q "may not run sudo"
}

if [ -t 1 ]; then
  is_tty() {
    true
  }
else
  is_tty() {
    false
  }
fi

supports_hyperlinks() {

  if [ -n "$FORCE_HYPERLINK" ]; then
    [ "$FORCE_HYPERLINK" != 0 ]
    return $?
  fi

  is_tty || return 1

  if [ -n "$DOMTERM" ]; then
    return 0
  fi

  if [ -n "$VTE_VERSION" ]; then
    [ $VTE_VERSION -ge 5000 ]
    return $?
  fi

  case "$TERM_PROGRAM" in
  Hyper | iTerm.app | terminology | WezTerm | vscode) return 0 ;;
  esac

  case "$TERM" in
  xterm-kitty | alacritty | alacritty-direct) return 0 ;;
  esac

  if [ "$COLORTERM" = "xfce4-terminal" ]; then
    return 0
  fi

  if [ -n "$WT_SESSION" ]; then
    return 0
  fi

  return 1
}

supports_truecolor() {
  case "$COLORTERM" in
  truecolor | 24bit) return 0 ;;
  esac

  case "$TERM" in
  iterm | \
    tmux-truecolor | \
    linux-truecolor | \
    xterm-truecolor | \
    screen-truecolor) return 0 ;;
  esac

  return 1
}

fmt_link() {
  
  if supports_hyperlinks; then
    printf '\033]8;;%s\033\\%s\033]8;;\033\\\n' "$2" "$1"
    return
  fi

  case "$3" in
  --text) printf '%s\n' "$1" ;;
  --url | *) fmt_underline "$2" ;;
  esac
}

fmt_underline() {
  is_tty && printf '\033[4m%s\033[24m\n' "$*" || printf '%s\n' "$*"
}

fmt_code() {
  is_tty && printf '`\033[2m%s\033[22m`\n' "$*" || printf '`%s`\n' "$*"
}

fmt_error() {
  printf '%sError: %s%s\n' "${FMT_BOLD}${FMT_RED}" "$*" "$FMT_RESET" >&2
}

setup_color() {
  if ! is_tty; then
    FMT_RAINBOW=""
    FMT_RED=""
    FMT_GREEN=""
    FMT_YELLOW=""
    FMT_BLUE=""
    FMT_BOLD=""
    FMT_RESET=""
    return
  fi

  if supports_truecolor; then
    FMT_RAINBOW="
      $(printf '\033[38;2;255;0;0m')
      $(printf '\033[38;2;255;97;0m')
      $(printf '\033[38;2;247;255;0m')
      $(printf '\033[38;2;0;255;30m')
      $(printf '\033[38;2;77;0;255m')
      $(printf '\033[38;2;168;0;255m')
      $(printf '\033[38;2;245;0;172m')
    "
  else
    FMT_RAINBOW="
      $(printf '\033[38;5;196m')
      $(printf '\033[38;5;202m')
      $(printf '\033[38;5;226m')
      $(printf '\033[38;5;082m')
      $(printf '\033[38;5;021m')
      $(printf '\033[38;5;093m')
      $(printf '\033[38;5;163m')
    "
  fi

  FMT_RED=$(printf '\033[31m')
  FMT_GREEN=$(printf '\033[32m')
  FMT_YELLOW=$(printf '\033[33m')
  FMT_BLUE=$(printf '\033[34m')
  FMT_BOLD=$(printf '\033[1m')
  FMT_RESET=$(printf '\033[0m')
}

setup_ohmyzsh() {
  umask g-w,o-w

  echo "${FMT_BLUE}Cloning Oh My Zsh...${FMT_RESET}"

  command_exists git || {
    fmt_error "git is not installed"
    exit 1
  }

  ostype=$(uname)
  if [ -z "${ostype%CYGWIN*}" ] && git --version | grep -Eq 'msysgit|windows'; then
    fmt_error "Windows/MSYS Git is not supported on Cygwin"
    fmt_error "Make sure the Cygwin git package is installed and is first on the \$PATH"
    exit 1
  fi

  git init --quiet "$ZSH" && cd "$ZSH" &&
    git config core.eol lf &&
    git config core.autocrlf false &&
    git config fsck.zeroPaddedFilemode ignore &&
    git config fetch.fsck.zeroPaddedFilemode ignore &&
    git config receive.fsck.zeroPaddedFilemode ignore &&
    git config oh-my-zsh.remote origin &&
    git config oh-my-zsh.branch "$BRANCH" &&
    git remote add origin "$REMOTE" &&
    git fetch --depth=1 origin &&
    git checkout -b "$BRANCH" "origin/$BRANCH" || {
    [ ! -d "$ZSH" ] || {
      cd -
      rm -rf "$ZSH" 2>/dev/null
    }
    fmt_error "git clone of oh-my-zsh repo failed"
    exit 1
  }
  cd -

  echo
}

setup_zshrc() {
  echo "${FMT_BLUE}Looking for an existing zsh config...${FMT_RESET}"

  OLD_ZSHRC="$zdot/.zshrc.pre-oh-my-zsh"
  if [ -f "$zdot/.zshrc" ] || [ -h "$zdot/.zshrc" ]; then
    if [ "$KEEP_ZSHRC" = yes ]; then
      echo "${FMT_YELLOW}Found ${zdot}/.zshrc.${FMT_RESET} ${FMT_GREEN}Keeping...${FMT_RESET}"
      return
    fi
    if [ -e "$OLD_ZSHRC" ]; then
      OLD_OLD_ZSHRC="${OLD_ZSHRC}-$(date +%Y-%m-%d_%H-%M-%S)"
      if [ -e "$OLD_OLD_ZSHRC" ]; then
        fmt_error "$OLD_OLD_ZSHRC exists. Can't back up ${OLD_ZSHRC}"
        fmt_error "re-run the installer again in a couple of seconds"
        exit 1
      fi
      mv "$OLD_ZSHRC" "${OLD_OLD_ZSHRC}"

      echo "${FMT_YELLOW}Found old .zshrc.pre-oh-my-zsh." \
        "${FMT_GREEN}Backing up to ${OLD_OLD_ZSHRC}${FMT_RESET}"
    fi
    echo "${FMT_YELLOW}Found ${zdot}/.zshrc.${FMT_RESET} ${FMT_GREEN}Backing up to ${OLD_ZSHRC}${FMT_RESET}"
    mv "$zdot/.zshrc" "$OLD_ZSHRC"
  fi

  echo "${FMT_GREEN}Using the Oh My Zsh template file and adding it to $zdot/.zshrc.${FMT_RESET}"

  omz="$ZSH"
  if [ -n "$ZDOTDIR" ] && [ "$ZDOTDIR" != "$HOME" ]; then
    omz=$(echo "$omz" | sed "s|^$ZDOTDIR/|\$ZDOTDIR/|")
  fi
  omz=$(echo "$omz" | sed "s|^$HOME/|\$HOME/|")

  sed "s|^export ZSH=.*$|export ZSH=\"${omz}\"|" "$ZSH/templates/zshrc.zsh-template" >"$zdot/.zshrc-omztemp"
  mv -f "$zdot/.zshrc-omztemp" "$zdot/.zshrc"

  echo
}

setup_shell() {
  if [ "$CHSH" = no ]; then
    return
  fi
  if [ "$(basename -- "$SHELL")" = "zsh" ]; then
    return
  fi

  if ! command_exists chsh; then
    cat <<EOF
I can't change your shell automatically because this system does not have chsh.
${FMT_BLUE}Please manually change your default shell to zsh${FMT_RESET}
EOF
    return
  fi

  echo "${FMT_BLUE}Time to change your default shell to zsh:${FMT_RESET}"

  printf '%sDo you want to change your default shell to zsh? [Y/n]%s ' \
    "$FMT_YELLOW" "$FMT_RESET"
  read -r opt
  case $opt in
  y* | Y* | "") ;;
  n* | N*)
    echo "Shell change skipped."
    return
    ;;
  *)
    echo "Invalid choice. Shell change skipped."
    return
    ;;
  esac

  case "$PREFIX" in
  *com.termux*)
    termux=true
    zsh=zsh
    ;;
  *) termux=false ;;
  esac

  if [ "$termux" != true ]; then
    if [ -f /etc/shells ]; then
      shells_file=/etc/shells
    elif [ -f /usr/share/defaults/etc/shells ]; then
      shells_file=/usr/share/defaults/etc/shells
    else
      fmt_error "could not find /etc/shells file. Change your default shell manually."
      return
    fi

    if ! zsh=$(command -v zsh) || ! grep -qx "$zsh" "$shells_file"; then
      if ! zsh=$(grep '^/.*/zsh$' "$shells_file" | tail -n 1) || [ ! -f "$zsh" ]; then
        fmt_error "no zsh binary found or not present in '$shells_file'"
        fmt_error "change your default shell manually."
        return
      fi
    fi
  fi

  if [ -n "$SHELL" ]; then
    echo "$SHELL" >"$zdot/.shell.pre-oh-my-zsh"
  else
    grep "^$USER:" /etc/passwd | awk -F: '{print $7}' >"$zdot/.shell.pre-oh-my-zsh"
  fi

  echo "Changing your shell to $zsh..."

  if user_can_sudo; then
    sudo -k chsh -s "$zsh" "$USER"
  else
    chsh -s "$zsh" "$USER"
  fi

  if [ $? -ne 0 ]; then
    fmt_error "chsh command unsuccessful. Change your default shell manually."
  else
    export SHELL="$zsh"
    echo "${FMT_GREEN}Shell successfully changed to '$zsh'.${FMT_RESET}"
  fi

  echo
}

print_success() {
  printf '%s         %s__      %s           %s        %s       %s     %s__   %s\n' $FMT_RAINBOW $FMT_RESET
  printf '%s  ____  %s/ /_    %s ____ ___  %s__  __  %s ____  %s_____%s/ /_  %s\n' $FMT_RAINBOW $FMT_RESET
  printf '%s / __ \\%s/ __ \\  %s / __ `__ \\%s/ / / / %s /_  / %s/ ___/%s __ \\ %s\n' $FMT_RAINBOW $FMT_RESET
  printf '%s/ /_/ /%s / / / %s / / / / / /%s /_/ / %s   / /_%s(__  )%s / / / %s\n' $FMT_RAINBOW $FMT_RESET
  printf '%s\\____/%s_/ /_/ %s /_/ /_/ /_/%s\\__, / %s   /___/%s____/%s_/ /_/  %s\n' $FMT_RAINBOW $FMT_RESET
  printf '%s    %s        %s           %s /____/ %s       %s     %s          %s....is now installed!%s\n' $FMT_RAINBOW $FMT_GREEN $FMT_RESET
  printf '\n'
  printf '\n'
  printf "%s %s %s\n" "Before you scream ${FMT_BOLD}${FMT_YELLOW}Oh My Zsh!${FMT_RESET} look over the" \
    "$(fmt_code "$(fmt_link ".zshrc" "file://$zdot/.zshrc" --text)")" \
    "file to select plugins, themes, and options."
  printf '\n'
  printf '%s\n' "• Follow us on X: $(fmt_link @ohmyzsh https://x.com/ohmyzsh)"
  printf '%s\n' "• Join our Discord community: $(fmt_link "Discord server" https://discord.gg/ohmyzsh)"
  printf '%s\n' "• Get stickers, t-shirts, coffee mugs and more: $(fmt_link "Planet Argon Shop" https://shop.planetargon.com/collections/oh-my-zsh)"
  printf '%s\n' $FMT_RESET
}

main() {
  if [ ! -t 0 ]; then
    RUNZSH=no
    CHSH=no
  fi
  
  while [ $# -gt 0 ]; do
    case $1 in
    --unattended)
      RUNZSH=no
      CHSH=no
      ;;
    --skip-chsh) CHSH=no ;;
    --keep-zshrc) KEEP_ZSHRC=yes ;;
    esac
    shift
  done

  setup_color

  if ! command_exists zsh; then
    echo "${FMT_YELLOW}Zsh is not installed.${FMT_RESET} Please install zsh first."
    exit 1
  fi

  if [ -d "$ZSH" ]; then
    echo "${FMT_YELLOW}The \$ZSH folder already exists ($ZSH).${FMT_RESET}"
    if [ "$custom_zsh" = yes ]; then
      cat <<EOF

You ran the installer with the \$ZSH setting or the \$ZSH variable is
exported. You have 3 options:

1. Unset the ZSH variable when calling the installer:
   $(fmt_code "ZSH= sh install.sh")
2. Install Oh My Zsh to a directory that doesn't exist yet:
   $(fmt_code "ZSH=path/to/new/ohmyzsh/folder sh install.sh")
3. (Caution) If the folder doesn't contain important information,
   you can just remove it with $(fmt_code "rm -r $ZSH")

EOF
    else
      echo "You'll need to remove it if you want to reinstall."
    fi
    exit 1
  fi

  if [ -n "$ZDOTDIR" ]; then
    mkdir -p "$ZDOTDIR"
  fi

  setup_ohmyzsh
  setup_zshrc
  setup_shell

  print_success

  if [ $RUNZSH = no ]; then
    echo "${FMT_YELLOW}Run zsh to try it out.${FMT_RESET}"
    exit
  fi

  echo "Instalação concluída."
}

main "$@"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting