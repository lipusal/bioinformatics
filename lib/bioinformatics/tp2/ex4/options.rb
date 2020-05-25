# frozen_string_literal: true

require 'optparse'

module Bioinformatics
  module TP2
    module Ex4
      class Options
        DEFAULT_INPUT_FILE = File.join __dir__, '..', '..', 'tp1', 'ex2', 'blast_raw.xml'

        def parse
          args = { in: DEFAULT_INPUT_FILE, out: nil, pattern: nil }

          OptionParser.new do |parser|
            parser.banner = "Usage: #{File.expand_path 'main.rb'} [options]"

            parser.on('-i IN', '--in IN', 'Input BLAST XML report file. Defaults to reading report from ex 2.') do |x|
              args[:in] = x
            end
            parser.on('-o OUT', '--out OUT', 'Output file. Defaults to STDOUT.') do |x|
              args[:out] = x
            end
            parser.on('-p PATTERN', '--pattern PATTERN', '[REQUIRED] Pattern to match, case-insensitive.') do |x|
              args[:pattern] = x
            end
          end.parse!

          if args[:pattern].nil?
            puts 'Pattern is required'
            exit 1
          end
          if args[:pattern].empty?
            puts 'Pattern is must be not empty'
            exit 1
          end

          # Convert in/out to files
          args[:in] = File.open(args[:in], 'r') unless args[:in].nil?
          args[:out] = args[:out].nil? ? STDOUT : File.open(args[:out], 'w')

          args
        end
      end
    end
  end
end
