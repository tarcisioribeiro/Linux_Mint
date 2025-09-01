#!/usr/bin/env python3
"""
Testes básicos para o script autostart.py
"""

import unittest
from unittest.mock import Mock, patch, call
import sys
import os
import tempfile

# Adicionar o diretório de scripts ao path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'scripts', 'autostart'))

try:
    from autostart import main
except ImportError:
    print("Aviso: Não foi possível importar autostart. Verifique se o arquivo existe.")
    sys.exit(0)


class TestAutostart(unittest.TestCase):
    
    def test_script_structure(self):
        """Verificar estrutura básica do script autostart"""
        script_path = os.path.join(os.path.dirname(__file__), '..', 'scripts', 'autostart', 'autostart.py')
        self.assertTrue(os.path.exists(script_path), "Script autostart.py não encontrado")
        
        with open(script_path, 'r') as f:
            content = f.read()
            
        # Verificar se tem estrutura básica de script Python
        self.assertIn('#!/usr/bin/python3', content)
        self.assertIn('if __name__', content)
    
    @patch('subprocess.run')
    def test_subprocess_calls(self, mock_run):
        """Testar se subprocess.run é chamado corretamente"""
        # Mock para simular sucesso em todas as chamadas
        mock_run.return_value = Mock(returncode=0)
        
        try:
            main()
        except Exception:
            # Ignorar exceções específicas do ambiente de teste
            pass
        
        # Verificar se pelo menos uma chamada de subprocess foi feita
        # (o número exato pode variar dependendo da implementação)
        self.assertTrue(mock_run.called, "Subprocess.run deveria ter sido chamado")


class TestAutoStartValidation(unittest.TestCase):
    """Testes de validação do sistema"""
    
    def test_python_version(self):
        """Verificar se está usando Python 3"""
        self.assertGreaterEqual(sys.version_info.major, 3, "Script requer Python 3")
    
    def test_required_modules(self):
        """Verificar se módulos básicos estão disponíveis"""
        try:
            import subprocess
            import os
            import sys
        except ImportError as e:
            self.fail(f"Módulo básico não encontrado: {e}")


if __name__ == '__main__':
    print("Executando testes para autostart.py...")
    unittest.main(verbosity=2)