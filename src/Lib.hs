module Lib
    ( someFunc
    , matchNewBranch
    , matchUpdateBranch
    ) where

import Gitutils.Matchers
  ( matchNewBranch
  , matchUpdateBranch
  )

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



