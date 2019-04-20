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

import           "shake" Development.Shake.FilePath ((</>), (<.>), (-<.>))

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

  Shake.action (needBlogFiles buildFile)

  buildFile "posts//*.html" %> fromMarkdown

  buildFile "share/bash-completion/shake-sboo-io" %> mkBashCompletion

  cleanRule

  listRule

  where

  needBlogFiles :: (FilePath -> FilePath) -> Shake.Action ()
  needBlogFiles buildFile = do

    blogFiles <- getBlogFiles buildFile

    Shake.need blogFiles

  getBlogFiles :: (FilePath -> FilePath) -> Shake.Action [FilePath]
  getBlogFiles buildFile = do

    mdFiles <- getMarkdownFiles

    let htmlFiles = mdFiles <&> (-<.> "html")

    let postFiles = htmlFiles <&> asPostFile

    return postFiles

    where

    asPostFile :: FilePath -> FilePath
    asPostFile = buildFile . ("posts//" </>)

--------------------------------------------------
-- Constants -------------------------------------
--------------------------------------------------

author = "Spiros Boosalis"

--tags = [ "mtg" ]

copyright = "© " <> author <> " " <> licenseSPDX -- TODO Formatting. 

--------------------------------------------------

licenseSPDX = "CC-BY-NC-SA-4.0"
licenseName = "Creative Commons Attribution Non Commercial Share Alike 4.0 International"
licenseFile = "../text/CC-BY-NC-SA-4.0/LICENSE"

--------------------------------------------------
--------------------------------------------------

postsSubDirectory :: FilePath
postsSubDirectory = "posts"

--------------------------------------------------
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

  { md    :: FilePath
  , html  :: FilePath
  , css   :: FilePath
  , title :: String
  }

  deriving (Show,Eq,Ord,Generic)

--------------------------------------------------
-- Rules -----------------------------------------
--------------------------------------------------

cleanRule :: Shake.Rules ()
cleanRule = Shake.phony "clean" do
  io do
    buildDirectory <- getCacheDirectory

    Shake.removeFiles buildDirectory ["//*"]

  --NOTE-- « Shake.removeFiles _ ["//*"] » means:
  --       delete everything inside the directory, but not the directory itself.

--------------------------------------------------

listRule :: Shake.Rules ()
listRule = Shake.phony "list" do
  io do
    buildDirectory <- getCacheDirectory

    printDivider

    whenM (Directory.doesDirectoryExist buildDirectory) do

      relativeFiles  <- Shake.getDirectoryFilesIO buildDirectory ["//*"]
      absolutePaths  <- return (relativeFiles <&> (buildDirectory </>))
      canonicalPaths <- absolutePaths & traverse Directory.canonicalizePath

      traverse_ putStrLn canonicalPaths
      printDivider

--------------------------------------------------
-- Actions ---------------------------------------
--------------------------------------------------

fromMarkdown :: FilePath -> Shake.Action ()
fromMarkdown html = do

  runCompileMarkdown config

  where

  name = File.takeBaseName html

  md = asMarkdownFile (name <.> "md")

  css = cssPostFile

  config = CompileMarkdown { md, html, css, title = name }

--------------------------------------------------

mkBashCompletion :: FilePath -> Shake.Action ()
mkBashCompletion bashFile = do

  nothing

--------------------------------------------------
-- Programs --------------------------------------
--------------------------------------------------

pandoc :: (Shake.CmdResult r) => [Shake.CmdOption] -> [String] -> Shake.Action r
pandoc options arguments = Shake.command options "pandoc" arguments

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

getMarkdownFiles :: Shake.Action [FilePath]
getMarkdownFiles = Shake.getDirectoryFiles mdDirectory ["//*.md"]

--------------------------------------------------

getCssFiles :: Shake.Action [FilePath]
getCssFiles = Shake.getDirectoryFiles cssDirectory ["//*.css"]

--------------------------------------------------

getJsFiles :: Shake.Action [FilePath]
getJsFiles = Shake.getDirectoryFiles jsDirectory ["//*.js"]

--------------------------------------------------

getVideoFiles :: Shake.Action [FilePath]
getVideoFiles = Shake.getDirectoryFiles videoDirectory ["//*.ogg", "//*.mp4", "//*.mkv"]

--------------------------------------------------

getImageFiles :: Shake.Action [FilePath]
getImageFiles = Shake.getDirectoryFiles imageDirectory ["//*.png", "//*.jpg", "//*.gif"]

--------------------------------------------------

getHaskelFiles :: Shake.Action [FilePath]
getHaskelFiles = Shake.getDirectoryFiles nixDirectory ["//*.hs", "//*.lhs"]

--------------------------------------------------

getNixFiles :: Shake.Action [FilePath]
getNixFiles = Shake.getDirectoryFiles nixDirectory ["//*.nix", "//*.json"]

--------------------------------------------------

getBashFiles :: Shake.Action [FilePath]
getBashFiles = Shake.getDirectoryFiles bashDirectory ["//*"] -- TODO if executable

--------------------------------------------------

{-| Invokes @pandoc@ to convert a Markdown file into an HTML file.

@
$ pandoc  --standalone  --from markdown  --to html  --css "$CSS.css"  "$MD.md"   >  "$HTML.html"
@

-}

runCompileMarkdown :: (Shake.CmdResult r) => CompileMarkdown -> Shake.Action r
runCompileMarkdown CompileMarkdown{ css, md, html, title } = do

  Shake.need [ css, md ]

  pandoc options arguments

  where

  options =

    [ Shake.FileStdout html
    , Shake.EchoStdout True
    , Shake.Traced     ""
    ]

  arguments = filterBlanks

    [ "--standalone"
    , "--from=markdown"
    , "--to=html"
    , "--css=" <> css
--TODO , F.formatToString ("--css " % F.string) css

    , "--metadata=pagetitle:" <> title
    , "--metadata=title:"     <> title
    , "--metadata=author:"    <> author

    , md
    , ""
    ]

--------------------------------------------------

asMarkdownFile :: FilePath -> FilePath
asMarkdownFile = (mdDirectory </>)

--------------------------------------------------

asCssFile :: FilePath -> FilePath
asCssFile = (cssDirectory </>)

--------------------------------------------------

asJsFile :: FilePath -> FilePath
asJsFile = (jsDirectory </>)

--------------------------------------------------

asVideoFile :: FilePath -> FilePath
asVideoFile = (videoDirectory </>)

--------------------------------------------------

asImageFile :: FilePath -> FilePath
asImageFile = (imageDirectory </>)

--------------------------------------------------

asNixFile :: FilePath -> FilePath
asNixFile = (nixDirectory </>)

--------------------------------------------------

asHaskellFile :: FilePath -> FilePath
asHaskellFile = (hsDirectory </>)

--------------------------------------------------

asBashFile :: FilePath -> FilePath
asBashFile = (bashDirectory </>)

--------------------------------------------------

filterBlanks :: [String] -> [String]
filterBlanks = filter (not . isBlank)
  where

  isBlank = all Char.isSpace

--------------------------------------------------

printDivider :: IO ()
printDivider = do

  putStrLn "----------------------------------------"

--------------------------------------------------
-- EOF -------------------------------------------
--------------------------------------------------