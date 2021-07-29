#### Code used for NeEstimator - species = Aen!

cp /projects/f_mlp195/brendanr/vcf2genepop.pl ./

### convert vcf to genepop
perl vcf2genepop.pl vcf=Aen.A.rad.RAW-6-6.Fltr18.19.HWE.recode.vcf pops=Aen-Cbat,Aen-AHam > aen.genepop

### create file associating loci with "chromosomes"
tail -n +2 aen.genepop | head -1 | tr " " "\n" | awk -F "," {'print $1'} > aen_locfile
tail -n +2 aen.genepop | head -1 | tr " " "\n" | awk -F "_" {'print $3'} > aen_chromfile
paste aen_chromfile aen_locfile > aen_chromlocfile

### NeEstimator wants shorter sample names
cp aen.genepop aen.rename.genepop
sed -i 's/-AeA.*repr//g' aen.rename.genepop
sed -i 's/-AeC.*repr//g' aen.rename.genepop

### run LD estimates per population
(echo "1"; echo "/home/br450/pire_cssl_data_processing/atherinomorus_endrachtensis/NeEst/" ; echo "aen.rename.genepop" ; echo "2" ; echo "/home/br450/pire_cssl_data_processing/atherinomorus_endrachtensis/NeEst/" ; echo "aen_ldout" ; echo "2" ; echo "0.05 0.01"; echo "0") > aen_neest_info
(echo "0 0" ; echo "0" ; echo "0" ; echo "0" ; echo "1" ; echo "1" ; echo "0" ; echo "0" ; echo "0" ; echo "2 aen_chromlocfile") > aen_neest_option
/projects/f_mlp195/brendanr/Ne2-1L i:aen_neest_info o:aen_neest_option

### run temporal estimate
(echo -e "/home/br450/pire_cssl_data_processing/atherinomorus_endrachtensis/NeEst/aen.rename.genepop" ; echo -e "8\n" ; echo -e "2\n" ; echo -e "0\n" ; echo -e "27\n") | /projects/f_mlp195/brendanr/Ne2-1L

