# License
 Copyright 2019
 Code by		**Simone Marini**,
 			**Francesca Vitali**,
 			**Andrea Demartini**,
    			and
			**Daniele Pala**.

 This file is part of "Matrix trifactorization for discovery of data similarity and association".

 Matrix trifactorization for discovery of data similarity and association" is free software: you
 can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 "Matrix trifactorization for discovery of data similarity and association" is distributed in
 the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with "Matrix trifactorization for discovery of data similarity and association"

If not, see <http://www.gnu.org/licenses/>.

"Matrix trifactorization for discovery of data similarity and association" is free software: you
can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

"Matrix trifactorization for discovery of data similarity and association" is distributed in
the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with "Matrix trifactorization for discovery of data similarity and association"
If not, see <http://www.gnu.org/licenses/>.

# Matrix trifactorization for discovery of data similarity and association

This algorithm predicts novel association or similarity among elements of a relational matrix. For example, given an ontology or a relational data set, such as tuples or associated elements, it infers the implicit relations emerging from the data patterns.

Data are grouped in data types, e.g. patients, genes, proteins, or pathways. Matrices are utilized to represent the relations (associations) between elements of different or same data types, e.g., the relations could be gene co-expression, gene or proteins interactions, relations among diseases, and so forth.

This approach is based on constrained joint matrix tri-factorization, inspired by the algorithm described in M. Zitnik and B. Zupan, “Data fusion by matrix factorization”, IEEE Transactions on Pattern Analysis & Machine Intelligence 37(1), 2015.

In its prototypal form, it was used in: “A Network-Based Data Integration Approach to Support Drug Repurposing and Multi-Target Therapies in Triple Negativ Breast Cancer”, PloS one 11(9), 2016.


