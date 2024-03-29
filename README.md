# workflow_exercise_1

## Nextflow Workflow for Read Trimming and Genome Assembly

### Workflow Overview:
The workflow automates the processing of .fastq.gz files located in a specified directory. It first performs read trimming to remove adapters and improve the quality of reads. Then, it assembles the trimmed reads into a genome sequence.

#### Input Parameters:
params.raw: Path to the directory containing raw sequencing data files in .fastq.gz format.

params.trimmed: Destination directory for storing the trimmed read files.

params.assembled: Destination directory for storing the assembled genome sequences.

### Processes:
1. trim_reads:
This process uses Trimmomatic for trimming single-end Illumina sequencing data

Inputs:
Read File (read_file): The FASTQ file to be trimmed.

Outputs:
Trimmed File: A file named with the original base name of the input file, appended with _trimmed. For example, sample.fastq.gz becomes sample_trimmed

2. assemble_reads:
This process assembles the trimmed reads using SKESA.

Inputs:
Trimmed Reads (trimmed_reads): The output from the trim_reads process.

Outputs:
Assembled Genome Sequence: A FASTA file named with the base name of the input file, appended with _assembled.fasta. For example, sample_trimmed becomes sample_assembled.fasta

## Usage
To execute this workflow, ensure Nextflow is installed and available in your environment. Place your raw .fastq.gz files in the directory specified by params.raw. Then run the workflow with the command:

Ensure that TruSeq3-SE.fa (adapter file for Trimmomatic) and SKESA are properly installed and accessible in your environment.

### Customization
You can modify the input parameters (params.raw, params.trimmed, params.assembled) to suit your directory structure. Additionally, Trimmomatic and SKESA parameters can be adjusted based on your specific data quality and requirements.
