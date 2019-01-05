module Gitutils.Matchers
  ( matchNewBranch
  , matchUpdateBranch
  , matchUpToDateBranch
  , matchAllFetch
  ) where

import Data.Maybe
  ( catMaybes
  )

import Text.Regex.PCRE ((=~~))

-- | Utility regex matcher, returns maybe the first matching group
matchRegex :: String -> String -> Maybe String
matchRegex re ln = do
  (_, _, _, parts) <- ln =~~ re :: Maybe (String, String, String, [String])
  return $ head parts

-- | Get the branch name from a [new branch] line
matchNewBranch :: String -> Maybe String
matchNewBranch = matchRegex "\\[new branch\\]\\s+([^\\s]+)\\s+->\\s+" 

-- | Get the branch name from an [up to date] line
matchUpToDateBranch :: String -> Maybe String
matchUpToDateBranch = matchRegex "\\[up to date\\]\\s+([^\\s]+)\\s+->\\s+" 

-- | Get the branch name from an updated branch line
matchUpdateBranch :: String -> Maybe String
matchUpdateBranch = matchRegex "\\s+[0-9a-f]+[.]+[0-9a-f]+\\s+([^\\s]+)\\s+->\\s+"

-- | Take an array of sting and return array of found branch names
matchAllFetch :: [String] -> [String]
matchAllFetch lines = catMaybes [f x | x <- lines, f <- [matchNewBranch, matchUpdateBranch, matchUpToDateBranch]]
