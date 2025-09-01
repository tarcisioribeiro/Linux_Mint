#!/usr/bin/bash

# Linux Mint Setup Script - Versão Melhorada com Validação de Dependências
# Autor: Sistema de configuração personalizada para Linux Mint
# Versão: 2.0

set -euo pipefail  # Modo strict: falha em erros, variáveis não definidas, pipes com falha

# Cores para output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Variáveis globais
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="$HOME/.linux_mint_setup.log"
readonly REPO_DIR="$HOME/Development/Linux_Mint"
readonly TERMINALS_DIR="$REPO_DIR/packages/terminals"
readonly CUSTOMIZATION_DIR="$REPO_DIR/customization"

# Função para logging
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Função para mensagens coloridas
msg_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

msg_success() {
    echo -e "${GREEN}[SUCESSO]${NC} $1" | tee -a "$LOG_FILE"
}

msg_warning() {
    echo -e "${YELLOW}[AVISO]${NC} $1" | tee -a "$LOG_FILE"
}

msg_error() {
    echo -e "${RED}[ERRO]${NC} $1" | tee -a "$LOG_FILE"
}

msg_color() {
    clear
    echo -e "\n\033[$1m$2\033[0m\n" | tee -a "$LOG_FILE"
    sleep 2
}

# Função para verificar se comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Função para verificar conectividade
check_internet() {
    msg_info "Verificando conectividade com a internet..."
    if ! ping -c 1 google.com >/dev/null 2>&1; then
        msg_error "Sem conexão com a internet. Verifique sua conexão e tente novamente."
        exit 1
    fi
    msg_success "Conexão com a internet confirmada."
}

# Função para verificar espaço em disco
check_disk_space() {
    local required_space=10000000  # 10GB em KB
    local available_space
    available_space=$(df / | awk 'NR==2 {print $4}')
    
    msg_info "Verificando espaço em disco..."
    if [[ $available_space -lt $required_space ]]; then
        msg_error "Espaço insuficiente em disco. Necessário: 10GB, Disponível: $((available_space/1024/1024))GB"
        exit 1
    fi
    msg_success "Espaço em disco suficiente: $((available_space/1024/1024))GB disponível."
}

# Função para verificar se é root
check_not_root() {
    if [[ $EUID -eq 0 ]]; then
        msg_error "Este script não deve ser executado como root."
        exit 1
    fi
}

# Função para verificar distribuição
check_distribution() {
    msg_info "Verificando distribuição Linux..."
    
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "$ID" in
            "linuxmint"|"ubuntu"|"debian")
                msg_success "Distribuição compatível detectada: $PRETTY_NAME"
                ;;
            *)
                msg_warning "Distribuição não testada: $PRETTY_NAME"
                read -p "Deseja continuar mesmo assim? (s/N): " -n 1 -r
                echo
                if [[ ! $REPLY =~ ^[Ss]$ ]]; then
                    msg_info "Instalação cancelada pelo usuário."
                    exit 0
                fi
                ;;
        esac
    else
        msg_error "Não foi possível detectar a distribuição Linux."
        exit 1
    fi
}

