#!/bin/bash

#SBATCH -c 2

module unload container_env
module load snakemake/7.21.0 singularity

snakemake -j 40  --use-singularity --slurm
