#cdb trying to filter Aen



## Step 9. Filter VCF Files

Clone fltrVCF and rad_haplotyper repos

```
cd /home/cbird/pire_cssl_data_processing/scripts
git clone git@github.com:cbirdlab/fltrVCF.git
git clone git@github.com:cbirdlab/rad_haplotyper.git

cd /home/cbird/pire_cssl_data_processing/atherinomorus_endrachtensis/
mkdir filterVCF_ceb

cp ../scripts/fltrVCF/config_files/config.fltr.ind.cssl filterVCF
```



```
cd /home/cbird/pire_cssl_data_processing/atherinomorus_endrachtensis/fitlerVCF
# this has to be run from dir with fq.gz files to be mapped and the ref genome
# this script is preconfigured to run mapping, filtering of the maps, and genotyping in 1 shot
sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl

# troubleshooting will be necessary).
```
