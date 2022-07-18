cwlVersion: v1.2
class: Workflow
label: distil

requirements:
- class: LoadListingRequirement
- class: SubworkflowFeatureRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: gene_expression_file
  type: File?
- id: input_bam_dna
  label: DNA BAM
  doc: |-
    BAM/CRAM file to produce readcounts for. Must have associated index (`.bai` or `.crai`) available.
  type: File?
  secondaryFiles:
  - pattern: .bai
    required: true
- id: input_bam_rna
  label: RNA BAM
  doc: The RNA BAM for the sample of interest.
  type: File?
  secondaryFiles:
  - pattern: .bai
    required: true
- id: input_cram_dna
  label: DNA CRAM
  doc: |-
    BAM/CRAM file to produce readcounts for. Must have associated index (`.bai` or `.crai`) available.
  type: File?
  secondaryFiles:
  - pattern: .crai
    required: true
- id: input_vcf
  label: Input VCF
  doc: |-
    The VCF to be decomposed then annotated with DNA and RNA BAM readcounts. Note that this VCF does not need to be decomposed prior to running this analysis.
  type: File
  secondaryFiles:
  - pattern: .tbi
    required: true
- id: ref_genome_dna
  label: DNA Reference Genome
  doc: Reference sequence used to align the DNA BAM.
  type: File
  secondaryFiles:
  - pattern: .fai
    required: true
- id: ref_genome_rna
  label: RNA Reference Genome
  doc: Reference sequence used to align the RNA BAM.
  type: File
  secondaryFiles:
  - pattern: .fai
    required: true
- id: transcript_expression_file
  type: File?
- id: vep_cache
  label: VEP Cache
  doc: The VEP cache TAR file.
  type: File
- id: vep_plugin_files
  label: VEP Plugin Files
  doc: |-
    Plugin files to use in VEP annotation (for pVACseq, must use Wildtype and Frameshift).
  type: File[]
- id: tumour_DNA_read2_sequences
  label: Tumour DNA Read 2 Sequences
  type: File
- id: tumour_DNA_read1_sequences
  label: Tumour DNA Read 1 Sequences
  type: File
- id: RNA_read2_sequences
  label: RNA Read 2 Sequences
  doc: Read 2 sequences in FASTA or FASTQ format (may be bgzipped).
  type: File?
- id: RNA_read1_sequences
  label: RNA Read 1 Sequences
  type: File?
- id: Germline_DNA_read2_sequences
  label: Germline DNA Read 2 Sequences
  type: File
- id: Germline_DNA_read1_sequences
  label: Germline DNA Read 1 Sequences
  type: File
- id: bowtie2_index
  label: HLA Bowtie2 Index Archive
  doc: Bowtie2 Index Archive for an HLA reference.
  type: File
- id: fusion_tsv
  label: Fusion TSV
  doc: A TSV file containing fusion variant calls.
  type: File
- id: patient_id
  label: Patient ID
  doc: The patient ID for the sample being analysed.
  type: string
- id: gene_col
  label: Gene ID Column Name
  doc: Name of the column in the gene expression TSV containing gene IDs. E.g. gene_id
  type: string
- id: expr_value_column
  doc: column name for gene expression value
  type: string
- id: tumour_sample_name
  type: string
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
- id: normal_sample_name
  type: string?
- id: gene_col_1
  label: Gene ID Column Name
  doc: Name of the column in the gene expression TSV containing gene IDs.
  type: string
- id: expr_col
  label: Expression Value Column Label
  doc: Name of the column in the gene expression TSV containing expression values.
  type: string
- id: bowtie2_index_prefix
  label: HLA Bowtie2 Index Prefix
  type: string
- id: to_subsample
  label: subsample tumour DNA
  doc: |-
    Tumour DNA fastq may be large due to high sequencing depth. Subsample it to reduce runtime.
  type: boolean
- id: number_of_subsample_reads
  doc: The number of reads to subsample for read2
  type: int?
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
- id: n_threads
  type: int?
- id: net_chop_method
  type:
  - 'null'
  - name: net_chop_method
    type: enum
    symbols:
    - cterm
    - 20s
- id: prediction_algorithms
  type: string[]
- id: epitope_lengths_class_i
  type: int[]?
- id: epitope_lengths_class_ii
  type: int[]?
- id: binding_threshold
  type: int?
