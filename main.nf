include {TRIM} from './modules/trimmomatic'
include {FASTQC} from './modules/fastqc'
include {BOWTIE2_BUILD} from './modules/bowtie2_build'
include {BOWTIE2_ALIGN} from './modules/bowtie2_align'
include {SAMTOOLS_FLAGSTAT} from './modules/samtools_flagstat'
include {MULTIQC} from './modules/multiqc'
include {SAMTOOLS_SORT} from './modules/samtools_sort'
include {SAMTOOLS_IDX} from './modules/samtools_idx'
include {BAMCOVERAGE} from './modules/deeptools_bamcoverage'
include {MULTIBWSUMMARY} from './modules/deeptools_multibwsummary'
include {PLOTCORRELATION} from './modules/deeptools_plotcorrelation'
include {CALLPEAKS} from './modules/macs3_callpeak'


workflow {
    Channel.fromPath(params.samplesheet)
    | splitCsv( header: true )
    | map{ row -> tuple(row.name, row.path) }
    | set { read_ch }

    FASTQC(read_ch)
    BOWTIE2_BUILD(params.genome)
    TRIM(read_ch, params.adapter_fa)

    BOWTIE2_ALIGN(TRIM.out.trimmed, BOWTIE2_BUILD.out.index, BOWTIE2_BUILD.out.name)
    SAMTOOLS_FLAGSTAT(BOWTIE2_ALIGN.out.bam)

    TRIM.out.log.concat(FASTQC.out.zip, SAMTOOLS_FLAGSTAT.out.flagstat).collect()
    | set { multiqc_ch }
    
    MULTIQC(multiqc_ch)

    SAMTOOLS_SORT(BOWTIE2_ALIGN.out)
    SAMTOOLS_IDX(SAMTOOLS_SORT.out)

    BAMCOVERAGE(SAMTOOLS_IDX.out.index)

    BAMCOVERAGE.out.bigwig.collect{ it[1] }
    | set { bws_ch }

    MULTIBWSUMMARY(bws_ch)
    PLOTCORRELATION(MULTIBWSUMMARY.out.multibwsummary, params.cortype)

    BOWTIE2_ALIGN.out
        | map { name, path -> tuple(name.split('_')[1], [(path.baseName.split('_')[0]): path]) }
        | groupTuple(by: 0)
        | map { rep, maps -> tuple(rep, maps[0] + maps[1]) }
        | map { rep, samples -> tuple(rep, samples.IP, samples.INPUT) }
        | set { peakcalling_ch }

    // CALLPEAKS(peakcalling_ch, params.macs3_genome)
}