# Função para verificar dependências essenciais
check_essential_dependencies() {
    msg_info "Verificando dependências essenciais..."
    
    local essential_deps=("curl" "wget" "git" "sudo")
    local missing_deps=()
    
    for dep in "${essential_deps[@]}"; do
        if ! command_exists "$dep"; then
            missing_deps+=("$dep")
        fi
    done
    
    if [[ ${#missing_deps[@]} -ne 0 ]]; then
        msg_error "Dependências essenciais faltando: ${missing_deps[*]}"
        msg_info "Instalando dependências essenciais..."
        
        if command_exists "apt-get"; then
            sudo apt-get update
            sudo apt-get install -y "${missing_deps[@]}"
        else
            msg_error "Gerenciador de pacotes apt não encontrado."
            exit 1
        fi
    fi
    
    msg_success "Todas as dependências essenciais estão disponíveis."
}

# Função para criar backup
create_backup() {
    msg_info "Criando backup das configurações existentes..."
    
    local backup_dir="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # Backup de configurações importantes
    local config_dirs=(".config" ".bashrc" ".zshrc" ".gitconfig" ".tmux.conf")
    
    for config in "${config_dirs[@]}"; do
        if [[ -e "$HOME/$config" ]]; then
            cp -r "$HOME/$config" "$backup_dir/" 2>/dev/null || true
            msg_info "Backup criado: $config"
        fi
    done
    
    msg_success "Backup criado em: $backup_dir"
}

# Função para instalar nala se não existir
ensure_nala() {
    if ! command_exists "nala"; then
        msg_info "Instalando nala (frontend melhorado para apt)..."
        sudo apt update
        sudo apt install -y nala
    fi
    msg_success "Nala está disponível."
}

# Função para verificar se pacote está disponível
package_available() {
    nala list "$1" 2>/dev/null | grep -q "$1" || apt list "$1" 2>/dev/null | grep -q "$1"
}

# Array de pacotes com verificação
PACKAGES=(
    # Ferramentas básicas
    "toilet" "curl" "wget" "build-essential" "gcc" "g++" "clang" 
    "make" "cmake" "automake" "autoconf" "git" "stow" "pkg-config" 
    "meson" "ninja-build" "scdoc"
    
    # Terminal e utilitários
    "neofetch" "tmux" "rofi" "fzf" "bat" "gdebi" "feh" "nitrogen" 
    "redshift" "xclip" "xsel" "playerctl" "btop" "scrot" "maim" "xdotool"
    
    # Multimídia
    "mpv" "vlc" "shotcut" "obs-studio" "cava" "pavucontrol" "gimp"
    
    # Desenvolvimento
    "python3" "python3-venv" "python3-tk" "python3-pip" "python3-dev"
    "python3-full" "golang" "nodejs" "npm" "ruby-full"
    
    # Sistema
    "flatpak" "timeshift" "openssh-server" "dkms" "perl" "p7zip" "pv"
    "cpu-checker" "gh" "unzip" "jq" "zsh" "ranger"
    
    # Bibliotecas de desenvolvimento (principais)
    "libssl-dev" "zlib1g-dev" "libbz2-dev" "libreadline-dev" 
    "libsqlite3-dev" "libffi-dev" "liblzma-dev" "tk-dev"
    "libpam0g-dev" "libcairo2-dev" "libfontconfig1-dev"
    
    # i3 e componentes gráficos
    "i3lock" "dunst" "polybar"
    "libxcb1-dev" "libxcb-keysyms1-dev" "libxcb-util0-dev"
    "libxcb-icccm4-dev" "libxcb-randr0-dev" "libxcb-xinerama0-dev"
    "libpango1.0-dev" "libx11-dev" "libxrandr-dev" "libxinerama-dev"
    
    # Outros essenciais
    "acpi" "light" "locate" "blueman" "nvtop" "breeze-cursor-theme"
    "xss-lock" "cargo" "gradle"
)

# Função para instalar pacotes com verificação
install_packages() {
    msg_color "34" "Atualizando repositórios e instalando dependências..."
    
    # Atualizar repositórios
    sudo nala update || sudo apt update
    sudo nala upgrade -y || sudo apt upgrade -y
    
    # Verificar e instalar pacotes
    local available_packages=()
    local unavailable_packages=()
    
    msg_info "Verificando disponibilidade dos pacotes..."
    for package in "${PACKAGES[@]}"; do
        if package_available "$package"; then
            available_packages+=("$package")
        else
            unavailable_packages+=("$package")
        fi
    done
    
    if [[ ${#unavailable_packages[@]} -ne 0 ]]; then
        msg_warning "Pacotes não disponíveis: ${unavailable_packages[*]}"
    fi
    
    msg_info "Instalando ${#available_packages[@]} pacotes disponíveis..."
    if [[ ${#available_packages[@]} -gt 0 ]]; then
        sudo nala install -y "${available_packages[@]}" || {
            msg_warning "Falha com nala, tentando com apt..."
            sudo apt install -y "${available_packages[@]}"
        }
    fi
    
    msg_success "Instalação de pacotes concluída."
}

# Função para verificar e executar scripts externos
safe_execute_script() {
    local script_path="$1"
    local description="$2"
    
    if [[ -f "$script_path" && -x "$script_path" ]]; then
        msg_info "Executando: $description"
        if "$script_path"; then
            msg_success "$description concluído."
        else
            msg_error "Falha ao executar: $description"
            return 1
        fi
    else
        msg_warning "Script não encontrado ou não executável: $script_path"
        return 1
    fi
}

# Função para instalar Oh My ZSH com verificação
install_oh_my_zsh() {
    msg_color "34" "Instalando o Oh My ZSH..."
    
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        msg_info "Oh My ZSH já instalado. Pulando..."
        return 0
    fi
    
    if safe_execute_script "$TERMINALS_DIR/oh_my_zsh_install.sh" "Oh My ZSH"; then
        return 0
    else
        # Fallback: instalação direta
        msg_info "Tentando instalação direta do Oh My ZSH..."
        RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
}

# Função principal de instalação
main() {
    log "=== Iniciando instalação do Linux Mint Setup ==="
    
    # Verificações preliminares
    check_not_root
    check_distribution
    check_internet
    check_disk_space
    check_essential_dependencies
    
    # Criar backup
    create_backup
    
    # Instalar nala
    ensure_nala
    
    # Instalar pacotes
    install_packages
    
    # Instalar Oh My ZSH
    install_oh_my_zsh
    
    # Instalar Oh My Posh com verificação
    msg_color "34" "Instalando o Oh My Posh..."
    if ! command_exists "oh-my-posh"; then
        sudo wget -q https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
        sudo chmod +x /usr/local/bin/oh-my-posh
        mkdir -p "$HOME/.poshthemes"
        wget -q https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O "$HOME/.poshthemes/themes.zip"
        unzip -q "$HOME/.poshthemes/themes.zip" -d "$HOME/.poshthemes"
        rm "$HOME/.poshthemes/themes.zip"
        ln -sf "$CUSTOMIZATION_DIR/zsh/tj-dracula.omp.json" "$HOME/.poshthemes/tj-dracula.omp.json"
    else
        msg_info "Oh My Posh já instalado."
    fi
    
    # Continuar com o resto da instalação...
    msg_color "34" "Criando diretórios necessários..."
    mkdir -p "$HOME/Development" "$HOME/.icons" "$HOME/.themes" "$HOME/scripts"
    
    msg_success "=== Instalação concluída com sucesso! ==="
    msg_info "Log completo disponível em: $LOG_FILE"
    msg_info "Para completar a instalação, faça logout e login novamente."
}

# Função de limpeza em caso de erro
cleanup() {
    msg_error "Instalação interrompida. Verificando se é necessária limpeza..."
    # Adicionar lógica de limpeza se necessário
}

# Capturar sinais para limpeza
trap cleanup EXIT

# Executar função principal se script for executado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi