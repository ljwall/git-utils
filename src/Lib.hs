module Lib
    ( someFunc
    ) where

import Gitutils.Matchers
  ( matchAll
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
  ( when
  )

cmd = proc "git" ["fetch"]

someFunc :: IO ()
someFunc = do
  (exitcode, stdout, stderr) <- echoReadCreateProcessWithExitCode cmd ""
  when (exitcode == ExitSuccess) $ do
    let allLines = lines stderr ++ lines stdout
    let branches = matchAll allLines
    print branches
  exitWith exitcode



