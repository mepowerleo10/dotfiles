-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")
local lain = require("lain")

-- Theme handling library
local beautiful = require("beautiful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local collision = require("collision")
collision()

cyclefocus = require("cyclefocus")

local helpers = require("helpers")

local naughty = require("naughty")

local dpi = require("beautiful.xresources").apply_dpi

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify(
        {
            preset = naughty.config.presets.critical,
            title = "Oops, there were errors during startup!",
            text = awesome.startup_errors
        }
    )
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal(
        "debug::error",
        function(err)
            -- Make sure we don't go into an endless error loop
            if in_error then
                return
            end
            in_error = true

            naughty.notify(
                {
                    preset = naughty.config.presets.critical,
                    title = "Oops, an error happened!",
                    text = tostring(err)
                }
            )
            in_error = false
        end
    )
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/mepowerleo10/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "gnome-terminal"
editor = os.getenv("EDITOR") or "vi"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    {
        "hotkeys",
        function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end
    },
    {"manual", terminal .. " -e man awesome"},
    {"edit config", editor_cmd .. " " .. awesome.conffile},
    {"restart", awesome.restart},
    {
        "quit",
        function()
            awesome.quit()
        end
    }
}

mymainmenu =
    awful.menu(
    {
        items = {
            {"awesome", myawesomemenu, beautiful.awesome_icon},
            {"open terminal", terminal}
        }
    }
)

mylauncher =
    awful.widget.launcher(
    {
        image = beautiful.awesome_icon,
        menu = mymainmenu
    }
)

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons =
    gears.table.join(
    awful.button(
        {},
        1,
        function(t)
            t:view_only()
        end
    ),
    awful.button(
        {modkey},
        1,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end
    ),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button(
        {modkey},
        3,
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end
    ),
    awful.button(
        {},
        4,
        function(t)
            awful.tag.viewnext(t.screen)
        end
    ),
    awful.button(
        {},
        5,
        function(t)
            awful.tag.viewprev(t.screen)
        end
    )
)

local tasklist_buttons =
    gears.table.join(
    awful.button(
        {},
        1,
        function(c)
            if c == client.focus then
                c.minimized = true
            else
                c:emit_signal("request::activate", "tasklist", {raise = true})
            end
        end
    ),
    awful.button(
        {},
        2,
        function(c)
            c:kill()
        end
    ),
    awful.button(
        {},
        3,
        function()
            awful.menu.client_list({theme = {width = 250}})
        end
    ),
    awful.button(
        {},
        4,
        function()
            awful.client.focus.byidx(1)
        end
    ),
    awful.button(
        {},
        5,
        function()
            awful.client.focus.byidx(-1)
        end
    )
)

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(
    function(s)
        -- Wallpaper
        set_wallpaper(s)

        require("tags")

        -- Create a promptbox for each screen
        s.mypromptbox = awful.widget.prompt()
        -- Create an imagebox widget which will contain an icon indicating which layout we're using.
        -- We need one layoutbox per screen.
        s.mylayoutbox = awful.widget.layoutbox(s)
        s.mylayoutbox:buttons(
            gears.table.join(
                awful.button(
                    {},
                    1,
                    function()
                        awful.layout.inc(1)
                    end
                ),
                awful.button(
                    {},
                    3,
                    function()
                        awful.layout.inc(-1)
                    end
                ),
                awful.button(
                    {},
                    4,
                    function()
                        awful.layout.inc(1)
                    end
                ),
                awful.button(
                    {},
                    5,
                    function()
                        awful.layout.inc(-1)
                    end
                )
            )
        )
        -- Create a taglist widget
        s.mytaglist =
            awful.widget.taglist {
            screen = s,
            filter = awful.widget.taglist.filter.all,
            buttons = taglist_buttons,
            widget_template = {
                {
                    {
                        {
                            id = "icon_role",
                            widget = wibox.widget.imagebox
                        },
                        margins = 2,
                        widget = wibox.container.margin
                    },
                    {
                        id = "separator",
                        {
                            id = "separator_text",
                            widget = wibox.widget.textbox
                        },
                        left = 0,
                        right = 2,
                        widget = wibox.container.margin
                    },
                    {
                        id = "tag_name",
                        widget = wibox.widget.textbox
                    },
                    layout = wibox.layout.fixed.horizontal
                },
                left = 2,
                right = 2,
                widget = wibox.container.margin,
                update_callback = function(self, t, index, tags) --luacheck: no unused args
                    local selected_tag = awful.screen.focused().selected_tag
                    if selected_tag ~= t then
                        self:get_children_by_id("separator")[1].right = 0
                        self:get_children_by_id("separator_text")[1].markup = ""
                        self:get_children_by_id("tag_name")[1].markup = ""
                    else
                        self:get_children_by_id("separator")[1].right = 2
                        self:get_children_by_id("separator_text")[1].markup = "•"
                        self:get_children_by_id("tag_name")[1].markup = t.name
                    end
                    self:connect_signal(
                        "mouse::enter",
                        function()
                            if self.bg ~= "#ff0000" then
                                self.backup = self.bg
                                self.has_backup = true
                            end
                            self.bg = "#ff0000"
                        end
                    )
                    self:connect_signal(
                        "mouse::leave",
                        function()
                            if self.has_backup then
                                self.bg = self.backup
                            end
                        end
                    )
                end
            }
        }

        -- Create a tasklist widgetpop
        s.mytasklist =
            awful.widget.tasklist {
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_buttons,
            widget_template = {
                {
                    {
                        {
                            {
                                id = "icon_role",
                                widget = wibox.widget.imagebox
                            },
                            margins = 2,
                            widget = wibox.container.margin
                        },
                        {
                            id = "text_role",
                            widget = wibox.widget.textbox
                        },
                        layout = wibox.layout.fixed.horizontal
                    },
                    left = 3,
                    right = 3,
                    widget = wibox.container.margin
                },
                id = "background_role",
                widget = wibox.container.background,
                create_callback = function(self, c, index, clients)
                    local tooltip =
                        awful.tooltip(
                        {
                            objects = {self},
                            timer_function = function()
                                return c.name
                            end
                        }
                    )
                    tooltip.align = "left"
                    tooltip.mode = "outside"
                    tooltip.preferred_positions = {"left"}
                end
            },
            
        }

        local weather_widget = require("widgets.weather-widget.weather")
        local mpdstatus_widget = require("widgets.mpdstatus.mpdstatus")
        local battery_widget = require("widgets.battery-widget.battery")

        local tray = wibox.widget.systray()
        tray:set_base_size(16)

        local arrow_sep =
            wibox.widget {
            bg = "#4B696D",
            forced_width = 12,
            span_ratio = 0.5,
            widget = wibox.widget.textbox,
            text = "›"
        }

        -- Create the wibox
        s.mywibox = awful.wibar({position = "top", screen = s})
        -- Add widgets to the wibox
        s.mywibox:setup {
            layout = wibox.layout.align.horizontal,
            {
                -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                -- mylauncher,
                s.mytaglist,
                s.mypromptbox
            },
            s.mytasklist, -- Middle widget
            {
                -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                {
                    spacing = 5,
                    layout = wibox.layout.fixed.horizontal,
                    mykeyboardlayout,
                    weather_widget(
                        {
                            api_key = "e5d6565ea5aaefba70e5fd671f801cfa",
                            -- coordinates = {-6.824, 39.270}, -- Dar-es-salaam
                            coordinates = {-6.2180937, 35.8084139}, -- Dodoma, In4mtx
                            time_format_12h = true,
                            units = "metric",
                            both_units_widget = false,
                            font_name = "Iosevka",
                            icons = "weather-underground-icons",
                            show_hourly_forecast = true,
                            show_daily_forecast = true,
                            timeout = 1200
                        }
                    ),
                    arrow_sep,
                    mpdstatus_widget,
                    arrow_sep,
                    mytextclock
                },
                {
                    layout = wibox.container.margin(_, 0, 0, 2, 1),
                    tray
                },
                {
                    layout = wibox.layout.fixed.horizontal,
                    battery_widget(
                        {
                            path_to_icons = "/usr/share/icons/Newaita-dark/.DP/32/",
                            -- path_to_icons = os.getenv("HOME") .. "/.local/share/icons/Qogir-dark/symbolic/status/"
                            font = "Iosevka 8"
                        }
                    )
                },
                s.mylayoutbox
            }
        }
    end
)
-- }}}

