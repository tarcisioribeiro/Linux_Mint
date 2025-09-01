#!/bin/bash

# Script para executar todos os testes do projeto
# Usage: ./run_tests.sh

set -e

echo "=== Executando Testes do Projeto Linux_Mint ==="
echo

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para exibir mensagens coloridas
msg_success() {
    echo -e "${GREEN}[SUCESSO]${NC} $1"
}

msg_error() {
    echo -e "${RED}[ERRO]${NC} $1"
}

msg_warning() {
    echo -e "${YELLOW}[AVISO]${NC} $1"
}

msg_info() {
    echo -e "[INFO] $1"
}

# Verificar se Python está instalado
if ! command -v python3 &> /dev/null; then
    msg_error "Python 3 não encontrado. Por favor, instale Python 3."
    exit 1
fi

msg_info "Usando Python: $(python3 --version)"

# Diretório base dos testes
TEST_DIR="$(dirname "$0")"
PROJECT_ROOT="$(dirname "$TEST_DIR")"

echo "Diretório do projeto: $PROJECT_ROOT"
echo "Diretório de testes: $TEST_DIR"
echo

# Contador de testes
total_tests=0
passed_tests=0
failed_tests=0

# Função para executar um teste
run_test() {
    local test_file=$1
    local test_name=$(basename "$test_file" .py)
    
    msg_info "Executando teste: $test_name"
    total_tests=$((total_tests + 1))
    
    if python3 "$test_file"; then
        msg_success "Teste $test_name passou"
        passed_tests=$((passed_tests + 1))
    else
        msg_error "Teste $test_name falhou"
        failed_tests=$((failed_tests + 1))
    fi
    echo
}

# Executar testes Python
msg_info "=== Testes Python ==="
for test_file in "$TEST_DIR"/test_*.py; do
    if [ -f "$test_file" ]; then
        run_test "$test_file"
    fi
done

# Verificar sintaxe dos scripts shell
msg_info "=== Verificação de Sintaxe Shell Scripts ==="
shell_scripts_found=0
shell_syntax_errors=0

find "$PROJECT_ROOT" -name "*.sh" -type f | while read -r script; do
    shell_scripts_found=$((shell_scripts_found + 1))
    msg_info "Verificando sintaxe: $(basename "$script")"
    
    if bash -n "$script"; then
        msg_success "Sintaxe OK: $(basename "$script")"
    else
        msg_error "Erro de sintaxe: $(basename "$script")"
        shell_syntax_errors=$((shell_syntax_errors + 1))
    fi
done

# Verificar sintaxe dos scripts Python
msg_info "=== Verificação de Sintaxe Python ==="
python_scripts_found=0
python_syntax_errors=0

find "$PROJECT_ROOT" -name "*.py" -type f | while read -r script; do
    python_scripts_found=$((python_scripts_found + 1))
    msg_info "Verificando sintaxe: $(basename "$script")"
    
    if python3 -m py_compile "$script"; then
        msg_success "Sintaxe OK: $(basename "$script")"
    else
        msg_error "Erro de sintaxe: $(basename "$script")"
        python_syntax_errors=$((python_syntax_errors + 1))
    fi
done

echo
echo "=== Resumo dos Testes ==="
echo "Total de testes executados: $total_tests"
echo "Testes aprovados: $passed_tests"
echo "Testes falharam: $failed_tests"

if [ $failed_tests -eq 0 ]; then
    msg_success "Todos os testes passaram!"
    exit 0
else
    msg_error "Alguns testes falharam."
    exit 1
fi