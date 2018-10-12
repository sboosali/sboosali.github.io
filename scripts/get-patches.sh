#!/bin/bash
set -u
##################################################

export HaskellDirectory=~/haskell/

export WebDirectory=~/www/

export PatchesDirectory="${WebDirectory}"/sboosali.github.io/patches/

##################################################

(cd "${HaskellDirectory}/polyparse" && git diff v1.12 v1.30 > "${PatchesDirectory}/polyparse.diff")

(cd "${HaskellDirectory}/HaXml2" && git diff v1.26 v1.30 > "${PatchesDirectory}/haxml.diff")
 
##################################################