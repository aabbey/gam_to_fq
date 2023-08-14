#!/usr/bin/env nextflow

params.gam = null
params.gfa = null
params.sortFastq = true
params.resultsDir = "results"

// Check if the gam file is provided and has the right extension
if (params.gam == null || !params.gam.endsWith('.gam') || !file(params.gam).exists()) {
    exit 1, "Please provide a valid .gam file with --gam parameter. Given file: ${params.gam}"
}

// Check if the gfa file is provided and has the right extension
if (params.gfa == null || !file(params.gfa).exists()) {
    exit 1, "Please provide a valid .gfa file with --gfa parameter. Given file: ${params.gfa}"
}

if (!params.gfa.endsWith('.gfa') || !params.gfa.endsWith('.gfa.gz')) {
    exit 1, "Please provide a valid .gfa file with --gfa parameter. Given file: ${params.gfa}"
}

ch_gam = Channel.value(file(params.gam))
ch_gfa = Channel.value(file(params.gfa))

include { GAM_TO_BAM } from "$projectDir/gam_to_bam"
include { BAM_TO_FQS } from "$projectDir/bam_to_fqs"

workflow {
    GAM_TO_BAM(ch_gam.map{ gamFile -> [ gamFile.baseName, gamFile ] }, ch_gfa.map{ gfaFile -> [gfaFile.baseName, gfaFile ] })

    BAM_TO_FQS(GAM_TO_BAM.out)
}
