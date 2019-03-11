#!/usr/bin/env cabal

{- cabal:

 build-tool-depends: sboo-io:shake-sboo-io
                   , hserv:hserv

  ----------------------------

 build-depends: spiros
               , directory  ^>= 1.3
               , filepath   ^>= 1.4

-}

--------------------------------------------------

{-# LANGUAGE NoImplicitPrelude #-}

--------------------------------------------------

{-# LANGUAGE PackageImports        #-}
{-# LANGUAGE BlockArguments        #-}
{-# LANGUAGE RecordWildCards       #-}
{-# LANGUAGE NamedFieldPuns        #-}
{-# LANGUAGE DuplicateRecordFields #-}

--------------------------------------------------



--------------------------------------------------

{-| 

-}

--------------------------------------------------
-- Imports ---------------------------------------
--------------------------------------------------

import qualified "typed-process" System.Process.Typed as Process

--------------------------------------------------

import qualified "filepath" System.FilePath as File

--------------------------------------------------

import qualified "directory" System.Directory as Directory

--------------------------------------------------

--import qualified "base" System.Info as IO

--------------------------------------------------

import "spiros" Prelude.Spiros

--------------------------------------------------
-- Main ------------------------------------------
--------------------------------------------------

main :: IO ()
main = do

  putStrLn "sboo.io"

  Process.runProcess_ $ hserv () [ "--port=6556" ]

--------------------------------------------------
-- Types -----------------------------------------
--------------------------------------------------

--------------------------------------------------
-- Constants -------------------------------------
--------------------------------------------------

--------------------------------------------------
-- Programs --------------------------------------
--------------------------------------------------

hserv :: () -> [String] -> Process.ProcessConfig () () () -- stdin stdout stderr
hserv _options arguments = Process.proc "hserv" arguments

--------------------------------------------------
-- XDG -------------------------------------------
--------------------------------------------------

xdgNamespace :: FilePath
xdgNamespace = "sboo-io"

--------------------------------------------------

getConfigDirectory :: IO FilePath
getConfigDirectory = do
  Directory.getXdgDirectory Directory.XdgConfig xdgNamespace

--------------------------------------------------

getDataDirectory :: IO FilePath
getDataDirectory = do
  Directory.getXdgDirectory Directory.XdgData xdgNamespace

--------------------------------------------------

getCacheDirectory :: IO FilePath
getCacheDirectory = do
  Directory.getXdgDirectory Directory.XdgCache xdgNamespace

--------------------------------------------------
-- Utilities -------------------------------------
--------------------------------------------------

--------------------------------------------------
-- EOF -------------------------------------------
--------------------------------------------------