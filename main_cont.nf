include {INTERSECT} from './modules/bedtools_intersect'
include {REMOVE} from "./modules/bedtools_remove"
include {ANNOTATE} from "./modules/homer_annotatepeaks"
include {COMPUTEMATRIX} from './modules/deeptools_computematrix'
include {PLOTPROFILE} from './modules/deeptools_plotprofile'
include {FIND_MOTIFS_GENOME} from './modules/homer_findmotifsgenome'


workflow {
    Channel.fromPath(["refs/rep1_peaks.narrowPeak", "refs/rep2_peaks.narrowPeak"]).collect()
    | map {files -> tuple('repr_peaks', files[0], files[1])}
    | set {intersect_ch}
    
    INTERSECT(intersect_ch)
    REMOVE(INTERSECT.out.intersect, params.blacklist)

    ANNOTATE(
        REMOVE.out.filtered,
        params.genome,
        params.gtf
    )

    Channel.fromPath("${params.outdir}/IP_rep*.bw")
    .collect()
    .map { files -> 
        tuple('input_group', files)
    }
    | set {ip_ch}

    COMPUTEMATRIX(ip_ch, file(params.genebody_bed), params.window)

    PLOTPROFILE(COMPUTEMATRIX.out.matrix)

    FIND_MOTIFS_GENOME(REMOVE.out.filtered, 
    "refs/GRCh38.primary_assembly.genome.fa")
}