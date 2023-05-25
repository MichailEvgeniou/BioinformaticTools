DC_parJacSim_elevated <- function(data,repetition){
  # 0. Background establishments ---------------------------------------------------------------
  #
  no_cores <- availableCores() - 1
  plan(multicore, workers = no_cores)
  
  #fix data column names
  data <- data
  colnames(data) <- c("Drug.Name","gene")
  data <- data.table(data)
  #create all the posible pairs of drugs
  pairs <- RcppAlgos::comboGrid(data$Drug.Name,data$Drug.Name,repetition = repetition) %>% 
    data.table()
  
  #create a score based on the common drug targets for each pair 1 same drug targets 0 not same
  pairs$jaccard <- as.data.table(unlist(future_map2(.x = pairs$Var1,.y = pairs$Var2,.f = function(drug1, drug2) {
    data[, jaccardSets(data[Drug.Name == drug1, gene], data[Drug.Name == drug2, gene])]
  })))
  #create a ration between the size of the drugs gene close to 1 means that the drugs has commo number of Drug targets
  pairs$size_ratio <- as.data.table(unlist(future_map2(.x = pairs$Var1,.y = pairs$Var2,.f = function(drug1, drug2) {
    data[, length(data[Drug.Name == drug1, gene])/ length(data[Drug.Name == drug2, gene])]
  })))
  #multiply the ratio with the jaccard score (the more similar the sample sizes the more stable will be the jaccard score e.g two drugs with the same amount of genes
  #will have ration of 1 multipling with the jaccard will give the same juaccard score)
  #then extract the value from the jaccard score if the result is close to zero that means the drugs has similar amount of genes 
  normJaccard <- pairs$jaccard-(pairs$jaccard*pairs$size_ratio)
  #if the jaccard scroe is 0 we dont care to normalize 
  pairs$normJac <- ifelse(pairs$jaccard==0,0, 1 - abs(normJaccard) / max(abs(normJaccard)))
  
  #pairs$normJac2 <- length(intersect(data[Drug.Name == drug1, gene], data[Drug.Name == drug2, gene])) / (length(data[Drug.Name == drug1, gene]) + length(data[Drug.Name == drug2, gene]) - length(intersect(data[Drug.Name == drug1, gene], data[Drug.Name == drug2, gene])))
  
  #pairs$normJac2 <- ifelse(pairs$jaccard==0,0, 1 / abs(0-normJaccard))
  
  
  return(pairs)
}
