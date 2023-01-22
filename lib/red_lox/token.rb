# frozen_string_literal: true

module RedLox
  class Token
    attr_reader :type
    attr_reader :lexeme
    attr_reader :literal
    attr_reader :line

    def initialize(type:, lexeme:, literal:, line:)
      @lexeme = lexeme
      @type = type
      @literal = literal
      @line = line
    end

    def to_s
      "#{type}, '#{lexeme}'" + if literal then ", \"#{literal}\"" else '' end
    end
  end
end
