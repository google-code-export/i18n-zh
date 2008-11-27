<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

  <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/fo/docbook.xsl"/>

  <xsl:param name="l10n.gentext.language" select="'zh_cn'"/>

  <xsl:param name="draft.mode" select="no"/>

  <xsl:param name="use.extensions">1</xsl:param>
  <xsl:param name="callouts.extension">1</xsl:param>
  <xsl:param name="linenumbering.extension">1</xsl:param>
  <xsl:param name="tablecolumns.extension">1</xsl:param>
  <xsl:param name="textinsert.extension">1</xsl:param>

  <xsl:param name="admon.graphics" select="1" />
  <xsl:param name="admon.graphics.extension">.png</xsl:param>
  <xsl:param name="callout.graphics" select="1" />
  <xsl:param name="callout.graphics.extension">.png</xsl:param>

  <xsl:param name="section.autolabel" select="1" />
  <xsl:param name="section.label.includes.component.label">1</xsl:param>

  <xsl:param name="fop.extensions">0</xsl:param>                <!-- fo only -->
  <xsl:param name="fop1.extensions">1</xsl:param>               <!-- fo only -->
  <xsl:param name="variablelist.as.blocks" select="1" />        <!-- fo only -->
  <xsl:param name="hyphenate">false</xsl:param>                 <!-- fo only -->
  <xsl:param name="paper.type" select="'A4'"></xsl:param>       <!-- fo only -->

  <!-- English font related Settings -->
  <!--
  <xsl:param name="body.font.family">serif</xsl:param>
  <xsl:param name="dingbat.font.family">serif</xsl:param>
  <xsl:param name="monospace.font.family">monospace</xsl:param>
  <xsl:param name="sans.font.family">sans-serif</xsl:param>
  <xsl:param name="title.font.family">sans-serif</xsl:param>
  <xsl:param name="symbol.font.family">Symbol,ZapfDingbats</xsl:param>
  -->

  <!-- Chinese font related settings -->
  <xsl:param name="body.font.family">zh_text</xsl:param>
  <xsl:param name="dingbat.font.family">zh_text</xsl:param>
  <xsl:param name="monospace.font.family">zh_verbatim</xsl:param>
  <xsl:param name="sans.font.family">zh_title</xsl:param>
  <xsl:param name="title.font.family">zh_title</xsl:param>

  <!-- Prevent blank pages in output -->
  <xsl:template name="book.titlepage.before.verso">
  </xsl:template>
  <xsl:template name="book.titlepage.verso">
  </xsl:template>
  <xsl:template name="book.titlepage.separator">
  </xsl:template>

  <!-- Colourize links in output -->
  <xsl:attribute-set name="xref.properties">
    <xsl:attribute name="color">
      <xsl:choose>
        <xsl:when test="self::ulink">blue</xsl:when>
        <xsl:when test="self::xref">blue</xsl:when>
        <xsl:when test="self::uri">blue</xsl:when>
        <xsl:otherwise>red</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>

</xsl:stylesheet>
