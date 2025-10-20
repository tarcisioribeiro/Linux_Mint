# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a comprehensive Linux Mint/Ubuntu/Debian desktop environment configuration repository using i3 window manager with customized dotfiles, scripts, and automation tools. The setup provides a complete desktop environment with i3-gaps, polybar, rofi, and various utilities managed through GNU Stow.

## Architecture

### Configuration Management with Stow

The repository uses **GNU Stow** for symlink-based dotfile management. All configuration files are in `stow/` with subdirectories for each application. Each subdirectory represents what would be in `~/.config/[app]`:

- To apply config: `stow -v -t "$HOME/.config/[app]" "[app]"`
- Stow creates symlinks from `~/.config/[app]` → `stow/[app]`
- When modifying configs, edit files in `stow/` directories

### Key Components

**Window Manager Stack:**
- i3-gaps (window manager) - config at `stow/i3/config`
- Polybar (status bar) - launched via `~/.config/polybar/launch_polybar.sh`
- Rofi (application launcher) - multiple applet types in `stow/rofi/`
- Picom (compositor) - config at `stow/picom.conf`
- Dunst (notifications) - config in `stow/dunst/`

**Terminal & Shell:**
- Supports multiple terminals (Alacritty, Kitty)
- ZSH with Oh My ZSH framework
- Oh My Posh for prompt customization
- Starship prompt support
- Tmux configurations in `customization/tmux/`

**Automation:**
- `scripts/autostart/autostart.py` - Python script for autostart applications
- `scripts/controller/controller_pad.py` - Xbox controller as keyboard/mouse
- Wallpaper rotation and monitor setup scripts
- Redshift control for screen temperature

## Development Commands

### Installation

```bash
# Run main installation script (30-60 minutes)
./installation_improved.sh

# This script:
# - Validates system (distro check, disk space, internet)
# - Creates timestamped backups in ~/.config-backup-[date]
# - Installs 100+ packages via nala/apt
# - Sets up Oh My ZSH and Oh My Posh
# - Does NOT apply stow configs (must be done separately)
```

### Applying Configurations

```bash
# Apply individual configs with stow
cd stow
stow -v -t "$HOME/.config/i3" "i3"
stow -v -t "$HOME/.config/polybar" "polybar"
stow -v -t "$HOME/.config/rofi" "rofi"

# Apply all major configs
for config in autostart btop cava dunst i3 lazygit nitrogen polybar rofi vim ranger; do
    stow -v -t "$HOME/.config/$config" "$config"
done

# Link shell customizations
ln -sf ~/Development/Linux_Mint/customization/zsh/.zshrc ~/.zshrc
ln -sf ~/Development/Linux_Mint/customization/bash/.bashrc ~/.bashrc
```

### Testing

```bash
# Run test suite
cd tests
./run_tests.sh

# Individual test files
python3 tests/test_autostart.py
python3 tests/test_controller_pad.py
```

### i3 Management

```bash
# Reload i3 config (or use $mod+Shift+c)
i3-msg reload

# Restart i3 (or use $mod+Shift+r)
i3-msg restart

# Check i3 config validity
i3 -C -c ~/.config/i3/config
```

### Polybar Management

```bash
# Launch polybar
~/.config/polybar/launch_polybar.sh

# Reload polybar
killall polybar
~/.config/polybar/launch_polybar.sh

# Edit config
vim ~/.config/polybar/config.ini
```

### Font Management

```bash
# Install fonts from fonts/ directory
sudo cp fonts/*.ttf /usr/share/fonts/
fc-cache -fv

# Verify font installation
fc-list | grep -i "jetbrains"
fc-list | grep -i "fantasque"
```

### Controller Script

```bash
# Run Xbox controller as mouse/keyboard
python3 ~/scripts/controller/controller_pad.py

# Requires: pip3 install --user inputs pynput
```

## Important Patterns

### Script Structure

All bash scripts follow this pattern:
```bash
#!/usr/bin/bash
set -euo pipefail  # Strict mode

# Use quoted variables
echo "$variable" not $variable

# Check command existence
command_exists() {
    command -v "$1" >/dev/null 2>&1
}
```

### Git Commit Convention

Follow **Conventional Commits** format (see CONTRIBUTING.md):
```
<tipo>(<escopo>): <descrição>

feat(controller): adicionar suporte para controle Xbox
fix(polybar): corrigir falha na inicialização da barra
docs: adicionar guia de instalação completo
refactor(scripts): melhorar estrutura dos scripts
```

Use `.gitmessage` template:
```bash
git config commit.template .gitmessage
```

### Package Installation Pattern

The installation script validates package availability before installing:
```bash
# Check if package exists in repos
package_available() {
    nala list "$1" 2>/dev/null | grep -q "$1" || apt list "$1" 2>/dev/null | grep -q "$1"
}

# Install only available packages
for package in "${PACKAGES[@]}"; do
    if package_available "$package"; then
        available_packages+=("$package")
    fi
done
sudo nala install -y "${available_packages[@]}"
```

### Polybar Multi-Monitor Launch

Polybar launches one instance per connected monitor:
```bash
for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload toph --config="~/.config/polybar/config.ini" &
done
```

## File Locations

**Dotfiles (managed by stow):**
- Window manager: `stow/i3/config`
- Status bar: `stow/polybar/config.ini`
- App launcher: `stow/rofi/` (multiple applets)
- Terminal: `stow/alacritty/`, `stow/kitty/`
- Editor: `stow/nvim/`, `stow/vim/`

**Shell customizations:**
- ZSH: `customization/zsh/.zshrc`, `customization/zsh/tj-dracula.omp.json`
- Bash: `customization/bash/.bashrc`
- Tmux: `customization/tmux/.tmux.conf`
- Git: `customization/git/.gitconfig`

**Scripts:**
- Autostart: `scripts/autostart/autostart.py`
- Controller: `scripts/controller/controller_pad.py`
- Monitor setup: `scripts/monitor_setup.sh`
- Wallpaper: `scripts/start_wallpaper.sh`, `scripts/wallpaper_rotation.sh`
- Polybar launcher: `stow/polybar/launch_polybar.sh`

**Installation:**
- Main script: `installation_improved.sh`
- Legacy scripts: `installation_1.sh`, `installation_2.sh`, `installation_3.sh`
- Package lists: `packages/` subdirectories

## Common Issues

### Polybar not starting
```bash
killall polybar
~/.config/polybar/launch_polybar.sh
```

### Fonts not appearing
```bash
fc-cache -fv
fc-list | grep -i "jetbrains"
```

### i3 not loading configs
```bash
# Check config validity first
i3 -C -c ~/.config/i3/config

# If valid, reload
i3-msg reload
```

### Python scripts failing
```bash
pip3 install --user inputs pynput
```

### X11 errors
Check logs at `~/.xsession-errors`

## Dependencies

**Essential for development:**
- `stow` - dotfile management
- `git` - version control
- `python3`, `python3-pip` - for Python scripts
- `i3`, `polybar`, `rofi` - window manager stack

**Testing:**
- `python3-unittest` (built-in)
- Test scripts in `tests/` directory

**Controller support:**
- Python packages: `inputs`, `pynput`

## Notes

- Primary branch: `main`
- Tested on Linux Mint 21.x (also compatible with Ubuntu 20.04+, Debian 11+)
- Installation creates timestamped backups before making changes
- Stow configs must be applied manually after running installation script
- i3 uses `$mod` key (Mod4/Super/Windows key) for all keybindings
- Polybar auto-detects all connected monitors via xrandr
- All logs saved to `~/.linux_mint_setup.log` during installation
