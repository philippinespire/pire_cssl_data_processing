# BAM Summary Stats

---

## [`getCVG.sbatch`](https://github.com/cbirdlab/rroberts_thesis/blob/main/scripts/bam_processing/getCVG.sbatch)

outputs one file per library with summary coverage stats on each contig

each row is a contig

see [samtools coverage](http://www.htslib.org/doc/samtools-coverage.html)

2 arguments are neccesary to run the script. $1 the directory containing the bam files, and $2 an out directory for the created files to be written into. A third optional arument can be used when bam files do not follow the \*-RG.bam naming scheme. By default it will recognize all bam files ending in -RG.bam. If your files are named something diffrent or you want to be more specific with what is run $3 will be that pattern. Do not add a \* infront of the pattern, the script already adds one.

### This is the code that was run using this script

```bash
# Done on USER@wahab.hpc.odu.edu server. 
# SPECIES should be replaced with the directory that contains the bam files. 
# In our case it will be Adu, Aur, etc...
cd /home/cbird/roy/rroberts_thesis/summary_data_ssl
sbatch ../scripts/bam_processing/getCVG.sbatch dDocentHPC_data/SPECIES/ out_cvg/ fltred.bam
```

---

## [`getSTATS.sbatch`](https://github.com/cbirdlab/rroberts_thesis/blob/main/scripts/bam_processing/getSTATS.sbatch)

outputs one file per library with summary coverage stats that vary

each row is a contig

see [samtools coverage](http://www.htslib.org/doc/samtools-coverage.html)

2 arguments are neccesary to run the script. $1 the directory containing the bam files, and $2 an out directory for the created files to be written into. A third optional arument can be used when bam files do not follow the \*-RG.bam naming scheme. By default it will recognize all bam files ending in -RG.bam. If your files are named something diffrent or you want to be more specific with what is run $3 will be that pattern. Do not add a \* infront of the pattern, the script already adds one.

### This is an example of how the code can be run using this script

```bash
# Done on USER@wahab.hpc.odu.edu server. 
# SPECIES should be replaced with the directory that contains the bam files. 
# In our case it will be Adu, Aur, etc...
cd /home/cbird/roy/rroberts_thesis/summary_data_ssl
sbatch ../scripts/bam_processing/getSTATS.sbatch dDocentHPC_data/SPECIES/ out_bam_stats/ fltred.bam
```

---

## [`mappedReadStats.sbatch`](https://github.com/cbirdlab/rroberts_thesis/blob/main/scripts/bam_processing/mappedReadStats.sbatch)

outputs one file per directory of libraries with means stats on `filename numreads meanreadlength meandepth_wcvg numpos numpos_wcvg meandepth pctpos_wcvg`

each row is a library

see [samtools depth](http://www.htslib.org/doc/samtools-depth.html)
see [samtools coverage](http://www.htslib.org/doc/samtools-coverage.html)
see [samtools view](http://www.htslib.org/doc/samtools-view.html)

output goes to files:

* one file per directory of bam files

### This is an example of how the code was run using this script

Done on USER@wahab.hpc.odu.edu server. 
3 arguments are neccesary to run this script $1 Bam Dirctory, $2 Out Directory, and $3 Speceies key.
By default this script will recognize bam files ending with -RG.bam.
If a different file pattern is used then $4 should be that pattern. No * is neccessary.
In our case $3 will be Adu, Aur, etc...

```bash
# sbatch script $1 = bamdir $2 = outdir $3 = species $4 = bampattern
sbatch mappedReadStats.sbatch /home/cbird/roy/rroberts_thesis/sequencing_calculations/sandbox /home/cbird/roy/rroberts_thesis/sequencing_calculations/sandbox Sfa fltrd.bam
```

---
