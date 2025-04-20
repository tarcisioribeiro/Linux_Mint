#!/usr/bin/env python3
from datetime import datetime
import subprocess
import time


def disable_input_devices():
    def get_device_id(name):
        try:
            output = subprocess.check_output(
                "xinput list",
                shell=True
            ).decode()
            for line in output.splitlines():
                if name.lower() in line.lower():
                    parts = line.split()
                    for part in parts:
                        if part.startswith("id="):
                            return part.split("=")[1]
        except Exception as e:
            print(f"Erro ao buscar dispositivo '{name}':", e)
        return None

    keyboard_id = get_device_id("keyboard")
    mouse_id = get_device_id("mouse")

    if keyboard_id:
        subprocess.run(f"xinput disable {keyboard_id}", shell=True)
    if mouse_id:
        subprocess.run(f"xinput disable {mouse_id}", shell=True)

    return keyboard_id, mouse_id


def enable_input_devices(keyboard_id, mouse_id):
    if keyboard_id:
        subprocess.run(f"xinput enable {keyboard_id}", shell=True)
    if mouse_id:
        subprocess.run(f"xinput enable {mouse_id}", shell=True)


def calculate_seconds():

    print("Desativando teclado e mouse...")
    keyboard_id, mouse_id = disable_input_devices()

    now = datetime.now().time()
    time_values = [int(float(part)) for part in str(now).split(":")]
    time_seconds = [3600, 60, 1]
    seconds = sum([t * s for t, s in zip(time_values, time_seconds)])

    if 0 <= seconds < 14400:
        temp = 4500
    elif 14400 <= seconds < 28800:
        temp = 5000
    elif 28800 <= seconds < 57600:
        temp = 5500
    elif 57600 <= seconds < 72000:
        temp = 5000
    elif 72000 <= seconds < 72000:
        temp = 4500
    else:
        temp = 4000

    command = f"redshift -x && redshift -P -O {temp}"
    result = subprocess.run(
        command,
        shell=True,
        capture_output=True,
        text=True
    )

    print("Saída:", result.stdout)
    print("Erros:", result.stderr)

    time.sleep(2)

    print("Ambiente configurado com sucesso!")

    print("Reativando teclado e mouse...")
    enable_input_devices(keyboard_id, mouse_id)

if __name__ == "__main__":
    calculate_seconds()
