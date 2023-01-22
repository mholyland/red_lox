# frozen_string_literal: true

module RedLox
  module TokenType
    # Single-character tokens.
    single_char = %w[LEFT_PAREN RIGHT_PAREN LEFT_BRACE RIGHT_BRACE
    COMMA DOT MINUS PLUS SEMICOLON SLASH STAR]

    # One or two character tokens.
    operands = %w[BANG BANG_EQUAL
      EQUAL EQUAL_EQUAL
      GREATER GREATER_EQUAL
      LESS LESS_EQUAL]

    # Literals.
    literals = %w[IDENTIFIER STRING NUMBER]

    # Keywords.
    keywords = %w[AND CLASS ELSE FALSE FUN FOR IF NIL OR
      PRINT RETURN SUPER THIS TRUE VAR WHILE]

    eof = %w[EOF]

    KEYWORD_MAP = {}
    keywords.map { |t| KEYWORD_MAP[t.downcase] = t.downcase.to_sym }

    token_strings = single_char + operands + literals + keywords + eof
    TOKEN_SYMBOLS = (token_strings.map { |t| t.downcase.to_sym }).to_set
  end
end