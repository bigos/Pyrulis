#! /usr/bin/python

from parse_apacheconfig import ApacheConfig 
from parsed_info import *

print("\n\n")
results = ApacheConfig.parse_file('vserver.conf')
config = results[0]
all_nodes = results[1]
top_obj = all_nodes[0]
#config.print_r()


