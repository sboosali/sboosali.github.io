#!/usr/bin/env cabal

{- cabal:

  build-depends: base     ^>= 4.12
               , shake    ^>= 0.17

-}

--------------------------------------------------

{-# LANGUAGE PackageImports #-}

--------------------------------------------------

{-| 

-}

--------------------------------------------------

import qualified "shake" Development.Shake          as Shake
import qualified "shake" Development.Shake.FilePath as Shake

import           "shake" Development.Shake          ((%>))
import           "shake" Development.Shake.FilePath ((-<.>))

--------------------------------------------------

import "base" Data.Maybe
import "base" Prelude

--------------------------------------------------

main :: IO ()
main = Shake.shakeArgs options rules

--------------------------------------------------

options :: Shake.ShakeOptions
options = Shake.shakeOptions

--------------------------------------------------

rules :: Shake.Rules ()
rules = do

    Shake.want ["result.tar"]

    "*.tar" %> \out -> do

        contents <- Shake.readFileLines $ out -<.> "txt"
        Shake.need contents
        Shake.cmd "tar -cf" [out] contents

--------------------------------------------------