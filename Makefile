REPOPATH = $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
PATH := $(REPOPATH)/vendor/schematron-cli/bin:$(PATH)

schema/hocr-%.xsl: schema/hocr-%.sch
	vendor/schematron-cli/bin/schematron --xslt-out $@ $<
