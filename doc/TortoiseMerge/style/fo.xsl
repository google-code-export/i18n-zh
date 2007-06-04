<xsl:stylesheet version='1.0'
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format" >

  <xsl:import href="../../../lib/docbook/docbook4-xsl/fo/docbook.xsl"/>

  <xsl:param name="l10n.gentext.language" select="'en'"/>

  <xsl:param name="paper.type" select="'A4'"></xsl:param>
  <xsl:param name="double.sided">0</xsl:param>
  <xsl:param name="headers.on.blank.pages">0</xsl:param>
  <xsl:param name="footers.on.blank.pages">0</xsl:param>

  <!-- Space between paper border and content (chaotic stuff, don't touch) -->
  <xsl:param name="page.margin.top">5mm</xsl:param>
  <xsl:param name="page.margin.bottom">0mm</xsl:param>
  <xsl:param name="page.margin.outer">10mm</xsl:param>
  <xsl:param name="page.margin.inner">10mm</xsl:param>

  <xsl:param name="title.margin.left">0pc</xsl:param>

  <!-- These extensions are required for table printing and other stuff -->
  <xsl:param name="use.extensions">1</xsl:param>
  <xsl:param name="tablecolumns.extension">0</xsl:param>
  <xsl:param name="fop.extensions">0</xsl:param>
  <xsl:param name="fop1.extensions">1</xsl:param>

  <xsl:param name="draft.mode" select="no"/>

  <!-- Font related Settings -->
  <xsl:param name="symbol.font.family" select="'Symbol,ZapfDingbats'"></xsl:param>
  <xsl:param name="body.font.family">sans-serif</xsl:param>
  <xsl:param name="dingbat.font.family">sans-serif</xsl:param>
  <xsl:param name="monospace.font.family">monospace</xsl:param>
  <xsl:param name="title.font.family">sans-serif</xsl:param>

  <!-- Default Font size -->
  <xsl:param name="body.font.master">11</xsl:param>

  <!-- Line height in body text -->
  <xsl:param name="line-height">1.4</xsl:param>

  <!-- Monospaced fonts are smaller than regular text -->
  <xsl:attribute-set name="monospace.properties">
      <xsl:attribute name="font-family">
          <xsl:value-of select="$monospace.font.family"/>
      </xsl:attribute>
      <xsl:attribute name="font-size">0.8em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:param name="variablelist.as.blocks" select="1" />

</xsl:stylesheet>
