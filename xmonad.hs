import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig
import System.IO

-- My Import
import XMonad.Layout.IndependentScreens
import XMonad.Util.SpawnOnce
import XMonad.Actions.SpawnOn
import XMonad.Layout.Spacing
import XMonad.Layout.ThreeColumns
import XMonad.Layout.FixedColumn
import XMonad.Layout.MultiColumns
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Tabbed
import XMonad.Layout.ResizableTile
import XMonad.Layout.Circle
import XMonad.Layout.ThreeColumns
import XMonad.Layout.WindowNavigation
import XMonad.Layout.MouseResizableTile
import Graphics.X11.ExtraTypes.XF86

-- End My Imports
import XMonad.Prompt.Shell
import XMonad.Prompt
import XMonad.Prompt.XMonad
import XMonad.Util.Run
import XMonad.ManageHook
import qualified XMonad.StackSet as W
import XMonad.Prompt.AppendFile
import XMonad.Actions.DwmPromote
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.SetWMName
import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.CycleWS
import XMonad.Hooks.ManageHelpers
import XMonad.Layout
import XMonad.Layout.WindowNavigation

-- Shift & View
import Control.Monad (liftM2)
import XMonad.Actions.GridSelect
import XMonad.Prompt.RunOrRaise
import XMonad.Prompt.Window
import XMonad.Actions.Search
import qualified XMonad.Actions.Search as S
import qualified XMonad.Actions.Submap as SM
import qualified Data.Map as M
import Data.Ratio
import Data.Monoid
import Control.Monad.Reader

modMask'    = mod4Mask  -- Rebind Mod(ALT) to Windows Key
terminal'   = "urxvt"
myWorkspaces = ["1","2","3","4","5","6","7","8","9"]
myNormalBorderColor  = "#a9c4fc"
myFocusedBorderColor = "#fc5356"
myBorderWidth = 3
-----------------------------------------------------------------------
xmobarCurrentWorkspaceColor = "#78a4ff"
myLayout = smartBorders (avoidStruts (windowNavigation (ResizableTall 1 (3/100) (1/2) []) ||| noBorders Full ||| multiCol [2] 4 0.01 0.5 ||| ThreeCol 1 (3/100) (1/2)))
-- myLayout = smartBorders (avoidStruts (windowNavigation (ResizableTall 1 (3/100) (1/2) []) ||| tabbed shrinkText defaultTheme ||| noBorders Full ||| multiCol [2] 4 0.01 0.5 ||| ThreeCol 1 (3/100) (1/2)))
-- myLayout = multiCol [1] 4 0.01 0.5

-- FLOATING TERMINAL
--
-- floatIt = Query ( do { x <- ask; W.float x; pure (Endo id) } )

manageHooks = composeAll
   [
     --className =? "feh"            --> doFloat
   ]

searchEngineMap method = M.fromList
  [
    ((0, xK_g), method S.duckduckgo )
  ]

-- CONSTANTS
background= "#181512"
foreground= "#78a4ff"
-- myFont = "xft:InconsolataForPowerline Nerd Font-13"
myHandlesEventHook = fullscreenEventHook <+> docksEventHook
myStartupHook = setWMName "LG3D" <+> spawn "feh --randomize --bg-fill $HOME/pics/wallpapers/*" <+> spawn "sh $HOME/.screenlayout/home.sh"

