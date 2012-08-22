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



fileList = []
fileSize = 0
folderCount = 0
sizeCount = 0
rootdir = '/home/jack/Programming/Pyrulis/Lisp'

print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@')
# als = 0 this won't work
als = os.lstat(rootdir).st_size
def each_file(path):
    files = os.listdir(path)
    #print(files)
    for file in files:
        ppp = os.path.join(path,file)
        ss = os.lstat(ppp).st_size
        global als
        als += ss
        print('{0} {1} {2}'.format(ppp, ss, als))
        if os.path.isdir(ppp) == True:
            try:
                each_file(ppp)
            except:
                print('-------------')

each_file(rootdir)
print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ {0}'.format(als))


##############################################
from xml.etree import ElementTree
from xml.dom import minidom

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

def prettify(elem):
    """Return a pretty-printed XML string for the Element.
    """
    rough_string = ElementTree.tostring(elem, 'utf-8')
    reparsed = minidom.parseString(rough_string)
    return reparsed.toprettyxml(indent="  ")

print(prettify (top))





# http://docs.python.org/library/os.html?highlight=listdir#os.listdir
