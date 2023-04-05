## Download and process TCGA data from GDC portal

## this is done via a for loop through the TCGA project names 
## the following steps are carried out for each project

## create queries for each omics
## see which submittor_sampleType_vial ids (considered to be the sample) have all omics
## recreate the queries to only include these samples
## download the files for each omics
## the TCGAbiolinks package automatically creates folders to store these
## import the files into R
## TCGAbiolinks creates an object containing all samples for the omics
## export the object as an rds
## delete the folder containing the downloaded files

## load neccessary libraries

library(TCGAbiolinks)

## get the vector of TCGA projects

ProjectsAll = TCGAbiolinks:::getGDCprojects()$project_id
ProjectsTCGA = ProjectsAll[substr(ProjectsAll,1,5)=="TCGA-"]

## subset for testing

# ProjectsTCGA = c("TCGA-LIHC", "TCGA-GBM")

## keep a record of how many primary ids have all omics 
## and for which projects data has been downloaded

# all_ids_count = integer()
# ProjectsDownloaded = character()

## create a directory to save the final files

SaveDirectory = "DownloadedData"
if(!dir.exists(SaveDirectory)){
  dir.create(SaveDirectory, showWarnings = FALSE, recursive = TRUE)
}

## loop through the projects

for (Prjct in ProjectsTCGA){

  ## initiate queries
  
  query_mRNA <- GDCquery(
    project = Prjct, 
    data.category = "Transcriptome Profiling", 
    data.type = "Gene Expression Quantification"
  )
  
  query_miRNA <- GDCquery(
    project = Prjct,  
    data.category = "Transcriptome Profiling", 
    data.type = "miRNA Expression Quantification"
  )
  
  query_DNAme <- GDCquery(
    project = Prjct,
    data.category = "DNA Methylation", 
    data.type = "Methylation Beta Value"
  )
  
  query_SNV <- GDCquery(
    project = Prjct, 
    data.category = "Simple Nucleotide Variation", 
    access = "open", 
    data.type = "Masked Somatic Mutation"
  )
  
  ## result summaries of the queries
  
  query_mRNA_res = getResults(query_mRNA)
  query_miRNA_res = getResults(query_miRNA)
  query_DNAme_res = getResults(query_DNAme)
  query_SNV_res = getResults(query_SNV)

  
  ## primary ids
  
  mRNA_id = substr(query_mRNA_res$cases,1,16)
  miRNA_id = substr(query_miRNA_res$cases,1,16)
  DNAme_id = substr(query_DNAme_res$cases[query_DNAme_res$platform=="Illumina Human Methylation 450"],1,16)
  SNV_id = substr(query_SNV_res$cases,1,16)
  
  ## unique intersection
  
  all_ids = unique(
    base::intersect(base::intersect(base::intersect(mRNA_id,
                                                    miRNA_id),
                                    DNAme_id),
                    SNV_id)
  )
  
  ## count the number of files and keep a record
  all_ids_count_tmp = length(all_ids)
  # all_ids_count = c(all_ids_count, all_ids_count_tmp)
  
  ## if there are files then download
  
  if (all_ids_count_tmp > 0){
    
    ## new filtered queries
    
    query_mRNA <- GDCquery(
      project = Prjct, 
      data.category = "Transcriptome Profiling", 
      data.type = "Gene Expression Quantification",
      barcode = all_ids
    )
    
    query_miRNA <- GDCquery(
      project = Prjct,  
      data.category = "Transcriptome Profiling", 
      data.type = "miRNA Expression Quantification",
      barcode = all_ids
    )
    
    query_DNAme <- GDCquery(
      project = Prjct,
      data.category = "DNA Methylation", 
      data.type = "Methylation Beta Value",
      platform = "Illumina Human Methylation 450",
      barcode = all_ids
    )
    
    query_SNV <- GDCquery(
      project = Prjct, 
      data.category = "Simple Nucleotide Variation", 
      access = "open", 
      data.type = "Masked Somatic Mutation",
      barcode = all_ids
    )
    
    ## download the files
    
    GDCdownload(query_mRNA, files.per.chunk = 45)
    GDCdownload(query_miRNA)
    GDCdownload(query_DNAme, files.per.chunk = 45)
    GDCdownload(query_SNV)
    
    ## load the files into R and aggregate for each omics
    
    expdat_mRNA <- GDCprepare(query = query_mRNA)
    expdat_miRNA <- GDCprepare(query = query_miRNA)
    expdat_DNAme <- GDCprepare(query = query_DNAme)
    expdat_SNV <- GDCprepare(query = query_SNV)
    
    ## save these as rds files
    
    saveRDS(expdat_mRNA, file.path(SaveDirectory,paste0(Prjct,"_mRNA.rds")))
    saveRDS(expdat_miRNA, file.path(SaveDirectory,paste0(Prjct,"_miRNA.rds")))
    saveRDS(expdat_DNAme, file.path(SaveDirectory,paste0(Prjct,"_DNAme.rds")))
    saveRDS(expdat_SNV, file.path(SaveDirectory,paste0(Prjct,"_SNV.rds")))
    
    # ProjectsDownloaded = c(ProjectsDownloaded,Prjct)
    
    
    ## delete the downloaded raw data files
    
    unlink(file.path("GDCdata",Prjct),recursive=TRUE)
  
  }
  
  ## delete query and objects and make space on local memory?
  # rm(list=c("query_mRNA", "query_miRNA", "query_DNAme", "query_SNV",
  #           "query_mRNA_res", "query_miRNA_res", "query_DNAme_res","query_SNV_res",
  #           "mRNA_id", "miRNA_id", "DNAme_id", "SNV_id", "all_ids", "all_ids_count_tmp",
  #           "expdat_mRNA", "expdat_miRNA", "expdat_DNAme", "expdat_SNV"))
  # gc()
  
}

## export a record of the download loop results

# DownloadRecord = list(
#   ProjectsTCGA = ProjectsTCGA,
#   all_ids_count = all_ids_count,
#   ProjectsDownloaded = ProjectsDownloaded
# )
# 
# saveRDS(DownloadRecord, file.path(SaveDirectory,"DownloadRecord.rds"))


