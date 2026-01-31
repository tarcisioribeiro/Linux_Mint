#!/usr/bin/python3
from time import sleep
import pyautogui as gui


class Installer:

    def __init__(self):
        pass
 
    def open_chrome(self):
        sleep(2.5)
        gui.press("win")
        sleep(2.5)
        gui.write("Google Chrome")
        sleep(2.5)
        gui.press("enter")
        sleep(2.5)
        gui.press("tab")

    def install_css_styles(
        self,
        style_url: str,
        x_position: int,
        y_position: int
    ):
        sleep(2.5)
        gui.write(style_url)
        sleep(2.5)
        gui.press("enter")
        sleep(2.5)
        gui.click(x=x_position, y=y_position)
        sleep(2.5)
        gui.hotkey("ctrl", "t")

    def install_chrome_styles(self):
        self.install_css_styles(
            style_url="chrome-extension://clngdbkpkpeebahjckkjfobafhncgmne/install-usercss.html?updateUrl=https%3A%2F%2Fraw.githubusercontent.com%2Fdracula%2Fgithub%2Fmaster%2Fstyle.user.css",
            x_position=74,
            y_position=193
        )
        self.install_css_styles(
            style_url="chrome-extension://clngdbkpkpeebahjckkjfobafhncgmne/install-usercss.html?updateUrl=https%3A%2F%2Fraw.githubusercontent.com%2Fdracula%2Fyoutube%2Fmain%2Fdracula.user.css",
            x_position=77,
            y_position=210
        )
        self.install_css_styles(
            style_url="chrome-extension://clngdbkpkpeebahjckkjfobafhncgmne/install-usercss.html?updateUrl=https%3A%2F%2Fraw.githubusercontent.com%2Fdracula%2Fchatgpt%2Fmain%2Fchatgpt-dracula.user.css",
            x_position=77,
            y_position=210
        )
        self.install_css_styles(
            style_url="chrome-extension://clngdbkpkpeebahjckkjfobafhncgmne/install-usercss.html?updateUrl=https%3A%2F%2Fraw.githubusercontent.com%2Fdracula%2Fgitlab%2Fmaster%2Fdracula.user.css",
            x_position=74,
            y_position=210
        )
        self.install_css_styles(
            style_url="chrome-extension://clngdbkpkpeebahjckkjfobafhncgmne/install-usercss.html?updateUrl=https%3A%2F%2Fuserstyles.world%2Fapi%2Fstyle%2F24931.user.css",
            x_position=68,
            y_position=205
        )
        self.install_css_styles(
            style_url="chrome-extension://clngdbkpkpeebahjckkjfobafhncgmne/install-usercss.html?updateUrl=https%3A%2F%2Fraw.githubusercontent.com%2Fdracula%2Fstackoverflow%2Fmaster%2Fdracula_for_stackoverflow.user.css",
            x_position=73,
            y_position=207
        )
        self.install_css_styles(
            style_url="chrome-extension://clngdbkpkpeebahjckkjfobafhncgmne/install-usercss.html?updateUrl=https%3A%2F%2Fraw.githubusercontent.com%2Fdracula%2Fgoogle-calendar%2Fmain%2Fgcal-dracula.user.css",
            x_position=63,
            y_position=213
        )
        self.install_css_styles(
            style_url="chrome-extension://clngdbkpkpeebahjckkjfobafhncgmne/install-usercss.html?updateUrl=https%3A%2F%2Fraw.githubusercontent.com%2Fdracula%2Fduolingo%2Fmain%2Fdracula-duolingo.user.css",
            x_position=65,
            y_position=215
        )
        self.install_css_styles(
            style_url="chrome-extension://clngdbkpkpeebahjckkjfobafhncgmne/install-usercss.html?updateUrl=https%3A%2F%2Fuserstyles.world%2Fapi%2Fstyle%2F9946.user.css",
            x_position=70,
            y_position=209
        )
        self.install_css_styles(
            style_url="chrome-extension://clngdbkpkpeebahjckkjfobafhncgmne/install-usercss.html?updateUrl=https%3A%2F%2Fraw.githubusercontent.com%2Fdracula%2Fgoogle-search%2Fmain%2Fgoogle-search.user.css",
            x_position=72,
            y_position=209
        )
        self.install_css_styles(
            style_url="chrome-extension://clngdbkpkpeebahjckkjfobafhncgmne/install-usercss.html?updateUrl=https%3A%2F%2Fraw.githubusercontent.com%2Fdracula%2Flichess%2Fmain%2Fdracula-lichess.user.css",
            x_position=68,
            y_position=209
        )
        self.install_css_styles(
            style_url="chrome-extension://clngdbkpkpeebahjckkjfobafhncgmne/install-usercss.html?updateUrl=https%3A%2F%2Fraw.githubusercontent.com%2Fdracula%2Fcodepen%2Fmain%2Fstyle.user.styl",
            x_position=66,
            y_position=191
        ) 

if __name__ == "__main__":
    installer = Installer()
    installer.open_chrome()
    installer.install_chrome_styles()
