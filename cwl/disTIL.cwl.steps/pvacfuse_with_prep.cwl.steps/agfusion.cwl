cwlVersion: v1.2
class: CommandLineTool
label: agfusion
doc: |-
  # About this tool
  This tool runs **agfusion v1.2** to annotate gene fusions. This analysis is necessary prior to running pVACfuse.

  ## Reference Genome Build
  agfusion requires a reference genome database as input. Two release versions are available:
  - Release 87 for hg38
  - Release 75 for hg19
  As part of the analysis, this tool downloads the required database release (using the command `agfusion download -g <genome_build>`) based on the input reference genome build selected.

  ## Docker
  This tool uses the Docker image: `zlskidmore/agfusion:1.2`

  ## Documentation
  - [agfusion](https://github.com/murphycj/AGFusion)
  - [agfusion publication](https://www.biorxiv.org/content/10.1101/080903v1)

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: alanwucci/agfusion:1.0.1
- class: InlineJavascriptRequirement

inputs:
- id: fusion_tsv
  label: Fusion TSV
  doc: A TSV file containing fusion variant calls.
  type: File
  inputBinding:
    prefix: -f
    position: 1
    valueFrom: infile
    shellQuote: false
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
  inputBinding:
    prefix: -a
    position: 2
    shellQuote: false
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
  inputBinding:
    position: 0
    valueFrom: |-
      ${
          if (inputs.ref_genome == "hg38") {
              return '&& agfusion download -s homo_sapiens -r 87 -d .'
          } else if (inputs.ref_genome == "hg19") {
              return '&& agfusion download -s homo_sapiens -r 75 -d .'
          }
      }
    shellQuote: false

outputs:
- id: output_file
  label: AGFusion Output
  doc: AGFusion output (compressed)
  type: File
  outputBinding:
    glob: agfusion-output.tar.gz

baseCommand: []
arguments:
- prefix: -db
  position: 3
  valueFrom: |-
    ${
        if (inputs.ref_genome == "hg38") {
            return "agfusion.homo_sapiens.87.db"
        } else if (inputs.ref_genome == "hg19") {
            return "agfusion.homo_sapiens.75.db"
        }
    }
  shellQuote: false
- prefix: ''
  position: 4
  valueFrom: --middlestar
  separate: false
  shellQuote: false
- prefix: ''
  position: 5
  valueFrom: --noncanonical
  separate: false
  shellQuote: false
- prefix: -o
  position: 3
  valueFrom: ./agfusion-output
  shellQuote: false
- prefix: ''
  position: 0
  valueFrom: |-
    touch infile && if head -n 1 $(inputs.fusion_tsv.path) | grep 'est_J'; then cut -f1-3,6- $(inputs.fusion_tsv.path) > infile ; else cat $(inputs.fusion_tsv.path) > infile ; fi && head infile 1>&2
  shellQuote: false
- prefix: ''
  position: 1
  valueFrom: '&& agfusion batch'
  separate: false
  shellQuote: false
- prefix: ''
  position: 6
  valueFrom: "${\n    return '&& tar -czvf agfusion-output.tar.gz agfusion-output';\n\
    }"
  shellQuote: false
id: mwonge/ccicb-distil/agfusion/10
