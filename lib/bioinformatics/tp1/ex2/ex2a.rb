# frozen_string_literal: true

require 'bio'
require_relative 'options'

module Bioinformatics
  module TP1
    module Ex2
      # Read a FASTA sequence and perform a BLAST search on it.
      class Ex2a
        args = Options.new.parse
        searcher_args = ['blastp', 'swissprot'] ## TODO NOW figure out whether our original sequence is NA or AA, and correct searcher_args
        searcher = args[:local] ? Bio::Blast.local(*searcher_args) : Bio::Blast.remote(*searcher_args)
        ff = Bio::FlatFile.new(Bio::FastaFormat, args[:in])
        ff.each_entry do |entry|
          report = searcher.query(entry.seq)
          args[:out].write "Report: #{report}"
        end
      end
    end
  end
end
