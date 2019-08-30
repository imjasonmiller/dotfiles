import XMonad
import XMonad.Util.Run(spawnPipe)
import qualified Data.Map as M

import XMonad.Config.Desktop
import XMonad.Util.SpawnOnce

myTerminal     = "alacritty"
myModMask      = mod4Mask -- Win key or Super_L
myBorderWidth  = 0
myWorkspaces   = ["web", "code", "a", "b", "c", "sfx"]

myStartupHook = do
  spawnOnce "$HOME/.config/polybar/launch.sh"

rofiDrun   = "rofi -show drun"
rofiWindow = "rofi -show window"
rofiCalc   = "rofi -show calc -no-show-match -calc-command \"echo '{result}' | xclip\""

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm, xK_p), (spawn rofiDrun))
    , ((modm, xK_f), (spawn rofiWindow))
    , ((modm, xK_c), (spawn rofiCalc))
    ]

myFocusFollowsMouse = False
myClickJustFocuses  = False

main = do
  xmonad $ desktopConfig
    { terminal          = myTerminal
    , focusFollowsMouse = myFocusFollowsMouse
    , clickJustFocuses  = myClickJustFocuses
    , modMask           = myModMask
    , borderWidth       = 0
    , workspaces        = myWorkspaces
    , startupHook       = myStartupHook <+> startupHook desktopConfig
    , keys              = \c -> myKeys c `M.union` keys XMonad.def c
    }

