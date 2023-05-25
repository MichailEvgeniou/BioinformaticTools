DC_parJacSim <- function(data,repetition){
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
  
  return(pairs)
}
