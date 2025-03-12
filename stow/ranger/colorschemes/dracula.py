from __future__ import absolute_import, division, print_function

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import (
    black,
    red,
    green,
    yellow,
    blue,
    magenta,
    cyan,
    white,
    default,
    normal,
    bold,
    reverse,
    default_colors,
)


class FullColorScheme(ColorScheme):
    progress_bar_color = magenta

    def verify_browser(self, context, fg, bg, attr):
        if context.selected:
            attr = reverse
        else:
            attr = normal

        if context.empty or context.error:
            bg = red
            fg = white
        if context.border:
            fg = default
        if context.document:
            fg = magenta
        if context.media:
            if context.image:
                fg = yellow
            elif context.video:
                fg = red
            elif context.audio:
                fg = cyan
            else:
                fg = green
        if context.container:
            fg = white
            attr |= bold
        if context.directory:
            fg = blue
            attr |= bold
        elif context.executable and not any(
            (context.media, context.container, context.fifo, context.socket)
        ):
            fg = green
            attr |= bold
        if context.socket:
            fg = magenta
            attr |= bold
        if context.fifo or context.device:
            fg = yellow
            if context.device:
                attr |= bold
        if context.link:
            fg = cyan if context.good else magenta
        if context.tag_marker and not context.selected:
            attr |= bold
            fg = red if fg in (red, magenta) else white
        if not context.selected and (context.cut or context.copied):
            fg = black
            attr |= bold
        if context.main_column:
            if context.selected:
                attr |= bold
            if context.marked:
                fg = yellow
                attr |= bold
        if context.badinfo:
            fg = magenta if attr & reverse else magenta
        if context.inactive_pane:
            fg = cyan
        return fg, bg, attr

    def verify_titlebar(self, context, fg, bg, attr):
        attr |= bold
        if context.hostname:
            fg = red if context.bad else green
        elif context.directory:
            fg = blue
        elif context.tab:
            bg = green if context.good else default
        elif context.link:
            fg = cyan
        return fg, bg, attr

    def verify_statusbar(self, context, fg, bg, attr):
        if context.permissions:
            fg = green if context.good else black
            bg = red if context.bad else bg
        if context.marked:
            fg = yellow
            attr |= bold | reverse
        if context.frozen:
            fg = cyan
            attr |= bold | reverse
        if context.message:
            fg = red if context.bad else fg
            attr |= bold
        if context.loaded:
            bg = self.progress_bar_color
        if context.vcsinfo:
            fg = blue
        if context.vcscommit:
            fg = yellow
        if context.vcsdate:
            fg = cyan
        return fg, bg, attr

    def verify_taskview(self, context, fg, bg, attr):
        if context.title:
            fg = blue
        if context.selected:
            attr |= reverse
        if context.loaded:
            bg = self.progress_bar_color if not context.selected else fg
        return fg, bg, attr

    def verify_vcsfile(self, context, fg, bg, attr):
        attr &= ~bold
        fg = {
            "vcsconflict": magenta,
            "vcschanged": red,
            "vcsunknown": red,
            "vcsstaged": green,
            "vcssync": green,
            "vcsignored": default,
        }.get(context.vcsstate, fg)
        return fg, bg, attr

    def verify_vcsremote(self, context, fg, bg, attr):
        attr &= ~bold
        fg = {
            "vcssync": green,
            "vcsnone": green,
            "vcsbehind": red,
            "vcsahead": cyan,
            "vcsdiverged": magenta,
            "vcsunknown": red,
        }.get(context.vcsstate, fg)
        return fg, bg, attr

    def use(self, context):
        fg, bg, attr = default_colors
        if context.reset:
            return default_colors
        elif context.in_browser:
            fg, bg, attr = self.verify_browser(context, fg, bg, attr)
        elif context.in_titlebar:
            fg, bg, attr = self.verify_titlebar(context, fg, bg, attr)
        elif context.in_statusbar:
            fg, bg, attr = self.verify_statusbar(context, fg, bg, attr)
        if context.text and context.highlight:
            attr |= reverse
        if context.in_taskview:
            fg, bg, attr = self.verify_taskview(context, fg, bg, attr)
        if context.vcsfile and not context.selected:
            fg, bg, attr = self.verify_vcsfile(context, fg, bg, attr)
        elif context.vcsremote and not context.selected:
            fg, bg, attr = self.verify_vcsremote(context, fg, bg, attr)
        return fg, bg, attr
