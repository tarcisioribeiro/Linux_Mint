#!/usr/bin/env python3
from datetime import datetime
import subprocess
import time
import os


home_dir = os.environ.get("HOME")


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

    if seconds >= 18000 and seconds < 25200:
        temp = 4000
        wp_command = f"""
        bash '{home_dir}/scripts/autostart/wallpapers/aurora.sh'
        """

    elif seconds >= 25200 and seconds < 39600:
        temp = 4500
        wp_command = f"""
        bash '{home_dir}/scripts/autostart/wallpapers/morning.sh'
        """

    elif seconds >= 39600 and seconds < 57600:
        temp = 5500
        wp_command = f"""
        bash '{home_dir}/scripts/autostart/wallpapers/afternoon.sh'
        """

    elif seconds >= 57600 and seconds < 64800:
        temp = 4500
        wp_command = f"bash '{home_dir}/scripts/autostart/wallpapers/dusk.sh'"

    elif seconds >= 64800 and seconds < 79200:
        temp = 4000
        wp_command = f"bash '{home_dir}/scripts/autostart/wallpapers/night.sh'"

    elif (
            seconds >= 79200 and seconds <= 86400
        ) or (
            seconds >= 1 and seconds < 18000):
        temp = 3500
        wp_command = f"bash '{home_dir}/scripts/autostart/wallpapers/dawn.sh'"

    else:
        temp = 4000

    subprocess.run(
        wp_command,
        shell=True,
        capture_output=False,
        text=True
    )

    command = f"redshift -x && redshift -P -O {temp}"

    subprocess.run(
        command,
        shell=True,
        capture_output=True,
        text=True
    )

    time.sleep(2)

    print("Ambiente configurado com sucesso!")
    print("Reativando teclado e mouse...")

    enable_input_devices(keyboard_id, mouse_id)


if __name__ == "__main__":
    calculate_seconds()
