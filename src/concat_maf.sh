#!/usr/bin/sh

PROJECT_DIR="/home/tichit/sync/Recherche/AnnieNguyen/networkTALL/"
PROCESSEDDATA_DIR="$PROJECT_DIR/processed_data/"

for I in P2 P3
do
  MSM_DIR="$PROJECT_DIR/GDCdata/TARGET-ALL-${I}/harmonized/Simple_Nucleotide_Variation/Masked_Somatic_Mutation/"
  zcat $GDCDATA_DIR/$MSM_DIR/*/*.gz | grep -v '^#' | grep -v '^Hugo' > "$PROCESSEDDATA_DIR/tALL_SNV_${I}.tsv"
done

