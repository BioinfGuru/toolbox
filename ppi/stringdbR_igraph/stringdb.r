#!/usr/bin/env Rscript
# Create PPI with stringdb and igraph
# Careful: stringdb will map things to what look like Ensembl protein IDs but really aren’t
# Sid Sethi - Kenneth Condon
# Feb 2018

# clear environment
rm(list=ls())

# load libraries
suppressPackageStartupMessages({
  library(STRINGdb)
  library(igraph)
})



args<-commandArgs(TRUE)   #1st arument = table/tissue , 2nd = output directory path
 
data = read.table(args[1], header = F, sep="\t")
### data = read.table("Wbrain.genes.txt", header = F)
### data = data[c(1:200),,drop=F]
#colnames(data) = c("geneSymbol","type")
colnames(data) = c("geneSymbol")
 
setwd(args[2])
 
cat("Initialising String object....\n")
string_db = STRINGdb$new( version="10", species=10090 , score_threshold = 900, input_directory="/NGS/users/Kenneth/ppi_plotting/stringdbR_igraph/lib/StringDB_data")
 
cat("Mapping input genes to STRING IDs....\n")
d_map <- string_db$map( data, "geneSymbol", removeUnmappedRows = TRUE )
#interactions = string_db$get_interactions(d_map$STRING_id)
 
cat("\nFetching the sub network....\n")
network.t = string_db$get_subnetwork(d_map$STRING_id)
network = delete.vertices(network.t,which(degree(network.t)<1))
 
# summary = string_db$get_summary(d_map$STRING_id)
# summary = sub("\n",", ",summary)
# summary = sub("\n",", ",summary)
# summary = sub("\n","",summary)
 
### extracting gene names and adding as labels to the i graph
cat("Extracting genes names....\n")
names = V(network)$name
labels = data.frame()
for(i in 1:length(names)){
                l = d_map[d_map$STRING_id == names[i],,drop=T]
                labels[i,"geneSymbol"] = l$geneSymbol[1]
                labels[i,"STRING_id"] = l$STRING_id[1]
                #gene = l$geneSymbol[1]
                ##type = data[data$geneSymbol == gene,]$type
                ##labels[i,"type"] = type
                #labels[i,"type"] = l$type[1]
}
#labels$type = as.character(labels$type)
### function to convert gene symbols UPPERCASE to Lowercase
r_ucfirst <- function (str) {
  paste(toupper(substring(str, 1, 1)), tolower(substring(str, 2)), sep = "")
}
labels$geneSymbol = r_ucfirst(labels$geneSymbol)
V(network)$label = labels$geneSymbol
#V(network)$type = labels$type
###########################################################################################
######################  PHENOTYPING #######################################################
###########################################################################################
 
### working on extracting phenotype, for adding attributes to the graph object
#cat("Extracting the phenotypes....\n")
#mp = "/NGS/users/Sid/ChromHmm/Posterior/State_6/POSTERIOR/Tau_enhancers/TauResults/Highly_specific/Pleitropy_mp/mgi_mp_matrix_update.txt"
#mp = "/NGS/users/Sid/ENHANCERS/SuperEnh/Mgi_phenotypes/MATRIX.txt"
#df = read.table(mp,header=T,sep="\t")
 
#phenotypes = data.frame()
#for(i in 1:nrow(labels)){
 #               present = labels$geneSymbol[i] %in% df$Gene
#                if(present == FALSE){
#                                phenotypes[i,"gene"] = labels$geneSymbol[i]
#                                phenotypes[i,"mp1"] = 0
                                #phenotypes[i,"mp2"] = 0
#                }else{
 #                               m = df[df$Gene == labels$geneSymbol[i],,drop=T]
  #                              phenotypes[i,"gene"] = labels$geneSymbol[i]
   #                             phenotypes[i,"mp1"] = m$MP.0003631[1]
                                #phenotypes[i,"mp2"] = m$MP.0003631[1]
    #            }
#}
###### for single phenotype
#phenotypes$final = phenotypes$mp1
###### for multiple phenotypes
#phenotypes$final = phenotypes$mp1 + phenotypes$mp2
 
#V(network)$mp = phenotypes$final
 
