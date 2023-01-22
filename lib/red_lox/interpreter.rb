# frozen_string_literal: true

require_relative 'scanner'

module RedLox
  class Interpreter
    def initialize
      super
      @had_error = false
    end

    def run(program_string)
      scanner = Scanner.new program_string
      tokens = scanner.scan_tokens

      tokens.each do |token|
        puts token
      end
    end

    def run_file(filename)
      file = File.open(filename)
      data = StringIO.new
      data << file.read
      file.close
      run(data.string)
      exit(65) if @had_error
    end

    def run_prompt()
      print '> '
      while (line = gets)
        print '> '
        run(line)
        @had_error = false
      end
    end

    def self.error(line, message)
      report(line, "", message)
    end

    def self.report(line, where, message)
      STDERR.puts "[line #{line}] Error #{where}: #{message}"
      @had_error = true
    end
  end
end
