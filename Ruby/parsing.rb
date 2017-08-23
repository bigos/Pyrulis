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

  def path(s)
    [s] + find_parents(s)
  end

  def find_parents(s)
    parents = @data.select { |_, v| v.index s }.keys
    seen = []
    loop do
      break if parents.empty?
      s = parents.first
      seen << s
      parents = @data.select { |_, v| v.index s }.keys
    end
    seen
  end
end

# a class for creation of parse tree
class ParseTree
  def initialize(str)
    @grammar = Grammar.new
    @str = str
    @tree = parse
  end

  def classify(c)
    matches = []
    @grammar.data.each do |key, rhs|
      matches << @grammar.path(key) unless rhs.reject { |x| x != c }.empty?
    end
    matches
  end

  def parse
    classified_chars = []
    @str.each_char do |c|
      classified_chars << [c, classify(c)]
    end

    classified_chars
  end
end

str = "123 + 456 "
tree = ParseTree.new(str)

p tree
