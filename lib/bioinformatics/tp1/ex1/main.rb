# frozen_string_literal: true

require 'bio'
require_relative 'options'

module Bioinformatics
  module TP1
    module Ex1
      # Calls run_return with command line arguments for input and output
      class Main
        def run
          args = Options.new.parse
          input = args[:in]
          args[:out].write run_return(input)
        end

        # Read a nucleotide sequence in GenBank format, convert it to aminoacid sequence and print it out in FASTA
        # format.
        # Adapted from <gems-root>/bio-2.0.1/doc/Tutorial.rd.html
        def run_return(input = File.open(Options::DEFAULT_INPUT_FILE))
          ff = Bio::FlatFile.new(Bio::GenBank, input)
          fasta_entries = ff.map do |entry|
            na_sequence = entry.to_biosequence
            aa_sequence = orf na_sequence
            header = "Translated amino acid sequence of #{entry.accession} #{entry.definition}"
            aa_sequence.to_fasta(header, 70)
          end

          fasta_entries.join "\n"
        end

        private

        # Get the longest amino acid sequence resulting from translating the given nucleotide sequence using
        # all different reading frames (Open Reading Frame). Adapted from https://biorelated.wordpress.com/category/bioruby/
        def orf(sequence)
          aa_seqs = []
          (1..6).each do |frame|
            aa_seq = Bio::Sequence::NA.new(sequence).translate(frame)
            # Split amino acid chains by STOP codon (*)
            aa_seqs.concat aa_seq.split('*')
          end
          # By convention the longest sequence is taken as valid
          aa_seqs.max_by(&:length)
        end
      end

      # Automatically run if running class directly. Based on https://stackoverflow.com/a/2249332/2333689
      Main.new.run if __FILE__ == $PROGRAM_NAME
    end
  end
end
