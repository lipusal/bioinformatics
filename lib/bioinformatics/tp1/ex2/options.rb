# frozen_string_literal: true

require 'optparse'
require 'stringio'
require_relative '../ex1/main'

module Bioinformatics
  module TP1
    module Ex2
      class Options
        def parse
          args = { in: nil, out: nil, local: false }

          OptionParser.new do |parser|
            parser.banner = "Usage: ruby #{File.expand_path 'main.rb', __dir__} [options]"

            parser.on('-i IN', '--in IN', "Input FASTA file. Defaults to calling ex 1 and using its output.") do |x|
              args[:in] = x
            end
            parser.on('-o OUT', '--out OUT', 'Output file. Defaults to STDOUT.') do |x|
              args[:out] = x
            end
            parser.on('-l', '--local', 'Perform a local BLAST search rather than online. Note that this requires that the blast binaries be in the PATH.') do |x|
              args[:local] = true
            end
          end.parse!

          # Convert in/out to files
          args[:in] = args[:in].nil? ? StringIO.open(Bioinformatics::TP1::Ex1::Main.new.run_return) : File.open(args[:in], 'r')
          args[:out] = args[:out].nil? ? STDOUT : File.open(args[:out], 'w')

          args
        end
      end
    end
  end
end
