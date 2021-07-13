# CAPTURE SHOTGUN DATA PROCESSING


1. Rename files to follow the `ddocent` naming convention
  * `population_indivdual.R1.fq.gz`

2. Clone denovo_genome_assembly repo to your working dir
  
2. Trim, deduplicate, and decontaminate the raw `fq.gz` files
  * [`denovo_genome_assembly/pre-assembly_processing`](https://github.com/philippinespire/denovo_genome_assembly/tree/main/pre-assembly_processing)

3. Map processed reads against best reference genome
  * Best genome can be found by running [`wrangelData.R`](https://github.com/philippinespire/denovo_genome_assembly/tree/main/compare_assemblers), sorting tibble by busco or n50, and filtering by species 
  * Use [dDocentHPC mkBAM](https://github.com/cbirdlab/dDocentHPC) to map reads to ref
    * Use [`config.5.cssl`](https://github.com/cbirdlab/dDocentHPC/blob/master/configs/config.5.cssl) when running dDocentHPC as a starting point for the settings
