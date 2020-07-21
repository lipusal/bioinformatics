# frozen_string_literal: true

require_relative 'options'
require_relative 'convolution'
require_relative 'spectrum'
require_relative 'score'

module Bioinformatics
  # Implementation of algorithms discussed in Chapter 4 of Bioinformatics Algorithms.
  # See https://www.bioinformaticsalgorithms.org/bioinformatics-chapter-4
  module Final
    class Main
      def run
        # puts Spectrum.new.cyclospectrum('KVAPSCKYELEL').sort.join(' ')
        # puts Score.new.score('NQEL', %w[0 99 113 114 128 227 257 299 355 356 370 371 484])

        args = Options.new.parse

        spectrum = (args[:spectrum] || args[:in].read.split("\n").first.chomp).split(' ')
        out = args[:out]

        # TODO NOW orchestrate ConvolutionCyclopeptideSequencing

        convolution = Convolution.new.convolution(spectrum, true)
      end
    end

    # Automatically run if running class directly. Based on https://stackoverflow.com/a/2249332/2333689
    Main.new.run if __FILE__ == $PROGRAM_NAME
  end
end
