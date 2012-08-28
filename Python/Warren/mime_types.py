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
        #print( el.name + str(el.values) + str(id(el) ))
        print_info(el,all_nodes)
        if len(el.children) > 0:
            print('>> children: >>')
            for x in el.children:
                #print( x.name + str(x.values) + str(id(el) ))
                print_info(x,all_nodes)
            print("\n")

lst = find(all_nodes,'Order')
for x in lst:
    print( x.name)
