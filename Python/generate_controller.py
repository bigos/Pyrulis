#! /usr/bin/python

import sys

print('controller generator')

def indent(i,str):
    space=' '
    return (space * i)+str

def guess_singular(plural):
    guessed=plural[0:-1]
    print(  "\nsuggested singular for plural %s is: %s" % (plural, guessed))
    print( "If it is correct press Enter,")
    print( "but if it not correct please enter correct version ")
    entered = raw_input('')
    if entered == '':
        return guessed
    else:
        return entered

def to_underscores(camel_string):
    cap_str='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    capitals = []
    result = ''
    for x in cap_str:
        capitals.append(x)
    for letter in camel_string:
        if letter.isupper():
            result += ('_' + letter.lower())
        else:
            result += letter
    return result.strip('_')

def spaces(n):
    return ' ' * n   

def generate(sing_camel, plu_camel):
    sing_under = to_underscores(sing_camel)
    plu_under =  to_underscores(plu_camel)
    methods = [
        ['index','all', False, False],             
        ['show','find',':id', False],              
        ['new','new', False, False],
        ['edit','find',':id', False],
        ['create','new',":{0}".format(sing_under),"if {0}.save".format(sing_under)],              
        ['update','find',':id',"if @{0}.update_attributes(params[:{0}])".format(sing_under)],
        ['destroy','find',':id', False] ]
    print methods
    r = "class {0}Controller < ApplicationController\n".format(plu_camel)
    r += indent(2, "respond_to :html, :json, :xml\n")
    for e in methods:
        r += indent(2, "def {0}\n".format(e[0]))
        if e[0] == 'index':
            obj = plu_under
        else:
            obj = sing_under
        r += indent(4, "@{0} = {1}.{2}".format(obj, sing_camel, e[1]))
        if e[2]:
            r += "(params[{0}])\n".format(e[2])
        else:
            r += "\n"
        if e[3]:
            r += indent(4,"{0}\n{2}\n{1}else\n{2}\n{1}end\n".format(e[3], spaces(4), spaces(6)))
        if e[0] == 'destroy':
            r += indent(4, "@{}.destroy\n".format(obj))
        r += indent(4, "respond_with(@{0})\n".format(obj))
        r += indent(2, "end\n")
    r += "end\n"
    print(r)

def main():
    print 'in main'
    plural_name = 'StruggleReports'
    singular_name = guess_singular(plural_name)
    generate( singular_name, plural_name)

main()
