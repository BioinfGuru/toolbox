#!/usr/bin/env Rscript
# kenneth condon march 2018
# calculates tissue specificity

########################################
######## Install with devtools #########
########################################
#if (!require("devtools")){install.packages("devtools")}
#install_github('roonysgalbi/tispec')
#help(package = 'tispec')

########################################
################ SET UP ################
########################################

# clear environment
rm(list = ls())

# load libraries
library(tispec)

# Set working directory
#wd <- '/home/kenneth/Documents/bioinf/data/' # linux laptop
wd <- '~/NGS/users/Kenneth/rpackages/data/' # linux desktop
#wd <- 'C:/users/admin/Documents/software/R/' # windows laptop
#setwd(wd)

########################################
############### PIPELINE ###############
########################################

#meanExp <- read.delim(file = "meanRpkm.txt", row.names = 1, dec = ".", fill = FALSE) # full data set
checkInput(meanExp)                                                     # check data for compatibility
log2Exp <- log2Tran(meanExp)                                            # log transform
qnExp <- quantNorm(log2Exp)                                             # quantile normalise
tauExp <- calcTau(qnExp)                                                # calculate tau + tau expression fraction
tauAnno <- getMart(x = 'mouse', y = 79, z = tauExp)                     # get ensembl data
plotDensity(tauAnno)                                                    # plot tissue specificity density
getDist(tauAnno, 1)                                                     # distribution of tissue specific genes
plotDist(tauAnno)                                                       # plot asgs + hsgs
tissueA <- getTissue('tissueA', qnExp, tauAnno)                         # extract a user defined tissue (colnames(meanExp))
optimum <- getOptimum(tauAnno, tissueA, 5)                              # plot top expressed tissue specific genes
corrPlots <- plotCorr(tissueA, c('Col4a3', 'Mboat7'))                    # plot correlation between specifity + expression
controls <- getControls(tissueA, tissueB)                               # Get a set of control genes: summary(controls)
gene <- subset(tauAnno, tauAnno$external_gene_name == 'Mboat7')          # extract a user specified gene
plotGene(tauAnno, 'Mboat7')                                              # plot a user specified gene

########################################
################ OUTPUT ################
########################################

# write table
# write.table(tauExp, file = "tauExpHead.txt", sep = "\t", dec = ".", row.names = TRUE, col.names = TRUE, quote = FALSE)

# write table including header in rowname column
#df <- output.from.get.mart.function
#out <- 'output.from.get.mart.function'
#df <- cbind(rownames(df), df)
#colnames(df)[1] <- 'ensembl_gene_id'
#write.table(df, file = out, sep = "\t", dec = ".", row.names = FALSE, col.names = TRUE, quote = FALSE)

# print image
#png("name.png", width = 1800, height = 800)
#objectname
#dev.off()

# color blind palette
#cb.palette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
#                   grey     l/orange     l/blue    d/green     yellow     d/blue   d/orange     pink

########################################
