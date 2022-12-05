# NOTES


code to make file of contigs w snps

```bash
tail -n +65 mkBAMbaitREF_contam_Albatross/TotalRawSNPs.ssl.Sgr-SgC0072C-contam-R1R2-noIsolate-fromPROBES.vcf | cut -f1 | uniq | tr "_" "\t" | sort -nk2,2 | uniq > mkBAMbaitREF_contam_Albatross/contigs_w_snps.tsv
```
