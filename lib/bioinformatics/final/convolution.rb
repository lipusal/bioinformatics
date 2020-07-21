# frozen_string_literal: true

module Bioinformatics
  module Final
    # Convolution algorithms that correspond to lesson 4.9 of the book.  Given a spectrum (molecular masses
    # read from all chunks of a peptide), compute all the positive differences between elements of the
    # spectrum.
    class Convolution
      MAX_MASS = 200
      MIN_MASS = 57

      # Compute the convolution of a given peptide's spectrum. Return the differences ordered by descending
      # multiplicity; every difference is given [multiplicity] times.
      # If restrict = true, only returns differences between #MAX_MASS and #MIN_MASS
      def self.convolution(spectrum, restrict = false)
        multiplicities = Hash.new { |map, key| map[key] = 0 }
        spectrum.map!(&:to_i).sort!
        # Traverse the lower half of the matrix created with spectrum as rows and columns (exclude diagonal)
        (0...spectrum.length).each do |col|
          ((col + 1)...spectrum.length).each do |row|
            diff = spectrum[row] - spectrum[col]
            next if diff <= 0

            multiplicities[diff] += 1
          end
        end

        # puts multiplicities.sort_by { |_k, v| -v }.to_h # Sort by descending multiplicity
        multiplicities
          .sort_by { |_k, v| -v } # Sort by descending multiplicity
          .select { |diff, _multiplicity| !restrict || diff >= MIN_MASS && diff <= MAX_MASS } # Restrict masses if requested
          .flat_map { |diff, multiplicity| [diff] * multiplicity } # Print out each difference multiplicity times
      end

      # Like #convolution, but rather than returning multiplicities prints out the convolution matrix for
      # easier visualization/debugging. The format of the matrix matches that of the book.
      def self.convolution_debug(spectrum)
        spectrum.map!(&:to_i).sort!
        n = spectrum.length
        # n x n array for differences
        convolution = Array.new(n) { Array.new(n, nil) }

        (0...spectrum.length).each do |col|
          ((col + 1)...spectrum.length).each do |row|
            diff = spectrum[row] - spectrum[col]
            next if diff <= 0

            convolution[row][col] = diff
          end
        end

        # Pretty print convolution matrix
        puts '    | ' + spectrum.map { |i| pretty(i) }.join('|')
        puts '======' * n
        convolution.each_with_index do |row, index|
          printf('%s| ', pretty(spectrum[index]))
          puts row.map { |i| i.nil? ? '    ' : pretty(i) }.join('|')
          puts '======' * n
        end
      end

      private

      def pretty(n)
        format('%4i', n)
      end
    end
  end
end
