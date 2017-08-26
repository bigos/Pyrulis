# parsing in Ruby

# require 'byebug'

# a class for grammar data
class Grammar
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

  private

  def symbol_parent(symb)
    @data.select { |_, val| val.index symb }.keys
  end

  def find_parents(symb)
    parents = symbol_parent symb
    seen = []
    until parents.empty?
      psym = parents.first
      seen << psym
      parents = symbol_parent psym
    end
    seen
  end
end

# class for parse tree nodes
class Node
  def initialize(char, path)
    @char = char if path.length == 1
    @dir = path.first
  end

  def add_node(char, path)
    # finish me
  end
end

# a class for creation of parse tree
class ParseTree
  attr_reader :tree
  def initialize(str)
    @grammar = Grammar.new
    @str = str
    @tree = Node.new nil, [:s]
    parse
    @tree
  end

  def parse
    classified_chars = []
    @str.each_char do |char|
      path = classify char
      classified_chars << [char, path]
      @tree.add_node char, path
    end
    classified_chars
  end

  private

  def classify(char)
    matches = []
    @grammar.data.each do |key, rhs|
      matches << @grammar.path(key).reverse unless rhs.reject { |elx| elx != char }.empty?
    end
    matches
  end
end

str = '123 + 456 '
tree = ParseTree.new(str)

p tree
