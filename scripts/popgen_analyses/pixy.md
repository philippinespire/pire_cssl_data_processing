pixy
================

Code for running pixy to calculate pi & Fst in windows. Requires an indexed "all sites" VCF (monomorphic & polymorphic sites) and a popfile as input. Instructions for installing pixy can be found in `/popgen_analyses/README.md`.

```bash
#popfile input for pixy is the same structure as the popmap file created/used for genotyping (just be sure to remove any individuals from this file if they were removed during the filter VCF process & to use the popmap file that accounts for cryptic structure, if there is any).

#pixy can be run on an interactive node, but jobs typically take 1-2 hours, so best to use sbatch file.

#move to working directory
cp pire_cssl_data_processing/scripts/popgen_analyses/pixy.sbatch .

sbatch pixy.sbatch
```

Copy output files to local computer. Read into R for visualization (`popgen_analyses/pi.R` & `popgen_analyses/fst.R`).
