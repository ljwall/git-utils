module Gitutils.Matchers
  ( matchNewBranch
  , matchUpdateBranch
  ) where

import Text.Regex.PCRE ((=~~))

matchNewBranch :: String -> Maybe String
matchNewBranch ln = do
  (_, _, _, parts) <- ln =~~ "\\[new branch\\]\\s+([^\\s]+)\\s+->\\s+" :: Maybe (String, String, String, [String])
  return $ head parts

matchUpdateBranch :: String -> Maybe String
matchUpdateBranch ln = do
  (_, _, _, parts) <- ln =~~ "\\s+[0-9a-f]+[.]+[0-9a-f]+\\s+([^\\s]+)\\s+->\\s+" :: Maybe (String, String, String, [String])
  return $ head parts
