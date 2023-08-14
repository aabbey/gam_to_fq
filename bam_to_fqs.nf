process BAM_TO_FQS {
    tag "${sample_id}"

    container = "pegi3s/bedtools"

    publishDir "${params.resultsDir}/fastq", mode: 'copy'

    input:
    tuple val(sample_id), path(bam_file)

    output:
    tuple val(sample_id), path("${params.resultsDir}/*.fastq.gz")

    script:
    """
    mkdir -p ${params.resultsDir}
    bedtools bamtofastq -i $bam_file -fq ${params.resultsDir}/${sample_id}_1.fastq -fq2 ${params.resultsDir}/${sample_id}_2.fastq

    ${params.sortFastq ? 
    """
    cat ${params.resultsDir}/${sample_id}_1.fastq | paste - - - - | sort -k1,1 -S 3G | tr '\t' '\n' | gzip > ${params.resultsDir}/${sample_id}_1.fastq.gz
    cat ${params.resultsDir}/${sample_id}_2.fastq | paste - - - - | sort -k1,1 -S 3G | tr '\t' '\n' | gzip > ${params.resultsDir}/${sample_id}_2.fastq.gz
    """
    : 
    """
    gzip ${params.resultsDir}/${sample_id}_1.fastq ${params.resultsDir}/${sample_id}_2.fastq
    """
    }
    """
}