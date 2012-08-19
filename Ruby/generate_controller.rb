#! /usr/bin/env ruby

class String
  def to_underscores
    # converts CamelCase to undescores
    capitals = %w(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
    result=''
    self.size.times do |x|
      letter = self[x,1]
      if capitals.index letter
        result += "_"+letter.downcase
      else
        result += letter
      end
    end
    result[0,1]='' if result[0,1]=='_'
    return result
  end
end
class Fixnum
  def spaces; ' ' * self; end
end

def guess_singular(plural)
  guessed=plural[0..-2]
  puts "\nsuggested singular for #{plural} is: "+guessed
  puts "If it is correct press Enter,"
  puts "but if it not correct please enter correct version"
  entered=STDIN.gets.chomp
  puts
  return guessed  if entered == ''
  return entered
end
def indent (i,str)
  i.spaces+str
end
def generate(plu_camel,plu_under,sing_camel,sing_under)
  methods=[ ['index','all'],
            ['show','find',':id'],
            ['new','new'],
            ['edit','find',':id'],
            ['create','new',":#{sing_under}","if @#{sing_under}.save"],
            ['update','find',':id',"if @#{sing_under}.update_attributes(params[:#{sing_under}]) "],
            ['destroy','find',':id'] ]

  r="class #{plu_camel}Controller < ApplicationController\n"
  r << indent( 2, "respond_to :html, :json, :xml\n")
  methods.each do |e|
    r << indent( 2,"def #{e[0]}\n")
    e[0]=='index' ? obj=plu_under : obj=sing_under
    r << indent( 4,"@#{obj} = #{sing_camel}.#{e[1]}")
    e[2] ? r << "(params[#{e[2]}])\n" : r << "\n"
    r << indent( 4,"#{e[3]}\n#{6.spaces}#\n#{4.spaces}else\n#{6.spaces}#\n#{4.spaces}end\n") if e[3]
    r << indent( 4,"@#{obj}.destroy\n") if e[0]=='destroy'
    r << indent( 4,"respond_with(@#{obj})\n")
    r << indent( 2,"end\n")
  end
  r << "end\n"
  puts r
end

def usage
  puts "usage:\n #{$0} PluralControllerNames"
end
#################################################
#puts $*.inspect
plural_name = $*[0]
if plural_name==nil or plural_name[0,1] == '-'
  usage
elsif plural_name != nil
  singular_name = guess_singular( plural_name)
  generate(plural_name,plural_name.to_underscores,singular_name,singular_name.to_underscores)
else
  usage
end

