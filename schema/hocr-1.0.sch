<?xml version="1.0" encoding="utf-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding='xslt2'>

    <phase id="default-phase">
        <active pattern="html-checks"/>
    </phase>

    <pattern id="html-checks">
        <title>Checking basic HTML structure</title>
        <rule context="html">
            <assert test="count(head) = 1">Exactly one &lt;head&gt;</assert>
            <report test="count(head) = 1">Exactly one &lt;head&gt;</report>
            <assert test="count(body) = 1">Exactly one &lt;body&gt;</assert>
            <report test="count(body) = 1">Exactly one &lt;body&gt;</report>
        </rule>
    </pattern>

    <pattern id="head-checks">
        <title>Checking HTML metadata</title>
        <rule context="head">
            <report test="meta[@name='ocr-id'][text()]">meta[@name=ocr-id] not empty</report>
            <report test="meta[@name='ocr-recognized'][text()]">meta[@name=ocr-id] not empty</report>
        </rule>
    </pattern>

    <pattern id="body-checks">
        <rule context="body">
            <assert test="//*[@class='ocr_page'][text()]">At least one *[@class=ocr_page]</assert>
            <report test="//*[@class='ocr_page'][text()]">At least one *[@class=ocr_page]</report>
        </rule>
    </pattern>

    <pattern id="ocr_page checks">
        <rule context="//*[@class='ocr_page']">
            <assert test="@bbox">Must have 'bbox' attribute</assert>
        </rule>
    </pattern>

</schema>
