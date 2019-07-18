# hOCR 内置 OCR 工作流程和输出格式, version 1.1

The purpose of this document is to define an open standard for representing OCR
results. The goal is to reuse as much existing technology as possible, and to
arrive at a representation that makes it easy to reuse OCR results.

本文的目的是为表达ocr的结果定义一个开放的标准，目标是尽可能多的重现现有技术，使ocr的结果表达更容易的再现。

This is the chinese translation, an [english translation is available as well](./spec.md).

## Table of Contents

<!-- BEGIN-MARKDOWN-TOC -->
* [Table of Contents](#table-of-contents)
* [修订记录 Revision History](#修订记录-revision-history)
* [1 基本原理 Rationale](#1-基本原理-rationale)
* [2 入门 Getting Started](#2-入门-getting-started)
* [3 术语表达 Terminology and Representation](#3-术语表达-terminology-and-representation)
* [4 逻辑结构元素 Logical Structuring Elements](#4-逻辑结构元素-logical-structuring-elements)
* [5 排版相关元素 Typesetting Related Elements](#5-排版相关元素-typesetting-related-elements)
* [6 Inline Representations](#6-inline-representations)
* [7 字符信息 Character Information](#7-字符信息-character-information)
* [8 OCR 引擎的特定标记 OCR Engine-Specific Markup](#8-ocr-引擎的特定标记-ocr-engine-specific-markup)
* [9 字体，文本颜色，语言，方向 Font, Text Color, Language, Direction](#9-字体-文本颜色-语言-方向-font-text-color-language-direction)
* [10 替代分割/读数 Alternative Segmentations / Readings](#10-替代分割读数-alternative-segmentations--readings)
* [11 组元素和多个层级 Grouped Elements and Multiple Hierarchies](#11-组元素和多个层级-grouped-elements-and-multiple-hierarchies)
* [12 功能 Capabilities](#12-功能-capabilities)
* [13 配置 Profiles](#13-配置-profiles)
* [14 必需的元信息 Required Meta Information](#14-必需的元信息-required-meta-information)
* [15 HTML Markup](#15-html-markup)
	* [15.1 HTML内容的限制 Restrictions on HTML Content](#151-html内容的限制-restrictions-on-html-content)
	* [15.2 映射的建议 Recommendations for Mappings](#152-映射的建议-recommendations-for-mappings)
		* [15.2.1 html_none](#1521-html_none)
		* [15.2.2 html_simple](#1522-html_simple)
		* [15.2.3 html_ocr_<engine>](#1523-html_ocr_)
		* [15.2.4 html_absolute_<element>](#1524-html_absolute_)
		* [15.2.5 html_xytable_absolute](#1525-html_xytable_absolute)
		* [15.2.6 html_xytable_relative](#1526-html_xytable_relative)
		* [15.2.7 html_<processor>](#1527-html_)
* [16 文件元信息 Document Meta Information](#16-文件元信息-document-meta-information)
* [17 用法示例 Sample Usage](#17-用法示例-sample-usage)

<!-- END-MARKDOWN-TOC -->

## 修订记录 Revision History

hOCR has been originally developed by Thomas Breuel.

See the [releases](https://github.com/kba/hocr-spec/releases/) and full [commit
history](https://github.com/kba/hocr-spec/commits/) for a revision history.


## 1 基本原理 Rationale

The purpose of this document is to define an open standard for representing OCR
results. The goal is to reuse as much existing technology as possible, and to
arrive at a representation that makes it easy to reuse OCR results.

本文的目的是为表达ocr的结果定义一个开放的标准，目标是尽可能多的重现现有技术，使ocr的结果表达更容易的再现。


## 2 入门 Getting Started

This document describes many tags and a lot of information that can be output.
However, getting started with hOCR is easy: you only need to output the tags
and information you actually want to.  For example, just outputting `ocr_line`
tags with bounding boxes is already very useful for many applications.  Just
start simple and add more output information as the need arises.

本文档描述了最终输出的诸多标签和大量信息，hOCR 入门很简单，只要使用这些标签和信息来表示你要输出的内容。例如，只输出带边界框的ocr_line标签对于许多应用来说是非常有用处的。从简单开始，在需要的时候来增加更多的信息。


## 3 术语表达 Terminology and Representation

This document describes a representation of various aspects of OCR output in an
XML-like format. That is, we define as set of tags containing text and other
tags, together with attributes of those tags. However, since the content we are
representing is formatted text,

However, we are not actually using a new XML for the representation; instead
embed the representation in XHTML (or HTML) because XHTML and XHTML processing
already define many aspects of OCR output representation that would otherwise
need additional, separate and ad-hoc definitions. These aspects include:

文档主要描述类似XML格式的OCR输出的各个方面的表示，也就是说，我们定义一套包含文本和其他标签的标签集合，和这些标签的属性。然而，由于想表达的文本是格式化文本，实际上并没有用一个新的xml来表达，而是将表达嵌入到XHTMl(HTML)中，因为XHTMl或者HTML过程已经定义了许多OCR的输出，否则需要额外，单独的临时定义，这些方面包括：


* standard representations for common logical structuring elements, including
  section headings, citations, tables, emphasis, line breaks, quotations,
  citations, and preformatted text
* standard representations for fonts, embedded images, embedded vector
  graphics, tables, languages, writing direction, colors
* standard representations for geometric layout and positioning
* output files that are understood without any further modification by widely
  used viewers (browsers), editors, conversion tools, and indexing tools
* libraries for parsing and generating the content
* support for document metadata

*  通用逻辑结构元素的标准表达，包括章节标题，引用，表格，强调，换行符，引文和预格式化文本
*  字体，嵌入式图像，嵌入式矢量图形，表格，语言，书写方向，颜色的标准表达
*  几何布局和定位的标准表达
*  广泛使用的查看器（浏览器），编辑，转换工具，和索引工具，没有使用以上这些工具来对输出文件进一步的修改来增加理解
*  解析和生成内容库
*  支持文档元数据



We are embedding this information inside HTML by encoding it within valid tags
and attributes inside HTML; We are going to use the terms "elements" and
"properties" for referring to embedded markup.

Elements are defined by the class= attribute on an arbitrary HTML tag. All
elements in this format have a class name of the form `ocr…_…`.

Properties are defined by putting information into the `title=` attribute of an
HTML tag. Properties in title attributes are of the form “name values…”, and
multiple properties are separated by semicolons.

通过HTML内有效的标签和属性将上述信息编码嵌入到html中，我们使 用术语“元素”（elements）和“属性”（properties）来指代嵌入式标记，在任意的html标签中通过class=attribute来定义元素。这个格式的所有元素有一个以`ocr.._..` 形式的类名，将信息加入HTML标签属性title=中使用来定义属性（Properties），标题属性的属性以“name values..”形式存在，多属性用分号分隔。

Here is an example:

下面是一个例子：

```html
<div class="ocr_page" id="page_1">
  <div class="ocr_carea" id="column_2" title="bbox 313 324 733 1922">
    <div class="ocr_par" id="par_7"> ... </div>
    <div class="ocr_par" id="par_19"> ... </div>
  </div>
</div>
```

The following properties can apply to most elements (where it makes sense):

* `bbox x0 y0 x1 y1` – the bounding box of the element relative to the
  binarized document image
  * use `x_bboxes` below for character bounding boxes
  * do not use `bbox` unless the bounding box of the layout component is, in
    fact, rectangular
  * some non-rectangular layout components may have rectangular bounding boxes
    if the non-rectangularity is caused by floating elements around which text flows

* `textangle alpha` - the angle in degrees by which textual content has been
  rotate relative to the rest of the page (if not present, the angle is assumed
  to be zero); rotations are counter-clockwise, so an angle of 90 degrees is
  vertical text running from bottom to top in Latin script; note that this is
  different from reading order, which should be indicated using standard HTML
  properties

以下属性可以适应于大多数的元素：

*  bbox x0 y0 x1 y1 ----元素相对应的边框的二值化文档图像
  * x_bbox表示字符边框（bounding boxes）
  * 不要使用bbox，除非页面布局组成的边框是矩形
  * 一些非矩形页面布局组成可能会有矩形边框，如果非矩形是由文本流出周围的浮点元素造成。
*  textangle alpha 角度是通过文本内容相对于页面其他部分旋转的角度来度量（如果不存在，就为0）；旋转是逆时针的，所以90度是在拉丁脚本中垂直文本方向从底部变成顶部；注意的是这与阅读顺序是不同的，需要使用标准HTML属性来表达。



The following properties can apply to most elements but should not be used
unless there is no alternative:

* `poly x0 y0 x1 y1 ...` - a closed polygon for elements with non-rectangular bounds
  * this property must not be used unless there is no other way of
    representing the layout of the page using rectangular bounding boxes,
    since most tools will simply not have the capability of dealing with
    non-rectangular layouts
  * note that the natural and correct representation of many non-rectangular
    layouts is in terms of rectangular content areas and rectangular floats
  * documents using polygonal borders anywhere must indicate this in the
    metadata
  * documents should attempt to provide a reasonable bbox equivalent as well
* `order n` – the reading order of the element (an integer)
  * this property must not be used unless there is no other way of representing
    the reading order of the page by element ordering within the page, since
    many tools will not be able to deal with content that is not in reading order
* `presence` presence must be declared in the document meta data

以下属性适用于大部分的内容，但是尽量不要使用，除非没有选择

* poly x0 y0 x1 y1 ...非矩形边界闭合多边行
  *  这个属性最好不要用，除非没有方法用矩阵边框来表达页面布局，因为大多数工具没有处理非矩形页面布局的能力
  *  注意许多非矩形页面布局的自然和正确的表示是在长矩阵内容领域和矩形浮动方面
  *  文件中使用多边形的边界的任何地方都必须在元数据中表明这一点
  *  文件同时还必须尝试提供合理的等价bbox
*  order n ---元素的阅读顺序(整数)
  *  这个属性最好不要使用，除非没有其他方法可以通过页面内的元素顺序来表达页面的阅读顺序，因为许多工具无法处理没有阅读顺序的内容
*  presence –若存在必须在文档元数据中表明




The following property relates the flow between multiple `ocr_carea` elements,
and between `ocr_carea` and `ocr_linear` elements.

* `cflow s` – the content flow on the page that this element is a part of
  * s must be a unique string for each content flow
  * must be present on ocr_carea and ocrx_block tags when reading order is
    attempted and multiple content flows are present
  * presence must be declared in the document meta data

以下属性涉及多个ocr_carea元素的流动，以及ocr_carea和ocr_linear元素

* cflow s –页面上内容的流动，该元素的一部分
  * s 必须是一个对每个内容流唯一的字符串
  * 必须存在于ocr_carea和ocrx_block标签中，当尝试阅读顺序和存在多个内容流时
  * 若存在必须在文件元数据中说明


This property applies primarily to textlines

* `baseline pn pn-1 … p0` - a polynomial describing the baseline of a line of
  text
  * the polynomial is in the coordinate system of the line, with the bottom
    left of the bounding box as the origin

此属性主要适应于文本行

* baseline pn pn-1 ..p0-描述文本行的基线多项式
  * 多项式在该行的坐标系中，与左边框为为原点的底部


## 4 逻辑结构元素 Logical Structuring Elements

我们认为存在以下逻辑结构元素:
We recognize the following logical structuring elements:
* `ocr_document`
  * `ocr_linear`
    * `ocr_title`
    * `ocr_author`
    * `ocr_abstract`
    * `ocr_part` [`<H1>`]
      * `ocr_chapter` [`<H1>`]
        * `ocr_section` [`<H2>`]
          * `ocr_sub*section` [`<H3>`,`<H4>`]
            * `ocr_display` 
            * `ocr_blockquote` [`<BLOCKQUOTE>`]
            * `ocr_par` [`<P>`]

These logical tags have their standard meaning as used in the publishing
industry and tools like LaTeX, MS Word, and others.

在已出版的产业和工具中比如LaTeX, MS Word和其他，这些逻辑标签具有标准的意义。

The standard HTML tags given in brackets specify the preferred HTML tags to use
with those logical structuring elements, but it may not be possible or
desirable to actually chose those tags (e.g., when adding hOCR information to
an existing HTML output routine).

括号中给出的标准的HTML标签指定首选的HTML标签与逻辑结构元素使用，但它可能无法或者令人满意的实际选择这些标签（例如，当增加hOCR信息到这些现有的HTML输出程序）。


For all of these elements except `ocr_linear`, there exists a natural linear
ordering defined by reading order (`ocr_linear` indicates that the elements
contained in it have a linear ordering). At the level of `ocr_linear`, there
may not be a single distinguished order. A common example of `ocr_linear` is a
newspaper, in which a single newspaper may contain many linear, but there is no
unique reading order for the different linear. OCR evaluation tools should
therefore be sensitive to the order of all elements other than `ocr_linear`.

除了ocr_linear其他所有元素，存在由阅读顺序限定的天然线性排序(“ocr_linear”表示包含的元素具有线性排序）。在“ocr_linear”的层面，有可能不是一个单一的杰出的顺序。“ocr_linear”的一个常见的例子是报纸，其中单份报纸可能包含许多linear，但对于不同的linear无唯一的阅读顺序。因此OCR评价工具应该比ocr_linear对元素的顺序更敏感。


Tags must be nested as indicated by nesting above, but not all tags within the
hierarchy need to be present.

由上述嵌套所指示的标签必须嵌套的，但分层结构内的所有标签不一定都需要存在。


Textual information like section numbers and bullets must be represented as
text inside the containing element.

例如章节号和bullets原文信息必须表示为包含的元素中的文本。


Documents whose logical structure does not map naturally onto these logical
structuring elements must not use them for other purpose.

逻辑结构没有很自然地映射到这些逻辑结构元素中的文件，不得使用它们用于其他目的。

Image captions may be indicated using the `ocr_caption` element; such an
element refers to the image(s) contained within the same float, or the
immediately adjacent image if both the image and the `ocr_caption` element are
in running text.

图片说明可以用“ocr_caption”元素来表示;这样的元素是指包含在同一范围内浮动图像，或者直接相邻的图像如果这两个图像和“ocr_caption”元素是在运行的文本。


## 5 排版相关元素 Typesetting Related Elements

The following typesetting related elements are based on a typesetting model as
found in most typesetting systems, including
[XSL:FO](https://www.w3.org/TR/xsl11/#fo-section),
[(La)TeX](https://latex-project.org/guides/usrguide.pdf),
[LibreOffice](https://wiki.documentfoundation.org/images/e/e6/WG42-WriterGuideLO.pdf),
and Microsoft Word.

下面排版相关的元素是基于在最优排版系统中找到的排版模型，包括XXSL:FO, (La)TeX, LibreOffice, 和 Microsoft Word。在这些系统中，每个页面被划分成若干个区域。每个区域可以是正文的一部分（或多个正文部分，例如报纸的布局）。区域的内容从文本内容的线性流中得出，流入区域，在其优选的方向面向行填充它们。


In those systems, each page is divided into a number of areas. Each area can
either be a part of the body text (or multiple body texts, in the case of
newspaper layouts). The content of the areas derives from a linear stream of
textual content, which flows into the areas, filling them linewise in their
preferred directions.

覆盖在该页面是一组浮动元素；浮动元素存在正常阅读顺序之外。浮动元素可以由文字内容引入，或者它们可以与网页本身有关（锚定anchoring是一个逻辑属性）。

Overlaid onto the page is a set of floating elements; floating elements exist
outside the normal reading order. Floating elements may be introduced by the
textual content, or they may be related to the page itself (anchoring is a
logical property). In typesetting systems, floating elements may be anchored to
the page, to paragraphs, or to the content stream. Floating pelements can
overlap content areas and render on top of or under content, or they can force
content to flow around them. The default for floating elements in this spec is
that their anchor is undefined (it is a logical property, not a typesetting
property), and that text flows around them. Note that with rectangular content
areas and rectangular floats, already a wide variety of non-rectangular text
shapes can be realized.

在排版系统，浮动元素可以锚定到该页面，段落，或向内容流。浮动元素可以重叠内容领域和渲染内容顶部或者底部，或者他们可以强制内容在周围的流动。浮动元素的默认说明是，他们锚是不确定的（这是一个逻辑属性，而不是排版属性），和周围的文本流。需要注意的是矩形内容区域和矩形浮动属性，已经可实现各种各样非矩形文本的形状。

**Issue: there is currently no way of indicating anchoring or flow-around
properties for floating elements; properties need to be defined for this.**

**Issue: 针对浮动元素，目前还没有定义好如何来表示锚点或浮动元素流动属性，需要为这个定义属性。**

The typesetting related elements therefore are:

因此，排版相关的元素有：

* `ocr_page`
* `ocr_carea` ("ocr content area" or "body area"; used to be called ~~ocr_column~~)
* `ocr_line` [`<SPAN>`]
* (floats)
* `ocr_separator` (any separator or similar element)
* `ocr_noise` (any noise element that isn't part of typesetting)

The `ocr_page` element must be present in all hOCR documents.

所有 hOCR 文件必须包含 `ocr_page` 元素。

The following properties should be present:

以下元素必须存在：

* `bbox`
  * the bounding box of the page; for pages, the top left corner must be at
    `(0,0)`, so a typical page bounding box will look like `bbox 0 0 2300 3200`
* `image imagefile`
  * image file name used as input
  * syntactically, must be a UNIX-like pathname or http URL (no Windows pathnames)
  * may be relative
  * cannot be resolved to the actual file in general (e.g., if the hOCR file
    becomes separated from the image fiels)
  * if the hOCR file is present in a directory hierarchy or file archive, should
    resolve to the corresponding image file
* `imagemd5 checksum`
  * MD5 fingerprint of the image file that this page was derived from
  * allows re-associating pages with source images
* `ppageno n`
  * the physical page number
  * the front cover is page number 0
  * should be unique
  * must not be present unless the pages in the document have a physical ordering
  * must not be present unless it is well defined and unique
* `lpageno string`
  * the logical page number expressed on the page
  * may not be numerical (e.g., Roman numerals)
  * usually is unique
  * must not be present unless it has been recognized from the page and is unambiguous

*  BBOX
  *  叶面边框；对于页，左上角都必须位于（0,0），这样一个典型的页面边框会看起来像“BBOX 0 0 2300 3200”

*  image imagefile图像镜像文件
  *  图片文件名做输入
  *  语法，必须是一个UNIX类似的路径或HTTP URL（没有Windows路径名）
  *  可能是相关
  *  一般不能被解析为实际文件（例如，如果该hOCR文件与图像文件分开）
  *  如果hOCR文件存在于目录层次或文件归档，应解析为相应的图像文件
*  imagemd5 checksum校验
  *  这一页的来源的图像文件的MD5指纹
  *  允许重新关联的页面与源图像
*  ppageno n
  *  物理页号
  *  封面页码0
  *  应该是唯一的
  *  一定不能出现，除非该文档的页面有一个物理顺序
  *  除非它被很好地定义和唯一的，否则不能出现
*  lpageno string 
  *  页上表达上的逻辑页号
  *  未必是数字（例如，罗马数字）
  *  通常是唯一的
  *  除非它已经从页面识别并且是不含糊，否则不能存在



The following properties MAY be present:

* `scan_res x_res y_res`
  * scanning resolution in DPI
* `x_scanner string`
  * a representation of the scanner
* `x_source string`
  * an implementation-dependent representation of the document source
  * could be a URL or a /gfs/ path
  * offsets within a multipage format (e.g., TIFF) may be represented using
    additional strings or using URL parameters or fragments
  * examples
    * `x_source /gfs/cc/clean/012345678911 17`
    * `x_source http://pageserver/012345678911&page=17`

以下属性可能存在
* scan_res x_res y_res
  * 在DPI扫描分辨率
* x_scanner string
  * 扫描器的表示
* x_source string
  * 文档源的实现相关的表达式
  * 可以是一个URL或/ gfs /路径
  * 一个多格式内的偏移量（例如，TIFF）可以使用额外的字符串或使用URL参数或片段来表示
  * 例子
    * x_source / gfs / cc /clean/ 012345678911 17
    * x_source http://pageserver/012345678911&page=17


The `ocr_carea` elements should appear reading order unless this is impossible
because of some other structuring requirement If the document contains multiple
`ocr_linear` streams, then each `ocr_carea` must indicate which stream it belongs
to.

`ocr_carea` 元素应该出现阅读顺序，除非顺序不可得，因为其他一些结构要求如果文档包含多个 `ocr_linear` 流，那么每个 `ocr_carea` 必须表明它属于哪个流。

In typesetting systems, content areas are filled with “blocks”, but most of
those blocks are not recoverable or semantically meaningful. However, one type
of block is visible and very important for OCR engines: the line. Lines are
typesetting blocks that only contain glyphs (“inlines” in XSL terminology).

在排版系统，内容方面都以“块”填充，但大部分区块的无法收回的或语义含义。然而，一个类型的块是OCR引擎可见而且非常重要：行。行排版仅包含字形（XSL中的术语“内联”）模块。

They are represented by the `ocr_line` area. In addition to the standard
properties, the `ocr_line` area supports the following additional properties:

它们由 `ocr_line` 面积表示。除了标准的属性，所述 `ocr_line` 区域支持以下附加性能：

* `hardbreak n`
  * a zero (default) indicates that the end of the line is not a hard
    (explicit) line break, but a break due to text flow
  * a one indicates that the line is a hard (explicit) line break

* hardbreak n
  * 0（默认值）表示该行的结尾不是一个（hard）硬（明确的）换行，而是由于文本流中断
  * 1表示指示该行是一个硬（显式）换行


Any special characters representing the desired end-of-line processing must be
present inside the `ocr_line` element. Examples of such special characters are a
soft hyphen ("­", `U+00AD`), a hard line break (`<br>`), or whitespace (` `) for soft
line breaks.


代表所需的最终的行处理的任何特殊字符必须存在 `ocr_line` 元件内部。这样的特殊字符的例子是软连字符（hyphen）（“”,U+00AD），硬换行符（“<br>”）或空格（ ）软换行符。

Note that for many documents, the actual ground truth careas are well-defined
by the document style of the original document before printing and scanning.
From a single page, the `careas` of the original document style cannot be
recovered exactly. However, the partition of a document by `ocr_carea` for an
individual page shall be considered correct relative to ground truth if

注意，对于许多文档，打印和扫描之前，实际基准careas由原始文档的文档样式明确定义。从单一的页面，原来的文档样式的 `careas` 不能精确恢复。 然而，通过 `ocr_carea` 为单个页面文档的分区应被相对于基准来说被视为正确的，如果

1. all the text contained in a ground truth carea is fully contained within a
  single `ocr_carea`,
2. no text outside a ground truth `carea` is contained within an
  `ocr_carea`, and 
3. the `ocr_careas` appear in the same order as the text flow
  relationships between the ground truth careas.

1、单个ocr_carea完全包含基准中包含的所有文本
2、ocr_carea不会包含基准carea以外的文本
3、ocr_careas与基准careas之间的文本流的关系有相同的顺序。


The following floats are defined:

* `ocr_float`
* `ocr_separator`
* `ocr_textfloat`
* `ocr_textimage`
* `ocr_image`
* `ocr_linedrawing` – something that could be represented well and naturally in
  a vector graphics format like SVG (even if it is actually represented as PNG)
* `ocr_photo` – something that requires JPEG or PNG to be represented well
* `ocr_header`
* `ocr_footer`
* `ocr_pageno`
* `ocr_table`

Floats should not be nested.

以下是定义好的浮动属性：
* ocr_float
* ocr_separator
* ocr_textfloat
* ocr_textimage
* ocr_image
* ocr_linedrawing -可以在如SVG（即使它实际上是表示为PNG）的矢量图形格式中中很自然的表达
* ocr_photo -这需要JPEG或PNG来表示良好
* ocr_header
* ocr_footer
* ocr_pageno
* ocr_table


浮动元素不应被嵌套。



## 6 Inline Representations

There is some content that should behave and flow like text

其中有一些内容应该和文本类似

* `ocr_glyph` – an individual glyph represented as an image (e.g., an unrecognized character)
  * must contain a single `<IMG>` tag, or be present on one
* `ocr_glyphs` – multiple glyphs represented as an image (e.g., an unrecognized word)
  * must contain a single `<IMG>` tag, or be present on one
* `ocr_dropcap` – an individual glyph representing a dropcap
  * may contain text or an `<IMG>` tag; the `ALT` of the image tag should
    contain the corresponding text
* `ocr_glyphs` – a collection of glyphs represented as an image
  * must contain a single `<IMG>` tag, or be present on one
* `ocr_chem` – a chemical formula
  * must contain either a single `<IMG>` tag or ChemML markup, or be present on one
* `ocr_math` – a mathematical formula
  * must contain either a single `<IMG>` tag or MathML markup, or be present on one


* ocr_glyph –-单个字形表示为图像（例如，一个无法识别的字符）
  * 必须包含单个IMG标签，or be present on one
* ocr_glyphs –多个字形表示一个图像（例如，一个无法识别的单词）
  * 必须包含单个IMG标签，或者可以单独表达为一个
* ocr_dropcap –单个字形表示一个dropcap
  * 可能包含文本或IMG标签;图像标记的ALT应包含相应的文本
* ocr_glyphs -字形的集合，表示为一幅图像
  * 必须包含单个IMG标签，或者可以存在于一个
* ocr_chem –一个化学式
  * 必须包含一个IMG标签或ChemML标记，或出现1
* ocr_math -数学公式
  * 必须包含一个IMG标签或MathML标记，或出现1



Mathematical and chemical formulas that float must be put into an `ocr_float`
section.


数学和化学公式的浮动必须加入ocr_float部分。

Mathematical and chemical formulas that are “display” mode should be put into
an `ocr_display` section.

数学和化学公式的“显示”模式应该加入ocr_display部分。

Non-breaking spaces must be represented using the HTML `&nbsp;` entity.

非中断/换行空格必须使用HTML `&nbsp;` 实体来表示。

Soft hyphens must be represented using the HTML `&shy;` entity.

软连字符必须使用HTML `&shy;` 实体表示。

Different space widths should be indicated using HTML and `&ensp;`, `&emsp`, `&thinsp;`,
`&zwnj;`, `&zwj;`.

不同空格宽度应该使用HTML和 `&ensp;`、 `&emsp`, `&thinsp;`， `&zwnj;`， `&zwj;` 表示。


The HTML `&lrm;` and `&rlm;` entities (indicating writing direction) must not
be used; all writing direction changes must be indicated with tags.


在HTML `&lrm;` 和 `&rlm;` 实体（指示书写方向）不能再使用; 所有的书写方向变化必须用标签来表示。

Other superscripts and subscripts must be represented using the HTML `<SUP>` and
`<SUB>` tags, even if special Unicode characters are available.

其他上标和下标必须使用HTML `<SUP>` 和 `<SUB>` 标签，即使存在特殊的Unicode字符。

Furigana and similar constructs must be represented using their correct Unicode
encoding.

假名和类似的结构，必须使用其正确的Unicode编码来表示。


## 7 字符信息 Character Information

Character-level information may be put on any element that contains only a
single "line" of text; if no other layout element applies, the `ocr_cinfo`
element may be used.

字符级信息可能放在任何一个只包含一个文本“线”的元素;如果没有其他的布局元件适用，`ocr_cinfo` 元件可以如下使用


* `cuts c1 c2 c3 …`
  * character segmentation cuts (see below)
  * there must be a bbox property relative to which the cuts can be interpreted
* `nlp c1 c2 c3 …`
  * estimate of the negative log probabilities of each character by the recognizer

* cuts C1 C2 C3 ...
  * 字符片段的分割（见下文）
  * 相对于哪个分割可以被解释必须有一个bbox属性
* nlp C1 C2 C3 ...
  * 由识别程序估算每个字符的负对数概率


For left-to-write writing directions, cuts are sequences of deltas in the x and
y direction; the first delta in each path is an offset in the x direction
relative to the last x position of the previous path. The subsequent deltas
alternate between up and right moves.

对于从左到右的书写方向，分割是x和y方向的σ序列;在各路径中的首个σ是x方向相对于前一路径的最后x位置的偏移。向上和向右移动的后续增量备用。


Assume a bounding box of `(0,0,300,100)`; then

假设边界框为（0,0,300,100）;然后


````
cuts("10 11 7 19") =
    [ [(10,0),(10,100)], [(21,0),(21,100)], [(28,0),(28,100)], [(47,0),(47,100)] ]
cuts("10,50,3 11,30,-3") =
    [ [(10,0),(10,50),(13,50),(13,100)], [(21,0),(21,30),(18,30),(18,100)] ]
```

Here is an example:
这有一个例子  

```html
<span class="ocr_cinfo" title="bbox 0 0 300 100; nlp 1.7 2.3 3.9 2.7; cuts 9 11 7,8,-2 15 3">hello</span>
```


Cuts are between all codepoints contained within the element, including any
whitespace and control characters.  Simply use a delta of 0 (zero) for
invisible codepoints.

cuts是包含在元素中的所有代码点，包括任何空白和控制字符之间。 只需使用0（零）增量隐形码点。


Writing directions other than left-to-right specify cuts as if the bounding box
for the element had been rotated by a multiple of 90 degrees such that the
writing direction is left to right, then rotated back.

除了从左到右，其他书写方向指定分割，如果该元素的边界框已被旋转多个90度，使得书写方向是从左向右，需要转动回来。

It is undefined what happens when cut paths intersect, with the exception that
a delta of 0 always corresponds to an invisible codepoint.

未定义当分割路径交错时会发生什么，特例是delta 0总是对应于一个无形的代码点。

## 8 OCR 引擎的特定标记 OCR Engine-Specific Markup

A few abstractions are used as intermediate abstractions in OCR engines,
although they do not have a meaning that can be defined either in terms of
typesetting or logical function. Representing them may be useful to represent
existing OCR output, say for workflow abstractions.

一些抽象的被作为OCR引擎中间抽象，尽管按排版或逻辑函数定义他们没有具体含义。表达他们可能对于表示现有的OCR输出是有用的，说说工作流程的抽象。

Common suggested engine-specific markup are:

常见的引擎特定标记是：

* `ocrx_block`
  * any kind of "block" returned by an OCR system
  * engine-specific because the definition of a "block" depends on the engine
* `ocrx_line`
  * any kind of "line" returned by an OCR system that differs from the standard ocr_line above
  * might be some kind of "logical" line
* `ocrx_word`
  * any kind of "word" returned by an OCR system
  * engine specific because the definition of a "word" depends on the engine

* ocrx_block
  * 任何一种通过OCR系统返回的“快”
  * 引擎特有的，因为一个“块”的定义取决于引擎
* ocrx_line
  * OCR系统返回的任何形式的“line”，与上面的标准ocr_line不同
  * 可能是某种“逻辑”行
* ocrx_word
  * 任何形式的“字”通过OCR系统返回
  * 引擎特定的，因为一个“字”的定义取决于发动机


The meaning of these tags is OCR engine specific. However, generators should
attempt to ensure the following properties:

* an `ocrx_block` should not contain content from multiple ocr_careas
* the union of all `ocrx_blocks` should approximately cover all `ocr_careas`
* an `ocrx_block` should contain either a float or body text, but not both
* an `ocrx_block` should contain either an image or text, but not both
* an `ocrx_line` should correspond as closely as possible to an `ocr_line`
* `ocrx_cinfo` should nest inside `ocrx_line`
* `ocrx_cinfo` should contain only `x_conf`, `x_bboxes`, and `cuts` attributes


这些标签的含义是OCR引擎特有的。然而，发生器应当尽可能的确保以下属性：
* 一个ocrx_block不应该包含来自多个ocr_careas内容
* 所有ocrx_blocks的联合应该近似覆盖所有ocr_careas
* 一个ocrx_block应该包含一个浮动float或正文文本，但不能同时包含
* 一个ocrx_block应包含的图像或文字，但不能同时包含
* 一个ocrx_line应尽可能地对应于ocr_line
* ocrx_cinfo应该嵌套在ocrx_line里面
* ocrx_cinfo应该只包含x_conf，x_bboxes和cuts属性

The following properties are defined:

* `x_font s`
  * OCR-engine specific font names
* `x_fsize n`
  * OCR-engine specific font size
* `x_boxes b1x0 b1y0 b1x1 b1y1 b2x0 b2y0 b2x1 b2y1 …`
  * OCR-engine specific boxes associated with each codepoint contained in the
    element
  * note that the bbox property is a property for the bounding box of a layout
    element, not of individual characters
  * in particular, use `<span class="ocr_cinfo" title="x_bboxes ....">`, not
    `<span class="ocr_cinfo" title="bbox ...">`
* `x_confs c1 c2 c3 …`
  * OCR-engine specific character confidences
  * `c1` etc. must be numbers
  * higher values should express higher confidences
  * if possible, convert character confidences to values between 0 and 100 and
    have them approximate posterior probabilities (expressed in %)
* `x_wconf n`
  * OCR-engine specific confidence for the entire contained substring
  * n must be a number
  * higher values should express higher confidences
  * if possible, convert word confidences to values between 0 and 100 and have
    them approximate posterior probabilities (expressed in %)

下列属性定义如下：
* x_font s
  * OCR引擎特定的字体名称
* x_fsize n
  * OCR引擎特定的字体大小
* x_boxes b1x0 b1y0 b1x1 b1y1 b2x0 b2y0 b2x1 b2y1 ...
  * 与每个元素所包含的编码点相关联的OCR引擎特定方框
  * 注意，bbox属性是一个布局元素的边框属性，而不是单个字符
  * 尤其是，使用<span class =“ocr_cinfo” title="x_bboxes ....">，
     而不是<span class =“ocr_cinfo” title=“BBOX ...”>
* x_confs C1 C2 C3 ...
  * OCR引擎特定的字符可信度
  * C1等，必须是数字
  * 较高的值应表达较高的可信度
  * 如果可能的话，转换的字符置信度到值0和100之间，并让它们近似后验概率（以％表示）
* x_wconf n
  * 包含子串的全部的OCR引擎特定置信度
  * n必须是一个数
  * 较高的值应表达较高的可信度
  * 如果可能的话，转换字置信度到值0和100之间，并让它们近似后验概率（以％表示）

## 9 字体，文本颜色，语言，方向 Font, Text Color, Language, Direction

OCR-generated font and text color information is encoded using standard HTML
and CSS attributes on elements with a class of `ocr_...` or `ocrx_...`.
Language and writing direction should be indicated using the HTML standard
attributes `lang=` and `dir=`, or alternatively can be indicated as properties on
elements.

OCR生成的字体和文本颜色信息使用标准的HTML和CSS中带ocr _...或ocrx _类的元素属性。语言和书写方向应使用HTML标准属性lang= 和dir= 来表示，或也可以表示为元素的属性。

OCR information and presentation information can be separated by putting the
CSS info related to the CSS in an outer element with an `ocr_` or `ocrx_` class,
and then overriding it for the presentation by nesting another `<SPAN>` with the
actual presentation information inside that:

通过将相关的CSS的信息加入ocr_或ocrx_类外部元件，然后通过嵌套另一个有内部的实际显示信息的<SPAN>来超越它以达到OCR信息和表达信息的分离：

```
<span class="ocr_cinfo" style="ocr style"><span style="presentation style"> ... </span></span>
```

The CSS3 text layout attributes can be used when necessary. For example, CSS
supports writing-mode, direction, glyph-orientation [ISO-15924-based
script](http://www.unicode.org/iso15924/codelists.html), text-indent, etc.

CSS3的文本布局属性可在必要时使用。例如，CSS支持写入模式，方向，字形取向基于ISO-15924脚本，文本缩进，等等。

## 10 替代分割/读数 Alternative Segmentations / Readings

Alternative segmentations and readings are indicated by a `<SPAN>` with
`class="alternatives"`. It must contains `<INS>` and `<DEL>` elements. The first
contained element should be `<INS>` and represent the most probable interpretation,
the subsequent ones `<DEL>`. Each `<INS>` and `<DEL>` element should have `class="alt"` and a
property of either `nlp` or `x_cost`. These `<SPAN>`, `<INS>`, and `<DEL>` tags can nest
arbitrarily.

可选分割和读数通过一个class=”alternatives”的<SPAN>属性表示。它必须包含<INS>和<DEL>元素。第一个包含的元素应该是<INS>，代表最可能的解释，后续的是<DEL>。每个<INS>和<DEL>元素应该有“class= “alt”和属性“nlp”或“x_cost”。这些<SPAN>，<INS>，和<DEL>标签可以任意嵌套。

Example:

例如：

```html
<SPAN class="alternatives">
<INS class="alt" title="nlp 0.3">hello</INS>
<DEL class="alt" title="nlp 1.1">hallo</DEL>
</SPAN>
```

Whitespace within the `<SPAN>` but outside the contained `<INS>`/`<DEL>`
elements is ignored and should be inserted to improve readability of the HTML
when viewed in a browser.

在span里面但是在包含INS / DEL元素之外的空白将被忽略，但是应该被插入，以提高浏览器中查看时HTML的可读性。

## 11 组元素和多个层级 Grouped Elements and Multiple Hierarchies

The different levels of layout information (logical, physical, engine-specific)
each form hierarchies, but those hierarchies may not be mutually compatible;
for example, a single ocr_page may contain information from multiple sections
or chapters. To represent both hierarchies within a single document, elements
may be grouped together.  That is, two elements with the same class may be
treated as one element by adding a "groupid identifier" property to them and
using the same identifier. 

布局信息（逻辑，物理，引擎特有的）的不同层次每一个形成一个层次结构，但这些层次结构可能不相互兼容;例如，一个单一的ocr_page可含有多个部分或章节的信息。为了表示一个文档中两个层次结构，元素可以组合在一起。也就是说，通过增加一个“组识别符号”（grouped identifier）属性，并使用相同的标识符,使具有相同类中的两个元件被视为一个元素。


Grouped elements should be logically consistent with the markup they represent;
for example, it is probably not sensible to use grouped elements to interleave
parts of two different chapters.  Therefore, grouped elements should usually be
adjacent in the markup.

分组元素应与他们所代表的标记逻辑一致的;例如，使用分组的元素来交错两个不同的章节部分是不明智的。因此，分组元素通常应该在标记附近。

Applications using hOCR may choose to manipulate grouped elements directly, but
the simplest way of dealing with them is to transform a document with grouped
elements into one without grouped elements prior to further processing by first
removing tags that are not of interest for the subsequent processing step, and
then collapsing grouped elements into single elements.  For example, output
that contains both logical and physical layout information, where the logical
layout information uses grouped elements, can be transformed by removing all
the physical layout information, and then collapsing all split ocr_chapter
elements into single ocr_chapter elements based on the groupid.  The result is
a simple DOM tree.  This transformation can be provided generically as a
pre-processor or Javascript.

使用hOCR的应用程序/系统可以选择直接操纵分组的元素，但是处理它们的最简单的方法是 首先除去那些后续处理步骤不感兴趣的标签，将一个有分组元素的文件转换为不含分组元素文件，然后使分组元素折叠成单一的元件。例如，同时包含逻辑和物理布局信息的输出，其中逻辑布局信息使用被分组元素，可通过除去所有的物理布局信息，然后基于组折叠所有分离的ocr_chapter元素成一个单独的ocr_chapter元素。其结果是一个简单的DOM树。这种转变可以提供一般地预处理器或Javascript。

The presence of grouped elements does not need to be indicated in the header;
when it affects their operations, hOCR processors should check for the presence
of grouped elements in the output and fail with an error message if they cannot
correctly process the hOCR information.

分组元素的存在并不需要在标题中指出；当它影响他们的操作时，hOCR处理器应该检查在输出分组元素的存在和如果他们不能正确处理hOCR信息查看错误信息。

## 12 功能 Capabilities

Any program generating files in this output format must indicate in the
document metadata what kind of markup it is capable of generating. This
includes listing the exact set of markup sections that the system could have
generated, even if it did not actually generate them for the particular
document.

任何以这个输出格式的生成文件程序必须在文档元数据中指出它能够产生什么样的标记。这包括列出该系统可能产生的标记的确切集合，即使它实际上没有产生它们用于特定文档。

The capability to generate specific properties is given by the prefix `ocrp_…`;
the important properties are:

生成特定属性的能力是由前缀ocrp_ ...给出;重要的属性有：

* `ocrp_lang` – capable of generating lang= attributes
* `ocrp_dir` – capable of generating dir= attributes
* `ocrp_poly` – capable of generating polygonal bounds
* `ocrp_font` – capable of generating font information (standard font information)
* `ocrp_nlp` – capable of generating nlp confidences

* ocrp_lang -能够产生lang= attributes
* ocrp_dir -能够产生dir= attributes
* ocrp_poly -能够产生多边形界
* ocrp_font -能够产生字体信息（标准字体信息）
* ocrp_nlp -能够产生NLP置信


The capability to generate other specific embedded formats is given by the
prefix `ocr_embeddedformat_<formatname>`.

生成其他特定的嵌入式格式的能力是由前缀ocr_embeddedformat_ <FORMATNAME>给出。

If an OCR engine represents a particular tag but cannot determine reading order
for that tag, it must must specify a capability of `ocr_<tag>_unordered`.

如果OCR引擎代表一个特定的标记，但不能确定该标签读取命令，它必须指定ocr_<tag>_unordered.

If a document lists a certain capabilities but no element or attribute is found
that corresponds to that capability, users of the document may infer that the
content is absent in the source document. If a capability is not listed, the
corresponding element or attribute must not be present in the document.

如果文档列出了某些功能，但没有元素或属性是发现对应于该功能，该文件的用户可以推断该内容是在源文档中不存在。如果未列出的功能，相应的元素或属性不能出现在文档中。

## 13 配置 Profiles

hOCR provides standard means of marking up information, but it does not mandate
the presence or absence of particular kinds of information.  For example, an
hOCR file may contain only logical markup, only physical markup, or only
engine-specific markup. As a result, merely knowing that OCR output is hOCR
compliant doesn't tell us whether that file is actually useful for subsequent
processing.

hOCR提供标记了信息的标准方法，但它并不强制特定类型的信息的存在或不存在。例如，一个hOCR文件可能仅包含逻辑标记，只有物理标记，或者仅引擎特定标记。其结果是，仅仅知道OCR输出是hOCR标准并没有告诉我们，文件对于后续处理是否有用。

OCR systems can use hOCR in various different ways internally, but we will
eventually define some common profiles that mandate what kinds of information
needs to be present in particular kinds of output.

OCR系统可以在各种不同的方式使用hOCR内部，但我们最终会确定一些通用的配置文件定义在特定输出上，什么类型的信息需要存在。

Of particular importance are:

特别重要的是： 

* physical layout profile: OCR output in XHTML format with a defined set of
  common physical layout markup capabilities (page, carea, floats, line).
  Logical layout may be present as well, but the document tree structure must
  represent the physical layout structure, with logical layout elements split
  and grouped as needed.

* logical layout profile: OCR output in XHTML format with a defined set of
  common logical layout markup capabilities (linear, chapter, section,
  subsection).  Physical layout may be present as well, but the document tree
  structure must represent the logical layout structure, with logical layout
  elements split and grouped as needed.


* 物理布局配置：OCR输出XHTML格式定义的一组常见的物理布局标记功能（page，carea，floats，line）。逻辑布局也可以存在，但是文档树结构必须代表的物理布局结构，根据需要分离和组合逻辑布局元素。

* 逻辑布局简介：OCR输出XHTML格式定义的一组常见的逻辑布局标记功能（线性，章，段，分段）（linear, chapter, section, subsection）。物理布局也可能存在，但文档树结构必须代表逻辑布局结构，根据需要分离和组合逻辑布局元素。



Other possible profiles might be defined for specific engines or specific document classes:

针对特定引擎或特定的文档类型，可能定义如下配置：

* common commercial OCR output (e.g., Abbyy)
  * ocr_page
  * ocrx_block, ocrx_line, ocrx_word
  * ocrp_lang
  * ocrp_font
* book target
  * all logical structuring elements (as applicable), except ocr_linear
  * ocr_page
* newspaper target
  * all logical structuring elements (as applicable)
  * articles map on ocr_linear
  * ocr_page


* 普通商业OCR输出（例如，Abbyy）
  * ocr_page
  * ocrx_block，ocrx_line，ocrx_word
  * ocrp_lang
  * ocrp_font
* 书 target
  * 所有的逻辑结构元素（as applicable），除了ocr_linear
  * ocr_page
* 报纸target
  * 所有的逻辑结构元素（as applicable）
  * 文章地图上ocr_linear
  * ocr_page


## 14 必需的元信息 Required Meta Information

The OCR system is required to indicate the following using meta tags in the header:

要求OCR系统必须在报头中使用元标签指示以下：

* `<meta name="ocr-system" content="name version"/>`
* `<meta name="ocr-capabilities" content="capabilities"/>`
  * see the capabilities defined above

The OCR system should indicate the following information

该OCR系统应注明以下信息

* name=ocr-number-of-pages content=number-of-pages
* `<meta name="ocr-langs" content=[languages-considered-by-ocr]/>`
  * use [ISO 639-1](https://www.loc.gov/standards/iso639-2/php/code_list.php) codes
  * value may be `unknown`
* `<meta name="ocr-scripts" content=[scripts-considered-by-ocr]/>`
  * use [ISO 15924](http://www.unicode.org/iso15924/codelists.html) letter codes
  * value may be `unknown`



## 15 HTML Markup

The HTML-based markup is orthogonal to the hOCR-based markup; that is, both can
be chosen independent of one another. The only thing that needs to be
consistent between the two markups is the text contained within the tags. hOCR
and other embedded format tags can be put on HTML tags, or they can be put on
their own `<DIV>`/`<SPAN>` tags.

基于HTML的标记是垂直于基于hOCR的标记;也就是说，既可以独立使用。两个标记唯一需要保持一致的事情就是包含在标签中的文本。hOCR和其他嵌入式格式的标签可以放在HTML标签，也可以在自己的 `<DIV>` /`< SPAN>` 标签。

There are many different choices possible and reasonable for the HTML markup,
depending on the use and further processing of the document. Each such choice
must be indicated in the meta data for the document.

HTML标记有许多不同的可能和可信的选择，这取决于文件的使用和进一步的处理。每个这样的选择必须在用于文件的元数据来指示。

Many mappings derived from existing tools are quite similar, and most follow
the restrictions and recommendations below already without further
modifications.

从现有的工具衍生出许多映射都十分相似，文件适用于不通的处理和使用，大部分服从这个限制，下面建议已经没再进一步的修改。

Depending on the particular HTML markup used in the document, the document is
suitable for different kinds of processing and use. The formats have the
following intents:

根据文档中使用的特定的HTML标记，该文件是适用于不同种类的加工和使用。格式具有以下意思：

* `html_none`: straightforward equivalent of Goodoc or XDOC
* `html_ocr`: straightforward recording of commercial OCR system output
* `html_absolute`: target format for services like Google's View as HTML
* `html_xytable`: target format for layout-preserving on-screen document viewing
* `html_simpl`: target format for convenient on-line viewing and intermediate format for indexing

* html_none：相当于等价Goodoc 或者XDOC
* html_ocr：商业OCR系统输出的简单记录
* html_absolute：像谷歌的查看HTML的服务目标格式
* html_xytable：对目标格式布局保持屏幕上的文档查看
* html_simple：便捷的在线观看和中间格式进行索引目标格式


As long as a format contains the hOCR information, it can be reprocessed by
layout analysis software and converted into one of the other formats. In
particular, we envision layout analysis tools for converting any hOCR document
into `html_absolute`, `html_xytable`, and `html_simple`. Furthermore,
internally, a layout analysis system might use `html_xytable` as an
intermediate format for converting hOCR into `html_simple`.


只要一个格式包含hOCR信息，它可以通过布局分析软件进行再加工并转换成其他格式之一。特别是，我们设想布局分析工具将任何hOCR文档转换成html_absolute，html_xytable和html_simple。此外，在内部，将hOCR转换成html_simple布局分析系统可能使用html_xytable作为中间格式。

### 15.1 HTML内容的限制 Restrictions on HTML Content

To avoid problems, any use of HTML markup must follow the following rules:

为了避免出现问题，任何使用HTML标记必须遵循以下规则：

* HTML content must not use class names that conflict with any of those defined in this document (`ocr_*`)
* HTML content must not use the title= attribute on any element with an ocr_* class for any purposes other than encoding OCR-related properties as described in this document

* HTML内容不得使用与文档中定义的（“ocr_ *”）起冲突的类名
* HTML内容不得在有ocr_*类别的元素上使用title=attribute,除了文档描述的OCR相关属性编码。


### 15.2 映射的建议 Recommendations for Mappings

When possible, any mapping of logical structure onto HTML should try to follow the following rules:

如果可能的话，逻辑结构到HTML任何映射应尽量遵循以下规则：

* the mapping should be "natural" -- similar to what an author of the document
  might have entered into a WYSIWYG content creation tool
* text should be in reading order
* all tags should be used for the intended purpose (and only for the intended
  purpose) as defined in the [HTML 4 spec](https://www.w3.org/TR/html4/).
* floats are contained in `<DIV>` elements with a `style` that includes a float attribute
* repeating floating page elements (header/footer) should be repeated and occur
  in their natural location in reading order (e.g., between pages)
* embedded images and SVG should be contained in files in the same directory
  (no `/` in the URL) and embedded with `<IMG>` and `<EMBED>` tags, respectively

* 映射应该是“自然的”-类似于文档的作者可能已经进入了一个所见即所得的内容创作工具时可能得到的
* 文字应该是按读取顺序
* 所有标签应该用于期望的目的（以及仅用于期望的目的），如同HTML4规范中定义
* 浮动属性包含在包括一个浮标属性的样式的<DIV>元素中
* 重复浮动页面元素（页眉/页脚）应现以阅读顺序在它们的自然位置（例如，页面之间）重复和出现
* 嵌入图像和SVG应包含在同一个目录下的文件（在URL中没有“/”）和分别嵌入<IMG>和<EMBED>标记。


Specifically

特别地：  


* `<EM>` and `<STRONG>` should represent emphasis, and are preferred to `<B>`, `<I>`, and `<U>`
* `<B>`, `<I>`, and `<U>` should represent a change in the corresponding
  attribute for the current font (but an OCR font specification must still be
  given)
* `<P>` should represent paragraph breaks
* `<BR>` should represent explicit linebreaks (not linebreak that happen because of text flow)
* `<H1>`, …, `<H6>` should represent the logical nesting structure (if any) of the document
* `<A>` should represent hyperlinks and references within the document
* `<BLOCKQUOTE>` should represent indented quotations, but not other uses of indented text.
* `<UL>`, `<OL>`, `<DL>` should represent lists
* `<TABLE>` should represent tables, including correct use of the `<TH>` tag

* `<EM>`和`<STRONG>`应该代表强调，并首选`<B>`，`<I>`和`<U>`
* `<B>`，`<I>`和`<U>`应代表在当前字体的相应属性的变化（但仍必须被给予一个OCR字体规范）
* `<P>`应该代表分段符
* `<BR>`应该代表明确的换行（没有断行这种情况发生，因为文本流）
* `<H1>`，...，`<H6>`应该代表文档的逻辑嵌套结构（如果有的话）
* `<A>`应该表示文档中的超链接和引用
* `<BLOCKQUOTE>`应该代表缩进引用，但不能缩进的文本的其他用途。
* `<UL>`，`<OL>`，`<DL>`应代表名单lists
* `<TABLE>`应该代表表，包括正确使用<TH>标记



If necessary, the markup may use the following non-standard tags:

如果需要的话，该标记可以使用以下非标准代码：

* `<NOBR>` to indicate that line breaking is not permitted for the enclosed content
* `<WBR>` to indicate that line breaking is permitted at that location


* `<NOBR>`，表明封闭的内容不允许断行
* `<WBR>`，以表明在该位置断行被允许


#### 15.2.1 html_none

The simplest HTML markup for hOCR formats contains no logical markup at all; it
is simply a collection of `<DIV>` and `<SPAN>` elements with associated hOCR
information. Note that such documents can still be rendered visually through
the use of CSS.

对于hOCR格式最简单的HTML标记根本不包含逻辑标记;它只是具有相关hOCR信息的<DIV>和<SPAN>元素的集合。请注意，这些文件仍然可以直观地通过使用CSS渲染。

#### 15.2.2 html_simple

This is a format that follows the restrictions and recommendations above, and only uses the following tags:

这是遵循上面的限制和建议的格式，和仅使用以下标记：

* `<H1>` … `<H6>`
* `<P>`, `<BR>`
* `<B>`, `<I>`, and `<U>` for appearance changes (bold, italic, underline)
* `<FONT>` for any other appearance changes
* `<A>`
* `<DIV>` with a float style for floats
* `<TABLE>` for tables
* `<IMG>` for images
* all SVG must be externally embedded with the `<EMBED>` tag
* the use of other embedded formats is permitted
* all other uses of `<DIV>`, `<SPAN>`, `<INS>`, and `<DEL>` only for hOCR tags or other embedded formats (hCard, …)

* `<H1>` ... `<H6>`
* `<P>`，`<BR>`
* `<B>`，`<I>`和`<U>`的外观变化（粗体，斜体，下划线）
* `<FONT>`用于任何其它外观变化
* `<A>`
* `<DIV>`浮动风格
* `<TABLE>`对表
* `<IMG>`的图像
* 所有SVG必须外部嵌入的<EMBED>标签
* 允许使用其他格式的嵌入式
* 仅供hOCR标签或者嵌套格式（使用hCard，...）的所有`<DIV>`，`<SPAN>`，`<INS>`和`<DEL>`的其他用途



#### 15.2.3 html_ocr_<engine>

The HTML markup produced by default by the OCR engine for the given document.
Examples of possible values are:

对于给定的文档，由默认OCR引擎产生的HTML标记。可能的值的实例是：

* `html_ocr_finereader_8`
* `html_ocr_textbridge_11`
* `html_ocr_unknown` – the HTML was generated by some OCR engine, but it's unknown which one


#### 15.2.4 html_absolute_<element>

The HTML represents absolute positioning of elements on each page. The possible subformats are:

在HTML表示每个页面上的元素的绝对定位。可能的子格式如下：

* `html_absolute_cols` – absolute positioning of cols
* `html_absolute_pars` – absolute positioning of paragraphs
* `html_absolute_lines` – absolute positioning of lines
* `html_absolute_words` – absolute positioning of words
* `html_absolute_chars` – absolute positioning of characters

The ["View as HTML" for PDF
files](https://googlewebmastercentral.blogspot.de/2011/09/pdfs-in-google-search-results.html)
feature of Google Search uses `html_absolute_lines`; this is probably the most
reasonable choice for approximating the appearance of the original document.

* html_absolute_cols - cols的绝对定位
* html_absolute_pars -段落绝对定位
* html_absolute_lines -线条绝对定位、html_absolute_words -词语的绝对定位
* html_absolute_chars -字符绝对定位
谷歌搜索的"View as HTML" for PDF files特征使用html_absolute_lines;这可能是用于逼近原始文档的外观最合理的选择


#### 15.2.5 html_xytable_absolute

The HTML is a table that gives the XY-cut layout segmentation structure of the
page in tabular form. Note that in this format, text order does not necessarily
correspond to reading order.

HTML是一个表，以表格的形式给出了页面的XY-cut布局分割结构。请注意，在这种格式中，文本顺序并不一定对应于读取顺序。

The format must contain one `<TABLE>` of class ocr_xycut representing each page.
The `<TABLE>` structure must represent the absolute size of the original page
element. The markup of the content of the table itself is as in html_simple.

格式必须包含类的一个含有类ocr_xycut的<table>代表每个页面。表结构必须代表原始网页元素的绝对尺寸。表本身的内容的标记类似html_simple。

#### 15.2.6 html_xytable_relative

The page representation is as in
[`html_xytable_absolute`](#1525-html_xytable_absolute), but table element sizes
are expressed relative (percentages).

该页面表示类似 [`html_xytable_absolute`](#1525-html_xytable_absolute)，但表中的单元尺寸表现为相对百分比。

#### 15.2.7 html_<processor>

The HTML represents markup that follows the mappings of the given document
processor to HTML. Note that the document doesn't actually need to have been
constructed in the processor and that the processor doesn't need to have been
used to generate the HTML. For example, the `html_latex2html` tag merely
indicates that, say, a scanned and ocr'ed article uses the same conventions for
logical markup tags that an equivalent article actually written in LaTeX and
actually converted to HTML would have used. Possible subformats are:

该HTML标记代表下面的给定的文档处理HTML的映射。注意，该文件实际上并不需要由处理器构造和该处理器不需要用于生成HTML。例如，html_latex2html标签仅仅表明，比方说，一个扫描件和ocr'ed文章对于逻辑标记标签使用相同的约定，等效文章实际写入LaTeX文章和实际上转换为HTML需使用的逻辑标记。可能的子格式是：


* `html_latex2html`
* `html_msword` – HTML mapping generated by “Save As HTML”
* `html_ooffice` – HTML mapping generated by “Save As HTML”
* `html_docbook_xsl` – HTML mapping generated by official XSL style sheets


## 16 文件元信息 Document Meta Information

For document meta information, use the [Dublin Core Embedding into
HTML](http://dublincore.org/documents/dcq-html/). See also [Citation Guidelines
for Dublin Core](http://dublincore.org/documents/dc-citation-guidelines/).

对于文档元数据信息，使用 [Dublin Core Embedding into
HTML](http://dublincore.org/documents/dcq-html/).。另请参见[Citation Guidelines
for Dublin Core](http://dublincore.org/documents/dc-citation-guidelines/).

## 17 用法示例 Sample Usage

See also the [hocr-tools](https://github.com/tmbdev/hocr-tools) for more samples.

更多例子请参考 [hocr-tools](https://github.com/tmbdev/hocr-tools).

The HTML format described here may seem fairly complicated and difficult to
parse, but because there are lots of tools for manipulating HTML documents,
they're actually pretty easy to manipulate. Here are some examples:

这里描述的HTML格式可能看起来相当复杂，难以解析，但因为有很多用于处理HTML文档的工具，它们实际上是很容易被操纵。 这里有些例子：

```python
import libxml2,re,os,string

# convert the HTML to XHTML (if necessary)
os.system("tidy -q -asxhtml < page.html > page.xhtml 2> /dev/null")

# parse the XML
doc = libxml2.parseFile('page.xhtml')

# search all nodes having a class of ocr_line
lines = doc.xpathEval("//*[@class='ocr_line']")

# a function for extracting the text from a node
def get_text(node):
    textnodes = node.xpathEval(".//text()")
    s = string.join([node.getContent() for node in textnodes])
    return re.sub(r'\s+',' ',s)

# a function for extracting the bbox property from a node
# note that the title= attribute on a node with an ocr_ class must
# conform with the OCR spec

def get_bbox(node):
    data = node.prop('title')
    bboxre = re.compile(r'\bbbox\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)')
    return [int(x) for x in bboxre.search(data).groups()]

# this extracts all the bounding boxes and the text they contain
# it doesn't matter what other markup the line node may contain
for line in lines:
    print get_bbox(line),get_text(line)
```

Note that the OCR markup, basic HTML markup, and semantic markup can co-exist
within the same HTML file without interfering with one another.

注意，OCR标记，基本的HTML标记，语义标记可以在相同的HTML文件中共存，而不会相互干扰。
