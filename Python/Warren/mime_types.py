#! /usr/bin/python

from parse_apacheconfig import ApacheConfig 
from parsed_info import *

print("\n\n")
results = ApacheConfig.parse_file('vserver.conf')
config = results[0]
all_nodes = results[1]
#config.print_r()

for el in all_nodes:
    if el.section:
        print_info(el,all_nodes)
        if len(el.children) > 0:
            print('>> children: >>')
            for x in el.children:
                print_info(x,all_nodes)
        print("\n")

print("\n\n\n")
lst = find(all_nodes,'AddType')
for x in lst:
    print( x.name, x.values)
    #my_change_values(el,'eeeeeeeee rrrrr ttttt')


#list added mime types
def list_mime_types(all_nodes):
    mime_types = []
    for el in all_nodes:
        if el.name == 'AddType':
            mime_types.append(el.values[0])
    return mime_types

def mime_type_extentions(all_nodes,mime_type):
    for el in all_nodes:
        if el.values[0] == mime_type:
            return el.values[1:]
########################################
print('found mime types: '+str(list_mime_types(all_nodes)))

mime='text/html'
print('extentions for '+mime+' : '+str(mime_type_extentions(all_nodes,mime)))

