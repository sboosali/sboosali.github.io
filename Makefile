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

# CheckCss?=

# CheckJs?=

CheckBash?=shellcheck
#CheckNix?=nix-instantiate

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
default: $(Target)

.PHONY: default

##################################################
test: build open

.PHONY: test

##################################################
run: serve

.PHONY: run

##################################################
build: 

.PHONY: build

##################################################
check: check-html check-bash

.PHONY: check

#TODO# check: check-html check-css check-js check-bash check-nix check-json check-md check-txt

##################################################
# Targets: File Types ############################
##################################################

$(HtmlFiles): check-html

$(BashFiles): check-bash

##################################################
# Targets: Linters ###############################
##################################################
check-html:
	$(CheckHtml) $(HtmlFiles) 2>/dev/null

.PHONY: check-html

##################################################
check-bash:
	$(CheckBash) $(BashFiles) 2>/dev/null

.PHONY: check-bash

# ##################################################
# check-css: $(CssFiles)
# 	$(CheckCss) $(CssFiles)

# .PHONY: check-css

# ##################################################
# check-js: $(JsFiles)
# 	$(CheckJs) $(JsFiles)

# .PHONY: check-js

##################################################
# Fake Targets (never return, or always succeed) #
##################################################
open:
	$(Open) $(IndexFile)

.PHONY: open

##################################################
serve:
	$(Serve)

.PHONY: serve

##################################################