cwlVersion: v1.2
class: CommandLineTool
label: tmb
doc: |-
  # About this tool
  This tool calculates Tumour Mutational Burden (TMB) from a VEP-annotated somatic VCF file (or the variant effects must have been recorded). 

  ## Calculation
  TMB is calculated as the number of canonical somatic missense variants divided by the coding exon size.
  The coding exon size is calculated from a reference genome as follows:
  - Download the coding exon BED file for GENCODE/Ensembl genes from the UCSC Table Browser
  - Remove alternative contigs
  - Collpase overlapping regions
  - Remove problematic regions by subtracting the Boyle Lab blacklist - this BED is used for filtering VCFs
  - Count bases in the coding regions remaining in the BED file

  The input VCF is filtered for 'PASS' variants and intersected with the coding exon BED (indicated above) prior to counting the missense canonical variants.

  ## Outputs
  - Number of variants: the number of missense canonical variants in the input VCF (with 'PASS' filter and intersected with coding exons BED)
  - TMB: calculated by dividing the number of variants by the coding exon size for the genome build selected

  ## Docker
  This tool uses the Docker image: `rachelbj/tmb:1.0`

  ## Documentation
  - [Boyle Lab Blacklists](https://github.com/Boyle-Lab/Blacklist)
  - [UCSC Table Browser](http://genome.ucsc.edu/cgi-bin/hgTables)
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: rachelbj/tmb:1.0
- class: InlineJavascriptRequirement

inputs:
- id: vcf
  label: Input VCF
  doc: VCF from which to calculate TMB.
  type: File
  inputBinding:
    position: 1
    separate: false
    shellQuote: false
  loadContents: true
  sbg:fileTypes: VCF, VCF.GZ
- id: reference_build
  label: Reference Build
  doc: Reference genome build. This determines the denominator of the TMB calculation.
  type:
    name: reference_build
    type: enum
    symbols:
    - hg19
    - hg38

outputs:
- id: tmb
  type: float
  outputBinding:
    glob: tmb
    outputEval: $(String(self[0].contents).replace(/(\r\n|\n|\r)/gm, ""))
    loadContents: true
- id: variants
  label: Canonical Missense Coding Variants
  doc: Number of missense canonical variants in with filter 'PASS'.
  type: int
  outputBinding:
    glob: variants
    outputEval: $(String(self[0].contents).replace(/(\r\n|\n|\r)/gm, ""))
    loadContents: true

baseCommand: []
arguments:
- prefix: ''
  position: 0
  valueFrom: 'e=`bedtools intersect -header -a '
  separate: false
  shellQuote: false
- prefix: ''
  position: 2
  valueFrom: |-
    ${
        var denom = 0
        if (inputs.reference_build == "hg38") {
            var denom = 34.5
            var bed = "/app/gencode_basic_v38.coding.exons.collapsed.filtered.grch38.bed"
        } else {
            var denom = 34.9
            var bed = "/app/ensembl_genes.coding.exons.collapsed.filtered.grch37.bed"
        }
        var cmd = '-b ' + bed + '| bcftools view -H -f PASS | grep -E "missense[^,]+protein_coding[^,]+Ensembl" | wc -l`'
        cmd = cmd + "; perl -E \"say sprintf('%.2f',$e/" + denom + ")\" > tmb;"
        return cmd
    }
  separate: false
  shellQuote: false
- prefix: ''
  position: 3
  valueFrom: echo $e > variants;
  separate: false
  shellQuote: false
id: mwonge/ccicb-distil/tmb/9
sbg:appVersion:
- v1.2
sbg:content_hash: af98627380f3efbaa6df241195858635eb41c4da31889c21860fb8bf484197ab8
sbg:contributors:
- alanwu
sbg:createdBy: alanwu
sbg:createdOn: 1653615626
sbg:id: mwonge/ccicb-distil/tmb/9
sbg:image_url:
sbg:latestRevision: 9
sbg:modifiedBy: alanwu
sbg:modifiedOn: 1657865775
sbg:project: mwonge/ccicb-distil
sbg:projectName: ccicb-distil
sbg:publisher: sbg
sbg:revision: 9
sbg:revisionNotes: ''
sbg:revisionsInfo:
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1653615626
  sbg:revision: 0
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.02.18. 
    Source: 
    repo: git@github.com:rbowenj/disTIL.git
    file: tools/tmb.cwl
    commit: d27541f
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1653870079
  sbg:revision: 1
  sbg:revisionNotes: ''
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1653878729
  sbg:revision: 2
  sbg:revisionNotes: ''
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1653879119
  sbg:revision: 3
  sbg:revisionNotes: Input must be VEP annotated
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1657674134
  sbg:revision: 4
  sbg:revisionNotes: ''
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1657852380
  sbg:revision: 5
  sbg:revisionNotes: ''
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1657854360
  sbg:revision: 6
  sbg:revisionNotes: ''
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1657860066
  sbg:revision: 7
  sbg:revisionNotes: ''
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1657864716
  sbg:revision: 8
  sbg:revisionNotes: ''
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1657865775
  sbg:revision: 9
  sbg:revisionNotes: ''
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
