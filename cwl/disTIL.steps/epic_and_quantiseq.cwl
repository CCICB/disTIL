cwlVersion: v1.0
class: CommandLineTool
label: immunedeconv
doc: |-
  # About this tool
  This tool runs EPIC and quanTIseq immune cell type deconvolution on a TSV output by an expression quantification algorithm (e.g. RSEM). The R package `immunedeconv` is used to run EPIC and quanTIseq.

  ## Inputs
  - Patient ID: the ID of the patient being analysed. This is used to name output files.
  - Gene Expression TSV: a gene expression TSV produced by an expression quantification algorithm such as RSEM.
  - Gene ID Column Name: the name of the column containing gene IDs in the gene expression TSV.
  - Expression Value Column Name: the name of the column containing expression values (usually TPM) in the gene expression TSV.

  ## Docker
  This tool uses the Docker image: `rachelbj/immunedeconv:1.0`

  ## Documentation
  - [immunedeconv](https://icbi-lab.github.io/immunedeconv/articles/immunedeconv.html)
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: rachelbj/immunedeconv:1.0
- class: InlineJavascriptRequirement
  expressionLib:
  - |2-

    var setMetadata = function(file, metadata) {
        if (!('metadata' in file))
            file['metadata'] = metadata;
        else {
            for (var key in metadata) {
                file['metadata'][key] = metadata[key];
            }
        }
        return file
    };

    var inheritMetadata = function(o1, o2) {
        var commonMetadata = {};
        if (!Array.isArray(o2)) {
            o2 = [o2]
        }
        for (var i = 0; i < o2.length; i++) {
            var example = o2[i]['metadata'];
            for (var key in example) {
                if (i == 0)
                    commonMetadata[key] = example[key];
                else {
                    if (!(commonMetadata[key] == example[key])) {
                        delete commonMetadata[key]
                    }
                }
            }
        }
        if (!Array.isArray(o1)) {
            o1 = setMetadata(o1, commonMetadata)
        } else {
            for (var i = 0; i < o1.length; i++) {
                o1[i] = setMetadata(o1[i], commonMetadata)
            }
        }
        return o1;
    };

inputs:
- id: gene_expr
  label: Gene Expression TSV
  doc: A TSV containing gene expression values for the given patient.
  type: File
  inputBinding:
    position: 1
    separate: false
    shellQuote: false
    loadContents: true
  sbg:fileTypes: TSV
- id: patient_id
  label: Patient ID
  doc: ID of the patient, used to name output files.
  type: string
  inputBinding:
    position: 0
    separate: false
    shellQuote: false
- id: gene_col
  label: Gene ID Column Name
  doc: Name of the column in the gene expression TSV containing gene IDs.
  type: string
  inputBinding:
    position: 2
    separate: false
    shellQuote: false
- id: expr_col
  label: Expression Value Column Label
  doc: Name of the column in the gene expression TSV containing expression values.
  type: string
  inputBinding:
    position: 3
    separate: false
    shellQuote: false

outputs:
- id: epic_deconv
  label: EPIC Deconvolution Results
  doc: A TSV file containing the results of EPIC deconvolution.
  type: File
  outputBinding:
    glob: '*_epic.tsv'
    outputEval: $(inheritMetadata(self, inputs.gene_expr))
  sbg:fileTypes: TSV
- id: quanitseq_deconv
  label: quanTIseq Deconvolution Results
  doc: A TSV file containing the results of quanTIseq deconvolution.
  type: File
  outputBinding:
    glob: '*_quantiseq.tsv'
    outputEval: $(inheritMetadata(self, inputs.gene_expr))
  sbg:fileTypes: TSV

baseCommand: []
arguments:
- prefix: ''
  position: 0
  valueFrom: Rscript /app/immunedeconv.R
  separate: false
  shellQuote: false
id: mwonge/ccicb-distil/epic_and_quantiseq/0
sbg:appVersion:
- v1.0
sbg:content_hash: a69ef3e82519d04462361fe178b57ba260c0b4249a5a9bfa6ac76c6c0d9162ba8
sbg:contributors:
- alanwu
sbg:createdBy: alanwu
sbg:createdOn: 1654745306
sbg:id: mwonge/ccicb-distil/epic_and_quantiseq/0
sbg:image_url:
sbg:latestRevision: 0
sbg:modifiedBy: alanwu
sbg:modifiedOn: 1654745306
sbg:project: mwonge/ccicb-distil
sbg:projectName: ccicb-distil
sbg:publisher: sbg
sbg:revision: 0
sbg:revisionNotes: |-
  Uploaded using sbpack v2022.02.18. 
  Source: 
  repo: git@github.com:rbowenj/disTIL.git
  file: tools/immunedeconv.cwl
  commit: d27541f
sbg:revisionsInfo:
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1654745306
  sbg:revision: 0
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.02.18. 
    Source: 
    repo: git@github.com:rbowenj/disTIL.git
    file: tools/immunedeconv.cwl
    commit: d27541f
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
sbg:wrapperAuthor: Rachel Bowen-James <rbowen-james@ccia.org.au>
