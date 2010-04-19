<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
		 xmlns:rss="http://purl.org/rss/1.0/"
		 xmlns:taxo="http://purl.org/rss/1.0/modules/taxonomy/"
		 xmlns:dc="http://purl.org/dc/elements/1.1/"
		 xmlns:syn="http://purl.org/rss/1.0/modules/syndication/"
		 xmlns:admin="http://webns.net/mvcb/"
		xmlns="http://www.w3.org/1999/xhtml"
		version="1.0"
		exclude-result-prefixes="rdf rss taxo dc syn admin #default">
	<xsl:output method="xml" indent="yes"/>
	
	<xsl:template match="/rdf:RDF">
		<div id="delicious" class="linkbox">
			<xsl:apply-templates select="rss:channel"/>
			<xsl:choose>
				<xsl:when test="rss:item">
					<p>Recent links:</p>
					<ul>
						<xsl:apply-templates select="rss:item"/>
					</ul>
				</xsl:when>
				<xsl:otherwise>
					<p>Del.icio.us is having a rest right now.</p>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	
	<xsl:template match="rss:channel">
		<h3>
			<a href="{rss:link}">
				<xsl:apply-templates select="rss:title"/>
			</a>
		</h3>
	</xsl:template>
	
	<xsl:template match="rss:item">
		<xsl:variable name="short1" select="normalize-space(substring-before(rss:title, ' - '))"/>
		<xsl:variable name="short2" select="normalize-space(substring-before(rss:title, '('))"/>
		<xsl:choose>
			<xsl:when test="$short1 != '' and ($short2 = '' or string-length($short2) &gt; string-length($short1))">
				<li>
					<a href="{rss:link}" 
						title="{substring-after(rss:title, ' - ')} &#x00B6; {rss:description}">
						<xsl:value-of select="$short1"/>
					</a>
				</li>
			</xsl:when>
			<xsl:when test="$short2 != ''">
				<li>
					<a href="{rss:link}" 
						title="{substring-before(substring-after(rss:title, '('), ')')} &#x00B6; {rss:description}">
						<xsl:value-of select="$short2"/>
					</a>
				</li>
			</xsl:when>
			<xsl:otherwise>
				<li>
					<a href="{rss:link}" title="{rss:description}">
						<xsl:apply-templates select="rss:title"/>
					</a>
				</li>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
</xsl:transform>