# Cite
If you use this code in your research work, please cite:
1. [Marini, S., et al. "Protease target prediction via matrix factorization." Bioinformatics (2018).](https://doi.org/10.1093/bioinformatics/bty746)
2. [Vitali, F., et al. "Patient similarity by joint matrix trifactorization to identify subgroups in acute myeloid leukemia." JAMIA Open (2018).](https://doi.org/10.1093/jamiaopen/ooy008)

# Applications

#### Protease-protein target discovery.
This project aims to discover novel protein targets for human proteases. It leverages on [BioGRID](https://thebiogrid.org/), [KEGG](http://www.genome.jp/kegg/pathway.html), [STRING](https://string-db.org/), [3did](https://3did.irbbarcelona.org/), [Domine](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2238965/), [MEROPS](https://www.ebi.ac.uk/merops/), [UniProt](http://www.uniprot.org/), and [Interpro](https://www.ebi.ac.uk/interpro/).

[Data and parameters are available](protease_target).

More here: [Marini, S., et al. "Protease target prediction via matrix factorization." Bioinformatics (2018).](https://doi.org/10.1093/bioinformatics/bty746).

#### Application: Patient similarity in precision oncology.
This project is about computing patient similarity based on TCGA AML, integrated with public tools/repositories, namely [DisGeNET](http://www.disgenet.org/web/DisGeNET/menu), [BioGRID](https://thebiogrid.org/), [KEGG](http://www.genome.jp/kegg/pathway.html), [Disease Ontology](http://disease-ontology.org/), and [PaPI](http://papi.unipv.it/).

[Data and parameters are available](Patient_similarity_TCGA).

More here: [Vitali, F., et al. "Patient similarity by joint matrix trifactorization to identify subgroups in acute myeloid leukemia." JAMIA Open (2018).](https://doi.org/10.1093/jamiaopen/ooy008)


# Quick start

## Run the algorithm on toy example
1. Run `main` on the command line
2. When requested, input the project directory name `Test_example`
3. Profit

## Run the algorithm on your data
1. Prepare the data in the (pair, value) format as `csv` files (see below for the details, [Running the algorithm](#running-the-algorithm))
2. Set the parameters in your `parameters.m` file
3. Run `get_mats_from_PV.m`
3. Run `main.m`
4. Profit

# User manual
Manual by **Simone Marini**.

Contributions by **Daniele Pala** and **Giovanna Nicora**.

## Goal
This software predicts novel association or similarity among elements, i.e. given an ontology or a
relational data set, such as tuples or associated elements, it infers the implicit relations emerging
from the data patterns.
Data are grouped in object types, e.g. patients, genes, proteins, or pathways. Matrices are utilized
to represent the relations (associations) between elements of different or same object types. For
example, the relations could be gene co-expression, gene or proteins interactions, relations among
diseases and so forth.
The algorithm is based on constrained joint matrix tri-factorization, inspired by the algorithm
described in M. Zitnik and B. Zupan, “Data fusion by matrix factorization”, IEEE Transactions on
Pattern Analysis & Machine Intelligence 37(1), 2015; and F. Vitali, et al. “A Network-Based Data
Integration Approach to Support Drug Repurposing and Multi-Target Therapies in Triple Negative
Breast Cancer”, PloS one 11(9),2016.

## _D_ and _S_ mode
The objective of the algorithm is to unveil

+ relations among __different (D)__ data types, such as patient and disease (diagnosis) patient
and survival rate (prognosis)

+ relations among __same (S)__ data types, such as proteins (interaction discovery), or patients
(patient similarity computation).
These two modes will generate different outputs, as explained in section 7.
The objective of this manual is to describe how the code works. The concepts behind this algorithm
are explained in the literature mentioned above

## Language
This software is developed in Matlab 2018a.

## Folder organization

### Main Folder
The main folder contains the algorithm main script, along with attached documents, including this
manual. Other folders are project-specific, i.e. they host data and parameters for projects involving
the application of this algorithm. A ready-to-use toy example is provided in the folder
`Test_example`.

+ `main.m` runs the algorithm
+ `find_new_relations.m` computes the consensus matrices
+ `get_list.m` writes and saves a list of the found relations
+ `get_mat_from_PV.m` computes the _R_ and _Theta_ matrices reading the csv files in the `pair_value` folder
+ `get_R.m` computes the _R_ matrix
+ `get_teta.m` computes the constraint matrices Theta
+ `getNeg.m` and `getPos.m` calculate positive and negative elements in the matrices
+ `load_dump.m` loads the Matlab workspace saved in case of an unexpected interruption of the algorithm, from the last available backup (`parsave.m`)
+ `parsave.m` saves the Matlab environment every 100 iterations
+ `random_mats.m` computes random matrices _R_ and _Theta_ to make a toy example
+ `read_mats.m`reads the matrices to create the block matrix _R_
+ `trifact_core.m` contains the algorithm main calculations

### Project folders
Each project folder is structured in the followed way:

+ `parameters.m`, Matlab file specifying the algorithm parameters
+ `pair_value`, folder containing the associations in the (pair, value) format, e.g., `data_x,data_y,0.2`
+ `matrices,` folder containing the matrices representing the (pair, value) data
+ `objects`, folder with the list of unique elements of the object types
+ `output`, folder with the algorithm results

### Matrix construction
The initial matrices building the block matrix R are constructed from the `csv` files in the
`pair_value` folder. Each file contains the associations between object pairs of two specific types,
such as patient-gene; gene-gene; or gene-pathway; a single pair-value file is used to build
a relational matrix _r_. All _rs_ matrices are then assembled (i.e., each _r_ is a block) to compose _R_.
Every line in the pair-value files contains two objects written in a specific order and separated by
commas, as well as a [0, 1] weight quantifying the relation between them, as depicted in Figure 1.

![Figure1](https://github.com/smarini/MaDDA/blob/master/Figures/Figure1.png "Figure1")

__Figure 1__: pairs of objects and their relations, comma separated. The names are random as they are self-generated in the toy example project.

The constraints for the filenames are:
+ `<Data type 1>_<Data type 2>.csv` for the ones containing relations among different types of Data types (relation matrices);
+ `<Data type 1>_<Data type 1>_<n>.csv` if they contain relations among objects of the same type. `n` represents the mutiplicity, that can be >1 for the constraint matrices, i.e.
the matrices made of relations between same-type objects. In other words, there can be multiple matrices representing the relations between data type A and B.

The matrices are built automatically running the script `get_mat_from_PV.m`. A graphical example
is provided in Figure 2. The values in the relation matrix R must be bounded in the [0, 1]
interval, while in the constraint matrices they are bounded in the [-1, 1] interval. Note that -1
meaning the strongest relationship and 1 meaning the strongest diversity.

![Figure2](https://github.com/smarini/MaDDA/blob/master/Figures/Figure2.png "Figure2")

__Figure 2__: example of how matrices are extracted from the pair-value files. The relation matrix of two object
types is assembled, in this example patient and gene.
The csv files must be saved in the folder called pair_value.
It is not required for all the relation matrices to be present, whereas if one or more constraint
matrices are missing, an error message will appear. If the relations between objects of the same
type are unknown just construct the costraint matrix as a diagonal matrix with every element of the
diagonal equal to -1.

#### Matrix file naming convention
+ The relation matrices are named `R<n>-<m>.mat`, where `n` and `m` indicate respectively the n-th
and m-th type of object, following the order in which they are saved in the folder objects
(e.g. if the third type of data in the folder `objects` is _gene_ and the forth is _mutation_, then `R3-4`.mat is
the _gene-mutatio_n matrix);

+ The costraint matrices are named `T<t>-<n>.mat`, where `t` indicates the t-th type of object and `n`
is its multiplicity. For example, if _gene_ is the third object type, and we have both a _gene-
gene_ interaction matrix and a _gene-gene_ coexpression matrix, then `T3-1.mat` and `T3-2.mat`
are the first and the second gene-gene constraint matrices. They are based on
interactions and coexpressions, respectively.

All the `R<n>-<m>.mat` files contain a sparse matrix, `R_matr`. It is the relation matrix specific of the
types of object specified by the file name. Each `T<n>-<t>.mat` file, on the other hand, contains a
sparse matrix called `teta_matr`.

Each `mat` file in the folder `objects` contains a cell array called `vett` with the unique objects of
the type specified in the filename. Before running the algorithm it is possible to check if the number
and the names of the objects of a specific type correspond to expectations.


### Running the algorithm

#### Running the Toy example

The folder named `Test_example`, located in the main folder, contains a toy example that can be
run to test the algorithm. To use it is sufficient to run the script `main.m` and type
the name of the folder when requested on the Matlab command window.

###### Generating a random toy example

To more understand how the matrix construction works, you can use the script
named `random_mats.m`. The array `dim`delines the number of
the object types (number of elements of `dim`), and the number of objects of each type. When
exploring the algorithm with the random matrices, in order to avoid excessive computational times,
it is advisable to use a small number of object types (3-4) with less than 100 elements. However,
we also recommend to avoid a too small number of object elements. For example, one can use a
number of elements between 50 and 100 for each object. When the script starts, a message will
request the name of the project folder in which you desire to save the random matrices. Make sure
that the directories `objects`, `pair_value`, and `matrices` in the project folder are empty before
using the toy example, otherwise they will be rewritten.
Once `dim` and the name of the folder are defined, a list of `csv` files is
generated in the folder `pair_value`. The objects are strings randomly
created to mimic instances such as patient, protein, or gene IDs (refer to Figure 1 for an example). Data types are named
`ObjectA`, `ObjectB`, `ObjectC`, and so forth. The relations are built in a way that yields matrices
with a degree of sparsity of about 90%.

After creating the `csv` files, you should run the script `get_mats_from_PV.m`. After that, the random data are ready to be processed.

#### Running the algorithm on your data

##### Data preparation

+ In order to run the algorithm, you need to have the data in the correct format. The file naming
conventions and data format are described in [Matrix Construction](#matrix-construction). As an example, let's assume you have three data types, genes, pathways, and patients.
Then you could have the following files: `gene_pathway.csv`, `patient_gene.csv`, `patient_patient_1.csv`, `gene_gene_1.csv`, `gene_gene_2.csv`, and `gene_gene_3.csv`.

+ Make sure your data pairs, such as `gene_pathway.csv`, or `patient_disease.csv`, are in the folder `pair_values`.

+ Make sure the parameters in `parameteres.m` are correct, see [Parameters](#parameters))

##### Matrix calculation

Run `get_mats_from_PV.m` to compute the initial matrices. The matrices are saved
in the folder `matrices`, and the data types are save in `objects`.

##### Run the algorithm

Run `main.m`.

#### Parameters
In the script named `parameters.m` it’s possible to set the following parameters:
+ `num_rep`, desired number of runs (repetitions) of the algorithm. Default: 10.
+ `Targ` and `cTarg`, respectively the row and the column of the block matrix _R_ we are using as
target, i.e. the values of `n` and `m` indexes for the target matrix `R<n>-<m>.mat` where new
relations are to be unveiled. (To be used for both same-object, and different-object
searches).
+ `T`, stopping threshold, if the absolute difference of the target matrix reconstruction error is
below this value the algorithm stops (verified every 10 iteractions). Default: 10 −4 .
+ `epsilon`, an arbitrary small parameter that avoids divisions by zero that can occur.
Default:10 −16 . We advise to not change this parameter.
+ `index_target`, which indicates the object type whose objects we are interested to relate. (To
be used for same-object search only), in terms of row-column coordinates in _R_
+ `max_iter`, the maximum number of iterations for each repetition, default: 1000.
+ `directoryMAT`: the name of the folder in which the matrices to be used are. We advise to
not change this parameter.
`lambda`, an array that contains the ranking scaling factors, one for each object type.
`select`, a character that states if the algorithm will be used to compute the relations
between object of the same type (`s`) or of a different type (`r`).

When the `main.m` script is started, a message requesting the name of the project folder is displayed
on the Matlab command window. Type the name of the folder and the algorithm will start. There
6are two different ways to run the trifactorization algorithm, depending on whether the aim is to find
the relations between objects of the same type or not.

### Output
The results of the procedure can be found in the folder named output. Results depend on which
mode (D or S) the algorithm runs.

#### _S_ mode
+ Consensus consensus matrix found for objects of the same type.
+ `R_original`, initially assembled block relational matrix (sparse)
+ `R_reconstructed`, inferred block relational matrix (full)
+ `New_found_relations`, newly inferred associations for objects of the same type

#### _D_ mode

+ `Consensus_row`, consensus matrix found for objects of different type, according to the row rule.
+ `Consensus_col`, consensus matrix found for objects of different type, according to the column rule.
+ `R_original`, initially assembled block relational matrix (sparse)
+ `R_reconstructed`, inferred block relational matrix (full)
+ `New_found_relations_row`, newly inferred associations for objects of different type, according to the row rule.
+ `New_found_relations_col`, newly inferred associations for objects of different type, according to the column rule.

Once the tri-factorization has terminated, a `csv` file with a list of all the found relations is
saved in the output folder. This file is named `new_found_relations.csv` and
contains on each line the names of two objects and the weight of their found relation, separated by
comma. If the algorithm has been used to compute the associations among objects of the same
type, each line of the file will contain the two objects and separately the association values found
by the row-based and the column-based rules; if the algorithm has been used to find the
associations among objects of the same type, each line of the file will contain two objects and the
association value that can be found in the consensus matrix. In this case the associations are
reported in a descending order with respect to the strength of the association.

### Rank selection
The input ranks can be computed in different ways, including:

+ Ranking scaling factors, such as number of nonzero element of the matrix divided by an arbitrary
number such as 50, 100, or 200. The ranks for the matrix are then chosen as the number of columns divided by ranking scaling factor.
+ The dispersion coefficient ρ ∈ [0,1], providing an estimation of the performance, given the
chosen rank (the higher coefficient ρ, the better). Note that dispersion coefficient ρ is here
calculated by default with each run of the algorithm.
+ Cross validation can optimize rank selection.

## Additional information

+ During the execution of the script, some updates will appear on the Matlab command
window, showing for each repetition the Frobenius norm of
the objective function every 10 iterations;
+ In the event of an unexpected interruption of the script due to external causes, there is no
need to restart the process from the beginning. During the execution the Matlab workspace
is periodically saved in a `mat` file called `dump.mat`. You can reload the workspace variables
using the script named `load_dump.m` and resume the process.

# MaddA
