#!/usr/bin/env bash
#
#$ -N extract_ccds
#$ -wd /well/lindgren-ukbb/projects/ukbb-11867/flassen/projects/dubdb
#$ -o logs/extract_ccds.log
#$ -e logs/extract_ccds.errors.log
#$ -P lindgren.prjc
#$ -pe shmem 1
#$ -q short.qc@@short.hga


set -o errexit
set -o nounset

readonly in_dir="data/mt/vep"
readonly in_prefix="${in_dir}/ukb_eur_wes_200k_csqs_chr"

readonly out_dir="data/ccds"
readonly out_file="${out_dir}/ukb_wes_200k_ccds.txt"

mkdir -p ${out_dir}

zcat ${in_prefix}*.tsv.gz | cut -f14 | grep -v NA | sort | uniq > ${out_file} 


