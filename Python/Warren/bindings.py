#! /usr/bin/python

from parse_apacheconfig import ApacheConfig 
from parsed_info import *

print("\n\n")
results = ApacheConfig.parse_file('vserver.conf')
config = results[0]
all_nodes = results[1]
top_obj = all_nodes[0]

config.print_r()


# http://httpd.apache.org/docs/2.2/mod/core.html#virtualhost

def set_virtual_host_address(all_nodes,address):
    for el in all_nodes:
        if el.name == 'VirtualHost':
            el.values[0] = address + ':80'

##################################################

set_virtual_host_address(all_nodes,'127.0.0.1')

config.print_r()
