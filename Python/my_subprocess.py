#! /usr/bin/python
    

import subprocess, os, tempfile

a = subprocess.call('ls -l /'.split(' '))

output = subprocess.Popen(["ls", "-l", "/"], stdout=subprocess.PIPE).communicate()[0]
print('result of runing above command')
print (output)
