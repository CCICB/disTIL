cwlVersion: v1.2
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
  sbg: https://sevenbridges.com

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
  sbg:fileTypes: GZ.TBI, VCF.GZ.TBI
  sbg:x: 600.4171142578125
  sbg:y: 114
- id: bgzipped_file
  label: Bgzipped File
  doc: Bgzipped version of the input file.
  type: File
  outputSource:
  - bgzip/bgzipped_file
  sbg:fileTypes: GZ, VCF.GZ
  sbg:x: 343.84375
  sbg:y: 114
- id: zipped_with_index
  label: Zipped File with Index
  doc: The bgzipped input file with its newly created index as a secondary file.
  type: File
  secondaryFiles:
  - pattern: .tbi
    required: false
  outputSource:
  - tabix/zipped_with_index
  sbg:fileTypes: GZ, VCF.GZ
  sbg:x: 600.5211181640625
  sbg:y: -68.5

steps:
- id: bgzip
  label: bgzip
  doc: Run bgzip compression on the input file.
  in:
  - id: input_file
    source: input_file
  run: bgzip_tabix_4.cwl.steps/bgzip.cwl
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
  run: bgzip_tabix_4.cwl.steps/tabix.cwl
  out:
  - id: index_file
  - id: zipped_with_index
  sbg:x: 343.84375
  sbg:y: 0
sbg:appVersion:
- v1.2
- v1.0
sbg:content_hash: ae8adaab7d431cdb49a351fbe23b63c4afce8dbd0414463cafd8679406238fc9c
sbg:contributors:
- alanwu
sbg:createdBy: alanwu
sbg:createdOn: 1645754358
sbg:id: mwonge/ccicb-distil/bgzip-tabix/1
sbg:image_url: |-
  https://cavatica.sbgenomics.com/ns/brood/images/mwonge/ccicb-distil/bgzip-tabix/1.png
sbg:latestRevision: 1
sbg:modifiedBy: alanwu
sbg:modifiedOn: 1645754629
sbg:original_source: mwonge/ccicb-distil/bgzip-tabix/1
sbg:project: mwonge/ccicb-distil
sbg:projectName: ccicb-distil
sbg:publisher: sbg
sbg:revision: 1
sbg:revisionNotes: add output suffix of vcf.gz
sbg:revisionsInfo:
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1645754358
  sbg:revision: 0
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.02.18. 
    Source: 
    repo: git@github.com:rbowenj/disTIL.git
    file: workflows/bgzip-tabix.cwl
    commit: d27541f
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1645754629
  sbg:revision: 1
  sbg:revisionNotes: add output suffix of vcf.gz
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
