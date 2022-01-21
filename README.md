
# HiC-project: A chromosome scale assembly using SALSA2 with additional QC steps.

## Notes on Pipeline

The following pipeline aims to improve an existing reference assembly by utilising HiC data and the SALSA2 open-source tool[1](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1007273) to re-order and re-orient the assembly and ultimately reduce the number of scaffold. When used with long read data, this pipeline should create a chromosome scale (or close to) assembly. 

This project uses experimental short-read HiC data, however the long read data from PacBio has not currently been delivered (samples have been collected and are in the process of being sequenced utilising PacBio HiFi read technology on the PacBio Sequell II). Therefore this pipeline is a proof of concept, that aims to reduce the number of scaffolds in the existing assembly, but due to its short read nature will not get a chromosome scale resolution. 

Furthermore, as the primary output is a fasta file of the final scaffold assembly, this is too large for github. These test results have been added to Dropbox and the links can be shared at request. Please create an Issue to get access. [This link](https://www.dropbox.com/sh/0ztfcfupay5xpmq/AADGSyrRX1NuY38YnFuRCt86a?dl=0) should take you to the dropbox folder.

## 1. Background and rationale

**Importance of chromosome scale assembly.**

Advances in technology have drastically reduced the cost of sequencing per base, resulting in an increase in massively parallel sequencing methods to answer biological questions. De novo assembly of these sequences still remains problematic however, and the quality of short read assemblies can often restrict analysis as the nature of short reads is often limiting (for example when compared to long repeat lengths of some gene regions)[2](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-14-S5-S18),[3](https://pubmed.ncbi.nlm.nih.gov/19580519/). Long read sequencing can offer reads in excess of 10kb however most technologies offer a relatively high error rate[4](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-020-1935-5),[5](https://pubmed.ncbi.nlm.nih.gov/29767702/). In Hi-C sequencing cells are cross-linked with formaldehyde, digested with a restriction enzyme where a biotinylated residue is added and then ligated prior to sequencing. The resulting reads provide contact information which allow for the study of the 3D organisation of the genome, however recently this data has also been applied to assemble eukaryotic genomes into chromosome-scale scaffolds[1](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1007273). Chromosome-scale assembly can aid evolution studies[6](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-018-1559-1), and may help resolve the relative phylogenetic position of ctenophores or sponges as the sister group to other metazoans.

**Model organism: Mnemiopsis leidyi**

*Mnemiopsis leidyi* is well placed phylogenetically as the sister group to all other metazoan and further understanding of its genome can elucidate information around genome evolution, cell differentiation and conserved gene regulatory networks that are required for multicellularity[7](https://pubmed.ncbi.nlm.nih.gov/24337300/).  Existing draft genomes exist for both *M. leidyi* and *Pleurobrachia bachei*, which have been instrumental in highlighting key developmental gene features that did not evolve until the common ancestor of bilateria, however both genomes are still not chromosome-scale.

**Aim**: To improve reference genome for *Mnemiopsis leidyi* by reducing number of scaffolds and move towards a chromosome-scale assembly.

**SALSA2 scaffolding**

The pipeline below utilises the SALSA2 tool, to reduce the number of scaffolds for the current reference genome of the model organism *Mnemiopsis leidyi*. SALSA2 requires an initial assembly of contig/scaffold sequences and optionally a GFA-assembly graph (not used in this pipeline). HiC reads are aligned to the assembly, and edges are scored according to the ‘best buddy’ scheme, generating a scaffold graph from which scaffolds are iteratively generated[1](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1007273). For more information please see the paper [Integrating Hi-C links with assembly graphs for chromosome-scale assembly]( https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1007273).

![SALSA2_scaffolding]( https://github.com/cbarcl01/BIOF501-project/blob/main/Fig_1.png)


## 2. Getting Started

### 2.1 Dependencies & Environment setup

You will require Miniconda and git to run this pipeline. This pipeline has been prepared for a linux terminal in BASH. 

Please note that SALSA2 is a tool in development and if installing manually you will need to use the specified versions for Python, BOOST libraries and Networkx. For more information on the tool itself, as well as additional functionality, please see the github repository for [SALSA2](https://github.com/marbl/SALSA).

Please be aware that conflicts in the python versions needed for each tool (version 2.7 for SALSA2 and >=3.1 for snakemake) has required different environments. In Snakemake 3.9.0 you can define isolated software environments per rule, so please ensure you are using the most recent version. See [Integrated Package Management](https://snakemake.readthedocs.io/en/stable/snakefiles/deployment.html#integrated-package-management) of the snakemake documentation for more information.The snakemake environment will be created from the `environment.yaml` file in the `envs` folder, while the pipeline itself will create another environment, within snakemake, to run SALSA2 - this environment has been called `SALSAenvironment`. Please ensure the environments are both stored in the envs folder so that the pipeline works correctly.

**Clone repository**

Please use the following shell command to clone the repository:

```
git clone https://github.com/cbarcl01/BIOF501-project.git
```

**Create Conda Environment**

To run the pipeline, first create a conda environment with the relevant dependencies by using the `environment.yaml` file in the `envs` subdirectory of this repository. The first line of the .yaml file sets the environment's name, you can amend this as needed. Please also amend the amend the prefix at the end of the document with the appropriate `\home\user` pathway to a relevant directory to store/load the conda environment.

```
conda env create -f  envs/environment.yaml
```


**Create Conda Environment**

To get started, activate the initial environment with the following code. The salsa environment does not need to be activated as this is referred to within the pipeline, however as with the environment.yaml file, you will need to amend the prefix at the end of the document with the appropriate `\home\user` pathway to a relevant directory.

```
conda activate biof501
```

### 2.2 Data

**Download data**

An existing assembly and HiC data are required to run this pipeline. The data will be downloaded and unzipped as part of the pipeline, however the links are also included below. The HiC data used to test this pipeline was collected in the  Plotkin lab, as part of a masters research project and therefore has not been added to any accession/database yet.


|**Filename**    |**Description of file** |**Link to data** | 
|:----------- | :----------- | :----------- |
| MlScaffold09.nt  | Draft reference assembly file  | [download](https://research.nhgri.nih.gov/mnemiopsis/download/genome/MlScaffold09.nt.gz) | 
| plotkin-mle_S3HiC_R1.fastq.gz   | Forward read for HiC | [download](https://www.dropbox.com/s/tnnhxz3bsccgjbn/plotkin-mle_S3HiC_R1.fastq.gz) | 
| plotkin-mle_S3HiC_R2.fastq.gz   | Reverse read for HiC | [download](https://www.dropbox.com/s/tnnhxz3bsccgjbn/plotkin-mle_S3HiC_R2.fastq.gz) | 


## 3. Usage

In order to run the scaffolding pipeline, we first need to align and convert files to input to the final shell script. The following steps must be completed:

1. Download reference genome and HiC data
2. Unzip data
3. Align HiC data to the reference genome
4. Convert .sam alignment to .bed format
5. Sort the .bed format
6. Generate a contig length fast.fai file
7. Run SALSA2 assembly

### 3.1 DAG

Below is the DAG for the scaffolding pipeline using SALSA2.


![DAG](https://github.com/cbarcl01/BIOF501-project/blob/main/dag.svg)

### 3.2 Run pipeline

Before running pipeline, ensure all filepaths are correct and that no files have been renamed. Make sure the biof501 environment is active. Run the pipeline using the following code:

```
snakemake --cores 2 --use-conda
```
Note, we need to use the --use-conda instruction to get the pipeline to use the additional environment for the scaffold rule. If there are any issues downloading the data with the pipeline (sometimes latency issues can cause this to hang), please download manually with the following commands and move data to the data/ directory:

```
wget https://research.nhgri.nih.gov/mnemiopsis/download/genome/MlScaffold09.nt.gz
wget https://www.dropbox.com/s/tnnhxz3bsccgjbn/plotkin-mle_S3HiC_R1.fastq.gz
wget https://www.dropbox.com/s/tnnhxz3bsccgjbn/plotkin-mle_S3HiC_R2.fastq.gz

gzip -d MlScaffold09.nt.gz
gzip -d plotkin-mle_S3HiC_R1.fastq.gz
gzip -d plotkin-mle_S3HiC_R2.fastq.gz
```

## 3.3 Test results

Due to the size ofsome the outputs, not all of the test results could be stored on github. Therefore the results have been added to Dropbox and the link shared. The SALSA2 scaffolding generates an output directory with a large number of files, according to the [SALSA2 github](https://github.com/marbl/SALSA):

*SALSA is an iterative algorithm, so it generates files for each iteration. The files you will be interested in are scaffolds_FINAL.fasta, which contains the sequences for the scaffolds generated by the algorithm. Another file which is of interest is scaffolds_FINAL.agp, which is the agp style output for the scaffolds describing the assignment, orientation and ordering of contigs along the scaffolds.* 

Therefore the only files that need to be used to test the pipeline are `scaffolds_FINAL.fasta` and `scaffolds_FINAL.agp`. A summary of the key results is below.

**Alignment output**

This should be a alignment.sam file (please see [Dropbox link](https://www.dropbox.com/sh/93w4crzlzo6aspn/AACHTpnfqdRkxqj5KecGicBza?dl=0) for the full test file) with the following alignment:

```
69789521 reads; of these:
  69789521 (100.00%) were paired; of these:
    69690487 (99.86%) aligned concordantly 0 times
    66548 (0.10%) aligned concordantly exactly 1 time
    32486 (0.05%) aligned concordantly >1 times
    ----
    69690487 pairs aligned concordantly 0 times; of these:
      66086 (0.09%) aligned discordantly 1 time
    ----
    69624401 pairs aligned 0 times concordantly or discordantly; of these:
      139248802 mates make up the pairs; of these:
        96080762 (69.00%) aligned 0 times
        27925732 (20.05%) aligned exactly 1 time
        15242308 (10.95%) aligned >1 times
31.16% overall alignment rate
```

**Sorted Bed file**

This should be an alignment.sorted.bed file (please see [Dropbox link](https://www.dropbox.com/sh/93w4crzlzo6aspn/AACHTpnfqdRkxqj5KecGicBza?dl=0) for the full test file). Using the tail function the output should look like this:

```
ML4106  1075    1229    GWNJ-1013:282:GW211004000:2:2678:9986:3035/2    0       -
ML1541  817403  817553  GWNJ-1013:282:GW211004000:2:2678:9986:5791/1    42      +
ML0580  55832   55982   GWNJ-1013:282:GW211004000:2:2678:9995:12007/1   23      +
ML1117  263618  263768  GWNJ-1013:282:GW211004000:2:2678:9995:17331/1   0       -
ML4358  264128  264278  GWNJ-1013:282:GW211004000:2:2678:9995:18865/1   42      +
ML0509  194511  194658  GWNJ-1013:282:GW211004000:2:2678:9995:31986/1   0       +
ML0091  207530  207680  GWNJ-1013:282:GW211004000:2:2678:9995:32174/1   1       +
ML0040  2638    2788    GWNJ-1013:282:GW211004000:2:2678:9995:32174/2   0       +
ML1621  79504   79654   GWNJ-1013:282:GW211004000:2:2678:9995:36746/1   42      -
ML0711  491552  491702  GWNJ-1013:282:GW211004000:2:2678:9995:36996/1   3       -

```

**Scaffolds**

The scaffold files of interest are scaffolds_FINAL.agp in the test_results directory of this repo and scaffolds_FINAL.fasta which is in Dropbox (please see [Dropbox link](https://www.dropbox.com/sh/93w4crzlzo6aspn/AACHTpnfqdRkxqj5KecGicBza?dl=0) for the full test file). The final scaffold number was **4312**, a reduction from the original assembly of **5100**. Below are previews of the files, using the head function:

**scaffolds_FINAL.fasta**


```
>scaffold_1
ACAAGGAATCCGAAGTTGATAGTTTCGAATCCGAAAAATCATCACTTGACCCCTTAAATGACCCCTTATAATAAGGCCCC
AAAATTGTAATTTTCAACTTTGAGCTAGGAGAAAAGTTAGACCAGTATTTTGACGTAAAATTAGACAAGGAATCCGAATT
TGATAGTTTCGAATCCTAACAAGAATTGCGGCCGCTTTCACTGTGTCAGGCGACCGCTGAATTTCCCGTATCAATTATCA
TGCCGTCGCTTATTGTAATTAAAATTCGCGAAATAAGGAATCATAATACGCAACCACTAACCACACGTAATTTCAGTTAA
TTTTCATAGTTCTGGCTCTGCACGTGTAAATACAGACGCACGAATTAATGCAGCCGTTCAATGCATGATTTTAAAATTTC
ACGCTGCACGCGCAATGTTTGAACACTATCGCGCGTTCTTTTCATTGTTTTATTTCAAATATCTTGAGTCTGTATGACGT
CGTCATAATTATATTGTCTATGCTACCTTTATAATTTATTCATAGTCATACTGCGTTGTGTTTATACTTAATACTAATAG
CGTTATGTAAGTTTGTCGTTAAATATATTTGTACCGTGTACGGAGCTGATATTAAAATCGTGTTACATTCATCTTTCAAT
CTGTCAAATTTCGACAAATTACTCAATAAAAGTAAAACTAAAGTTCATAGAATTTTGATCATTTTTCTTGATGTGAGGCA
```
**scaffolds_FINAL.fasta**

```
scaffold_1      1       1222598 1       W       ML1541  1       1222598 +
scaffold_2      1       584472  1       W       ML0179  1       584472  -
scaffold_2      584473  584972  2       N       500     scaffold        yes     na
scaffold_2      584973  960666  3       W       ML0864  1       375694  -
scaffold_3      1       734417  1       W       ML0569  1       734417  +
scaffold_4      1       708851  1       W       ML0032  1       708851  +
scaffold_5      1       366950  1       W       ML0044  1       366950  +
scaffold_5      366951  367450  2       N       500     scaffold        yes     na
scaffold_5      367451  443353  3       W       ML1026  1       75903   +
scaffold_5      443354  443853  4       N       500     scaffold        yes     na

```


#### References

1. 	Ghurye J, Rhie A, Walenz BP, et al. Integrating Hi-C links with assembly graphs for chromosome-scale assembly. PLoS Comput Biol. 2019;15(8):1-19. doi:10.1371/journal.pcbi.1007273
2. 	Bresler G, Bresler M, Tse D. Optimal assembly for high throughput shotgun sequencing. BMC Bioinformatics. 2013;14 Suppl 5(Suppl 5):1-13. doi:10.1186/1471-2105-14-s5-s18
3. 	Nagarajan N, Pop M. Parametric complexity of sequence assembly: Theory and applications to next generation sequencing. J Comput Biol. 2009;16(7):897-908. doi:10.1089/cmb.2009.0005
4. 	Amarasinghe SL, Su S, Dong X, Zappia L, Ritchie ME, Gouil Q. Opportunities and challenges in long-read sequencing data analysis. Genome Biol. 2020;21(1):1-16. doi:10.1186/s13059-020-1935-5
5. 	Pollard MO, Gurdasani D, Mentzer AJ, Porter T, Sandhu MS. Long reads: Their purpose and place. Hum Mol Genet. 2018;27(R2):R234-R241. doi:10.1093/hmg/ddy177
6. 	Sacerdot C, Louis A, Bon C, Roest Crollius H. Chromosome evolution at the origin of the ancestral vertebrate genome. Genome Biol. 2018:1-15. doi:10.1101/253104
7. 	Ryan JF, Pang K, Schnitzler CE, et al. The genome of the ctenophore Mnemiopsis leidyi and its implications for cell type evolution. Science (80- ). 2013;342(6164). doi:10.1126/science.1242592

