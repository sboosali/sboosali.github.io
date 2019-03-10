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

Open ?=xdg-open

#------------------------------------------------#

Python ?=python

Serve  ?=$(Python) -m SimpleHTTPServer $(Port)

# ^ server program.

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

IndexFile=index.html

HtmlFiles=html/*.html

CssFiles=css/*.css

JsFiles=js/*.js

#------------------------------------------------#

MarkdownFiles=md/*.md

#------------------------------------------------#

ImageFiles=images/*.*

VideoFiles=videos/*.*

#------------------------------------------------#

BashFiles=scripts/*.sh

NixFiles=nix/*.nix

NixJsonFiles=nix/*.json

# ^ e.g. « nix/nixpkgs.json » from « nix-prefetch-url ».

##################################################
# Targets ########################################
##################################################

default: open-index

.PHONY: default

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

##################################################
# File Targets ###################################
##################################################
#------------------------------------------------#

shell: $(NixFiles) # $(NixJsonFiles)

	$(CheckNix) ./shell.nix

	touch                           "./shell"
	echo "#!/bin/bash"           >> "./shell"
	echo "nix-shell ./shell.nix" >> "./shell"
	chmod +x ./shell

#------------------------------------------------#
##################################################
# Targets: File Types ############################
##################################################

$(WebFiles): $(HtmlFiles) $(CssFiles) $(JsFiles)

#------------------------------------------------#

$(HtmlFiles): check-html

$(CssFiles): #TODO check-css

$(JsFiles): check-js

#------------------------------------------------#

$(BashFiles): check-bash

$(NixFiles): check-nix

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
	find -L . -name '*.md' -exec pandoc -f markdown -t html '{}' ';'

.PHONY: check-markdown

##################################################
# Building #######################################
##################################################
#------------------------------------------------#

build-blog:
	pandoc --standalone -f markdown -t html --css "../css/post.css" blog/TSP.md > blog/TSP.html

.PHONY: build-blog

#------------------------------------------------#
##################################################
# Development ####################################
##################################################
#------------------------------------------------#

run: serve

.PHONY: run

#------------------------------------------------#
##################################################
# Fake Targets (never return, or always succeed) #
##################################################
open:
	$(Open) $(IndexFile)

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

test: build open

.PHONY: test

#------------------------------------------------#
serve:
	$(Serve)

.PHONY: serve

##################################################