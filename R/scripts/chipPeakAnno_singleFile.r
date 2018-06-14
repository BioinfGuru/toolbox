#!/usr/bin/env Rscript
# Annotation of Peaks + bi-directional promoters
# Kenneth Condon
# May 2017

# clear environment
rm(list=ls())

# load libraries
suppressPackageStartupMessages({
  library(ChIPpeakAnno)
  library(EnsDb.Mmusculus.v79)
  library(org.Mm.eg.db)
  library(gsubfn)
  library(ggplot2)
  #library("grid")
  library(grid)
  })

# set the file to be annotated
#filename <- "~/NGS/working_projects/Zfhx3_ChipSeq_v2/FASTQ_2_filtered/Macs_results/Macs_results_001/differential/diff_Zt3VsZt15_c3.0_common.bed"
filename <- "~/NGS/working_projects/Zfhx3_ChipSeq_v2/FASTQ_2_filtered/Macs_results/motifs/results/unfiltered_p001_zt15_peaks/enh/zoops/fimo_out_1/fimo.parsed"

# collect annotation data
annoData <- toGRanges(EnsDb.Mmusculus.v79, feature="gene")

# read in the file (after overlappng with TAD file if present)
#input_file <- read.delim(file = filename, header = FALSE, dec = ".", fill = FALSE)
input_file <- read.table(text = system(paste("intersectBed -loj -a ",filename," -b ~/NGS/working_projects/Zfhx3_ChipSeq_v2/FASTQ_2_filtered/Macs_results/motifs/mESC_tads.mm10.txt", sep = ""), intern=TRUE))

# required for all files
colnames(input_file)[1] <- "seqnames"
colnames(input_file)[2] <- "start"
colnames(input_file)[3] <- "end"

# narrowPeak files
#colnames(input_file)[4] <- "peak"
#colnames(input_file)[4] <- "score"
#colnames(input_file)[5] <- "strand"
#colnames(input_file)[7] <- "fold_change"
#colnames(input_file)[8] <- "log10pval"
#colnames(input_file)[9] <- "log10qval"
#colnames(input_file)[10] <- "start_to_summit"

# bdgdiff files
#colnames(input_file)[5] <- "loglr"
#colnames(input_file)[6] <- "tad.chr"
#colnames(input_file)[7] <- "tad.start"
#colnames(input_file)[8] <- "tad.end"
#colnames(input_file)[9] <- "tad.id"

# fimo files
colnames(input_file)[4] <- "strand"
colnames(input_file)[5] <- "score"
colnames(input_file)[6] <- "pval"
colnames(input_file)[7] <- "qval"
colnames(input_file)[8] <- "seq"
colnames(input_file)[9] <- "motif"
colnames(input_file)[10] <- "tad.chr"
colnames(input_file)[11] <- "tad.start"
colnames(input_file)[12] <- "tad.end"
colnames(input_file)[13] <- "tad.id"

# Create GRanges object
suppressWarnings(peaks <- toGRanges(input_file, format="BED")) # ignore "duplicated or NA names found. Rename all the names by numbers"

# annotate peaks
anno <- annotatePeakInBatch(peaks,AnnotationData=annoData,PeakLocForDistance = "middle",select = "all", output = "both")
anno <- addGeneIDs(anno, orgAnn="org.Mm.eg.db",feature_id_type="ensembl_gene_id",IDs2Add=c("symbol","ensembl")) # https://rdrr.io/bioc/ChIPpeakAnno/man/addGeneIDs.html
anno.df <- as.data.frame(anno)

