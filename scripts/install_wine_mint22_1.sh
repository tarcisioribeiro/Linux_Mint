#!/usr/bin/env bash
#
# install_wine_mint22_1.sh
# Instala e configura Wine no Linux Mint 22.1 (baseado em Ubuntu 22.04 jammy)
# Executar como root (sudo) ou será solicitado sudo conforme necessário.
#
# Versão: 2025-09-27
#
set -euo pipefail
IFS=$'\n\t'

### Configurações (edite se quiser) ###
WINE_CHANNEL="stable"         # opções: stable, staging, development
WINE_ARCH="win32"             # "win32" para prefix 32-bit padrão, "win64" para 64-bit
WINE_PREFIX_DIR="$HOME/.wine" # prefix padrão (pode alterar)
INSTALL_DXVK=true             # true/false - instala DXVK via winetricks (se possível)
INSTALL_CORE_FONTS=true       # true/false - instala corefonts via winetricks
CREATE_DESKTOP_SHORTCUTS=true
# Fim das configurações

LOGFILE="/tmp/install_wine_$(date +%Y%m%d%H%M%S).log"

echo "==> START: Instalação do Wine (log: $LOGFILE)"
echo "Configuração: WINE_CHANNEL=$WINE_CHANNEL, WINE_ARCH=$WINE_ARCH, WINE_PREFIX=$WINE_PREFIX_DIR"
echo

# Função de log
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOGFILE"
}

# Verifica se usuário está em sessão gráfica (para algumas etapas)
HAS_XDISPLAY=false
if [ -n "${DISPLAY:-}" ] || [ -n "${WAYLAND_DISPLAY:-}" ]; then
  HAS_XDISPLAY=true
fi

# Requer sudo para comandos que alteram o sistema
if [ "$EUID" -ne 0 ]; then
  SUDO='sudo'
else
  SUDO=''
fi

# Atualiza e instala pré-requisitos mínimos
log "Instalando dependências básicas..."
$SUDO apt update -y | tee -a "$LOGFILE"
$SUDO apt install -y --no-install-recommends \
  software-properties-common \
  apt-transport-https \
  ca-certificates \
  curl \
  wget \
  gnupg2 \
  lsb-release \
  gdebi-core \
  dialog \
  cabextract \
  p7zip-full \
  tar \
  unzip \
  fonts-liberation \
  apt-transport-https \
  curl \
  ca-certificates |
  tee -a "$LOGFILE"

# Habilita arquitetura i386
log "Habilitando arquitetura i386..."
$SUDO dpkg --add-architecture i386

# Adiciona repositório WineHQ
UBUNTU_CODENAME="jammy" # Mint 22.1 é baseado em Ubuntu 22.04 (jammy)
WINEHQ_KEY_URL="https://dl.winehq.org/wine-builds/winehq.key"
WINEHQ_SOURCES="/etc/apt/sources.list.d/winehq.list"
WINEHQ_KEYRING="/usr/share/keyrings/winehq-archive.key"

if [ ! -f "$WINEHQ_KEYRING" ]; then
  log "Baixando chave do WineHQ..."
  curl -fsSL "$WINEHQ_KEY_URL" | $SUDO gpg --dearmor -o "$WINEHQ_KEYRING"
fi

if ! grep -q "dl.winehq.org/wine-builds/ubuntu" "$WINEHQ_SOURCES" 2>/dev/null || [ ! -f "$WINEHQ_SOURCES" ]; then
  log "Adicionando repositório WineHQ..."
  echo "deb [signed-by=$WINEHQ_KEYRING] https://dl.winehq.org/wine-builds/ubuntu/ $UBUNTU_CODENAME main" | $SUDO tee "$WINEHQ_SOURCES" >/dev/null
fi

# Adiciona repositório OBS para libfaudio (frequentemente necessário em jammy)
OBS_REPO_LIST="/etc/apt/sources.list.d/obs-wine.list"
OBS_KEYRING="/usr/share/keyrings/obs-wine-archive.key"
OBS_KEY_URL="https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Ubuntu_22.04/Release.key"
OBS_DEB_LINE="deb [signed-by=$OBS_KEYRING] https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Ubuntu_22.04/ /"

