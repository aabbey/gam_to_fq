params.gam = "$projectDir/x.gam"

ch_gam = Channel.of(params.gam)

include { GAM_TO_BAM } from "$projectDir/gam_to_bam"
include { BAM_TO_FQS } from "$projectDir/bam_to_fqs"

workflow {
    GAM_TO_BAM(ch_gam.map{ ch_gam -> [ [ id:ch_gam.baseName ], ch_gam ] })

    BAM_TO_FQS(GAM_TO_BAM.out)
}