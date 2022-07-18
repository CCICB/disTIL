cwlVersion: v1.2
class: CommandLineTool
label: ipass-patient
doc: |-
  # About this tool
  This tool runs the IPASS gene expression classifier on a TSV of gene expression values output by an expression quantification algorithm (such as RSEM).

  ## Inputs
  - Patient ID: the ID of the patient being analysed. This is used to name output files.
  - Gene Expression TSV: a gene expression TSV produced by an expression quantification algorithm such as RSEM.
  - Gene ID Column Name: the name of the column containing gene IDs in the gene expression TSV.
  - Expression Value Column Name: the name of the column containing expression values (usually TPM) in the gene expression TSV.

  ## Docker
  This tool uses the Docker image `rachelbj/ipass-patient:1.0`

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: rachelbj/ipass-patient:1.0
- class: InlineJavascriptRequirement

inputs:
- id: patient_id
  label: Patient ID
  doc: The patient ID for the sample being analysed.
  type: string
  inputBinding:
    position: 0
    separate: false
    shellQuote: false
- id: gene_expr_file
  label: Gene Expression File
  doc: A TSV output by an expression quantification algorithm (e.g. RSEM).
  type: File
  inputBinding:
    position: 1
    separate: false
    shellQuote: false
- id: gene_col
  label: Gene ID Column Name
  doc: Name of the column in the gene expression TSV containing gene IDs. E.g. gene_id
  type: string
  inputBinding:
    position: 3
    separate: false
    shellQuote: false
- id: expr_col
  label: Gene Expression Column Name
  doc: |-
    Name of the column in the gene expression TSV containing expression values. E.g. TPM
  type: string
  inputBinding:
    position: 4
    separate: false
    shellQuote: false

outputs:
- id: ipass_score_file
  type: File
  outputBinding:
    glob: $(inputs.patient_id)_IPASS.txt

baseCommand: []
arguments:
- prefix: ''
  position: 0
  valueFrom: Rscript /app/patientIPASS.R
  separate: false
  shellQuote: false
id: mwonge/ccicb-distil/ipass-patient/1
