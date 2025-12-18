require_relative 'token'

class Lexer
  WHITESPACE = [ " ", "\t", "\n", "\r", "\f", "\v" ].freeze
  KEYWORDS = {
    "fn" => Token::FN,
    "let" => Token::LET,
    "true" => Token::TRUE,
    "false" => Token::FALSE,
    "if" => Token::IF,
    "else" => Token::ELSE,
    "return" => Token::RETURN
  }.freeze
  SINGLE_CHAR_TOKENS = {
    '(' => Token::LPAREN,
    ')' => Token::RPAREN,
    '{' => Token::LBRACE,
    '}' => Token::RBRACE,
    '[' => Token::LBRACK,
    ']' => Token::RBRACK,
    ';' => Token::SEMICOLON,
    ',' => Token::COMMA,
    ':' => Token::COLON
  }.freeze

  private_constant :WHITESPACE
  private_constant :KEYWORDS
  private_constant :SINGLE_CHAR_TOKENS

  def initialize(input:)
    @input = input
    @pos = 0
  end

  def get_tokens
    res = []
    errors = []
    loop do
      tok = next_token
      res << tok
      errors << tok if tok.is_a?(Token::ILLEGAL)
      break if tok.is_a?(Token::EOF)
    end

    raise LexerError.new(errors) unless errors.empty?
    res
  end

  private

  def next_token
    consume_whitespace

    return Token::EOF.new if @pos >= @input.length

    ch = @input[@pos]
    tok = nil

    if SINGLE_CHAR_TOKENS.key?(ch)
      tok = SINGLE_CHAR_TOKENS[ch].new
      @pos += 1
    else
      case ch
      when '!'
        if peek == '='
          tok = Token::NE.new
          @pos += 2
        else
          tok = Token::BANG.new
          @pos += 1
        end
      when '='
        if peek == '='
          tok = Token::EQ.new
          @pos += 2
        else
          tok = Token::ASSIGN.new
          @pos += 1
        end
      when '<'
        if peek == '='
          tok = Token::LE.new
          @pos += 2
        else
          tok = Token::LT.new
          @pos += 1
        end
      when '>'
        if peek == '='
          tok = Token::GE.new
          @pos += 2
        else
          tok = Token::GT.new
          @pos += 1
        end
      when '+'
        if peek == '+'
          tok = Token::INC.new
          @pos += 2
        else
          tok = Token::PLUS.new
          @pos += 1
        end
      when '-'
        if peek == '-'
          tok = Token::DEC.new
          @pos += 2
        else
          tok = Token::MINUS.new
          @pos += 1
        end
      when '*'
        tok = Token::ASTERISK.new
        @pos += 1
      when '/'
        tok = Token::SLASH.new
        @pos += 1
      else
        if is_letter(ch)
          s = consume_id_or_kw
          tok_type = KEYWORDS.fetch(s, Token::ID)
          tok = tok_type == Token::ID ? Token::ID.new(s) : tok_type.new
        elsif is_digit(ch)
          s = consume_digit
          if @input[@pos] == '.'
            s += '.'
            @pos += 1
            frac = consume_digit
            if frac == ''
              tok = Token::ILLEGAL.new(s)
            else
                s << frac
              begin
                tok = Token::FLOAT.new(Float(s))
              rescue ArgumentError
                tok = Token::ILLEGAL.new(s)
              end
            end
          else
            tok = Token::INT.new(Integer(s))
          end
        else
          tok = Token::ILLEGAL.new(ch)
          @pos += 1
        end
      end
    end

    tok
  end

  def consume_whitespace
    while @pos < @input.length && WHITESPACE.include?(@input[@pos])
      @pos += 1
    end
  end

  def consume_id_or_kw
    s = ''
    while @pos < @input.length && (is_letter(@input[@pos]) || is_digit(@input[@pos]))
      # Use StringIO?
      s << @input[@pos]
      @pos += 1
    end
    s
  end

  # tokens like 1.0abc are valid (FLOAT & ID), should this be the case?
  def consume_digit
    s = ''
    while @pos < @input.length && is_digit(@input[@pos])
      # Use StringIO?
      s << @input[@pos]
      @pos += 1
    end
    s
  end

  def peek
    return nil if @pos + 1 >= @input.length
    return @input[@pos + 1]
  end

  def is_letter(ch)
    'a' <= ch && ch <= 'z' || 'A' <= ch && ch <= 'Z' || ch == '_'
  end

  def is_digit(ch)
    '0' <= ch && ch <= '9'
  end
end

class LexerError < StandardError
  attr_reader :tokens

  def initialize(tokens)
    @tokens = tokens
    tokens_str = tokens.map(&:to_s).join(', ')
    super("Lexer encountered illegal tokens: #{tokens_str}")
  end
end
