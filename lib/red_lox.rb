# frozen_string_literal: true

require_relative "red_lox/version"
require_relative "red_lox/interpreter"
require_relative "red_lox/token_type"

module RedLox
  class Error < StandardError; end

  def self.main(args)
    if args.length > 1
      puts 'Usage: redlox [script]'
      exit(64)
    else
      intp = Interpreter.new
      if args.length == 1
        intp.run_file args[0]
      else
        intp.run_prompt
      end
    end
  end
end
