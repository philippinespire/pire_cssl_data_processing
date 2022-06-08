# correcting naming format for metadata summary

the names of these files are both non-standard format and dont match those from other directories in this project.  Consequently, I did the following to change th$

the root cause of this has been solved, and this is an anomly, so changing the metadata file read into R is the simplest solution

```bash
# commands run from this dir
# backup metadata file
cp multiqc_fastqc.txt multiqc_fastqc_backup.txt
# then I made seqid_sample.txt from the raw fqgz dir
cat <(echo -e seq_id\tSample) <(paste <(raw_fq_capture/*1.fq.gz | sed -e 's/^.*\///' -e 's/_.*$//') <(raw_fq_capture/*1.fq.gz | sed -e 's/^.*\///' -e 's/\(_L[1-9]\)_.*$/\1/')) > seqid_sample.txt
# then I replaced the sample in multiqc_fastqc_backup.txt with that in seqid_sample.txt
paste <(sed 's/^Gmi\-...._...\-//' multiqc_fastqc_backup.txt | sed 's/-.*$//' | sed 's/Sample.*$/seq_id/' ) \
<(cat multiqc_fastqc_backup.txt | cut -f2-) | \
awk 'NR==FNR{a[$1]=$1OFS$2;next}{$1=a[$1];print}' OFS='\t' seqid_sample.txt - | \
grep -Pv "^\t" | \
cut -f2- > multiqc_fastqc.txt
```

