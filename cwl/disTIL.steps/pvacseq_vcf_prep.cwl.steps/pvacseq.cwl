cwlVersion: v1.2
class: CommandLineTool
label: pvacseq
doc: |-
  # About this tool
  This tool contains CWL from [the pVACtools team](https://github.com/genome/analysis-workflows/blob/master/definitions/tools/pvacseq.cwl), using pVACtools version 2.0.4.

  ## Edits
  Changes made to the original CWL provided by the pVACtools team include:
  - The allele input is now a text file (rather than an array). The text file should contain a string of comma-separated, single-quoted alleles, e.g. `'HLA-A*02:01','HLA-A*11:01','HLA-B*01:02','HLA-B*01:02''`
  - The output directory is now named `pvacseq_<sample_name>`.
  - The Docker image has been updated to use pVACtools 2.0.3 (rather than 2.0.1)

  ## Docker
  This tool uses the Docker image: `griffithlab/pvactools:2.0.3`.
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: LoadListingRequirement
- class: ResourceRequirement
  coresMin: $(inputs.n_threads)
  ramMin: 16000
- class: DockerRequirement
  dockerPull: griffithlab/pvactools:2.0.7
- class: InlineJavascriptRequirement

inputs:
- id: additional_report_columns
  type:
  - 'null'
  - name: additional_report_columns
    type: enum
    symbols:
    - sample_name
  inputBinding:
    prefix: -a
    position: 0
    shellQuote: false
- id: allele_specific_binding_thresholds
  type: boolean?
  inputBinding:
    prefix: --allele-specific-binding-thresholds
    position: 0
    shellQuote: false
- id: alleles
  label: HLA Alleles
  doc: |-
    A text file containing the HLA alleles for this sample as a comma separated string.
  type: File
  inputBinding:
    prefix: ''
    position: 3
    valueFrom: $(String(self.contents))
    separate: false
    shellQuote: false
  loadContents: true
  sbg:fileTypes: TXT
- id: binding_threshold
  type: int?
  inputBinding:
    prefix: -b
    position: 0
    shellQuote: false
- id: downstream_sequence_length
  type: string?
  inputBinding:
    prefix: -d
    position: 0
    shellQuote: false
- id: epitope_lengths_class_i
  type: int[]?
  inputBinding:
    prefix: -e1
    position: 0
    itemSeparator: ','
    shellQuote: false
- id: epitope_lengths_class_ii
  type: int[]?
  inputBinding:
    prefix: -e2
    position: 0
    itemSeparator: ','
    shellQuote: false
- id: exclude_nas
  type: boolean?
  inputBinding:
    prefix: --exclude-NAs
    position: 0
    shellQuote: false
- id: expn_val
  type: float?
  inputBinding:
    prefix: --expn-val
    position: 0
    shellQuote: false
- id: fasta_size
  type: int?
  inputBinding:
    prefix: -s
    position: 0
    shellQuote: false
- id: iedb_retries
  type: int?
  inputBinding:
    prefix: -r
    position: 0
    shellQuote: false
- id: input_vcf
  type: File
  secondaryFiles:
  - pattern: .tbi
    required: true
  inputBinding:
    position: 1
    shellQuote: false
- id: keep_tmp_files
  type: boolean?
  inputBinding:
    prefix: -k
    position: 0
    shellQuote: false
- id: maximum_transcript_support_level
  type:
  - 'null'
  - name: maximum_transcript_support_level
    type: enum
    symbols:
    - '1'
    - '2'
    - '3'
    - '4'
    - '5'
  inputBinding:
    prefix: --maximum-transcript-support-level
    position: 0
    shellQuote: false
- id: minimum_fold_change
  type: float?
  inputBinding:
    prefix: -c
    position: 0
    shellQuote: false
- id: n_threads
  type: int?
  default: 8
  inputBinding:
    prefix: --n-threads
    position: 0
    shellQuote: false
- id: net_chop_method
  type:
  - 'null'
  - name: net_chop_method
    type: enum
    symbols:
    - cterm
    - 20s
  inputBinding:
    prefix: --net-chop-method
    position: 0
    shellQuote: false
- id: net_chop_threshold
  type: float?
  inputBinding:
    prefix: --net-chop-threshold
    position: 0
    shellQuote: false
- id: netmhc_stab
  type: boolean?
  inputBinding:
    prefix: --netmhc-stab
    position: 0
    shellQuote: false
- id: normal_cov
  type: int?
  inputBinding:
    prefix: --normal-cov
    position: 0
    shellQuote: false
- id: normal_sample_name
  type: string?
  inputBinding:
    prefix: --normal-sample-name
    position: 0
    shellQuote: false
- id: normal_vaf
  type: float?
  inputBinding:
    prefix: --normal-vaf
    position: 0
    shellQuote: false
- id: percentile_threshold
  type: int?
  inputBinding:
    prefix: --percentile-threshold
    position: 0
    shellQuote: false
- id: phased_proximal_variants_vcf
  type: File?
  secondaryFiles:
  - pattern: .tbi
    required: true
  inputBinding:
    prefix: -p
    position: 0
    shellQuote: false
- id: prediction_algorithms
  type: string[]
  inputBinding:
    position: 4
    shellQuote: false
- id: run_reference_proteome_similarity
  type: boolean?
  inputBinding:
    prefix: --run-reference-proteome-similarity
    position: 0
    shellQuote: false
- id: sample_name
  type: string
  inputBinding:
    position: 2
    shellQuote: false
- id: tdna_cov
  type: int?
  inputBinding:
    prefix: --tdna-cov
    position: 0
    shellQuote: false
- id: tdna_vaf
  type: float?
  inputBinding:
    prefix: --tdna-vaf
    position: 0
    shellQuote: false
- id: top_score_metric
  type:
  - 'null'
  - name: top_score_metric
    type: enum
    symbols:
    - lowest
    - median
  inputBinding:
    prefix: -m
    position: 0
    shellQuote: false
- id: trna_cov
  type: int?
  inputBinding:
    prefix: --trna-cov
    position: 0
    shellQuote: false
- id: trna_vaf
  type: float?
  inputBinding:
    prefix: --trna-vaf
    position: 0
    shellQuote: false

outputs:
- id: combined_aggregated_report
  type: File?
  outputBinding:
    glob: |-
      pvacseq_$(inputs.sample_name)/combined/$(inputs.sample_name).all_epitopes.aggregated.tsv
- id: combined_all_epitopes
  type: File?
  outputBinding:
    glob: pvacseq_$(inputs.sample_name)/combined/$(inputs.sample_name).all_epitopes.tsv
- id: combined_filtered_epitopes
  type: File?
  outputBinding:
    glob: pvacseq_$(inputs.sample_name)/combined/$(inputs.sample_name).filtered.tsv
- id: mhc_i_aggregated_report
  type: File?
  outputBinding:
    glob: |-
      pvacseq_$(inputs.sample_name)/MHC_Class_I/$(inputs.sample_name).all_epitopes.aggregated.tsv
- id: mhc_i_all_epitopes
  type: File?
  outputBinding:
    glob: pvacseq_$(inputs.sample_name)/MHC_Class_I/$(inputs.sample_name).all_epitopes.tsv
- id: mhc_i_filtered_epitopes
  type: File?
  outputBinding:
    glob: $(inputs.sample_name)_pvacseq_i.filtered.tsv
- id: mhc_ii_aggregated_report
  type: File?
  outputBinding:
    glob: |-
      pvacseq_$(inputs.sample_name)/MHC_Class_I/$(inputs.sample_name).all_epitopes.aggregated.tsv
- id: mhc_ii_all_epitopes
  type: File?
  outputBinding:
    glob: |-
      pvacseq_$(inputs.sample_name)/MHC_Class_II/$(inputs.sample_name).all_epitopes.tsv
- id: mhc_ii_filtered_epitopes
  type: File?
  outputBinding:
    glob: $(inputs.sample_name)_pvacseq_ii.filtered.tsv
- id: pvacseq_predictions
  type: Directory
  outputBinding:
    glob: pvacseq_$(inputs.sample_name)
    loadListing: deep_listing

baseCommand:
- ln
- -s
arguments:
- position: 0
  valueFrom: $TMPDIR
  shellQuote: false
- /tmp/pvacseq
- position: 0
  valueFrom: ' && '
  shellQuote: false
- export
- TMPDIR=/tmp/pvacseq
- position: 0
  valueFrom: ' && '
  shellQuote: false
- /usr/local/bin/pvacseq
- run
- --iedb-install-directory
- /opt/iedb
- --pass-only
- prefix: ''
  position: 5
  valueFrom: pvacseq_$(inputs.sample_name)
  shellQuote: true
- prefix: ''
  position: 5
  valueFrom: |-
    && cp pvacseq_$(inputs.sample_name)/MHC_Class_I/$(inputs.sample_name).filtered.tsv $(inputs.sample_name)_pvacseq_i.filtered.tsv
  shellQuote: false
- prefix: ''
  position: 6
  valueFrom: |-
    && cp pvacseq_$(inputs.sample_name)/MHC_Class_II/$(inputs.sample_name).filtered.tsv $(inputs.sample_name)_pvacseq_ii.filtered.tsv
  shellQuote: false
id: mwonge/ccicb-distil/pvacseq/5
sbg:appVersion:
- v1.2
sbg:content_hash: a806038e4ca4adf4f07b89b9a200d4262a21ce5b6d97ee5da3b2313ccbd04f899
sbg:contributors:
- alanwu
sbg:createdBy: alanwu
sbg:createdOn: 1645661907
sbg:id: mwonge/ccicb-distil/pvacseq/5
sbg:image_url:
sbg:latestRevision: 5
sbg:modifiedBy: alanwu
sbg:modifiedOn: 1657867204
sbg:project: mwonge/ccicb-distil
sbg:projectName: ccicb-distil
sbg:publisher: sbg
sbg:revision: 5
sbg:revisionNotes: ''
sbg:revisionsInfo:
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1645661907
  sbg:revision: 0
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.02.18. 
    Source: 
    repo: git@github.com:rbowenj/disTIL.git
    file: tools/pvacseq.cwl
    commit: (uncommitted file)
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1650603140
  sbg:revision: 1
  sbg:revisionNotes: Update to the latest pvactools
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1650605712
  sbg:revision: 2
  sbg:revisionNotes: pvactools 3.0.0 is not backward compatible, reverting to 2.0.7
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1657761339
  sbg:revision: 3
  sbg:revisionNotes: ''
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1657772738
  sbg:revision: 4
  sbg:revisionNotes: ''
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1657867204
  sbg:revision: 5
  sbg:revisionNotes: ''
sbg:sbgMaintained: false
sbg:toolAuthor: GriffithLab
sbg:toolkit: pvactools
sbg:toolkitVersion: 2.0.3
sbg:validationErrors: []
sbg:workflowLanguage: CWL
sbg:wrapperAuthor: GriffithLab
