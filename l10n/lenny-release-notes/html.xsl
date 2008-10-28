<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
  <xsl:import
    href="http://docbook.sourceforge.net/release/xsl/current/xhtml/chunk.xsl"/>
  <xsl:param name="admon.graphics">1</xsl:param>
  <xsl:param name="chunk.section.depth">0</xsl:param>
  <xsl:param name="html.stylesheet">debian.css</xsl:param>
  <xsl:param name="section.autolabel">1</xsl:param>
  <xsl:param name="section.label.includes.component.label">1</xsl:param>
  <xsl:param name="use.id.as.filename">1</xsl:param>

  <xsl:template match="acronym">
    <xsl:variable name="acronym" select="."/>
    <xsl:variable name="title"><xsl:value-of
    select="//*/glossary/glossentry[glossterm=$acronym]/glossdef/para"/></xsl:variable>
    <acronym xmlns="http://www.w3.org/1999/xhtml">
      <xsl:choose>
        <xsl:when test="string-length($title)=0">
          <xsl:message>Warning: <xsl:value-of
          select="$acronym"/> not defined!</xsl:message>
        </xsl:when>
	<xsl:otherwise>
	  <xsl:attribute name="title">
	    <xsl:value-of select="$title"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates/>
    </acronym>
  </xsl:template>
</xsl:stylesheet>
