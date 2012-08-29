#! /usr/bin/python

from parse_apacheconfig import ApacheConfig 
from parsed_info import *

print("\n\n")
results = ApacheConfig.parse_file('vserver.conf')
config = results[0]
all_nodes = results[1]
top_obj = all_nodes[0]

config.print_r()

# http://httpd.apache.org/docs/2.2/ssl/ssl_howto.html#strongurl


def add_temporary_url(all_nodes, top_obj, url):
    add_directive(all_nodes,top_obj, 'ServerAlias',[url])


def remove_temporary_url(all_nodes,top_obj, url):
    for el in all_nodes:
        if el.name == 'ServerAlias' and el.values[0] == url:
            parent = find_parent_obj(all_nodes,id(el))
            parent.children.remove(el)  
            all_nodes.remove(el)

            


################################################
add_temporary_url(all_nodes, top_obj, 'one-example-com.temporaryurl.com')

remove_temporary_url(all_nodes, top_obj, 'remove-me.example.com')

print("")
config.print_r()




print("\nfound top objects")
tpo = found_top_objects(all_nodes)
for el in tpo:
    print("------------> {0} {1} ".format(el.name,str(el.values)))
