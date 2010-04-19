<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:html="http://www.w3.org/1999/xhtml"
		version="1.0"
		exclude-result-prefixes="">
	<xsl:output method="text"/>
	
	<xsl:template match="/">
		<xsl:text># Map from article title to URI on LiveJournal&#x0A;</xsl:text>
		<xsl:text># Generated with xsltproc ljToLjData.xslt livejournal-pdc.html&#x0A;&#x0A;</xsl:text>
		<xsl:text>array set ljTitleComments {&#x0A;</xsl:text>
		<xsl:apply-templates select="//html:tr[html:td/html:a]"/>
		<xsl:text>}&#x0A;</xsl:text>
	</xsl:template>
	
	<xsl:template match="html:tr">
		<xsl:variable name="uri" select="html:td[html:a]/html:a/@href"/>
		<xsl:variable name="title" select="normalize-space(html:td[html:b]/html:b)"/>
		
		<xsl:text>    </xsl:text>
		<xsl:choose>
			<xsl:when test="contains($title, ' ')">"<xsl:value-of select="$title"/>"</xsl:when>
			<xsl:otherwise><xsl:value-of select="$title"/></xsl:otherwise>
		</xsl:choose>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$uri"/>
		<xsl:text>&#x0A;</xsl:text>
	</xsl:template>
	
</xsl:transform>
