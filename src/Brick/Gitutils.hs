module Brick.Gitutils
  ( chooseItem
  ) where

chooseItem :: [String] -> IO (Maybe String)
chooseItem [] = return Nothing
chooseItem (x:_) = return $ Just x
