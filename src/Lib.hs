module Lib
    ( someFunc
    , matchNewBranch
    , matchUpdateBranch
    ) where

import Data.Maybe
  ( catMaybes
  )

import System.Exit
  ( ExitCode (ExitSuccess)
  )

import System.Process
  ( proc
  )

import System.Process.Gitutils
  ( echoReadCreateProcessWithExitCode
  )

import Text.Regex.PCRE ((=~~))

import Control.Monad
  ( when
  )

cmd = proc "git" ["fetch"]

someFunc :: IO ()
someFunc = do
  (exitcode, stdout, stderr) <- echoReadCreateProcessWithExitCode cmd ""
  when (exitcode == ExitSuccess) $ do
    let allLines = lines stderr ++ lines stdout
    let branches = catMaybes [f x | x <- allLines, f <- [matchNewBranch, matchUpdateBranch]]
    print branches


matchNewBranch :: String -> Maybe String
matchNewBranch ln = do
  (_, _, _, parts) <- ln =~~ "\\[new branch\\]\\s+([^\\s]+)\\s+->\\s+" :: Maybe (String, String, String, [String])
  return $ head parts

matchUpdateBranch :: String -> Maybe String
matchUpdateBranch ln = do
  (_, _, _, parts) <- ln =~~ "\\s+[0-9a-f]+[.]+[0-9a-f]+\\s+([^\\s]+)\\s+->\\s+" :: Maybe (String, String, String, [String])
  return $ head parts
