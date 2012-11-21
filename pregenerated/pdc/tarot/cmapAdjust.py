import os.path
import re
import sys

class CMap:
    '''Colour converter using a file for info.'''
    def __init__(self, fileName):
        '''Read colourmap data from fileName.'''
        self.ctr = 0
        self._map = { } 
        input = open(fileName, 'r')
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
                    if (not self._map.has_key(bad)) or self._map[bad][1] < cnt:
                        self._map[bad] = (good, cnt)
        #for key, val in self._map.items():
        #    print key, '->', val[0], '(', val[1], ')'

    def mapColour(self, rrggbb):
        '''Map the proffered CSS colour, expressed as 6 hexadecimal digits.'''
        self.ctr = self.ctr + 1
        rrggbb = rrggbb.lower()
        return self._map[rrggbb][0]  # exception if colour undefined!


def backupFileAndReadAll(inFileName, outFileName=None):
    if not outFileName:
        outFileName = inFileName

    isBackUp = os.path.exists(outFileName)

    if isBackUp:
        dir, name = os.path.split(outFileName)
        bkdir = os.path.join(dir, 'Backups')
        if os.path.exists(bkdir):
            bakFileName = os.path.join(bkdir, name)
        else:
            bakFileName = outFileName + '.bak'
            
        input = open(outFileName, 'rb')
        content = input.read()
        input.close()
        
        output = open(bakFileName, 'wb')
        output.write(content)
        output.close()
        print 'Wrote backup to', bakFileName

    if not isBackUp or outFileName != inFileName:
        input = open(inFileName, 'rb')
        content = input.read()
        input.close()
        
    return content
    
def processFile(cmap, inFileName, outFileName=None):
    if not outFileName:
        outFileName = inFileName
    print inFileName + ':'
    text = backupFileAndReadAll(inFileName, outFileName)
    colourRE = re.compile('#([a-f0-9]{6})', re.IGNORECASE)
    text = colourRE.sub(lambda m: '#' + cmap.mapColour(m.group(1)), text)
    output = open(outFileName, 'wb')
    output.write(text)
    print 'Wrote output to', outFileName

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
    
