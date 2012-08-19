#! /usr/bin/python

import sys

print('controller generator')

def indent(i,str):
    space=' '
    (space * i)+str

def guess_singular(plural):
    guessed=plural[0:-1]
    print(  "\nsuggested singular for %s is: %s" % (plural, guessed))
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
    

print to_underscores('DailyStruggleReport')
