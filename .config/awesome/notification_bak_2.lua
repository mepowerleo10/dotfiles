local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local naughty = require("naughty")

local helpers = require("helpers")

naughty.config.presets.ok = naughty.config.presets.normal
naughty.config.presets.info = naughty.config.presets.normal
naughty.config.presets.warn = naughty.config.presets.critical

naughty.connect_signal(
    "request::display",
    function(n)
        local appicon = n.icon or n.app_icon
        if not appicon then
            appicon = beautiful.notification_icon
        end

        local margin = dpi(5)

        local notification_icon = {
            {
                {
                    image = appicon,
                    resize = true,
                    widget = wibox.widget.imagebox
                },
                strategy = "max",
                height = 48,
                width = 48,
                widget = wibox.container.constraint
            },
            widget = wibox.container.margin,
            top = margin,
            bottom = margin,
            left = margin
        }

        local notification_title = {
            -- {
                markup = "<span weight='bold'>" .. helpers.get_substring(n.title, 30) .. "</span>",
                align = "left",
                widget = wibox.widget.textbox,
            -- },
            -- widget = wibox.container.scroll.horizontal,
            -- step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
            -- speed = 50,
            forced_width = dpi(220),
        }

        local notification_message = {
            {
                markup = n.message,
                align = "left",
                widget = wibox.widget.textbox
            },
            widget = wibox.container.scroll.vertical,
            step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
            speed = 20,
            forced_height = dpi(32),
            forced_width = dpi(220)
        }

        local notification_info = {
            {
                notification_title,
                notification_message,
                spacing = 4,
                layout = wibox.layout.fixed.vertical
            },
            widget = wibox.container.margin,
            top = margin,
            right = margin
        }

        local notification_template = {
            {
                {
                    {
                        {
                            notification_icon,
                            notification_info,
                            fill_space = true,
                            spacing = 4,
                            layout = wibox.layout.fixed.horizontal
                        },
                        naughty.list.actions,
                        spacing = 10,
                        layout = wibox.layout.fixed.vertical
                    },
                    margins = beautiful.notification_margin,
                    widget = wibox.container.margin
                },
                id = "background_role",
                widget = naughty.container.background
            },
            strategy = "max",
            width = beautiful.notification_max_width or beautiful.xresources.apply_dpi(500),
            widget = wibox.container.constraint
        }

        naughty.layout.box {
            notification = n,
            type = "notification",
            width = dpi(300),
            height = dpi(48),
            widget_template = notification_template
        }
    end
)