- id: percentile_threshold
  type: int?
- id: iedb_retries
  type: int?
- id: keep_tmp_files
  type: boolean?
- id: netmhc_stab
  type: boolean?
- id: top_score_metric
  type:
  - 'null'
  - name: top_score_metric
    type: enum
    symbols:
    - lowest
    - median
- id: net_chop_threshold
  type: float?
- id: run_reference_proteome_similarity
  type: boolean?
- id: additional_report_columns
  type:
  - 'null'
  - name: additional_report_columns
    type: enum
    symbols:
    - sample_name
- id: fasta_size
  type: int?
- id: downstream_sequence_length
  type: string?
- id: exclude_nas
  type: boolean?
- id: min_base_qual
  type: int?
- id: min_mapping_qual
  type: int?
- id: intervals_string
  type: string?
- id: cache_version
  label: VEP Cache Version
  doc: VEP cache version.
  type: int
- id: net_chop_method_1
  type:
  - 'null'
  - name: net_chop_method
    type: enum
    symbols:
    - cterm
    - 20s
- id: n_threads_1
  type: int?
- id: prediction_algorithms_1
  type: string[]
- id: additional_report_columns_1
  type:
  - 'null'
  - name: additional_report_columns
    type: enum
    symbols:
    - sample_name
- id: allele_specific_binding_thresholds
  type: boolean?
- id: binding_threshold_1
  type: int?
- id: downstream_sequence_length_1
  type: string?
- id: epitope_lengths_class_i_1
  type: int[]?
- id: epitope_lengths_class_ii_1
  type: int[]?
- id: exclude_nas_1
  type: boolean?
- id: expn_val
  type: float?
- id: fasta_size_1
  type: int?
- id: iedb_retries_1
  type: int?
- id: keep_tmp_files_1
  type: boolean?
- id: maximum_transcript_support_level
  type:
  - 'null'
  - name: maximum_transcript_support_level
    type: enum
    symbols:
    - '1'
    - '2'
    - '3'
    - '4'
    - '5'
- id: minimum_fold_change
  type: float?
- id: net_chop_threshold_1
  type: float?
- id: netmhc_stab_1
  type: boolean?
- id: normal_cov
  type: int?
- id: normal_vaf
  type: float?
- id: percentile_threshold_1
  type: int?
- id: run_reference_proteome_similarity_1
  type: boolean?
- id: tdna_cov
  type: int?
- id: tdna_vaf
  type: float?
- id: top_score_metric_1
  type:
  - 'null'
  - name: top_score_metric
    type: enum
    symbols:
    - lowest
    - median
- id: trna_cov
  type: int?
- id: trna_vaf
  type: float?

outputs:
- id: ipass_score_file
  type: File
  outputSource:
  - ipass_patient/ipass_score_file
- id: quanitseq_deconv
  label: quanTIseq Deconvolution Results
  doc: A TSV file containing the results of quanTIseq deconvolution.
  type: File
  outputSource:
  - epic_and_quantiseq/quanitseq_deconv
- id: epic_deconv
  label: EPIC Deconvolution Results
  doc: A TSV file containing the results of EPIC deconvolution.
  type: File
  outputSource:
  - epic_and_quantiseq/epic_deconv
- id: pvacseq_predictions
  type: Directory
  outputSource:
  - pvacseq_vcf_prep/pvacseq_predictions
- id: sample3_json
  label: Tumour RNA HLA-HD Results JSON
  type: File?
  outputSource:
  - consensus_hla/sample3_json
- id: sample2_json
  label: Normal DNA HLA-HD Results JSON
  type: File
  outputSource:
  - consensus_hla/sample2_json
- id: sample1_json
  label: Tumour DNA HLA-HD Results JSON
  type: File
  outputSource:
  - consensus_hla/sample1_json
- id: hla_report
  label: HLA Report
  doc: A PDF report containing the HLA consensus results.
  type: File
  outputSource:
  - consensus_hla/hla_report
- id: consensus_json
  label: HLA Consensus JSON
  type: File
  outputSource:
  - consensus_hla/consensus_json
- id: clin_sig_txt
  label: Clinically Significant HLA Consensus Text File
  type: File
  outputSource:
  - consensus_hla/clin_sig_txt
- id: clin_sig_json
  label: Clinically Significant HLA Consensus JSON
  type: File
  outputSource:
  - consensus_hla/clin_sig_json
