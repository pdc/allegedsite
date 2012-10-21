<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:flickr="tag:alleged.org.uk,2004:flickr"
		xmlns="http://www.w3.org/2000/svg"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		version="1.0"
		exclude-result-prefixes="flickr">
	<!--
	<xsl:output method="xml" indent="no"
			doctype-public="-//W3C//DTD SVG 20010904//EN"
			doctype-system="http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"
	/>
	-->
	<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
	
	<xsl:param name="creator" select="'Damian Cugley'"/>
	<xsl:param name="uri" select="'http://www.flickr.com/photos/pdc/'"/>
	<xsl:param name="width" select="200"/>
	<xsl:param name="height" select="200"/>
	
	<xsl:param name="photo-seconds" select="60"/>
	<xsl:param name="crossfade-seconds" select="2"/>
	
	<xsl:template match="/flickr:badge">
		<svg viewBox="0 0 {$width} {$height}" width="100%" height="100%">
			<!-- 
			I would have used width="{$width}" height="{$height}" 
			but that causes spurious scrollbars in firefox 1.5
			-->
			<title>
				<xsl:value-of select="$creator"/>
				<xsl:text>&#x2019;s photos</xsl:text>
			</title>
			<desc>
				<xsl:text>Link to </xsl:text>
				<xsl:value-of select="$creator"/>
				<xsl:text>&#x2019;s photos on Flickr.com</xsl:text>
			</desc>
			<defs>
			</defs>
			<rect x="0" y="0" width="{$width}" height="{$height}"
					fill="#333" stroke="none"/>
			<a xlink:href="{$uri}" target="_parent">
				<g onclick="parent.location.href='{$uri}'; return false;">
					<xsl:apply-templates select="flickr:a/flickr:img"/>
					<image
							x="1" y="1" width="48" height="48"
							xlink:href="http://www.flickr.com/buddyicons/14145351@N00.jpg"/>
					<rect x="{$width - 50}" y="{$height - 20}" width="52" height="22" 
							rx="2" ry="2" fill="#FFF" opacity="0.75"/>
					<text
						x="{$width - 1}" y="{$height - 1}"
						font-family="Helvetica, Ariel, sans-serif"
						font-weight="700"
						font-size="20"
						text-anchor="end" stroke="none"
					>
						<tspan fill="#0063DC">flick</tspan><tspan fill="#FF0084">r</tspan>
					</text>
				</g>
			</a>
		</svg>
	</xsl:template>
	
	<xsl:template match="flickr:img">
		<xsl:variable name="i" select="count(../preceding-sibling::flickr:a)"/>
		<xsl:variable name="n" select="count(../../flickr:a)"/>
		<xsl:variable name="total-seconds"
				select="$photo-seconds + $crossfade-seconds"/>
		<xsl:variable name="photo-frac" 
				select="$photo-seconds div ($total-seconds) div $n"/>
		<xsl:variable name="crossfade-frac" 
				select="$crossfade-seconds div ($total-seconds) div $n"/>
		<image
				x="0" y="0" width="{$width}" height="{$height}"
				preserveAspectRatio="xMidYMid slice"
				xlink:href="{@src}">
			<xsl:if test="$i &gt; 0">
				<xsl:attribute name="opacity">0</xsl:attribute>
			</xsl:if>
			<animate attributeName="opacity" values="0;1;1;0;0" 
					keyTimes="0;{$crossfade-frac};{$photo-frac + $crossfade-frac};{$photo-frac + 2 * $crossfade-frac};1"
					begin="{$i * $total-seconds}s" dur="{$n * $total-seconds}" repeatCount="indefinite"/>
		</image>
	</xsl:template>
	
</xsl:transform>
