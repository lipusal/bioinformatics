# frozen_string_literal: true

module Bioinformatics
  module Final
    # (Cyclo)spectrum algorithms that correspond to lesson 4.4 of the book.
    class Spectrum
      # Integer masses for the 20 standard aminoacids. Taken from http://rosalind.info/problems/ba4c/
      MASSES = {
        G: 57,
        A: 71,
        S: 87,
        P: 97,
        V: 99,
        T: 101,
        C: 103,
        I: 113,
        L: 113,
        N: 114,
        D: 115,
        K: 128,
        Q: 128,
        E: 129,
        M: 131,
        H: 137,
        F: 147,
        R: 156,
        Y: 163,
        W: 186
      }.freeze

      # Generate the theoretical spectrum of a given cyclic peptide.
      def cyclospectrum(peptide)
        tmp = peptide.upcase.split('').map(&:to_sym)
        result = [0]

        (1...tmp.length).each do |length|
          (0...tmp.length).each do |start|
            subpeptide = tmp.rotate(start).take(length)
            # puts "Mass of #{subpeptide} = #{mass(subpeptide)}"
            result << mass(subpeptide)
          end
        end

        # Mass of full peptide
        result << mass(tmp)
        result
      end

      private

      def mass(peptide)
        peptide
          .map { |amino| MASSES[amino] }
          .sum
      end
    end
  end
end
