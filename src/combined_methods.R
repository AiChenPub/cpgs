library(gage)
library(Biobase)
library(limma)
library(EnrichmentBrowser)
library(edgeR)

######
args <- commandArgs(TRUE)
if (length(args) != 6){
  stop("Rscript combined_methods.R cgpshome expfile phefile datatype=[ma/rseq] species output_directory \n")
}
cgpshome <- args[1]
expf <- args[2]
phef <- args[3]
dtype <- args[4]  # read count
spe <- args[5]
outdir <- args[6]


########################
### source the codes ###
########################

source('./src/individual_methods.R')

gmtf <- file.path(cgpshome,paste0('data/kegg.',spe,'.gmt'))
grnf <- file.path(cgpshome,paste0('data/kegg.',spe,'.grn.tsv'))
if (file.exists(gmtf) & file.exists(grnf)){
  gene.sets <- read.gs.from.file(gmtf)
  grn <- read.grn.from.file(grnf)
} else{
  rs <- get.gs.grn.from.kegg(spe)
  gene.sets <- rs$gsl
  grn <- rs$grn
  write.gmt(gene.sets, gmtf)
  write.grn(grn, grnf)
}


expdata <- read.exp(expf)  # return matrix
pdata <- read.phe(phef) # return AnnotateDF
exset <- Biobase::ExpressionSet(assayData = expdata, phenoData = pdata)
exset <- norm.de.exp(exset,dtype)  # normalized and de analysis

cgps.methods <- function(){
  return (c('cepa','gage','ganpa','globaltest','gsa','gsea','padog','plage','safe'))
}

#library(foreach)
#library(doParallel)

run.all.mds.prl <- function(exset,gene.sets,grn,outdir){
  cl <- makeCluster(8)
  registerDoParallel(cl)
  mds <- cgps.methods()
  foreach (md=mds, .export = c("exset","gene.sets","grn","outdir",
                               "run.cepa","run.gage","run.ganpa","run.globaltest",
                               "run.gsa", "run.gsea","run.padog","run.plage","run.safe")) %dopar% {
    if (md %in% c('cepa','ganpa')){
      res <- eval(parse(text = paste0("run.",md,"(exset,gene.sets,grn)")))
    }else{
      res <- eval(parse(text = paste0("run.",md,"(exset,gene.sets)")))
    }
    write.table(res, file = file.path(outdir, paste0(md,'.tsv')),sep='\t',quote = F, row.names = F, col.names = T)
  }
}

#run.all.mds.prl(exset,gene.sets,grn,outdir)

run.all.mds <- function(exset,gene.sets,grn,outdir){
  #cl <- makeCluster(8)
  #registerDoParallel(cl)
  mds <- cgps.methods()
  for (md in mds) {
    if (md %in% c('cepa','ganpa')){
      res <- eval(parse(text = paste0("run.",md,"(exset,gene.sets,grn)")))
    }else{
      res <- eval(parse(text = paste0("run.",md,"(exset,gene.sets)")))
    }
    write.table(res, file = file.path(outdir, paste0(md,'.tsv')),sep='\t',quote = F, row.names = F, col.names = T)
  }
}
run.all.mds(exset,gene.sets,grn,outdir)

