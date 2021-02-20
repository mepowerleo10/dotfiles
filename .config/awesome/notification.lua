local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local naughty = require("naughty")

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

naughty.connect_signal(
    "request::display",
    function(n)
        n.timeout = 3
        local bg = nil
        if n.urgency == "low" or n.urgency == "normal" then
            bg = beautiful.bg_normal
        elseif n.urgency == "critical" then
            bg = beautiful.bg_urgent
        end

        local appicon = n.icon or n.app_icon
        if not appicon then
            appicon = beautiful.notification_icon
        end

        local action_widget = {
            {
                {
                    id = "text_role",
                    align = "center",
                    valign = "center",
                    widget = wibox.widget.textbox
                },
                left = dpi(2),
                right = dpi(2),
                widget = wibox.container.margin
            },
            bg = "#2b2b2b",
            forced_height = dpi(25),
            forced_width = dpi(20),
            shape = helpers.rrect(dpi(4)),
            widget = wibox.container.background
        }

        local actions =
            wibox.widget {
            notification = n,
            base_layout = wibox.widget {
                spacing = dpi(8),
                layout = wibox.layout.flex.horizontal
            },
            widget_template = action_widget,
            style = {
                underline_normal = false,
                underline_selected = true,
                bg_selected = "#2b2b2b",
                icon_size_normal = 16
            },
            widget = naughty.list.actions
        }

        local notification_icon_widget = {
            {
                {
                    {
                        image = appicon,
                        resize = true,
                        widget = wibox.widget.imagebox
                    },
                    -- bg = beautiful.xcolor1,
                    strategy = "max",
                    height = 48,
                    width = 48,
                    widget = wibox.container.constraint
                },
                layout = wibox.layout.align.vertical
            },
            top = dpi(0),
            left = dpi(4),
            right = dpi(1),
            bottom = dpi(0),
            widget = wibox.container.margin
        }

        local notification_title_widget = {
            step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
            speed = 50,
            {
                markup = "<span weight='bold'>" .. n.title .. "</span>",
                font = beautiful.font,
                align = "left",
                visible = title_visible,
                widget = wibox.widget.textbox
            },
            forced_width = dpi(204),
            widget = wibox.container.scroll.horizontal
        }

        local notification_message_widget = {
            {
                markup = n.message,
                align = "left",
                font = beautiful.font,
                widget = wibox.widget.textbox
            },
            right = 5,
            widget = wibox.container.margin
        }

        naughty.layout.box {
            notification = n,
            type = "notification",
            -- position = beautiful.notification_position,
            width = dpi(300),
            -- bg = beautiful.xbackground .. "00",
            widget_template = {
                {
                    {
                        {
                            {
                                notification_icon_widget,
                                {
                                    {
                                        nil,
                                        {
                                            notification_title_widget,
                                            notification_message_widget,
                                            {
                                                actions,
                                                visible = n.actions and #n.actions > 0,
                                                layout = wibox.layout.fixed.vertical,
                                                forced_width = dpi(220)
                                            },
                                            spacing = dpi(3),
                                            layout = wibox.layout.fixed.vertical
                                        },
                                        nil,
                                        expand = "none",
                                        layout = wibox.layout.align.vertical
                                    },
                                    margins = dpi(8),
                                    widget = wibox.container.margin
                                },
                                layout = wibox.layout.fixed.horizontal
                            },
                            top = dpi(5),
                            bottom = dpi(5),
                            widget = wibox.container.margin
                        },
                        -- bg = beautiful.xbackground,
                        widget = wibox.container.background
                    },
                    margins = beautiful.widget_border_width,
                    widget = wibox.container.margin
                },
                -- bg = beautiful.xcolor0,
                forced_width = dpi(300),
                bg = bg,
                widget = wibox.container.background
            }
        }
    end
)

-- naughty.disconnect_signal("request::display", naughty.default_notification_handler)
