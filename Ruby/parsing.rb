# parsing in Ruby

# require 'byebug'

# a class for grammar data
class Grammar
  $count = 0
  attr_reader :data
  def initialize
    @data = { s: [:seq, :num, :op, :num],
              op: [:alt, '+', '-'],
              num: [:rep, 1, 3, :digit],
              space: [:alt, ' '],
              digit: [:alt, '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'] }
  end

  def path(symb)
    [symb] + find_parents(symb)
  end

  def symbol_parent(symb)
    @data.select { |_, val| val.index symb }.keys
  end

  def find_parents(symb)
    parents = symbol_parent symb
    seen = []
    loop do
      break if parents.empty?
      psym = parents.first
      seen << psym
      parents = symbol_parent psym
    end
    seen
  end
end

# a class for creation of parse tree
class ParseTree
  attr_reader :tree
  def initialize(str)
    @grammar = Grammar.new
    @str = str
    @tree = parse
  end

  def classify(char)
    matches = []
    @grammar.data.each do |key, rhs|
      matches << @grammar.path(key).reverse unless rhs.reject { |elx| elx != char }.empty?
    end
    matches
  end

  def parse
    classified_chars = []
    @str.each_char do |char|
      classified_chars << [char, classify(char)]
    end

    classified_chars
  end
end

str = "123 + 456 "
tree = ParseTree.new(str)

p tree
