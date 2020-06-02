# frozen_string_literal: true

require 'optparse'

module Bioinformatics
  module TP2
    module Ex5
      class Options

        def parse
          args = { in: nil, out: '.', sequence: nil }

          OptionParser.new do |parser|
            parser.banner = "Usage: #{File.expand_path 'main.rb'} [options]"

            parser.on('-i IN', '--in IN', 'Input nucleotide sequence FASTA file.') do |x|
              args[:in] = x
            end
            parser.on('-o OUT', '--out OUT', 'Output directory. Defaults to cwd.') do |x|
              args[:out] = x
            end
            parser.on('-s SEQUENCE', '--sequence SEQUENCE', 'Nucleotide sequence in FASTA format.') do |x|
              args[:sequence] = x
            end
          end.parse!

          unless File.directory? args[:out]
            puts "#{args[:out]} is not a directory"
            exit 1
          end

          # Convert in/out to files
          args[:in] = File.open(args[:in], 'r') unless args[:in].nil?

          args
        end
      end
    end
  end
end
