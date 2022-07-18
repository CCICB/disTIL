cwlVersion: v1.2
class: CommandLineTool
label: bam-readcount-helper
doc: |-
  # About bam-readcount
  Information about bam-readcount can be found [here](https://github.com/genome/bam-readcount).  
  bam-readcount is a tool which runs on a BAM/CRAM file and generates metrics at single nucleotide positions. These metrics can be useful for filtering out false positive variant calls.

  # About this CWL tool
  This CWL tool runs an edited version of the `bam_readcount_helper` (v1.1.1) script provided [here](https://github.com/genome/docker-bam_readcount_helper-cwl). The script generates a region list from a VCF, then runs bam-readcount v1.0.0 separately on SNVs and indels (using indel-centric mode `-i` for indels). It uses the Docker `rachelbj/bam-readcount` (based on `mgibio/bam_readcount_helper-cwl:1.1.1`).  
  **NOTE: the VCF must first be decomposed using `vt-decompose`.**

  ## Edits made
  The original script did not account for BAMs with references using the 'chr' chromosome prefix (e.g. 'chr1' for chromosome 1). The edited script used in this CWL tool checks the chromosome naming in the BAMfile using the `pysam.idxstats` function. If the 'chr' prefix is found in the BAMthen it is added to the region list passed to bam-readcount.

  ## Main inputs
  - BAMfor which to generate readcounts (must have index `.bai` available).
  - VCF of somatic variants called from the BAM.
  - Reference sequence in FASTA format. Note that this should be the same reference file used to generate the BAM.

  ## Outputs
  - Indel readcounts TSV.
  - SNV readcounts TSV.
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: alanwucci/bam_readcount:1.0.5
- class: InlineJavascriptRequirement

inputs:
- id: input_vcf
  label: Matched VCF
  doc: Variants called from the input BAM in VCF format.
  type: File
  inputBinding:
    position: 0
    shellQuote: false
  sbg:fileTypes: VCF, VCF.GZ
- id: sample_name
  label: Sample Name
  doc: Name of the matched sample in the VCF file.
  type: string
  inputBinding:
    position: 1
    shellQuote: false
- id: reference_fasta
  label: Reference FASTA
  doc: Reference sequence in FASTA format (reference used to align the input BAM).
  type: File
  inputBinding:
    position: 2
    shellQuote: false
  sbg:fileTypes: FA, FASTA
- id: input_bam_cram
  label: Input BAM/CRAM
  doc: |-
    BAM/CRAM file to produce readcounts for. Must have associated index (`.bai` or `.crai`) available.
  type: File
  secondaryFiles:
  - pattern: |-
      ${
          var filename = self.path.split("/").slice(-1).pop();
          var suffix = filename.split('.').slice(-1).pop();
          if (suffix === 'bam') {
              return self.path + '.bai';
          } else {
              return self.path + '.crai';
          }
      }
    required: true
  inputBinding:
    position: 3
    shellQuote: false
  sbg:fileTypes: BAM, bam, cram, CRAM
- id: data_type
  label: Data Type
  doc: Indicates whether the input BAM file contains DNA or RNA data.
  type:
    name: data_type
    type: enum
    symbols:
    - DNA
    - RNA
  inputBinding:
    position: 4
    shellQuote: false
- id: min_base_qual
  label: Minimum Base Quality
  doc: Minimum base quality at a position to use a read for counting.
  type: int?
  inputBinding:
    position: 5
    shellQuote: false
  sbg:toolDefaultValue: '0'
- id: min_mapping_qual
  label: Minimum Mapping Quality
  doc: Minimum mapping quality of reads used for counting.
  type: int?
  inputBinding:
    position: 6
    shellQuote: false
  sbg:toolDefaultValue: '0'

outputs:
- id: indel_readcount
  label: Indel Readcounts
  doc: TSV file containing indel readcounts.
  type: File
  outputBinding:
    glob: '*_bam_readcount_indel.tsv'
  sbg:fileTypes: TSV
- id: snv_readcount
  label: SNV Readcounts
  doc: TSV file containing SNV readcounts.
  type: File
  outputBinding:
    glob: '*_bam_readcount_snv.tsv'
  sbg:fileTypes: TSV

baseCommand:
- python3
- /usr/bin/bam_readcount_helper_edited.py
arguments:
- prefix: ''
  position: 5
  valueFrom: ./
  separate: false
  shellQuote: false
- prefix: ''
  position: 7
  valueFrom: 1>&2
  shellQuote: false
id: mwonge/ccicb-distil/bam-readcount-helper/8
sbg:appVersion:
- v1.2
sbg:content_hash: a7198313475b82197e8038b20c293a2af315d6e9980769db030037951caeb52e5
sbg:contributors:
- alanwu
sbg:createdBy: alanwu
sbg:createdOn: 1645762188
sbg:id: mwonge/ccicb-distil/bam-readcount-helper/8
sbg:image_url:
sbg:latestRevision: 8
sbg:modifiedBy: alanwu
sbg:modifiedOn: 1650327032
sbg:project: mwonge/ccicb-distil
sbg:projectName: ccicb-distil
sbg:publisher: sbg
sbg:revision: 8
sbg:revisionNotes: update to latest docker
sbg:revisionsInfo:
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1645762188
  sbg:revision: 0
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.02.18. 
    Source: 
    repo: git@github.com:rbowenj/disTIL.git
    file: tools/bam-readcount-helper.cwl
    commit: d27541f
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1648097605
  sbg:revision: 1
  sbg:revisionNotes: add support for CRAM input
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1648183924
  sbg:revision: 2
  sbg:revisionNotes: update to use bam-readcount v1.0.0 docker to allow cram input
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1648428604
  sbg:revision: 3
  sbg:revisionNotes: update to latest docker
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1649311134
  sbg:revision: 4
  sbg:revisionNotes: update docker
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1649377546
  sbg:revision: 5
  sbg:revisionNotes: ''
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1649637335
  sbg:revision: 6
  sbg:revisionNotes: use latest bam-readcount-helper docker from bam-readcount team
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1649647728
  sbg:revision: 7
  sbg:revisionNotes: update to docker image build from second computer
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1650327032
  sbg:revision: 8
  sbg:revisionNotes: update to latest docker
sbg:sbgMaintained: false
sbg:toolAuthor: The McDonnell Genome Institute
sbg:toolkit: bam-readcount
sbg:toolkitVersion: 1.0.0
sbg:validationErrors: []
sbg:workflowLanguage: CWL
sbg:wrapperAuthor: Rachel Bowen-James <rbowen-james@ccia.org.au>
