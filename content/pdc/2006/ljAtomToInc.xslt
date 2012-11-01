<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:atom="http://www.w3.org/2005/Atom"
		version="1.0"
		exclude-result-prefixes="atom">
	<xsl:output method="html" indent="yes"/>
	
	<xsl:template match="/">
		<div id="livejournal" class="linkbox">
			<xsl:apply-templates select="atom:feed"/>
		</div>
	</xsl:template>
	
	<xsl:template match="atom:feed">
		<h3>
			<a href="{atom:link[@rel='alternate' and @type='text/html']/@href}">
				<xsl:apply-templates select="atom:title"/>
			</a>
		</h3>
		<p>
			Latest jottings on LiveJournal:
		</p>
		<ul>
			<xsl:apply-templates select="atom:entry"/>
		</ul>
	</xsl:template>
	
	<xsl:template match="atom:entry">
		<li>
			<a href="{atom:link[@rel='alternate' and @type='text/html']/@href}"
					title="{substring(atom:published, 1, 10)}">
				<xsl:apply-templates select="atom:title"/>
			</a>
		</li>
	</xsl:template>

	
</xsl:transform>
