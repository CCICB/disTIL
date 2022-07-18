cwlVersion: v1.2
class: CommandLineTool
label: pvacfuse
doc: |-
  # About this tool
  This tool contains CWL from [the pVACtools authors](https://github.com/genome/analysis-workflows/blob/master/definitions/tools/pvacfuse.cwl), using pVACtools version 2.0.3.

  ## Edits
  Changes made to the original CWL provided by the pVACtools authors include:
  - The allele input is now a text file (rather than an array). The text file should contain a string of comma-separated, single-quoted alleles, e.g. `'HLA-A*02:01','HLA-A*11:01','HLA-B*01:02','HLA-B*01:02''`
  - The output directory is now named `pvacfuse_<sample_name>`.
  - The Docker image has been updated to use pVACtools 2.0.3 (rather than 2.0.1)

  ## Docker
  This tool uses the Docker image: `griffithlab/pvactools:2.0.3`.

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
- id: input_file
  type: File
- id: sample_name
  type: string
  inputBinding:
    position: 20
    shellQuote: false
- id: alleles
  label: HLA Alleles
  doc: |-
    A text file containing the HLA alleles for this sample as a comma separated string.
  type: File
  inputBinding:
    position: 21
    valueFrom: $(String(self.contents))
    shellQuote: false
  loadContents: true
- id: prediction_algorithms
  type: string[]
  inputBinding:
    position: 22
    shellQuote: false
- id: epitope_lengths_class_i
  type: int[]?
  inputBinding:
    prefix: -e1
    position: 3
    itemSeparator: ','
    shellQuote: false
- id: epitope_lengths_class_ii
  type: int[]?
  inputBinding:
    prefix: -e2
    position: 4
    itemSeparator: ','
    shellQuote: false
- id: binding_threshold
  type: int?
  inputBinding:
    prefix: -b
    position: 5
    shellQuote: false
- id: percentile_threshold
  type: int?
  inputBinding:
    prefix: --percentile-threshold
    position: 6
    shellQuote: false
- id: iedb_retries
  type: int?
  inputBinding:
    prefix: -r
    position: 7
    shellQuote: false
- id: keep_tmp_files
  type: boolean?
  inputBinding:
    prefix: -k
    position: 8
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
    position: 9
    shellQuote: false
- id: netmhc_stab
  type: boolean?
  inputBinding:
    prefix: --netmhc-stab
    position: 10
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
    position: 11
    shellQuote: false
- id: net_chop_threshold
  type: float?
  inputBinding:
    prefix: --net-chop-threshold
    position: 12
    shellQuote: false
- id: run_reference_proteome_similarity
  type: boolean?
  inputBinding:
    prefix: --run-reference-proteome-similarity
    position: 13
    shellQuote: false
- id: additional_report_columns
  type:
  - 'null'
  - name: additional_report_columns
    type: enum
    symbols:
    - sample_name
  inputBinding:
    prefix: -a
    position: 14
    shellQuote: false
- id: fasta_size
  type: int?
  inputBinding:
    prefix: -s
    position: 15
    shellQuote: false
- id: downstream_sequence_length
  type: string?
  inputBinding:
    prefix: -d
    position: 16
    shellQuote: false
- id: exclude_nas
  type: boolean?
  inputBinding:
    prefix: --exclude-NAs
    position: 17
    shellQuote: false
- id: n_threads
  type: int?
  default: 8
  inputBinding:
    prefix: --n-threads
    position: 18
    shellQuote: false

outputs:
- id: mhc_i_all_epitopes
  type: File?
  outputBinding:
    glob: |-
      pvacfuse_$(inputs.sample_name)/MHC_Class_I/$(inputs.sample_name).all_epitopes.tsv
- id: mhc_i_aggregated_report
  type: File?
  outputBinding:
    glob: |-
      pvacfuse_$(inputs.sample_name)/MHC_Class_I/$(inputs.sample_name).all_epitopes.aggregated.tsv
- id: mhc_i_filtered_epitopes
  type: File?
  outputBinding:
    glob: $(inputs.sample_name)_pvacfuse_i.filtered.tsv
- id: mhc_ii_all_epitopes
  type: File?
  outputBinding:
    glob: |-
      pvacfuse_$(inputs.sample_name)/MHC_Class_II/$(inputs.sample_name).all_epitopes.tsv
- id: mhc_ii_aggregated_report
  type: File?
  outputBinding:
    glob: |-
      pvacfuse_$(inputs.sample_name)/MHC_Class_II/$(inputs.sample_name).all_epitopes.aggregated.tsv
- id: mhc_ii_filtered_epitopes
  type: File?
  outputBinding:
    glob: $(inputs.sample_name)_pvacfuse_ii.filtered.tsv
- id: combined_all_epitopes
  type: File?
  outputBinding:
    glob: pvacfuse_$(inputs.sample_name)/combined/$(inputs.sample_name).all_epitopes.tsv
- id: combined_aggregated_report
  type: File?
  outputBinding:
    glob: |-
      pvacfuse_$(inputs.sample_name)/combined/$(inputs.sample_name).all_epitopes.aggregated.tsv
- id: combined_filtered_epitopes
  type: File?
  outputBinding:
    glob: pvacfuse_$(inputs.sample_name)/combined/$(inputs.sample_name).filtered.tsv
- id: mhc_i
  type: Directory?
  outputBinding:
    glob: pvacfuse_$(inputs.sample_name)/MHC_Class_I
    loadListing: deep_listing
- id: mhc_ii
  type: Directory?
  outputBinding:
    glob: pvacfuse_$(inputs.sample_name)/MHC_Class_II
    loadListing: deep_listing
- id: pvacfuse_predictions
  type: Directory?
  outputBinding:
    glob: pvacfuse_$(inputs.sample_name)
    loadListing: deep_listing

baseCommand: []
arguments:
- prefix: ''
  position: 23
  valueFrom: pvacfuse_$(inputs.sample_name)
  shellQuote: false
- prefix: ''
  position: 1
  valueFrom: "${\n    return ' && tar -xf ' + inputs.input_file.path;\n}"
  shellQuote: false
- prefix: ''
  position: 0
  valueFrom: "${\n    return 'ln -s $TMPDIR /tmp/pvacseq && export TMPDIR=/tmp/pvacseq\
    \ ';\n}"
  shellQuote: false
- prefix: ''
  position: 2
  valueFrom: |-
    ${
        return ' && /usr/local/bin/pvacfuse run --iedb-install-directory /opt/iedb';
    }
  shellQuote: false
- prefix: ''
  position: 19
  valueFrom: "${\n    \n    return inputs.input_file.basename.replace('.tar.gz', '')\n\
    }"
  shellQuote: false
- prefix: ''
  position: 23
  valueFrom: |-
    && cp pvacfuse_$(inputs.sample_name)/MHC_Class_I/$(inputs.sample_name).filtered.tsv $(inputs.sample_name)_pvacfuse_i.filtered.tsv
  shellQuote: false
- prefix: ''
  position: 24
  valueFrom: |-
    && cp pvacfuse_$(inputs.sample_name)/MHC_Class_II/$(inputs.sample_name).filtered.tsv $(inputs.sample_name)_pvacfuse_ii.filtered.tsv
  shellQuote: false

hints:
  value: c5.4xlarge;ebs-gp2;1024
id: mwonge/ccicb-distil/pvacfuse/10
