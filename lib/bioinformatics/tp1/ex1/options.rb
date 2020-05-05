# frozen_string_literal: true

require 'optparse'

module Bioinformatics
  module TP1
    module Ex1
      class Options
        DEFAULT_INPUT_FILE = File.join __dir__, 'NM_002049.gbk'

        def parse
          args = { in: DEFAULT_INPUT_FILE, out: nil }

          OptionParser.new do |parser|
            parser.banner = 'Usage: ex1.rb [options]'

            parser.on('-i IN', '--in IN', "Input file. Defaults to #{DEFAULT_INPUT_FILE}.") do |x|
              args[:in] = x
            end
            parser.on('-o OUT', '--out OUT', 'Output file. Defaults to STDOUT.') do |x|
              args[:out] = x
            end
          end.parse!

          # Convert in/out to files
          args[:in] = File.open(args[:in], 'r')
          args[:out] = args[:out].nil? ? STDOUT : File.open(args[:out], 'w')

          args
        end
      end
    end
  end
end
