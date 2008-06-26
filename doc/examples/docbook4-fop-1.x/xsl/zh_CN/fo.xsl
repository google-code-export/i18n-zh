<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

  <xsl:import href="../fo.xsl"/>

  <xsl:param name="l10n.gentext.language" select="'zh_cn'"/>

  <xsl:param name="hyphenate">false</xsl:param>

  <!-- Font related Settings -->
  <xsl:param name="title.font.family">zh_title</xsl:param>
  <xsl:param name="body.font.family">zh_text</xsl:param>
  <xsl:param name="dingbat.font.family">zh_text</xsl:param>
  <xsl:param name="monospace.font.family">zh_verbatim</xsl:param>

</xsl:stylesheet>
