#!/usr/bin/python3

from inputs import get_gamepad, UnpluggedError
from pynput.keyboard import Controller as KeyboardController, Key
from pynput.mouse import Controller as MouseController, Button
import time

keyboard = KeyboardController()
mouse = MouseController()

pressed_buttons = set()

def press_key(key):
    keyboard.press(key)
    keyboard.release(key)

def press_combo(keys):
    for key in keys:
        keyboard.press(key)
    for key in reversed(keys):
        keyboard.release(key)

def handle_input():
    print("Aguardando controle ser conectado...")
    while True:
        try:
            events = get_gamepad()
        except UnpluggedError:
            time.sleep(1)
            continue

        for event in events:
            # --- BOTÕES DE AÇÃO ---
            if event.ev_type == "Key":
                if event.code == "BTN_START":
                    if event.state and "START" not in pressed_buttons:
                        press_combo([Key.alt, Key.space])
                        pressed_buttons.add("START")
                    elif not event.state:
                        pressed_buttons.discard("START")

                elif event.code == "BTN_SOUTH":  # A
                    if event.state and "A" not in pressed_buttons:
                        press_key(Key.enter)
                        pressed_buttons.add("A")
                    elif not event.state:
                        pressed_buttons.discard("A")

                elif event.code == "BTN_THUMBL":  # Left analog press
                    if event.state and "L_PRESS" not in pressed_buttons:
                        mouse.press(Button.left)
                        mouse.release(Button.left)
                        pressed_buttons.add("L_PRESS")
                    elif not event.state:
                        pressed_buttons.discard("L_PRESS")

                elif event.code == "BTN_THUMBR":  # Right analog press
                    if event.state and "R_PRESS" not in pressed_buttons:
                        mouse.press(Button.right)
                        mouse.release(Button.right)
                        pressed_buttons.add("R_PRESS")
                    elif not event.state:
                        pressed_buttons.discard("R_PRESS")

            # --- D-PAD DIRECIONAL ---
            elif event.ev_type == "Absolute":
                if event.code == "ABS_HAT0Y":
                    if event.state == -1 and "UP" not in pressed_buttons:
                        press_key(Key.up)
                        pressed_buttons.add("UP")
                    elif event.state == 1 and "DOWN" not in pressed_buttons:
                        press_key(Key.down)
                        pressed_buttons.add("DOWN")
                    elif event.state == 0:
                        pressed_buttons.discard("UP")
                        pressed_buttons.discard("DOWN")

                elif event.code == "ABS_HAT0X":
                    if event.state == -1 and "LEFT" not in pressed_buttons:
                        press_key(Key.left)
                        pressed_buttons.add("LEFT")
                    elif event.state == 1 and "RIGHT" not in pressed_buttons:
                        press_key(Key.right)
                        pressed_buttons.add("RIGHT")
                    elif event.state == 0:
                        pressed_buttons.discard("LEFT")
                        pressed_buttons.discard("RIGHT")

        time.sleep(0.01)  # mais responsivo

if __name__ == "__main__":
    print("Modo controle de teclado ativado com Xbox Controller.")
    try:
        handle_input()
    except KeyboardInterrupt:
        print("Encerrado pelo usuário.")
