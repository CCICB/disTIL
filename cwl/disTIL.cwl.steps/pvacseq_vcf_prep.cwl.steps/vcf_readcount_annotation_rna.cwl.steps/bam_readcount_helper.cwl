cwlVersion: v1.0
class: CommandLineTool
label: bam-readcount-helper
doc: |-
  # About bam-readcount
  Information about bam-readcount can be found [here](https://github.com/genome/bam-readcount).  
  bam-readcount is a tool which runs on a BAM/CRAM file and generates metrics at single nucleotide positions. These metrics can be useful for filtering out false positive variant calls.

  # About this CWL tool
  This CWL tool runs an edited version of the `bam_readcount_helper` (v1.1.1) script provided [here](https://github.com/genome/docker-bam_readcount_helper-cwl). The script generates a region list from a VCF, then runs bam-readcount v1.0.0 separately on SNVs and indels (using indel-centric mode `-i` for indels). It uses the Docker `rachelbj/bam-readcount` (based on `mgibio/bam_readcount_helper-cwl:1.1.1`).  
  **NOTE: the VCF must first be decomposed using `vt-decompose`.**

  ## Edits made
  The original script did not account for BAMs with references using the 'chr' chromosome prefix (e.g. 'chr1' for chromosome 1). The edited script used in this CWL tool checks the chromosome naming in the BAMfile using the `pysam.idxstats` function. If the 'chr' prefix is found in the BAMthen it is added to the region list passed to bam-readcount.

  ## Main inputs
  - BAMfor which to generate readcounts (must have index `.bai` available).
  - VCF of somatic variants called from the BAM.
  - Reference sequence in FASTA format. Note that this should be the same reference file used to generate the BAM.

  ## Outputs
  - Indel readcounts TSV.
  - SNV readcounts TSV.

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: rachelbj/bam-readcount:1.0.0

inputs:
- id: input_vcf
  label: Matched VCF
  doc: Variants called from the input BAM in VCF format.
  type: File
  inputBinding:
    position: 0
    shellQuote: false
- id: sample_name
  label: Sample Name
  doc: Name of the matched sample in the VCF file.
  type: string
  inputBinding:
    position: 1
    shellQuote: false
- id: reference_fasta
  label: Reference FASTA
  doc: Reference sequence in FASTA format (reference used to align the input BAM).
  type: File
  inputBinding:
    position: 2
    shellQuote: false
- id: input_bam
  label: Input BAM
  doc: |-
    BAM file to produce readcounts for. Must have associated index (`.bai`) available.
  type: File
  secondaryFiles:
  - .bai
  inputBinding:
    position: 3
    shellQuote: false
- id: data_type
  label: Data Type
  doc: Indicates whether the input BAM file contains DNA or RNA data.
  type:
    name: data_type
    type: enum
    symbols:
    - DNA
    - RNA
  inputBinding:
    position: 4
    shellQuote: false
- id: min_base_qual
  label: Minimum Base Quality
  doc: Minimum base quality at a position to use a read for counting.
  type: int?
  inputBinding:
    position: 5
    shellQuote: false
- id: min_mapping_qual
  label: Minimum Mapping Quality
  doc: Minimum mapping quality of reads used for counting.
  type: int?
  inputBinding:
    position: 6
    shellQuote: false

outputs:
- id: indel_readcount
  label: Indel Readcounts
  doc: TSV file containing indel readcounts.
  type: File
  outputBinding:
    glob: '*_bam_readcount_indel.tsv'
- id: snv_readcount
  label: SNV Readcounts
  doc: TSV file containing SNV readcounts.
  type: File
  outputBinding:
    glob: '*_bam_readcount_snv.tsv'

baseCommand:
- python
- /usr/bin/bam_readcount_helper_edited.py
arguments:
- prefix: ''
  position: 5
  valueFrom: ./
  separate: false
  shellQuote: false
id: bam_readcount_helper