-- Keybindings
require("keys")

-- Rulesnice
require("rules")

local nice = require("nice")
nice {
    titlebar_height = 20,
    titlebar_font = "Iosevka 8",
    titlebar_radius = 0,
    button_size = 12,
    win_shade_enabled = true,
    no_titlebar_maximized = true,
    titlebar_items = {
        left = {},
        right = {"minimize", "maximize", "close"},
        middle = "title"
    },
    context_menu_theme = {
        bg_focus = beautiful.bg_focus,
        bg_normal = beautiful.bg_normal,
        border_color = "#00000000",
        border_width = 1,
        fg_focus = beautiful.fg_focus,
        fg_normal = beautiful.fg_normal,
        font = "Iosevka 8",
        height = 20,
        width = 250
    }
}

-- {{{ Signals

function Set(list)
    local set = {}
    for _, l in ipairs(list) do
        set[l] = true
    end
    return set
end

-- client titlebar toggling
function client_titlebars_toggle(c)
    local height = 19.0
    local non_titled_windows = Set {}
    if non_titled_windows[c.class] then
        if c.maximized then
            -- Remove titlebars on a maximized client
            awful.titlebar.hide(c)
            c.height = c.height + dpi(height)
        else
            c.height = c.height - dpi(height)
            c:emit_signal("request::titlebars")
        end
    end
end

function set_forced_geometry(c)
    if c.floating then
        if c.class == "feh" then
            --599
            c.width = 573
            --662
            c.height = 484
        elseif c.class == "Org.gnome.Nautilus" and not c.role == "dialog" then
            c.width = 824
            c.height = 507
        end
    end
end

-- Signal function to execute when a new client appears.
client.connect_signal(
    "manage",
    function(c)
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- if not awesome.startup then awful.client.setslave(c) end

        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end

        set_forced_geometry(c)
    end
)

-- Manage clients intending to change their geometry
client.connect_signal(
    "request::geometry",
    function(c)
        set_forced_geometry(c)
    end
)
-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal(
    "mouse::enter",
    function(c)
        c:emit_signal("request::activate", "mouse_enter", {raise = false})
    end
)

client.connect_signal(
    "focus",
    function(c)
        c.border_color = beautiful.border_focus
    end
)
client.connect_signal(
    "unfocus",
    function(c)
        c.border_color = beautiful.border_normal
    end
)
-- }}}

-- {{{ Handle layout changes to floating
client.connect_signal(
    "property::size",
    function(c)
        if c.floating and c.role == "normal" then
            c.width = 867
            c.height = 505
        end
    end
)

client.connect_signal(
    "property::name",
    function(c)
        if not string.match(c.name, "nil") then
            c.name = helpers.get_substring(c.name, 30)
        else
            c.name = "  "
        end
    end
)
-- }}}

-- {{{ Autostart apps
require("apps")
start_apps()
-- }}}
