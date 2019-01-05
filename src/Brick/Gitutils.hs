{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TupleSections #-}

module Brick.Gitutils
  ( chooseItem
  ) where

import Brick
import Brick.Widgets.Border
import Brick.Widgets.List
import Data.Vector (fromList)
import Graphics.Vty

chooseItem :: [String] -> IO (Maybe String)
chooseItem xs = snd <$> listMain xs

type AppState = (List () String, Maybe String)

handleEv
  :: AppState
  -- ^ Application state
  -> BrickEvent () ()
  -- ^ The event
  -> EventM () (Next AppState)
  -- ^ Action and folow up state
handleEv s (VtyEvent (EvKey (KChar 'q') [])) = halt s
handleEv s (VtyEvent (EvKey (KChar '!') [])) = suspendAndResume $ do
  putStrLn "Press any key to continue"
  getChar
  return s
handleEv (l, _) (VtyEvent (EvKey KEnter [])) = halt (l, snd <$> listSelectedElement l)
handleEv (l, m) (VtyEvent e) = (,m) <$> handleListEventVi handleListEvent e l >>= continue
handleEv s _ = continue s

app :: App AppState () ()
app = (simpleApp undefined)
  { appHandleEvent = handleEv
  , appDraw = \(s, _) ->
      (:[]) $ vBox
        [ renderList
          (\sel el -> withAttr (if sel then "selected" else mempty) $ str el
          ) True s
        , hBorder
        , withAttr "footer" $ str "down/up: j/k; checkout: enter; quit: q; see terminal: !."
        ]
  , appAttrMap =
      const $
      attrMap
        defAttr
        [ ("selected", bg white)
        , ("footer", fg white `withStyle` bold)
        ]
  }

listMain :: [String] ->  IO AppState
listMain xs = defaultMain app (list () (fromList xs) 1, Nothing)
