#!/bin/Rscript
args<-commandArgs(TRUE)   #1st arument = table , 2nd = output directory path

library(RcisTarget)
library(RcisTarget.mm9.motifDatabases)
library(reshape2)
library(igraph)

# Load gene sets to analyze
cat("\nReading input data file....\n")
data = read.table(args[1], header = F)
#data = read.table("BAT.genes.txt", header = F)
colnames(data) = c("geneSymbol")
geneLists <- list(tissue=as.character(data$geneSymbol))

setwd(args[2])

# Select motif database to use (i.e. organism and distance around TSS)
cat("Loading motif data for mm9....\n")
data(mm9_10kbpAroundTss_motifRanking)
data(mm9_direct_motifAnnotation)
data(mm9_indirect_motifAnnotation)
motifRankings <- mm9_10kbpAroundTss_motifRanking

# Motif enrichment analysis:
cat("Running motif enrichment analysis....\n")
res = cisTarget(geneLists, motifRankings, motifAnnot_direct=mm9_direct_motifAnnotation, motifAnnot_indirect=mm9_indirect_motifAnnotation,
nCores = 3
)
cat("Writing enrichment results to file....\n")
out = sub(".genes.txt","",args[1])
resFile1 = paste(out,".res.all.txt",sep="")
resFile2 = paste(out,".res.short.txt",sep="")
write.table(res,file=resFile1,sep="\t",quote=F, row.names=F)
write.table(res[,1:8],file=resFile2,sep="\t",quote=F, row.names=F)

# finding motifs associated with a TF
anotatedTfs <- lapply(split(res$TF_direct, res$geneSet),
                      function(x) unique(unlist(strsplit(x, "; "))))

# extracting motif ids of the annotated Tfs
if(length(anotatedTfs$tissue)>=3){
loopLen = 3
} else{
loopLen = length(anotatedTfs$tissue)
}
motifNames = character(loopLen)                    
for(i in 1:loopLen){
motif_id = res[res$TF_direct==anotatedTfs$tissue[i],1:2]$motif[1]
motifNames[i] = motif_id
}

# Exracting Matrix of interactions for network
cat("Finding genes with top 3 motifs, generating interactions for network....\n")                      
incidenceMatrix <- getSignificantGenes(geneLists$tissue, 
                                       motifRankings,
                                       signifRankingNames=motifNames,
                                       plotCurve=FALSE, maxRank=5000, 
                                       genesFormat="incidMatrix",nCores=3,
                                       method = "iCisTarget")$incidMatrix

# generating edges and nodes for network                                       
edges <- melt(incidenceMatrix)
edges <- edges[which(edges[,3]==1),1:2]
colnames(edges) <- c("from","to")

motifs <- unique(as.character(edges[,1]))
genes <- unique(as.character(edges[,2]))
nodes <- data.frame(id=c(motifs, genes),   
          label=c(anotatedTfs$tissue[1:loopLen], genes), 
          shape=c(rep("sphere", length(motifs)), rep("circle", length(genes))),
          size=c(rep(7, length(motifs)), rep(2.5, length(genes))),
          color=c(rep("yellow", length(motifs)), rep("skyblue", length(genes)))
)

# making igraph object
net <- graph_from_data_frame(d=edges, vertices=nodes, directed=T)
geneNames = V(net)$name

cat("Extracting the phenotypes....\n")
mp = "/Users/s.sethi/Desktop/working_paper/Tau_results/Enhancers/Pleitropy_mp/mgi_mp_matrix.txt"
df = read.table(mp,header=T,sep="\t")

phenotypes = data.frame()
for(i in 1:length(geneNames)){
present = geneNames[i] %in% df$Gene
if(present == FALSE){
phenotypes[i,"mp1"] = 0
#phenotypes[i,"mp2"] = 0
}else{
m = df[df$Gene == geneNames[i],,drop=T]
phenotypes[i,"mp1"] = m$MP.0005380[1]
#phenotypes[i,"mp2"] = m$MP.0003631[1]
} 
}
V(net)$mp = phenotypes$mp1 # for single phenotype
# for multiple phenotypes
#phenotypes$final = phenotypes$mp1 + phenotypes$mp2
#phenotypes$final = ifelse(phenotypes$final == 2,1,phenotypes$final)
#V(net)$mp = phenotypes$final

color = V(net)$mp
for(i in 1:length(color)){
if(color[i]== "0"){
color[i] = "skyblue"
}else if(color[i]=="1"){
color[i] = "hotpink"
}
}
for(i in 1:3){
color[i] = "yellow"
}


file_name = paste(out,".png",sep="")
title = out

cat("Plotting network....\n")
print(file_name)
png(file_name,bg="transparent",units="in",width = 7.25, height= 6.25 ,res=600)
plot(net, 
vertex.label = ifelse(V(net)$size > 3, V(net)$label, NA), 
vertex.label.degree = -pi/2,
vertex.label.dist= 0.4,
vertex.label.color = "black",
vertex.label.font = 2, vertex.label.cex = 0.7,
layout=layout.kamada.kawai,
main = title,
edge.width = 0.2,
frame=TRUE,
margin = c(0,0,0,0),
edge.arrow.size = 0.07,
vertex.frame.color = adjustcolor("black",alpha.f=0.4),
#vertex.color=adjustcolor(nodes$color,alpha.f=0.8)
vertex.color=adjustcolor(color,alpha.f=0.8)
)
legend(x=0.85, y=-0.80, c("TF enriched","known","novel"), pch=21, pt.bg=c("yellow","hotpink","skyblue"), pt.cex=1.3, cex=0.55, bty="n", ncol=1, title = "Embryogenesis\nphenotype")
dev.off()