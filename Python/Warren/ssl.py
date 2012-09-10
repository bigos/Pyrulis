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



################################################


remove_directive(all_nodes,top_obj,'SSLCipherSuite')

change_values(all_nodes,top_obj,'SSLEngine',['off'])

add_directive(all_nodes,top_obj,'SSLMyTest',['test'])

print("")
config.print_r()
