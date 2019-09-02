import XMonad
import qualified Data.Map as M

import XMonad.Util.Run(spawnPipe)

-- Fullscreen support
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.EwmhDesktops  (ewmh, fullscreenEventHook)
import XMonad.Layout.Fullscreen   (fullscreenManageHook)
import Data.Maybe                 (maybeToList)
import Control.Monad              ((>=>), join, liftM, when)

import XMonad.Hooks.ManageDocks

import XMonad.Config.Desktop
import XMonad.Util.SpawnOnce

myTerminal     = "alacritty"
myModMask      = mod4Mask -- Win key or Super_L
myBorderWidth  = 0
myWorkspaces   = ["Web", "Code", "Chat", "Media", "Other"]

myStartupHook = do
  spawnOnce "$HOME/.config/polybar/launch.sh"
  addEWMHFullscreen 

myManageHook = composeAll
    [ className =? "firefox"        --> doShift "Web"
    , resource  =? "desktop_window" --> doIgnore
    , className =? "feh"            --> doFloat
    , isFullscreen                  --> doFullFloat 
    , fullscreenManageHook
    ]

myFocusFollowsMouse = False
myClickJustFocuses  = False

rofiDrun   = "rofi -show run"
rofiWindow = "rofi -show window"
rofiCalc   = "rofi -show calc -no-show-match -no-history -calc-command \"echo '{result}' | xclip\"" 

-- In order for scrot to start in selection mode, it should sleep
-- See https://wiki.haskell.org/Xmonad/Config_archive/John_Goerzen%27s_Configuration#Customizing_xmonad
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((0, xK_Print),       (spawn "scrot"))
    , ((modm, xK_Print),    (spawn "sleep 0.2; scrot -sf"))
    , ((modm, xK_p),        (spawn rofiDrun))
    , ((modm, xK_f),        (spawn rofiWindow))
    , ((modm, xK_c),        (spawn rofiCalc))
    ]

main = do
  xmonad $ desktopConfig
    { terminal          = myTerminal
    , modMask           = myModMask
    , focusFollowsMouse = myFocusFollowsMouse
    , clickJustFocuses  = myClickJustFocuses
    , borderWidth       = 0
    , workspaces        = myWorkspaces
    , startupHook       = myStartupHook <+> startupHook desktopConfig
    , manageHook        = myManageHook <+> manageHook desktopConfig
    , handleEventHook   = fullscreenEventHook <+> handleEventHook desktopConfig
    , keys              = \c -> myKeys c `M.union` keys XMonad.def c
    }

-- Fullscreen hack for Firefox
-- https://github.com/xmonad/xmonad-contrib/issues/183
addNETSupported :: Atom -> X ()
addNETSupported x   = withDisplay $ \dpy -> do
    r               <- asks theRoot
    a_NET_SUPPORTED <- getAtom "_NET_SUPPORTED"
    a               <- getAtom "ATOM"
    liftIO $ do
       sup <- (join . maybeToList) <$> getWindowProperty32 dpy a_NET_SUPPORTED r
       when (fromIntegral x `notElem` sup) $
         changeProperty32 dpy r a_NET_SUPPORTED a propModeAppend [fromIntegral x]

addEWMHFullscreen :: X ()
addEWMHFullscreen   = do
    wms <- getAtom "_NET_WM_STATE"
    wfs <- getAtom "_NET_WM_STATE_FULLSCREEN"
    mapM_ addNETSupported [wms, wfs]
