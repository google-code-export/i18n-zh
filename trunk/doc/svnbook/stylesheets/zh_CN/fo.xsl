<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version='1.0'>

  <xsl:import href="../fo.xsl"/>

  <xsl:param name="l10n.gentext.language" select="'zh_cn'"/>

  <!-- Chinese font related settings -->
  <xsl:param name="title.font.family">Calibri,Arial,sans-serif,zh_title</xsl:param>
  <xsl:param name="body.font.family">Cambria,Times New Roman,serif,zh_text</xsl:param>
  <xsl:param name="sans.font.family">Calibri,Arial,sans-serif,zh_title</xsl:param>
  <xsl:param name="dingbat.font.family">Cambria,Times New Roman,serif,zh_text</xsl:param>
  <xsl:param name="monospace.font.family">Courier New,monospace,zh_verbatim</xsl:param>
  <xsl:param name="symbol.font.family">OpenSymbol,Symbol,ZapfDingbats</xsl:param>

  <xsl:param name="title.fontset">Calibri,Arial,sans-serif,OpenSymbol,Symbol,ZapfDingbats,zh_title</xsl:param>
  <xsl:param name="body.fontset">Cambria,Times New Roman,serif,OpenSymbol,Symbol,ZapfDingbats,zh_text</xsl:param>

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