- id: consensus_txt
  label: HLA Consensus Text File
  type: File
  outputSource:
  - consensus_hla/consensus_txt
- id: pvacfuse_predictions
  type: Directory?
  outputSource:
  - pvacfuse_with_prep/pvacfuse_predictions
- id: disTIL_report
  label: disTIL Report
  doc: A PDF report containing the disTIL results
  type: File
  outputSource:
  - distil_report/disTIL_report
- id: variants
  label: Canonical Missense Coding Variants
  doc: Number of missense canonical variants in with filter 'PASS'.
  type: int
  outputSource:
  - tmb/variants
- id: tmb_1
  type: float
  outputSource:
  - tmb/tmb

steps:
- id: consensus_hla
  label: consensus-hla
  in:
  - id: tumour_DNA_read2_sequences
    source: tumour_DNA_read2_sequences
  - id: tumour_DNA_read1_sequences
    source: tumour_DNA_read1_sequences
  - id: Germline_DNA_read2_sequences
    source: Germline_DNA_read2_sequences
  - id: Germline_DNA_read1_sequences
    source: Germline_DNA_read1_sequences
  - id: bowtie2_index
    source: bowtie2_index
  - id: RNA_read1_sequences
    source: RNA_read1_sequences
  - id: RNA_read2_sequences
    source: RNA_read2_sequences
  - id: patient_id
    source: patient_id
  - id: bowtie2_index_prefix
    source: bowtie2_index_prefix
  - id: to_subsample
    source: to_subsample
  - id: number_of_subsample_reads
    source: number_of_subsample_reads
  run: disTIL.cwl.steps/consensus_hla.cwl
  out:
  - id: hla_report
  - id: sample3_json
  - id: sample2_json
  - id: sample1_json
  - id: consensus_txt
  - id: clin_sig_txt
  - id: consensus_json
  - id: clin_sig_json
- id: pvacseq_vcf_prep
  label: pvacseq-with-prep
  in:
  - id: min_base_qual
    source: min_base_qual
  - id: min_mapping_qual
    source: min_mapping_qual
  - id: tumour_sample_name
    source: tumour_sample_name
  - id: ref_genome_dna
    source: ref_genome_dna
  - id: ref_genome_rna
    source: ref_genome_rna
  - id: input_vcf
    source: input_vcf
  - id: input_bam_rna
    source: input_bam_rna
  - id: intervals_string
    source: intervals_string
  - id: vep_cache
    source: vep_cache
  - id: vep_plugin_files
    source:
    - vep_plugin_files
  - id: cache_version
    source: cache_version
  - id: input_bam_dna
    source: input_bam_dna
  - id: input_cram_dna
    source: input_cram_dna
  - id: transcript_expression_file
    source: transcript_expression_file
  - id: gene_expression_file
    source: gene_expression_file
  - id: alleles
    source: consensus_hla/clin_sig_txt
  - id: net_chop_method
    source: net_chop_method_1
  - id: n_threads
    source: n_threads_1
  - id: normal_sample_name
    source: normal_sample_name
  - id: prediction_algorithms
    source:
    - prediction_algorithms_1
  - id: additional_report_columns
    source: additional_report_columns_1
  - id: allele_specific_binding_thresholds
    source: allele_specific_binding_thresholds
  - id: binding_threshold
    source: binding_threshold_1
  - id: downstream_sequence_length
    source: downstream_sequence_length_1
  - id: epitope_lengths_class_i
    source:
    - epitope_lengths_class_i_1
  - id: epitope_lengths_class_ii
    source:
    - epitope_lengths_class_ii_1
  - id: exclude_nas
    source: exclude_nas_1
  - id: expn_val
    source: expn_val
  - id: fasta_size
    source: fasta_size_1
  - id: iedb_retries
    source: iedb_retries_1
  - id: keep_tmp_files
    source: keep_tmp_files_1
  - id: maximum_transcript_support_level
    source: maximum_transcript_support_level
  - id: minimum_fold_change
    source: minimum_fold_change
  - id: net_chop_threshold
    source: net_chop_threshold_1
  - id: netmhc_stab
    source: netmhc_stab_1
  - id: normal_cov
    source: normal_cov
  - id: normal_vaf
    source: normal_vaf
  - id: percentile_threshold
    source: percentile_threshold_1
  - id: run_reference_proteome_similarity
    source: run_reference_proteome_similarity_1
  - id: tdna_cov
    source: tdna_cov
  - id: tdna_vaf
    source: tdna_vaf
  - id: top_score_metric
    source: top_score_metric_1
  - id: trna_cov
    source: trna_cov
  - id: trna_vaf
    source: trna_vaf
  run: disTIL.cwl.steps/pvacseq_vcf_prep.cwl
  out:
  - id: pvacseq_predictions
  - id: vep_vcf
  - id: mhc_ii_filtered_epitopes
  - id: mhc_i_filtered_epitopes
