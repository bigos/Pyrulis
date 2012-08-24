#! /usr/bin/python


from apacheconfig import ApacheConfig 

dt = ApacheConfig.parse_file('vserver.conf')
config = dt[0]
all_nodes = dt[1]

config.print_r()

for el in all_nodes:
    print(  el.name + str(el.values) )
    

def find(all_nodes, name):    
    for el in all_nodes:
        if el.name == name:
            print('!!!!!!!!!!!!!!! '+  el.name + str(el.values) )



find(all_nodes,'AddType')
