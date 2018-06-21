#!/bin/python

"""While I wait for inspiration on how to get PIL to work on Mac OS X, make thumnails using PBMPlus and libjpeg"""

from subprocess import Popen, PIPE
import re
import os
import getopt, sys

jpeg_dimens_re = re.compile(r'JPEG image is (?P<w>[0-9]+)w \* (?P<h>[0-9]+)h, (?P<color_components>[0-9]+) color components, (?P<bits_per_sample>[0-9]+) bits per sample')
def file_dimens(file_name):
    spurge = Popen(['rdjpgcom', '-verbose', file_name], stdout=PIPE).communicate()[0]
    for line in spurge.split('\n'):
        m = jpeg_dimens_re.match(line)
        if m:
            w = int(m.group('w'), 10)
            h = int(m.group('h'), 10)
            return (w, h)

def thumbnail_pipeline(file_name, dimens, meet_or_slice):
    wf, hf = file_dimens(file_name)
    wt, ht = dimens

    pipeline = [['pamscale', ('-xyfit' if meet_or_slice == 'meet' else '-xyfill'), str(wt), str(ht)]]
    if meet_or_slice == 'slice':
        if wf * ht > wt * hf:
            # Input is wider than thumbnail.
            ws, hs = wf * ht / hf, ht
            x, y = (ws - wt) / 2, 0
        else:
            ws, hs = wt, hf * wt / wf
            x, y = 0, (hs - ht) / 2
        pipeline.append(['pnmcut', str(x), str(y), str(wt), str(ht)])
    return pipeline

def thumbnail_file_name(file_name, dir_name, dimens, meet_or_slice):
    (w, h) = dimens
    if meet_or_slice == 'overlap':
        s = '%dh' % h if w <= 1 else '%dw' % w if h <= 1 else 'l%d' % w if w == h else 'l%dx%d' % (w, h)
    else:
        p = '' if meet_or_slice == 'meet' else meet_or_slice[0]
        s = '%s%d' % (p, w) if w == h else '%s%dx%d' % (p, w, h)
    new_file = '%s-%s.jpeg' % (os.path.splitext(os.path.basename(file_name))[0],s)
    return os.path.join(dir_name, new_file)

class Usage(Exception): pass

def main(argv=None):
    if argv == None:
        argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(argv[1:], 'mslnd:', ['meet', 'slice', 'overlap', 'dry-run', 'directory='])
        except getopt.error as err:
            raise Usage(str(err))

        mood = 'meet'
        is_dry_run = False
        dir_name = None
        for opt, arg in opts:
            if opt in ['-m', '--meet']:
                mood = 'meet'
            elif opt in ['-s', '--slice']:
                mood = 'slice'
            elif opt in ['-l', '--overlap']:
                mood = 'overlap'
            elif opt in ['-n', '--dry-run']:
                is_dry_run = True
            elif opt in ['-d', '--directory']:
                dir_name = arg

        w, h = args[:2]
        width = int(w, 10)
        height = int(h, 10)

        for file_name in args[2:]:
            print(file_name, '...', end=' ', file=sys.stderr)

            pipeline = [['djpeg', file_name]] + thumbnail_pipeline(file_name, (width, height), mood)

            if dir_name:
                out_file = thumbnail_file_name(file_name, dir_name, (width, height), mood)
                pipeline.append(['cjpeg', '-optimize', '-outfile', out_file])
                print(out_file, end=' ', file=sys.stderr)

            if is_dry_run:
                print(" \\\n | ".join(" ".join(cmd) for cmd in pipeline))
            else:
                last_process = None
                for cmd in pipeline:
                    if last_process:
                        last_process = Popen(cmd, stdin=last_process.stdout, stdout=PIPE)
                    else:
                        last_process = Popen(cmd, stdout=PIPE)
                out, err = last_process.communicate()

                if err:
                    print(err, file=sys.stderr)
                sys.stdout.write(out)
                sys.stdout.flush()
            print(file=sys.stderr)

    except Usage as err:
        return str(err)
    return 0

if __name__ == '__main__':
    sys.exit(main())

