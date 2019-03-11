#!/usr/bin/env cabal

{- cabal:

  build-depends: base       ^>= 4.12
               , shake      ^>= 0.17
               , formatting ^>= 6.3

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

import qualified "shake" Development.Shake          as Shake
--import qualified "shake" Development.Shake.FilePath as Shake

import           "shake" Development.Shake          ((%>))

import           "shake" Development.Shake.FilePath ((</>), (-<.>))
--import           "shake" Development.Shake.FilePath ((</>), (<.>), (-<.>))

--------------------------------------------------

--import qualified "formatting" Formatting as F
--import           "formatting" Formatting ((%))

--------------------------------------------------

import qualified "filepath" System.FilePath as File

--------------------------------------------------

import qualified "directory" System.Directory as Directory

--------------------------------------------------

--import qualified "base" Data.Version as Version
--import           "base" Data.Version (Version)

--import qualified "base" System.Info as IO

import qualified "base" Data.Char  as Char

--------------------------------------------------

import "spiros" Prelude.Spiros

--------------------------------------------------
-- Main ------------------------------------------
--------------------------------------------------

main :: IO ()
main = Shake.shakeArgs shakeOptions shakeRules

--------------------------------------------------

shakeOptions :: Shake.ShakeOptions
shakeOptions = Shake.shakeOptions
  { Shake.shakeThreads = 6
  }

--------------------------------------------------

shakeRules :: Shake.Rules ()
shakeRules = do

  Shake.want ["../blog/*.html"] --TODO blogHtmlFiles

  "../blog/*.html" %> fromMarkdown

  clean

--------------------------------------------------
-- Types -----------------------------------------
--------------------------------------------------

data CompileMarkdown = CompileMarkdown

  { md   :: FilePath
  , html :: FilePath
  , css  :: FilePath
  }

  deriving (Show,Eq,Ord,Generic)

--------------------------------------------------



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

  mkBlogFile = ("../blog" </>)

--------------------------------------------------

cssPostFile :: FilePath
cssPostFile = "../css/post.css"

--------------------------------------------------
-- Actions ---------------------------------------
--------------------------------------------------

fromMarkdown :: FilePath -> Shake.Action ()
fromMarkdown htmlFile = do

  Shake.need [ mdFile ]
  runCompileMarkdown config

  where

  mdFile = File.replaceDirectory "md" (htmlFile -<.> "md")

  config = CompileMarkdown

    { md   = mdFile
    , html = htmlFile
    , css  = cssPostFile
    }

--------------------------------------------------

clean :: Shake.Rules ()
clean = Shake.phony "clean" do

  buildDirectory <- io getCacheDirectory

  io $ Shake.removeFiles buildDirectory ["//*"]

  --NOTE-- « Shake.removeFiles _ ["//*"] » means:
  --       delete everything inside the directory, but not the directory itself.

--------------------------------------------------
-- Programs --------------------------------------
--------------------------------------------------

pandoc :: (Shake.CmdResult r) => [Shake.CmdOption] -> [String] -> Shake.Action r
pandoc options arguments = Shake.command options "pandoc" arguments

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

{-| Invokes @pandoc@ to convert a Markdown file into an HTML file.

@
$ pandoc  --standalone  --from markdown  --to html  --css "$CSS.css"  "$MD.md"   >  "$HTML.html"
@

-}

runCompileMarkdown :: (Shake.CmdResult r) => CompileMarkdown -> Shake.Action r
runCompileMarkdown CompileMarkdown{ css, md, html } = pandoc options arguments
  where

  options =

    [ Shake.FileStdout html
    , Shake.EchoStdout True
    , Shake.Traced     ""
    ]

  arguments = filterBlanks

    [ "--standalone"
    , "--from markdown"
    , "--to html"
    , "--css " <> css
--  , F.formatToString ("--css " % F.string) css
    , md
    , ""
    ]

--------------------------------------------------

filterBlanks :: [String] -> [String]
filterBlanks = filter (not . isBlank)
  where

  isBlank = all Char.isSpace

--------------------------------------------------
-- EOF -------------------------------------------
--------------------------------------------------