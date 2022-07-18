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
$namespaces:
  sbg: https://sevenbridges.com

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
  sbg:fileTypes: TSV, RESULT
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
sbg:appVersion:
- v1.2
sbg:content_hash: a0c927f83f1d3a1e36b069d2c36316c8cba3d137c62940ab09f50dae83f2e99a4
sbg:contributors:
- alanwu
sbg:createdBy: alanwu
sbg:createdOn: 1645663682
sbg:id: mwonge/ccicb-distil/ipass-patient/1
sbg:image_url:
sbg:latestRevision: 1
sbg:modifiedBy: alanwu
sbg:modifiedOn: 1645672482
sbg:project: mwonge/ccicb-distil
sbg:projectName: ccicb-distil
sbg:publisher: sbg
sbg:revision: 1
sbg:revisionNotes: expression tsv are stored in .result suffix
sbg:revisionsInfo:
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1645663682
  sbg:revision: 0
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.02.18. 
    Source: 
    repo: git@github.com:rbowenj/disTIL.git
    file: tools/ipass-patient.cwl
    commit: d27541f
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1645672482
  sbg:revision: 1
  sbg:revisionNotes: expression tsv are stored in .result suffix
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
sbg:wrapperAuthor: Rachel Bowen-James <rbowen-james@ccia.org.au>
