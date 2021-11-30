rule all:
    input:
	sortedbed="alignment.sorted.bed",
	scaffolds="scaffolds"

rule download_data:
	output:
		ref="data/MlScaffold09.nt.gz",
		r1="data/plotkin-mle_S3HiC_R1.fastq.gz",
		r2="data/plotkin-mle_S3HiC_R2.fastq.gz"
    shell:
     	"""
     	wget https://research.nhgri.nih.gov/mnemiopsis/download/genome/MlScaffold09.nt.gz -O {output.ref}
     	wget https://www.dropbox.com/s/tnnhxz3bsccgjbn/plotkin-mle_S3HiC_R1.fastq.gz -O {output.r1}
     	wget https://www.dropbox.com/s/tnnhxz3bsccgjbn/plotkin-mle_S3HiC_R2.fastq.gz -O {output.r2}
     	"""

rule unzip_data:
    input:
    	ref=rules.download_data.output.ref,
    	r1=rules.download_data.output.r1,
    	r2=rules.download_data.output.r2
    output:
    	ref="data/MlScaffold09.nt",
    	r1="data/plotkin-mle_S3HiC_R1.fastq",
    	r2="data/plotkin-mle_S3HiC_R2.fastq"
    shell:
    	"""
    	gzip -d {input.ref} 
    	gzip -d {input.r1}
    	gzip -d {input.r2} 
    	"""

rule build_index:
    input:
        ref=rules.unzip_data.output.ref
    output:
        index="index/mleindex"
    shell:
        """
        bowtie2-build -f {input.ref} {output.index}
        """

rule map_reads:
    input:
        index=rules.build_index.output.index,
        r1=rules.unzip_data.output.r1,
        r2=rules.unzip_data.output.r2
    output:
        sam="alignment.sam"
    shell:
        """
        bowtie2 -x {input.index} \ -p 8 -q -1 {input.r1} \ -2 {input.r2} \ -S {output.sam}
        """

rule samtools:
    input:
        sam=rules.map_reads.output.sam
    output:
        bam="alignment.bam"
    shell:
        """
        samtools view -S -b -h {input.sam} > {output.bam}
        """
        
rule bam_to_bed:
    input:
        bam=rules.samtools.output.bam
    output:
        bed="alignment.bed"
    shell:
        """
        bamToBed -i {input.bam} > {output.bed}
        """

rule contigs_length:
    input:
        ref=rules.unzip_data.output.ref
    output:
        contigs_length="contigs.fasta.fai"
    shell:
        """
        samtools faidx {input.ref} -o {output.contigs_length}
        """

rule sortBed:
    input:
        bed=rules.bam_to_bed.output.bed
    output:
        bed="alignment.sorted.bed"
    shell:
        """
        sort -k 4 {input.bed} > tmp && mv tmp {output.bed}
        """

rule salsa_scaffold:
    input:
        assembly=rules.unzip_data.output.ref,
        contigs_length=rules.contigs_length.output.contigs_length,
        bed=rules.sortBed.output.bed
    output:
        scaffolds=directory("scaffolds")
    conda:
        "envs/SALSAenvironment.yaml"
    shell:
        """
        run_pipeline.py -a {input.assembly} -l {input.contigs_length} -b {input.bed} -e GANTC,TTAA,CTNAG,GATC -o {output.scaffolds} -m yes
        """

