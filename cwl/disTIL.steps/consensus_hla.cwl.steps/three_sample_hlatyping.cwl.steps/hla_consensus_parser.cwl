cwlVersion: v1.2
class: CommandLineTool
label: hlahd-consensus-parser
doc: |-
  # About this tool
  This tool produces a consensus HLA type based on two or three sets of candidate alleles produced by running HLA-HD on any combination of tumour/normal WGS/WES/RNA-seq (e.g. tumour RNA-seq, normal WGS, tumour WGS) samples for a single patient.

  ## Before running this tool
  Before running this tool, you need to have obtained the HLA-HD results for two/three samples. You should use the 'final results' text files output by HLA-HD as inputs to this tool.

  ## Logic
  This tool compares the HLA types determined from three samples, and defines a 'consensus' type for each allele according to the following rules:
  - An allele must have at least 2-field (4-digit) accuracy in order to be considered, otherwise it is considered 'Not typed'.
  - If a 3-field allele (e.g. HLA-A*01:01:01) is an exact match across at least two samples, it is taken as the consensus type.
  - If there is no 3-field match across at least two samples, then the allele is truncated to 2-fields (e.g. HLA-A*01:01) and again compared between samples. If this 2-field allele is an exact match across at least two samples, then it is taken as the consensus type.
  - If there is inadequate support for an allele, it is set as 'No consensus'.

  Using the above logic, this tool only provides a consensus type for an allele if there is adequate support for it (i.e. exact match across at least two samples). These consensus types may be alleles with 2- or 3-field accuracy.  
  Note that if an allele is set as 'Not typed', this means HLA-HD was unsuccessful in typing the allele. If an allele is set as 'No consensus', it was typed by HLA-HD but there was insufficient evidence to call a consensus allele.

  ## Outputs
  There are 4 main outputs from this tool:
  - **HLA Consensus JSON:** a JSON file containing consensus alleles for **all typed HLA genes at the highest possible accuracy level** (two- or three-field).
  - **HLA Consensus Text File:** a text file containing all **unique consensus alleles** from all HLA genes which were successfully typed by HLA-HD for which a consensus could be determined (i.e. 'Not typed' and 'No consensus' alleles are removed). The alleles are truncated to two-field accuracy. This file can be used as input to pVACtools.
  - **Clinically Significant HLA Consensus JSON:** a JSON file containing consensus alleles for **a subset of clinically significant HLA genes (HLA-A, -B, -C, -DRA, -DRB1, -DRB3, -DRB4, -DRB5, -DQA1, -DQB1, -DPA1, -DPB1) at the highest possible accuracy level** (two- or three-field).
  - **Clinically Significant HLA Consensus Text File:** a text file containing all **unique consensus alleles** from the clinically significant subset of HLA genes(defined above) which were successfully typed by HLA-HD for which a consensus could be determined (i.e. 'Not typed' and 'No consensus' alleles are removed). The alleles are truncated to two-field accuracy. This file can be used as input to pVACtools.

  In addition, a JSON file is generated containing the two/three sets of input HLA-HD results in a format consistent with that of the consensus allele JSONs.

  ## Docker
  This tool uses the Docker image: `alanwucci/consensus_parser:1.0.0`.

  ## Documentation
  - [HLA-HD](https://www.genome.med.kyoto-u.ac.jp/HLA-HD/)
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: alanwucci/consensus_parser:1.0.0

inputs:
- id: tumour_dna
  label: Sample 1 HLA-HD Results
  doc: The final results text file produced by running HLA-HD on the tumour DNA sample.
  type: File
  inputBinding:
    prefix: -tumour
    position: 1
    shellQuote: false
  sbg:fileTypes: TXT
- id: tumour_rna
  label: Sample 3 HLA-HD Results
  doc: The final results text file produced by running HLA-HD on the tumour RNA sample.
  type: File?
  inputBinding:
    prefix: -rnaseq
    position: 3
    shellQuote: false
  sbg:fileTypes: TXT
- id: normal_dna
  label: Sample 2 HLA-HD Results
  doc: The final results text file produced by running HLA-HD on the normal DNA sample.
  type: File
  inputBinding:
    prefix: -germline
    position: 2
    shellQuote: false
  sbg:fileTypes: TXT
- id: sample_name
  label: Sample Name
  doc: The sample name used to name the output files.
  type: string
  inputBinding:
    position: 1
    shellQuote: false

outputs:
- id: clin_sig_json
  label: Clinically Significant HLA Genes Consensus JSON
  doc: |-
    A JSON file containing consensus alleles for the clinically significant classical HLA genes: A, B, C, DRB1, DQA1, DQB1, DPA1, DPB1.
  type: File
  outputBinding:
    glob: '*Sample_hla.consensus.clinSig.json'
  sbg:fileTypes: JSON
- id: filtered_txt
  label: HLA Consensus Text File
  doc: |-
    A text file containing a comma-separated list of consensus alleles for all typed HLA genes. Only includes alleles for which a consensus could be determined. All alleles are truncated to two-field accuracy. This file should be used as input for pVACseq.
  type: File
  outputBinding:
    glob: '*Sample_hla.consensus.trunc.txt'
  sbg:fileTypes: TXT
- id: tumour_dna_json
  label: Sample 1 HLA-HD Results JSON
  doc: HLA-HD final results obtained from sample 1 and represented in JSON format.
  type: File
  outputBinding:
    glob: '*tumour_hla.json'
  sbg:fileTypes: JSON
- id: consensus_json
  label: HLA Consensus JSON
  doc: A JSON file containing cosnensus alleles for all typed HLA genes.
  type: File
  outputBinding:
    glob: '*Sample_hla.consensus.json'
  sbg:fileTypes: JSON
- id: normal_dna_json
  label: Sample 2 HLA-HD Results JSON
  doc: HLA-HD final results obtained from sample 2 and represented in JSON format.
  type: File
  outputBinding:
    glob: '*germline_hla.json'
  sbg:fileTypes: JSON
- id: rna_json
  label: Sample 3 HLA-HD Results JSON
  doc: HLA-HD final results obtained from sample 3 and represented in JSON format.
  type: File?
  outputBinding:
    glob: '*rnaseq_hla.json'
  sbg:fileTypes: JSON
- id: clin_sig_txt
  label: Clinically Significant HLA Genes Consensus Text File
  doc: |-
    A text file containing a comma-separated list of consensus alleles for the clinically significant classical HLA genes: A, B, C, DRB1, DQA1, DQB1, DPA1, DPB1.. Only includes alleles for which a consensus could be determined. All alleles are truncated to two-field accuracy. This file should be used as input for pVACseq.
  type: File
  outputBinding:
    glob: '*Sample_hla.consensus.clinSig.trunc.txt'
  sbg:fileTypes: TXT

baseCommand:
- python3
- /app/hlahd_consensus_parser_v2.py
arguments:
- prefix: ''
  position: 4
  valueFrom: '> hla'
  separate: false
  shellQuote: false
id: mwonge/ccicb-distil/hla-consensus-parser/6
sbg:appVersion:
- v1.2
sbg:content_hash: a3dbf0ecf75ae1fb03fe689764a794a7f3358d659172e79b96948584fcaa5596f
sbg:contributors:
- alanwu
sbg:createdBy: alanwu
sbg:createdOn: 1645504927
sbg:id: mwonge/ccicb-distil/hla-consensus-parser/6
sbg:image_url:
sbg:latestRevision: 6
sbg:modifiedBy: alanwu
sbg:modifiedOn: 1657758473
sbg:project: mwonge/ccicb-distil
sbg:projectName: ccicb-distil
sbg:publisher: sbg
sbg:revision: 6
sbg:revisionNotes: ''
sbg:revisionsInfo:
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1645504927
  sbg:revision: 0
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.02.18. 
    Source: 
    repo: git@github.com:rbowenj/disTIL.git
    file: tools/hlahd-consensus-parser.cwl
    commit: d27541f
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1645591470
  sbg:revision: 1
  sbg:revisionNotes: change port names
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1645592624
  sbg:revision: 2
  sbg:revisionNotes: ''
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1645593269
  sbg:revision: 3
  sbg:revisionNotes: ''
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1657686876
  sbg:revision: 4
  sbg:revisionNotes: ''
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1657687551
  sbg:revision: 5
  sbg:revisionNotes: ''
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1657758473
  sbg:revision: 6
  sbg:revisionNotes: ''
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
sbg:wrapperAuthor: Rachel Bowen-James <rbowen-james@ccia.org.au>
