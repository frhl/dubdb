#!/usr/bin/env Rscript

library(argparse)
library(data.table)

null_omit <- function(lst) {
    lst[!vapply(lst, is.null, logical(1))]
}

main <- function(args){

    # read auxillary files
    enz <- fread('/well/lindgren/flassen/ressources/genesets/genesets/data/ubiquitin/dubs_e3_zhu.txt')
    pfam <- fread('/well/lindgren/flassen/ressources/pfam/releases/pfam35.0//Pfam-A.clans.tsv.gz', header = FALSE)
    colnames(pfam) <- c('csqs.domains.name','pfam.clan','pfam.type1','pfam.type2','pfam.description')
    
    # subset to relevant genes
    domains <- fread(args$input_path)
    domains <- domains[domains$csqs.gene_id %in% enz$ensembl_gene_id, ]
    domains <- domains[domains$consequence_category %in% c('pLoF','damaging_missense'),]
    mrg <- merge(domains, pfam, all.x = TRUE)

    # remove various columns
    mrg$csqs.gene_pheno <- NULL
    mrg$csqs.hgvsc <- NULL
    mrg$csqs.hgvsp <- NULL
    mrg$csqs.hgvs_offset <- NULL
    mrg$csqs.lof_info <- NULL
    mrg$csqs.minimised <- NULL
    mrg$csqs.domains.name <- NULL
    mrg$rsid <- NULL
    mrg$chr <- args$chrom

    # re-order columns
    start <- c('csqs.gene_symbol','chrom','csqs.most_severe_consequence','consequence_category','pfam.clan','pfam.type1', 'pfam.type2', 'pfam.description')
    mrg <- cbind(mrg[,colnames(mrg) %in% start, with = FALSE], mrg[,! colnames(mrg) %in% start, with = FALSE])
    fwrite(mrg, args$output_path, sep = args$delimiter, quote = FALSE) 

}

# add arguments
parser <- ArgumentParser()
parser$add_argument("--chrom", default=NULL, help = "?")
parser$add_argument("--input_path", default=NULL, help = "?")
parser$add_argument("--output_path", default=NULL, help = "?")
parser$add_argument("--delimiter", default="\t", help = "?")
args <- parser$parse_args()

main(args)

