####################  plotBAITcvg.R   ########################
### plots depth of coverage for targeted bait regions  ###.
######### using the output of getBAITcvg.sbatch ##########.
##########################################################.

#### SOURCE ####
# created by Eric Garcia
# plotBAITcvg.R plots depth of coverage for targeted bait regions from the output of getBAITcvg.sbatch
# getBAITcvg.sbatch uses "bedtools coverage -hist" to compute coverage stats for bait regions as determined by a bed file 
# This script was modified from: Stephen Turner 
# https://gettinggeneticsdone.blogspot.com/2014/03/visualize-coverage-exome-targeted-ngs-bedtools.html

#### IMPORT DATA ####

# Get DATA
# Download the *all.txt output files from getBAITcvg.sbatch into your computer
# and place this script in the same directory

# clear global environment
rm(list = ls())

# set working dir as the script's dir
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

# if you have sub-directories
setwd("baitCVGcontam")
setwd("baitCVGdecontam")
getwd()

# Get a list of the bedtools output files you'd like to read in
print(files <- list.files(pattern="G.hist.all.tsv$"))

### Optional but recommended, create short labels for the file names that are very long. 
# print the 1st file to see the naming scheme
files[1] 
# example: [1] "Sgr-AJol_001-Ex1-cssl.clmp.fp2_repr.ssl.SgC0072C_contam_R1R2_noIsolate-RG.baitCVG.hist.all.txt"

# Normally, the Species, Era, Population and Indiviual are represented within the first 12 characters of the file name. 
# If this is the case, you can truncate the names to first 12 characters.
print(labs <- substr(files,1,12))

# Alternately, modified the regex below as necessary to leave only the code for species, era, locality and individual
# Check the example below. (mostly this will match <-Ex1-cssl\\.clmp\\.fp2_repr\\.ssl\\.>) (<then you have match your specific assembly treatments>) (and this should match too <.baitCVG\\.hist\\.all\\.txt">)
#print(labs <- gsub("-Ex1-cssl\\.clmp\\.fp2_repr\\.ssl\\.SgC0072C_contam_R1R2_noIsolate-RG\\.baitCVG\\.hist\\.all\\.txt", "", files, perl=TRUE), sep="")
# example output: [1] "Sgr-AJol_001" "Sgr-AJol_002" "Sgr-AJol_003" "Sgr-AJol_004" "Sgr-AJol_005"
### <º)))<<

# get the populations (either code works)
print(pops <- unique(sub('_.*','', labs)))
print(pops <- unique(sub('_.*','', files)))
# [1] "Sgr-AJol" "Sgr-CJol"


### IMPORTANT
# After this point, follow the instructions:
#  "by ERA" if you have 1 Albatross and 1 Contemporary population
#  "by POP" if you have more than 1 Albatross and 1 Contemporary populations

#### DIVIVE DATA by ERA ####

# print the labs/files in the console and check which files correspond to which ERA and split them accordingly
labs
files   #if you didn't create labs
# Hint, check that you have the correct number. 
# In this case the last Albatross individual is file #215
# I can see that "labs[215]" gives me the last Albatross sample
labs[215] # last albatross

# split files per ERA
afiles <- files[1:215]
cfiles <- files[216:401]


#### DIVIVE DATA by POP ####

# get the populations (either code works)
print(pops <- unique(sub('_.*','', labs)))
print(pops <- unique(sub('_.*','', files)))
# [1] "Sgr-AJol" "Sgr-AMvi" "Sgr-APal" "Sgr-CJol" "Sgr-CMas" "Sgr-CMvi"
# Thus, in this case, I have 6 pops. Most species will only have 2 though.

# use the labs/files check which files correspond to which population and split them accordingly
labs
files   #if you didn't create labs
# Hint, check that you have the correct number. 
# In this case the the first Albatross pop (Sgr-AJol) end with file #92
# I can see that "labs[92]" gives me the last Sgr-AJol file
labs[92]  # last Sgr-AJol
labs[178] # last Sgr-AMvi
labs[215] # last Sgr-APal
labs[276] # last Sgr-CJol
labs[340] # last Sgr-CMas
labs[401] # last Sgr-CMvi

