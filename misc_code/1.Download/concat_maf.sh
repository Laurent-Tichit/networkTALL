#!/usr/bin/sh

zcat */*.gz | grep -v '^#' | grep -v '^Hugo' > snv_data_all.tsv

