CreateSymmetricalMatrix <- function(dataframe){#The input is a dataframe of paies
  vals<-sort(unique(c(as.character(dataframe$Var1), as.character(dataframe$Var2))))
  nm <- matrix(NA, nrow=length(vals), ncol=length(vals), dimnames=list(vals, vals))
  diag(nm) <- 1    
  
  #fill
  nm[as.matrix(dataframe[, 1:2])] <- dataframe[,3]
  #fill reversed
  nm[as.matrix(dataframe[, 2:1])] <- dataframe[,3]
  return(nm)
}