if [ ! -f "$OBS_KEYRING" ]; then
  log "Baixando chave OBS (libfaudio)..."
  curl -fsSL "$OBS_KEY_URL" | $SUDO gpg --dearmor -o "$OBS_KEYRING"
fi

if ! grep -q "Emulators:/Wine:/Debian/Ubuntu_22.04" "$OBS_REPO_LIST" 2>/dev/null || [ ! -f "$OBS_REPO_LIST" ]; then
  log "Adicionando repositório OBS para libfaudio..."
  echo "$OBS_DEB_LINE" | $SUDO tee "$OBS_REPO_LIST" >/dev/null
fi

# Atualiza apt
log "Atualizando cache do apt ..."
$SUDO apt update -y | tee -a "$LOGFILE"

# Escolhe pacote Wine a instalar
case "$WINE_CHANNEL" in
stable)
  WINE_PKG="winehq-stable"
  ;;
staging)
  WINE_PKG="winehq-staging"
  ;;
development)
  WINE_PKG="winehq-devel"
  ;;
*)
  log "Canal WINE desconhecido: $WINE_CHANNEL. Usando stable."
  WINE_PKG="winehq-stable"
  ;;
esac

# Instala Wine e dependências recomendadas
log "Instalando $WINE_PKG e dependências recomendadas..."
$SUDO apt install -y --install-recommends "$WINE_PKG" | tee -a "$LOGFILE" || {
  log "A instalação do $WINE_PKG falhou. Tentando instalar dependências básicas e depois $WINE_PKG sem --install-recommends..."
  $SUDO apt install -y winehq-stable wine-stable wine-stable-i386 wine-stable-amd64 || true
}

# Instala libfaudio (se disponível via OBS repo)
log "Tentando instalar libfaudio0 e libfaudio0:i386 (se disponíveis)..."
$SUDO apt update -y
$SUDO apt install -y libfaudio0 libfaudio0:i386 2>/dev/null || log "libfaudio não disponível nos repositórios - ignorable se não houver dependência."

# Instalar winetricks (script oficial)
log "Instalando winetricks..."
if ! command -v winetricks >/dev/null 2>&1; then
  curl -fsSL https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks -o /tmp/winetricks
  $SUDO install -m 0755 /tmp/winetricks /usr/local/bin/winetricks
  rm -f /tmp/winetricks
else
  log "winetricks já presente."
fi

# Cria o prefixo Wine (respeita variável WINE_PREFIX_DIR)
log "Configurando WINEPREFIX em $WINE_PREFIX_DIR com arquitetura $WINE_ARCH ..."
export WINEPREFIX="$WINE_PREFIX_DIR"
export WINEARCH="$WINE_ARCH"

if [ ! -d "$WINEPREFIX" ] || [ -z "$(ls -A "$WINEPREFIX" 2>/dev/null || true)" ]; then
  log "Criando WINEPREFIX... (isso pode abrir janela winecfg se houver DISPLAY)"
  # Força criação não interativa da pasta
  mkdir -p "$WINEPREFIX"
  # Executa winecfg para inicializar prefixo
  if $HAS_XDISPLAY; then
    log "Executando winecfg (pode abrir GUI)..."
    sudo -u "$SUDO_USER" env DISPLAY="$DISPLAY" HOME="$HOME" WINEPREFIX="$WINEPREFIX" WINEARCH="$WINEARCH" winecfg 2>/dev/null || true
  else
    log "Sem DISPLAY detectado — criando prefixo base via wineboot (modo headless)..."
    sudo -u "$SUDO_USER" env WINEPREFIX="$WINEPREFIX" WINEARCH="$WINEARCH" wineboot -u 2>/dev/null || true
  fi
else
  log "WINEPREFIX já existe — pulando criação."
fi

# Instala corefonts e outras utilidades via winetricks (opcional)
if $INSTALL_CORE_FONTS; then
  log "Instalando corefonts via winetricks (pode pedir interação) ..."
  sudo -u "$SUDO_USER" env WINEPREFIX="$WINEPREFIX" winetricks -q corefonts || log "Falha instalando corefonts via winetricks (ver log)."
fi

