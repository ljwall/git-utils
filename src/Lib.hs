module Lib
    ( fetchUi
    ) where

import Gitutils.Matchers
  ( matchAllFetch
  )

import Brick.Gitutils
  ( chooseItem
  )

import System.Environment
  ( getArgs
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
  , callProcessWithExitCode
  )

import Control.Monad
  ( unless
  )

fetchUi :: IO ()
fetchUi = do
  args <- getArgs
  let cmd = proc "git" ("fetch":args)
  (exitcode, stdout, stderr) <- echoReadCreateProcessWithExitCode cmd ""
  if exitcode == ExitSuccess then do
    let allLines = lines stderr ++ lines stdout
    let branches = matchAllFetch allLines
    unless (null branches) $ do
      branch <- chooseItem branches
      case branch of
        Just name -> do putStrLn $ "%%% git checkout " ++ name
                        callProcessWithExitCode "git" ["checkout", name] >>= exitWith
        Nothing   -> putStrLn "Nothing to do"
  else
    exitWith exitcode