# write unfiltered results # needed for fishers exact test
write.table(anno.df,file=paste(filename,".unfiltered.anno", sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote = FALSE)

# filter by qval
anno.df <- subset(anno.df, qval < 0.01)  # can't filter bgdiff files

# write filtered results
write.table(anno.df,file=paste(filename,".anno", sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote = FALSE)
write.table(na.omit(unique(anno.df['symbol'])), file = paste(filename,".targetlist", sep=""), row.names = FALSE, sep = "\t", quote = FALSE, col.names = FALSE)
write.table(na.omit(unique(anno.df['tad.id'])), file = paste(filename,".tadlist", sep=""), row.names = FALSE, sep = "\t", quote = FALSE, col.names = FALSE)

# annotate bi directional promoters
#suppressWarnings(bdp <- peaksNearBDP(peaks, annoData, maxgap=5000, PeakLocForDistance =  "middle", FeatureLocForDistance = "TSS"))
#bdpPeaks <- unlist(bdp$peaksWithBDP) # convert GRangesList object to GRanges object
#bdpPeaks <- addGeneIDs(bdpPeaks, orgAnn="org.Mm.eg.db", feature_id_type="ensembl_gene_id", IDs2Add=c("symbol"))
#bdpPeaks <- split(bdpPeaks, seqnames(bdpPeaks)) # convert GRanges object to GRangesList object
#bdpPeaks.df <- as.data.frame(bdpPeaks)
#bdpPeaks.df[1] <- NULL # remove group column
#bdpPeaks.df[1] <- NULL # remove group_name column
#write.table(bdpPeaks,file=paste(wd,"/",filename,".annotated.bdp",sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

# line plot of distribution relative to TSS
distancetoFeature.df<-subset(anno.df, select = c('distancetoFeature'))                   
distancetoFeature.lineplot<-ggplot(distancetoFeature.df, aes(x=distancetoFeature))+                          
 geom_density(stat = "density",size = 0.5, fill = "red")+  
  geom_vline(aes(xintercept=0), linetype=2, colour = "black")+
  #labs(title= "Distribution relative to TSS")+
  scale_x_continuous(limits = c(-2000,2000), breaks = round(seq(min(-2000), max(2000), by = 500),1),name = "Distance to TSS")+               ##### For plotting PRO
  #scale_x_continuous(limits = c(-50000,50000), breaks = round(seq(min(-50000), max(50000), by = 25000),1),name = "Distance to TSS")+      ##### For plotting ENH
  #scale_x_continuous(limits = c(-200000,200000), breaks = round(seq(min(-200000), max(200000), by = 100000),1),name = "Distance to TSS")+      ##### For plotting ENH 
  #scale_x_continuous(limits = c(-500000,500000), breaks = round(seq(min(-500000), max(500000), by = 100000),1),name = "Distance to TSS")+      ##### For plotting ENH
  theme_bw()+
  theme(
    #plot.title = element_text(size=25,face="bold"),
    axis.title.x = element_text(size=25, face="bold"),
    axis.title.y = element_text(size=25, face="bold"),
    axis.text.x = element_text(size=18), 
    axis.text.y = element_text(size=18),
    panel.border = element_rect(colour="BLACK",size=0.5),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    strip.background = element_rect()
  )
distancetoFeature.lineplot

png(paste(filename,".line.png", sep=""), width = 600, height = 800)
distancetoFeature.lineplot
dev.off()

# Histogram of distribution relative to TSS (for ENH only)
distancetoFeature.df<-subset(anno.df, select = c('distancetoFeature'))
breaks = c(-5000,-600,-500,-400,-300,-200,-100,-2,0,0.2,100,200,300,400,500,600,5000)
ranges = paste(head(breaks,-1), breaks[-1], sep=" to ")
freq   = hist(distancetoFeature.df$distancetoFeature/1000, breaks=breaks, include.lowest=TRUE, plot=FALSE)
data = data.frame(range = ranges, frequency = freq$counts, stringsAsFactors = F)
data$per = (data$frequency/sum(data$frequency))*100

distancetoFeature.histogram<-ggplot(data, aes(x=range,y=per)) +
  geom_col(color = "red", fill = "red", lwd = 0.4,alpha = 0.5, width = 0.7) +
  geom_text(label=data$frequency,vjust=-0.3, size= 2)+
  #labs(title="Distribution") +
  scale_x_discrete(name = "Distance to TSS (kb)", limits = c("-500 to -400","-400 to -300","-300 to -200","-200 to -100","-100 to -2","-2 to 0","0 to 0.2","0.2 to 100","100 to 200","200 to 300","300 to 400","400 to 500"))+
  scale_y_continuous(name="Frequency %",breaks = pretty(data$per, n = 8))+
  theme_bw() +
  theme(panel.grid.minor=element_blank(), panel.grid.major=element_blank()) +
  theme(plot.title = element_text(size=14, hjust=0.5, face = "bold"),
        legend.key.size = unit(0.55,"cm"),
        legend.title = element_blank(),
        legend.text = element_text(size = 11),
        legend.position= c(0.83,0.9),
       legend.background = element_rect(fill = "transparent",colour = NA),
        axis.text.x = element_text(size=12, angle=45, hjust=1),    #20 before
        axis.text.y = element_text(size=12),
        panel.border = element_rect(colour="BLACK",size=0.4),
        axis.title.x = element_text(size=13, vjust = 0.1),
        axis.title.y = element_text(size=13,angle = 90, vjust = 0.6),
        panel.background = element_rect(fill="transparent"),
       plot.background = element_rect(fill = "transparent",colour = NA)
  )
distancetoFeature.histogram

png(paste(filename,".hist.png"), width = 600, height = 800)
distancetoFeature.histogram
dev.off()

