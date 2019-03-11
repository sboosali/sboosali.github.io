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
main = do
  shakeOptions <- getShakeOptions
  Shake.shakeArgs shakeOptions shakeRules

--------------------------------------------------

getShakeOptions :: IO Shake.ShakeOptions
getShakeOptions = do

  shakeDirectory <- getShakeCacheDirectory

  let options = Shake.shakeOptions
       { Shake.shakeThreads = 6
       , Shake.shakeFiles   = shakeDirectory
       }

  return options

  where

  getShakeCacheDirectory :: IO FilePath
  getShakeCacheDirectory = do
    Directory.getXdgDirectory Directory.XdgCache ("shake" </> xdgNamespace)
    -- e.g. « ~/.cache/shake/sboo-io ».

--------------------------------------------------

shakeRules :: Shake.Rules ()
shakeRules = do

  buildDirectory <- io getCacheDirectory
  let buildFile = (buildDirectory </>) :: FilePath -> FilePath

  Shake.action needBlogFiles

  buildFile "posts//*.html" %> fromMarkdown

  cleanRule

  listRule

  where

  needBlogFiles :: Shake.Action ()
  needBlogFiles = do

    blogFiles <- getBlogFiles

    Shake.need blogFiles

  getBlogFiles :: Shake.Action [FilePath]
  getBlogFiles = do

    mdFiles <- getMarkdownFiles

    let htmlFiles = mdFiles
    return htmlFiles

--------------------------------------------------
-- Constants -------------------------------------
--------------------------------------------------

author = "Spios Boosalis"

--tags = [ "mtg" ]

copyright = "© " <> author <> " " <> licenseSPDX -- TODO Formatting. 

--------------------------------------------------

licenseSPDX = "CC-BY-NC-SA-4.0"
licenseName = "Creative Commons Attribution Non Commercial Share Alike 4.0 International"
licenseFile = "../text/CC-BY-NC-SA-4.0/LICENSE"

--------------------------------------------------

mdDirectory :: FilePath
mdDirectory = "../md"

--------------------------------------------------

cssDirectory :: FilePath
cssDirectory = "../css"

--------------------------------------------------

jsDirectory :: FilePath
jsDirectory = "../js"

--------------------------------------------------

videoDirectory :: FilePath
videoDirectory = "../video"

--------------------------------------------------

imageDirectory :: FilePath
imageDirectory = "../image"

--------------------------------------------------

nixDirectory :: FilePath
nixDirectory = "../nix"

--------------------------------------------------

hsDirectory :: FilePath
hsDirectory = "../hs"

--------------------------------------------------

bashDirectory :: FilePath
bashDirectory = "../bash"

--------------------------------------------------

cssPostFile :: FilePath
cssPostFile = asCssFile "post.css"

--------------------------------------------------

xdgNamespace :: FilePath
xdgNamespace = "sboo-io"

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
-- Ruless ----------------------------------------
--------------------------------------------------

cleanRule :: Shake.Rules ()
cleanRule = Shake.phony "clean" do

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