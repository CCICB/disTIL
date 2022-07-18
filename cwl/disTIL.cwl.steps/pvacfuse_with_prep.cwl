cwlVersion: v1.2
class: Workflow
label: pvacfuse-with-prep
doc: |-
  # About this workflow
  This workflow runs all pVACfuse input file preparation steps followed by pVACfuse prediction of neoepitopes.

  ## Steps
  1. `agfusion` - for more details, this tool can be found in the repo.
  2. `pvacfuse` v2.0.4

requirements:
- class: LoadListingRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: fusion_tsv
  label: Fusion TSV
  doc: A TSV file containing fusion variant calls.
  type: File
- id: alleles
  label: HLA Alleles
  doc: |-
    A text file containing the HLA alleles for this sample as a comma separated string.
  type: File
- id: sample_name
  type: string
- id: ref_genome
  label: Reference Genome Build
  doc: |-
    The referece genome build used to generate the fusion variant calls. This is used to determine which agfusion database to use (release 87 or 75).
  type:
    name: ref_genome
    type: enum
    symbols:
    - hg38
    - hg19
- id: fusion_caller
  label: Fusion Caller
  doc: The name of the algorithm used to generate the input Fusion TSV.
  type:
    name: fusion_caller
    type: enum
    symbols:
    - starfusion
    - jaffa
    - bellerophontes
    - breakfusion
    - chimerascan
    - chimerscope
    - defuse
    - ericscript
    - fusioncatcher
    - fusionhunter
    - fusionmap
    - fusioninspector
    - infusion
    - mapsplice
    - tophatfusion
- id: n_threads
  type: int?
- id: net_chop_method
  type:
  - 'null'
  - name: net_chop_method
    type: enum
    symbols:
    - cterm
    - 20s
- id: prediction_algorithms
  type: string[]
- id: epitope_lengths_class_i
  type: int[]?
- id: epitope_lengths_class_ii
  type: int[]?
- id: binding_threshold
  type: int?
- id: percentile_threshold
  type: int?
- id: iedb_retries
  type: int?
- id: keep_tmp_files
  type: boolean?
- id: netmhc_stab
  type: boolean?
- id: top_score_metric
  type:
  - 'null'
  - name: top_score_metric
    type: enum
    symbols:
    - lowest
    - median
- id: net_chop_threshold
  type: float?
- id: run_reference_proteome_similarity
  type: boolean?
- id: additional_report_columns
  type:
  - 'null'
  - name: additional_report_columns
    type: enum
    symbols:
    - sample_name
- id: fasta_size
  type: int?
- id: downstream_sequence_length
  type: string?
- id: exclude_nas
  type: boolean?

outputs:
- id: pvacfuse_predictions
  type: Directory?
  outputSource:
  - pvacfuse_1/pvacfuse_predictions
- id: mhc_ii_filtered_epitopes
  type: File?
  outputSource:
  - pvacfuse_1/mhc_ii_filtered_epitopes
- id: mhc_i_filtered_epitopes
  type: File?
  outputSource:
  - pvacfuse_1/mhc_i_filtered_epitopes

steps:
- id: agfusion
  label: agfusion
  in:
  - id: fusion_tsv
    source: fusion_tsv
  - id: fusion_caller
    source: fusion_caller
  - id: ref_genome
    source: ref_genome
  run: pvacfuse_with_prep.cwl.steps/agfusion.cwl
  out:
  - id: output_file
- id: pvacfuse_1
  label: pvacfuse
  in:
  - id: input_file
    source: agfusion/output_file
  - id: sample_name
    source: sample_name
  - id: alleles
    source: alleles
  - id: prediction_algorithms
    source:
    - prediction_algorithms
  - id: epitope_lengths_class_i
    source:
    - epitope_lengths_class_i
  - id: epitope_lengths_class_ii
    source:
    - epitope_lengths_class_ii
  - id: binding_threshold
    source: binding_threshold
  - id: percentile_threshold
    source: percentile_threshold
  - id: iedb_retries
    source: iedb_retries
  - id: keep_tmp_files
    source: keep_tmp_files
  - id: net_chop_method
    source: net_chop_method
  - id: netmhc_stab
    source: netmhc_stab
  - id: top_score_metric
    source: top_score_metric
  - id: net_chop_threshold
    source: net_chop_threshold
  - id: run_reference_proteome_similarity
    source: run_reference_proteome_similarity
  - id: additional_report_columns
    source: additional_report_columns
  - id: fasta_size
    source: fasta_size
  - id: downstream_sequence_length
    source: downstream_sequence_length
  - id: exclude_nas
    source: exclude_nas
  - id: n_threads
    source: n_threads
  run: pvacfuse_with_prep.cwl.steps/pvacfuse_1.cwl
  out:
  - id: mhc_i_all_epitopes
  - id: mhc_i_aggregated_report
  - id: mhc_i_filtered_epitopes
  - id: mhc_ii_all_epitopes
  - id: mhc_ii_aggregated_report
  - id: mhc_ii_filtered_epitopes
  - id: combined_all_epitopes
  - id: combined_aggregated_report
  - id: combined_filtered_epitopes
  - id: mhc_i
  - id: mhc_ii
  - id: pvacfuse_predictions