main = do
  xmproc <- spawnPipe "/usr/bin/xmobar /home/seventh/.xmobarrc"
  xmonad $ def
    { manageHook         = manageHooks <+> manageDocks <+> manageSpawn <+> manageHook def
    , normalBorderColor  = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    , layoutHook         = spacing 2 $ myLayout
    , startupHook        = myStartupHook
    , modMask            = modMask'
    , terminal           = terminal'
    , borderWidth        = myBorderWidth
    , workspaces         = withScreens 2 myWorkspaces
    , handleEventHook    = myHandlesEventHook
    , logHook            = dynamicLogWithPP $ xmobarPP
        { ppOutput   = hPutStrLn xmproc
        , ppTitle    = xmobarColor "#ffffff" "#002080" . shorten 80
        , ppLayout   = const ""
        }
    }


    `additionalKeysP`
    [ ("M-<Print>", spawn "sleep 0.2; scrot -s")
    , ("M-<Return>", dwmpromote >>  windows W.focusDown )   -- Swap the focused window and the master window
    , ("M-<F1>", xmonadPrompt def)
    , ("M-S-f", shiftTo Next EmptyWS)

    , ("M-p", spawn "dmenu_run -l 20 -b -nb '#78a4ff' -nf '#000000' -sb '#003399' -sf '#ffffff' -p '>>' -fn 'Iosevka-14' -i")
    , ("M-C-p", spawn "passmenu -l 20 -b -nb '#78a4ff' -nf '#000000' -sb '#003399' -sf '#ffffff' -p '>>' -fn 'Iosevka-14' -i")

    , ("M-l", sendMessage $ Go R)
    , ("M-h", sendMessage $ Go L)
    , ("M-k", sendMessage $ Go U)
    , ("M-j", sendMessage $ Go D)
    , ("M-S-l", sendMessage Expand)
    , ("M-S-h", sendMessage Shrink)
    , ("M-S-k", sendMessage MirrorExpand)
    , ("M-S-j", sendMessage MirrorShrink)

    , ("M-b", sendMessage ToggleStruts)

    , ("M-C-l", sendMessage $ Swap R)
    , ("M-C-h", sendMessage $ Swap L)
    , ("M-C-k", sendMessage $ Swap U)
    , ("M-C-j", sendMessage $ Swap D)
    , ("M-<Right>", nextWS)
    , ("M-<Left>", prevWS)
    , ("M-<Up>", toggleWS)
    , ("M-<Down>", toggleWS)
    , ("M-S-<Right>", shiftToNext >> nextWS)
    , ("M-S-<Left>", shiftToPrev >> prevWS)
    , ("M-g", goToSelected def)

    , ("M-C-x", kill)

    , ("M-C-S-l", spawn "sh ~/.bin/mlock.sh")
    , ("M-C-S-k", spawn "sh ~/.bin/keyboard.sh")

    , ("M-1", windows $ onCurrentScreen W.greedyView "1")
    , ("M-2", windows $ onCurrentScreen W.greedyView "2")
    , ("M-3", windows $ onCurrentScreen W.greedyView "3")
    , ("M-4", windows $ onCurrentScreen W.greedyView "4")
    , ("M-5", windows $ onCurrentScreen W.greedyView "5")
    , ("M-6", windows $ onCurrentScreen W.greedyView "6")
    , ("M-7", windows $ onCurrentScreen W.greedyView "7")
    , ("M-8", windows $ onCurrentScreen W.greedyView "8")
    , ("M-9", windows $ onCurrentScreen W.greedyView "9")
    , ("M-0", windows $ onCurrentScreen W.greedyView "0")

    , ("M-S-1", windows $ onCurrentScreen W.shift "1")
    , ("M-S-2", windows $ onCurrentScreen W.shift "2")
    , ("M-S-3", windows $ onCurrentScreen W.shift "3")
    , ("M-S-4", windows $ onCurrentScreen W.shift "4")
    , ("M-S-5", windows $ onCurrentScreen W.shift "5")
    , ("M-S-6", windows $ onCurrentScreen W.shift "6")
    , ("M-S-7", windows $ onCurrentScreen W.shift "7")
    , ("M-S-8", windows $ onCurrentScreen W.shift "8")
    , ("M-S-9", windows $ onCurrentScreen W.shift "9")
    , ("M-S-0", windows $ onCurrentScreen W.shift "0")

    -- , ("M-C-2", spawn "pactl set-sink-volume @DEFAULT_SINK@ 20%")
    -- , ("M-C-3", spawn "pactl set-sink-volume @DEFAULT_SINK@ 30%")
    -- , ("M-C-4", spawn "pactl set-sink-volume @DEFAULT_SINK@ 40%")
    -- , ("M-C-5", spawn "pactl set-sink-volume @DEFAULT_SINK@ 50%")
    -- , ("M-C-6", spawn "pactl set-sink-volume @DEFAULT_SINK@ 60%")
    -- , ("M-C-7", spawn "pactl set-sink-volume @DEFAULT_SINK@ 70%")
    -- , ("M-C-8", spawn "pactl set-sink-volume @DEFAULT_SINK@ 80%")
    -- , ("M-C-9", spawn "pactl set-sink-volume @DEFAULT_SINK@ 90%")
    -- , ("M-C-0", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    -- , ("M-C-u", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
    -- , ("M-C-i", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")

    , ("<XF86AudioPrev>", spawn "mpc prev")
    , ("<XF86AudioNext>", spawn "mpc next")
    , ("<XF86AudioPlay>", spawn "mpc toggle")

    , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
    , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")

    , ("M-C-t", spawn "sh ~/.bin/notifymail.sh")
    , ("M-C-m", spawn "sh ~/.bin/dmenu-mutt-handler.sh")
    , ("M-C-S-o", spawn "sh ~/.bin/dmenu-offline-handler.sh")

    -- FLOATING TERMINAL
    -- , ("M-n", doFloat $ spawn "urxvt -e ytnba.sh")

    , ("M-f", spawn "urxvt -e ranger")
    , ("M-m", spawn "urxvt -e ncmpcpp")
    , ("M-v", spawn "urxvt -e pulsemixer")

    ]
