#!/usr/bin/env Rscript
# for ranking a dataframe

# clear environment
rm(list = ls())

# function
range01 <- function(x){(x-min(x))/(max(x)-min(x))}

# create data
tau <- c(0,0.2,0.4,0.6,0.8,0.85,0.9,0.95,1,
         0,0.2,0.4,0.6,0.8,0.85,0.9,0.95,1,
         0,0.2,0.4,0.6,0.8,0.85,0.9,0.95,1,
         0,0.2,0.4,0.6,0.8,0.85,0.9,0.95,1,
         0,0.2,0.4,0.6,0.8,0.85,0.9,0.95,1,
         0,0.2,0.4,0.6,0.8,0.85,0.9,0.95,1,
         0,0.2,0.4,0.6,0.8,0.85,0.9,0.95,1,
         0,0.2,0.4,0.6,0.8,0.85,0.9,0.95,1,
         0,0.2,0.4,0.6,0.8,0.85,0.9,0.95,1)
qnExp <- c(10,10,10,10,10,10,10,10,10,
           9.5,9.5,9.5,9.5,9.5,9.5,9.5,9.5,9.5,
           9,9,9,9,9,9,9,9,9,
           8.5,8.5,8.5,8.5,8.5,8.5,8.5,8.5,8.5,
           8,8,8,8,8,8,8,8,8,
           6,6,6,6,6,6,6,6,6,
           4,4,4,4,4,4,4,4,4,
           2,2,2,2,2,2,2,2,2,
           0,0,0,0,0,0,0,0,0)
data <- data.frame(tau,qnExp)

# add cols
data$qnExpRanged <- range01(data$qnExp)
data$sum <- data$tau + data$qnExpRanged
#data$product <- data$tau*data$qnExpRanged
#data$pyth <- sqrt((data$tau^2)+(data$qnExpRanged^2))

# prep for sort
data$sum <- as.numeric(as.character(data$sum))
data$tau <- as.numeric(as.character(data$tau))

# sort
data <- data[order(-data$sum, -data$tau), ]
#data <- data[order(-data$product), ]
#data <- data[order(-data$pyth), ]

# scatter plot all
plot(data$tau, data$qnExp)

# remove all rows below 0.85 tau
data <- subset(data, tau>=0.85)

# scatter plot top
top <- head(data, n = 3)
plot(top$tau, top$qnExp)
top <- head(data, n = 4)
plot(top$tau, top$qnExp)
top <- head(data, n = 5)
plot(top$tau, top$qnExp)
top <- head(data, n = 6)
plot(top$tau, top$qnExp)
top <- head(data, n = 7)
plot(top$tau, top$qnExp)
top <- head(data, n = 8)
plot(top$tau, top$qnExp)
top <- head(data, n = 9)
plot(top$tau, top$qnExp)
top <- head(data, n = 10)
plot(top$tau, top$qnExp)
top <- head(data, n = 11)
plot(top$tau, top$qnExp)
top <- head(data, n = 12)
plot(top$tau, top$qnExp)
top <- head(data, n = 13)
plot(top$tau, top$qnExp)
top <- head(data, n = 14)
plot(top$tau, top$qnExp)
top <- head(data, n = 15)
plot(top$tau, top$qnExp)
top <- head(data, n = 16)
plot(top$tau, top$qnExp)
top <- head(data, n = 17)
plot(top$tau, top$qnExp)
top <- head(data, n = 18)
plot(top$tau, top$qnExp)
top <- head(data, n = 19)
plot(top$tau, top$qnExp)
top <- head(data, n = 20)
plot(top$tau, top$qnExp)
top <- head(data, n = 21)
plot(top$tau, top$qnExp)
top <- head(data, n = 22)
plot(top$tau, top$qnExp)
top <- head(data, n = 23)
plot(top$tau, top$qnExp)
top <- head(data, n = 24)
plot(top$tau, top$qnExp)
top <- head(data, n = 25)
plot(top$tau, top$qnExp)
