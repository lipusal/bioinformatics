# frozen_string_literal: true

module Bioinformatics
  module Final
    # Convolution algorithms that correspond to lesson 4.9 of the book.  Given a spectrum (molecular masses
    # read from all chunks of a peptide), compute all the positive differences between elements of the
    # spectrum.
    class Convolution
      MAX_MASS = 200
      MIN_MASS = 57

      # Compute the convolution of a given peptide's spectrum. Return each difference paired with its
      # multiplicity.
      # If restrict = true, only returns differences between #MAX_MASS and #MIN_MASS
      def self.convolution(spectrum, restrict = false)
        multiplicities = Hash.new { |map, key| map[key] = 0 }
        # Sort because spectrum should contain 0 and total mass TODO what happens if 0 is not present? Can we assume the largest element is the total mass?
        spectrum.map!(&:to_i).sort!
        # Traverse the lower half of the matrix created with spectrum as rows and columns (exclude diagonal)
        (0...spectrum.length).each do |col|
          ((col + 1)...spectrum.length).each do |row|
            diff = spectrum[row] - spectrum[col]
            if diff <= 0 || (restrict && diff < MIN_MASS || diff > MAX_MASS) # Restrict masses if requested
              next
            end

            multiplicities[diff] += 1
          end
        end

        # puts multiplicities.sort_by { |_k, v| -v }.to_h # Sort by descending multiplicity
        multiplicities
      end

      # Calls #convolution and formats the output as a string.  Differences are ordered by descending
      # multiplicity and every difference is printed [multiplicity] times.
      def self.convolution_formatted(spectrum, restrict = false)
        convolution(spectrum, restrict)
          .sort_by { |_k, v| -v } # Sort by descending multiplicity
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
