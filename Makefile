##################################################
# Makefile Settings/Directives
##################################################

SHELL=bash

.EXPORT_ALL_VARIABLES:

##################################################
# Makefile Variables #############################
##################################################

Port?=2666

# ^ server port.
#------------------------------------------------#
# Paths:
#------------------------------------------------#

BaseDirectory ?=$(CURDIR)

InstallDirectory ?=./out

#------------------------------------------------#
# Programs:
#------------------------------------------------#

Pandoc ?=pandoc

#------------------------------------------------#

Python ?=python

Serve  ?=$(Python) -m SimpleHTTPServer $(Port)

# ^ server program.

#------------------------------------------------#

Open ?=xdg-open

#------------------------------------------------#

CheckHtml       ?=tidy -errors

# ^ "⦗ -errors, -e ⦘ — show only errors and warnings."

CheckCss	?=csslint

CheckJs		?=eslint

CheckBash	?=shellcheck

CheckNix	?=nix-instantiate --parse
#TODO CheckNix?=nix eval

# CheckTarball?=tar -C /tmp -zxvf

# CheckJson?=jsonlint
# CheckMarkdown?=$(Markdown)
# CheckProse?=spellcheck

##################################################
# Constants ######################################
##################################################

BlogFiles=blog/TSP.html blog/PLC.html blog/FUT.html

MirrorFiles=mirror/boolean-blindness.html

#------------------------------------------------#

IndexFile=index.html

CssPostFile=../css/post.css

# ^ NOTE:
#   the CSS path is relative to the desintation (i.e. « ./blog »).

#------------------------------------------------#

HtmlFiles=html/*.html

CssFiles=css/*.css

JsFiles=js/*.js

#------------------------------------------------#

MarkdownFiles=md/*.md

#------------------------------------------------#

ImageFiles=images/*.*

VideoFiles=videos/*.*

#------------------------------------------------#

BashFiles=bash/*

NixFiles=nix/*.nix

NixJsonFiles=nix/*.json

# ^ e.g. « nix/nixpkgs.json » from « nix-prefetch-url ».

##################################################
# Targets ########################################
##################################################

default: blog

.PHONY: default

#------------------------------------------------#
# File Targets ----------------------------------#
#------------------------------------------------#

blog/%.html : md/%.md

	mkdir -p ./blog

	$(Pandoc)  --standalone  --from markdown  --to html  --css $(CssPostFile)  $<   >   $@

# e.g.
#     $ pandoc  --standalone  --from markdown  --to html  --css ./css/post.css  --metadata pagetitle="PLC"  md/PLC.md  >  blog/PLC.html

# --metadata pagetitle="$<"

#------------------------------------------------#

mirror/%.html : mirror/%.md

	mkdir -p ./mirror

	$(Pandoc)  --standalone  --from markdown  --to html  --css $(CssPostFile)  $<   >   $@

#------------------------------------------------#

# shell: $(NixFiles) # $(NixJsonFiles)

# 	$(CheckNix) ./shell.nix

# 	touch                           "./shell"
# 	echo "#!/bin/bash"           >> "./shell"
# 	echo "nix-shell ./shell.nix" >> "./shell"
# 	chmod +x ./shell

#------------------------------------------------#
# Standard Targets ------------------------------#
#------------------------------------------------#

build: $(WebFiles)

.PHONY: build

#------------------------------------------------#

check: check-html check-bash check-nix

.PHONY: check

#TODO# check: check-html check-css check-js check-bash check-nix check-json check-md check-txt

#------------------------------------------------#

install: build

	mkdir -p "$(InstallDirectory)/html"
	mkdir -p "$(InstallDirectory)/css"
	mkdir -p "$(InstallDirectory)/js"

	mkdir -p "$(InstallDirectory)/images"
	mkdir -p "$(InstallDirectory)/videos"

	cp -rav $(IndexFile) "$(InstallDirectory)"
	cp -rav $(HtmlFiles) "$(InstallDirectory)/html"
	cp -rav $(CssFiles)  "$(InstallDirectory)/css"
	cp -rav $(JsFiles)   "$(InstallDirectory)/js"

.PHONY: install

#------------------------------------------------#
# Blog ------------------------------------------#
#------------------------------------------------#

blog: $(BlogFiles)

.PHONY: blog

#------------------------------------------------#

mirror: $(MirrorFiles)

.PHONY: mirror

#------------------------------------------------#
##################################################
# Targets: File Types ############################
##################################################

# $(WebFiles): $(HtmlFiles) $(CssFiles) $(JsFiles)

# #------------------------------------------------#

# $(HtmlFiles): check-html

# $(CssFiles): #TODO check-css

# $(JsFiles): check-js

# #------------------------------------------------#

# $(BashFiles): check-bash

# $(NixFiles): check-nix

##################################################
# Targets: Linters ###############################
##################################################

check-html:
	$(CheckHtml) $(HtmlFiles) 2>/dev/null

.PHONY: check-html

#------------------------------------------------#

check-css:
	$(CheckCss) $(CssFiles) 2>/dev/null

.PHONY: check-css

#------------------------------------------------#

check-bash:
	$(CheckBash) $(BashFiles) 2>/dev/null

.PHONY: check-bash

#------------------------------------------------#

check-nix:
	$(CheckNix) $(NixFiles) 2>/dev/null >/dev/null

.PHONY: check-nix

# #------------------------------------------------#

# check-css: $(CssFiles)
# 	$(CheckCss) $(CssFiles)

# .PHONY: check-css

# #------------------------------------------------#

# check-js: $(JsFiles)
# 	$(CheckJs) $(JsFiles)

# .PHONY: check-js

#------------------------------------------------#

check-markdown:
	find -L . -name '*.md' -exec $(Pandoc) -f markdown -t html '{}' ';'

.PHONY: check-markdown

##################################################
# Building #######################################
##################################################
#------------------------------------------------#
##################################################
# Development ####################################
##################################################
#------------------------------------------------#

run: serve

.PHONY: run

#------------------------------------------------#

shake:

	(cd "./hs"  &&  cabal new-run "exe:shake-sboo-io")

#	cabal new-run --project-file=./hs/cabal.project "exe:shake-sboo-io"
#	(cd ./hs  &&  cabal new-run "exe:shake-sboo-io")

.PHONY: shake

#------------------------------------------------#
##################################################
# Fake Targets (never return, or always succeed) #
##################################################

open: open-index

.PHONY: open

#------------------------------------------------#

open-index:
	$(Open) $(IndexFile)

.PHONY: open-index

#------------------------------------------------#

open-blog: build-blog

	$(Open) blog/TSP.html

.PHONY: open-blog

#------------------------------------------------#

serve:
	$(Serve)

.PHONY: serve

#------------------------------------------------#

clean:
	rm -f blog/*.html

.PHONY: clean

##################################################