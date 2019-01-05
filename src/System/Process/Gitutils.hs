module System.Process.Gitutils where

import Control.Concurrent
  ( forkIO
  )

import System.Process
  ( CreateProcess
  , StdStream(CreatePipe)
  , withCreateProcess
  , waitForProcess
  , std_in
  , std_out
  , std_err
  , spawnProcess
  )

import System.Exit
  ( ExitCode
  )

import System.IO
  ( FilePath
  )

import GHC.IO.Handle
  ( hPutStr
  , hGetContents
  )

echoReadCreateProcessWithExitCode :: CreateProcess -> String -> IO (ExitCode, String, String)
echoReadCreateProcessWithExitCode cmd input = do
  -- Ensure new pipes attached
  let cmd2 = cmd { std_out = CreatePipe
                 , std_err = CreatePipe
                 , std_in = CreatePipe
                 }
  withCreateProcess cmd2 $ \(Just stdin) (Just stdout) (Just stderr) ph -> do
    -- Probably this is wrong...
    hPutStr stdin input
    -- Get lazy strings of stdout and stderr
    output <- hGetContents stdout
    err <- hGetContents stderr
    -- pipe subprocess std out/err to own stdout/err (without blocking)
    forkIO $ putStr output
    forkIO $ putStr err
    -- wait for subprocess to finish, and return results
    exitCode <- waitForProcess ph
    return (exitCode, output, err)

callProcessWithExitCode :: FilePath -> [String] -> IO ExitCode
callProcessWithExitCode bin args = spawnProcess bin args >>= waitForProcess
