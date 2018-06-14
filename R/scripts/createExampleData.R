#!/usr/bin/env Rscript
# takes input data, and produces a randomised subset from which example data .rda files are created
# Kenneth Condon March 2018

# Guidelines:
    # the basics: http://r-pkgs.had.co.nz/data.html
    # the details: https://cran.r-project.org/doc/manuals/r-release/R-exts.html#Data-in-packages
    # Internal: FALSE when creating example data for the user, TRUE when adding internal data that the package itself needs
# Documentation:
    # Write notes on how you created the data + include notes in data-raw/ (http://r-pkgs.had.co.nz/data.html)
    # To document data, see http://r-pkgs.had.co.nz/data.html, section 'documenting datasets'

# create example data set in terminal:
# cut -f 1,5-16,28-30 meanRpkm.txt >example_meanRpkm_15.txt
# 

#clear environment
rm(list = ls())

# directories
input.dir <- '/home/kenneth/Documents/bioinf/data/' # laptop
output.dir <- '/home/kenneth/Documents/bioinf/rpackages/' # laptop
#input.dir <- '~/NGS/users/Kenneth/rpackages/data/' # desktop
#output.dir <- '~/NGS/users/Kenneth/rpackages/' # desktop

# read in example data set
meanExp <- read.delim(file = paste(input.dir, 'example_meanRpkm_15.txt', sep = ''), row.names = 1, dec = ".", fill = FALSE)

# rename the columns
colnames(meanExp) <- c('tissueA', 'tissueB', 'tissueC', 'tissueD', 'tissueE', 
                       'tissueF', 'tissueG', 'tissueH', 'tissueI', 'tissueJ', 
                       'tissueK', 'tissueL', 'tissueM', 'tissueN', 'tissueO')

# randomly rearrange rownames
rownames(meanExp) <- sample(rownames(meanExp))

# subset if needed to reduce size
#meanExp <- head(meanExp, n = 10000)
#meanExp <- meanExp[,1:10] 

# ============================================================================ #
# ###### Now run all package functions to create their output objects ######## #
# ============================================================================ #

# create .rda files from the output objects
setwd(output.dir)
devtools::use_data(meanExp, pkg = 'tispec', internal = FALSE, overwrite = TRUE, compress = 'xz') 
devtools::use_data(log2Exp, pkg = 'tispec', internal = FALSE, overwrite = TRUE, compress = 'xz') 
devtools::use_data(qnExp, pkg = 'tispec', internal = FALSE, overwrite = TRUE, compress = 'xz') 
devtools::use_data(tauExp, pkg = 'tispec', internal = FALSE, overwrite = TRUE, compress = 'xz') 
devtools::use_data(tauAnno, pkg = 'tispec', internal = FALSE, overwrite = TRUE, compress = 'xz') 
devtools::use_data(tissueA, pkg = 'tispec', internal = FALSE, overwrite = TRUE, compress = 'xz') 
devtools::use_data(tissueB, pkg = 'tispec', internal = FALSE, overwrite = TRUE, compress = 'xz')
devtools::use_data(optimum, pkg = 'tispec', internal = FALSE, overwrite = TRUE, compress = 'xz')

# ==============================================================================
# for a single file in input directory without running package
#inputfilename <- read.delim(file = paste(input.dir, 'inputfilename', sep = ''), dec = ".", fill = FALSE)

# for multiple files in input directory without running package
# setwd(input.dir)
# file.names <- list.files(full.names = FALSE)
# data <- lapply(file.names, function(x){
#   read.delim(file = x, dec = ".", fill = FALSE)
# })
# names(data) <- file.names
# names(data)
# str(data)

# create R/sysdata.R
#setwd(output.dir)
#devtools::use_data(inputfilename, pkg = 'packagename', internal = FALSE, overwrite = TRUE, compress = 'xz') 
