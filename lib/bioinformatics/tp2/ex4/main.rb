# frozen_string_literal: true

require 'bio'
require_relative 'options'
require_relative '../../utils'

module Bioinformatics
  module TP2
    module Ex4
      # Read a BLAST report XML (eg. ex 2 output) and search for a pattern in results. Lookup full FASTA
      # sequences from matching hits in NCBI, and output.
      class Main
        def run
          args = Options.new.parse
          report = Bio::Blast.reports(args[:in])[0]
          out = args[:out]
          puts "Finding \"#{args[:pattern]}\" in #{report.hits.length} hits"

          pattern_regex = Regexp.compile(args[:pattern], Regexp::IGNORECASE)
          matching_hits = report.hits.select do |entry|
            pattern_regex.match?(entry.accession) ||
              pattern_regex.match?(entry.definition) ||
              entry.hsps.map(&:hseq).select { |sequence| pattern_regex.match? sequence }.any?
          end
          puts "Found #{matching_hits.length} matches"
          exit 0 if matching_hits.empty?

          ids = matching_hits
                .map { |h| Utils.extract_hit_id h }
                .reject(&:nil?)
                .uniq
          puts "#{ids.length} matching hits with valid IDs"
          exit 0 if ids.empty?

          puts 'Looking up sequences in NCBI...'
          puts if out == STDOUT
          entries = Utils.ncbi_protein_lookup(ids)
          out.puts entries.map(&:to_s).join "\n"
        end
      end

      # Automatically run if running class directly. Based on https://stackoverflow.com/a/2249332/2333689
      Main.new.run if __FILE__ == $PROGRAM_NAME
    end
  end
end
