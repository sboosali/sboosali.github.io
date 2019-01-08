##################################################
# Makefile Settings/Directives
##################################################

SHELL=bash

.EXPORT_ALL_VARIABLES:

##################################################
# Customizeable Variables: Installation ########## 
##################################################

Port?=2666

# ^ server port.

##################################################

Python?=python

Serve?=$(Python) -m SimpleHTTPServer $(Port)

# ^ server program.

##################################################
# Customizeable Variables: Development ###########
##################################################

# Target?=test
# Target?=check

Target?=check

# ^ default (Makefile) target.

##################################################
# Paths:

BaseDirectory?=$(CURDIR)

##################################################
# Programs:

Open?=xdg-open

CheckHtml?=tidy -errors

# ^ "⦗ -errors, -e ⦘ — show only errors and warnings."

CheckCss?=csslint

CheckJs?=eslint

CheckBash?=shellcheck

CheckNix?=nix-instantiate --parse
#TODO CheckNix?=nix eval

# CheckTarball?=tar -C /tmp -zxvf

# CheckJson?=jsonlint
# CheckMarkdown?=$(Markdown)
# CheckProse?=spellcheck

##################################################
# Constants ######################################
##################################################

HtmlFiles=*.html

CssFiles=css/*.css

JsFiles=js/*.js

##################################################

IndexFile=index.html

##################################################

BashFiles=scripts/*.sh

NixFiles=nix/*.nix

##################################################
# Targets ########################################
##################################################

default: open-blog
#default: $(Target)

.PHONY: default

##################################################
test: build open

.PHONY: test

##################################################
run: serve

.PHONY: run

##################################################
build: $(WebFiles)

.PHONY: build

##################################################
check: check-html check-bash check-nix

.PHONY: check

#TODO# check: check-html check-css check-js check-bash check-nix check-json check-md check-txt

##################################################
# Targets: File Types ############################
##################################################

$(WebFiles): $(HtmlFiles) $(CssFiles) $(JsFiles)

##################################################

$(HtmlFiles): check-html

$(CssFiles): #TODO check-css

$(JsFiles): check-js

##################################################

$(BashFiles): check-bash

$(NixFiles): check-nix

##################################################
# Targets: Linters ###############################
##################################################
check-html:
	$(CheckHtml) $(HtmlFiles) 2>/dev/null

.PHONY: check-html

##################################################
check-css:
	$(CheckCss) $(CssFiles) 2>/dev/null

.PHONY: check-css

##################################################
check-bash:
	$(CheckBash) $(BashFiles) 2>/dev/null

.PHONY: check-bash

##################################################
check-nix:
	$(CheckNix) $(NixFiles) 2>/dev/null >/dev/null

.PHONY: check-nix

# ##################################################
# check-css: $(CssFiles)
# 	$(CheckCss) $(CssFiles)

# .PHONY: check-css

# ##################################################
# check-js: $(JsFiles)
# 	$(CheckJs) $(JsFiles)

# .PHONY: check-js

##################################################
check-markdown:
	find -L . -name '*.md' -exec pandoc -f markdown -t html '{}' ';'

.PHONY: check-markdown

##################################################
build-blog:
	pandoc --standalone -f markdown -t html --css "../css/post.css" blog/TSP.md > blog/TSP.html

.PHONY: build-blog

##################################################
# Fake Targets (never return, or always succeed) #
##################################################
open:
	$(Open) $(IndexFile)

.PHONY: open

##################################################
open-blog: build-blog

	$(Open) blog/TSP.html

.PHONY: open-blog

##################################################
serve:
	$(Serve)

.PHONY: serve

##################################################