#!/usr/bin/env Rscript
# be careful when counting occurances of vector in a vector when the vector contains NAs!
# use sum() instead of length() where possible

vector <- c(0.000, 0.000, 0.000, 0.000, 0.415, 3.358)
x = 0


print(vector)
print(sum(vector==0,na.rm = TRUE))
print(sum(is.na(vector)))

# change 0 to NA
vector[vector == 0] <- NA

print(vector)
print(sum(vector==0,na.rm = TRUE))
print(sum(is.na(vector)))