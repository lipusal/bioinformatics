# frozen_string_literal: true

require_relative 'score'

module Bioinformatics
  module Final
    class Sequencing

      def initialize
        @scorer = Score.new
      end

      # Implement the leaderboard-based convolution cyclopeptide sequencing algorithm.
      #
      # @param spectrum Spectrum to sequence.
      # @param masses_dictionary Masses of aminoacids that will be used in the expand step
      # @param leaderboard_size Maximum leaderboard size. Note that ties all occupy one spot.
      def ConvolutionCyclopeptideSequencing(spectrum, masses_dictionary, leaderboard_size)
        parent_mass = parent_mass spectrum
        leaderboard = [[]]
        leader = []
        until leaderboard.empty?
          leaderboard = expand(leaderboard, masses_dictionary)
          leaderboard.each_with_index do |peptide, index|
            if mass(peptide) == parent_mass
              if score(peptide, spectrum) > score(leader, spectrum)
                leader = peptide
              end
            elsif mass(peptide) > parent_mass
              leaderboard.delete_at index
            end
          end
          leaderboard = trim(leaderboard, spectrum, leaderboard_size)
        end

        leader

        #  LeaderboardCyclopeptideSequencing(Spectrum, N)
        #   Leaderboard ← set containing only the empty peptide
        #   LeaderPeptide ← empty peptide
        #   while Leaderboard is non-empty
        #     Leaderboard ← Expand(Leaderboard)
        #     for each Peptide in Leaderboard
        #       if Mass(Peptide) = ParentMass(Spectrum)
        #         if Score(Peptide, Spectrum) > Score(LeaderPeptide, Spectrum)
        #           LeaderPeptide ← Peptide
        #       else if Mass(Peptide) > ParentMass(Spectrum)
        #         remove Peptide from Leaderboard
        #     Leaderboard ← Trim(Leaderboard, Spectrum, N)
        #   output LeaderPeptide
      end

      private

      def score(peptide, spectrum)
        # FIXME this doesn't work because the problem inputs masses rather than aminoacids, and I am only given
        #   a table of 20 aminoacids, not the full 100+, so there are some masses I can't translate for the
        #   scorer.
        @scorer.score(peptide, spectrum)
      end

      # Append every mass in the given masses dictionary to every peptide.
      def expand(peptides, masses_dictionary)
        peptides.flat_map do |peptide|
          masses_dictionary.map do |mass|
            peptide + [mass]
          end
        end
      end

      def mass(peptide)
        peptide.sum
      end

      # "For the sake of simplicity, we will assume that for all experimental spectra, ParentMass(Spectrum) is
      # equal to the largest mass in Spectrum."
      def parent_mass(spectrum)
        spectrum.max
      end

      # Get the top number elements from ARY, disregarding ties (ie. ties don't add up to MAX, so resulting array
      # may contain more than MAX elements).
      def trim(leaderboard, spectrum, max)
        sorted = leaderboard
                 .map { |peptide| [peptide, score(peptide, spectrum)] }
                 .sort_by { |_peptide, score| -score }
        result = [sorted.first]
        inserted = 1
        i = 1
        while inserted < max && i < sorted.size
          _peptide, score = sorted[i]
          result << sorted[i]
          i += 1
          # Don't count an additional inserted if the differences have equal multiplicity
          inserted += 1 if score < result[-2][1]
        end
        result.map { |peptide, _score| peptide }
      end

      # Take the top MAX elements from ARY, disregarding ties (ie. ties don't count towards MAX, result might
      # have more than MAX elements).
      def take_top(ary, max)
        sorted = ary.sort.reverse
        result = [sorted.first]
        inserted = 1
        i = 1
        while inserted < max && i < sorted.size
          result << sorted[i]
          i += 1
          # Don't count an additional inserted if the differences have equal multiplicity
          inserted += 1 if result[-1] < result[-2]
        end
        result
      end
    end
  end
end
