<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
  <xsl:import
    href="http://docbook.sourceforge.net/release/xsl/current/xhtml/docbook.xsl"/>

  <!-- parameters for optimal text output -->
  <xsl:param name="callout.graphics" select="0"/>
  <xsl:param name="callout.unicode" select="0"/>
  <xsl:param name="section.autolabel" select="1"/>
  <xsl:param name="section.label.includes.component.label" select="1"/>
  <xsl:param name="generate.toc">
  appendix  title
  article/appendix  nop
  article   toc,title
  book      toc,title,figure,table,example,equation
  chapter   title
  part      toc,title
  preface   toc,title
  qandadiv  toc
  qandaset  toc
  reference toc,title
  section   toc
  set       toc,title
  </xsl:param>

  <!-- centering and aligning title elements -->
  <xsl:template match="/*/title[position()=1]" mode="titlepage.mode">
    <br/>
    <center>
      <xsl:apply-imports/>
    </center>
    <br/>
    <hr/> <!-- no underline, but at least something -->
  </xsl:template>

  <xsl:template match="author|editor" mode="titlepage.mode">
    <center>
      <xsl:apply-imports/>
    </center>
  </xsl:template>

  <xsl:template match="releaseinfo" mode="titlepage.mode">
    <center>
      <xsl:apply-imports/>
    </center>
    <hr/>
  </xsl:template>

  <!-- dirty hack to get a left margin for paragraphs etc. -->
  <xsl:template match="legalnotice/*
        |chapter/*[not(name(.)='section') and not(name(.)='title')]
        |section/*[not(name(.)='section') and not(name(.)='title')]
        |appendix/*[not(name(.)='section') and not(name(.)='title')]
	|footnote/*">
    <xsl:copy><table><tr><td>&#xa0;&#xa0;&#xa0;</td><td>
    <xsl:apply-imports/>
    </td></tr></table></xsl:copy>
  </xsl:template>

</xsl:stylesheet>
