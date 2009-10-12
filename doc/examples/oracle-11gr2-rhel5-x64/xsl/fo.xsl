<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format"
      xmlns:rx="http://www.renderx.com/XSL/Extensions"
      version='1.0'>

  <!-- <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/fo/docbook.xsl"/> -->
  <xsl:import href="../../../../lib/docbook/docbook-xsl/fo/docbook.xsl"/>

  <xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>

  <xsl:param name="l10n.gentext.language" select="'en'"/>
  <xsl:param name="paper.type" select="'A4'"></xsl:param>
  <xsl:param name="draft.mode" select="no"/>

  <!-- These extensions are required for table printing and other stuff -->
  <xsl:param name="use.extensions">1</xsl:param>
  <xsl:param name="variablelist.as.blocks" select="1" />
  <xsl:param name="admon.textlabel" select="0" />
  <xsl:param name="admon.graphics" select="1" />
  <xsl:param name="admon.graphics.path">figures/</xsl:param>
  <xsl:param name="admon.graphics.extension">.png</xsl:param>
  <xsl:param name="section.autolabel" select="1" />
  <xsl:attribute-set name="sidebar.properties" use-attribute-sets="formal.object.properties">
    <xsl:attribute name="border-style">solid</xsl:attribute>
    <xsl:attribute name="border-width">.1mm</xsl:attribute>
    <xsl:attribute name="background-color">#EEEEEE</xsl:attribute>
  </xsl:attribute-set>

  <!-- Font related Settings
  <xsl:param name="title.font.family">Arial,Calibri,sans-serif,SimHei</xsl:param>
  <xsl:param name="body.font.family">Times New Roman,Cambria,Cambria Math,serif,SimSun</xsl:param>
  <xsl:param name="sans.font.family">Arial,Calibri,sans-serif,SimHei</xsl:param>
  <xsl:param name="dingbat.font.family">Times New Roman,Cambria,Cambria Math,serif,SimSun</xsl:param>
  <xsl:param name="monospace.font.family">Courier New,monospace,FangSong</xsl:param>
   -->

  <!-- Breaking long lines -->
  <xsl:param name="hyphenate.verbatim">1</xsl:param>
  <xsl:attribute-set name="monospace.verbatim.properties"
                     use-attribute-sets="verbatim.properties monospace.properties">
    <xsl:attribute name="border-color">blue</xsl:attribute>
    <xsl:attribute name="border-width">thin</xsl:attribute>
    <xsl:attribute name="border-style">solid</xsl:attribute>
    <xsl:attribute name="font-size">8pt</xsl:attribute>
    <xsl:attribute name="wrap-option">wrap</xsl:attribute>
    <xsl:attribute name="hyphenation-character">&#x27A4;</xsl:attribute>
  </xsl:attribute-set>

  <!-- toc settings -->
  <xsl:attribute-set name="toc.margin.properties">
    <xsl:attribute name="break-after">page</xsl:attribute>
    <xsl:attribute name="break-before">page</xsl:attribute>
  </xsl:attribute-set>

  <!-- titlepage settings -->
  <xsl:template name="article.titlepage">
    <fo:block>
        <fo:table table-layout="fixed" space-after.optimum="10pt" width="100%">
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell>
                        <fo:block text-align="center">
                          <fo:external-graphic src="url(figures/et-cover-logo.png)"
                              width="90%"  height="auto" content-width="scale-to-fit" content-height="scale-to-fit" />
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </fo:block>

    <fo:block text-align="center" color="#000000" margin-left="1cm" margin-right="1cm"
        space-before.optimum="6cm" space-after.optimum="10.0cm"
        font-family="sans-serif" font-weight="900" font-size="32pt">
      <xsl:value-of select="articleinfo/title"/>
    </fo:block>

    <!--fo:block text-align="center" color="#000000" margin-left="1cm" margin-right="1cm"
        space-before.optimum="5cm" space-after.optimum="5cm"
        font-family="sans-serif" font-weight="600" font-size="24pt">

      <xsl:call-template name="person.name.list">
        <xsl:with-param name="person.list" select="articleinfo/authorgroup/author"/>
      </xsl:call-template>
    </fo:block-->

    <fo:block text-align="end"    color="#666D70" margin-left="1cm" margin-right="1cm"
        font-family="sans-serif" font-weight="normal" font-size="10pt" >
      <xsl:value-of select="articleinfo/copyright/holder"/>
    </fo:block>
  </xsl:template>

  <!-- header settings -->
  <xsl:template name="header.table"/>

  <!-- footer settings -->
  <xsl:param name="footer.column.widths">4 1 4</xsl:param>
  <xsl:template name="footer.content">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="position" select="''"/>
    <fo:block color="#7C1C51">
      <xsl:if test="$position='left'">
      <xsl:call-template name="datetime.format">
        <xsl:with-param name="date" select="/article/articleinfo/pubdate"/>
        <xsl:with-param name="format" select="'B Y'"/>
      </xsl:call-template>
      </xsl:if>

      <xsl:if test="$position='center'">
        <xsl:value-of select="articleinfo/revhistory/revision[1]/revnumber"/>
      </xsl:if>
      <xsl:if test="$position='right'">
         <fo:page-number/>
      </xsl:if>
    </fo:block>
  </xsl:template>

  <!-- section title settings -->
  <xsl:template match="title" mode="section.titlepage.recto.auto.mode">
    <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" xsl:use-attribute-sets="section.titlepage.recto.style"
        margin-left="{$title.margin.left}" font-family="{$title.fontset}" color="#7C1C51">
      <xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
    </fo:block>
  </xsl:template>

  <!-- emphasis settings -->
  <xsl:template match="emphasis">
    <xsl:param name="content">
      <xsl:call-template name="simple.xlink">
        <xsl:with-param name="content">
          <xsl:apply-templates/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:param>

    <fo:inline color="#7C1C51" font-weight="bold">
      <xsl:copy-of select="$content"/>
    </fo:inline>
  </xsl:template>

  <!-- inline monospace tags settings -->
  <xsl:template name="inline.monoseq">
    <xsl:param name="content">
      <xsl:call-template name="simple.xlink">
        <xsl:with-param name="content">
          <xsl:apply-templates/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:param>

    <fo:inline xsl:use-attribute-sets="monospace.properties" color="#000080" font-weight="bold">
      <xsl:if test="@dir">
        <xsl:attribute name="direction">
          <xsl:choose>
            <xsl:when test="@dir = 'ltr' or @dir = 'lro'">ltr</xsl:when>
            <xsl:otherwise>rtl</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
      <xsl:copy-of select="$content"/>
    </fo:inline>
  </xsl:template>

  <!-- index settings (break before index) -->
  <xsl:template match="index">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>

   <xsl:if test="$generate.index != 0">
    <xsl:choose>
      <xsl:when test="$make.index.markup != 0">
        <fo:block>
          <xsl:call-template name="generate-index-markup">
            <xsl:with-param name="scope" select="(ancestor::book|/)[last()]"/>
          </xsl:call-template>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block id="{$id}" break-before="page">
          <xsl:call-template name="index.titlepage"/>
        </fo:block>
        <xsl:apply-templates/>
        <xsl:if test="count(indexentry) = 0 and count(indexdiv) = 0">
          <xsl:call-template name="generate-index">
            <xsl:with-param name="scope" select="(ancestor::book|/)[last()]"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
   </xsl:if>
  </xsl:template>

  <!-- Colourize links in output -->
  <xsl:attribute-set name="xref.properties">
    <xsl:attribute name="color">
      <xsl:choose>
        <xsl:when test="self::ulink">blue</xsl:when>
        <xsl:when test="self::xref">blue</xsl:when>
        <xsl:when test="self::uri">blue</xsl:when>
        <xsl:otherwise>red</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>

</xsl:stylesheet>
