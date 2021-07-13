# CAPTURE SHOTGUN DATA PROCESSING


1. Rename files to follow the `ddocent` naming convention
  * `population_indivdual.R1.fq.gz`

2. Clone denovo_genome_assembly repo to your working dir

3. Run [`fastqc`]()
 * visualize results with ['multiqc']()
  
4. Trim, deduplicate, and decontaminate the raw `fq.gz` files
  * [`denovo_genome_assembly/pre-assembly_processing`](https://github.com/philippinespire/denovo_genome_assembly/tree/main/pre-assembly_processing)
  * review the outputs from fastp with multiqc

5. Map processed reads against best reference genome
  * Best genome can be found by running [`wrangelData.R`](https://github.com/philippinespire/denovo_genome_assembly/tree/main/compare_assemblers), sorting tibble by busco or n50, and filtering by species 
  * Use [dDocentHPC mkBAM](https://github.com/cbirdlab/dDocentHPC) to map reads to ref
    * Use [`config.5.cssl`](https://github.com/cbirdlab/dDocentHPC/blob/master/configs/config.5.cssl) when running dDocentHPC as a starting point for the settings

6. Filter the `bam` files
 * Use [dDocentHPC fltrBAM](https://github.com/cbirdlab/dDocentHPC)
 * visualize results with IGV or equivalent on a local computer to look for mapping artifacts
   * look at both contemp and albatross (that goes for anything that follows)
 * compare the filtered (`RG.bam`) to unfiltered (`RAW.bam`) files
   * were a lot of reads lost?

7. Genotype the `bam` files
 * Use [`dDocentHPC mkVCF`](https://github.com/cbirdlab/dDocentHPC) 

8. Filter the `vcf` files
 * Use [`fltrVCF`](https://github.com/cbirdlab/fltrVCF)
   * Use [`config.fltr.ind.cssl`](https://github.com/cbirdlab/fltrVCF/blob/master/config_files/config.fltr.ind.cssl) as a starting point for filter settings

