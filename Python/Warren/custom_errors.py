#! /usr/bin/python

from parse_apacheconfig import ApacheConfig 
from parsed_info import *

print("\n\n")
results = ApacheConfig.parse_file('vserver.conf')
config = results[0]
all_nodes = results[1]
top_obj = all_nodes[0]

config.print_r()

print("\n\n\n")
lst = find(all_nodes,'AddType')
for x in lst:
    print( x.name, x.values)
    #my_change_values(el,'eeeeeeeee rrrrr ttttt')

#parent might not be neccesary
def add_error_page(all_nodes, parent, error_code, path):
    vals=[]
    for el in all_nodes:
        if id(el) == id(parent):
            vals.append(str(error_code))
            vals.append(path)
            child = ApacheConfig('ErrorDocument', values=vals, section=False)
            el.add_child(child)

#parent might not be neccesary
def remove_error_page(all_nodes,parent, error_code):
    for el in all_nodes:
        if el.name == 'ErrorDocument':
            if el.values[0] == str(error_code):
                parent_obj = find_parent_obj(all_nodes,id(el))
                if parent_obj == parent:
                    parent.children.remove(el)

########################################################
error_code = 404
path = '/tmp/vserver1/error.html'
add_error_page(all_nodes, top_obj, error_code, path)
config.print_r()

remove_error_page(all_nodes,top_obj, 500)
config.print_r()
