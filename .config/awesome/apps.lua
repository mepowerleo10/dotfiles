awful = require("awful")
naughty = require("naughty")
gears = require("gears")
-- {{{ Autorun apps
local apps = {}

apps["picom"] = "picom -cCGfF -o 0.38 -O 200 -I 200 -t 0 -l 0 -r 5 -m 0.88"
apps["copyq"] = "copyq"
apps["blueman-applet"] = "blueman-applet"
apps["nm-applet"] = "nm-applet"
apps["pasystray"] = "pasystray -m 100"
apps["albert"] = "albert"
apps["udiskie"] = "udiskie -t"
apps["redshift"] = "redshift -P"
apps["light"] = "light -N 20"
apps["fusuma"] = "fusuma"
apps["flashfocus"] = "flashfocus"
apps["vscode"] = "/usr/bin/code-oss --no-sandbox --unity-launch %F"
apps["telegram"] = "telegram-desktop -- %u"
apps["qutebrowser"] = "qutebrowser %u"
apps["fusuma"] = "fusuma -d"

for k,v in ipairs(apps) do
    awful.spawn.once({
            cmd = v,
            unique_id = k,
            callback = function ()
                naughty.notify({
                    title = "Started <b>" .. v .. "</b>",
                    text = "With ID: <i>" .. k .. "</i>",
                    timeout = 3
                })
            end
        })
end

gears.timer {
    timeout = 900,
    call_now = true,
    autostart = true,
    callback = function ()
        awful.spawn.easy_async(
            {"sh", "-c", os.getenv("HOME") .. "/.bin/wallpaper.sh"},
            function ()
                -- nothing to do in here
            end
        )
    end
}

-- }}}
