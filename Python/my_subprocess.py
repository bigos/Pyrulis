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
def prettify(elem):
    """Return a pretty-printed XML string for the Element.
    """
    rough_string = ElementTree.tostring(elem, 'utf-8')
    reparsed = minidom.parseString(rough_string)
    return reparsed.toprettyxml(indent="  ")


rootdir = '/home/jack/Programming/Pyrulis/Lisp'
fileList = []
fileSize = 0
folderCount = 0
# sizeCount = 0 #won't work - why?
sizeCount = os.lstat(rootdir).st_size


top = ElementTree.Element('xyz')

print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@')

def each_file(path,top):
    global sizeCount
    fname = path.split('/')[-1]
    par = ElementTree.SubElement(top,fname)
    par.text = fname
    files = os.listdir(path)
    for file in files:
        fullPath = os.path.join(path,file)
        size = os.lstat(fullPath).st_size        
        sizeCount += size
        fchild = ElementTree.SubElement(par,file)
        fchild.text = file
        print('{0} {1} {2}'.format(fullPath, size, sizeCount))
        if os.path.isdir(fullPath) == True:
            print('^ dir')
            each_file(fullPath,top)
    print('descending V V V V V '+ path)
    return top


each_file(rootdir,top)
print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ {0}'.format(sizeCount))
print ElementTree.tostring(top)
print(prettify (top))

print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ')

top = ElementTree.Element('top')

comment = ElementTree.Comment('Generated for PyMOTW')
top.append(comment)

child = ElementTree.SubElement(top, 'child')
child.text = 'This child contains text.'

child_with_tail = ElementTree.SubElement(top, 'child_with_tail')
child_with_tail.text = 'This child has regular text.'
child_with_tail.tail = 'And "tail" text.'

child_with_entity_ref = ElementTree.SubElement(top, 'child_with_entity_ref')
child_with_entity_ref.text = 'This & that'

print ElementTree.tostring(top)


print(prettify (top))





# http://docs.python.org/library/os.html?highlight=listdir#os.listdir
