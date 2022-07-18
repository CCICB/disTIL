cwlVersion: v1.0
class: CommandLineTool
label: vep-with-plugins
doc: |-
  #About VEP
  VEP determines the effect of your variants (SNPs, insertions, deletions, CNVs or structural variants) on genes, transcripts, and protein sequence, as well as regulatory regions.

  Simply input the coordinates of your variants and the nucleotide changes to find out the:
  Genes and Transcripts affected by the variants
  Location of the variants (e.g. upstream of a transcript, in coding sequence, in non-coding RNA, in regulatory regions)
  Consequence of your variants on the protein sequence (e.g. stop gained, missense, stop lost, frameshift), see variant consequences
  Known variants that match yours, and associated minor allele frequencies from the 1000 Genomes Project
  SIFT and PolyPhen-2 scores for changes to protein sequence
  ... And more! See data types, versions.

  # About this CWL tool
  This tool is intended for VEP annotation of VCF files prior to neoantigen prediction using pVACseq ([info](https://pvactools.readthedocs.io/en/latest/pvacseq/input_file_prep/vep.html)). All VEP options required for pVACseq are exposed as app settings, plus some additional options. 

  ## Cache
  The VEP cache must be supplied as a `tar.gz`. Caches can be downloaded from [VEP release page](http://ftp.ensembl.org/pub/). It is recommended that the cache version used matches the VEP release number (note that this app uses the latest VEP release. See [here](https://hub.docker.com/r/ensemblorg/ensembl-vep/tags?page=1&ordering=last_updated) to find out the latest VEP release number). As of July 2021, the latest VEP release was version 104.

  ### Merged
  If the cache version used is merged, the `--merged` flag must be used. This is achieved by setting the 'merged' input option to 'Yes'. 

  ## Plugins
  pVACseq requires the use of the Frameshift and Wildtype plugins, available for download [here](https://github.com/griffithlab/pVACtools/tree/master/tools/pvacseq/VEP_plugins).

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: ensemblorg/ensembl-vep:release_104.3
- class: InitialWorkDirRequirement
  listing:
  - $(inputs.vep_plugin_files)
  - $(inputs.vep_cache)
- class: InlineJavascriptRequirement

inputs:
- id: input_file
  label: Input File
  doc: Input VCF to VEP annotate. Can be bgzipped.
  type: File
  inputBinding:
    prefix: --input_file
    position: 3
    shellQuote: false
- id: vep_cache
  label: VEP Cache
  doc: |-
    VEP cache supplied as a tar.gz. Caches can be downloaded from [VEP release page](http://ftp.ensembl.org/pub/). It is recommended that the cache version used matches the VEP release number (note that this app uses the latest VEP release. See [here](https://hub.docker.com/r/ensemblorg/ensembl-vep/tags?page=1&ordering=last_updated) for more info).
  type: File
- id: ref_genome
  label: Reference Genome
  doc: The reference genome FASTA file to use to look up reference sequence.
  type: File
  inputBinding:
    prefix: --fasta
    position: 3
    shellQuote: false
- id: vep_plugin_files
  label: VEP Plugin Files
  doc: Optional VEP plugin files to use when annotating the input VCF.
  type: File[]?
- id: cache_version
  label: Cache Version
  doc: |-
    Version number of the cache used. It is recommended that the cache version used matches the VEP release number (note that this app uses the latest VEP release. See [here](https://hub.docker.com/r/ensemblorg/ensembl-vep/tags?page=1&ordering=last_updated) for more info).
  type: int
  inputBinding:
    prefix: --cache_version
    position: 3
    shellQuote: false
- id: merged
  label: Merged
  doc: |-
    Use the merged Ensembl and RefSeq cache. Consequences are flagged with the SOURCE of each transcript used.
    NOTE: This flag MUST be used if the cache is merged.
  type: boolean
  inputBinding:
    position: 6
    valueFrom: |-
      ${
          if (inputs.merged == true) {
              return '--merged'
          } else {
              return ''
          }
          
      }
    separate: false
    shellQuote: false
- id: symbol
  label: Symbol
  doc: Adds the gene symbol (e.g. HGNC) (where available) to the output.
  type: boolean?
  inputBinding:
    position: 6
    valueFrom: |-
      ${
          if (inputs.symbol == true) {
              return '--symbol'
          } else {
              return ''
          }
      }
    separate: false
    shellQuote: false
- id: biotype
  label: Biotype
  doc: Adds the biotype of the transcript or regulatory feature.
  type: boolean?
  inputBinding:
    position: 6
    valueFrom: |-
      ${
          if (inputs.biotype == true) {
              return '--biotype'
          } else {
              return ''
          }
          
      }
    separate: false
    shellQuote: false
- id: numbers
  label: Numbers
  doc: Adds affected exon and intron numbering to to output. Format is Number/Total.
  type: boolean?
  inputBinding:
    position: 6
    valueFrom: |-
      ${
          if (inputs.numbers == true) {
              return '--numbers'
          } else {
              return ''
          }
      }
    separate: false
    shellQuote: false
- id: canonical
  label: Canonical
  doc: |-
    Adds a flag indicating if the transcript is the canonical transcript for the gene.
  type: boolean?
  inputBinding:
    position: 6
    valueFrom: |-
      ${
          if (inputs.canonical == true) {
              return '--canonical'
          } else {
              return ''
          }
      }
    separate: false
    shellQuote: false
- id: total_length
  label: Total Length
  doc: Give cDNA, CDS and protein positions as Position/Length.
  type: boolean?
  inputBinding:
    position: 6
    valueFrom: |-
      ${
          if (inputs.total_length == true) {
              return '--total_length'
          } else {
              return ''
          }
      }
    separate: false
    shellQuote: false
- id: sift
  label: Sift
  doc: |-
    Species limited SIFT predicts whether an amino acid substitution affects protein function based on sequence homology and the physical properties of amino acids. VEP can output the prediction term, score or both.
  type:
  - 'null'
  - name: sift
    type: enum
    symbols:
    - p
    - s
    - b
  inputBinding:
    position: 6
    valueFrom: |-
      ${
          if (inputs.sift == null) {
              return ''
          } else {
              return '--sift ' + inputs.sift
          }
      }
    separate: false
    shellQuote: false
- id: polyphen
  label: Polyphen
  doc: |-
    Human only PolyPhen is a tool which predicts possible impact of an amino acid substitution on the structure and function of a human protein using straightforward physical and comparative considerations. VEP can output the prediction term, score or both.
  type:
  - 'null'
  - name: polyphen
    type: enum
    symbols:
    - p
    - s
    - b
  inputBinding:
    position: 6
    valueFrom: |-
      ${
          if (inputs.polyphen == null) {
              return ''
          } else {
              return '--polyphen ' + inputs.polyphen
          }
      }
    separate: false
    shellQuote: false
- id: terms
  label: Terms
  doc: |-
    The type of consequence terms to output. The Ensembl terms are described [here](https://www.ensembl.org/info/genome/variation/prediction/predicted_data.html#consequences). The Sequence Ontology is a joint effort by genome annotation centres to standardise descriptions of biological sequences.
  type:
  - 'null'
  - name: terms
    type: enum
    symbols:
    - SO
    - display
    - NCBI
  inputBinding:
    position: 6
    valueFrom: |-
      ${
          if (inputs.terms == null) {
              return ''
          } else {
              return '--terms ' + inputs.terms
          }
      }
    separate: false
    shellQuote: false

outputs:
- id: vep_vcf
  label: Annotated VCF
  doc: VEP annotated VCF file.
  type: File
  outputBinding:
    glob: '*.vep.vcf'
- id: vep_stats
  label: VEP Stats
  doc: Stats file produced by VEP.
  type: File?
  outputBinding:
    glob: '*.vep.html'

baseCommand: []
arguments:
- prefix: --dir_cache
  position: 4
  valueFrom: "${\n    return './cache'\n}"
  shellQuote: false
- prefix: --output_file
  position: 4
  valueFrom: |-
    ${
        var in_file = inputs.input_file.basename
        
        if (in_file.endsWith(".gz")) {
            var out_file = in_file.replace('.vcf.gz', '.vep.vcf')
        } else {
            var out_file = in_file.replace('.vcf', '.vep.vcf')
        }
        
        return out_file
    }
  shellQuote: false
- prefix: --stats_file
  position: 5
  valueFrom: |-
    ${
        var in_file = inputs.input_file.basename
        
        if (in_file.endsWith(".gz")) {
            var out_file = in_file.replace('.vcf.gz', '.vep.html')
        } else {
            var out_file = in_file.replace('.vcf', '.vep.html')
        }
        
        return out_file
    }
  shellQuote: false
- prefix: --species
  position: 5
  valueFrom: homo_sapiens
  shellQuote: false
- prefix: ''
  position: 3
  valueFrom: |-
    --cache --format vcf --vcf --offline --fork 8 --no_progress --tsl --hgvs --shift_hgvs 1
  separate: false
  shellQuote: false
- prefix: ''
  position: 0
  valueFrom: |-
    mkdir ./plugins ${
      if (inputs.vep_plugin_files == null) {
        return ""
      }

      let mv_cmd = "";
      for (var i=0; i < inputs.vep_plugin_files.length; i++) {
        mv_cmd = mv_cmd + " && mv " + inputs.vep_plugin_files[i].path + " ./plugins/";
      }
      return mv_cmd;
    } && ls ./plugins 1>&2 &&
  separate: false
  shellQuote: false
- prefix: ''
  position: 2
  valueFrom: vep
  separate: false
  shellQuote: false
- prefix: ''
  position: 7
  valueFrom: |2-
     ${
        let plugin_cmd = "";
        for (var i=0; i < inputs.vep_plugin_files.length; i++) {
            plugin_split = inputs.vep_plugin_files[i].path.split('/')
            plugin = plugin_split[plugin_split.length-1].split('.')[0]
            plugin_cmd = plugin_cmd + "--plugin " + plugin + " ";
        }
        return plugin_cmd;
    }
  separate: false
  shellQuote: false
- prefix: ''
  position: 1
  valueFrom: |-
    ${
      var cache_bundle = inputs.vep_cache.basename
      return 'mkdir ./cache' + ' && tar -xvf ' + cache_bundle + ' -C ./cache &&'
    }
  separate: false
  shellQuote: false
- prefix: ''
  position: 10
  valueFrom: |-
    ${
        if (inputs.vep_plugin_files.length != 0) {
            return '--dir_plugins ./plugins'
        } else {
            return ''
        }
    }
  separate: false
  shellQuote: false
id: vep_with_plugins
