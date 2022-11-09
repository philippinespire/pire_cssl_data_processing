#!/bin/bash

# this script converts the Bait Bed format, which is received with each line as a tile (Currently 2022, we use 2-80bp tiles per bait), into a single line per region.
# in other words, it collapses the 2 tiles into a single bait region.
# for example, this will the 2 tile format

#>NODE_10001_length_16029_cov_33.041557  4962    5042
#>NODE_10001_length_16029_cov_33.041557  5004    5084
#>NODE_1000_length_55924_cov_30.121021   5379    5459
#>NODE_1000_length_55924_cov_30.121021   5420    5500

#this will be converted into
#>NODE_10001_length_16029_cov_33.041557  4962    5084
#>NODE_1000_length_55924_cov_30.121021   5379    5500

TILEBED=$1
BAITBED=$2

cut -f1,2 $TILEBED | awk 'NR%2==1' > FILE1.temp
cut -f3 $TILEBED | awk 'NR%2==0' > FILE2.temp

paste FILE1.temp FILE2.temp > $BAITBED

rm FILE1.temp FILE2.temp
