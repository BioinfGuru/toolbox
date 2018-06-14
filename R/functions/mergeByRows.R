#' @name mergeByRows
#' @title Merge two data frames
#' @description 
#' Uses base function merge() to left join 2 data frames by row name 
#' while preserving row names
#' @param x data frame 1 (left side)
#' @param y data frame 2 (right side)
#' @return 
#' Returns all rows from x, and all columns from x and y. 
#' Rows in x with no match in y are given NA values
#' @examples 
#' x <- data.frame(a = c(1,2,3), b = c(4,5,6), c = c(7,8,9))
#' rownames(x) <- c('planes', 'boats', 'cars')
#' x
#' y <- data.frame(d = c(10,11,12), e = c(13,14,15), f = c(16,17,18))
#' rownames(y) <- c('planes', 'boats', 'cars')
#' y
#' z <- mergeByRows(x,y)
#' z
#' @export

mergeByRows <- function(x, y){
    z<- merge(x, y, by = "row.names", all = TRUE)
    z$Row.names <- as.character(z$Row.names)
    row.names(z) <- z$Row.names
    z <- z[,c(2:ncol(z))]
}