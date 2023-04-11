library('TCGAbiolinks')

query_P2_clinical <- GDCquery(
  project = "TARGET-ALL-P2",
  data.category = "Clinical",
  access = "controlled",
  data.type = "Clinical Supplement")
GDCdownload(query_P2_clinical)
expdat_P2_clinical <- GDCprepare(query = query_P2_clinical)


query_P3_clinical <- GDCquery(
  project = "TARGET-ALL-P3",
  data.category = "Clinical",
  access = "open",
  data.type = "Clinical Supplement")
GDCdownload(query_P3_clinical)
expdat_P3_clinical <- GDCprepare(query = query_P3_clinical)


# it will download one big xlsx file to GDCdata/TARGET-ALL-P2/harmonized/Clinical 
# https://bioconductor.org/packages/release/bioc/vignettes/TCGAbiolinks/inst/doc/download_prepare.html#Clinical
# https://bioconductor.org/packages/release/bioc/manuals/TCGAbiolinks/man/TCGAbiolinks.pdf
query_AML_clinical <- GDCquery(
  project = "TARGET-AML",
  data.category = "Clinical",
  access = "open",
  data.type = "Clinical Supplement")
GDCdownload(query_AML_clinical)
expdat_AML_clinical <- GDCprepare(query = query_AML_clinical)
