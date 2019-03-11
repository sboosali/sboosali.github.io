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

  Process.runProcess_ $ hserv ()
    [ "--port=" <> port
    ]

  Process.runProcess_ $ open ()
    [ url
    ]

  where

  port = show portNumber

  url  = "http://0.0.0.0:" <> port

--------------------------------------------------
-- Constants -------------------------------------
--------------------------------------------------

portNumber :: Word16
portNumber = 6556

--------------------------------------------------

xdgNamespace :: FilePath
xdgNamespace = "sboo-io"

--------------------------------------------------
-- Types -----------------------------------------
--------------------------------------------------

-------------------------------------------------
-- Programs --------------------------------------
--------------------------------------------------

hserv :: () -> [String] -> Process.ProcessConfig () () () -- stdin stdout stderr
hserv _options arguments = Process.proc "hserv" arguments

--------------------------------------------------

open :: () -> [String] -> Process.ProcessConfig () () () -- stdin stdout stderr
open _options arguments = Process.proc "open" arguments -- TODO or xdg-open

--------------------------------------------------
-- XDG -------------------------------------------
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