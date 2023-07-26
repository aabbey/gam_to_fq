process BAM_TO_FQS {
    tag "${sample_id}"

    input:
    tuple val(sample_id), path(bam_file)

    output:
    tuple val(sample_id), path("*.fastq.gz")

    script:
    """
    bedtools bamtofastq -i $bam_file -fq ${sample_id}_1.fastq -fq2 ${sample_id}_2.fastq
    gzip ${sample_id}_1.fastq ${sample_id}_2.fastq
    """
}