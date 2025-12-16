module Token

  PRIMITIVE = [
    "LPAREN", # (
    "RPAREN", # )
    "LBRACE", # [
    "RBRACE", # ]
    "LBRACK", # {
    "RBRACK", # }

    "ASSIGN", # =
    "EQ", # ==
    "BANG", # !
    "NE", # !=
    "GT", # >
    "GE", # >=
    "LT", # <
    "LE", # <=
    "PLUS", # +
    "INC", # ++
    "MINUS", # -
    "DEC", # --
    "ASTERISK", # *
    "SLASH", # /
    "COLON", # :
    "COMMA", # ,
    "SEMICOLON", # ;
    
    # keywords
    "FN", # function
    "LET", # let
    "TRUE", # true
    "FALSE", # false
    "IF", # if
    "ELSE", # else
    "RETURN", # return

    "ILLEGAL", # unidentified token
    "EOF", # end-of-file
  ]

  COMPOSITE = [
    "ID", # Identifier
    "INT", # Integer
    "FLOAT", # Float
  ]

  private_constant :PRIMITIVE
  private_constant :COMPOSITE

  PRIMITIVE.each do |type|
    klass = Class.new do
      def to_s
        "#{self.class.to_s.split('::')[-1]}"
      end
    end
    const_set(type, klass)
  end

  COMPOSITE.each do |type|
    klass = Class.new do
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def to_s
        "#{self.class.to_s.split('::')[-1]}(#{value})"
      end
    end
    const_set(type, klass)
  end
end
