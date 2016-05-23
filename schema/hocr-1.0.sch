<?xml version="1.0" encoding="utf-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding='xslt2'>

    <phase id="default-phase">
        <active pattern="html-checks"/>
    </phase>

    <pattern id="html-checks">
        <title>Checking basic HTML structure</title>
        <rule abstract="true" id="has-lang">
            <assert test="@lang">&lt;<name/>&gt; has no "lang" attribute</assert>
            <report test="@lang">&lt;<name/>&gt; has a "lang" attribute</report>
        </rule>
        <rule context="html">
            <extends rule="has-lang"/>
            <assert test="count(head) = 1">Exactly one &lt;head&gt;</assert>
            <report test="count(head) = 1">Exactly one &lt;head&gt;</report>
            <assert test="count(body) = 1">Exactly one &lt;body&gt;</assert>
            <report test="count(body) = 1">Exactly one &lt;body&gt;</report>
        </rule>
    </pattern>

    <pattern id="head-checks">
        <title>Checking HTML metadata</title>
        <rule context="head">
            <report test="meta[@name='ocr-id'][@content]">meta[@name=ocr-id] not empty</report>
            <assert test="meta[@name='ocr-id'][@content]">meta[@name=ocr-id] not empty</assert>
            <report test="meta[@name='ocr-recognized'][@content]">meta[@name=ocr-id] not empty</report>
            <assert test="meta[@name='ocr-recognized'][@content]">meta[@name=ocr-id] not empty</assert>
            <report test="meta[@name='ocr-system'][@content]">meta[@name=ocr-system] not empty</report>
            <assert test="meta[@name='ocr-system'][@content]">meta[@name=ocr-system] not empty</assert>
        </rule>
    </pattern>

    <pattern id="body-checks">
        <rule context="body">
            <assert test="//*[@class='ocr_page'][text()]">At least one *[@class=ocr_page]</assert>
            <report test="//*[@class='ocr_page'][text()]">At least one *[@class=ocr_page]</report>
        </rule>
    </pattern>

    <pattern id="ocr_line checks">
        <rule context="//*[@class='ocr_line']">
            <!-- <assert test="*[@class='ocr_page']::parent()">ocr_line must be in ocr_page</assert> -->
        </rule>
    </pattern>

    <pattern id="ocr_page checks">
        <rule context="//*[@class='ocr_page']">
            <assert test="@bbox">Must have 'bbox' attribute</assert>
        </rule>
    </pattern>

</schema>
