cwlVersion: v1.2
class: CommandLineTool
label: hla-report
doc: |-
  # About this tool

  This tool generates an HLA report from the output of disTIL HLA consensus HLA typing.
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: alanwucci/conshla_report:1.0.0
- class: InitialWorkDirRequirement
  listing:
  - $(inputs.clin_sig_hla)
  - $(inputs.full_hla)
- class: InlineJavascriptRequirement

inputs:
- id: full_hla
  label: HLA Consensus JSON
  doc: |-
    A JSON file containing all HLA consensus alleles. All HLA genes typed by HLA-HD are included at two- or three-field accuracies.
  type: File
  sbg:fileTypes: JSON
- id: clin_sig_hla
  label: Clinically Significant HLA Consensus JSON
  doc: |-
    A JSON file containing consensus alleles for the clinically significant classical HLA genes. Only classical Class-I and Class-II genes are included and all alleles are truncated to two-field accuracy.
  type: File
  sbg:fileTypes: JSON
- id: patient_id
  label: Patient ID
  doc: ID for the patient.
  type: string

outputs:
- id: hla_report
  label: HLA Report
  doc: A PDF report containing the HLA consensus results.
  type: File
  outputBinding:
    glob: "${\n    return inputs.patient_id + '_hlaReport.pdf'\n}"
  sbg:fileTypes: PDF

baseCommand: []
arguments:
- prefix: ''
  position: 2
  valueFrom: |-
    ${
        var cmd = 'Rscript -e "rmarkdown::render(\'hla_report_generator.Rmd\',params=list(full_hla_json=\'./' + inputs.full_hla.basename + '\', clin_hla_json=\'./' + inputs.clin_sig_hla.basename + '\', pid=\'' + inputs.patient_id + '\'), output_file=paste(\'' + inputs.patient_id + '\', \'_hlaReport.pdf\', sep=\'\'))\"'
        return cmd
    }
  shellQuote: false
- prefix: ''
  position: 10
  valueFrom: 1>&2
  shellQuote: false
- prefix: ''
  position: 0
  valueFrom: ' cp /hla_report_generator.Rmd . && ls 1>&2 &&'
  shellQuote: false
- prefix: ''
  position: 1
  valueFrom: |-
    echo "RES" 1>&2 && head $(inputs.full_hla.basename) 1>&2 && echo "CLIN" 1>&2 && head $(inputs.clin_sig_hla.basename) 1>&2 &&
  shellQuote: false
id: mwonge/ccicb-distil/hla-reports/2
sbg:appVersion:
- v1.2
sbg:content_hash: ac073dd379dc0fe16e1ac3ccea530840e2038862f755c891273305df91e081da3
sbg:contributors:
- alanwu
- mwonge
sbg:createdBy: mwonge
sbg:createdOn: 1642571935
sbg:id: mwonge/ccicb-distil/hla-reports/2
sbg:image_url:
sbg:latestRevision: 2
sbg:modifiedBy: alanwu
sbg:modifiedOn: 1654654389
sbg:project: mwonge/ccicb-distil
sbg:projectName: ccicb-distil
sbg:publisher: sbg
sbg:revision: 2
sbg:revisionNotes: ''
sbg:revisionsInfo:
- sbg:modifiedBy: mwonge
  sbg:modifiedOn: 1642571935
  sbg:revision: 0
  sbg:revisionNotes: Copy of mwonge/mwtest/hla-reports/12
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1654649734
  sbg:revision: 1
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.02.18. 
    Source: 
    repo: git@github.com:rbowenj/disTIL.git
    file: tools/hla-reports.cwl
    commit: d27541f
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1654654389
  sbg:revision: 2
  sbg:revisionNotes: ''
sbg:sbgMaintained: false
sbg:toolkit: disTIL
sbg:toolkitVersion: 1.0.0
sbg:validationErrors: []
sbg:workflowLanguage: CWL
sbg:wrapperAuthor: Rachel Bowen-James <rbowen-james@ccia.org.au>
