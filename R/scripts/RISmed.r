#!/usr/bin/env Rscript
# Pubmed text mining http://amunategui.github.io/pubmed-query/
# Kenneth Condon
# Oct 2017

# clear environment
rm(list=ls())

# load packages
suppressPackageStartupMessages({
  library(RISmed)
  library(geneSynonym)
  library(reports)
  library(stringr)
})

##########################
# Collecting gene synonyms
# https://github.com/oganm/geneSynonym/blob/master/README.md
##########################
# get all mouse and human synonyms
mygene <-'zfhx3'
h.gene <- str_to_upper(mygene, locale = "en") # convert to human
h.syn <- humanSyno(h.gene)
h.syn <- unique(unlist(h.syn))
m.gene <- str_to_title(mygene, locale = "en") # convert to mouse
m.syn <- c(mouseSyno(m.gene))
m.syn <- unique(unlist(m.syn))
both.syn <- unique(c(h.syn,m.syn))
both.syn

# Get all pub med articles for the synonyms
pubmed_data <- data.frame()
for (i in both.syn)
{
  # create search string
  search_topic <- paste("(((",i,") AND adipogenesis)) OR ((",i,") AND adipocyte)", sep = "")
  #search_topic <- paste("(term1) AND term2")
  search_topic <- paste("(term1) AND term2")
  
  # search pubmed
  search_query <- EUtilsSummary(search_topic, retmax=100, mindate=2000,maxdate=2017)
  
  # create medline object
  records<- EUtilsGet(search_query)
  
  # store parameters of interest
  temp.df <- data.frame('Year'=YearPubmed(records), 'PMID'=PMID(records), 'Title'=ArticleTitle(records),'Abstract'=AbstractText(records))
  
  # add to existing results
  pubmed_data = rbind(pubmed_data, temp.df)
}

# clean the dataframe and remove duplicates
pubmed_data$Abstract <- as.character(pubmed_data$Abstract)
pubmed_data$Abstract <- gsub(",", " ", pubmed_data$Abstract, fixed = TRUE)
pubmed_data = pubmed_data[!duplicated(pubmed_data ), ]

# Get the pubmed IDS
pubMedIDs <- unique(pubmed_data$PMID)
length(pubMedIDs)

# List the titles
pubmed_data$Title

