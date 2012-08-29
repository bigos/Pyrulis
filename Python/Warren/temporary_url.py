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



################################################
add_temporary_url(all_nodes, top_obj, 'one-example-com.temporaryurl.com')
#remove_temporary_url(all_nodes, top_obj, url)

print("")
config.print_r()



