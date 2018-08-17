#!/usr/bin/env Rscript
# creates, document, install, check new R packages
# Kenneth Condon April 2018

################################################################################

# install required packages
#install.packages("devtools")
#install.packages("roxygen2")
#source("https://bioconductor.org/biocLite.R")
#biocLite("BiocCheck")

# clear environment
rm(list = ls())

# use dev version (mid april - midoctober)
library(BiocInstaller)
useDevel(devel=FALSE) # enter true for devel, false for release
isDevel() # returns true for devel, false for release

# load libraries
suppressPackageStartupMessages({
    library(devtools)
    library(roxygen2)
    library(BiocCheck)
    library(biocViews)
    library(knitr)
    library(testthat)
})

# working directory
wd <- '/home/kenneth/Documents/'
setwd(wd)

# set package name
myNewPackageName <- 'tispec'                        # name

################################################################################
# vignette
#use_vignette('UserGuide', pkg = myNewPackageName)   # creates vignette template
#vignette('UserGuide', package = 'tispec')          # view vignette
#edit(vignette('UserGuide', package = 'tispec'))    # edit vignette

# make package
create(myNewPackageName)       # create
document(myNewPackageName)     # document
install(myNewPackageName)      # install
check(myNewPackageName)        # check - cran
BiocCheck(myNewPackageName)   # check - bioconductor

# additional options
help(package = 'tispec')                            # docs
recommendBiocViews(myNewPackageName)                # get biocview terms
remove.packages(myNewPackageName)                   # uninstall
use_travis(myNewPackageName)                        # adds travis to package

# unit testing
use_testthat(myNewPackageName)                      # unit testing
test_dir(paste(wd, myNewPackageName, '/', 'tests/testthat', sep = ''))



