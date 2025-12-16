require_relative 'token'

class Lexer
  WHITESPACE = [ " ", "\t", "\n", "\r", "\f", "\v" ].freeze

  private_constant :WHITESPACE

  def initialize(input:)
    @input = input
    @pos = 0
  end

  def get_tokens
    res = []

    tok = nil
    until ((tok = next_token).class == Token::EOF)
      res.append(tok)
    end

    res.append(tok)
  end

  private

  def next_token
    consume_whitespace

    return Token::EOF.new if @pos >= @input.length

    ch = @input[@pos]
    tok = nil

    case ch
    when '('
      tok = Token::LPAREN.new
      @pos += 1
    when ')'
      tok = Token::RPAREN.new
      @pos += 1
    when '['
      tok = Token::LBRACE.new
      @pos += 1
    when ']'
      tok = Token::RBRACE.new
      @pos += 1
    when '{'
      tok = Token::LBRACK.new
      @pos += 1
    when '}'
      tok = Token::RBRACK.new
      @pos += 1
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
    when ';'
      tok = Token::SEMICOLON.new
      @pos += 1
    when ','
      tok = Token::COMMA.new
      @pos += 1
    when ':'
      tok = Token::COLON.new
      @pos += 1
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
        case s
        when 'fn'
          tok = Token::FN.new
        when 'let'
          tok = Token::LET.new
        when 'true'
          tok = Token::TRUE.new
        when 'false'
          tok = Token::FALSE.new
        when 'if'
          tok = Token::IF.new
        when 'else'
          tok = Token::ELSE.new
        when 'return'
          tok = Token::RETURN.new
        else
          tok = Token::ID.new(s)
        end
      elsif is_digit(ch)
        s = consume_digit
        if @input[@pos] == '.'
          s += '.'
          @pos += 1
          s += consume_digit 
          begin
            tok = Token::FLOAT.new(Float(s))
          rescue ArgumentError
            tok = Token::ILLEGAL.new
          end
        else
          tok = Token::INT.new(Integer(s))
        end
      else
        tok = Token::ILLEGAL.new
        @pos += 1
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
      s += @input[@pos]
      @pos += 1
    end
    s
  end

  # tokens like 1.0abc are valid, should this be the case?
  def consume_digit
    s = ''
    while @pos < @input.length && is_digit(@input[@pos])
      s += @input[@pos]
      @pos += 1
    end
    s
  end

  def peek
    return '' if @pos + 1 >= @input.length
    return @input[@pos + 1]
  end

  def is_letter(ch)
    'a' <= ch && ch <= 'z' || 'A' <= ch && ch <= 'Z' || ch == '_'
  end

  def is_digit(ch)
    '0' <= ch && ch <= '9'
  end
end
