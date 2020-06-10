# Exercise 2a
Read a FASTA sequence and perform a local or remote BLAST search on it.
Output results. Regardless of output, also write the raw result XML
file in this directory (used in other exercises).
By default, uses [sequence from exercise 1](https://github.com/lipusal/bioinformatics/blob/master/lib/bioinformatics/tp1/ex1/NM_002049.gbk)
(translated and converted to FASTA).

## Dependencies
For local BLAST search, the **old** [unsupported](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download)
blast suite (NOT the current blast+ suite) must be installed and present in the PATH.
BioRuby uses the `blastall` binary which is not bundled in the new blast+ suite, that's
why local search doesn't work by default (see https://github.com/lipusal/bioinformatics/issues/1)
