cwlVersion: v1.0
class: CommandLineTool
label: vatools-expression-annotation
doc: |-
  # About this tool
  This tool runs VAtools expression annotation (v5.0.1) to add genome or transcript level expression values to a VCF file.  

  ## RNA expression values
  Genome and transcript level expression values in TSV format must be generated before running this analysis. Any expression quantification algorithm can be used to generate these values, but note that:
  - If you use a tool other than Kallisto, Stringtie or Cufflinks, you need to specify the names of the columns containing gene/transcript IDs and expression values.
  - The expression values must be in TSV file format.
  - The gene/transcript ID format used must match that in the VCF. **Given that this workflow is likely to be run after VEP annotation with Ensembl IDs (as an input for pVACseq), it is recommended that IDs are converted to Ensembl format prior to running this analysis (tool provided in this repo).**

  ## Output
  If the expression level is 'gene', then the output annotated VCF will have the added extension `gx`.  
  If the expression level is 'transcript', then the output annotated VCF will have the added extension `tx`.  


  ## Docker
  This tool uses the Docker image [griffithlab/vatools:5.0.1](https://hub.docker.com/r/griffithlab/vatools).

  ## Documentation
  - [VAtools](https://vatools.readthedocs.io/en/latest/vcf_expression_annotator.html)
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: griffithlab/vatools:5.0.1
- class: InlineJavascriptRequirement

inputs:
- id: input_vcf
  label: Input VCF
  doc: The VCF to annotate with expression values.
  type: File
  secondaryFiles:
  - .tbi
  inputBinding:
    position: 0
    shellQuote: false
  sbg:fileTypes: VCF.GZ
- id: expression_file
  label: Expression File
  doc: |-
    The TSV file containing gene or transcript level expression values determined from RNA using the expression quantification algorithm.
  type: File
  inputBinding:
    position: 1
    shellQuote: false
  sbg:fileTypes: TSV
- id: quant_algo
  label: Expression Quantification Algorithm
  doc: |-
    The expression quantification algorithm used to generate the expression file. Note that if 'custom' is selected, then the ID and expression columns must be provided as parameters.
  type:
    name: quant_algo
    type: enum
    symbols:
    - kallisto
    - stringtie
    - cufflinks
    - custom
  inputBinding:
    position: 2
    shellQuote: false
- id: expression_level
  label: Expression Level
  doc: |-
    Either 'gene' or 'transcript', depending on the level at which expression values are quantified in the expression file.
  type:
    name: expression_level
    type: enum
    symbols:
    - gene
    - transcript
  inputBinding:
    position: 3
    shellQuote: false
- id: id_column
  label: ID Column Name
  doc: |-
    The name of the column containing gene or transcript IDs in the expression file. Note that these IDs must be in the same format as IDs in the VCF (i.e. Ensembl, RefSeq)
  type: string?
  inputBinding:
    prefix: --id-column
    position: 4
    shellQuote: false
- id: expression_column
  label: Expression Column Name
  doc: |-
    The name of the column containing expression values (usually in TPM) in the expression file.
  type: string?
  inputBinding:
    prefix: --expression-column
    position: 5
    shellQuote: false
- id: sample_name
  label: Sample Name
  doc: Name of the sample to be annotated in the VCF file.
  type: string
  inputBinding:
    prefix: --sample-name
    position: 5
    shellQuote: false

outputs:
- id: exp_annotated_vcf
  type: File
  outputBinding:
    glob: |-
      ${
          if (inputs.expression_level == 'gene') {
              return "*.gx.vcf"
          } else {
              return "*.tx.vcf"
          }
      }

baseCommand:
- vcf-expression-annotator
arguments:
- prefix: ''
  position: 6
  valueFrom: --ignore-ensembl-id-version
  separate: false
  shellQuote: false
- prefix: --output-vcf
  position: 4
  valueFrom: |-
    ${
        var full = inputs.input_vcf.path
        var split_full = full.split('/')
        var base = split_full[split_full.length -1]
        var split_base = base.split('vcf')
        
        if (inputs.expression_level == 'gene') {
            return split_base[0] + 'gx.vcf'
        } else {
            return split_base[0] + 'tx.vcf'
        }
    }
  shellQuote: false
id: mwonge/ccicb-distil/vcf-expression-annotation/0
sbg:appVersion:
- v1.0
sbg:content_hash: a1c3b411909695a2a978e2a3b2daff02bed5342da2518d9a62ffb4e3fe163109b
sbg:contributors:
- alanwu
sbg:createdBy: alanwu
sbg:createdOn: 1650340083
sbg:id: mwonge/ccicb-distil/vcf-expression-annotation/0
sbg:image_url:
sbg:latestRevision: 0
sbg:modifiedBy: alanwu
sbg:modifiedOn: 1650340083
sbg:project: mwonge/ccicb-distil
sbg:projectName: ccicb-distil
sbg:publisher: sbg
sbg:revision: 0
sbg:revisionNotes: |-
  Uploaded using sbpack v2022.02.18. 
  Source: 
  repo: git@github.com:rbowenj/disTIL.git
  file: tools/vatools-expression-annotation.cwl
  commit: d27541f
sbg:revisionsInfo:
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1650340083
  sbg:revision: 0
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.02.18. 
    Source: 
    repo: git@github.com:rbowenj/disTIL.git
    file: tools/vatools-expression-annotation.cwl
    commit: d27541f
sbg:sbgMaintained: false
sbg:toolAuthor: GriffithLab
sbg:toolkit: vatools
sbg:toolkitVersion: 5.0.1
sbg:validationErrors: []
sbg:workflowLanguage: CWL
sbg:wrapperAuthor: Rachel Bowen-James <rbowen-james@ccia.org.au>
