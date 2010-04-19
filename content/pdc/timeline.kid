<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 20010904//EN" 
		"http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">
<svg xmlns="http://www.w3.org/2000/svg" 
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:py="http://purl.org/kid/ns#"
		viewBox="0 0 800 450" width="800" height="450">
	<title>Timeline Experiments</title>
  	<desc></desc>
    	<defs>
			<script type="text/javascript" py:content="'var spec = %s' % open('entries.json', 'rt').read()"/>
	</defs>
	<rect x="0.5" y="0.5" width="799" height="449"
		stroke="#000" stroke-width="1" fill="#009"/>
	<g id="ticks" stroke="#69C" stroke-width="1">
	</g>
	<script type="text/javascript">
		// <![CDATA[
		svg_ns = 'http://www.w3.org/2000/svg'
		
		var page_wd = 800.0;
		var page_ht = 450.0;
		var tick_wd = 12.0;
		
		
		g_elt = document.getElementById('ticks');
		var f = page_ht / spec.entries.length;
		for (var i in spec.entries) {
			var ent = spec.entries[i];
			var e = document.createElementNS(svg_ns, 'line');
			var y = i * f + 0.5;
			e.setAttribute('x1', page_wd - tick_wd);
			e.setAttribute('y1', y);
			e.setAttribute('x2', page_wd);
			e.setAttribute('y2', y);
			g_elt.appendChild(e);
		}
		// ]]>
	</script>
</svg>

		
