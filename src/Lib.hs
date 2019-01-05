module Lib
    ( fetchUi
    , checkoutRecent
    ) where

import Gitutils.Matchers
  ( matchAllFetch
  , matchAllReflog
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
  , readProcessWithExitCode
  )

import System.Process.Gitutils
  ( echoReadCreateProcessWithExitCode
  , callProcessWithExitCode
  )

import Control.Monad
  ( unless
  , when
  )

deleteAll :: (Eq a) => a -> [a] -> [a]
deleteAll _ [] = []
deleteAll a (b:bs)
  | a == b    = rest
  | otherwise = b:rest
  where rest = deleteAll a bs

removeDuplicates :: (Eq a) => [a] -> [a]
removeDuplicates [] = []
removeDuplicates (a:as) = a:(removeDuplicates . deleteAll a $ as)

checkoutABranch :: [String] -> IO ()
checkoutABranch branches = unless (null branches) $ do
  branch <- chooseItem branches
  case branch of
    Just name -> do putStrLn $ "%%% git checkout " ++ name
                    callProcessWithExitCode "git" ["checkout", name] >>= exitWith
    Nothing   -> putStrLn "Nothing to do"

fetchUi :: IO ()
fetchUi = do
  args <- getArgs
  let cmd = proc "git" ("fetch":args)
  (exitcode, stdout, stderr) <- echoReadCreateProcessWithExitCode cmd ""
  when (exitcode /= ExitSuccess) $ exitWith exitcode
  checkoutABranch . matchAllFetch $ lines stderr ++ lines stdout

checkoutRecent :: IO ()
checkoutRecent = do
  (exitcode, stdout, _) <- readProcessWithExitCode "git"
                                  [ "reflog"
                                  , "-n", "100"
                                  , "--grep-reflog=checkout"
                                  , "--pretty=%gs"
                                  ] ""
  when (exitcode /= ExitSuccess) $ exitWith exitcode
  checkoutABranch . removeDuplicates . matchAllReflog $ lines stdout

