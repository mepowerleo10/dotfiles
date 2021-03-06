-------------------------------
--  "Zenburn" awesome theme  --
--    By Adrian C. (anrxc)   --
-------------------------------

local themes_path = require("gears.filesystem").get_themes_dir()
local dpi = require("beautiful.xresources").apply_dpi
local naughty = require("naughty")
local beautiful = require("beautiful")
local shape = require("gears.shape")

-- {{{ Main
local theme = {}
theme.wallpaper = themes_path .. "zenburn/zenburn-background.png"
theme.confdir = os.getenv("HOME") .. "/.config/awesome/"
-- }}}

-- {{{ Styles
theme.font = "Iosevka 8"

-- {{{ Colors
theme.fg_normal = "#DCDCCC"
theme.fg_focus = "#F0DFAF"
theme.fg_urgent = "#CC9393"
theme.bg_normal = "#3F3F3F"
theme.bg_focus = "#1E2320"
-- theme.bg_urgent = "#893F45" -- Cordovan
-- theme.bg_urgent = "#AB4E52" -- Rose vale
-- theme.bg_urgent = "#BF4F51" -- Bittersweet shimmer
theme.bg_urgent = "#D05340" -- Jasper
-- theme.bg_urgent  = "#eb5454"
-- theme.bg_urgent  = "#592727"
theme.bg_systray = theme.bg_normal
theme.systray_icon_spacing = 2
-- }}}

-- {{{ Borders
theme.useless_gap = dpi(0)
theme.border_width = dpi(2)
theme.border_normal = "#3F3F3F"
theme.border_focus = "#6F6F6F"
theme.border_marked = "#CC9393"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus = "#3F3F3F"
theme.titlebar_bg_normal = "#3F3F3F"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
theme.taglist_bg_focus = theme.bg_normal
-- }}}

-- {{{ Widgets
-- https://github.com/streetturtle/awesome-wm-widget
theme.widget_main_color = "#74aeab"
theme.widget_red = "#e53935"
theme.widget_yelow = "#c0ca33"
theme.widget_green = "#43a047"
theme.widget_black = "#000000"
theme.widget_transparent = "#00000000"

-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)
-- }}}

-- {{{ Icons
-- {{{ Taglist
-- theme.taglist_squares_sel   = themes_path .. "zenburn/taglist/squarefz.png"
theme.taglist_squares_sel = nil
-- theme.taglist_squares_unsel = themes_path .. "zenburn/taglist/squarez.png"
theme.taglist_squares_unsel = nil
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon = themes_path .. "zenburn/awesome-icon.png"
theme.menu_submenu_icon = themes_path .. "default/submenu.png"
-- }}}

-- {{{ Layout
theme.layout_tile = theme.confdir .. "likee/icons/tile.png"
theme.layout_tileleft = theme.confdir .. "likee/icons/tileleft.png"
theme.layout_tilebottom = theme.confdir .. "likee/icons/tilebottom.png"
theme.layout_tiletop = theme.confdir .. "likee/icons/tiletop.png"
theme.layout_fairv = theme.confdir .. "likee/icons/fairv.png"
theme.layout_fairh = theme.confdir .. "likee/icons/fairh.png"
theme.layout_spiral = theme.confdir .. "likee/icons/spiral.png"
theme.layout_dwindle = theme.confdir .. "likee/icons/dwindle.png"
theme.layout_max = theme.confdir .. "likee/icons/max.png"
theme.layout_fullscreen = theme.confdir .. "likee/icons/fullscreen.png"
theme.layout_magnifier = theme.confdir .. "likee/icons/magnifier.png"
theme.layout_floating = theme.confdir .. "likee/icons/floating.png"
theme.layout_cornernw = theme.confdir .. "likee/icons/cornernw.png"
theme.layout_cornerne = theme.confdir .. "likee/icons/cornerne.png"
theme.layout_cornersw = theme.confdir .. "likee/icons/cornersw.png"
theme.layout_cornerse = theme.confdir .. "likee/icons/cornerse.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus = themes_path .. "zenburn/titlebar/close_focus.png"
theme.titlebar_close_button_normal = themes_path .. "zenburn/titlebar/close_normal.png"

theme.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus = themes_path .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_focus_active = themes_path .. "zenburn/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "zenburn/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive = themes_path .. "zenburn/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = themes_path .. "zenburn/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active = themes_path .. "zenburn/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "zenburn/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive = themes_path .. "zenburn/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = themes_path .. "zenburn/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active = themes_path .. "zenburn/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = themes_path .. "zenburn/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive = themes_path .. "zenburn/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = themes_path .. "zenburn/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active = themes_path .. "zenburn/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "zenburn/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive = themes_path .. "zenburn/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = themes_path .. "zenburn/titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

-- {{{ Naughty notifications configuration
theme.notification_position = "bottom_right"
-- theme.notification_border_width = dpi(0)
-- theme.notification_border_radius = theme.border_radius
theme.notification_border_color = "#2b2b2b"
-- theme.notification_bg = x.background
-- theme.notification_fg = x.foreground
theme.notification_crit_bg = theme.bg_urgent
-- theme.notification_crit_fg = x.color1
theme.notification_icon_size = dpi(48)
-- theme.notification_height = dpi(80)
theme.notification_width = dpi(300)
-- theme.notification_margin = dpi(48)
-- theme.notification_opacity = 1
-- theme.notification_font = "Iosevka 8"
theme.notification_padding = dpi(5) * 2
theme.notification_spacing = dpi(5) * 4
theme.notification_icon =
    "/home/mepowerleo10/.local/share/icons/WhiteSur/apps/scalable/preferences-desktop-notification.svg"

-- Tasklist configuration
theme.tasklist_plain_task_name = true
-- theme.tasklist_disable_task_name = true

--[[ naughty.config.presets {
    critical = {
        bg = "#F06060",
        fg = "#EEE9EF",
        width = 300,
        screen = mouse.screen,
        icon_size = 48,
        hover_timeout = 0.5,
    }
} ]]
-- beautiful.notification_icon_size = 48
-- }}}

-- Collision color schemes
beautiful.collision_focus_bg_center = theme.bg_focus
theme.collision_resize_bg = theme.bg_normal
theme.collision_focus_bg = theme.bg_normal
theme.collision_resize_shape = shape.rectangle
theme.collision_focus_shape = shape.rectangle
theme.collision_focus_shape_center = shape.rectangle
theme.collision_resize_width = dpi(5) * 5
theme.collision_shape_width = dpi(5) * 7
theme.collision_shape_height = dpi(5) * 7

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