# split files per population 
a1files <- files[1:92]
a2files <- files[93:178]
a3files <- files[179:215]
c1files <- files[216:276]
c2files <- files[277:340]
c3files <- files[341:401]




#### READ IN DATA by ERA ####

# For for each ERA:
# Create lists to hold coverage and cumulative coverage for each alignment,
# and read the data into these lists.

#Albatross
acov <- list()
acov_cumul <- list()
for (i in 1:length(afiles)) {
  acov[[i]] <- read.table(afiles[i])
  acov_cumul[[i]] <- 1-cumsum(acov[[i]][,5])
}

#Contemporary
ccov <- list()
ccov_cumul <- list()
for (i in 1:length(cfiles)) {
  ccov[[i]] <- read.table(cfiles[i])
  ccov_cumul[[i]] <- 1-cumsum(ccov[[i]][,5])
}





#### READ IN DATA by POP ####

# For each population:
# Create lists to hold coverage and cumulative coverage for each alignment,
# and read the data into these lists.

#pop1
a1cov <- list()
a1cov_cumul <- list()
for (i in 1:length(a1files)) {
  a1cov[[i]] <- read.table(a1files[i])
  a1cov_cumul[[i]] <- 1-cumsum(a1cov[[i]][,5])
}

#pop2
a2cov <- list()
a2cov_cumul <- list()
for (i in 1:length(a2files)) {
  a2cov[[i]] <- read.table(a2files[i])
  a2cov_cumul[[i]] <- 1-cumsum(a2cov[[i]][,5])
}

#pop3
a3cov <- list()
a3cov_cumul <- list()
for (i in 1:length(a3files)) {
  a3cov[[i]] <- read.table(a3files[i])
  a3cov_cumul[[i]] <- 1-cumsum(a3cov[[i]][,5])
}

#pop4
c1cov <- list()
c1cov_cumul <- list()
for (i in 1:length(c1files)) {
  c1cov[[i]] <- read.table(c1files[i])
  c1cov_cumul[[i]] <- 1-cumsum(c1cov[[i]][,5])
}

#pop5
c2cov <- list()
c2cov_cumul <- list()
for (i in 1:length(c2files)) {
  c2cov[[i]] <- read.table(c2files[i])
  c2cov_cumul[[i]] <- 1-cumsum(c2cov[[i]][,5])
}

#pop6
c3cov <- list()
c3cov_cumul <- list()
for (i in 1:length(c3files)) {
  c3cov[[i]] <- read.table(c3files[i])
  c3cov_cumul[[i]] <- 1-cumsum(c3cov[[i]][,5])
}





#### Left over color code (prob. you won't need this) ####
### This is left over color code from Stephen, I don't use because we have too many samples.
# Pick some colors
# Ugly:
# cols <- 1:length(cov)
# Prettier:
#?colorRampPalette
#display.brewer.all()
#library(RColorBrewer)
#cols <- brewer.pal(length(cov), "Dark2")
#### Instead, I hand picked colors in the plot and legend commands





#### Plot coverage per ERA ####

# Save the graph to a file (this works in combination with 'dev.off()' at the end)
# Don't run this code if you want to see the plot within Rstudio
png("Sgr-baitCVG-ERAplot_contamREF.png", h=1000, w=1000, pointsize=20)

# Create plot area, but do not plot anything. Add gridlines and axis labels.
# If you plot the whole range of depth, you might not see the Albatross depth very well if the contemporary samples have much higher depth.
# Thus, I use xlim=c(0,100) to limit to 100x cvg.
plot(ccov[[1]][ , 2], ccov_cumul[[1]], type='n', xlab="Depth", ylab="Fraction of capture target bases \u2265 depth", ylim=c(0,1.0), xlim=c(0,100), main="Sgr CSSL Bait Region Coverage - contam REF")
abline(v = 20, col = "gray60")
abline(v = 40, col = "gray60")
abline(v = 60, col = "gray60")
abline(v = 80, col = "gray60")
abline(h = 0.20, col = "gray60")
abline(h = 0.40, col = "gray60")
abline(h = 0.60, col = "gray60")
abline(h = 0.80, col = "gray60")
#axis(1, at=c(10,20,30,40), labels=c(10,20,30,40))
#axis(2, at=c(0.25), labels=c(0.25))
#axis(2, at=c(0.50), labels=c(0.50))
#axis(2, at=c(0.75), labels=c(0.75))

