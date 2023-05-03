## Roadmap for running Stairway Plot v2 on cssl data

Given an SFS derived from a VCF file, StairwayPlot can estimate the historical demography of a population.

Steps for running Stairway Plot (with Gmi as an example):

### Clone the vcf2sfs and StairwayPlot repos

```
git clone https://github.com/shenglin-liu/vcf2sfs

git clone https://github.com/xiaoming-liu/stairway-plot-v2
```

### Get the vcf and popmap files

```
mkdir /home/breid/Gmi_stairway

cd /home/breid/Gmi_stairway

cp /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF_merge/Gmi.A.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr18.1.HWE.recode.vcf /home/breid/Gmi_stairway/

cp /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF_merge/popmap.rad.RAW-10-10.HWEsplit /home/breid/Gmi_stairway
```

You will need to edit the popmap file to reflect the samples retained by filterVCF.

### Compute the SFS

Obtain a node and load modules.

```
salloc

module load container_env/0.1

module load R/4.2.1

module load java
```

Open R in the terminal and run vcf2sfs.

```
source("/home/breid/vcf2sfs/vcf2sfs.r")

mygt<-vcf2gt("/home/breid/Gmi_stairway/Gmi.A.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr18.1.HWE.recode.vcf", "/home/breid/Gmi_stairway/Gmi_popmap_passedfilter")

mysfs_GmiABasA<-gt2sfs.raw(mygt, "Gmi-ABas-A")
mysfs_GmiABasA_fold<- fold.sfs(mysfs_GmiABasA)
write.1D.fsc(mysfs_GmiABasA_fold,"/home/breid/Gmi_stairway/Gmi-ABas-A.sfs")

mysfs_GmiAHamA<-gt2sfs.raw(mygt, "Gmi-AHam-A")
mysfs_GmiAHamA_fold<- fold.sfs(mysfs_GmiAHamA)
write.1D.fsc(mysfs_GmiAHamA_fold,"/home/breid/Gmi_stairway/Gmi-AHam-A.sfs")

mysfs_GmiAHamB<-gt2sfs.raw(mygt, "Gmi-AHam-B")
mysfs_GmiAHamB_fold<- fold.sfs(mysfs_GmiAHamB)
write.1D.fsc(mysfs_GmiAHamB_fold,"/home/breid/Gmi_stairway/Gmi-AHam-B.sfs")

mysfs_GmiCBasA<-gt2sfs.raw(mygt, "Gmi-CBas-A")
mysfs_GmiCBasA_fold<- fold.sfs(mysfs_GmiCBasA)
write.1D.fsc(mysfs_GmiCBasA_fold,"/home/breid/Gmi_stairway/Gmi-CBas-A.sfs")

mysfs_GmiCBatA<-gt2sfs.raw(mygt, "Gmi-CBat-A")
mysfs_GmiCBatA_fold<- fold.sfs(mysfs_GmiCBatA)
write.1D.fsc(mysfs_GmiCBatA_fold,"/home/breid/Gmi_stairway/Gmi-CBat-A.sfs")

mysfs_GmiCBatB<-gt2sfs.raw(mygt, "Gmi-CBat-B")
mysfs_GmiCBatB_fold<- fold.sfs(mysfs_GmiCBatB)
write.1D.fsc(mysfs_GmiCBatB_fold,"/home/breid/Gmi_stairway/Gmi-CBat-B.sfs")
```

Can calculate SFS for each era/population separately.

Note that I have just used the VCF with polymorphic sites. You will need to know the total # of sites genotyped to run stairway plot. You can calculate this based on the monomorphic VCF.

### Copy and edit the blueprint file and the folder containing program files.

```
cp -r /home/breid/stairway-plot-v2/stairway_plot_v2.1.1/stairway_plot_es /home/breid/Gmi_stairway/

cp /home/breid/stairway-plot-v2/stairway_plot_v2.1.1/two-epoch_fold.blueprint /home/breid/Gmi_stairway/GmiCBatA.blueprint
```

### Edit the blueprint file

Fields to edit:

```
popid: Gmi-CBat-A

nseq: 128
# double the number of diploid individuals

L: 143041
# total length

whether_folded: true

SFS: 2177	1821	1371	1040	716	520	442	381	309	251	240	220	202	177	181	121	131	108	109	93	91	96	83	64	56	63	54	62	59	57	46	39	37	40	28	32	27	45	29	28	24	31	20	19	31	25	40	24	26	24	32	27	31	23	33	27	33	36	25	27	29	32	37	10
# copy and pasted from vcf2sfs output - first bin is singletons

#smallest_size_of_SFS_bin_used_for_estimation: 1

#largest_size_of_SFS_bin_used_for_estimation: 64

project_dir: Gmi-CBat-A_stairway

stairway_plot_dir: stairway_plot_es # directory to the stairway plot files

years_per_generation: 1.4

project_dir: Gmi-CBat-A

plot_title: Gmi-CBat-A # title of the plot
```

### Generate the .sh file to run using java

```
crun java -cp stairway_plot_es Stairbuilder GmiCBatA.blueprint
```

### Run Stairway Plot

Can just run in your node:
```
crun bash GmiCBatA.blueprint.sh
```

Or here is an sbatch script to run:

```
#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name=Lle-CNas_stairway
#SBATCH --output=Lle-CNas_stairway-%j.out

module load container_env/0.1

module load java

crun bash GmiCBatA.blueprint.sh
```
