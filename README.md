# CGPS
CGPS is a tool for gene set enrichment analysis. It integrates nine methods for a more confident result comparing to use one single method.
The nine methods are two network-based method, CEPA and GANPA; and seven set-based method, GSEA, GSA, PADOG, PLAGE, GLOBALTEST,GAGE and SAFE.
## Installation 
### Package dependencies
  R package:
* Biobase
* limma
* edgeR
* gage
* GSVA
* EnrichmentBrowser
* dplyr
* datatable

### Step 1
  Download CGPS.
### Step 2
  Create development conda environment with 
```bash
  conda env create environmental.yml
```
  Activate the environment with
```bash
  source activate cgps
```
### Step 3
  Tell CGPS the directory of itself.
  Open the cgpsrc file, rite CGPS directory after '=', and copy this file into your $HOME directory as '.cgpsrc'
### Run CGPS
1. To run the pipeline, you should always activate cgps environment except you have all dependent softwares installed.
 source activate cgps
2. Prepare the input data. 
  * EXP file: expression data file. A tab delimited text file format that contains expression values. Columns correspond to samples, rows correspond to genes. Header='Genes' and sample names , Row names = gene ID. 
  * PHE file: sample class file. Sample class label, separated by the new lines. Each sample label should be corresponding with each sample in the expression matrix (from 2nd column to the last column of the matrix).
  Use '0' for unaffected samples (controls) and ‘1’ for affected samples (cases). Only binary class type is supported.   
  * Species: input the abbr of the species that you studied, the abbr refers to [KEGG website](http://www.genome.jp/kegg/catalog/org_list.html)
  * Data type: 'ma' for microarray, 'rseq' for RNA-Seq.
3. Run CGPS 
```bash
python run_cgps.py -e \[expfile\] -p \[phefile\] -s \[species\] -d \[ma\] -o \[outdir\]
```

>Notes: 
1. Only support KEGG PATHWAY now, unless you provide GMT file.
2. Only support NCBI ENTREZ GENE ID unless GMT file is provided. The type of gene ID in GMT file must match with that in EXP file.

### Example:
mkdir test/res
python run_cgps.py -e ./test/ALL_entrez.exp.txt -p ./test/ALL_BcrAbl_NEG.phe.txt -d ma -s hsa -o ./test/res


