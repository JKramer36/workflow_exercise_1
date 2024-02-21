#!/usr/bin/env nextflow

nextflow.enable.dsl=2


//Input Filepaths for raw data, trimmed reads, and final assemblies

params.raw = "/root/7210/workflow_exercise/raw_data"
params.trimmed = "/root/7210/workflow_exercise/trimmed_reads"
params.assembled = "/root/7210/workflow_exercise/SKESA_Assembled"


//Load fastq.gz files from raw data directory into a channel

def fastq_files = Channel.fromFilePairs("${params.raw}/*_R{1,2}.fastq.gz")


//Define Read Trimming Process

process trim_reads {
	
	//Specify Output Directory for Trimmed Reads
	publishDir "${params.trimmed}"
    
    input:
    tuple val(sample), path(reads)

    //Specify Output Filename
    output:
    tuple val(sample), path("${sample}_trimmed_R1.fastq.gz"), path("${sample}_trimmed_R2.fastq.gz")

    /*Run Trimmomatic for Single End Illumina Sequencing Data
    Trims Adapter Sequences
    Trims Reads using a Sliding Window Approach
    */

    script:
    """
 	trimmomatic PE -phred33 ${reads[0]} ${reads[1]} \
    ${sample}_trimmed_R1.fastq.gz ${sample}_unpaired_R1.fastq.gz \
    ${sample}_trimmed_R2.fastq.gz ${sample}_unpaired_R2.fastq.gz \
    ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:4:15 MINLEN:36
    """
}

//Define Assembly Process

process assemble_reads {
	
	//Specify Output Directory for Final Assemblies
	publishDir "${params.assembled}"
	
	input:
	tuple val(sample), path(reads)

	//Specify Output Filename
	output:
	path "${sample}_assembled.fasta"
	
	//Run Skesa to Assemble Trimmed Reads
	script:
	"""
	 skesa --reads ${reads[0]},${reads[1]} > ${sample}_assembled.fasta
    """
}

/*  
Define the workflow
Trim raw fastq data using trimmomatic
Assemble trimmed reads using SKESA
*/

workflow {
	trimmed_reads = trim_reads(fastq_files)
	assemble_reads(trimmed_reads)
}
