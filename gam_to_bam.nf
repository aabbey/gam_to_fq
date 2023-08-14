process GAM_TO_BAM {
    tag "${sample_id}"

    container = "vg"

    publishDir "${params.resultsDir}/bam", mode: 'copy'

    input:
    tuple val(sample_id), path(gam_file)
    tuple val(sample_id), path(reference_graph)

    output:
    tuple val(sample_id), path("*.bam")

    script:
    """
    vg convert -g ${reference_graph} > reference.vg
    vg surject -b -x reference.vg -i ${gam_file} > ${sample_id}.bam
    """
}
