<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

  <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/html/chunk.xsl"/>

  <xsl:param name="l10n.gentext.language" select="'en'"/>

  <xsl:output method="html" encoding="utf-8" indent="yes"/>
  <xsl:param name="chunker.output.indent" select="'yes'"/>

  <xsl:param name="use.id.as.filename">1</xsl:param>
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

  <xsl:output method="html" encoding="utf-8" indent="yes"/>     <!-- html only -->
  <xsl:param name="use.id.as.filename">1</xsl:param>            <!-- html only -->
  <xsl:param name="chunk.section.depth">0</xsl:param>           <!-- html only -->
  <!-- xsl:param name="html.stylesheet">debian.css</xsl:param -->       <!-- html only -->

</xsl:stylesheet>
