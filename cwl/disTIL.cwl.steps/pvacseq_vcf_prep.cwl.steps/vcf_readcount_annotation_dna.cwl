cwlVersion: v1.2
class: Workflow
label: vcf-readcount-annotation
doc: |-
  # About this workflow
  This workflow runs readcount annotation of a VCF. This is part of the file preparation process for pVACseq.  
  The following tool versions are used in this workflow:
  - bam-readcount-helper v1.1.1 (uses bam-readcount v1.0.0)
  - vatools vcf-readcount-annotator v5.0.1


  ## Inputs and parameters
  To run this workflow, you will need:
  - **Input VCF:** An input VCF to be annotated with readcounts. Note that this VCF should be decomposed prior to running this analysis (see vt-decompose).
  - **Sample Name:** The name of the sample to annotate in the input VCF. Note that this string must exactly match the sample name in the VCF.
  -  **Input BAM:** An input BAM containing DNA or RNA data for the sample to be annotated.
  - **Reference Genome:** The reference genome FASTA used to generate the input BAM.
  - **Genomic Data Type:** The data type contained in the intput BAM (either DNA or RNA). Note that this parameter determines whether the DNA or RNA readcount fields will be annotated in the VCF.

  Optionally, you can include minimum base quality, minimum mapping wuality, and an interval string for use in running bam-readcount. For more information, see the bam-readcount documentation (below).

  ## Steps
  This workflow runs the following steps:
  1. Generates SNV and indel readcounts from a BAM using **bam-readcount** via an adapted version of the bam-readcount-helper from mgibio.
  2. Annotates the VCF with SNV readcounts using **vatools vcf-readcount-annotator**.
  2. Annotates the VCF with indel readcounts using **vatools vcf-readcount-annotator**.

  ## Outputs
  Depending on the data type (DNA/RNA) and variant type (SNV/indel/all), the following extensions are added to the annotated output file name:
  - `dsr`: **D**NA **S**NV **r**eadcounts
  - `dir`: **D**NA **i**ndel **r**eadcounts
  - `dr`: **D**NA **r**eadcounts (SNVs and indels)
  - `rsr`: **R**NA **S**NV **r**eadcounts
  - `rir`: **R**NA **i**ndel **r**eadcounts
  - `rr`: **R**NA **r**eadcounts (SNVs and indels)

  ## Documentation
  - [bam-readcount](https://github.com/genome/bam-readcount)
  - [bam-readcount-helper](https://github.com/genome/docker-bam_readcount_helper-cwl)
  - [vatools vcf-readcount-annotator](https://vatools.readthedocs.io/en/latest/vcf_readcount_annotator.html)

requirements:
- class: SubworkflowFeatureRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: sample_name
  label: Sample Name
  doc: Name of the sample to annotate in the VCF.
  type: string
- id: data_type
  label: Genomic Data Type
  doc: |-
    Either DNA or RNA, depending on whether the input BAM file contains DNA or RNA data.
  type:
  - 'null'
  - name: data_type
    type: enum
    symbols:
    - DNA
    - RNA
- id: input_vcf
  label: Input VCF
  doc: |-
    The VCF to annotate with readcounts. Note that this VCF should be decomposed prior to running this workflow (see vt-decompose).
  type: File
  secondaryFiles:
  - pattern: .tbi
    required: true
- id: reference_fasta
  label: Reference FASTA
  doc: Reference sequence in FASTA format (reference used to align the input BAM).
  type: File
- id: input_bam_cram
  label: Input BAM/CRAM
  doc: |-
    BAM/CRAM file to produce readcounts for. Must have associated index (`.bai` or `.crai`) available.
  type: File

outputs:
- id: snv_indel_annot_zipped
  label: SNV and Indel Annotated VCF
  doc: VCF annotated with SNV and indel readcounts from the input BAM.
  type: File
  secondaryFiles:
  - pattern: .tbi
    required: false
  outputSource:
  - bgzip_tabix_2/zipped_with_index
- id: snv_readcount
  label: SNV Readcounts
  doc: TSV file containing SNV readcounts.
  type: File
  outputSource:
  - bam_readcount_helper_1/snv_readcount
- id: indel_readcount
  label: Indel Readcounts
  doc: TSV file containing indel readcounts.
  type: File
  outputSource:
  - bam_readcount_helper_1/indel_readcount

steps:
- id: snv_readcount_annot
  label: readcount-annot-snv
  doc: VAtools annotation of the input VCF with SNV readcounts.
  in:
  - id: input_vcf
    source: input_vcf
  - id: bam_readcount_file
    source: bam_readcount_helper_1/snv_readcount
  - id: sample_name
    source: sample_name
  - id: variant_type
    default: snv
  - id: data_type
    source: data_type
  run: vcf_readcount_annotation_dna.cwl.steps/snv_readcount_annot.cwl
  out:
  - id: annotated_vcf
- id: bgzip_tabix_1
  label: bgzip-tabix
  in:
  - id: input_file
    source: snv_readcount_annot/annotated_vcf
  run: vcf_readcount_annotation_dna.cwl.steps/bgzip_tabix_1.cwl
  out:
  - id: index_file
  - id: bgzipped_file
  - id: zipped_with_index
- id: indel_readcount_annot
  label: readcount-annot-indel
  doc: VAtools annotation of the input VCF with indel readcounts.
  in:
  - id: input_vcf
    source: bgzip_tabix_1/zipped_with_index
  - id: bam_readcount_file
    source: bam_readcount_helper_1/indel_readcount
  - id: sample_name
    source: sample_name
  - id: variant_type
    default: indel
  - id: data_type
    source: data_type
  run: vcf_readcount_annotation_dna.cwl.steps/indel_readcount_annot.cwl
  out:
  - id: annotated_vcf
- id: bgzip_tabix_2
  label: bgzip-tabix
  in:
  - id: input_file
    source: indel_readcount_annot/annotated_vcf
  run: vcf_readcount_annotation_dna.cwl.steps/bgzip_tabix_2.cwl
  out:
  - id: index_file
  - id: bgzipped_file
  - id: zipped_with_index
- id: bam_readcount_helper_1
  label: bam-readcount-helper
  in:
  - id: input_vcf
    source: input_vcf
  - id: sample_name
    source: sample_name
  - id: reference_fasta
    source: reference_fasta
  - id: input_bam_cram
    source: input_bam_cram
  - id: data_type
    source: data_type
  run: vcf_readcount_annotation_dna.cwl.steps/bam_readcount_helper_1.cwl
  out:
  - id: indel_readcount
  - id: snv_readcount
