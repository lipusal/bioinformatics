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
        args = Options.new.parse
        ff = Bio::FlatFile.new(Bio::GenBank, args[:in])
        ff.each_entry do |entry|
          definition = "#{entry.accession} #{entry.definition}"
          sequence = entry.to_biosequence
          args[:out].write sequence.to_fasta(definition, 70)
        end
      end
    end
  end
end
