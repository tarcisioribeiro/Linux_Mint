# Guia de Instalação - Linux Mint Setup

Este guia fornece instruções detalhadas para instalar e configurar o ambiente Linux Mint personalizado.

## 📋 Pré-requisitos

### Sistema Operacional
- Linux Mint 20.x ou superior
- Ubuntu 20.04+ (compatível)
- Debian 11+ (compatível)

### Requisitos de Sistema
- Pelo menos 4GB de RAM
- 10GB de espaço livre em disco
- Conexão com a internet
- Permissões de sudo

### Dependências Básicas
Certifique-se de que os seguintes pacotes estão instalados:
```bash
sudo apt update
sudo apt install -y curl wget git build-essential
```

## 🚀 Instalação Rápida

### 1. Clone o Repositório
```bash
cd ~/Development
git clone https://github.com/[seu-usuario]/Linux_Mint.git
cd Linux_Mint
```

### 2. Execute o Script de Instalação
```bash
chmod +x installation_1.sh
./installation_1.sh
```

⚠️ **Aviso**: O script de instalação pode demorar 30-60 minutos dependendo da velocidade da internet.

## 📖 Instalação Passo a Passo

### Etapa 1: Preparação do Sistema

1. **Atualizar sistema:**
```bash
sudo apt update && sudo apt upgrade -y
```

2. **Instalar dependências essenciais:**
```bash
sudo apt install -y nala curl wget git stow build-essential
```

### Etapa 2: Instalação de Pacotes

O script instala automaticamente mais de 100 pacotes, incluindo:

#### Ferramentas de Desenvolvimento
- `gcc`, `g++`, `clang`, `make`, `cmake`
- `python3`, `python3-pip`, `nodejs`, `golang`
- `git`, `gh` (GitHub CLI)

#### Interface Gráfica
- `i3-gaps`, `polybar`, `rofi`, `picom`
- `dunst`, `nitrogen`, `feh`
- `alacritty`, `kitty`

#### Multimídia
- `mpv`, `vlc`, `obs-studio`
- `gimp`, `shotcut`
- `pavucontrol`

#### Utilitários
- `tmux`, `ranger`, `btop`
- `neovim`, `vim`
- `flatpak`, `timeshift`

### Etapa 3: Configuração de Dotfiles

1. **Backup das configurações existentes:**
```bash
mkdir -p ~/.config-backup
cp -r ~/.config/* ~/.config-backup/ 2>/dev/null || true
```

2. **Aplicar configurações com Stow:**
```bash
cd stow
for config in autostart btop cava dunst i3 lazygit nitrogen polybar rofi vim ranger; do
    stow -v -t "$HOME/.config/$config" "$config"
done
```

3. **Configurar arquivos de shell:**
```bash
ln -sf ~/Development/Linux_Mint/customization/zsh/.zshrc ~/.zshrc
ln -sf ~/Development/Linux_Mint/customization/bash/.bashrc ~/.bashrc
```

### Etapa 4: Instalação de Fontes

```bash
sudo mkdir -p /usr/share/fonts
sudo cp fonts/*.ttf /usr/share/fonts/
fc-cache -fv
```

### Etapa 5: Configuração do Tema

1. **Instalar tema Dracula GTK:**
```bash
cd /tmp
wget https://github.com/dracula/gtk/archive/master.zip
unzip master.zip
mv gtk-master ~/.themes/Dracula
```

2. **Instalar ícones Tela Dracula:**
```bash
git clone https://github.com/vinceliuice/Tela-icon-theme.git
cd Tela-icon-theme
./install.sh -n dracula
```

## 🔧 Configurações Pós-Instalação

### Terminal e Shell

1. **Configurar ZSH como shell padrão:**
```bash
chsh -s $(which zsh)
```

2. **Instalar Oh My Zsh:**
```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

3. **Configurar Starship prompt:**
```bash
curl -sS https://starship.rs/install.sh | sh
```

### i3 Window Manager

1. **Fazer logout e login novamente**
2. **Escolher i3 na tela de login**
3. **Pressionar `$mod+Return` para abrir terminal**

### Polybar

1. **Iniciar polybar:**
```bash
~/.config/polybar/launch_polybar.sh
```

## 🎮 Configurações Especiais

### Controle Xbox

Para usar controle Xbox como mouse/teclado:

1. **Conectar controle via USB ou Bluetooth**
2. **Executar script:**
```bash
python3 ~/scripts/controller/controller_pad.py
```

### Jogos

Instalar Steam e configurar Proton:
```bash
flatpak install flathub com.valvesoftware.Steam
```

## 📱 Aplicações Flatpak

Instalar aplicações adicionais:
```bash
flatpak install flathub org.mozilla.firefox
flatpak install flathub com.spotify.Client
flatpak install flathub com.discordapp.Discord
flatpak install flathub org.telegram.desktop
```

## 🧪 Executar Testes

Para verificar se tudo está funcionando:
```bash
cd tests
./run_tests.sh
```

## 🔍 Solução de Problemas

### Problema: Polybar não inicia
**Solução:**
```bash
killall polybar
~/.config/polybar/launch_polybar.sh
```

### Problema: Fonts não aparecem
**Solução:**
```bash
fc-cache -fv
fc-list | grep -i "jetbrains"
```

### Problema: i3 não carrega configurações
**Solução:**
```bash
i3-msg reload
# ou
$mod+Shift+r
```

### Problema: Scripts Python falham
**Solução:**
```bash
pip3 install --user inputs pynput
```

## 📚 Estrutura do Projeto

```
Linux_Mint/
├── stow/                   # Configurações dotfiles
│   ├── i3/                # Config do i3wm
│   ├── polybar/           # Config da polybar
│   ├── rofi/              # Config do rofi
│   └── ...
├── scripts/               # Scripts utilitários
│   ├── controller/        # Scripts para controle
│   └── autostart/         # Scripts de inicialização
├── customization/         # Customizações de shell
│   ├── zsh/              # Configs do ZSH
│   ├── bash/             # Configs do Bash
│   └── tmux/             # Config do Tmux
├── fonts/                 # Fontes Nerd Fonts
├── wallpapers/           # Papéis de parede
├── tests/                # Testes automatizados
└── packages/             # Scripts de instalação de pacotes
```

## ⚙️ Customização

### Modificar Atalhos do i3

Editar `~/.config/i3/config` e recarregar:
```bash
$mod+Shift+c
```

### Personalizar Polybar

Editar `~/.config/polybar/config.ini`

### Alterar Tema de Cores

Modificar arquivos em `customization/` e reaplicar com stow.

## 📞 Suporte

- **Issues**: Reporte problemas no GitHub
- **Documentação**: Consulte o README.md principal
- **Logs**: Verifique `~/.xsession-errors` para erros do X11

---

**Nota**: Este setup foi testado em Linux Mint 21.x. Adaptações podem ser necessárias para outras distribuições.