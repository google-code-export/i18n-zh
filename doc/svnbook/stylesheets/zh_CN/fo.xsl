<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version='1.0'>

  <xsl:import href="../fo.xsl"/>

  <xsl:param name="l10n.gentext.language" select="'zh_cn'"/>

  <!-- Chinese font related settings -->
  <xsl:param name="title.font.family">Arial,Wingdings,Symbol,ZapfDingbats,zh_title</xsl:param>
  <xsl:param name="body.font.family">Times New Roman,Wingdings,Symbol,ZapfDingbats,zh_text</xsl:param>
  <xsl:param name="sans.font.family">Arial,zh_title</xsl:param>
  <xsl:param name="dingbat.font.family">Times New Roman,zh_text</xsl:param>
  <xsl:param name="monospace.font.family">Courier New,zh_verbatim</xsl:param>
  <xsl:param name="symbol.font.family"></xsl:param>

  <xsl:param name="body.font.size">12</xsl:param>
  <xsl:param name="body.font.master">12</xsl:param>
  <xsl:param name="title.font.size">14</xsl:param>

  <xsl:attribute-set name="standard.para.spacing" use-attribute-sets="normal.para.spacing">
    <xsl:attribute name="text-indent">24pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template match="para">
    <fo:block xsl:use-attribute-sets="standard.para.spacing">
      <xsl:call-template name="anchor"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

</xsl:stylesheet>