- id: ipass_patient
  label: ipass-patient
  in:
  - id: patient_id
    source: patient_id
  - id: gene_expr_file
    source: gene_expression_file
  - id: gene_col
    source: gene_col
  - id: expr_col
    source: expr_value_column
  run: disTIL.cwl.steps/ipass_patient.cwl
  out:
  - id: ipass_score_file
- id: pvacfuse_with_prep
  label: pvacfuse-with-prep
  in:
  - id: fusion_tsv
    source: fusion_tsv
  - id: alleles
    source: consensus_hla/clin_sig_txt
  - id: sample_name
    source: tumour_sample_name
  - id: ref_genome
    source: ref_genome
  - id: fusion_caller
    source: fusion_caller
  - id: n_threads
    source: n_threads
  - id: net_chop_method
    source: net_chop_method
  - id: prediction_algorithms
    source:
    - prediction_algorithms
  - id: epitope_lengths_class_i
    source:
    - epitope_lengths_class_i
  - id: epitope_lengths_class_ii
    source:
    - epitope_lengths_class_ii
  - id: binding_threshold
    source: binding_threshold
  - id: percentile_threshold
    source: percentile_threshold
  - id: iedb_retries
    source: iedb_retries
  - id: keep_tmp_files
    source: keep_tmp_files
  - id: netmhc_stab
    source: netmhc_stab
  - id: top_score_metric
    source: top_score_metric
  - id: net_chop_threshold
    source: net_chop_threshold
  - id: run_reference_proteome_similarity
    source: run_reference_proteome_similarity
  - id: additional_report_columns
    source: additional_report_columns
  - id: fasta_size
    source: fasta_size
  - id: downstream_sequence_length
    source: downstream_sequence_length
  - id: exclude_nas
    source: exclude_nas
  run: disTIL.cwl.steps/pvacfuse_with_prep.cwl
  out:
  - id: pvacfuse_predictions
  - id: mhc_ii_filtered_epitopes
  - id: mhc_i_filtered_epitopes
- id: distil_report
  label: distil-report
  in:
  - id: hla_json
    source: consensus_hla/consensus_json
  - id: patient_id
    source: patient_id
  - id: pvacseq_i
    source: pvacseq_vcf_prep/mhc_i_filtered_epitopes
  - id: pvacseq_ii
    source: pvacseq_vcf_prep/mhc_ii_filtered_epitopes
  - id: pvacfuse_i
    source: pvacfuse_with_prep/mhc_i_filtered_epitopes
  - id: pvacfuse_ii
    source: pvacfuse_with_prep/mhc_ii_filtered_epitopes
  - id: coding_missense_variants
    source: tmb/variants
  - id: tmb
    source: tmb/tmb
  - id: ipass
    source: ipass_patient/ipass_score_file
  - id: epic_deconv
    source: epic_and_quantiseq/epic_deconv
  - id: quant_deconv
    source: epic_and_quantiseq/quanitseq_deconv
  run: disTIL.cwl.steps/distil_report.cwl
  out:
  - id: disTIL_report
- id: epic_and_quantiseq
  label: immunedeconv
  in:
  - id: gene_expr
    source: gene_expression_file
  - id: patient_id
    source: patient_id
  - id: gene_col
    source: gene_col_1
  - id: expr_col
    source: expr_col
  run: disTIL.cwl.steps/epic_and_quantiseq.cwl
  out:
  - id: epic_deconv
  - id: quanitseq_deconv
- id: tmb
  label: tmb
  in:
  - id: vcf
    source: pvacseq_vcf_prep/vep_vcf
  - id: reference_build
    source: ref_genome
  run: disTIL.cwl.steps/tmb.cwl
  out:
  - id: tmb
  - id: variants
