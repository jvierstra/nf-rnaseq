params.samples_file='/net/seq/data/projects/regulotyping-phaseI/rnaseq/alignment_params.tsv'

Channel
	.fromPath(params.samples_file)
	.splitCsv(header:true, sep:'\t')
	.map{ row -> tuple( row.indiv_id, row.ln_number, row.run, file(row.r1_fastq), file(row.r2_fasta)) }
	.set{ FASTQ_TO_ALIGN }



process align {
    tag "${indiv_id}:LN${ln_number}:run${run}"

    input:
    val(indiv_id), val(ln_number), val(run), file(r1_fastq), file(r2_fastq) from FASTQ_TO_ALIGN

    output:
    val(indiv_id), val(ln_number), val(run), file('*.Aligned.sortedByCoord.out.bam') into ALIGNED_BAMFILES

    script:
    """
    /src/run_STAR.py \
        ${star_index_dir} \
        ${r1_fasta} ${r2_fasta} \
        ${ln_number}_run${run} \
        --threads 4
    """
}

// process merge_mark_duplicates {
    
//     container = "broadinstitute/gtex_rnaseq:V8"

//     inputs:

//     outputs:

//     script:
//     """
//     /src/run_MarkDuplicates.py \
//         /data/star_out/${sample_id}.Aligned.sortedByCoord.out.patched.bam \
//         ${sample_id}.Aligned.sortedByCoord.out.patched.md \
//         --output_dir /data"
//     """
// }


// process merge_by_indiv {

// }

// process run_rnaseqc {

//     inputs
// }