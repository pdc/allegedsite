#!/usr/bin/env python
# encoding: utf-8
"""
testjpegsfromtiffs.py

Created by Damian Cugley on 2010-04-10.
Copyright (c) 2010 __MyCompanyName__. All rights reserved.
"""

import unittest
from jpegsfromtiffs import *
import os


class TestMungeName(unittest.TestCase):
    def setUp(self):
        pass
        
    def test_simple(self):
        self.assertEqual('andy-andy1.jpeg', munge_name('Andy', 'Andy 1'))
        
    def test_amp(self):
        self.assertEqual('andy-andykeith.jpeg', munge_name('Andy', 'Andy & Keith'))
        
    def test_list_o_pix(self):
        input_pix = list(input_file_iter())
        self.assertEqual(109, len(input_pix))
        self.assertEqual(('Andy', 'Andy & Keith', '150dpi TIFFs/Andy/Andy & Keith'), input_pix[0])
        self.assertEqual(('Winding Up', 'Leaving', '150dpi TIFFs/Winding Up/Leaving'), input_pix[-1])
        
    def test_all_names(self):
        for dir_name, file_name, file_path in input_file_iter():
            munged_name = munge_name(dir_name, file_name)
            old_file = '72dpi/%s' % munged_name.replace('.jpeg', '.jpg')
            self.assert_(os.path.exists(old_file), '%s: not found' % old_file)
                

    
if __name__ == '__main__':
    unittest.main()