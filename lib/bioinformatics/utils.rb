module Bioinformatics
  # Various file- and lookup-related utilities.
  class Utils
    # Define "static" methods
    class << self

      # Extract UID from a BLAST report hit. This ID can be used in #ncbi_protein_lookup
      def extract_hit_id(hit)
        result = hit.accession
        unless result.index(':').nil? # : in accession means this isn't really an accession (eg. our blast_raw.txt)
          # ID is enclosed in [] at the beginning of the definition, extract.
          # The weird &.[] is a null-safe [0], see https://stackoverflow.com/questions/34794697/using-with-the-safe-navigation-operator-in-ruby
          result = hit.definition.scan(/^\[(.+)\]/)&.[](0)&.[](0)
        end
        result
      end

      # Look up proteins in NCBI by ID and return them as FASTA
      def ncbi_protein_lookup(ids)
        results = Bio::NCBI::REST::EFetch.protein(ids, 'fasta')
        parsed_results = Bio::FlatFile.new(Bio::FastaFormat, StringIO.new(results))
        parsed_results.entries
      end
    end
  end
end
