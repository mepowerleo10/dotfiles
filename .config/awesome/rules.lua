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
    {
        rule = {},
        properties = {
            border_width = 0,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            honor_workarea = true,
            margins = {
                bottom = beautiful.useless_gap * 2,
                right = beautiful.useless_gap * 2,
                left = beautiful.useless_gap * 2
            }
        },
        callback = awful.client.setslave
    },
    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA", -- Firefox addon DownThemAll.
                "pinentry"
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin", -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer",
                "mpv",
                "TelegramDesktop",
                "albert", 
                "ranger",
                "kitty",
                "qutebrowser",
                "copyq"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester" -- xev.
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
                "GtkFileChooserDialog" -- Nautilus' file chooser dialog
            }
        },
        properties = {
            floating = true,
            maximized_horizontal = false,
            maximized_vertical = false,
            honor_workarea = true,
            placement = awful.placement.centered
        }
    },
    -- Add titlebars to normal clients and dialogs
    {
        rule_any = {
            type = {"normal", "dialog"}
        },
        properties = {titlebars_enabled = true}
    },
    {
        rule = {type = "dialog"},
        properties = {
            floating = true,
            placement = awful.placement.centered
        }
    },
    -- {{ Maximized clients
    {
        rule_any = {
            class = {"firefox", "code-oss"}
        },
        properties = {
            maximized_horizontal = true,
            maximized_vertical = true
        }
    },
    {
        rule = {
            type = {"normal"},
            name = {"libreoffice"}
        },
        properties = {
            maximized_horizontal = true,
            maximized_vertical = true
        }
        
    },
    {
        rule = {
            type = {"normal"},
            class = {"google-chrome"}
        },
        properties = {
            maximized_horizontal = true,
            maximized_vertical = true
        }   
    },
    -- }}
--[[     {
        rule = {role = "GtkFileChooserDialog"},
        properties = {
            width = 866,
            height = 647,
            placement = awful.placement.centered
        }
    }, ]]
    {
        rule = {instance = "copyq"},
        properties = {
            requests_no_titlebar = true,
            skip_taskbar = true,
            placement = awful.placement.centered
        }
    },
    {
        rule = {class = "TelegramDesktop"},
        properties = {
            -- tag = "chat",
            placement = awful.placement.centered,
            skip_taskbar = true,
            width = 605,
            height = 501
        }
    },
    {
        rule = {class = "feh"},
        properties = {
            placement = awful.placement.store_geometry,
            width = 573,
            height = 484
        }
    },
    {
        rule = {class = "mpv"},
        properties = {
            placement = awful.placement.no_offscreen 
                + awful.placement.no_overlap,
                -- + awful.placement.centered,
            honor_workarea = true,
            store_geometry = true,
            -- titlebars_enabled = false,
            width = 640,
            height = 360
        }
    },
    {
        rule = {class = "albert", name = "albert"},
        properties = {
            placement = awful.placement.center_horizontal,
            titlebars_enabled = false,
            requests_no_titlebar = true,
            dockable = false,
            skip_taskbar = true,
            ontop = true
        }
    },
    {
        rule_any = {class = {"ranger", "kitty"}},
        properties = {
            titlebars_enabled = true,
            width = 867,
            height = 505,
            placement = awful.placement.no_offscreen
        }
    },
    {
        rule = {class = "Dragon-drag-and-drop"},
        properties = {
            titlebars_enabled = false,
            requests_no_titlebar = true,
            floating = true,
            sticky = true,
            above = true,
            ontop = true,
            width = 603,
            placement = awful.placement.bottom_left
        }
    },
    {
        rule = {class = "Zathura"},
        properties = {
            floating = true,
            width = 882,
            height = 670,
            placement = awful.placement.no_offscreen
        }
    },
    {
        rule = {class = "Uget-gtk", type = "normal"},
        properties = {
            floating = true,
            width = 714,
            height = 451,
            placement = awful.placement.no_offscreen
        }
    },
    {
        rule = {class = "TelegramDesktop", name = "Media viewer"},
        properties = {
            fullscreen = true,
            titlebars_enabled = false,
            requests_no_titlebar = true,
            -- above = true,
            ontop = true,
            floating = true
        }
    },
    {
        rule = {class = "Plank", type = "dock"},
        properties = {
            requests_no_titlebar = true,
            titlebars_enabled = false,
            above = true,
            ontop = true,
            floating = true,
            dockable = true,
            skip_taskbar = true,
        }
    },
    {
        rule = {class = "Tint2", type = "dock"},
        properties = {
            requests_no_titlebar = true,
            titlebars_enabled = false,
            -- above = true,
            ontop = true,
            floating = false,
            dockable = true,
            skip_taskbar = true,
            placement = awful.placement.top
        }
    },
    {
        rule = {class = "Zotero", name = "Quick Format Citation"},
        properties = {
            floating = true, 
            skip_taskbar = true,
        }
    },
    --[[ {
        rule = {class = "Org.gnome.Nautilus", type = "dialog"},
        properties = {
            maximized_vertical = true,
            titlebars_enabled = false,
            requests_no_titlebar = true
        }
    }, ]]
    {
        rule = {class = "Gedit"},
        properties = {
            requests_no_titlebar = true,
            titlebars_enabled = false
        }
    },
    {
        rule = {class = "flameshot"},
        properties = {
            fullscreen = true,
            titlebars_enabled = false,
            requests_no_titlebar = true,
            above = true,
            ontop = true,
            floating = false
            -- maximized = true,
        }
    },
    -- Tag classifications
    {
        rule_any = {class = {"Google-chrome", "firefox", "qutebrowser" }},
        properties = {
            tag = "web"
        }
    },
    {
        rule = {class = "code-oss"},
        properties = {
            tag = "code"
        }
    },
    {
        rule = {class = "Mailspring"},
        properties = {
            tag = "mail",
            floating = true,
            width = 882,
            height = 670
        }
    },
    {
        rule = {instance = "ncmpcpp"},
        properties = {
            -- titlebars_enabled = false,
            -- requests_no_titlebar = true,
            tag = "music",
            placement = awful.placement.store_geometry
        }
    },
    {
        rule = {instance = "Kunst"},
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
            name = "^win[0-9]+$"
        },
        properties = {
            tag = "code",
            placement = awful.placement.no_offscreen,
            titlebars_enabled = false,
            requests_no_titlebar = true
        }
    },
    {
        rule_any = {
            name = {"Android Emulator*", "^Emulator"}
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
    }
    --[[{
      rule = { name = "^Emulator", type = "utility" },
      properties = {
        focusable = false,
        skip_taskbar = true,
      }
    }]]
    --
}
-- }}}
