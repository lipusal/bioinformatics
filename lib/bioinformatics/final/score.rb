# frozen_string_literal: true

require_relative 'spectrum'

module Bioinformatics
  module Final
    # Scoring function that corresponds to lesson 4.7 of the book and http://rosalind.info/problems/ba4f/
    class Score
      def run
        puts Score.new.score('NQEL', %w[0 99 113 114 128 227 257 299 355 356 370 371 484])
      end

      # Compute the score of a given peptide against a given spectrum. The score is the number of shared
      # masses between the peptide's cyclospectrum and the given spectrum, accounting for multiplicity.
      def score(peptide, spectrum)
        cyclospectrum = Spectrum.new.cyclospectrum(peptide).sort
        sorted_spectrum = spectrum.map(&:to_i).sort
        i = j = 0
        score = 0
        while i < cyclospectrum.length && j < sorted_spectrum.length
          a = cyclospectrum[i]
          b = sorted_spectrum[j]
          if a == b
            score += 1
            i += 1
            j += 1
          elsif a < b && i < cyclospectrum.length - 1
            i += 1
          elsif a > b && j < sorted_spectrum.length - 1
            j += 1
          else
            break
          end
        end
        score
      end
    end

    # Automatically run if running class directly. Based on https://stackoverflow.com/a/2249332/2333689
    Score.new.run if __FILE__ == $PROGRAM_NAME
  end
end
