#! /usr/bin/python
    

import subprocess, os, tempfile

a = subprocess.call('ls -l /'.split(' '))

output = subprocess.Popen('ls -l /'.split(' '), stdout=subprocess.PIPE).communicate()[0]
print("\n\nresult of runing above command\n\n")
print (output)
