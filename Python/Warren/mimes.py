#! /usr/bin/python


from apacheconfig import ApacheConfig 

print("\n\n")
results = ApacheConfig.parse_file('vserver.conf')
config = results[0]
all_nodes = results[1]

#config.print_r()

def find_parent(all_nodes,objid):
    for el in all_nodes:
        for child in el.children:
            if id(child) == objid:
                return id(el)

def print_info(el):
    print("zzzzzzz {0}  values: {1} id: {2} parent_id: {3}".format(el.name,str(el.values),id(el),find_parent(all_nodes,id(el))))

for el in all_nodes:
    if el.section:
        #print( el.name + str(el.values) + str(id(el) ))
        print_info(el)
        if len(el.children) > 0:
            print('>> children: >>')
            for x in el.children:
                #print( x.name + str(x.values) + str(id(el) ))
                print_info(x)
            print("\n")



    
def my_change_values(obj, val):
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
            #config.print_r()



#find(all_nodes,'Allow')
