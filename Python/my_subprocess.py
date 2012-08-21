#! /usr/bin/python
    

import subprocess, os, tempfile



output = subprocess.Popen('df -h'.split(' '), stdout=subprocess.PIPE).communicate()[0]

print ('your root partition usage:')
print (output.split("\n"))[1]
print
