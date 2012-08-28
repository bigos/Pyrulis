#! /usr/bin/python


from parse_apacheconfig import ApacheConfig 

print("\n\n")


def find_parent(all_nodes,objid):
    for el in all_nodes:
        for child in el.children:
            if id(child) == objid:
                return id(el)

def print_info(el,all_nodes):
    print("zzzzzzz {0}  values: {1} id: {2} parent_id: {3}".format(el.name,str(el.values),id(el),find_parent(all_nodes,id(el))))
    
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
    node_list = []
    for el in all_nodes:
        if el.name == name:
            node_list.append(el)
            #print('!!!! found !!!!!!!!!!! '+  el.name + str(el.values) )            
    return(node_list)


