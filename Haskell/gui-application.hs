-- from https://www.stackbuilders.com/tutorials/haskell/gui-application/
-- looks like i need: stack setup --upgrade-cabal

import Control.Monad
import Control.Monad.IO.Class
import Data.IORef
import Graphics.UI.Gtk hiding (Action, backspace)

-- | Creates a 'Grid'.
gridNew :: IO Grid

-- | Sets whether all rows of grid will have the same height.
gridSetRowHomogeneous :: GridClass self
  => self              -- ^ The grid
  -> Bool              -- ^ 'True' to make rows homogeneous
  -> IO ()

-- | Adds a widget to the grid. The position of child is determined by left
-- and top. The number of "cells" that child will occupy is determined by
-- width and height.
gridAttach :: (GridClass self, WidgetClass child)
  => self    -- ^ The grid
  -> child   -- ^ The widget to add
  -> Int     -- ^ The column number to attach the left side of child to
  -> Int     -- ^ The row number to attach the top side of child to
  -> Int     -- ^ Width - the number of columns that child will span
  -> Int     -- ^ Height - the number of rows that child will span
  -> IO ()
-- As I said, GTK+ bindings are very imperative. All binding code lives in IO monad except for some cases that we will cover shortly.

main :: IO ()
main = do
  void initGUI
  window <- windowNew
  set window [ windowTitle         := "Calculator"
             , windowResizable    := False
             , windowDefaultWidth  := 230
             , windowDefaultHeight := 250 ]
  display <- entryNew
  set display [ entryEditable := False
              , entryXalign   := 1 -- makes contents right-aligned
              , entryText     := "0" ]
  widgetShowAll window
  mainGUI
