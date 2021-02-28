local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local naughty = require("naughty")
local menubar_icon_theme = require("menubar.icon_theme")
local menubar_utils = require("menubar.utils")

local helpers = require("helpers")

-- Timeouts
naughty.config.presets.low.timeout = 3
naughty.config.presets.critical.timeout = 0

naughty.config.presets.normal = {
    font = beautiful.font,
    fg = beautiful.fg_normal,
    bg = beautiful.bg_normal
}

naughty.config.presets.low = {
    font = beautiful.font,
    fg = beautiful.fg_normal,
    bg = beautiful.bg_normal
}

naughty.config.presets.critical = {
    -- font = beautiful.font_name .. "10",
    -- fg = beautiful.xcolor1,
    bg = beautiful.bg_urgent,
    timeout = 0
}

naughty.config.presets.ok = naughty.config.presets.normal
naughty.config.presets.info = naughty.config.presets.normal
naughty.config.presets.warn = naughty.config.presets.critical

local icon_theme = os.getenv("HOME") .. "/.local/share/icons/WhiteSur/"
naughty.config.icon_dirs = {
    icon_theme .. "devices/scalable/",
    icon_theme .. "apps/scalable/",
    icon_theme .. "mimes/scalable/"
}
naughty.connect_signal(
    "request::preset",
    function(n, context, args)
        n.timeout = 3
        if n.urgency == "critical" then
            n.bg = beautiful.bg_urgent
        end

        local icon_folder = icon_theme .. "devices/scalable/"

        if string.match(n.app_name, "udiskie") then
            n.icon = icon_folder .. "drive-removable-media.svg"
        elseif string.match(n.app_name, "pasystray") then
            n.icon = icon_folder .. "audio-speakers.svg"
        elseif string.match( n.app_name,"blueman") then
            n.icon = icon_folder .. "bluetooth.svg"
        end
        -- n.position = "bottom_right"
    end
)

naughty.connect_signal("request::action_icon", function(a, context, hints)
    a.icon = menubar_utils.lookup_icon(hints.id)
end)

naughty.connect_signal("request::icon", function(n, context, hints)
    if context ~= "app_icon" then return end

    local path = menubar_utils.lookup_icon(hints.app_icon) or
        menubar_utils.lookup_icon(hints.app_icon:lower())

    if path then
        n.icon = path
    end
end)