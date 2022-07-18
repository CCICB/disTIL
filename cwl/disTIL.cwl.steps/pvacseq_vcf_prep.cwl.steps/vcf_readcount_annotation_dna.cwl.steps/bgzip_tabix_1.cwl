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

requirements:
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: input_file
  label: Input File
  doc: An unzipped file to be bgzipped.
  type: File

outputs:
- id: index_file
  label: Index file
  doc: Index for the bgzipped file.
  type: File?
  outputSource:
  - tabix/index_file
- id: bgzipped_file
  label: Bgzipped File
  doc: Bgzipped version of the input file.
  type: File
  outputSource:
  - bgzip/bgzipped_file
- id: zipped_with_index
  label: Zipped File with Index
  doc: The bgzipped input file with its newly created index as a secondary file.
  type: File
  secondaryFiles:
  - .tbi
  outputSource:
  - tabix/zipped_with_index

steps:
- id: bgzip
  label: bgzip
  doc: Run bgzip compression on the input file.
  in:
  - id: input_file
    source: input_file
  run: bgzip_tabix_1.cwl.steps/bgzip.cwl
  out:
  - id: bgzipped_file
- id: tabix
  label: tabix
  doc: Run tabix to create an index of the bgzipped file.
  in:
  - id: input_file
    source: bgzip/bgzipped_file
  run: bgzip_tabix_1.cwl.steps/tabix.cwl
  out:
  - id: index_file
  - id: zipped_with_index
