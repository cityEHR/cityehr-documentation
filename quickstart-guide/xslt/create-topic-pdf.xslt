<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
  xmlns:com="http://cityehr/pdf/common"
  exclude-result-prefixes="xs com ditaarch"
  version="2.0">
  
  <!--
    Generates FO code to produce a PDF from an LwDITA 'topic'.
    
    Author: Adam Retter
  -->
  
  <xsl:import href="common-pdf.xslt"/>
  
  <xsl:output encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>

  <xsl:variable name="topic-page-sequence-id" as="xs:string" select="generate-id()"/>

  <xsl:template match="/">
    <xsl:call-template name="com:fo-root">
      <xsl:with-param name="page-sequence-id" select="$topic-page-sequence-id"/>
    </xsl:call-template>
  </xsl:template>
  
  <!-- PAGE METADATA -->
  <xsl:template match="topic" mode="declarations">
    <xsl:call-template name="com:fo-declarations">
      <xsl:with-param name="title" select="title"/>
      <xsl:with-param name="authors" select="('John Chelsom', 'Stephanie Cabrera', 'Catriona Hopper', 'Jennifer Ramirez')"/>
      <xsl:with-param name="description" select="p[1]"/>
    </xsl:call-template>
  </xsl:template>
  
  <!-- PAGE HEADER -->
  <xsl:template match="topic" mode="header">
    <fo:block text-align="center" font-size="10pt">
      <fo:block border-after-style="solid" border-after-width="0.75pt">cityEHR Quick Start Guide</fo:block>
    </fo:block>
  </xsl:template>
  
  <!-- PAGE FOOTER -->
  <xsl:template match="topic" mode="footer">
    <fo:block text-align-last="justify" font-size="10pt" border-style="solid" border-width="0.75pt" display-align="center">
      <fo:block margin-left="8pt" margin-right="8pt">
        <fo:inline>cityEHR Quick Start Guide</fo:inline>
        <fo:leader leader-pattern="space"/>
        <fo:inline>Page <fo:page-number-citation ref-id="{$topic-page-sequence-id}"/> of <fo:page-number-citation-last ref-id="{$topic-page-sequence-id}"/></fo:inline>
      </fo:block>
    </fo:block>
  </xsl:template>
  
  <!-- PAGE SEQUENCE METADATA -->
  <xsl:template match="topic" mode="page-sequence-setup">
    <fo:title><xsl:value-of select="title"/></fo:title>
  </xsl:template>

  <!-- PAGE CONTENT HEADER -->
  <xsl:template match="topic" mode="body">
    <fo:block background-color="#B84747" color="#FFFFFF" font-weight="bold" font-size="14pt" display-align="center" margin-bottom="11pt">
      <fo:block margin-left="8pt"><xsl:value-of select="title"/></fo:block>
    </fo:block>
    <xsl:apply-templates select="body" mode="body"/>
  </xsl:template>
  

  <!-- PAGE CONTENT -->
  
  <xsl:template match="body" mode="body">
    <fo:block id="body">
      <xsl:apply-templates select="p" mode="body"/>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="p" mode="body">
    <fo:block space-after="4pt"> <!-- NOTE(AR): 4pt spacing after each paragraph -->
      <xsl:apply-templates select="node()" mode="body"/>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="i|em" mode="body">
    <fo:inline font-style="italic"><xsl:apply-templates select="node()" mode="body"/></fo:inline>
  </xsl:template>
  
  <xsl:template match="b|strong" mode="body">
    <fo:inline font-weight="bold"><xsl:apply-templates select="node()" mode="body"/></fo:inline>
  </xsl:template>
  
  <xsl:template match="image" mode="body">
    <fo:block>
      <fo:external-graphic src="{@href}"/>
      <xsl:apply-templates select="alt" mode="body"/>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="alt" mode="body">
    <fo:block font-size="9pt"><xsl:value-of select="."/></fo:block>
  </xsl:template>


<!--
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
-->
  
</xsl:stylesheet>