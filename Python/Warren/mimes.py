#! /usr/bin/python


from apacheconfig import ApacheConfig 

config = ApacheConfig.parse_file('vserver.conf')
config.print_r()

config.change_values('AddType','rb')

print('_______________________________________')

config.print_r()


print('~~~~~~~~~~~')
w = config.get_values('ErrorLog')

print("{0}         {1}".format(type(w), str(w) ))
