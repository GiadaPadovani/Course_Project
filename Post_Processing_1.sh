#!/bin/bash

#SBATCH --time=72:00:00
#SBATCH --mem=16gb

echo "sample" >temp0
echo "giraffe" > temp1
echo "T.truncatus" > temp2
echo "P.catodon" > temp3
echo "M.nova" >temp4
echo "B.musculus" >temp5
echo "B.physalus" > temp6

module load samtools

ls T.truncatus/BAM_Files/*.g.final.bam | cut -f3 -d'/' | cut -f1 -d'.' >>temp0

ls G.camelopardalis/BAM_Files/*.g.final.bam > bam_list_temp
cat bam_list_temp | while read bam
do
samtools view -c $bam >>temp1
done

ls T.truncatus/BAM_Files/*.g.final.bam > bam_list_temp
cat bam_list_temp | while read bam
do
samtools view -c $bam >>temp2
done

ls P.catodon/BAM_Files/*.g.final.bam > bam_list_temp
cat bam_list_temp | while read bam
do
samtools view -c $bam >>temp3
done

ls M.novaeangliae/BAM_Files/*.g.final.bam > bam_list_temp
cat bam_list_temp | while read bam
do
samtools view -c $bam >>temp4
done

ls B.musculus/BAM_Files/*.g.final.bam > bam_list_temp
cat bam_list_temp | while read bam
do
samtools view -c $bam >>temp5
done

ls B.physalus/BAM_Files/*.g.final.bam > bam_list_temp
cat bam_list_temp | while read bam
do
samtools view -c $bam >>temp6
done

paste temp0 temp1 temp2 temp3 temp4 temp5 temp6 > tab_recap_bamreads.txt
rm temp*