# Instala DXVK (se pedido e se winetricks suportar)
if $INSTALL_DXVK; then
  log "Tentando instalar DXVK via winetricks..."
  sudo -u "$SUDO_USER" env WINEPREFIX="$WINEPREFIX" winetricks -q dxvk || log "Falha instalando DXVK via winetricks (ver log)."
fi

# Instala wine-mono e wine-gecko (geralmente automáticos; aqui força se possível)
log "Forçando instalação de wine-mono e wine-gecko via winetricks (se necessário)..."
sudo -u "$SUDO_USER" env WINEPREFIX="$WINEPREFIX" winetricks -q mono210 || true
sudo -u "$SUDO_USER" env WINEPREFIX="$WINEPREFIX" winetricks -q gecko || true

# Ajustes de registro e configurações úteis (exemplo: desativar automount se quiser)
log "Aplicando pequenas configurações no registro (exemplos)..."
# Exemplo: habilitar suporte a long paths no Windows (se desejar)
# echo 'REGEDIT4
# [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\FileSystem]
# "LongPathsEnabled"=dword:00000001' > /tmp/win_longpaths.reg
# sudo -u "$SUDO_USER" env WINEPREFIX="$WINEPREFIX" wine regedit /tmp/win_longpaths.reg || true
# rm -f /tmp/win_longpaths.reg

# Cria atalhos de desktop simples para winecfg e para o prefixo (opcional)
if $CREATE_DESKTOP_SHORTCUTS; then
  DESKTOP_DIR="$HOME/.local/share/applications"
  mkdir -p "$DESKTOP_DIR"
  log "Criando atalhos .desktop em $DESKTOP_DIR ..."

  cat >"$HOME/.local/share/applications/winecfg.desktop" <<EOF
[Desktop Entry]
Name=Wine Configuration (winecfg)
Comment=Configurar o Wine
Exec=env WINEPREFIX="$WINEPREFIX" WINEARCH="$WINEARCH" winecfg
Icon=wine
Terminal=false
Type=Application
Categories=Settings;System;
EOF

  cat >"$HOME/.local/share/applications/winefile.desktop" <<EOF
[Desktop Entry]
Name=Wine File Manager (winefile)
Comment=Abrir gerenciador de arquivos do Wine
Exec=env WINEPREFIX="$WINEPREFIX" WINEARCH="$WINEARCH" winefile
Icon=wine
Terminal=false
Type=Application
Categories=Utility;FileManager;
EOF

  log "Atalhos criados: winecfg, winefile"
fi

# Limpeza e finalização
log "Limpeza de pacotes temporários..."
$SUDO apt autoremove -y || true
$SUDO apt -y clean || true

log "==> FINISH: Wine instalado/configurado."
log "WINE_PREFIX: $WINEPREFIX"
log "Para verificar, rode: env WINEPREFIX=\"$WINEPREFIX\" wine --version"
log "Log completo em: $LOGFILE"

cat <<EOF

Próximos passos / notas úteis:
- Para abrir a configuração do Wine em sua sessão gráfica:
    env WINEPREFIX="$WINEPREFIX" WINEARCH="$WINEARCH" winecfg

- Para instalar programas Windows:
    env WINEPREFIX="$WINEPREFIX" WINEARCH="$WINEARCH" wine setup.exe
  (substitua setup.exe pelo instalador desejado)

- Para usar winetricks (ex.: instalar dotnet, fonts, configurações):
    env WINEPREFIX="$WINEPREFIX" winetricks

- Se tiver problemas com bibliotecas faltando (ex.: libfaudio), verifique se o repositório OBS foi adicionado corretamente e atualize apt:
    sudo apt update
    sudo apt install libfaudio0 libfaudio0:i386

- DXVK requer driver Vulkan e GPU suportada. Se estiver usando NVIDIA proprietária, instale drivers NVIDIA e Vulkan (libvulkan1, mesa-vulkan-drivers) antes.

- Se quiser um prefix 64-bit, ajuste WINEARCH=win64 e remova/mova o prefix existente antes de criar.

Se quiser, eu posso:
- Gerar um script menor apenas para instalar wine-stable;
- Adicionar instalação automática do Proton / Steam / Lutris;
- Adicionar instalação de versões específicas do Wine (ex.: staging).
EOF

exit 0
