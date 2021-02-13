 -- Each screen has its own tag table.
 local names = {
    "web",
    "code",
    "files",
    "term",
    "chat",
    "music",
    "mail",
    8,
    9
}

local awful = require("awful")

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
local l = awful.layout.suit
local layouts = {
    l.floating,
    l.floating,
    l.floating,
    l.fair,
    l.floating,
    l.floating,
    l.floating,
    l.floating,
    l.floating
}

local icon_folder = '/home/mepowerleo10/.local/share/icons/WhiteSur/apps/scalable/'
local default_layout = l.floating
awful.tag.add("web", {
    icon = icon_folder .. "applications-webbrowsers.svg",
    layout = default_layout,
    master_fill_policy = "expand",
    screen = s,
    selected = true
})

awful.tag.add("code", {
    icon = icon_folder .. "code-oss.svg",
    layout = default_layout,
    master_fill_policy = "master_width_factor",
    screen = s
})

awful.tag.add("files", {
    icon = icon_folder .. "org.gnome.nautilus.svg",
    layout = default_layout,
    master_fill_policy = "master_width_factor",
    screen = s
})

awful.tag.add("term", {
    icon = icon_folder .. "terminal.svg",
    layout = l.fair,
    master_fill_policy = "master_width_factor",
    screen = s
})

awful.tag.add("chat", {
    icon = icon_folder .. "internet-chat.svg",
    layout = default_layout,
    master_fill_policy = "master_width_factor",
    screen = s
})

awful.tag.add("music", {
    icon = icon_folder .. "gnome-music.svg",
    layout = default_layout,
    master_fill_policy = "master_width_factor",
    screen = s
})

awful.tag.add("mail", {
    icon = icon_folder .. "internet_mail.svg",
    layout = default_layout,
    master_fill_policy = "master_width_factor",
    screen = s
})

awful.tag.add("options", {
    icon = icon_folder .. "gnome-settings.svg",
    layouts = default_layout,
    master_fill_policy = "master_width_factor",
    screen = s
})

awful.tag.add("others", {
    icon = icon_folder .. "text-editor.svg",
    layouts = default_layout,
    master_fill_policy = "master_width_factor",
    screen = s
})