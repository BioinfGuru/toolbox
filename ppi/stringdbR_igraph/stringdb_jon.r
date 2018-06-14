69 #
70 # string_db <- STRINGdb$new(version = “10”, species = 10090, score_threshold = 0, input_directory = “”)
71 #
72 # myMap3 <- string_db$map( Scnzt3, “name”, removeUnmappedRows = T )
73 # myGraph3 <- string_db$get_interactions(myMap3$STRING_id)
74 # myGraph3 <- myGraph3[myGraph3$combined_score >= 400,]
75 # #myGraph3[myGraph3 == 0] <- NA
76 # G3tr_Names <-myGraph3[,c(1:2)]
77 # G3tr_Vals <- myGraph3[,c(3:16)]
78 # # first, transform data frme by stuff / 1000 to make decimals
79 # G3tr_Vals <- G3tr_Vals * 1/1000
80 # myGraph3 <- cbind(G3tr_Names,G3tr_Vals)
81 #
82 # write.table(myGraph3, “graph3.txt”, sep = “\t”, col.names = T, row.names = F, quote = F)