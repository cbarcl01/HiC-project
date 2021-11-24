----
output: github_document
----

# BIOF501-project: A chromosome scale assembly using SALSA2 with additional QC steps.

## Instructions

The student will identify a dataset and develop a workflow that allows a third party to interrogate the
dataset. The workflow must be created as a pipeline using Snakemake or NextFlow and requires
that the student create a Standard Operating Procedure that documents the usage of the workflow.
The workflow must include visualisations so that the results can be easily interpreted.
As part of your project, you must:
◦ Describe the dataset, providing full accession details, number of individuals in the cohort, type of
data (DNA, RNA, methylation, etc) and other relevant metadata
◦ Some tools may accept several datasets or types (be specific and document flexibility)
◦ Clearly define your control and test groups
◦ Clearly state your hypothesis, aims and objectives
◦ Clearly describe your environment (python version, snakemake version, package versions, etc)

The Standard Operating Procedure (SOP) must provide details
on:
◦ Information about the pipeline and what it aims to do
◦ Expected results
◦ Usage instructions so that another person can replicate
your results
◦ The setup of the environment as well as package versions
so that it can be replicated easily
◦ Information about the data used in the analysis (source,
accession date, number of samples, disease status, etc.)
◦ Any accessory programs that will be called from snakemake
(including version numbers)


## 1. Background and rationale

Importance of chromosome scale assembly.

SALSA2 is a tool for chromosome scale assembly. Uses Hi-C data.

What is HiC data and how is it generated.

In this pipeline we aim to reduce the numebr of scaffolds for the current reference genome of the model organism *Mnemiopsis leidyi*.This organism is well placed phylogenetically as the sister group to all other metazoa and further understanding of it's genome can elucidate information around genome evolution, cell differentiation and conserved gene regulatory networks that are required for multicellularity.  

**Aim**: To improve reference genome for *Mnemiopsis leidyi* by reducing number of scaffolds and move towards a chromosome-scale assembly.

## 2. Getting Started

### 2.1 Dependencies

You will require Miniconda and git to run this pipeline. This pipeline has been prepared for a linux terminal in BASH. 

Please note that SALSA2 is a tool in development and therefore you will need to use the specified versions for Python, BOOST libraries and Networkx. For more information on the tool itself, as well as additional functionality, please see the github repository for [SALSA2](https://github.com/marbl/SALSA).

**Clone repository**

Please use the following shell command to clone the repository:

```
git clone https://github.com/cbarcl01/BIOF501-project.git
```

**Conda Environment**

Generate a conda environment with the relevant dependencies by using the `environment.yml` file in this repository. The first line of the .yml file sets the environment's name, you can amend this as needed.

```
conda env create -f  environment.yml
```

### 2.2 Get Data

Download existing reference assembly using wget and unzip

```
wget https://research.nhgri.nih.gov/mnemiopsis/download/genome/MlScaffold09.nt.gz
gzip -d ./MlScaffold09.nt
```


## 3. Usage

### 3.1 DAG

### 3.2 Run pipeline
