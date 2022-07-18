cwlVersion: v1.2
class: CommandLineTool
label: distil-report
doc: |-
  # About this tool
  This tool generates a disTIL HTML report using the outputs of disTIL's analysis modules.

  ## Inputs
  - HLA JSON file
  - pVACseq MHC-I Filtered Report
  - pVACseq MHC-II Filtered Report
  - pVACfuse MHC-I STAR Annotated Filtered Report
  - pVACfuse MHC-II STAR Annotated Filtered Report
  - TMB (string)
  - Number of coding missense variants (string)
  - EPIC Deconvolution TSV
  - quanTIseq Deconvolution TSV
  - IPASS TSV
  - Patient ID

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: alanwucci/distil_report:1.0.0
- class: InitialWorkDirRequirement
  listing:
  - $(inputs.hla_json)
  - $(inputs.pvacseq_i)
  - $(inputs.pvacseq_ii)
  - $(inputs.pvacfuse_i)
  - $(inputs.pvacfuse_ii)
  - $(inputs.ipass)
  - $(inputs.epic_deconv)
  - $(inputs.quant_deconv)
- class: InlineJavascriptRequirement

inputs:
- id: hla_json
  label: HLA Consensus JSON
  doc: |-
    A JSON file containing all HLA consensus alleles. All HLA genes typed by HLA-HD are included at two- or three-field accuracies.
  type: File
- id: patient_id
  label: Patient ID
  doc: ID for the patient.
  type: string
- id: pvacseq_i
  type: File
- id: pvacseq_ii
  type: File
- id: pvacfuse_i
  type: File
- id: pvacfuse_ii
  type: File
- id: coding_missense_variants
  type: int
- id: tmb
  type: float
- id: ipass
  type: File
- id: epic_deconv
  type: File
- id: quant_deconv
  type: File

outputs:
- id: disTIL_report
  label: disTIL Report
  doc: A PDF report containing the disTIL results
  type: File
  outputBinding:
    glob: "${\n    return inputs.patient_id + '_distilReport.html'\n}"

baseCommand: []
arguments:
- prefix: ''
  position: 2
  valueFrom: |-
    ${
        var cmd = 'Rscript -e "rmarkdown::render(\'report_generator.Rmd\',params=list(hla_json=\'./' + inputs.hla_json.basename + '\', pvacseq_i=\'./' + inputs.pvacseq_i.basename + '\', pvacseq_ii=\'./' + inputs.pvacseq_ii.basename + '\', pvacfuse_i=\'./' + inputs.pvacfuse_i.basename + '\', pvacfuse_ii=\'./' + inputs.pvacfuse_ii.basename + '\', tmb=\'' + inputs.tmb + '\', coding_missense_variants=\'' + inputs.coding_missense_variants + '\', ipass=\'' + inputs.ipass.basename + '\',  epic_deconv=\'' + inputs.epic_deconv.basename + '\', quantiseq_deconv=\'' + inputs.quant_deconv.basename +  '\', pid=\'' + inputs.patient_id + '\'), output_file=paste(\'' + inputs.patient_id + '\', \'_distilReport.html\', sep=\'\'))\"'
        return cmd
    }
  shellQuote: false
- prefix: ''
  position: 10
  valueFrom: 1>&2
  shellQuote: false
- prefix: ''
  position: 0
  valueFrom: ' cp /report_generator.Rmd . &&  cp /report_styles.css . && ls 1>&2 &&'
  shellQuote: false
id: mwonge/ccicb-distil/distil-report/8
