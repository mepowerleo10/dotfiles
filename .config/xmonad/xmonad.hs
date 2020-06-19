import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.Tabbed
import System.IO


------------------------------------------------------------------
main = do
  xmproc <- spawnPipe "/home/mepowerleo10/.config/polybar/launch_polybar"
  xmproc <- spawnPipe "firefox"

  xmonad $ defaultConfig {
    manageHook = manageDocks <+> manageHook defaultConfig, 
    layoutHook = avoidStruts $ layoutHook defaultConfig, 
    modMask = mod4Mask,    -- Rebind to the Win key
    terminal = "gnome-terminal", 
    borderWidth = 0
    {--myLayout = avoidStruts $ 
      noBorders (tabbed shrinkText)
      ||| tiled
      ||| twopane
      where
        tiled = spacing 6 $ ResizableTall nmaster delta ratio []
        twopane = spacing 6 $ TwoPane delta ratio--}
  } 
  {--`additionalKeys`    -- Extra Keybindings
    [
      ("M-S-e", confirmPrompt myXPConfig "exit" (io exitSuccess))
      --("M-<Return>", shellPrompt myXPConfig), 
    ]--}


