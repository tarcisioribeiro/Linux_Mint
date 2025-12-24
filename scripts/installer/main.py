import pyautogui
from time import sleep


def main():
    sleep(2)
    pyautogui.hotkey('ctrl', 'shift', 'enter')
    sleep(2)


if __name__ == "__main__":
    main()
