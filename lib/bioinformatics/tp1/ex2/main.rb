# frozen_string_literal: true

require 'bio'
require_relative 'options'

module Bioinformatics
  module TP1
    module Ex2
      DIVIDER = "----------------------------------------------------------------------\n"
      HSP_DIVIDER = "\n\t******************************************************************\n"

      # Read a FASTA sequence and perform a BLAST search on it. Output resutls.
      class Main
        def run
          args = Options.new.parse
          searcher = build_searcher args
          ff = Bio::FlatFile.new(Bio::FastaFormat, args[:in])
          out = args[:out]
          ff.each_entry do |entry|
            puts "Performing BLAST search for #{entry.definition}..."
            report = searcher.query(entry.seq)
            hits = report.hits
            puts "Got #{hits.length} hits"
            out.puts "Results of BLAST search for #{entry.definition}"
            hits.each_with_index do |hit, _i|
              out.puts hit_to_s(hit)
            end
            out.puts DIVIDER unless hits.empty?
            File.write(File.join(__dir__, 'blast_raw.txt'), searcher.output)
          end
        end

        def build_searcher(args)
          method = args[:local] ? :local : :remote
          searcher_args = %w[blastp swissprot]
          Bio::Blast.public_send(method, *searcher_args)
        end

        def hit_to_s(hit)
          header = "Hit ##{hit.num}\n#{hit.hit_id}\n#{hit.accession} #{hit.definition}"
          body = ["Length: #{hit.len}"]
          # body << "Number of identities: #{hit.identity}"
          # body << "Length of Overlapping region: #{hit.overlap}"
          # body << "Query sequence:   #{hit.query_seq}"
          # body << "Subject sequence: #{hit.target_seq}"

          result = DIVIDER + header + "\n" + body.map { |line| "#{line}" }.join("\n")
          # Iterate over HSPs
          hit.each do |hsp|
            result << hsp_to_s(hsp)
          end

          result
        end

        def hsp_to_s(hsp)
          header = "HSP #{hsp.num}"
          body = ["Bit score: #{hsp.bit_score}"]
          body << "Score: #{hsp.score}"
          body << "E-value: #{hsp.evalue}"
          body << "Start in query: #{hsp.query_from}"
          body << "End in query: #{hsp.query_to}"
          body << "Start in subject: #{hsp.hit_from}"
          body << "End in subject: #{hsp.hit_to}"
          # body << "PHI-BLAST start: #{hsp.pattern_from}"
          # body << "PHI-BLAST end: #{hsp.pattern_to}"
          # body << "Translation frame of query: #{hsp.query_frame}"
          # body << "Translation frame of subject: #{hsp.hit_frame}"
          body << "Number of identities: #{hsp.identity}"
          body << "Number of positives: #{hsp.positive}"
          body << "Number of gaps: #{hsp.gaps}"
          body << "Alignment length: #{hsp.align_len}"
          # body << "Score density: #{hsp.density}"
          body << "Alignment string for query (with gaps):   #{hsp.qseq}"
          body << "Alignment string for subject (with gaps): #{hsp.hseq}"
          body << "Middle line:                              #{hsp.midline}"

          HSP_DIVIDER + "\t#{header}\n" + body.map { |line| "\t#{line}" }.join("\n") + HSP_DIVIDER
        end
      end

      # Automatically run if running class directly. Based on https://stackoverflow.com/a/2249332/2333689
      Main.new.run if __FILE__ == $PROGRAM_NAME
    end
  end
end
