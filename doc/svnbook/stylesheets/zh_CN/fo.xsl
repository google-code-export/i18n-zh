<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

  <xsl:import href="../fo.xsl"/>

  <xsl:param name="l10n.gentext.language" select="'zh_cn'"/>

  <!-- Chinese font related settings -->
  <xsl:param name="body.font.family">zh_text</xsl:param>
  <xsl:param name="dingbat.font.family">zh_text</xsl:param>
  <xsl:param name="monospace.font.family">zh_verbatim</xsl:param>
  <xsl:param name="sans.font.family">zh_title</xsl:param>
  <xsl:param name="title.font.family">zh_title</xsl:param>

</xsl:stylesheet>
