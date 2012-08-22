#! /usr/bin/python
    
import subprocess, os, tempfile, sys

# disk usage on mounted filesystems
output = subprocess.Popen('df -h'.split(' '), stdout=subprocess.PIPE).communicate()[0]
print ('your root partition usage:')
print (output.split("\n"))[1]
print


# disk usage in a directory
path = '/home/jack/Programming/Pyrulis'
output = subprocess.Popen(('du -sb '+path).split(' '), stdout=subprocess.PIPE).communicate()[0]
#print( "disk usage: {0} bytes".format(output.split("\t")[0]))

output = subprocess.Popen(('du -ab '+path).split(' '), stdout=subprocess.PIPE).communicate()[0]
#print (output)

#lines = output.split("\n")

from xml.etree import ElementTree
from xml.dom import minidom
import xml.dom 

def prettify(elem):
    """Return a pretty-printed XML string for the Element.
    """
    rough_string = ElementTree.tostring(elem, 'utf-8')
    reparsed = minidom.parseString(rough_string)
    return reparsed.toprettyxml(indent="  ")


rootdir = '/home/jack/Documents/Design'
fileList = []
fileSize = 0
folderCount = 0
# sizeCount = 0 #won't work - why?
sizeCount = os.lstat(rootdir).st_size


top = ElementTree.Element('FilesForWarren')

print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@')

def each_file(path, parent):
    global sizeCount
    files = os.listdir(path)
    for file in files:
        fullPath = os.path.join(path,file)
        size = os.lstat(fullPath).st_size        
        sizeCount += size
        # xml stuff
        if os.path.isdir(fullPath):
            tagname = 'Directory'
        else:
            tagname = 'File'                   
        child = ElementTree.SubElement(parent, tagname)
 
        if os.path.isdir(fullPath):
            child.attrib['directory_name'] = file
        else:
            child.text = file
            child.attrib['size'] = "{0}".format(size)
        
        #print('{0} {1} {2}'.format(fullPath, size, sizeCount))
        if os.path.isdir(fullPath):
            each_file(fullPath, child)
    


each_file(rootdir,top)
print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ {0}\n\n".format(sizeCount))
#print ElementTree.tostring(top)
print(prettify (top))

