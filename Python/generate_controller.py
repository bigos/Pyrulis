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

