<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

  <xsl:import href="../fo.xsl"/>

  <xsl:param name="l10n.gentext.language" select="'zh_cn'"/>

  <xsl:param name="hyphenate">false</xsl:param>

  <!-- Font related Settings -->
  <xsl:param name="sans.font.family">zh_title</xsl:param>
  <xsl:param name="title.font.family">zh_title</xsl:param>
  <xsl:param name="body.font.family">zh_text</xsl:param>
  <xsl:param name="dingbat.font.family">zh_text</xsl:param>
  <xsl:param name="monospace.font.family">zh_verbatim</xsl:param>
  <xsl:param name="body.font.size">12</xsl:param>
  <xsl:param name="title.font.size">14</xsl:param>

  <!-- Page related Settings -->
  <xsl:param name="page.margin.inner">1.5cm</xsl:param>
  <xsl:param name="page.margin.outer">1.5cm</xsl:param>
  <xsl:param name="title.margin.left">0pt</xsl:param>
  <xsl:param name="body.start.indent">24pt</xsl:param>
  <xsl:param name="body.end.indent">0pt</xsl:param>

  <!-- Admonitions -->
  <xsl:param name="admon.graphics" select="1"/>

  <xsl:param name="callout.unicode.font">zh_title</xsl:param>
  <xsl:param name="callout.unicode.start.character">10102</xsl:param>

</xsl:stylesheet>
