hocr-spec
=========

[![Join the chat at https://gitter.im/kba/hocr-spec](https://badges.gitter.im/kba/hocr-spec.svg)](https://gitter.im/kba/hocr-spec?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

The hOCR Embedded OCR Workflow and Output Format

## About

This repository contains the [hOCR](https://en.wikipedia.org/wiki/HOCR) format
specification originally written by [Thomas Breuel](https://github.com/tmbdev).

## Versions

* `1.0` [English](https://docs.google.com/document/d/1QQnIQtvdAC_8n92-LhwPcjtAUFwBlzE8EWnKAxlgVf0/preview)
  * Google Doc the original text by @tmbdev
  * Last substantial edit in May 2010
* `1.1` [English](./1.1/spec.md), [中文 (Chinese)](./1.1/spec_zh_CN.md)
  * Port of the Google Doc
  * Cleaning obvious errata (duplicate content)
  * More fine-grained heading structure
  * Table of contents
  * Chinese translation provided by [@littlePP24](https://github.com/littlePP24) and [@wanghaisheng](https://github.com/wanghaisheng)
  * Last substantial edit in September 2016
* `1.2` [English](https://kba.github.io/hocr-spec/1.2/)
  * Create a WHATWG-like spec using [bikeshed](https://github.com/tabatkins/bikeshed)
  * Add issues where appropriate
  * Semantically backwards-compatible with both 1.0 and 1.1

## Contribute

There is no formal body. Feel free to use the [Github
issues](https://github.com/kba/hocr-spec/issues) for discussion and questions.
Pull requests are very welcome.

For quick questions you can use the [hocr-spec gitter
channel](https://gitter.im/kba/hocr-spec).

## Building the spec

To build the spec, you will need to have installed:
  * `GNU make` 
  * One of the following programs installed:
    * [bikeshed](https://github.com/tabatkins/bikeshed)
    * [docker](https://docker.com)
  * Python 3

To install the python requirements:

```sh
pip3 install --user -r requirements.txt
```

The Makefile will first look for a local bikeshed installation and fallback to docker
to use the [bikeshed docker container](https://hub.docker.com/kbai/bikeshed) 
to build the spec.

To change the spec, adapt
  * `<VERSION>/spec.md` to change the body of the spec
  * `<VERSION>/spec.before.html` to change
    * the [bikeshed metadata](https://tabatkins.github.io/bikeshed/#metadata)
    * the [references to terms from other specs](https://tabatkins.github.io/bikeshed/#custom-dfns)
  * `<VERSION>/spec.after.html` to change
    * Javascript to run in the generated spec document
  * `<VERSION>/defs.yml` to change the definition lists for elements and properties

Then run `make VERSION=<VERSION>` to build that spec.

Examples:
  * To build the `1.2` version: `make VERSION=1.2` or simply `make`
  * To build the `1.2-zh` version: `make VERSION=1.2-zh`

## Open Tasks

The goal of this project is to make the hOCR specification more accessible and
easier to maintain.

* Cross-reference other specs
* Harmonize style
* Add samples
* [...](https://github.com/kba/hocr-spec/issues)
