# frozen_string_literal: true

require 'pry'
require_relative 'token'

module RedLox
  class Scanner
    def initialize(source)
      @source = source
      @start = 0
      @pos = 0
      @line = 1
      @tokens = []
    end

    def advance
      ret = @source[@pos]
      @pos += 1
      ret
    end

    def add_token(type, literal = nil)
      text = @source[@start...@pos]
      @tokens << Token.new(type: type, lexeme: text, literal: literal, line: @line)
    end

    def scan_tokens()
      until at_end?
        @start = @pos
        scan_token
      end
      @tokens << Token.new(type: :eof, lexeme: '', literal: nil, line: @line)
    end

    def at_end?
      @pos >= @source.length
    end

    def scan_token
      c = advance
      case c
      when "("
        add_token :left_paren
      when ")"
        add_token :right_paren
      when "{"
        add_token :left_brace
      when "}"
        add_token :right_brace
      when ","
        add_token :comma
      when "."
        add_token :dot
      when "-"
        add_token :minus
      when "+"
        add_token :plus
      when ";"
        add_token :semicolon
      when "*"
        add_token :star
      when "!"
        add_token(if match("=")
                    :bang_equal
                  else
                    :bang
                  end)
      when "="
        add_token(if match("=")
                    :equal_equal
                  else
                    :equal
                  end)
      when "<"
        add_token(if match("=")
                    :less_equal
                  else
                    :less
                  end)
      when ">"
        add_token(if match("=")
                    :greater_equal
                  else
                    :greater
                  end)
      when "/"
        if match "/"
          while peek != "\n" && !at_end?
            advance
          end
        end
      when " "
        # skip
      when "\r"
        # skip
      when "\t"
        # skip
      when "\n"
        @line += 1
      when "\""
        string
      else
        if is_digit? c
          number
        elsif is_alpha? c
          identifier
        else
          Interpreter.error @line, 'Unexpected character.'
        end
      end
    end

    def identifier
      advance while is_alpha_numeric?(peek)

      text = @source[@start...@pos]
      type = TokenType::KEYWORD_MAP[text]
      type = :identifier if type == nil
      add_token(type)
    end

    def is_digit?(char)
      return false if (char.class != String && char.length != 1)
      '0' <= char && char <= '9'
    end

    def is_alpha?(char)
      'a' <= char && char <= 'z' ||
        'A' <= char && char <= 'Z' ||
        char == '_'
    end

    def is_alpha_numeric?(char)
      is_digit?(char) || is_alpha?(char)
    end

    def number
      while is_digit?(peek) && !at_end?
        @line += 1 if peek == "\n"
        advance
      end

      if peek == "." && is_digit?(peek_next)
        advance

        advance while is_digit?(peek)
      end

      value = @source[@start..@pos]
      add_token(:number, value.to_f)
    end

    def string
      while peek != "\"" && !at_end?
        @line += 1 if peek == "\n"
        advance
      end

      if at_end?
        Interpreter.error @line, 'Unterminated string.'
        return
      end

      advance

      value = @source[@start + 1..@pos]
      add_token(:string, value)
    end

    def peek
      return "\0" if at_end?
      @source[@pos]
    end

    def peek_next
      return "\0" if @pos + 1 >= @source.length
      @source[@pos + 1]
    end

    def match(expected)
      return false if at_end? || (@source[@pos] != expected)

      @pos += 1
      true
    end
  end
end
