<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version='1.0'>

  <xsl:import href="../fo.xsl"/>

  <xsl:param name="l10n.gentext.language" select="'zh_cn'"/>

  <!-- Chinese font related settings -->
  <xsl:param name="title.font.family">Arial,Calibri,sans-serif,zh_title</xsl:param>
  <xsl:param name="body.font.family">Times New Roman,Cambria,Cambria Math,serif,zh_text</xsl:param>
  <xsl:param name="sans.font.family">Arial,Calibri,sans-serif,zh_title</xsl:param>
  <xsl:param name="dingbat.font.family">Times New Roman,Cambria,Cambria Math,serif,zh_text</xsl:param>
  <xsl:param name="monospace.font.family">Courier New,monospace,zh_verbatim</xsl:param>
  <xsl:param name="symbol.font.family">Symbol,ZapfDingbats</xsl:param>

  <xsl:param name="title.fontset">Arial,Calibri,sans-serif,Symbol,ZapfDingbats,zh_title</xsl:param>
  <xsl:param name="body.fontset">Times New Roman,Cambria,Cambria Math,serif,Symbol,ZapfDingbats,zh_text</xsl:param>

  <xsl:param name="body.font.size">12</xsl:param>
  <xsl:param name="body.font.master">12</xsl:param>
  <xsl:param name="title.font.size">14</xsl:param>

  <xsl:attribute-set name="standard.para.spacing" use-attribute-sets="normal.para.spacing">
    <xsl:attribute name="text-indent">24pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template match="section/para">
    <fo:block xsl:use-attribute-sets="standard.para.spacing">
      <xsl:call-template name="anchor"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

</xsl:stylesheet>
