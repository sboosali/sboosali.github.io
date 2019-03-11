#!/usr/bin/env cabal

{- cabal:

  build-depends: base       ^>= 4.12
               , shake      ^>= 0.17
               , formatting ^>= 6.3

-}

--------------------------------------------------

{-# LANGUAGE PackageImports #-}

--------------------------------------------------

{-| 

-}

--------------------------------------------------
-- Imports ---------------------------------------
--------------------------------------------------

import qualified "shake" Development.Shake          as Shake
import qualified "shake" Development.Shake.FilePath as Shake

import           "shake" Development.Shake          ((%>))
import           "shake" Development.Shake.FilePath ((</>), (<.>), (-<.>))

--------------------------------------------------

import qualified "formatting" Formatting as F
import           "formatting" Formatting ((%))

--------------------------------------------------

import qualified "base" Data.Char as Char

import "base" Data.Maybe

import "base" Prelude

--------------------------------------------------
-- Main ------------------------------------------
--------------------------------------------------

main :: IO ()
main = Shake.shakeArgs options rules

--------------------------------------------------

options :: Shake.ShakeOptions
options = Shake.shakeOptions

--------------------------------------------------

rules :: Shake.Rules ()
rules = do

  Shake.want blogHtmlFiles

  "*.html" %> fromMarkdown

--------------------------------------------------
-- Constants -------------------------------------
--------------------------------------------------

blogHtmlFiles :: [FilePath]
blogHtmlFiles = (fmap mkBlogFile . filterBlanks)

  [ "TSP.html"
  , "PLC.html"
  , "FUT.html"
  , ""
  , ""
  ]

  where

  mkBlogFile = ("blog" </>)

--------------------------------------------------

cssPostFile :: FilePath
cssPostFile = "./css/post.css"

--------------------------------------------------
-- Actions ---------------------------------------
--------------------------------------------------

fromMarkdown :: FilePath -> Shake.Action ()
fromMarkdown htmlFile = return()

  -- Shake.need [ md ]
  -- Shake.cmd (pandocMarkdownHTML cssPostFile mdFile htmlFile)

  -- where

  -- mdFile = htmlFile -<.> "md"

  -- pandocMarkdownHTML css md html =

  --   F.format ("pandoc  --standalone  --from markdown  --to html  --css " % F.text % " " % F.text % " > " % F.text % "") css md html

-- "pandoc  --standalone  --from markdown  --to html  --css css  md   >  html"

--------------------------------------------------
-- Utilities -------------------------------------
--------------------------------------------------

filterBlanks :: [String] -> [String]
filterBlanks = id -- filter (not . isBlank)
  -- where

  -- isBlank = all Char.isSpace

--------------------------------------------------
-- EOF -------------------------------------------
--------------------------------------------------