out = sub(".txt","",args[1])
file_name = paste(out,".png",sep="")
 
title = out
 
print(file_name)
 
# 
# legend = "Hypertensive Disease"
# 
#  
# 
# E(network)[ V(network)[mp=="0"] %->% V(network)[mp >= "1"] ]$color = "skyblue"
# 
# E(network)[ V(network)[mp >="1"] %->% V(network)[mp >= "1"] ]$color = "grey"
# 
# E(network)[ V(network)[mp =="0"] %->% V(network)[mp == "0"] ]$color = "grey"
# 
#  
# 
# V(network)$frame.color = adjustcolor("black",alpha.f=0.4)
# 
# #V(network)$frame.color = ifelse(V(network)$type == "Cerebellum",adjustcolor("green",alpha.f=0.4),V(network)$frame.color)
# 
# #V(network)$frame.color = ifelse(V(network)$type == "Cortex",adjustcolor("yellow",alpha.f=0.4),V(network)$frame.color)
# 
# #V(network)$frame.color = ifelse(V(network)$type == "Wbrain",adjustcolor("red",alpha.f=0.4),V(network)$frame.color)
# 
# #V(network)$frame.color = ifelse(V(network)$type == "multiple",adjustcolor("blue",alpha.f=0.4),V(network)$frame.color)
# 
#  
# 
lo = layout_with_fr(network, grid = "nogrid")
 
#################### For interactive plotting #############
########## helpful for tweaking ###########################
# library(tcltk)
# tkid <- tkplot(network,
#             #vertex.label = NA,
#             vertex.label = ifelse(V(network)$mp == 0, V(network)$label, NA),
#             vertex.label.dist = 0.52,
#             vertex.size = 4.5,
#             #vertex.size = ifelse(V(network)$mp == 0,2,1.5),
#             #vertex.label.color = "skyblue",
#             vertex.label.cex = 0.8,
#             #layout=layout.kamada.kawai,
#             layout = lo,
#             edge.width = 0.4,
#             frame=TRUE,
#             margin = c(0,0,0,0),
#             #main = title,
#             #vertex.frame.color = adjustcolor("black",alpha.f=0.4),
#             #vertex.shape = c("square","circle")[1+(V(network)$type=="no_enh")],
#             #vertex.frame.color = adjustcolor(c("black","red")[1+(V(network)$type=="2")],alpha.f=0.4),
#             vertex.color=adjustcolor(c("pink","skyblue")[1+(V(network)$mp=="0")],alpha.f=0.8)
# )
# new.cord <- tkplot.getcoords(tkid) # grab the coordinates from tkplot
#save(new.cord, file = "tkplot.cordinates.RData") # for saving into a file
# ###### tk_close(tkid, window.close = T)
# ## change the layout in the real plot to "new.cord" to plot with the new coordinates
###########################################################################################
######################  PLOTTING WITH IGRAPH ##############################################
###########################################################################################
 
cat("Plotting network....\n")
png(file_name,bg="transparent",units="in",width = 7.25, height= 6.25 ,res=600)
plot(network,
                #vertex.label = NA,
                #vertex.label = ifelse(V(network)$mp == 0, V(network)$label, NA),
                vertex.label.dist = 0.52,
                vertex.size = 2.5,
                #vertex.size = ifelse(V(network)$mp == 0,2,1.5),
                #vertex.label.color = "skyblue",
                vertex.label.cex = 0.4,
                #layout=layout.kamada.kawai,
                layout = lo,
                edge.width = 0.4,
                frame=TRUE,
                margin = c(0,0,0,0)
                #main = title,
                #vertex.frame.color = adjustcolor("black",alpha.f=0.4),
                #vertex.shape = c("square","circle")[1+(V(network)$type=="no_enh")],
                #vertex.frame.color = adjustcolor(c("black","red")[1+(V(network)$type=="2")],alpha.f=0.4),
                #vertex.color=adjustcolor(c("#CCCC00","cornflowerblue")[1+(V(network)$mp=="0")],alpha.f=0.8)
)
#legend(x=-1.4, y=-0.80, c("Wbrain-enh","Cortex-enh","Cerebellum-enh","multiple-enh"), pch=c(22,22,22,22), pt.bg=c("NA","NA","NA","NA"),col=c("red","yellow","green","blue"),pt.cex=1, cex=.6, bty="n", ncol=1)
#legend(x=0.65, y=-0.77, c("known","novel"), pch=c(21,21), pt.bg=c("#CCCC00","cornflowerblue"),col=c("black","black"),pt.cex=1.2, cex=0.6, bty="n", ncol=2, title = legend)
#legend(x=0.60, y=-0.92, c("novel --> known","known --> known"), lty=c(1,1),col=c("skyblue","grey"),lwd=c(1.5,1.5), cex=0.6, bty="n", ncol=1)
 
