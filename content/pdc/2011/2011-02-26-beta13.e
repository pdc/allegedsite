Title: Texturepacker Recipes with Parameters
Date: 2011-02-26
Topics: minecraft texturepacker
Image: ../icon-64x64.png

In my [previous entry][1], I described how [Texturepacker][] can be used
to create Beta-1.3-compatible texture packs from Beta-1.2-supporting
packs. Now I have made it possible to streamline the process by passing
packs as parameters to recipes.

Free Samples
============

Here are 3 packs I have prepared this way for people waiting for updates:

<table>
    <thead>
        <tr>
            <th>Pack and home page</th>
            <th>Ersatz Beta-1.3 version</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><a href="http://www.eldpack.com/">Eldpack</a></td>
            <td><a href="http://static.alleged.org.uk/pdc/2011/eldpack_v3.3+beta1.3.zip">eldpack_v3.3+beta1.3.zip</a></td>
        </tr>
        <tr>
            <td><a href="http://www.minecraftforum.net/viewtopic.php?f=1021&t=46707">Frenden</a></td>
            <td><a href="http://static.alleged.org.uk/pdc/2011/Frenden6_1a+beta1.3.zip">Frenden6_1a+beta1.3.zip</a></td>
        </tr>
        <tr>
            <td><a href="http://www.minecraftforum.net/viewtopic.php?f=1021&amp;t=164560">Pixelade</a></td>
            <td><a href="http://static.alleged.org.uk/pdc/2011/pixelade+beta1.3.zip">pixelade+beta1.3.zip</a></td>
        </tr>
    </tbody>
</table>

These are obviously not as good as the upcoming versions will be, but it
will enable you to carry on playing Minecraft while waiting for the real
thing to be released.

How it works
============


The new recipe starts like this:

    parameters:
      packs:
        - beta12
    label: "{{ beta12.label }} + Beta 1.3"
    desc: "{{ beta12.desc }}"
    … rest as before …

I can now use this recipe as follows:

    maketexture -v --output=pixelade+beta1.3.zip \
        examples/beta-1.3.tprx  \
        beta12=http://dl.dropbox.com/u/3890564/pixelade.zip

This identifies the [Pixelade pack][2] using its download URL. This is
downloaded and its `pack.txt` used to supply parts of the label and desc
fields of the new pack. The result is [pixelade+beta1.3.zip][3].

Er, this will not make much sense until I get the recipe syntax for
Texturepacker documented. In the meantime use the links above and enjoy!

 [1]: 02/26.html
 [2]: http://www.minecraftforum.net/viewtopic.php?f=1021&t=164560
 [3]: http://static.alleged.org.uk/pdc/2011/pixelade+beta1.3.zip
 [Texturepacker]: http://pdc.github.com/texturepacker/
