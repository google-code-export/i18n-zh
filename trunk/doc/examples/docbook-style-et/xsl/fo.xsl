<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format"
      xmlns:rx="http://www.renderx.com/XSL/Extensions"
      xmlns:exsl="http://exslt.org/common"
      xmlns:date="http://exslt.org/dates-and-times"
      exclude-result-prefixes="exsl date"
      version='1.0'>

  <xsl:import href="../../../../lib/docbook/docbook-xsl/fo/docbook.xsl"/>

  <xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>

  <xsl:param name="l10n.gentext.language" select="'en'"/>

  <xsl:param name="paper.type" select="'A4'"></xsl:param>
  <xsl:param name="double.sided">0</xsl:param>


  <!-- These extensions are required for table printing and other stuff -->
  <xsl:param name="use.extensions">1</xsl:param>
  <xsl:param name="variablelist.as.blocks" select="1" />
  <xsl:param name="admon.textlabel" select="0" />
  <xsl:param name="admon.graphics" select="1" />
  <xsl:param name="admon.graphics.path">images/colorsvg</xsl:param>
  <xsl:param name="admon.graphics.extension">.svg</xsl:param>
  <xsl:param name="section.autolabel" select="1" />
  <xsl:attribute-set name="sidebar.properties" use-attribute-sets="formal.object.properties">
    <xsl:attribute name="border-style">solid</xsl:attribute>
    <xsl:attribute name="border-width">.1mm</xsl:attribute>
    <xsl:attribute name="background-color">#EEEEEE</xsl:attribute>
  </xsl:attribute-set>

  <!-- Consecutive page numbering
  <xsl:template name="initial.page.number">auto-odd</xsl:template>
  <xsl:template name="page.number.format">1</xsl:template>
  <xsl:template name="book.titlepage.before.verso">
  </xsl:template>
  <xsl:template name="book.titlepage.verso">
  </xsl:template>
  <xsl:template name="book.titlepage.separator">
  </xsl:template>
   -->
  <xsl:template name="book.titlepage">
    <fo:block text-align="center" color="#000000" margin-left="2.5cm" margin-right="1cm"
        space-before.optimum="7.5cm" space-after.optimum="11.0cm"
        font-family="FranklinGothic-Heavy" font-weight="normal" font-size="36pt">
      ElephantTalk Build Guide
    </fo:block>

    <fo:block text-align="center" color="#000000" margin-left="2.5cm" margin-right="1cm"
        space-before.optimum="2cm" space-after.optimum="8cm"
        font-family="FranklinGothic-Heavy" font-weight="normal" font-size="24pt">

      <xsl:call-template name="person.name.list">
        <xsl:with-param name="person.list" select="bookinfo/authorgroup/author"/>
      </xsl:call-template>
    </fo:block>

    <fo:block text-align="end"    color="#666D70" margin-left="2.5cm" margin-right="1cm"
        font-family="FranklinGothic-Book"  font-weight="normal" font-size="10pt" >
      <xsl:value-of select="bookinfo/copyright/holder"/>
    </fo:block>
  </xsl:template>

  <xsl:param name="footer.column.widths">4 1 4</xsl:param>
  <xsl:template name="footer.content">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="position" select="''"/>
    <fo:block>
      <xsl:if test="$position='left'">
      <xsl:call-template name="datetime.format">
        <xsl:with-param name="date" select="date:date-time()"/>
        <xsl:with-param name="format" select="'B Y'"/>
      </xsl:call-template>
      </xsl:if>

      <xsl:if test="$position='center'">1.0
      </xsl:if>
      <xsl:if test="$position='right'">
         <fo:page-number/>
      </xsl:if>
    </fo:block>
  </xsl:template>

  <xsl:param name="header.column.widths">4 1 4</xsl:param>
  <xsl:template name="header.content">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="position" select="''"/>

    <fo:block>
      <xsl:if test="$position='left'">
         <xsl:value-of select="/book/bookinfo/title"/>
      </xsl:if>

      <xsl:choose>
        <xsl:when test="$pageclass = 'lot'">
          <xsl:if test="$position='right'">
             Table of Contents
          </xsl:if>
        </xsl:when>

        <xsl:when test="$pageclass = 'body'">
          <xsl:if test="$position='right'">
             <xsl:apply-templates select="." mode="title.markup"/>
          </xsl:if>
        </xsl:when>
      </xsl:choose>

    </fo:block>
  </xsl:template>
</xsl:stylesheet>
