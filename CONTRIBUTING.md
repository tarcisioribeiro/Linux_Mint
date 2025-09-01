# Guia de Contribuição

## 📝 Mensagens de Commit

Este projeto segue o padrão **Conventional Commits** para mensagens de commit claras e consistentes.

### Formato das Mensagens

```
<tipo>(<escopo>): <descrição>

[corpo opcional]

[rodapé opcional]
```

### Tipos de Commit

| Tipo | Descrição |
|------|-----------|
| `feat` | Nova funcionalidade |
| `fix` | Correção de bug |
| `docs` | Alterações na documentação |
| `style` | Formatação, espaços em branco, etc. |
| `refactor` | Refatoração de código |
| `test` | Adição ou correção de testes |
| `chore` | Tarefas de manutenção |
| `perf` | Melhorias de performance |
| `ci` | Mudanças na integração contínua |

### Exemplos de Boas Mensagens

#### Funcionalidade Nova
```
feat(controller): adicionar suporte para controle Xbox

- Implementar mapeamento de botões do gamepad
- Adicionar controle de movimento com analógicos
- Configurar D-pad para navegação por setas
- Criar script Python para captura de eventos

Permite navegação completa do sistema usando controle Xbox
conectado via USB ou Bluetooth.

Closes #45
```

#### Correção de Bug
```
fix(polybar): corrigir falha na inicialização da barra

- Adicionar verificação de dependências antes da execução
- Corrigir caminho do script launch_polybar.sh
- Implementar fallback para configuração padrão

Resolves #32
```

#### Documentação
```
docs: adicionar guia de instalação completo

- Criar INSTALL.md com instruções passo a passo
- Documentar pré-requisitos do sistema
- Adicionar seção de solução de problemas
- Incluir estrutura do projeto
```

#### Refatoração
```
refactor(scripts): melhorar estrutura dos scripts de instalação

- Separar verificação de dependências em função própria
- Adicionar logging para debugging
- Implementar tratamento de erros robusto
- Padronizar nomes de variáveis
```

### Configuração do Template

O projeto inclui um template de commit pré-configurado:

```bash
git config commit.template .gitmessage
```

## 🧪 Testes

### Executar Testes

```bash
cd tests
./run_tests.sh
```

### Criar Novos Testes

1. Adicionar arquivo `test_nome.py` na pasta `tests/`
2. Usar unittest para estrutura de testes
3. Incluir testes de validação básica
4. Documentar casos de teste

### Exemplo de Teste

```python
import unittest
from unittest.mock import patch

class TestScript(unittest.TestCase):
    def test_funcao_basica(self):
        """Testar funcionalidade básica"""
        resultado = minha_funcao(entrada)
        self.assertEqual(resultado, esperado)
```

## 📁 Estrutura do Projeto

Mantenha a organização:

```
Linux_Mint/
├── stow/           # Configurações dotfiles (GNU Stow)
├── scripts/        # Scripts utilitários
├── customization/  # Customizações de shell/terminal
├── tests/         # Testes automatizados
├── fonts/         # Fontes Nerd Fonts
├── wallpapers/    # Papéis de parede
└── packages/      # Scripts de instalação
```

## 🔧 Padrões de Código

### Shell Scripts
- Use `#!/bin/bash` ou `#!/usr/bin/bash`
- Ative modo strict: `set -euo pipefail`
- Use aspas em variáveis: `"$variavel"`
- Valide entrada de usuário
- Adicione comentários descritivos

### Python
- Siga PEP 8
- Use docstrings para funções
- Implemente tratamento de exceções
- Adicione type hints quando possível

### Configurações
- Mantenha comentários explicativos
- Use valores sensatos como padrão
- Documente opções customizáveis

## 🚀 Fluxo de Contribuição

1. **Fork** do repositório
2. **Clone** seu fork localmente
3. **Crie branch** para sua funcionalidade:
   ```bash
   git checkout -b feat/minha-funcionalidade
   ```
4. **Faça commits** seguindo o padrão
5. **Execute testes** para validar mudanças
6. **Push** para seu fork
7. **Abra Pull Request** com descrição detalhada

## ✅ Checklist do Pull Request

- [ ] Commits seguem o padrão conventional
- [ ] Testes passam (`./tests/run_tests.sh`)
- [ ] Documentação atualizada se necessário
- [ ] Código segue padrões estabelecidos
- [ ] Funcionalidade testada manualmente
- [ ] PR tem descrição clara das mudanças

## 🐛 Reportando Bugs

Use o template de issue para reportar bugs:

1. Descrição do problema
2. Passos para reproduzir
3. Comportamento esperado vs atual
4. Ambiente (OS, versão, etc.)
5. Logs/screenshots se aplicável

## 💡 Sugestões de Melhorias

- Abra issue com label `enhancement`
- Descreva claramente a funcionalidade
- Explique caso de uso
- Considere impacto na compatibilidade

## 📞 Ajuda

- Issues no GitHub para bugs e sugestões
- Discussões para dúvidas gerais
- Wiki para documentação adicional

---

Obrigado por contribuir! 🎉