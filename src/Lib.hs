module Lib
    ( someFunc
    ) where

import Gitutils.Matchers
  ( matchAll
  )

import Brick.Gitutils
  ( chooseItem
  )

import System.Exit
  ( ExitCode (ExitSuccess)
  , exitWith
  )

import System.Process
  ( proc
  )

import System.Process.Gitutils
  ( echoReadCreateProcessWithExitCode
  )

import Control.Monad
  ( unless
  )

cmd = proc "git" ["fetch"]

someFunc :: IO ()
someFunc = do
  (exitcode, stdout, stderr) <- echoReadCreateProcessWithExitCode cmd ""
  if exitcode == ExitSuccess then do
    let allLines = lines stderr ++ lines stdout
    let branches = matchAll allLines
    unless (null branches) $ do
      branch <- chooseItem branches
      case branch of
        Just name -> putStrLn $ "check out: " ++ name
        Nothing   -> putStrLn "Nothing to do"
  else
    exitWith exitcode
