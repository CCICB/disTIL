cwlVersion: v1.2
class: Workflow
label: pvacfuse-with-prep
doc: |-
  # About this workflow
  This workflow runs all pVACfuse input file preparation steps followed by pVACfuse prediction of neoepitopes.

  ## Steps
  1. `agfusion` - for more details, this tool can be found in the repo.
  2. `pvacfuse` v2.0.4
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: LoadListingRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: fusion_tsv
  label: Fusion TSV
  doc: A TSV file containing fusion variant calls.
  type: File
  sbg:fileTypes: TSV
  sbg:x: -1618.6866455078125
  sbg:y: 332.6002197265625
- id: alleles
  label: HLA Alleles
  doc: |-
    A text file containing the HLA alleles for this sample as a comma separated string.
  type: File
  sbg:fileTypes: TXT
  sbg:x: -1376.59423828125
  sbg:y: 783.7005004882812
- id: sample_name
  type: string
  sbg:x: -1393.3961181640625
  sbg:y: -76.48631286621094
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
  sbg:x: -1618.4769287109375
  sbg:y: 210.04147338867188
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
  sbg:x: -1620
  sbg:y: 467.1532897949219
- id: n_threads
  type: int?
  sbg:x: -1387.7987060546875
  sbg:y: 392.7198181152344
- id: net_chop_method
  type:
  - 'null'
  - name: net_chop_method
    type: enum
    symbols:
    - cterm
    - 20s
  sbg:x: -1383.1981201171875
  sbg:y: 243.8373565673828
- id: prediction_algorithms
  type: string[]
  sbg:x: -1387.7987060546875
  sbg:y: 98.79871368408203
- id: epitope_lengths_class_i
  type: int[]?
  sbg:exposed: true
- id: epitope_lengths_class_ii
  type: int[]?
  sbg:exposed: true
- id: binding_threshold
  type: int?
  sbg:exposed: true
- id: percentile_threshold
  type: int?
  sbg:exposed: true
- id: iedb_retries
  type: int?
  sbg:exposed: true
- id: keep_tmp_files
  type: boolean?
  sbg:exposed: true
- id: netmhc_stab
  type: boolean?
  sbg:exposed: true
- id: top_score_metric
  type:
  - 'null'
  - name: top_score_metric
    type: enum
    symbols:
    - lowest
    - median
  sbg:exposed: true
- id: net_chop_threshold
  type: float?
  sbg:exposed: true
- id: run_reference_proteome_similarity
  type: boolean?
  sbg:exposed: true
- id: additional_report_columns
  type:
  - 'null'
  - name: additional_report_columns
    type: enum
    symbols:
    - sample_name
  sbg:exposed: true
- id: fasta_size
  type: int?
  sbg:exposed: true
- id: downstream_sequence_length
  type: string?
  sbg:exposed: true
- id: exclude_nas
  type: boolean?
  sbg:exposed: true

outputs:
- id: pvacfuse_predictions
  type: Directory?
  outputSource:
  - pvacfuse_1/pvacfuse_predictions
  sbg:x: -663.812744140625
  sbg:y: -71.52864074707031
- id: mhc_ii_filtered_epitopes
  type: File?
  outputSource:
  - pvacfuse_1/mhc_ii_filtered_epitopes
  sbg:x: -670.5581665039062
  sbg:y: 251.44444274902344
- id: mhc_i_filtered_epitopes
  type: File?
  outputSource:
  - pvacfuse_1/mhc_i_filtered_epitopes
  sbg:x: -684.5581665039062
  sbg:y: 438.1111145019531

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
  sbg:x: -1384
  sbg:y: 556.2817993164062
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
  sbg:x: -1073.682861328125
  sbg:y: 371.8523864746094
sbg:appVersion:
- v1.2
sbg:content_hash: a061aa2a12a1c877cd911eaa2b25ab5f3fa1972f11b5ad1e10972494b9487d4ac
sbg:contributors:
- alanwu
sbg:createdBy: alanwu
sbg:createdOn: 1651557270
sbg:id: mwonge/ccicb-distil/pvacfuse-with-prep/9
sbg:image_url: |-
  https://cavatica.sbgenomics.com/ns/brood/images/mwonge/ccicb-distil/pvacfuse-with-prep/9.png
sbg:latestRevision: 9
sbg:modifiedBy: alanwu
sbg:modifiedOn: 1657867102
sbg:original_source: mwonge/ccicb-distil/pvacfuse-with-prep/9
sbg:project: mwonge/ccicb-distil
sbg:projectName: ccicb-distil
sbg:publisher: sbg
sbg:revision: 9
sbg:revisionNotes: ''
sbg:revisionsInfo:
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1651557270
  sbg:revision: 0
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.02.18. 
    Source: 
    repo: git@github.com:rbowenj/disTIL.git
    file: workflows/pvacfuse-with-prep.cwl
    commit: d27541f
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1651557795
  sbg:revision: 1
  sbg:revisionNotes: latest pvacfuse and agfusion
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1651622251
  sbg:revision: 2
  sbg:revisionNotes: simplified output
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1651627042
  sbg:revision: 3
  sbg:revisionNotes: make inputs as ports for batch task creation
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1654744601
  sbg:revision: 4
  sbg:revisionNotes: ''
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1654749053
  sbg:revision: 5
  sbg:revisionNotes: ''
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1656557749
  sbg:revision: 6
  sbg:revisionNotes: ''
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1657761057
  sbg:revision: 7
  sbg:revisionNotes: ''
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1657772575
  sbg:revision: 8
  sbg:revisionNotes: ''
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1657867102
  sbg:revision: 9
  sbg:revisionNotes: ''
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
