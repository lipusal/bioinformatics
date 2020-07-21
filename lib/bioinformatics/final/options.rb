# frozen_string_literal: true

require 'optparse'

module Bioinformatics
  module Final
    class Options

      def parse
        args = { in: nil, out: nil, spectrum: nil, top_masses: nil, leaderboard_size: nil }

        OptionParser.new do |parser|
          parser.banner = "Usage: ruby #{File.expand_path 'main.rb', __dir__} [options]"

          parser.on('-i IN', '--in IN', 'Spectrum input file.') do |x|
            args[:in] = x
          end
          parser.on('-o OUT', '--out OUT', 'Output file. Defaults to STDOUT.') do |x|
            args[:out] = x
          end
          parser.on('-s SPECTRUM', '--spectrum SPECTRUM', 'Spectrum. Elements should be space-separated.') do |x|
            args[:spectrum] = x
          end
          parser.on('-m TOP_MASSES', '--top-masses TOP_MASSES', Integer, 'Number of masses to use from the convolution of the specified spectrum.') do |x|
            args[:top_masses] = x
          end
          parser.on('-n LEADERBOARD_SIZE', '--leaderboard-size LEADERBOARD_SIZE', Integer, 'Maximum leaderboard size for peptide sequencing.') do |x|
            args[:leaderboard_size] = x
          end
        end.parse!

        if args[:in].nil? && args[:spectrum].nil?
          puts 'Either input file (-i) or spectrum (-s) is required.'
          exit 1
        end
        if args[:top_masses].nil?
          puts 'Top masses (-m) is required.'
          exit 1
        end
        if args[:leaderboard_size].nil?
          puts 'Leaderboard size (-n) is required.'
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
