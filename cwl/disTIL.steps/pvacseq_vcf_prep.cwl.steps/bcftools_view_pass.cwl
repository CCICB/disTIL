cwlVersion: v1.0
class: CommandLineTool
label: bcftools-view-pass
$namespaces:
  sbg: https://www.sevenbridges.com/

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: rachelbj/samtools:1.10.0
- class: InlineJavascriptRequirement
  expressionLib:
  - |2-

    var setMetadata = function(file, metadata) {
        if (!('metadata' in file))
            file['metadata'] = metadata;
        else {
            for (var key in metadata) {
                file['metadata'][key] = metadata[key];
            }
        }
        return file
    };

    var inheritMetadata = function(o1, o2) {
        var commonMetadata = {};
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
        }
        if (!Array.isArray(o1)) {
            o1 = setMetadata(o1, commonMetadata)
        } else {
            for (var i = 0; i < o1.length; i++) {
                o1[i] = setMetadata(o1[i], commonMetadata)
            }
        }
        return o1;
    };

inputs:
- id: vcf
  label: VCF
  doc: VCF to filter.
  type: File

outputs:
- id: pass_filtered_vcf
  label: Pass Filtered VCF
  doc: Input VCF filtered to contain only PASS variants.
  type: File
  outputBinding:
    glob: '*pass.vcf'
    outputEval: $(inheritMetadata(self, inputs.vcf))

baseCommand: []
arguments:
- prefix: ''
  position: 1
  valueFrom: |-
    ${
        var full = inputs.vcf.path
        var split_full = full.split('/')
        var base = split_full[split_full.length -1]
        var split_base = base.split('vcf')
        var out = split_base[0] + 'pass.vcf'
        
        var cmd = "bcftools view -f PASS " + inputs.vcf.path + " > " + out
        return cmd
    }
  separate: false
  shellQuote: false
id: bcftools_view_pass
