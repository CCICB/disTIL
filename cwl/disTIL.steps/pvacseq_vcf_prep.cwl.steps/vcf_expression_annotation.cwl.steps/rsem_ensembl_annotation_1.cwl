cwlVersion: v1.0
class: CommandLineTool
label: rsem-ensembl-annotation
doc: |-
  # About this tool
  This tool uses R BioMart to convert HGNC symbols/RefSeq mRNA to Ensembl gene and transcript IDs. This is needed to prepare RSEM expression files prior to VCF expression annotation for pVACtools.

  ## Docker
  This tool uses the Docker image: `rachelbj/symbol_to_ensembl`
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: rachelbj/symbol_to_ensembl:latest

inputs:
- id: rsem_results
  type: File
  inputBinding:
    position: 3
    separate: false
    shellQuote: false

outputs:
- id: output
  type: File
  outputBinding:
    glob: '*_ensemblAnnot'

baseCommand: []
arguments:
- prefix: ''
  position: 2
  valueFrom: Rscript /app/RSEM_symbolToEnsembl.R
  separate: false
  shellQuote: false
id: mwonge/ccicb-distil/rsem-ensembl-annotation/0
sbg:appVersion:
- v1.0
sbg:content_hash: adb723a23bf738d86a25f5a0210fa6cef340b57e03b8e574d81a857e03f3f3f4a
sbg:contributors:
- alanwu
sbg:createdBy: alanwu
sbg:createdOn: 1650416129
sbg:id: mwonge/ccicb-distil/rsem-ensembl-annotation/0
sbg:image_url:
sbg:latestRevision: 0
sbg:modifiedBy: alanwu
sbg:modifiedOn: 1650416129
sbg:project: mwonge/ccicb-distil
sbg:projectName: ccicb-distil
sbg:publisher: sbg
sbg:revision: 0
sbg:revisionNotes: |-
  Uploaded using sbpack v2022.02.18. 
  Source: 
  repo: git@github.com:rbowenj/disTIL.git
  file: tools/rsem-ensembl-annotation.cwl
  commit: d27541f
sbg:revisionsInfo:
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1650416129
  sbg:revision: 0
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.02.18. 
    Source: 
    repo: git@github.com:rbowenj/disTIL.git
    file: tools/rsem-ensembl-annotation.cwl
    commit: d27541f
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
