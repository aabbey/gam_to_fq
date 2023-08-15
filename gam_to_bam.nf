process GAM_TO_BAM {
    tag "${sample_id}"

    container = "quay.io/aabbey_lodestar/vg"

    publishDir "${params.resultsDir}/bam", mode: 'copy'

    input:
    tuple val(sample_id), path(gam_file)
    tuple val(sample_id), path(reference_graph)

    output:
    tuple val(sample_id), path("*.bam")

    script:
    """
    if [[ "${reference_graph}" == *.gz ]]; then
        gunzip -c ${reference_graph} > reference.gfa
    else
        cp ${reference_graph} reference.gfa
    fi

    vg convert -x -g reference.gfa > reference.xg
    vg surject -b -x reference.xg -i ${gam_file} > ${sample_id}.bam
    """
}
