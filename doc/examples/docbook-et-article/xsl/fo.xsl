<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version='1.0'>

  <xsl:import href="../../../../lib/docbook/docbook-xsl/fo/docbook.xsl"/>

  <xsl:param name="l10n.gentext.language" select="'en'"/>

  <xsl:param name="paper.type" select="'A4'"></xsl:param>

  <!-- These extensions are required for table printing and other stuff -->
  <xsl:param name="use.extensions">1</xsl:param>
  <xsl:param name="tablecolumns.extension">0</xsl:param>
  <xsl:param name="fop.extensions">0</xsl:param>
  <xsl:param name="fop1.extensions">1</xsl:param>

  <xsl:param name="draft.mode" select="no"/>

  <xsl:param name="variablelist.as.blocks" select="1" />
  <xsl:param name="admon.textlabel" select="0" />
  <xsl:param name="admon.graphics" select="1" />
  <xsl:param name="admon.graphics.path">images/</xsl:param>
  <xsl:param name="admon.graphics.extension">.png</xsl:param>
  <xsl:param name="section.autolabel" select="1" />
  <xsl:attribute-set name="sidebar.properties" use-attribute-sets="formal.object.properties">
    <xsl:attribute name="border-style">solid</xsl:attribute>
    <xsl:attribute name="border-width">.1mm</xsl:attribute>
    <xsl:attribute name="background-color">#EEEEEE</xsl:attribute>
  </xsl:attribute-set>

  <!-- Font related Settings -->
  <xsl:param name="title.font.family">Arial,Calibri,sans-serif,SimHei</xsl:param>
  <xsl:param name="body.font.family">Times New Roman,Cambria,Cambria Math,serif,SimSun</xsl:param>
  <xsl:param name="sans.font.family">Arial,Calibri,sans-serif,SimHei</xsl:param>
  <xsl:param name="dingbat.font.family">Times New Roman,Cambria,Cambria Math,serif,SimSun</xsl:param>
  <xsl:param name="monospace.font.family">Courier New,monospace,FangSong</xsl:param>

  <!-- toc settings -->
  <xsl:attribute-set name="toc.margin.properties">
    <xsl:attribute name="break-after">page</xsl:attribute>
    <xsl:attribute name="break-before">page</xsl:attribute>
  </xsl:attribute-set>

  <!-- titlepage settings -->
  <xsl:template name="article.titlepage">
    <fo:block margin-left="1cm" margin-right="1cm" text-align="left">
        <fo:table table-layout="fixed" space-after.optimum="10pt" width="100%">
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell>
                        <fo:block text-align="center"> <fo:external-graphic width="90%" height="auto" content-width="scale-to-fit" content-height="scale-to-fit" src="url(figures/et-cover-logo.png)"/></fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </fo:block>

    <fo:block text-align="center" color="#000000" margin-left="1cm" margin-right="1cm"
        space-before.optimum="6cm" space-after.optimum="3.0cm"
        font-family="sans-serif" font-weight="900" font-size="36pt">
      <xsl:value-of select="articleinfo/title"/>
    </fo:block>

    <fo:block text-align="center" color="#000000" margin-left="1cm" margin-right="1cm"
        space-before.optimum="4cm" space-after.optimum="4cm"
        font-family="sans-serif" font-weight="600" font-size="24pt">

      <xsl:call-template name="person.name.list">
        <xsl:with-param name="person.list" select="articleinfo/authorgroup/author"/>
      </xsl:call-template>
    </fo:block>

    <fo:block text-align="end"    color="#666D70" margin-left="1cm" margin-right="1cm"
        font-family="sans-serif" font-weight="normal" font-size="10pt" >
      <xsl:value-of select="articleinfo/copyright/holder"/>
    </fo:block>
  </xsl:template>

</xsl:stylesheet>
