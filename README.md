---
output:
  html_document:
    toc: true
    theme: united
---
    
# BIOF501-project: A chromosome scale assembly using SALSA2 with additional QC steps.

### Notes on Pipeline

The following pipeline aims to improve an existing reference assembly by utilisng HiC student will identify a dataset and develop a workflow that allows a third party to interrogate the dataset. The workflow must be created as a pipeline using Snakemake or NextFlow and requires that the student create a Standard Operating Procedure that documents the usage of the workflow.
The workflow must include visualisations so that the results can be easily interpreted.

As part of your project, you must:

- Describe the dataset, providing full accession details, number of individuals in the cohort, type of
data (DNA, RNA, methylation, etc) and other relevant metadata
- Some tools may accept several datasets or types (be specific and document flexibility)
- Clearly define your control and test groups
- Clearly state your hypothesis, aims and objectives
- Clearly describe your environment (python version, snakemake version, package versions, etc)

The Standard Operating Procedure (SOP) must provide details
on:

- Information about the pipeline and what it aims to do
- Expected results
- Usage instructions so that another person can replicate
your results
- The setup of the environment as well as package versions
so that it can be replicated easily
- Information about the data used in the analysis (source,
accession date, number of samples, disease status, etc.)
- Any accessory programs that will be called from snakemake
(including version numbers)


### 1. Background and rationale

Importance of chromosome scale assembly.

SALSA2 is a tool for chromosome scale assembly. Uses Hi-C data.

What is HiC data and how is it generated.

In this pipeline we aim to reduce the numebr of scaffolds for the current reference genome of the model organism *Mnemiopsis leidyi*.This organism is well placed phylogenetically as the sister group to all other metazoa and further understanding of it's genome can elucidate information around genome evolution, cell differentiation and conserved gene regulatory networks that are required for multicellularity.  

**Aim**: To improve reference genome for *Mnemiopsis leidyi* by reducing number of scaffolds and move towards a chromosome-scale assembly.

### 2. Getting Started

#### 2.1 Dependencies & Environment setup

You will require Miniconda and git to run this pipeline. This pipeline has been prepared for a linux terminal in BASH. 

Please note that SALSA2 is a tool in development and if installing manually you will need to use the specified versions for Python, BOOST libraries and Networkx. For more information on the tool itself, as well as additional functionality, please see the github repository for [SALSA2](https://github.com/marbl/SALSA).

Please be aware that conflicts in the python versions needed for each tool (version 2.7 for SALSA2 and >=3.1 for snakemake) has required different environments. The snakemake environment will be created from the `environment.yaml` file in the `envs` folder, while the pipeline itself will create another environment, within snakemake, to run SALSA2 - this environment has been called `SALSAenvironment`. Please ensure the environments are both stored in the envs folder so that the pipeline works correctly.  

**Clone repository**

Please use the following shell command to clone the repository:

```
git clone https://github.com/cbarcl01/BIOF501-project.git
```

**Create Conda Environment**

To run the pipeline, first create a conda environment with the relevant dependencies by using the `biof501env.yml` file in the `envs` subdirectory of this repository. The first line of the .yml file sets the environment's name, you can amend this as needed.

```
conda env create -f  envs/biof501env.yml
```

Due to conflicting versions of python required for different rules, we need to create an additional environment to run the final part of the pipeline for the salsa_scaffold rule. In Snakemake 3.9.0 you can define isolated software environments per rule, so please ensure you are using the most recent version. See [Integrated Package Management](https://snakemake.readthedocs.io/en/stable/snakefiles/deployment.html#integrated-package-management) of the snakemake documentation for more information. To create this environment please use the  

```
conda env create -f  envs/salsaEnvironment.yml
```

**Create Conda Environment**

To get started, activate the initial environment with the following code. The salsa environment does not need to be activated as this is referred to within the pipeline.

```
conda activate biof501env
```

#### 2.2 Data

**Download data**

An existing assembly and HiC data are required to run this pipeline. The data will be downloaded and unzipped as part of the pipeline, however the links are also included below. The HiC data used to test this pipeline was collected in the  Plotkin lab, as part of a masters research project and therefore has not been added to any accession/database yet.


|**Filename**    |**Description of file** |**Link to data** | 
|:----------- | :----------- | :----------- |
| MlScaffold09.nt  | Draft reference assembly file  | [download](https://research.nhgri.nih.gov/mnemiopsis/download/genome/MlScaffold09.nt.gz) | 
| plotkin-mle_S3HiC_R1.fastq.gz   | Forward read for HiC | [download](https://www.dropbox.com/s/tnnhxz3bsccgjbn/plotkin-mle_S3HiC_R1.fastq.gz) | 
| plotkin-mle_S3HiC_R2.fastq.gz   | Reverse read for HiC | [download](https://www.dropbox.com/s/tnnhxz3bsccgjbn/plotkin-mle_S3HiC_R2.fastq.gz) | 


### 3. Usage

Description of pipeline process

#### 3.1 DAG



#### 3.2 Run pipeline


### 3.3 Test results


**Alignment output**

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


#### References

