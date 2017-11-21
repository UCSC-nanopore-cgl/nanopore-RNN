#!/usr/bin/env bash

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -f|--fasta)
    FASTA="$2"
    shift # past argument
    shift # past value
    ;;
    -t|--threads)
    THREADS="$2"
    shift # past argument
    shift # past value
    ;;
    -r|--reference)
    REFERENCE="$2"
    shift # past argument
    shift # past value
    ;;
    -o|--output)
    OUTPUT="$2"
    shift # past argument
    shift # past value
    ;;
    --rna)
    RNA=true
    shift # past argument
    ;;

esac
done


echo FASTA FILE  = "${FASTA}"
echo THREADS  = "${THREADS}"
echo REFERENCE = "${REFERENCE}"
echo OUTPUT = "${OUTPUT}"
echo RNA = "${RNA}"


#echo `$FASTA `
if [ "$RNA" = true ] ; then
    echo `minimap2 -ax splice -uf -k14 $REFERENCE $FASTA > $OUTPUT/all_files.sam`
else
    echo `bwa mem -x ont2d -t $THREADS $REFERENCE $FASTA > $OUTPUT/all_files.sam`
fi

echo `samtools view -bS $OUTPUT/all_files.sam > $OUTPUT/all_files.bam`
echo `samtools sort $OUTPUT/all_files.bam -o $OUTPUT/all_files.sorted.bam`
echo `samtools view -F 0x904 -b $OUTPUT/all_files.sorted.bam > $OUTPUT/unique.sorted.bam`
echo `jsa.hts.errorAnalysis --bamFile $OUTPUT/unique.sorted.bam --reference $REFERENCE`