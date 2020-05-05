# frozen_string_literal: true

require 'bio'
require_relative 'options'

module Bioinformatics
  module TP1
    module Ex1
      # Read a nucleotide sequence in GenBank format, convert it to aminoacid sequence and print it out in FASTA
      # format.
      # Adapted from <gems-root>/bio-2.0.1/doc/Tutorial.rd.html
      class Ex1
        # Automatically run if running class directly. Based on https://stackoverflow.com/a/2249332/2333689
        run if __FILE__ == $PROGRAM_NAME

        def run
          args = Options.new.parse
          ff = Bio::FlatFile.new(Bio::GenBank, args[:in])
          ff.each_entry do |entry|
            definition = "#{entry.accession} #{entry.definition}"
            sequence = entry.to_biosequence
            args[:out].write sequence.to_fasta(definition, 70)
          end
        end

        # Equivalent to run but takes parameters and returns value instead of using in/out arguments
        def run_return(input = File.open(Options::DEFAULT_INPUT_FILE))
          ff = Bio::FlatFile.new(Bio::GenBank, input)
          fasta_entries = ff.map do |entry|
            definition = "#{entry.accession} #{entry.definition}"
            sequence = entry.to_biosequence
            sequence.to_fasta(definition, 70)
          end

          fasta_entries.join "\n"
        end
      end
    end
  end
end
