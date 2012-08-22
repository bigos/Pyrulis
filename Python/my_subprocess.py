#! /usr/bin/python
    
import subprocess, os, tempfile

# disk usage on mounted filesystems
output = subprocess.Popen('df -h'.split(' '), stdout=subprocess.PIPE).communicate()[0]
print ('your root partition usage:')
print (output.split("\n"))[1]
print


# disk usage in a directory
path = '/home/jack/Programming/Pyrulis'
output = subprocess.Popen(('du -sb '+path).split(' '), stdout=subprocess.PIPE).communicate()[0]
print( "disk usage: {0} bytes".format(output.split("\t")[0]))

output = subprocess.Popen(('du -ab '+path).split(' '), stdout=subprocess.PIPE).communicate()[0]
print ('all files: '+output)



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
