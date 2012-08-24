#! /usr/bin/python


from apacheconfig import ApacheConfig 

dt = ApacheConfig.parse_file('vserver.conf')
config = dt[0]
config.print_r()
for el in dt[1]:
    print(  el.name + str(el.values) )

