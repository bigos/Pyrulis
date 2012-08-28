#! /usr/bin/python


from apacheconfig import ApacheConfig 

results = ApacheConfig.parse_file('vserver.conf')
config = results[0]
all_nodes = results[1]

config.print_r()

for el in all_nodes:
    if el.section:
        print( el.name + str(el.values))
        if len(el.children) > 0:
            print('>>>')
            for x in el.children:
                print( x.name + str(x.values))
            print('<<<')

    
def my_change_values(obj, val):
    """my code for recursive changing of config values
    """
    element_id = id(obj)
    if obj.section:
        print obj.name+' ###  '+str(obj.values)
        for child in obj.children:
            child.change_values(element_id,val)
    else:
        if id(obj) == element_id:
            for x in obj.values:
                obj.values.pop()
            obj.values.append(str(val))
        else:
            print obj.name+'  '+str(obj.values)


def find(all_nodes, name):   
    for el in all_nodes:
        if el.name == name:
            
            print('!!!!!!!!!!!!!!! '+  el.name + str(el.values) )
            my_change_values(el,'eeeeeeeee rrrrr ttttt')
            config.print_r()



find(all_nodes,'Allow')
