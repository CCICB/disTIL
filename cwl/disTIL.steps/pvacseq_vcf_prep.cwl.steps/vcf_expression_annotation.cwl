cwlVersion: v1.2
class: Workflow
label: vcf-expression-annotation
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: SubworkflowFeatureRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: input_vcf
  label: Input VCF
  doc: The VCF to annotate with expression values.
  type: File
  secondaryFiles:
  - pattern: .tbi
    required: true
  sbg:fileTypes: VCF.GZ, vcf.gz
  sbg:x: -493
  sbg:y: -208.49208068847656
- id: gene_expression_file
  type: File
  sbg:x: -676
  sbg:y: -35
- id: transcript_expression_file
  type: File
  sbg:x: -173.87364196777344
  sbg:y: 188.64459228515625
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
  sbg:exposed: true
- id: id_column
  label: ID Column Name
  doc: |-
    The name of the column containing gene or transcript IDs in the expression file. Note that these IDs must be in the same format as IDs in the VCF (i.e. Ensembl, RefSeq)
  type: string?
  sbg:exposed: true
- id: expression_column
  label: Expression Column Name
  doc: |-
    The name of the column containing expression values (usually in TPM) in the expression file.
  type: string?
  sbg:exposed: true
- id: sample_name
  label: Sample Name
  doc: Name of the sample to be annotated in the VCF file.
  type: string
  sbg:x: -540.4605102539062
  sbg:y: -383.80194091796875
- id: quant_algo_1
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
  sbg:exposed: true
- id: id_column_1
  label: ID Column Name
  doc: |-
    The name of the column containing gene or transcript IDs in the expression file. Note that these IDs must be in the same format as IDs in the VCF (i.e. Ensembl, RefSeq)
  type: string?
  sbg:exposed: true
- id: expression_column_1
  label: Expression Column Name
  doc: |-
    The name of the column containing expression values (usually in TPM) in the expression file.
  type: string?
  sbg:exposed: true

outputs:
- id: expression_annotated_vcf
  label: expression-annotated-vcf
  doc: The bgzipped input file with its newly created index as a secondary file.
  type: File
  secondaryFiles:
  - pattern: .tbi
    required: true
  outputSource:
  - bgzip_tabix_2/zipped_with_index
  sbg:fileTypes: VCF.GZ, vcf.gz
  sbg:x: 807.7788696289062
  sbg:y: 48.211421966552734

steps:
- id: vcf_gene_expression_annotation
  label: vatools-gene-expression-annotation
  in:
  - id: input_vcf
    source: input_vcf
  - id: expression_file
    source: rsem_ensembl_annotation/output
  - id: quant_algo
    source: quant_algo_1
  - id: expression_level
    default: gene
  - id: id_column
    source: id_column_1
  - id: expression_column
    source: expression_column_1
  - id: sample_name
    source: sample_name
  run: vcf_expression_annotation.cwl.steps/vcf_gene_expression_annotation.cwl
  out:
  - id: exp_annotated_vcf
  sbg:x: -273
  sbg:y: -153
- id: vcf_transcript_expression_annotation
  label: vatools-trasncript-expression-annotation
  in:
  - id: input_vcf
    source: bgzip_tabix_1/zipped_with_index
  - id: expression_file
    source: rsem_ensembl_annotation_1/output
  - id: quant_algo
    source: quant_algo
  - id: expression_level
    default: transcript
  - id: id_column
    source: id_column
  - id: expression_column
    source: expression_column
  - id: sample_name
    source: sample_name
  run: vcf_expression_annotation.cwl.steps/vcf_transcript_expression_annotation.cwl
  out:
  - id: exp_annotated_vcf
  sbg:x: 283.5127868652344
  sbg:y: -116.44288635253906
- id: bgzip_tabix_1
  label: bgzip-tabix
  in:
  - id: input_file
    source: vcf_gene_expression_annotation/exp_annotated_vcf
  run: vcf_expression_annotation.cwl.steps/bgzip_tabix_1.cwl
  out:
  - id: index_file
  - id: bgzipped_file
  - id: zipped_with_index
  sbg:x: -22.248483657836914
  sbg:y: -92.6622085571289
- id: bgzip_tabix_2
  label: bgzip-tabix
  in:
  - id: input_file
    source: vcf_transcript_expression_annotation/exp_annotated_vcf
  run: vcf_expression_annotation.cwl.steps/bgzip_tabix_2.cwl
  out:
  - id: index_file
  - id: bgzipped_file
  - id: zipped_with_index
  sbg:x: 526.3341064453125
  sbg:y: -9.9574613571167
- id: rsem_ensembl_annotation
  label: rsem-ensembl-annotation
  in:
  - id: rsem_results
    source: gene_expression_file
  run: vcf_expression_annotation.cwl.steps/rsem_ensembl_annotation.cwl
  out:
  - id: output
  sbg:x: -487
  sbg:y: -42
- id: rsem_ensembl_annotation_1
  label: rsem-ensembl-annotation
  in:
  - id: rsem_results
    source: transcript_expression_file
  run: vcf_expression_annotation.cwl.steps/rsem_ensembl_annotation_1.cwl
  out:
  - id: output
  sbg:x: 66.74968719482422
  sbg:y: 133.62515258789062
sbg:appVersion:
- v1.2
- v1.0
sbg:content_hash: a2b775afc30bfa3408069d0b8f3122633fdaccf59398c2de2585630195f08d471
sbg:contributors:
- alanwu
sbg:createdBy: alanwu
sbg:createdOn: 1650415614
sbg:id: mwonge/ccicb-distil/vcf-expression-annotation-1/2
sbg:image_url: |-
  https://cavatica.sbgenomics.com/ns/brood/images/mwonge/ccicb-distil/vcf-expression-annotation-1/2.png
sbg:latestRevision: 2
sbg:modifiedBy: alanwu
sbg:modifiedOn: 1650416815
sbg:original_source: mwonge/ccicb-distil/vcf-expression-annotation-1/2
sbg:project: mwonge/ccicb-distil
sbg:projectName: ccicb-distil
sbg:publisher: sbg
sbg:revision: 2
sbg:revisionNotes: expose parameters
sbg:revisionsInfo:
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1650415614
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1650416705
  sbg:revision: 1
  sbg:revisionNotes: workflow for expression annotation of a vcf
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1650416815
  sbg:revision: 2
  sbg:revisionNotes: expose parameters
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
