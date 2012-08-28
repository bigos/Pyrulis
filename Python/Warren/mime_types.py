#! /usr/bin/python

from parse_apacheconfig import ApacheConfig 
import parsed_info

for el in all_nodes:
    if el.section:
        #print( el.name + str(el.values) + str(id(el) ))
        print_info(el)
        if len(el.children) > 0:
            print('>> children: >>')
            for x in el.children:
                #print( x.name + str(x.values) + str(id(el) ))
                print_info(x)
            print("\n")

lst = find(all_nodes,'Order')

print(str(lst))
for x in lst:
    print( x.name)
