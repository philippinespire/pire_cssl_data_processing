# CAPTURE SHOTGUN DATA PROCESSING & ANALYSIS

---

The purpose of this repo is to document the processing and analysis of capture shotgun data for the Philippines PIRE Project. 

For now, each species will get it's own directory in the repo.  Try to avoing putting dirs inside dirs inside dirs.  **The Lle dir will serve as the example to follow in terms of both directory structure and documentation of progress in `README.md`. The `README.md` structure for your species should follow this format as closely as possible.**

---

## Use Git/GitHub to Track Progress

To process a species, begin by cloning this repo to your dir.

```
git clone <insert url here>
```

The data will be processed and analyzed in the repo.  There is a `.gitignore` file that lists files and directories to be ignored by git.  It includes large files that git cannot handle (fq.gz, bam, etc) and other repos that might be downloaded into this repo.  For example, the dir `dDocentHPC` contains the [dDocentHPC](https://github.com/cbirdlab/dDocentHPC) repo which you will be using, but we don't need to save that to this repo, so `dDocentHPC/` occurs in  `.gitignore` so that it is not uploaded to github in this repo.

Because large data files will not be saved to github, they will reside in an individual's copy of the repo or somewhere on the HPC. You should provide paths (absolute/full paths are probably best) or info that make it clear where the files reside. Most of these large intermediate files should be deleted once it is confirmed that they worked. For example, we don't ultimately need the intermedate files produced by fastp, clumpify, fastq_screen.

A list of ongoing CSSL projects can be found below. If you are working on an CSSL analysis project (or if you wish to claim a project), please indicate so in the table.

|Species | Data availability | Analysis lead | Analysis status / notes |
| --- | --- | --- | --- |
|Aen | On ODU HPC | Rene | Pop gen (ongoing) |
|Gmi | On ODU HPC | Rene | Pop gen (ongoing) |
|Lle | On ODU HPC | Rene | Pop gen (ongoing) |
|Sde | On ODU HPC | Eric | QC complete? |
|Leq | On ODU HPC | John | Needs QC |
|Tbi | On ODU HPC | George | Needs QC |
|Tzo | On ODU HPC | Kyra | Needs QC |
|Hte | On ODU HPC | Brendan | Data generated with incorrect probes, some pops missing |

---

## Maintaining Git Repo

You must pull down the lated version of the repo everytime you sit down to work and push the changes you made everytime you walk away from the terminal.  The following order of operations when you sync the repo will minimize problems.

```
git pull
git add --all
git commit -m "insert message"
git pull
git push
```

If you should be met with a conflict screen, you are in the archane `vim` editor.  You can look up instructions on how to interface with it. I typically do the following:

* hit escape key twice
* type the following
  `:quit!`
  
___

## Data Processing Roadmap

1. Clone this repo to your working dir

2. Complete fq.gz preprocessing
    * go to the [pire_fq_gz_processing](https://github.com/philippinespire/pire_fq_gz_processing) repo and complete the steps then return here

3. Map processed reads against best reference genome
    * Best genome can be found by running [`wrangleData.R`](https://github.com/philippinespire/denovo_genome_assembly/tree/main/compare_assemblers), sorting tibble by busco or n50, and filtering by species 
    * Use [dDocentHPC mkBAM](https://github.com/cbirdlab/dDocentHPC) to map reads to ref
      * Use [`config.5.cssl`](https://github.com/cbirdlab/dDocentHPC/blob/master/configs/config.5.cssl) when running dDocentHPC as a starting point for the settings

4. Filter the `bam` files
    * Use [dDocentHPC fltrBAM](https://github.com/cbirdlab/dDocentHPC)
    * Visualize results with IGV or equivalent on a local computer to look for mapping artifacts
      * Look at both contemp and albatross (that goes for anything that follows)
    * Compare the filtered (`RG.bam`) to unfiltered (`RAW.bam`) files
      * Were a lot of reads lost?

5. Genotype the `bam` files
    * Use [`dDocentHPC mkVCF`](https://github.com/cbirdlab/dDocentHPC) 

6. Filter the `vcf` file
    * Use [`fltrVCF`](https://github.com/cbirdlab/fltrVCF)
      * Use [`config.fltr.ind.cssl`](https://github.com/cbirdlab/fltrVCF/blob/master/config_files/config.fltr.ind.cssl) as a starting point for filter settings
      * Only run up to the second Filter 07

7. Check for cryptic species
   * Run PCA & ADMIXTURE to look for cryptic speciation
   * Instructions in [`pire_cssl_data_processing/scripts/popgen_analyses/`](https://github.com/philippinespire/pire_cssl_data_processing/tree/main/scripts/popgen_analyses)

8. Filter the `vcf` file for HWE
   * Update popmap file based on results from Step 9
   * Run Filters 18 & 17 in [`config.fltr.ind.cssl`](https://github.com/cbirdlab/fltrVCF/blob/master/config_files/config.fltr.ind.cssl)

9. Make `vcf` with monomorphic loci

10. Filter monomorphic `vcf`
