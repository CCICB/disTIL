class: Workflow
cwlVersion: v1.0
id: restricted_reads_hlahd
doc: >-
  # About this workflow

  This workflow runs fast HLA typing by restricting reads to those aligning with
  the HLA region prior to running HLA-HD.  

  Aligning the input FASTQs to a reference containing only the HLA region, then
  converting the mapped reads back to FASTQs allows us to restrict the reads
  used by HLA-HD to only those which are critically relevant to HLA typing.
  While it is optimal to provide all reads to HLA-HD, the runtime is
  prohibitively long. In our testing, this full read restriction method
  (including HLA-HD) has been shown to take approximately two thirds of the time
  taken to run HLA-HD alone on unrestricted reads.


  ## Before running this workflow

  Prior to running this workflow, you must create/download a Bowtie2 Index
  (generated using `bowtie2 build`) for a reference file **which only includes
  the HLA region on chromosome 6**. We recommend using the HLA region reference
  `hla_gen.fasta` provided by IMGT. It can be downloaded from the IMGT GitHub
  repo [here](https://github.com/ANHIG/IMGTHLA/tree/Latest/fasta) or using this
  download link
  [ftp://ftp.ebi.ac.uk/pub/databases/ipd/imgt/hla/hla_gen.fasta](ftp://ftp.ebi.ac.uk/pub/databases/ipd/imgt/hla/hla_gen.fasta).
  The Bowtie2 Index files must then be archived using the `tar` command before
  being used as the Bowtie2 Index Archive input to this workflow.  

  **A Bowtie2 index archive for `hla_gen.fasta` can be downloaded from the
  disTIL repo to be used as an input for this workflow. The corresponding
  Bowtie2 Index Prefix parameter should be `hla_gen`.**


  ## Steps

  This workflow follows the steps recommended by the HLA-HD authors
  [here](https://www.genome.med.kyoto-u.ac.jp/HLA-HD/) under the subheadings
  Tips > Filtering of reads (March 6, 2019).

  1. Use `bowtie2` to map the input paired-end FASTQs to the HLA reference
  sequence (provided as the Bowtie2 Index Archive).

  2. Use `samtools view` to extract mapped reads (using option `-F 4`).

  3. Use `samtools fastq` to convert the BAM of aligned HLA reads to paired-end
  FASTQs.

  4. Run HLA-HD using the new, smaller FASTQs (containing only those reads which
  aligned to the HLA region) as input.


  ## Documentation

  - [HLA-HD docs](https://www.genome.med.kyoto-u.ac.jp/HLA-HD/)

  - [HLA-HD publication](https://pubmed.ncbi.nlm.nih.gov/28419628/)

  - [Bowtie2](https://github.com/BenLangmead/bowtie2)
label: restricted-reads-hlahd
$namespaces:
  sbg: 'https://sevenbridges.com'
inputs:
  - id: sample_name
    type: string
    label: Patient ID
    doc: Patient ID to be used for naming the output SAM.
    'sbg:x': 0
    'sbg:y': 0
  - id: read2_sequences
    'sbg:fileTypes': 'FASTQ, FASTQ.GZ, FASTA, FASTA.GZ, FA, FA.GZ, FQ, FQ.GZ'
    type: File
    label: Read 2 Sequences
    doc: Read 2 sequences in FASTA or FASTQ format (may be bgzipped).
    'sbg:x': 0
    'sbg:y': 106.578125
  - id: read1_sequences
    'sbg:fileTypes': 'FASTQ, FASTQ.GZ, FASTA, FASTA.GZ, FA, FA.GZ, FQ, FQ.GZ'
    type: File
    label: Read 1 Sequences
    doc: Read 1 sequences in FASTA or FASTQ format (may be bgzipped).
    'sbg:x': 0
    'sbg:y': 213.15625
  - id: bowtie2_index_prefix
    type: string
    label: Bowtie2 Index Prefix
    doc: >-
      The prefix of index files contained in the Bowtie2 index TAR. Note that
      all Bowtie2 nidex files in the TAR should have this prefix.
    'sbg:x': 0
    'sbg:y': 426.203125
  - id: bowtie2_index
    'sbg:fileTypes': TAR
    type: File
    label: Bowtie2 Index Archive
    doc: >-
      A TAR archive containing Bowtie2 index files. For the purposes of speeding
      up HLA-HD, this should be an archive of Bowtie2 index files for an HLA
      region reference, such as `hla_gen` provided by the IMGT.
    'sbg:x': 0
    'sbg:y': 532.5625
  - id: output_prefix
    type: string?
    label: HLA-HD Output Prefix
    doc: Optional prefix for HLA-HD output files and directory.
    'sbg:x': 0
    'sbg:y': 319.734375
outputs:
  - id: hla_fastq_reads1
    outputSource:
      - samtools_fastq_1/output_fastq_2
    'sbg:fileTypes': FASTQ
    type: File
    label: HLA Reads 1
    doc: >-
      A FASTQ file containing end 1 reads which were found to align to the HLA
      region.
    'sbg:x': 1095.0543212890625
    'sbg:y': 372.6953125
  - id: hla_fastq_reads2
    outputSource:
      - samtools_fastq_1/output_fastq_1
    'sbg:fileTypes': FASTQ
    type: File
    label: HLA Reads 2
    doc: >-
      A FASTQ file containing end 2 reads which were found to align to the HLA
      region.
    'sbg:x': 1095.0543212890625
    'sbg:y': 266.3359375
  - id: hlahd_output
    outputSource:
      - hla_hd_1/hlahd_results
    type: Directory
    label: HLA-HD Output
    doc: Directory containing all HLA-HD output files.
    'sbg:x': 1407.3223876953125
    'sbg:y': 213.046875
  - id: hlahd_final
    outputSource:
      - hla_hd_1/hlahd_final_results
    'sbg:fileTypes': TXT
    type: File
    label: HLA-HD Final Results File
    doc: The final results text file produced by HLA-HD.
    'sbg:x': 1407.3223876953125
    'sbg:y': 319.515625
steps:
  - id: bowtie2
    in:
      - id: bowtie2_index
        source: bowtie2_index
      - id: read1_sequences
        source: read1_sequences
      - id: read2_sequences
        source: read2_sequences
      - id: no_unaligned
        default: true
      - id: sample_name
        source: sample_name
      - id: bowtie2_index_prefix
        source: bowtie2_index_prefix
    out:
      - id: aligned_sam
    run: ../tools/bowtie2.cwl
    label: bowtie2
    doc: Run Bowtie2 alignment of input FASTQs to an HLA region reference.
    'sbg:x': 216.125
    'sbg:y': 238.3359375
  - id: samtools_view
    in:
      - id: output_format
        default: BAM
      - id: input_alignment
        source: bowtie2/aligned_sam
      - id: fast_bam_compression
        default: true
      - id: exclude_reads_any
        default: '4'
    out:
      - id: output_alignment
    run: ../tools/samtools-view.cwl
    label: samtools-view
    'sbg:x': 533.77783203125
    'sbg:y': 266.3359375
  - id: samtools_fastq_1
    in:
      - id: input_alignment
        source: samtools_view/output_alignment
    out:
      - id: output_fastq_1
      - id: output_fastq_2
    run: ../tools/samtools-fastq.cwl
    label: samtools-fastq
    'sbg:x': 799.46533203125
    'sbg:y': 259.2265625
  - id: hla_hd_1
    in:
      - id: threads
        default: 2
      - id: minimum_read_length
        default: 0
      - id: fastq_reads1
        source: samtools_fastq_1/output_fastq_1
      - id: fastq_reads2
        source: samtools_fastq_1/output_fastq_2
      - id: sample_id
        source: sample_name
      - id: output_prefix
        source: output_prefix
    out:
      - id: hlahd_results
      - id: hlahd_final_results
    run: ../tools/hla-hd.cwl
    label: hla-hd
    'sbg:x': 1095.0543212890625
    'sbg:y': 138.9765625
requirements: []
'sbg:appVersion':
  - v1.0
  - 'sbg:draft-2'
'sbg:content_hash': add6652eda2ac4c569b525e4c85d8cd2500558ff2e60ade0ddf04069a9625d109
'sbg:latestRevision': 3
'sbg:publisher': sbg
'sbg:revisionsInfo':
  - 'sbg:modifiedBy': rbowen_james
    'sbg:modifiedOn': 1624947026
    'sbg:revision': 0
    'sbg:revisionNotes': null
  - 'sbg:modifiedBy': rbowen_james
    'sbg:modifiedOn': 1626325746
    'sbg:revision': 1
    'sbg:revisionNotes': null
  - 'sbg:modifiedBy': rbowen_james
    'sbg:modifiedOn': 1626351035
    'sbg:revision': 2
    'sbg:revisionNotes': null
  - 'sbg:modifiedBy': rbowen_james
    'sbg:modifiedOn': 1626393722
    'sbg:revision': 3
    'sbg:revisionNotes': null
'sbg:toolAuthor': Rachel Bowen-James <rbowen-james@ccia.org.au>
'sbg:wrapperAuthor': Rachel Bowen-James <rbowen-james@ccia.org.au>
