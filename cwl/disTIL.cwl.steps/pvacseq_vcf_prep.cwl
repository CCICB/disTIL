cwlVersion: v1.2
class: Workflow
label: pvacseq-with-prep
doc: |-
  # About this workflow
  This workflow runs the VCF preparation steps necessary for pVACseq. This includes decomposition of the VCF, followed by annotation with DNA and RNA BAM readcounts, and annotation with genome and transcript level expression values (from prior RNA analysis).  

  The following tool versions are used in this workflow:
  - vep v104.3
  - vt-decompose v0.57721
  - bam-readcount-helper v1.1.1 (uses bam-readcount v1.0.0)
  - vatools vcf-readcount-annotator v5.0.1
  - vatools vcf-expression-annotator v5.0.1

  ## Before you run this workflow
  Note that this workflow requires a range of DNA and RNA inputs, as well as RNA expression values.  
  To use this workflow, you will need the following:
  - Inputs for VEP annotation:
  1. **VEP Cache:** A vep cache TAR file.
  2. **VEP Cache Version:** The version of the vep cache TAR file.
  3.**VEP Plugin Files:** Plugin files to be used in VEP annotation (for pVACseq, you must provide Wildtype.pm and Frameshift.pm plugin files).
  - Inputs for readcount annotation
  1. **Input VCF:** An input VCF to be annotated with readcounts. Note that this VCF does **not** need to be decomposed prior to running this analysis.
  2. **Sample Name:** The name of the sample to annotate in the input VCF. Note that this string must exactly match the sample name in the VCF.
  3. **DNA BAM:** A BAM containing DNA data for the sample of interest.
  4. **DNA Reference Genome:** The reference genome FASTA used to align the DNA BAM.
  5. **RNA BAM:** A BAM containing RNA data for the sample of interest.
  6. **RNA Reference Genome:** The reference genome FASTA used to align the RNA BAM.
  - Inputs for expression annotation
  1. **Gene Level Expression File:** A TSV file containing gene level expression values.
  2. **Gene Expression Quntification Algorithm:** The algorithm used to quantify gene level expression (and generate the gene level expression file).
  3. **Gene ID Column:** The name of the column containing gene IDs in the gene expression file.
  4. **Gene Expression Column:** The name of the column containing expression values in the gene expression file.
  5. **Transcript Level Expression File:** A TSV file containing gene level expression values.
  6. **Transcript Expression Quntification Algorithm:** The algorithm used to quantify transcript level expression (and generate the transcript level expression file).
  7. **Transcript ID Column:** The name of the column containing transcript IDs in the transcript expression file.
  8. **Transcript Expression Column:** The name of the column containing expression values in the transcript expression file.


  **If you do not have all of these inputs available, you can run components of this analysis using the constituent CWL tools and subworkflows (all of which are provided in this repo).**

  ### RNA expression values
  Genome and transcript level expression values in TSV format must be generated before running this analysis. Any tool can be used to generate these expression values, but note that:
  - If you use a tool other than Kallisto, Stringtie or Cufflinks, you need to specify the names of the columns containing gene/transcript IDs and expression values.
  - The expression values must be in TSV file format.
  - The gene/transcript ID format used.

  ## Steps
  This workflow runs the following steps:
  1.  Filters the input VCF to retain only PASS variants.
  2. Annotates the input VCF using **vep**.
  3. Decomposes the input VCF using **vt-decompose**.
  4. Generates SNV and indel readcounts from a BAM using **bam-readcount** via an adapted version of the bam-readcount-helper from mgibio.
  5. Annotates the VCF with SNV readcounts using **vatools vcf-readcount-annotator**.
  6. Annotates the VCF with indel readcounts using **vatools vcf-readcount-annotator**.
  7. Annotates the VCF with gene level expression values using **vatools vcf-expression-annotator**.
  8. Annotates the VCF with transcript level expression values using **vatools vcf-expression-annotator**.

  ## Documentation
  - [vep](https://www.ensembl.org/info/docs/tools/vep/index.html)
  - [vt-decompose](https://genome.sph.umich.edu/wiki/Vt)
  - [bam-readcount](https://github.com/genome/bam-readcount)
  - [bam-readcount-helper](https://github.com/genome/docker-bam_readcount_helper-cwl)
  - [vatools vcf-readcount-annotator](https://vatools.readthedocs.io/en/latest/vcf_readcount_annotator.html)
  - [vatools vcf-expression-annotator](https://vatools.readthedocs.io/en/latest/vcf_expression_annotator.html)

requirements:
- class: LoadListingRequirement
- class: SubworkflowFeatureRequirement
- class: MultipleInputFeatureRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: min_base_qual
  type: int?
- id: min_mapping_qual
  type: int?
- id: tumour_sample_name
  label: Tumour sample Name
  doc: Name of the sample to annotate in the input VCF file.
  type: string
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
- id: input_vcf
  label: Input VCF
  doc: |-
    The VCF to be decomposed then annotated with DNA and RNA BAM readcounts. Note that this VCF does not need to be decomposed prior to running this analysis.
  type: File
  secondaryFiles:
  - pattern: .tbi
    required: true
- id: input_bam_rna
  label: RNA BAM
  doc: The RNA BAM for the sample of interest.
  type: File?
  secondaryFiles:
  - pattern: .bai
    required: true
- id: intervals_string
  type: string?
- id: vep_cache
  label: VEP Cache
  doc: The VEP cache TAR file.
  type: File
- id: vep_plugin_files
  label: VEP Plugin Files
  doc: |-
    Plugin files to use in VEP annotation (for pVACseq, must use Wildtype and Frameshift).
  type: File[]
- id: cache_version
  label: VEP Cache Version
  doc: VEP cache version.
  type: int
- id: input_bam_dna
  label: DNA BAM
  doc: |-
    BAM/CRAM file to produce readcounts for. Must have associated index (`.bai` or `.crai`) available.
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
- id: transcript_expression_file
  type: File?
- id: gene_expression_file
  type: File?
- id: alleles
  label: HLA Alleles
  doc: |-
    A text file containing the HLA alleles for this sample as a comma separated string.
  type: File
- id: phased_proximal_variants_vcf
  type: File?
  secondaryFiles:
  - pattern: .tbi
    required: true
- id: net_chop_method
  type:
  - 'null'
  - name: net_chop_method
    type: enum
    symbols:
    - cterm
    - 20s
- id: n_threads
  type: int?
- id: normal_sample_name
  type: string?
- id: prediction_algorithms
  type: string[]
- id: additional_report_columns
  type:
  - 'null'
  - name: additional_report_columns
    type: enum
    symbols:
    - sample_name
- id: allele_specific_binding_thresholds
  type: boolean?
- id: binding_threshold
  type: int?
- id: downstream_sequence_length
  type: string?
- id: epitope_lengths_class_i
  type: int[]?
- id: epitope_lengths_class_ii
  type: int[]?
- id: exclude_nas
  type: boolean?
- id: expn_val
  type: float?
- id: fasta_size
  type: int?
- id: iedb_retries
  type: int?
- id: keep_tmp_files
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
- id: net_chop_threshold
  type: float?
- id: netmhc_stab
  type: boolean?
- id: normal_cov
  type: int?
- id: normal_vaf
  type: float?
- id: percentile_threshold
  type: int?
- id: run_reference_proteome_similarity
  type: boolean?
- id: tdna_cov
  type: int?
- id: tdna_vaf
  type: float?
- id: top_score_metric
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
- id: pvacseq_predictions
  type: Directory
  outputSource:
  - pvacseq/pvacseq_predictions
- id: vep_vcf
  label: VEP annotated VCF
  doc: VEP annotated VCF file. For TMB calculation
  type: File
  outputSource:
  - vep_with_plugins/vep_vcf
- id: mhc_ii_filtered_epitopes
  type: File?
  outputSource:
  - pvacseq/mhc_ii_filtered_epitopes
- id: mhc_i_filtered_epitopes
  type: File?
  outputSource:
  - pvacseq/mhc_i_filtered_epitopes

steps:
- id: vcf_readcount_annotation_rna
  label: vcf-readcount-annotation-rna
  doc: Annotation of the VCF with readcounts from an RNA BAM.
  in:
  - id: ref_genome
    source: ref_genome_rna
  - id: sample_name
    source: tumour_sample_name
  - id: input_bam
    source: input_bam_rna
  - id: data_type
    default: RNA
  - id: min_base_qual
    source: min_base_qual
  - id: min_mapping_qual
    source: min_mapping_qual
  - id: input_vcf
    source: vcf_readcount_annotation_dna/snv_indel_annot_zipped
  run: pvacseq_vcf_prep.cwl.steps/vcf_readcount_annotation_rna.cwl
  when: |-
    ${
        if (inputs.input_bam === null) {
            return false;
        } else {
            return true;
        }
    }
  out:
  - id: snv_indel_annot_zipped
  - id: snv_readcount
  - id: indel_readcount
- id: vt_decompose
  label: vt-decompose
  doc: Decompose the VCF file prior to readcount annotation.
  in:
  - id: seq_regions
    default: true
  - id: input_vcf
    source: bgzip_tabix_5/zipped_with_index
  - id: intervals_string
    source: intervals_string
  run: pvacseq_vcf_prep.cwl.steps/vt_decompose.cwl
  out:
  - id: decomposed_vcf
- id: vep_with_plugins
  label: vep-with-plugins
  doc: Run VEP annotation of the input VCF.
  in:
  - id: input_file
    source: bgzip_tabix_3/zipped_with_index
  - id: vep_cache
    source: vep_cache
  - id: ref_genome
    source: ref_genome_dna
  - id: vep_plugin_files
    source:
    - vep_plugin_files
  - id: cache_version
    source: cache_version
  - id: merged
    default: true
  - id: symbol
    default: true
  - id: biotype
    default: true
  - id: numbers
    default: true
  - id: canonical
    default: true
  - id: total_length
    default: true
  - id: sift
    default: b
  - id: polyphen
    default: b
  - id: terms
    default: SO
  run: pvacseq_vcf_prep.cwl.steps/vep_with_plugins.cwl
  out:
  - id: vep_vcf
  - id: vep_stats
- id: bcftools_view_pass
  label: bcftools-view-pass
  in:
  - id: vcf
    source: input_vcf
  run: pvacseq_vcf_prep.cwl.steps/bcftools_view_pass.cwl
  out:
  - id: pass_filtered_vcf
- id: bgzip_tabix_5
  label: bgzip-tabix
  in:
  - id: input_file
    source: vep_with_plugins/vep_vcf
  run: pvacseq_vcf_prep.cwl.steps/bgzip_tabix_5.cwl
  out:
  - id: index_file
  - id: bgzipped_file
  - id: zipped_with_index
- id: bgzip_tabix_3
  label: bgzip-tabix
  in:
  - id: input_file
    source: bcftools_view_pass/pass_filtered_vcf
  run: pvacseq_vcf_prep.cwl.steps/bgzip_tabix_3.cwl
  out:
  - id: index_file
  - id: bgzipped_file
  - id: zipped_with_index
- id: bgzip_tabix_4
  label: bgzip-tabix
  in:
  - id: input_file
    source: vt_decompose/decomposed_vcf
  run: pvacseq_vcf_prep.cwl.steps/bgzip_tabix_4.cwl
  out:
  - id: index_file
  - id: bgzipped_file
  - id: zipped_with_index
- id: vcf_readcount_annotation_dna
  label: vcf-readcount-annotation-dna
  in:
  - id: sample_name
    source: tumour_sample_name
  - id: data_type
    default: DNA
  - id: input_vcf
    source: bgzip_tabix_4/zipped_with_index
  - id: reference_fasta
    source: ref_genome_dna
  - id: input_bam_cram
    source:
    - input_bam_dna
    - input_cram_dna
    pickValue: first_non_null
  run: pvacseq_vcf_prep.cwl.steps/vcf_readcount_annotation_dna.cwl
  out:
  - id: snv_indel_annot_zipped
  - id: snv_readcount
  - id: indel_readcount
- id: vcf_expression_annotation
  label: vcf-expression-annotation
  in:
  - id: input_vcf
    valueFrom: "${\n    return self[0];\n}"
    source:
    - vcf_readcount_annotation_rna/snv_indel_annot_zipped
    - vcf_readcount_annotation_dna/snv_indel_annot_zipped
    pickValue: all_non_null
  - id: gene_expression_file
    source: gene_expression_file
  - id: transcript_expression_file
    source: transcript_expression_file
  - id: quant_algo
    default: custom
  - id: id_column
    default: ensembl_transcript_id
  - id: expression_column
    default: TPM
  - id: sample_name
    source: tumour_sample_name
  - id: quant_algo_1
    default: custom
  - id: id_column_1
    default: ensembl_gene_id
  - id: expression_column_1
    default: TPM
  run: pvacseq_vcf_prep.cwl.steps/vcf_expression_annotation.cwl
  when: |-
    ${
        if (inputs.gene_expression_file === null || inputs.trasncript_expression_file === null) {
            return false;
        } else {
            return true;
        }
    }
  out:
  - id: expression_annotated_vcf
- id: pvacseq
  label: pvacseq
  in:
  - id: additional_report_columns
    source: additional_report_columns
  - id: allele_specific_binding_thresholds
    source: allele_specific_binding_thresholds
  - id: alleles
    source: alleles
  - id: binding_threshold
    source: binding_threshold
  - id: downstream_sequence_length
    source: downstream_sequence_length
  - id: epitope_lengths_class_i
    source:
    - epitope_lengths_class_i
  - id: epitope_lengths_class_ii
    source:
    - epitope_lengths_class_ii
  - id: exclude_nas
    source: exclude_nas
  - id: expn_val
    source: expn_val
  - id: fasta_size
    source: fasta_size
  - id: iedb_retries
    source: iedb_retries
  - id: input_vcf
    valueFrom: "${\n    return self[0];\n}"
    source:
    - vcf_expression_annotation/expression_annotated_vcf
    - vcf_readcount_annotation_rna/snv_indel_annot_zipped
    - vcf_readcount_annotation_dna/snv_indel_annot_zipped
    pickValue: all_non_null
  - id: keep_tmp_files
    source: keep_tmp_files
  - id: maximum_transcript_support_level
    source: maximum_transcript_support_level
  - id: minimum_fold_change
    source: minimum_fold_change
  - id: n_threads
    source: n_threads
  - id: net_chop_method
    source: net_chop_method
  - id: net_chop_threshold
    source: net_chop_threshold
  - id: netmhc_stab
    source: netmhc_stab
  - id: normal_cov
    source: normal_cov
  - id: normal_sample_name
    source: normal_sample_name
  - id: normal_vaf
    source: normal_vaf
  - id: percentile_threshold
    source: percentile_threshold
  - id: phased_proximal_variants_vcf
    source: phased_proximal_variants_vcf
  - id: prediction_algorithms
    source:
    - prediction_algorithms
  - id: run_reference_proteome_similarity
    source: run_reference_proteome_similarity
  - id: sample_name
    source: tumour_sample_name
  - id: tdna_cov
    source: tdna_cov
  - id: tdna_vaf
    source: tdna_vaf
  - id: top_score_metric
    source: top_score_metric
  - id: trna_cov
    source: trna_cov
  - id: trna_vaf
    source: trna_vaf
  run: pvacseq_vcf_prep.cwl.steps/pvacseq.cwl
  out:
  - id: combined_aggregated_report
  - id: combined_all_epitopes
  - id: combined_filtered_epitopes
  - id: mhc_i_aggregated_report
  - id: mhc_i_all_epitopes
  - id: mhc_i_filtered_epitopes
  - id: mhc_ii_aggregated_report
  - id: mhc_ii_all_epitopes
  - id: mhc_ii_filtered_epitopes
  - id: pvacseq_predictions
