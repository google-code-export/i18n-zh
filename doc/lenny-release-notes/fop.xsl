<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version='1.0'>

  <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/fo/docbook.xsl"/>

  <xsl:param name="l10n.gentext.language" select="'zh_cn'"/>

  <xsl:param name="draft.mode" select="no"/>

  <!-- These extensions are required for table printing and other stuff -->
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

  <xsl:param name="variablelist.as.blocks" select="1" />        <!-- fo only -->
  <xsl:param name="hyphenate">false</xsl:param>                 <!-- fo only -->
  <xsl:param name="paper.type" select="'A4'"></xsl:param>       <!-- fo only -->

  <!-- Default font settings -->
  <!--
  <xsl:param name="title.font.family">sans-serif</xsl:param>
  <xsl:param name="body.font.family">serif</xsl:param>
  <xsl:param name="sans.font.family">sans-serif</xsl:param>
  <xsl:param name="dingbat.font.family">serif</xsl:param>
  <xsl:param name="monospace.font.family">monospace</xsl:param>
  <xsl:param name="symbol.font.family">Symbol,ZapfDingbats</xsl:param>
  -->

  <!-- Chinese font settings - preferred truetype font -->
  <xsl:param name="title.font.family">Arial,FZCuYaSong,sans-serif,SimHei</xsl:param>
  <xsl:param name="body.font.family">Times New Roman,FZBoYaSong,serif,SimSun</xsl:param>
  <xsl:param name="sans.font.family">Arial,Calibri,sans-serif,zh_title</xsl:param>
  <xsl:param name="dingbat.font.family">Times New Roman,FZBoYaSong,serif,SimSun</xsl:param>
  <xsl:param name="monospace.font.family">Courier New,FZFangSong,monospace,FangSong</xsl:param>

  <xsl:param name="body.font.master">12</xsl:param>

  <!-- Page related Settings -->
  <xsl:param name="page.margin.inner">1.5cm</xsl:param>
  <xsl:param name="page.margin.outer">1.5cm</xsl:param>
  <xsl:param name="title.margin.left">0pt</xsl:param>
  <xsl:param name="body.start.indent">24pt</xsl:param>
  <xsl:param name="body.end.indent">0pt</xsl:param>

  <!-- Breaking long lines -->
  <xsl:param name="hyphenate.verbatim">1</xsl:param>
  <xsl:param name="hyphenate.verbatim.characters"></xsl:param>
  <xsl:attribute-set name="monospace.verbatim.properties"
                     use-attribute-sets="verbatim.properties monospace.properties">
    <xsl:attribute name="wrap-option">wrap</xsl:attribute>
    <xsl:attribute name="hyphenation-character">&#x25BA;</xsl:attribute>
  </xsl:attribute-set>

  <!-- Prevent blank pages in output -->
  <xsl:template name="book.titlepage.before.verso">
  </xsl:template>
  <xsl:template name="book.titlepage.verso">
  </xsl:template>
  <xsl:template name="book.titlepage.separator">
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

  <xsl:attribute-set name="standard.para.spacing" use-attribute-sets="normal.para.spacing">
    <xsl:attribute name="text-indent">24pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template match="abstract/para|appendix/para|chapter/para|colophon/para|legalnotice/para|preface/para|section/para|sect1/para|sect2/para">
    <fo:block xsl:use-attribute-sets="standard.para.spacing">
      <xsl:call-template name="anchor"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="section/para/*">
    <fo:wrapper text-indent="0pt">
      <xsl:apply-imports/>
    </fo:wrapper>
  </xsl:template>

</xsl:stylesheet>
