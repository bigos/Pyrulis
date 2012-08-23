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
print( "disk usage: for{0} {1} bytes".format(path, output.split("\t")[0]))

output = subprocess.Popen(('du -ab '+path).split(' '), stdout=subprocess.PIPE).communicate()[0]
#print ("files and sizes: {0}".format(output))

#lines = output.split("\n")

########################################
from xml.etree import ElementTree
from xml.dom import minidom
import xml.dom 

def prettify(elem):
    """Return a pretty-printed XML string for the Element.
    """
    rough_string = ElementTree.tostring(elem, 'utf-8')
    reparsed = minidom.parseString(rough_string)
    return reparsed.toprettyxml(indent="  ")


def each_file(argpath,parent):
    global sizeCount
    size = os.lstat(argpath).st_size   
    argfile =  argpath.split('/')[-1]
    sizeCount += size
    #print(">>> "+argpath)
    if os.path.isdir(argpath):
        tagname = 'Directory'
    else:
        tagname = 'File'                   
    child = ElementTree.SubElement(parent, tagname)
    if os.path.isdir(argpath):
        child.attrib['name'] = argfile
    else:
        child.text = argfile
        child.attrib['size'] = "{0}".format(size)

    if os.path.isdir(argpath):
        files = os.listdir(argpath)
        for file in files:
            path = os.path.join(argpath,file)
            each_file(path,child)


rootdir = '/home/jack/Documents/Design'
sizeCount = 0
top = ElementTree.Element('MoreFilesForWarren')
# with this function I can start with sizeCount 0
each_file(rootdir,top)
print("disk usage for {0} {1} bytes\n".format(rootdir,sizeCount))
print(prettify (top))


### zip command ################
#  zip -r  myzipfile.zip ./    #
################################
