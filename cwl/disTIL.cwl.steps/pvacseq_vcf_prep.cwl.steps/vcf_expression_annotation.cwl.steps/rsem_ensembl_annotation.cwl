cwlVersion: v1.0
class: CommandLineTool
label: rsem-ensembl-annotation
doc: |-
  # About this tool
  This tool uses R BioMart to convert HGNC symbols/RefSeq mRNA to Ensembl gene and transcript IDs. This is needed to prepare RSEM expression files prior to VCF expression annotation for pVACtools.

  ## Docker
  This tool uses the Docker image: `rachelbj/symbol_to_ensembl`

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
