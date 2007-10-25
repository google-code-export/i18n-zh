<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="chm-import.xsl"/>

  <xsl:param name="base.dir" select="'htmlhelp/'"/>

  <xsl:param name="VERSION" select="1.4"/>
  <xsl:param name="htmlhelp.chm" select="'svnbook.chm'"/>

  <xsl:param name="htmlhelp.title">
    <xsl:text>Version Control with Subversion</xsl:text>
  </xsl:param>

</xsl:stylesheet>
