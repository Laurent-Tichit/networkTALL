setwd('/home/tichit')

#get list of interesting files
paths <- list.files(
    path = 'GDCdata/TARGET-ALL-P2/harmonized/Transcriptome_Profiling/',
    full.name = TRUE,
    recursive = TRUE,
    pattern = '*.tsv'
  )
#their number
nb.samples <- length(paths)
#the short name of each file: sample ID
sample.names <- substr(basename(paths), 1, 36)

#get transcript names from first file: paths[1]
#skip the first rows (uninteresting)
transcript.names <- read.delim(paths[1], skip = 6, header = FALSE)[1][[1]] #get only the 1st column [1] then extract to vector [[1]]
#their number
nb.transcripts <- length(transcript.names)

#create empty matrix of right size
m <- matrix(
    nrow = nb.samples,
    ncol = nb.transcripts,
    byrow = TRUE,
    dimnames = list(sample.names, transcript.names)
  )

# fill matrix row by row (sample by sample)
# we use the 9th row only (normalized fpkm)
# for raw counts we should use another column
for (i in 1:length(paths)) {
  print(paste0("processing file ", i, "/", nb.samples, ": ", basename(paths[[i]])))
  m[i,]  <- read.delim(paths[[i]], skip = 6, header = FALSE)[9][[1]]
}

write.table(m, "RNASeq.tsv")
