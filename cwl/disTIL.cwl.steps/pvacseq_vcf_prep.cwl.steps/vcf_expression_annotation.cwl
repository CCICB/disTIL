cwlVersion: v1.2
class: Workflow
label: vcf-expression-annotation

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
- id: gene_expression_file
  type: File
- id: transcript_expression_file
  type: File
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
- id: id_column
  label: ID Column Name
  doc: |-
    The name of the column containing gene or transcript IDs in the expression file. Note that these IDs must be in the same format as IDs in the VCF (i.e. Ensembl, RefSeq)
  type: string?
- id: expression_column
  label: Expression Column Name
  doc: |-
    The name of the column containing expression values (usually in TPM) in the expression file.
  type: string?
- id: sample_name
  label: Sample Name
  doc: Name of the sample to be annotated in the VCF file.
  type: string
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
- id: id_column_1
  label: ID Column Name
  doc: |-
    The name of the column containing gene or transcript IDs in the expression file. Note that these IDs must be in the same format as IDs in the VCF (i.e. Ensembl, RefSeq)
  type: string?
- id: expression_column_1
  label: Expression Column Name
  doc: |-
    The name of the column containing expression values (usually in TPM) in the expression file.
  type: string?

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
- id: rsem_ensembl_annotation
  label: rsem-ensembl-annotation
  in:
  - id: rsem_results
    source: gene_expression_file
  run: vcf_expression_annotation.cwl.steps/rsem_ensembl_annotation.cwl
  out:
  - id: output
- id: rsem_ensembl_annotation_1
  label: rsem-ensembl-annotation
  in:
  - id: rsem_results
    source: transcript_expression_file
  run: vcf_expression_annotation.cwl.steps/rsem_ensembl_annotation_1.cwl
  out:
  - id: output
