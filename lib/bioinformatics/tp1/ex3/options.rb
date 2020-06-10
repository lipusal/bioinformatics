# frozen_string_literal: true

require 'optparse'
require 'stringio'
require_relative '../ex1/main'

module Bioinformatics
  module TP1
    module Ex3
      class Options
        def parse
          args = { in: nil, out: nil, mafft: 'mafft' }

          OptionParser.new do |parser|
            parser.banner = "Usage: ruby #{File.expand_path 'main.rb', __dir__} [options]"

            parser.on('-i IN', '--in IN', 'Input FASTA file. Defaults to reading raw BLAST from ex 2, looking up random FASTA sequences and using that.') do |x|
              args[:in] = x
            end
            parser.on('-o OUT', '--out OUT', 'Output file. Defaults to STDOUT.') do |x|
              args[:out] = x
            end
            parser.on('-m MAFFT', '--mafft MAFFT', "MAFFT program path. Defaults to 'mafft'.") do |x|
              args[:mafft] = x
            end
          end.parse!

          # Convert in/out to files
          args[:in] = File.open(args[:in], 'r') unless args[:in].nil?
          args[:out] = args[:out].nil? ? STDOUT : File.open(args[:out], 'w')

          args
        end
      end
    end
  end
end
