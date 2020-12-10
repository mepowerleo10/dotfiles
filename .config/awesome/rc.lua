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
-- Notification library
-- local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

require("collision")()

local helpers = require("helpers")

local naughty = require("naughty")

-- Revelation MacOSX's expose
local revelation = require("revelation")
-- beautiful.init()
revelation.init()

-- require("exit-screen")

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
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    {"hotkeys", function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end},
    {"manual", terminal .. " -e man awesome"},
    {"edit config", editor_cmd .. " " .. awesome.conffile},
    {"restart", awesome.restart},
    {"quit", function()
            awesome.quit()
        end}
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
local year_calendar = awful.widget.calendar_popup.year()

-- year_calendar:attach( mytextclock, "tr", {on_hover = false} )

mytextclock:buttons(
    awful.util.table.join(
        awful.button(
            {},
            1,
            function()
                year_calendar:toggle()
            end
        )
    )
)

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
        function (c)
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

        -- Each screen has its own tag table.
        -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

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
        local l = awful.layout.suit
        local layouts = {
            l.floating,
            l.tile,
            l.floating,
            l.fair,
            l.max,
            l.floating,
            l.tile.left,
            l.floating,
            l.floating
        }
        awful.tag(names, s, layouts)

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
            buttons = taglist_buttons
        }

        -- Create a tasklist widgetpop
        s.mytasklist =
            awful.widget.tasklist {
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_buttons
        }

        local weather_widget = require("widgets.weather-widget.weather")
        local mpdstatus_widget = require("widgets.mpdstatus.mpdstatus")
        local battery_widget = require("widgets.battery-widget.battery")
        -- local capslock_widget = require("widgets.capslock.capslock")
        -- local todo_widget = require("widgets.todo-widget.todo")
        -- local github_activity_widget = require("widgets.github-activity-widget.github-activity-widget")
        -- local ram_widget = require("widgets.ram-widget.ram-widget")
        -- local netspeed_widget = require("widgets.net-speed-widget.net-speed")
        -- local awwmoji = require("widgets.awwmoji.awwmoji")

        local tray = wibox.widget.systray()
        tray:set_base_size(16)

        local arrow_sep =
            wibox.widget {
            -- shape = function(cr, w, h, ...)
            --     local f = gears.shape.transform(gears.shape.powerline):rotate_at(w / 2, h / 2, math.pi)
            --     f(cr, w, h, ...)
            -- end,
            bg = "#4B696D",
            forced_width = 12,
            span_ratio = 0.5,
            -- widget = wibox.widget.separator,
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
                    spacing = 5, -- Pushed down from 5
                    layout = wibox.layout.fixed.horizontal,
                    -- awwmoji,
                    mykeyboardlayout,
                    weather_widget(
                        {
                            api_key = "e5d6565ea5aaefba70e5fd671f801cfa",
                            coordinates = {-6.824, 39.270},
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
                            font = "Iosevka 8",
                            enable_battery_warning = false
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

-- Rules
require("rules")

-- {{{ Signals

-- client titlebar toggling
function client_titlebars_toggle(c)
    if c.maximized then
        -- Remove titlebars on a maximized client
        awful.titlebar.hide(c)
        c.height = c.height + 20
    elseif c.titlebars_enabled then
        c.height = c.height - 20
        -- awful.titlebar.show(c)
        c:emit_signal("request::titlebars")
    end
end

-- Signal function to execute when a new client appears.
client.connect_signal(
    "manage",
    function(c)
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- if not awesome.startup then awful.client.setslave(c) end

        client_titlebars_toggle(c)

        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end
)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal(
    "request::titlebars",
    function(c)
        -- buttons for the titlebar
        local buttons =
            gears.table.join(
            awful.button(
                {},
                1,
                function()
                    c:emit_signal("request::activate", "titlebar", {raise = true})
                    awful.mouse.client.move(c)
                end
            ),
            awful.button(
                {},
                3,
                function()
                    c:emit_signal("request::activate", "titlebar", {raise = true})
                    awful.mouse.client.resize(c)
                end
            )
        )

        awful.titlebar(c):setup {
            {
                -- Left
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout = wibox.layout.fixed.horizontal
            },
            {
                -- Middle
                {
                    -- Title
                    align = "center",
                    ellipsize = "end",
                    forced_width = 10,
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                buttons = buttons,
                layout = wibox.layout.flex.horizontal
            },
            {
                -- Right
                awful.titlebar.widget.floatingbutton(c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.stickybutton(c),
                awful.titlebar.widget.ontopbutton(c),
                awful.titlebar.widget.closebutton(c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        }
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
        c.name = helpers.get_substring(c.name, 30)
    end
)

client.connect_signal(
    "property::maximized",
    function (c)
        client_titlebars_toggle(c)
    end
)
-- }}}

-- {{{ Autostart apps
require("apps")
-- }}}