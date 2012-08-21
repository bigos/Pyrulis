#! /usr/bin/python
    

import subprocess, os, tempfile

# disk usage on mounted filesystems
output = subprocess.Popen('df -h'.split(' '), stdout=subprocess.PIPE).communicate()[0]
print ('your root partition usage:')
print (output.split("\n"))[1]
print


path = '/home/jack/Programming/Pyrulis'

output = subprocess.Popen(('du -sb '+path).split(' '), stdout=subprocess.PIPE).communicate()[0]
print( "disk usage: {0} bytes".format(output.split("\t")[0]))
