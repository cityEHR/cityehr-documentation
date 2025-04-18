<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
  xmlns:htop="http://cityehr/html/topic"
  xmlns:hcom="http://cityehr/html/common"
  xmlns:com="http://cityehr/common"
  exclude-result-prefixes="xs hcom ditaarch"
  version="2.0">
  
  <!--
    Generates a simple HTML page from an LwDITA 'topic'.
    Author: Adam Retter
  -->

  <xsl:import href="common.xslt"/>
  <xsl:import href="common-html.xslt"/>

  <xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes"/>

  <!-- PARAMETER - the version number of the generated document -->
  <xsl:param name="version" required="yes" as="xs:string"/>
  
  <!-- PARAMETER - the revision date and time of the generated document -->
  <xsl:param name="revision" required="no" as="xs:dateTime" select="current-dateTime()"/>

  <xsl:param name="petal-api-url"             as="xs:string"  required="yes"/>
  <xsl:param name="petal-github-org-name"     as="xs:string"  required="yes"/>
  <xsl:param name="petal-github-repo-name"    as="xs:string"  required="yes"/>
  <xsl:param name="petal-github-branch"       as="xs:string"  required="yes"/>
  <xsl:param name="petal-referrer-base-url"   as="xs:string"  required="yes"/>
  <xsl:param name="petal-referrer-sub-folder" as="xs:string?" required="no"/>

  <xsl:variable name="authors" as="xs:string+" select="('John Chelsom', 'Stephanie Cabrera', 'Catriona Hopper', 'Jennifer Ramirez')"/>
  
  <xsl:template match="topic">
    <html>
      <head>
        <xsl:call-template name="hcom:meta">
          <xsl:with-param name="authors" select="$authors"/>
          <xsl:with-param name="version" select="$version"/>
          <xsl:with-param name="created-dateTime" select="$revision"/>
          <xsl:with-param name="modified-dateTime" select="$revision"/>
        </xsl:call-template>
        <xsl:call-template name="hcom:style"/>
      </head>
      <body>
        <nav id="top-nav">
          <xsl:apply-templates select="." mode="top-nav"/>
        </nav>

        <!-- Petal Edit Button -->
        <div id="petal-edit-page-button">
          <a href="{htop:petal-edit-url(com:document-uri(.), $petal-api-url, $petal-github-org-name, $petal-github-repo-name, $petal-github-branch, $petal-referrer-base-url, $petal-referrer-sub-folder)}">
            <input type="button" value="Edit this page..."/>
          </a>
        </div>

        <article>
          <xsl:apply-templates select="element()" mode="body"/>
        </article>
        <nav id="bottom-nav">
          <xsl:apply-templates select="." mode="bottom-nav"/>
        </nav>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="topic" mode="top-nav bottom-nav">
    <div id="contents-link"><a href="index.html">Return to Contents...</a></div>
  </xsl:template>

  <xsl:template match="title" mode="metadata">
    <title><xsl:value-of select="."/></title>
  </xsl:template>
  
  <xsl:template match="title" mode="body">
    <h1><xsl:value-of select="."/></h1>
  </xsl:template>
  
  <xsl:template match="p|b|i|ol|ul|li" mode="body">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates mode="body"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="image[alt]" mode="body">
    <figure>
      <img src="{@href}">
        <xsl:if test="alt">
          <xsl:attribute name="alt" select="alt"/>
        </xsl:if>
        <xsl:attribute name="width" select="960"/>
      </img>
      <figcaption><xsl:value-of select="alt"/></figcaption>
    </figure>
  </xsl:template>
  
  <xsl:template match="simpletable" mode="body">
    <table style="border-collapse: collapse; width: 85%;">
      <xsl:apply-templates select="node()" mode="body"/>
    </table>
  </xsl:template>
  
  <xsl:template match="sthead" mode="body">
    <tr>
      <xsl:apply-templates select="node()" mode="table-head"/>
    </tr>
  </xsl:template>
  
  <xsl:template match="strow" mode="body">
    <tr>
      <xsl:apply-templates select="node()" mode="table-row"/>
    </tr>
  </xsl:template>
  
  <xsl:template match="stentry" mode="table-head">
    <th style="padding: 4px; border: 1px solid black; background-color: #f2f2f2;">
      <b>
        <xsl:apply-templates select="node()" mode="body"/>
      </b>
    </th>
  </xsl:template>
  
  <xsl:template match="stentry" mode="table-row">
    <td style="padding: 4px; border: 1px solid black;">
      <xsl:apply-templates select="node()" mode="body"/>
    </td>
  </xsl:template>

  <xsl:template match="image[empty(alt)]" mode="body">
    <img src="{@href}">
      <xsl:if test="alt">
        <xsl:attribute name="alt" select="alt"/>
      </xsl:if>
      <xsl:attribute name="width" select="960"/>
    </img>
  </xsl:template>

  <xsl:template match="xref" mode="body">
    <a href="{@href}">
      <xsl:apply-templates mode="body"/>
    </a>
  </xsl:template>

  <xsl:template match="section" mode="body">
    <section>
      <xsl:apply-templates select="title|p|b|i|ol|ul|li|image|section|simpletable" mode="body"/>
    </section>
  </xsl:template>

  <xsl:template match="title[parent::section/parent::body]" mode="body">
    <h2 style="color:#808080;"><xsl:value-of select="."/></h2>
  </xsl:template>

  <xsl:template match="title[parent::section/parent::section/parent::body]" mode="body">
    <h3><xsl:value-of select="."/></h3>
  </xsl:template>

  <xsl:template match="title[parent::section/parent::section/parent::section/parent::body]" mode="body">
    <h4><xsl:value-of select="."/></h4>
  </xsl:template>

  <xsl:template match="title[parent::section/parent::section/parent::section/parent::section/parent::body]" mode="body">
    <h5><xsl:value-of select="."/></h5>
  </xsl:template>

  <xsl:template match="title[parent::section/parent::section/parent::section/parent::section/parent::section/parent::body]" mode="body">
    <h6><xsl:value-of select="."/></h6>
  </xsl:template>

  <!--
    Generates an Edit button URL for Petal
  -->
  <xsl:function name="htop:petal-edit-url" as="xs:string">
    <xsl:param name="petal-source-file-uri"     as="xs:string" required="yes"/>
    <xsl:param name="petal-api-url"             as="xs:string" required="yes"/>
    <xsl:param name="petal-github-org-name"     as="xs:string" required="yes"/>
    <xsl:param name="petal-github-repo-name"    as="xs:string" required="yes"/>
    <xsl:param name="petal-github-branch"       as="xs:string" required="yes"/>
    <xsl:param name="petal-referrer-base-url"   as="xs:string" required="yes"/>
    <xsl:param name="petal-referrer-sub-folder" as="xs:string?"/>

    <xsl:variable name="petal-source-file-uri-tokens" select="tokenize($petal-source-file-uri, concat($petal-github-repo-name, '/'))" />
    <xsl:variable name="petal-source-file" select="$petal-source-file-uri-tokens[last()]" />
    <xsl:variable name="petal-webpage-filename" select="hcom:dita-filename-to-html(com:filename($petal-source-file-uri))" />
    <xsl:sequence select="concat($petal-api-url, '?ghrepo=', $petal-github-org-name, '/', $petal-github-repo-name, '&amp;source=', $petal-source-file, '&amp;branch=', $petal-github-branch, '&amp;referer=', string-join(($petal-referrer-base-url, $petal-referrer-sub-folder, $petal-webpage-filename), '/'))" />
  </xsl:function>

</xsl:stylesheet>
