# changes made here

the file names are too long, so I renamed this files, removing the ref genome part of the names



## example of original names

Sgr-CMvi_092-Ex1-cssl.clmp.fp2_repr.ssl.Sgr-SgC0072C-contam-R1R2-noIsolate-fromPROBES-RG.baitCVG.hist.tsv


## example of new names
Sgr-CMvi_092-Ex1-cssl.baitCVG.hist.tsv

##

```bash
rename 's/\.clmp\.fp2_repr\.ssl\.Sgr\-SgC0072C\-contam\-R1R2\-noIsolate\-fromPROBES\-RG//' *.tsv
```
