<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

  <xsl:import href="html-import.xsl"/>

  <xsl:output method="html" encoding="utf-8" indent="yes"/>
  <xsl:param name="use.id.as.filename">1</xsl:param>

  <xsl:param name="chunker.output.indent" select="'yes'"/>

  <xsl:param name="l10n.gentext.language" select="'en'"/>

  <!--No adjustColumnWidths function available.-->
  <xsl:param name="use.extensions">1</xsl:param>
  <xsl:param name="tablecolumns.extension">1</xsl:param>
  <xsl:param name="callouts.extension">1</xsl:param>
  <xsl:param name="textinsert.extension">1</xsl:param>

</xsl:stylesheet>
