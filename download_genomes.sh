#!/bin/bash
#SBATCH --job-name=ncbi_down
#SBATCH --output=logs/dl_%A_%a.out
#SBATCH --error=logs/dl_%A_%a.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=02:00:00
#SBATCH --array=1-8

mkdir -p genomes

ACC=$(sed -n "${SLURM_ARRAY_TASK_ID}p" accessions.txt)
ZIP_FILE="genomes/${ACC}.zip"

rm -f ${ZIP_FILE}

for i in {1..3}; do
    datasets download genome accession ${ACC} --filename ${ZIP_FILE} && break
    echo "Download failed for ${ACC}, retrying ($i/3)..."
    sleep 5
done

if [ -s "${ZIP_FILE}" ]; then
    unzip ${ZIP_FILE} -d ./genomes/${ACC}
    echo "Successfully downloaded and extracted: ${ACC}"
else
    echo "ERROR: Download failed completely for ${ACC}"
    exit 1
fi

