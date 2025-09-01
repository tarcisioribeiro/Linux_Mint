#!/usr/bin/env python3
"""
Testes básicos para o script controller_pad.py
"""

import unittest
from unittest.mock import Mock, patch, MagicMock
import sys
import os

# Adicionar o diretório de scripts ao path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'scripts', 'controller'))

try:
    from controller_pad import press_key, press_combo, handle_input
except ImportError:
    print("Aviso: Não foi possível importar controller_pad. Certifique-se de que as dependências estão instaladas.")
    sys.exit(0)


class TestControllerPad(unittest.TestCase):
    
    def setUp(self):
        """Configurar mocks para testes"""
        self.keyboard_mock = Mock()
        self.mouse_mock = Mock()
    
    @patch('controller_pad.keyboard')
    def test_press_key(self, mock_keyboard):
        """Testar função press_key"""
        from pynput.keyboard import Key
        
        press_key(Key.enter)
        
        mock_keyboard.press.assert_called_once_with(Key.enter)
        mock_keyboard.release.assert_called_once_with(Key.enter)
    
    @patch('controller_pad.keyboard')
    def test_press_combo(self, mock_keyboard):
        """Testar função press_combo"""
        from pynput.keyboard import Key
        
        keys = [Key.alt, Key.space]
        press_combo(keys)
        
        # Verificar se todas as teclas foram pressionadas
        expected_press_calls = [unittest.mock.call(Key.alt), unittest.mock.call(Key.space)]
        mock_keyboard.press.assert_has_calls(expected_press_calls)
        
        # Verificar se todas as teclas foram liberadas na ordem reversa
        expected_release_calls = [unittest.mock.call(Key.space), unittest.mock.call(Key.alt)]
        mock_keyboard.release.assert_has_calls(expected_release_calls)
    
    @patch('controller_pad.get_gamepad')
    @patch('controller_pad.time.sleep')
    def test_handle_input_unplugged_error(self, mock_sleep, mock_get_gamepad):
        """Testar tratamento de erro quando controle está desconectado"""
        from inputs import UnpluggedError
        
        # Simular erro de controle desconectado seguido de sucesso
        mock_get_gamepad.side_effect = [UnpluggedError(), []]
        
        # Executar apenas uma iteração
        with patch('controller_pad.time.sleep') as mock_sleep:
            mock_sleep.side_effect = [None, KeyboardInterrupt()]  # Interromper após primeira iteração
            
            with self.assertRaises(KeyboardInterrupt):
                handle_input()
        
        # Verificar se sleep foi chamado quando controle estava desconectado
        mock_sleep.assert_called()


class TestControllerValidation(unittest.TestCase):
    """Testes de validação e estrutura do código"""
    
    def test_imports_available(self):
        """Verificar se todas as dependências necessárias estão disponíveis"""
        try:
            import inputs
            import pynput.keyboard
            import pynput.mouse
            import time
        except ImportError as e:
            self.fail(f"Dependência não encontrada: {e}")
    
    def test_script_structure(self):
        """Verificar estrutura básica do script"""
        script_path = os.path.join(os.path.dirname(__file__), '..', 'scripts', 'controller', 'controller_pad.py')
        self.assertTrue(os.path.exists(script_path), "Script controller_pad.py não encontrado")
        
        with open(script_path, 'r') as f:
            content = f.read()
            
        # Verificar se funções essenciais estão definidas
        self.assertIn('def press_key(', content)
        self.assertIn('def press_combo(', content)
        self.assertIn('def handle_input(', content)
        self.assertIn('if __name__ == "__main__":', content)


if __name__ == '__main__':
    print("Executando testes para controller_pad.py...")
    
    # Verificar se dependências estão instaladas antes de executar testes
    try:
        import inputs
        import pynput
    except ImportError:
        print("Aviso: Dependências 'inputs' e/ou 'pynput' não instaladas.")
        print("Para instalar: pip install inputs pynput")
        sys.exit(0)
    
    unittest.main(verbosity=2)