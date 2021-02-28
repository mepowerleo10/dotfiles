-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
require("awful.autofocus")
local switcher = require("awesome-switcher")
cyclefocus.show_clients = true

-- {{{ Mouse bindings
root.buttons(
    gears.table.join(
        awful.button(
            {},
            3,
            function()
                mymainmenu:toggle()
            end
        ),
        awful.button({}, 4, awful.tag.viewnext),
        awful.button({}, 5, awful.tag.viewprev)
    )
)
-- }}}

-- {{{ Key bindings
globalkeys =
    gears.table.join(
    awful.key({modkey}, "s", hotkeys_popup.show_help, {description = "show help", group = "awesome"}),
    awful.key({modkey}, "", awful.tag.viewprev, {description = "view previous", group = "tag"}),
    awful.key({modkey}, "", awful.tag.viewnext, {description = "view next", group = "tag"}),
    awful.key({modkey}, "Escape", awful.tag.history.restore, {description = "go back", group = "tag"}),
    awful.key(
        {modkey},
        "j",
        function()
            awful.client.focus.byidx(1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key(
        {modkey},
        "k",
        function()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key(
        {modkey},
        "o",
        function()
            mymainmenu:show()
        end,
        {description = "show main menu", group = "awesome"}
    ),
    -- Layout manipulation
    awful.key(
        {modkey, "Shift"},
        "j",
        function()
            awful.client.swap.byidx(1)
        end,
        {description = "swap with next client by index", group = "client"}
    ),
    awful.key(
        {modkey, "Shift"},
        "k",
        function()
            awful.client.swap.byidx(-1)
        end,
        {description = "swap with previous client by index", group = "client"}
    ),
    awful.key(
        {modkey, "Control"},
        "j",
        function()
            awful.screen.focus_relative(1)
        end,
        {description = "focus the next screen", group = "screen"}
    ),
    awful.key(
        {modkey, "Control"},
        "k",
        function()
            awful.screen.focus_relative(-1)
        end,
        {description = "focus the previous screen", group = "screen"}
    ),
    awful.key({modkey}, "u", awful.client.urgent.jumpto, {description = "jump to urgent client", group = "client"}),
    awful.key(
        {modkey},
        "d",
        function()
            awful.spawn("/home/mepowerleo10/.config/rofi/launchers/slate/launcher.sh")
        end,
        {description = "spawn rofi dmenu for applications", group = "rofi"}
    ),
    awful.key(
        {"Mod1"},
        "c",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}
    ),
    -- mod+Tab: cycle through all the clients
    awful.key(
        {"Mod1"},
        "Tab",
        function(c)
            cyclefocus.cycle({modifier = "Alt_L"})
        end,
        {description = "cycle forward through all clients", group = "tag"}
    ),
    -- modkey+Shift+Tab: backwards
    awful.key(
        {"Mod1", "Shift"},
        "Tab",
        function(c)
            cyclefocus.cycle({modifier = "Alt_L"})
        end,
        {description = "cycle backwards through all clients", group = "tag"}
    ),
    --[[ -- modkey+Shift+c: cycle through clients in the current workspace
    cyclefocus.key(
        {"Mod1"},
        "c", {
            cycle_filters = { cyclefocus.filters.same_screen, cyclefocus.filters.common_tag },
        },
        {description = "cycle through all clients in current tag", group = "tag"}
    ), ]]
    -- Standard program
    awful.key(
        {modkey},
        "Return",
        function()
            awful.spawn(terminal)
        end,
        {description = "open a terminal", group = "launcher"}
    ),
    awful.key({modkey, "Control"}, "r", awesome.restart, {description = "reload awesome", group = "awesome"}),
    awful.key(
        {modkey, "Shift"},
        "e",
        function()
            awful.spawn("/home/mepowerleo10/.config/rofi/applets/menu/powermenu.sh")
        end,
        {description = "quit awesome", group = "awesome"}
    ),
    awful.key(
        {modkey},
        "l",
        function()
            awful.tag.incmwfact(0.05)
        end,
        {description = "increase master width factor", group = "layout"}
    ),
    awful.key(
        {modkey},
        "h",
        function()
            awful.tag.incmwfact(-0.05)
        end,
        {description = "decrease master width factor", group = "layout"}
    ),
    awful.key(
        {modkey, "Shift"},
        "h",
        function()
            awful.tag.incnmaster(1, nil, true)
        end,
        {description = "increase the number of master clients", group = "layout"}
    ),
    awful.key(
        {modkey, "Shift"},
        "l",
        function()
            awful.tag.incnmaster(-1, nil, true)
        end,
        {description = "decrease the number of master clients", group = "layout"}
    ),
    awful.key(
        {modkey, "Control"},
        "h",
        function()
            awful.tag.incncol(1, nil, true)
        end,
        {description = "increase the number of columns", group = "layout"}
    ),
    awful.key(
        {modkey, "Control"},
        "l",
        function()
            awful.tag.incncol(-1, nil, true)
        end,
        {description = "decrease the number of columns", group = "layout"}
    ),
    awful.key(
        {modkey},
        "space",
        function()
            awful.layout.inc(1)
        end,
        {description = "select next", group = "layout"}
    ),
    awful.key(
        {modkey, "Shift"},
        "space",
        function()
            awful.layout.inc(-1)
        end,
        {description = "select previous", group = "layout"}
    ),
    awful.key(
        {modkey, "Control"},
        "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal("request::activate", "key.unminimize", {raise = true})
            end
        end,
        {description = "restore minimized", group = "client"}
    ),
    -- -- Exit screen
    -- awful.key({ modkey, }, "grave",
    --           function ()
    --               exit_screen_show()
    --           end
    -- ),

    -- Prompt
    awful.key(
        {modkey},
        "r",
        function()
            awful.screen.focused().mypromptbox:run()
        end,
        {description = "run prompt", group = "launcher"}
    ),
    awful.key(
        {modkey},
        "x",
        function()
            awful.prompt.run {
                prompt = "Run Lua code: ",
                textbox = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        {description = "lua execute prompt", group = "awesome"}
    ),
    awful.key(
        {"Control", "Shift"},
        "space",
        function()
            naughty.destroy_all_notifications()
        end,
        {description = "close all notifications", group = "awesome"}
    ),
    -- Menubar
    awful.key(
        {modkey},
        "p",
        function()
            menubar.show()
        end,
        {description = "show the menubar", group = "launcher"}
    ),
    -- Hotkeys
    awful.key(
        {},
        "XF86AudioRaiseVolume",
        function()
            awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +2%")
        end,
        {description = "volume up", group = "Audio Control"}
    ),
    awful.key(
        {},
        "XF86AudioLowerVolume",
        function()
            awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -2%")
        end,
        {description = "volume down", group = "Audio Control"}
    ),
    awful.key(
        {},
        "XF86AudioMute",
        function()
            awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
        end,
        {description = "toggle mute", group = "Audio Control"}
    ),
    awful.key(
        {},
        "XF86AudioMicMute",
        function()
            awful.spawn("pactl set-source-mute @DEFAULT_SOURCE@")
        end,
        {description = "toggle mic", group = "Audio Control"}
    ),
    awful.key(
        {},
        "XF86MonBrightnessUp",
        function()
            awful.spawn("light -A 5")
        end,
        {description = "increase brightness", group = "Brightness"}
    ),
    awful.key(
        {},
        "XF86MonBrightnessDown",
        function()
            awful.spawn("light -U 5")
        end,
        {description = "decrease brightness", group = "Brightness"}
    ),
    -- Custom shortcuts
    awful.key(
        {modkey},
        "XF86AudioRaiseVolume",
        function()
            awful.spawn("mpc next")
        end,
        {description = "next in playlist", group = "Custom Shortcuts"}
    ),
    awful.key(
        {modkey},
        "XF86AudioLowerVolume",
        function()
            awful.spawn("mpc prev")
        end,
        {description = "previous in playlist", group = "Custom Shortcuts"}
    ),
    awful.key(
        {modkey},
        "XF86AudioMute",
        function()
            awful.spawn("mpc toggle")
        end,
        {description = "pause/play playlist", group = "Custom Shortcuts"}
    ),
    awful.key(
        {modkey},
        "t",
        function()
            awful.spawn("copyq toggle")
        end,
        {description = "open clipboard", group = "Custom Shortcuts"}
    ),
    awful.key(
        {modkey},
        "Print",
        function()
            awful.spawn("flameshot gui -p " .. os.getenv("HOME") .. "/Pictures/Captures")
        end,
        {description = "capture screenshot", group = "Custom Shortcuts"}
    ),
    -- Rofimoji
    awful.key(
        {modkey},
        "i",
        function()
            -- awful.spawn('rofimoji -p --rofi-args "-theme .config/rofi.old/themes/rofimoji.rasi"')
            awful.spawn('emote')
        end,
        {description = "show rofimoji", group = "Custom Shortcuts"}
    )
    -- AwesomeWM Alt-Tab switcher
    --[[ awful.key(
        {modkey},
        "Tab",
        function()
            switcher.switch(1, modkey, "Alt_L", "Shift", "Tab")
        end
    ),
    awful.key(
        {modkey, "Shift"},
        "Tab",
        function()
            switcher.switch(-1, "Mod1", "Alt_L", "Shift", "Tab")
        end
    ) ]]
)

clientkeys =
    gears.table.join(
    awful.key(
        {modkey},
        "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}
    ),
    awful.key(
        {modkey, "Shift"},
        "c",
        function(c)
            c:kill()
        end,
        {description = "close", group = "client"}
    ),
    awful.key({modkey}, "v", awful.client.floating.toggle, {description = "toggle floating", group = "client"}),
    awful.key(
        {modkey, "Control"},
        "Return",
        function(c)
            c:swap(awful.client.getmaster())
        end,
        {description = "move to master", group = "client"}
    ),
    awful.key(
        {modkey},
        "o",
        function(c)
            c:move_to_screen()
        end,
        {description = "move to screen", group = "client"}
    ),
    awful.key(
        {modkey, "Shift"},
        "t",
        function(c)
            c.ontop = not c.ontop
        end,
        {description = "toggle keep on top", group = "client"}
    ),
    awful.key(
        {modkey},
        "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        {description = "minimize", group = "client"}
    ),
    awful.key(
        {modkey},
        "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        {description = "(un)maximize", group = "client"}
    ),
    awful.key(
        {modkey, "Control"},
        "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        {description = "(un)maximize vertically", group = "client"}
    ),
    awful.key(
        {modkey, "Shift"},
        "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        {description = "(un)maximize horizontally", group = "client"}
    ),
    awful.key(
        {modkey, "Shift"},
        "Down",
        function()
            awful.client.incwfact(-0.01)
        end
    ),
    awful.key(
        {modkey, "Shift"},
        "Up",
        function()
            awful.client.incwfact(0.01)
        end
    ),
    -- Title bar state
    awful.key({modkey, "Shift"}, "t", awful.titlebar.toggle)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys =
        gears.table.join(
        globalkeys,
        -- View tag only.
        awful.key(
            {modkey},
            "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    if tag == awful.screen.focused().selected_tag then
                        awful.tag.history.restore()
                    else
                        tag:view_only()
                    end
                end
            end,
            {description = "view tag #" .. i, group = "tag"}
        ),
        -- Toggle tag display.
        awful.key(
            {modkey, "Control"},
            "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. i, group = "tag"}
        ),
        -- Move client to tag.
        awful.key(
            {modkey, "Shift"},
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {description = "move focused client to tag #" .. i, group = "tag"}
        ),
        -- Toggle tag on focused client.
        awful.key(
            {modkey, "Control", "Shift"},
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {description = "toggle focused client on tag #" .. i, group = "tag"}
        )
    )
end

local r_ajust = {
    left = function(c, d)
        return {x = c.x - d, width = c.width + d}
    end,
    right = function(c, d)
        return {width = c.width + d}
    end,
    up = function(c, d)
        return {y = c.y - d, height = c.height + d}
    end,
    down = function(c, d)
        return {height = c.height + d}
    end
}

local smallify = function(c)
    r_ajust.right(c, -100)
    r_ajust.down(c, -100)
end

local largify = function(c)
    r_ajust.right(c, 100)
    r_ajust.down(c, 100)
end

clientbuttons =
    gears.table.join(
    awful.button(
        {},
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end
    ),
    awful.button(
        {modkey},
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end
    ),
    awful.button(
        {modkey},
        3,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end
    ),
    awful.button(
        {modkey},
        5,
        function(c)
            c:emit_signal("request::geometry", "mouse_resize", smallify(c))
        end
    )
)

-- Set keys
root.keys(globalkeys)
-- }}}
