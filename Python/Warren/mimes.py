#! /usr/bin/python


from apacheconfig import ApacheConfig 

results = ApacheConfig.parse_file('vserver.conf')
config = results[0]
all_nodes = results[1]

config.print_r()

for el in all_nodes:
    print(  el.name + str(el.values) )
    

def find(all_nodes, name):   
    for el in all_nodes:
        if el.name == name:
            print('!!!!!!!!!!!!!!! '+  el.name + str(el.values) )
            print(id(el))
            print(dir(el))
            el.change_values(id(el),'one two three')
            config.print_r()



find(all_nodes,'AddType')