# Actually plot the data for each of the files per population (stored in the lists).
for (i in 1:length(acov)) points(acov[[i]][ , 2], acov_cumul[[i]], type='l', lwd=0.5, col="gold1")
for (i in 1:length(ccov)) points(ccov[[i]][ , 2], ccov_cumul[[i]], type='l', lwd=0.5, col="blue")
# if you want to subset number of records
#for (i in 1:length(cov)) points(cov[[i]][1:201, 2], cov_cumul[[i]][1:200], type='l', lwd=0.5) #, col=cols[i])

# Add a legend using the pop labels
#legend("topright", legend=pops, fill = c("gold1", "blue"),  bg =  "white")
# if pops doesn't work or if you have multiple pops but just doing an Albatross and Contemporary plot for now
legend("topright", legend=c("Albatross", "Contemporary"), fill = c("gold1", "blue"),  bg =  "white")

# save plot in working dir
dev.off()

#### Plot coverage per POP ####

# Save the graph to a file (this works in combination with 'dev.off()' at the end)
# Don't run this code if you want to see the plot within Rstudio
png("Sgr-baitCVG-POPplot_contamREF.png", h=1000, w=1000, pointsize=20)


# Create plot area, but do not plot anything. Add gridlines and axis labels.
# If you plot the whole range of depth, you might not see the Albatross depth very well if the contemporary samples have much higher depth.
# Thus, I use xlim=c(0,100) to limit to 100x cvg.
plot(ccov[[1]][,2], ccov_cumul[[1]], type='n', xlab="Depth", ylab="Fraction of capture target bases \u2265 depth", ylim=c(0,1.0), xlim=c(0,100), main="Sgr CSSL Bait Region Coverage - contam REF")
abline(v = 20, col = "gray60")
abline(v = 40, col = "gray60")
abline(v = 60, col = "gray60")
abline(v = 80, col = "gray60")
abline(h = 0.20, col = "gray60")
abline(h = 0.40, col = "gray60")
abline(h = 0.60, col = "gray60")
abline(h = 0.80, col = "gray60")
#axis(1, at=c(10,20,30,40), labels=c(10,20,30,40))
#axis(2, at=c(0.25), labels=c(0.25))
#axis(2, at=c(0.50), labels=c(0.50))
#axis(2, at=c(0.75), labels=c(0.75))

# Actually plot the data for each of the files per population (stored in the lists).
for (i in 1:length(a1cov)) points(a1cov[[i]][, 2], a1cov_cumul[[i]], type='l', lwd=0.5, col="gold1")
for (i in 1:length(a2cov)) points(a2cov[[i]][, 2], a2cov_cumul[[i]], type='l', lwd=0.5, col="red4")
for (i in 1:length(a3cov)) points(a3cov[[i]][, 2], a3cov_cumul[[i]], type='l', lwd=0.5, col="darkolivegreen")
for (i in 1:length(c1cov)) points(c1cov[[i]][, 2], c1cov_cumul[[i]], type='l', lwd=0.5, col="blue")
for (i in 1:length(c2cov)) points(c2cov[[i]][, 2], c2cov_cumul[[i]], type='l', lwd=0.5, col="magenta")
for (i in 1:length(c3cov)) points(c3cov[[i]][, 2], c3cov_cumul[[i]], type='l', lwd=0.5, col="black")
# if you want to subset the number of records
#for (i in 1:length(cov)) points(cov[[i]][1:200, 2], cov_cumul[[i]][1:200], type='l', lwd=0.5) #, col=cols[i])

# Add a legend using the nice sample labels rather than the full filenames.
legend("topright", legend=pops, fill = c("gold1", "red4", "darkolivegreen", "blue", "magenta", "black"),  bg =  "white") # lty=1, lwd=4)

# send file to working directory
dev.off()

