# frozen_string_literal: true

require 'bio'
require_relative 'options'
require_relative '../ex1/main'

module Bioinformatics
  module TP1
    module Ex3
      # Read multiple FASTA sequences and perform a multiple sequence alignment (MSA).
      class Main
        BLAST_RAW_FILE = File.join __dir__, '..', 'ex2', 'blast_raw.xml'

        def run
          args = Options.new.parse
          sequences = if args[:in].nil?
                        ex1_sequences + lookup_random_fasta
                      else
                        ff = Bio::FlatFile.new(Bio::FastaFormat, args[:in])
                        ff.entries
                      end
          out = args[:out]

          puts "Performing alignment on #{sequences.length} sequences..."
          aligner = Bio::MAFFT.new args[:mafft], ['--quiet']
          alignment = aligner.query sequences
          out.puts alignment.to_fasta
        end

        private

        def ex1_sequences
          fasta = Bioinformatics::TP1::Ex1::Main.new.run_return
          parsed_fasta = Bio::FlatFile.new(Bio::FastaFormat, StringIO.new(fasta))
          parsed_fasta.entries
        end

        def lookup_random_fasta
          report = Bio::Blast::Report.new File.read(BLAST_RAW_FILE)
          random_hits = report.hits.sample(5)
          # ID is enclosed in [] at the beginning of the definition, extract
          ids = random_hits.map { |h| h.definition.scan(/^\[(.+)\]/)[0][0] }
          # Look up proteins in NCBI by ID and return them as FASTA
          results = Bio::NCBI::REST::EFetch.protein(ids, 'fasta')
          parsed_results = Bio::FlatFile.new(Bio::FastaFormat, StringIO.new(results))
          parsed_results.entries
        end
      end

      # Automatically run if running class directly. Based on https://stackoverflow.com/a/2249332/2333689
      Main.new.run if __FILE__ == $PROGRAM_NAME
    end
  end
end
