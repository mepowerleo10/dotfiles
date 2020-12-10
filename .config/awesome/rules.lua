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

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { 
        border_width = 0,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = clientkeys,
        buttons = clientbuttons,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap+awful.placement.no_offscreen,
        honor_workarea = true,
        margins = {
            bottom = beautiful.useless_gap * 2, 
            right = beautiful.useless_gap * 2, 
            left = beautiful.useless_gap * 2
        }
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer",
          "mpv",
          "TelegramDesktop"
        },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.

        }
      }, properties = { 
          floating = true,
          maximized_horizontal = false,
          maximized_vertical = false,
          honor_workarea = true,
          placement = awful.placement.centered,
        }
    },

    -- Add titlebars to normal clients and dialogs
    { 
      rule_any = {
        type = { "normal", "dialog" }
      }, 
      properties = { titlebars_enabled = true },
      callback = function (c)
        if c.maximized then
          awful.titlebars:hide(c)
        else
          awful.titlebars:show(c)
        end
      end
    },

    {
      rule = { type = "dialog" },
      properties = {
        floating = true,
        placement = awful.placement.centered
      }
    },

    {
        rule = { instance = "Navigator", type = "normal" },
        properties = { 
          tag = "web",
          titlebars_enabled = true,
          maximized = false,
          -- requests_no_titlebar = true,
          maximized_horizontal = false,
          maximized_vertical = false,
          floating = true,
          width = 1100,
          height = 600,
          placement = awful.placement.centered
        }
    },

    {
        rule = { instance = "copyq" },
        properties = {
            floating = true,
            titlebars_enabled = true,
            requests_no_titlebar = true,
            maximized_horizontal = false,
            maximized_vertical = false,
            skip_taskbar = true,
            placement = awful.placement.centered,
        }
    },
    {
        rule = { class = "TelegramDesktop" },
        properties = {
            tag = "chat",
            floating = true,
            maximized_horizontal = false,
            maximized_vertical = false,
            placement = awful.placement.centered,
            skip_taskbar = true,
            width = 605,
            height = 501,
        }
    },

    {
      rule = { class = "mpv" },
      properties = {
          floating = true,
          maximized_horizontal = false,
          maximized_vertical = false,
          placement = awful.placement.centered,
          titlebars_enabled = false,
          width = 640,
          height = 360,
      }
    },
    {
      rule = { class = "albert" },
      properties = {
        floating = true,
        placement = awful.placement.center_horizontal,
        titlebars_enabled = false,
        requests_no_titlebar = true,
        dockable = false,
        skip_taskbar = true,
        ontop = true,
      }
    },
    {
      rule_any = { class = {"Gnome-terminal", "ranger", "kitty",} },
      properties = {
          floating = true,
          titlebars_enabled = true,
          maximized_horizontal = false,
          maximized_vertical = false,
          width = 867,
          height = 505,
          -- placement = awful.placement.no_offscreen,
      }
    },
    {
      rule_any = { class = {"feh"} },
      properties = {
          floating = true,
          titlebars_enabled = true,
          maximized_horizontal = false,
          maximized_vertical = false,
      }
    },

    {
      rule = { class = "Dragon-drag-and-drop" },
      properties = {
          floating = true,
          sticky = true,
          above = true,
          ontop = true,
          width = 603,
          placement = awful.placement.bottom_left
      }
    },

    {
        rule = { class = "Zathura" },
        properties = {
            floating = true,
            width = 882,
            height = 670,
            placement = awful.placement.no_offscreen
        }
    },

    {
        rule = { class = "TelegramDesktop", name = "Media viewer" },
        properties = {
          fullscreen = true,
          titlebars_enabled = false,
          requests_no_titlebar = true,
          above = true,
          ontop = true,
          floating = false,
          -- maximized = true,
        }
    },
    {
      rule = { class = "flameshot" },
      properties = {
        fullscreen = true,
        titlebars_enabled = false,
        requests_no_titlebar = true,
        above = true,
        ontop = true,
        floating = false,
        -- maximized = true,
      }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },

    -- Tag classifications
    {
      rule = { class = "code-oss" },
      properties = {
        tag = "code",
      }
    },
    {
      rule = { class = "qutebrowser" },
      properties = {
        tag = "web",
        maximized_horizontal = true,
        maximized_vertical = true,
        floating = false,
      }
    },
    {
      rule = { class = "Mailspring" },
      properties = {
        tag = "mail",
        floating = true,
        width = 882,
        height = 670,
      },
    },
    {
      rule = { instance = "ncmpcpp" },
      properties = {
        titlebars_enabled = false,
        requests_no_titlebar = true,
        tag = "music",
        placement = awful.placement.store_geometry
      },
    },
    {
      rule = { instance = "Kunst" },
      properties = {
          tag = "music",
          titlebars_enabled = false,
          requests_no_titlebar = true,
          floating = true,
          placement = awful.placement.store_geometry
      }
  },
    {
      rule = {
          class = "jetbrains-studio",
          name="^win[0-9]+$",
      },
      properties = {
          tag = "code",
          placement = awful.placement.no_offscreen,
          titlebars_enabled = false
      }
    },
    {
      rule = {
        class = "Lollypop",
      },
      properties = {
        titlebars_enabled = false,
        floating = true,
        requests_no_titlebar = true,
      }
    },
    {
      rule_any = {
        name = {"Android Emulator*", "^Emulator", "Lollypop"}
      },
      properties = {
        titlebars_enabled = false,
        requests_no_titlebar = true,
        floating = true,
        callback = function(c)
          --c.border_width = 0
          --c.no_border = true
        end
      }
    },
    --[[{
      rule = { name = "^Emulator", type = "utility" },
      properties = {
        focusable = false,
        skip_taskbar = true,
      }
    }]]--
}
-- }}}
