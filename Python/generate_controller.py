#! /usr/bin/python

import sys

print('controller generator')

def indent(i,str):
    space=' '
    (space * i)+str

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
    
def generate(sing_camel, plu_camel):
    sing_under = to_underscores(sing_camel)
    plu_under =  to_underscores(plu_camel)
    methods = [
        ['index','all'],             
        ['show','find',':id'],              
        ['new','new'],
        ['edit','find',':id'],
        ['create','new',":{0}".format(sing_under),"if {0}.save".format(sing_under)],              
        ['update','find',':id',"if @{0}.update_attributes(params[:{0}])".format(sing_under)],
        ['destroy','find',':id'] ]
    print methods
    r = "class {0}Controller < ApplicationController\n".format(plu_camel)
    r += indent(2, "respond_to :html, :json, :xml\n")
    # iterate here
    r += "end\n"
    print(r)

def main():
    print 'in main'
    plural_name = 'StruggleReports'
    singular_name = guess_singular(plural_name)
    generate( singular_name, plural_name)

main()
