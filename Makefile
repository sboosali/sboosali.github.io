##################################################
# Makefile Settings/Directives
##################################################

SHELL=bash

.EXPORT_ALL_VARIABLES:

##################################################
# Customizeable Variables ########################
##################################################

Port?=2666

###BaseDirectory?=$(CURDIR)

##################################################
# Programs:

Open?=xdg-open

Python?=python

CheckHtml?=tidy

# CheckCss?=

# CheckJs?=

##################################################
# Files ##########################################
##################################################

IndexFile=index.html

HtmlFiles=*.html

CssFiles=css/*.css

JsFiles=js/*.js

##################################################
# Targets ########################################
##################################################
default: test

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
check: check-html check-css check-js

.PHONY: check

##################################################
# Linter Targets #################################
##################################################
check-html: $(HtmlFiles)
	$(CheckHtml) $(HtmlFiles)

.PHONY: check-html

##################################################
check-css: $(CssFiles)
#TODO#	$(CheckCss) $(CssFiles)

.PHONY: check-css

##################################################
check-js: $(JsFiles)
#TODO#	$(CheckJs) $(JsFiles)

.PHONY: check-js

##################################################
# Fake Targets (never return, or always succeed) #
##################################################
open:
	$(Open) $(IndexFile)

.PHONY: open

##################################################
serve:
	$(Python) -m SimpleHTTPServer $(Port)

.PHONY: serve

##################################################