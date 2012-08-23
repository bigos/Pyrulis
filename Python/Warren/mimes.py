#! /usr/bin/python


from apacheconfig import ApacheConfig 

config = ApacheConfig.parse_file('vserver.conf')
config.print_r()
