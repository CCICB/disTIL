#!/usr/bin/python3

import sys
import os
from cyvcf2 import VCF
import tempfile
import csv
from subprocess import Popen, PIPE
from pysam import idxstats
import re

### ADDITIONAL FUNCTION ###
def check_chr_format(bam_file):
    chrom_1 = idxstats(bam_file).split('\n')[0].split('\t')[0]

    # Check if chromosome name contains 'chr' prefix
    if re.match('chr', chrom_1):
        has_prefix = True
    else:
        has_prefix = False
    return has_prefix

# Added arg has_prefix to this function
def generate_region_list(hash, has_prefix):
    print('Generating region list')
    fh = tempfile.NamedTemporaryFile('w', delete=False)
    writer = csv.writer(fh, delimiter='\t')
    for chr, positions in hash.items():
        for pos in sorted(positions.keys()):
            if has_prefix:
                writer.writerow(['chr' + chr, pos, pos])
            else:
                writer.writerow([chr, pos, pos])
    fh.close()
    return fh.name

### ADDED FUNCTION ###
def filter_sites_in_hash(has_prefix, region_list, bam_file, ref_fasta, prefixed_sample, output_dir, insertion_centric, map_qual, base_qual):
    print('Running bam-readcount ')
    bam_readcount_cmd = ['/usr/bin/bam-readcount', '-f', ref_fasta, '-l', region_list, '-w', '0', '-b', str(base_qual), '-q', str(map_qual)]
    if insertion_centric:
        bam_readcount_cmd.append('-i')
        output_file = os.path.join(output_dir, prefixed_sample + '_bam_readcount_indel.tsv')
    else:
        output_file = os.path.join(output_dir, prefixed_sample + '_bam_readcount_snv.tsv')
    bam_readcount_cmd.append(bam_file)
    execution = Popen(bam_readcount_cmd, stdout=PIPE, stderr=PIPE)
    stdout, stderr = execution.communicate()
    if execution.returncode == 0:
        with open(output_file, 'wb') as output_fh:
            # Added: if 'chr' chromosome prefix used, remove from bam-readcount tsv (won't be recognized in VCF by vatools)
            if has_prefix:
                string_stdout = stdout.decode().replace('chr', '')
                output_fh.write(string_stdout)
            else:
                output_fh.write(stdout)
    else:
        sys.exit(stderr)

#initializing these with default values
min_base_qual = 20
min_mapping_qual = 0

if len(sys.argv) == 7:
    (script_name, vcf_filename, sample, ref_fasta, bam_file, prefix, output_dir)= sys.argv
elif len(sys.argv) == 8:
    (script_name, vcf_filename, sample, ref_fasta, bam_file, prefix, output_dir, min_base_qual)= sys.argv
elif len(sys.argv) == 9: #elif instead of else for explicit safety
    (script_name, vcf_filename, sample, ref_fasta, bam_file, prefix, output_dir, min_base_qual, min_mapping_qual)= sys.argv

if prefix == 'NOPREFIX':
    prefixed_sample = sample
else:
    prefixed_sample = '_'.join([prefix, sample])

print('Reading VCF ...')
vcf_file = VCF(vcf_filename)
sample_index = vcf_file.samples.index(sample)

rc_for_indel = {}
rc_for_snp   = {}
print('Processing variants ...')
for variant in vcf_file:
    ref = variant.REF
    chr = variant.CHROM
    start = variant.start
    end = variant.end
    pos = variant.POS
    for var in  variant.ALT:
        if len(ref) > 1 or len(var) > 1:
            #it's an indel or mnp
            if len(ref) == len(var) or (len(ref) > 1 and len(var) > 1):
                sys.stderr.write("Complex variant or MNP will be skipped: %s\t%s\t%s\t%s\n" % (chr, pos, ref , var))
                continue
            elif len(ref) > len(var):
                #it's a deletion
                pos += 1
                unmodified_ref = ref
                ref = unmodified_ref[1]
                var = "-%s" % unmodified_ref[1:]
            else:
                #it's an insertion
                var = "+%s" % var[1:]
            if chr not in rc_for_indel:
                rc_for_indel[chr] = {}
            if pos not in rc_for_indel[chr]:
                rc_for_indel[chr][pos] = {}
            if ref not in rc_for_indel[chr][pos]:
                rc_for_indel[chr][pos][ref] = {}
            rc_for_indel[chr][pos][ref] = variant
        else:
            #it's a SNP
            if chr not in rc_for_snp:
                rc_for_snp[chr] = {}
            if pos not in rc_for_snp[chr]:
                rc_for_snp[chr][pos] = {}
            if ref not in rc_for_snp[chr][pos]:
                rc_for_snp[chr][pos][ref] = {}
            rc_for_snp[chr][pos][ref] = variant

# Added line
has_prefix = check_chr_format(bam_file)

if len(rc_for_snp.keys()) > 0:
    region_file = generate_region_list(rc_for_snp, has_prefix)
    filter_sites_in_hash(has_prefix, region_file, bam_file, ref_fasta, prefixed_sample, output_dir, False, min_mapping_qual, min_base_qual)
else:
    output_file = os.path.join(output_dir, prefixed_sample + '_bam_readcount_snv.tsv')
    open(output_file, 'w').close()

if len(rc_for_indel.keys()) > 0:
    region_file = generate_region_list(rc_for_indel, has_prefix)
    filter_sites_in_hash(has_prefix, region_file, bam_file, ref_fasta, prefixed_sample, output_dir, True, min_mapping_qual, min_base_qual)
else:
    output_file = os.path.join(output_dir, prefixed_sample + '_bam_readcount_indel.tsv')
    open(output_file, 'w').close()
