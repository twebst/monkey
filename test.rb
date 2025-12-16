#!/home/tyler/.rvm/rubies/ruby-3.3.0/bin/ruby
require_relative 'lexer'

test = """
let five = 5;
let ten = 10;
let add = fn(x, y) {
x + y;
};
let result = add(five, ten);
!-/*5;
5 < 10 > 5;
"""

l = Lexer.new(input: test)
puts l.get_tokens
