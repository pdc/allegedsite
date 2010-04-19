Title: My Mate V-Mate?
Topics: vmate video hardware
Date: 20070310
Icon: ../icon-64x64.png

How do you get video from your old VHS tapes to your ultra-modern digital gadgets?
SanDisk’s solution is a little gadget called a [V-Mate][5]: a little box with
card-reader slots in the front and analogue TV connectors in the back.


Wires wires wires
-----

Having opened the box, I discover that it has composite video connectors (the sort with
yellow, red, and white plugs). I had to buy two SCART-to-composite adapters before I
could plug it in to our system between TiVo and the TV. When switched to stand-by or
switched off, V-Mate passes video through unaltered, behaving much like the SCART cable
it replaced. So you can leave it there perched on the AV stack, and just switch it on
when you need it.

You control the V-Mate through a dinky remote control. You can set the format to save
video in, or just say you want to save it ‘for TV or PC’ and it will record MPEG-4 at
640×480 at 25 frames/second (about 20 MB/minute, so a 1-GB card would hold 50 min). That
is actually a higher rate than my four-year-old PowerBook 12″ can play back without
stuttering in low-performance (power-saving) mode. 

You are in a twist of mazy video formats, all alike
-----


I’d like to be able to report that I recorded video using the V-Mate and played it back
on all my devices without any hassle. Instead my Nokia N800 Internet Tablet says it does
not recognize the `.mp4` file from the V-Mate. I don’t think this problem is specific to
the V-Mate; it suffers the same lack of interoperability that frustrates everyone who
tries to move video clips around.

You can also ask V-Mate for what it calls 3GP files. These limit you to a resolution of
320×240 and a frame-rate of 15 frames/second. The N800 can play back 3GP fine, so it
would seem that this is the format to use if I want to take movies with me to play back
on the N800 for some reason. It is not the format I would use if extracting clips to
edit in to a video project, because of the lower resolution. Not to mention, when I try
to play one of these files back on the Mac, the picture is blank!

After several attempts to generate video content I can play on my Nokia, I am beginning
to come to the conclusion that this is turning into a bit of a farce: I try different
variations on the export options, and nothing works in the N800. I think I need to try
to find a definitive list of video codecs it supports.

<table>
	<thead>
		<tr valign="baseline">
			<th>Format not supported</th>
			<th>Codec not supported</th>
			<th>Supported</th>
		</tr>
	</thead>
	<tbody>
		<tr valign="baseline">
			<td>
				<ul>
					<li>3GPP with H.264 from QuickTime</li>
					<li>3GPP with MPEG4 from QuickTime</li>
					<li>3GPP2 with anything</li>
					<li>MP4 from V-Mate</li>
					<li>AVI from my digital camera</li>
				</ul>
			</td>
			<td>
				<ul>
					<li>AVI with Apple Cinepak from QuickTime</li>
				</ul>
			</td>
			<td>
				<ul>
					<li>3GP with H.263 from V-Mate<sup>a</sup></li>
					<li>AVI with ‘DivX 6.0’ supplied with the N800</li>
					<li>MP4 with MPEG4 video and AAC sound from QuickTime</li>
				</ul>
			</td>
		</tr>
	</tbody>
</table>

[Nokia’s tech specs][1] say they support ‘3GP, AVI, H.263, MPEG-1, MPEG-4, RV
(Real Video)’. Of these, so far as I can tell, [3GP][2] is a file format (a container),
with MPEG-4 and H.263 being codecs used for streams in a 3GP container. QuickTime has
formats 3GPP and 3GPP2 which I believe are intended to be the same thing.

[AVI][3] is Microsoft’s container format, and can contain MPEG-4 streams, but less
efficiently than 3GP. The clip supplied with my Internet Tablet is reported by QuickTime
has having ‘DivX 6.0’ format video: from what Wikipedia says, this is a brand name for a
profile of MPEG-4 that the DivX plug-in generates. To add to the confusion, MPEG-4 can
also mean a container format (`.mp4`).

The Nokia would not play MP4 files created by the V-Mate, but I got a partial success by
loading the `.mp4` file in to QuickTime and telling it to ‘Save Movie as MPEG-4’ and to
use ‘pass-through’ for the video and audio (the result being to re-do the packaging but
to leave the actual data unchanged). This worked on the Nokia (except that it does not
have the processing power to render video at 640×480 and 30 f/s). Re-encoding at a lower
resolution and frame rate also makes an MPEG-4 file that does run on the Nokia. From
this I deduce that there is some variability in what goes in to a `.mp4`-format file,
and V-Mate’s profile does not work with Nokia’s whereas Apple’s does. When it comes to
`.3gp` files, the situation is reversed: what QuickTime calls ‘3GPP’ files don’t work,
but ‘3GP’ files from V-Mate do.

Just say ‘no’ to optional features
-----

I am not sure what to conclude at this early stage, except that people writing
specifications need to think carefully about making their specifications flexible in
ways that end up with non-interoperable implementations.   It is particularly telling that unpacking an MPEG-4 file and repacking it as an MPEG-4 file, without altering the video data itself, makes the difference between being readable by the Nokia or not. 

  [1]: http://web.nseries.com/nseries/v3/media/sections/products/tech_specs/en-R1/tech_specs_n800_en_R1.html
  [2]: http://en.wikipedia.org/wiki/3GP
  [3]: http://en.wikipedia.org/wiki/Audio_Video_Interleave
  [4]: http://en.wikipedia.org/wiki/DivX
  [5]: http://www.sandisk.com/Products/Catalog(1209)-SanDisk_VMate_Video_Memory_Card_Recorder.aspx