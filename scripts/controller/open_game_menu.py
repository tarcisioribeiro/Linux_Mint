#!/usr/bin/python3

import pyudev
import os
import subprocess
import time


def open_game_menu():
    print("Controle Xbox conectado! Abrindo seu script personalizado...")
    subprocess.Popen(["bash", os.path.expandvars("$HOME/.config/rofi/applets/bin/games.sh")])

def monitoring_xbox_controller():
    context = pyudev.Context()
    monitor = pyudev.Monitor.from_netlink(context)
    monitor.filter_by(subsystem='input')

    print("Aguardando conexão do controle Xbox via Bluetooth...")

    for device in iter(monitor.poll, None):
        if device.action == 'add':
            if "xbox" in device.get('NAME', '').lower() or \
               "xpad" in device.get('DRIVER', '').lower() or \
               "Microsoft X-Box" in str(device).lower():
               time.sleep(5)
               open_game_menu()


if __name__ == "__main__":
    try:
        monitoring_xbox_controller()
    except KeyboardInterrupt:
        print("\nInterrompido pelo usuário.")
