cwlVersion: v1.0
class: Workflow
label: bgzip-tabix
doc: |-
  # About this tool
  This tool runs:
  1. bgzip compression of an input file
  2. tabix indexing of the bgzipped file

  # Documentation
  - [bgzip](http://www.htslib.org/doc/bgzip.html)
  - [tabix](http://www.htslib.org/doc/tabix.html)
$namespaces:
  sbg: https://www.sevenbridges.com/

requirements:
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: input_file
  label: Input File
  doc: An unzipped file to be bgzipped.
  type: File
  sbg:x: 0
  sbg:y: 60.5

outputs:
- id: index_file
  label: Index file
  doc: Index for the bgzipped file.
  type: File?
  outputSource:
  - tabix/index_file
  sbg:fileTypes: GZ.TBI
  sbg:x: 600.4171142578125
  sbg:y: 114
- id: bgzipped_file
  label: Bgzipped File
  doc: Bgzipped version of the input file.
  type: File
  outputSource:
  - bgzip/bgzipped_file
  sbg:fileTypes: GZ
  sbg:x: 343.84375
  sbg:y: 114
- id: zipped_with_index
  label: Zipped File with Index
  doc: The bgzipped input file with its newly created index as a secondary file.
  type: File
  secondaryFiles:
  - .tbi
  outputSource:
  - tabix/zipped_with_index
  sbg:fileTypes: GZ
  sbg:x: 600.5211181640625
  sbg:y: -68.5

steps:
- id: bgzip
  label: bgzip
  doc: Run bgzip compression on the input file.
  in:
  - id: input_file
    source: input_file
  run: bgzip_tabix_2.cwl.steps/bgzip.cwl
  out:
  - id: bgzipped_file
  sbg:x: 130.828125
  sbg:y: 60.5
- id: tabix
  label: tabix
  doc: Run tabix to create an index of the bgzipped file.
  in:
  - id: input_file
    source: bgzip/bgzipped_file
  run: bgzip_tabix_2.cwl.steps/tabix.cwl
  out:
  - id: index_file
  - id: zipped_with_index
  sbg:x: 343.84375
  sbg:y: 0
sbg:original_source: bgzip_tabix
