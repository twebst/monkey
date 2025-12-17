module Token
  class Base
    def type
      self.class
    end
  end

  OPERATORS = %w[ASSIGN EQ BANG NE GT GE LT LE PLUS INC MINUS DEC ASTERISK SLASH COLON]
  KEYWORDS = %w[FN LET TRUE FALSE IF ELSE RETURN]
  DELIMITERS = %w[LPAREN RPAREN LBRACE RBRACE LBRACK RBRACK COMMA SEMICOLON]
  SPECIAL = %w[EOF]
  COMPOSITE = %w[ID INT FLOAT ILLEGAL]

  private_constant :OPERATORS, :KEYWORDS, :DELIMITERS, :SPECIAL, :COMPOSITE

  [OPERATORS, KEYWORDS, SPECIAL, DELIMITERS].each do |types|
    types.each do |type|
      klass = Class.new(Base) do
        define_method(:to_s) { "#{type}" }
      end

      const_set(type, klass)
    end
  end

  COMPOSITE.each do |type|
    klass = Class.new(Base) do
      attr_reader :value

      define_method(:initialize) { |value| @value = value }
      define_method(:to_s) { "#{type}(#{value})" }
    end
    const_set(type, klass)
  end
end
