#!/bin/bash

#SBATCH --job-name=insertCal
#SBATCH --output=insertCal-%j.out
#SBATCH -c 32
##SBATCH --mail-user=<your email>
##SBATCH --mail-type=begin
##SBATCH --mail-type=END

enable_lmod
module load container_env samtools

#!/bin/bash

total_insert_size=0
total_reads=0

# Function to process a single BAM file
process_bam() {
    file=$1
    echo "Processing file: $file"

    # Exclude unmapped reads and extract insert size using SAMtools and AWK
    insert_sizes=$(crun.samtools view -F 0x4 "$file" | awk '{print $9}')

    # Iterate over insert sizes and update total
    for insert_size in $insert_sizes; do
        total_insert_size=$((total_insert_size + insert_size))
        total_reads=$((total_reads + 1))
    done
}

export -f process_bam

# Check if a regular expression is provided as an argument
if [ -n "$1" ]; then
    regex=$1
else
    regex="*.bam"  # Default regex if no argument is provided
fi

# Iterate over matched files in the directory using parallel
find . -maxdepth 1 -type f -name "$regex" | parallel -kj 32 process_bam {}

# Calculate average insert size
if [ $total_reads -gt 0 ]; then
    average_insert_size=$((total_insert_size / total_reads))
    echo "Average insert size for $regex is: $average_insert_size"
else
    echo "No reads found in the BAM files."
fi

