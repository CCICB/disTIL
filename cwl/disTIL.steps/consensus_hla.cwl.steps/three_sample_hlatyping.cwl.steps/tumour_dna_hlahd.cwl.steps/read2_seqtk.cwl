cwlVersion: v1.2
class: CommandLineTool
label: seqtk
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: nanozoo/seqtk:latest
- class: InlineJavascriptRequirement
  expressionLib:
  - |2-

    var setMetadata = function(file, metadata) {
        if (!('metadata' in file)) {
            file['metadata'] = {}
        }
        for (var key in metadata) {
            file['metadata'][key] = metadata[key];
        }
        return file
    };
    var inheritMetadata = function(o1, o2) {
        var commonMetadata = {};
        if (!o2) {
            return o1;
        };
        if (!Array.isArray(o2)) {
            o2 = [o2]
        }
        for (var i = 0; i < o2.length; i++) {
            var example = o2[i]['metadata'];
            for (var key in example) {
                if (i == 0)
                    commonMetadata[key] = example[key];
                else {
                    if (!(commonMetadata[key] == example[key])) {
                        delete commonMetadata[key]
                    }
                }
            }
            for (var key in commonMetadata) {
                if (!(key in example)) {
                    delete commonMetadata[key]
                }
            }
        }
        if (!Array.isArray(o1)) {
            o1 = setMetadata(o1, commonMetadata)
            if (o1.secondaryFiles) {
                o1.secondaryFiles = inheritMetadata(o1.secondaryFiles, o2)
            }
        } else {
            for (var i = 0; i < o1.length; i++) {
                o1[i] = setMetadata(o1[i], commonMetadata)
                if (o1[i].secondaryFiles) {
                    o1[i].secondaryFiles = inheritMetadata(o1[i].secondaryFiles, o2)
                }
            }
        }
        return o1;
    };

inputs:
- id: seed
  label: seed
  doc: Seed for value for random subsampling
  type: int
  default: 1
  inputBinding:
    prefix: -s
    position: 0
    shellQuote: false
- id: input_fastq
  type: File
  inputBinding:
    position: 1
    shellQuote: false
  sbg:fileTypes: fastq.gz, FASTQ.GZ
- id: num_reads
  type: int
  inputBinding:
    position: 2
    shellQuote: false

outputs:
- id: subsampled_fastq
  label: subsampled compressed fastq
  type: File
  outputBinding:
    glob: '*subsample.fastq.gz'
    outputEval: $(inheritMetadata(self, inputs.input_fastq))
  sbg:fileTypes: fastq.gz, FASTQ.GZ
stdout: |-
  ${
      var elements = inputs.input_fastq.basename.split('.');
      var filename = elements[0];
      
      return filename + '_subsample.fastq.gz'
  }

baseCommand:
- seqtk
- sample
arguments:
- prefix: ''
  position: 3
  valueFrom: '| gzip -c'
  shellQuote: false
- prefix: ''
  position: 0
  valueFrom: '-2'
  shellQuote: false
id: mwonge/ccicb-distil/seqtk/14
sbg:appVersion:
- v1.2
sbg:content_hash: a340db0df0cd4ccdb749f5229c26cbe4e1d03dacaaa04d2c14efec69578eea497
sbg:contributors:
- alanwu
sbg:createdBy: alanwu
sbg:createdOn: 1651205320
sbg:id: mwonge/ccicb-distil/seqtk/14
sbg:image_url:
sbg:latestRevision: 14
sbg:modifiedBy: alanwu
sbg:modifiedOn: 1651621373
sbg:project: mwonge/ccicb-distil
sbg:projectName: ccicb-distil
sbg:publisher: sbg
sbg:revision: 14
sbg:revisionNotes: add back -2 pass to save memory
sbg:revisionsInfo:
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1651205320
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1651207595
  sbg:revision: 1
  sbg:revisionNotes: ''
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1651210030
  sbg:revision: 2
  sbg:revisionNotes: specify file full path in command
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1651452010
  sbg:revision: 3
  sbg:revisionNotes: remove gzip
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1651452629
  sbg:revision: 4
  sbg:revisionNotes: ''
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1651453305
  sbg:revision: 5
  sbg:revisionNotes: specify output file glob
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1651460289
  sbg:revision: 6
  sbg:revisionNotes: redirect stdout
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1651462042
  sbg:revision: 7
  sbg:revisionNotes: ''
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1651463257
  sbg:revision: 8
  sbg:revisionNotes: redirect stdout to working dir
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1651470259
  sbg:revision: 9
  sbg:revisionNotes: add boolean switch
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1651534327
  sbg:revision: 10
  sbg:revisionNotes: gzip output from seqtk
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1651537902
  sbg:revision: 11
  sbg:revisionNotes: use 2-pass mode to save memory
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1651556362
  sbg:revision: 12
  sbg:revisionNotes: -2 option too slow
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1651557857
  sbg:revision: 13
  sbg:revisionNotes: remove boolean to subsample flag
- sbg:modifiedBy: alanwu
  sbg:modifiedOn: 1651621373
  sbg:revision: 14
  sbg:revisionNotes: add back -2 pass to save memory
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
