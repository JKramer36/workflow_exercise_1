#!/usr/bin/env nextflow

nextflow.enable.dsl=2


//Input Filepaths for raw data, trimmed reads, and final assemblies

params.raw = "/root/7210/workflow_exercise/raw_data"
params.trimmed = "/root/7210/workflow_exercise/trimmed_reads"
params.assembled = "/root/7210/workflow_exercise/SKESA_Assembled"


//Load fastq.gz files from raw data directory into a channel

def fastq_files = Channel.fromPath("${params.raw}/*.fastq.gz")



//Define Read Trimming Process

process trim_reads {
	
	//Specify Output Directory for Trimmed Reads
	publishDir "${params.trimmed}"
    
    input:
    path read_file

    //Specify Output Filename
    output:
    path "${read_file.baseName.replaceAll(/\.fastq$/, '')}_trimmed"

    /*Run Trimmomatic for Single End Illumina Sequencing Data
    Trims Adapter Sequences
    Trims Reads using a Sliding Window Approach
    */

    script:
    """
    trimmomatic SE -phred33 ${read_file} ${read_file.baseName.replaceAll(/\.fastq$/, '')}_trimmed \
    ILLUMINACLIP:TruSeq3-SE.fa:2:30:10 SLIDINGWINDOW:4:15 MINLEN:36
    """
}

//Define Assembly Process

process assemble_reads {
	
	//Specify Output Directory for Final Assemblies
	publishDir "${params.assembled}"
	
	input:
	path trimmed_reads

	//Specify Output Filename
	output:
	path "${trimmed_reads.baseName.replaceAll(/_trimmed$/, '')}_assembled.fasta"

	//Run Skesa to Assemble Trimmed Reads
	script:
	"""
	skesa --reads ${trimmed_reads} > ${trimmed_reads.baseName.replaceAll(/_trimmed$/, '')}_assembled.fasta
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
