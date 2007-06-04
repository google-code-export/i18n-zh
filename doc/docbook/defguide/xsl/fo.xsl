<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

  <xsl:import href="../../../../lib/docbook/docbook5-xsl/fo/docbook.xsl"/>

  <xsl:param name="l10n.gentext.language" select="'en'"/>

  <xsl:param name="paper.type" select="'A4'"></xsl:param>

  <!-- These extensions are required for table printing and other stuff -->
  <!-- If enabled, the pdf is invalid ! -->
  <xsl:param name="use.extensions">0</xsl:param>
  <xsl:param name="fop.extensions">0</xsl:param>
  <xsl:param name="fop1.extensions">1</xsl:param>

  <!-- Don't know how to do callouts with libxslt -->
  <xsl:param name="callouts.extension">1</xsl:param>


  <xsl:param name="section.autolabel" select="1" />
  <xsl:param name="section.label.includes.component.label" select="1" />
  <xsl:param name="generate.index" select="1" />

  <xsl:param name="draft.mode" select="no"/>

  <xsl:param name="variablelist.as.blocks" select="1" />


  <!-- Prevent blank pages in output -->
  <xsl:template name="book.titlepage.before.verso">
  </xsl:template>
  <xsl:template name="book.titlepage.verso">
  </xsl:template>
  <xsl:template name="book.titlepage.separator">
  </xsl:template>

  <!-- Font related Settings -->
  <xsl:param name="body.font.family">sans-serif</xsl:param>
  <xsl:param name="dingbat.font.family">sans-serif</xsl:param>
  <xsl:param name="monospace.font.family">monospace</xsl:param>
  <xsl:param name="title.font.family">sans-serif</xsl:param>

</xsl:stylesheet>
