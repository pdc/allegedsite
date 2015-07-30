import os.path
import re
import sys


class CMap:
    '''Colour converter using a file for info.'''
    def __init__(self, file_name):
        '''Read colourmap data from file_name.'''
        self.ctr = 0
        self._map = {}
        input = open(file_name, 'r')
        for line in input.readlines():
            pos = line.find('#')
            if pos >= 0:
                line = line[:pos]
            line = line.strip()
            if line:
                es = line.split()
                if len(es) == 3:
                    bad, good, cnt = es
                    bad = bad.lower()
                    good = good.upper()
                    cnt = int(cnt)
                    if (bad not in self._map) or self._map[bad][1] < cnt:
                        self._map[bad] = (good, cnt)
        # for key, val in self._map.items():
        #     print key, '->', val[0], '(', val[1], ')'

    def mapColour(self, rrggbb):
        '''Map the proffered CSS colour, expressed as 6 hexadecimal digits.'''
        self.ctr = self.ctr + 1
        rrggbb = rrggbb.lower()
        return self._map[rrggbb][0]  # exception if colour undefined!


def backupFileAndReadAll(in_file_name, out_file_name=None):
    if not out_file_name:
        out_file_name = in_file_name

    is_backup = os.path.exists(out_file_name)

    if is_backup:
        dir, name = os.path.split(out_file_name)
        bkdir = os.path.join(dir, 'Backups')
        if os.path.exists(bkdir):
            bakfile_name = os.path.join(bkdir, name)
        else:
            bakfile_name = out_file_name + '.bak'

        input = open(out_file_name, 'rb')
        content = input.read()
        input.close()

        output = open(bakfile_name, 'wb')
        output.write(content)
        output.close()
        print 'Wrote backup to', bakfile_name

    if not is_backup or out_file_name != in_file_name:
        input = open(in_file_name, 'rb')
        content = input.read()
        input.close()

    return content


def processFile(cmap, in_file_name, out_file_name=None):
    if not out_file_name:
        out_file_name = in_file_name
    print in_file_name + ':'
    text = backupFileAndReadAll(in_file_name, out_file_name)
    colour_re = re.compile('#([a-f0-9]{6})', re.IGNORECASE)
    text = colour_re.sub(lambda m: '#' + cmap.mapColour(m.group(1)), text)
    output = open(out_file_name, 'wb')
    output.write(text)
    print 'Wrote output to', out_file_name


if __name__ == '__main__':
    # dir = 'F:\\tarot'
    dir = '.'
    for arg in sys.argv[1:]:
        b = arg
        if b[-4:] == '.svg':
            b = b[:-4]
        if b[-4:] == '-bad':
            b = b[:-4]
        if b[-3:] == '.sk':
            b = b[:-3]
        cmap = CMap(os.path.join(dir, 'tmp.cmap'))
        inFile = os.path.join(dir, b + '.sk.svg')
        outFile = os.path.join(dir, b + '.svg')
        processFile(cmap, inFile, outFile)
