# frozen_string_literal: true

require 'bio'

module Bioinformatics::TP1
  # Read a nucleotide sequence in GenBank format, convert it to aminoacid sequence and print it out in FASTA
  # format.
  # Adapted from <gems-root>/bio-2.0.1/doc/Tutorial.rd.html
  class Ex1
    ff = Bio::FlatFile.new(Bio::GenBank, File.open('NM_002049.gbk'))
    ff.each_entry do |entry|
      definition = "#{entry.accession} #{entry.definition}"
      sequence = entry.to_biosequence
      sequence.aa # Convert to amino acid (AA) sequence TODO check this, we also need to check open reading frames
      puts sequence.to_fasta(definition, 60)
    end
  end
end