dev.off()
 
#####################################################################################
####################################################################################
######################################################################################
# 
# 
# cat("Extracting all connected nodes....\n")
# 
# genesWithInteractions = V(network)$label
# 
# allConnecting = data.frame()
# 
# for(i in 1:length(genesWithInteractions)){
# 
#                 l = phenotypes[phenotypes$gene == genesWithInteractions[i],,drop=T]
# 
#                 allConnecting[i,"gene"] = l$gene[1]
# 
#                 allConnecting[i,"mpFinal"] = l$final[1]
# 
# }
# 
#  
# 
# ### extracting novel genes connecting to known phenotype genes
# 
# cat("Extracting novel nodes connected to phenotype nodes....\n")
# 
# edges_nk = as_ids(E(network)[ V(network)[mp=="0"] %->% V(network)[mp >= "1"] ])
# 
# k=1
# 
# novelConnecting = data.frame()
# 
# for(i in 1:length(edges_nk)){
# 
#                 for(j in 1:2){
# 
#                                 n1 = labels[labels$STRING_id == unlist(strsplit(edges_nk[i],"[|]"))[j],,drop=T]$geneSymbol
# 
#                                 l = phenotypes[phenotypes$gene == n1,,drop=T]
# 
#                                 if(l$final == 0){
# 
#                                                 novelConnecting[k,"gene"] = l$gene[1]
# 
#                                                 novelConnecting[k,"mpFinal"] = l$final[1]
# 
#                                                 k=k+1
# 
#                                 }
# 
#                 }
# 
# }
# 
# novelConnecting = unique(novelConnecting)
# 
#  
# 
# file_name_2 = paste(out,"_allConnecting.txt",sep="")
# 
# write.table(allConnecting,file=file_name_2,sep="\t",quote=F,row.names=F)
# 
# file_name_3 = paste(out,"_novelConnecting.txt",sep="")
# 
# write.table(novelConnecting,file=file_name_3,sep="\t",quote=F,row.names=F)
# 
#  
# 
# ### extracting no of genes with phenotype from original input data
# 
# cat("Calculating and writing stats....\n")
# 
# input_pheno = data.frame()
# 
# for(i in 1:nrow(data)){
# 
#                 present = data$geneSymbol[i] %in% df$Gene
# 
#                 if(present == FALSE){
# 
#                                 input_pheno[i,"mp1"] = 0
# 
#                                 #input_pheno[i,"mp2"] = 0
# 
#                 }else{
# 
#                                 m = df[df$Gene == as.character(data$geneSymbol[i]),,drop=T]
# 
#                                 input_pheno[i,"mp1"] = m$MP.0003631[1]
# 
#                                 #input_pheno[i,"mp2"] = m$MP.0003631[1]
# 
#                 }
# 
# }
# 
#  
# 
# input_genes = table(input_pheno)
# 
# network_genes = table(phenotypes$final)
# 
# stats_1 = rbind(input_genes,network_genes)
# 
# statsFile = paste(out,".stats.txt",sep="")
# 
# write.table(stats_1,file=statsFile,sep="\t",quote=F)
# 
#  
# 
# cat("writing mapping and Novel-known interactions....\n")
# 
# file_name_4 = paste(out,"_mapping.txt",sep="")
# 
# write.table(d_map,file=file_name_4,sep="\t",quote=F,row.names=F)
# 
# file_name_5 = paste(out,"_nkinteractions.txt",sep="")
# 
# write.table(edges_nk,file=file_name_5,sep="\t",quote=F,row.names=F)