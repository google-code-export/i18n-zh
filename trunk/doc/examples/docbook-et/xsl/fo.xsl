<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format"
      xmlns:rx="http://www.renderx.com/XSL/Extensions"
      version='1.0'>

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
  <xsl:param name="admon.graphics.path">images/colorsvg</xsl:param>
  <xsl:param name="admon.graphics.extension">.svg</xsl:param>
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

  <!-- titlepage settings -->
  <xsl:template name="book.titlepage">
    <fo:block>
        <fo:table table-layout="fixed" space-after.optimum="10pt" width="100%">
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell>
                        <fo:block text-align="center">
                          <fo:external-graphic src="url(figures/et-cover-logo.png)"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </fo:block>

    <fo:block text-align="center" color="#000000" margin-left="2.5cm" margin-right="1cm"
        space-before.optimum="4cm" space-after.optimum="3.0cm"
        font-family="sans-serif" font-weight="900" font-size="36pt">
      <xsl:value-of select="title"/>
    </fo:block>

    <fo:block text-align="center" color="#000000" margin-left="2.5cm" margin-right="1cm"
        space-before.optimum="4cm" space-after.optimum="5cm"
        font-family="sans-serif" font-weight="600" font-size="24pt">

      <xsl:call-template name="person.name.list">
        <xsl:with-param name="person.list" select="bookinfo/authorgroup/author"/>
      </xsl:call-template>
    </fo:block>

    <fo:block text-align="end"    color="#666D70" margin-left="2.5cm" margin-right="1cm"
        font-family="sans-serif" font-weight="normal" font-size="10pt" >
      <xsl:value-of select="bookinfo/copyright/holder"/>
    </fo:block>
  </xsl:template>

  <!-- footer settings -->
  <xsl:param name="footer.column.widths">4 1 4</xsl:param>
  <xsl:template name="footer.content">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="position" select="''"/>
    <fo:block color="#7C1C51">
      <xsl:if test="$position='left'">
      <xsl:call-template name="datetime.format">
        <xsl:with-param name="date" select="/book/bookinfo/pubdate"/>
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

  <!-- header settings -->
  <xsl:param name="header.column.widths">1 1 8</xsl:param>
  <xsl:template name="header.content">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="position" select="''"/>

    <fo:block color="#7C1C51">
      <xsl:if test="$position='right'">
         <xsl:apply-templates select="." mode="title.markup"/>
         <fo:retrieve-marker retrieve-class-name="currentSectionTitle" />
      </xsl:if>

      <xsl:choose>
        <xsl:when test="$pageclass = 'lot'">
          <xsl:if test="$position='left'">
             <xsl:value-of select="/book/bookinfo/title"/>
          </xsl:if>
        </xsl:when>

        <xsl:when test="$pageclass = 'body'">
          <xsl:if test="$position='left'">
             <xsl:value-of select="/book/bookinfo/title"/>
          </xsl:if>
        </xsl:when>
      </xsl:choose>

    </fo:block>
  </xsl:template>

  <!-- my page number settings -->
  <xsl:template name="page.number.format">1</xsl:template>

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

  <!-- my chapter title settings -->
  <xsl:template match="title" mode="chapter.titlepage.recto.auto.mode">
    <fo:block xsl:use-attribute-sets="chapter.titlepage.recto.style" font-size="24.8832pt" font-weight="bold" color="#7C1C51">
    <xsl:call-template name="component.title">
      <xsl:with-param name="node" select="ancestor-or-self::chapter[1]"/>
    </xsl:call-template>
    </fo:block>
  </xsl:template>

  <!-- my chapter settings -->
  <xsl:template name="my.chapter">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>

    <fo:block id="{$id}"
              xsl:use-attribute-sets="component.titlepage.properties">
      <xsl:call-template name="chapter.titlepage"/>
    </fo:block>

    <xsl:variable name="toc.params">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="contains($toc.params, 'toc')">
      <xsl:call-template name="component.toc">
        <xsl:with-param name="toc.title.p"
                        select="contains($toc.params, 'title')"/>
      </xsl:call-template>
      <xsl:call-template name="component.toc.separator"/>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- my book settings -->
  <xsl:template match="book">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>

    <xsl:variable name="preamble"
                  select="title|subtitle|titleabbrev|bookinfo|info"/>

    <xsl:variable name="content"
                  select="node()[not(self::title or self::subtitle
                              or self::titleabbrev
                              or self::info
                              or self::bookinfo)]"/>

    <xsl:variable name="titlepage-master-reference">
      <xsl:call-template name="select.pagemaster">
        <xsl:with-param name="pageclass" select="'titlepage'"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="$preamble">
      <xsl:call-template name="page.sequence">
        <xsl:with-param name="master-reference"
                        select="$titlepage-master-reference"/>
        <xsl:with-param name="content">
          <fo:block id="{$id}">
            <xsl:call-template name="book.titlepage"/>
          </fo:block>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <xsl:apply-templates select="dedication" mode="dedication"/>
    <xsl:apply-templates select="acknowledgements" mode="acknowledgements"/>

    <xsl:call-template name="make.book.tocs"/>

    <fo:page-sequence master-reference="body" language="en" format="1" force-page-count="no-force" hyphenate="true" hyphenation-character="-" hyphenation-push-character-count="2" hyphenation-remain-character-count="2">


        <xsl:for-each select="chapter">
          <xsl:apply-templates select="." mode="running.head.mode">
            <xsl:with-param name="master-reference" select="body"/>
          </xsl:apply-templates>

          <xsl:apply-templates select="." mode="running.foot.mode">
            <xsl:with-param name="master-reference" select="body"/>
          </xsl:apply-templates>

          <fo:flow flow-name="xsl-region-body">
            <xsl:call-template name="set.flow.properties">
              <xsl:with-param name="element" select="local-name(.)"/>
              <xsl:with-param name="master-reference" select="body"/>
            </xsl:call-template>

            <xsl:call-template name="my.chapter">
              <xsl:with-param name="pageclass" select="body"/>
            </xsl:call-template>
          </fo:flow>
        </xsl:for-each>

    </fo:page-sequence>
  </xsl:template>
</xsl:stylesheet>
