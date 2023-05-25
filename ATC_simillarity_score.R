##ATC simillarity score
AtcSimScore <- function(AtcCode1,AtcCode2){
  result <- c()
  for (k in seq_along(AtcCode1)) {
    AtcCode <- c(AtcCode1[[k]],AtcCode2[[k]])
    AtcsToBeCompared <- list()
    
    for (j in 1:2) {
      FirstLevel <- str_sub(AtcCode[[j]],end = 1)
      tmp <- str_remove(AtcCode[[j]],FirstLevel)
      SecondLevel <- str_sub(tmp,end = 2)
      tmp <- str_remove(tmp,SecondLevel)
      ThirdLevel <- str_sub(tmp,end = 1)
      tmp <- str_remove(tmp,ThirdLevel)
      FourthLevel <- str_sub(tmp,end = 1)
      tmp <- str_remove(tmp,FourthLevel)
      tmp <- c(FirstLevel,SecondLevel,ThirdLevel,FourthLevel)
      AtcsToBeCompared[[j]] <- tmp
    }
    
    score=0
    
    for (i  in 1:4) {
      if (AtcsToBeCompared[[1]][[i]]==AtcsToBeCompared[[2]][[i]]) {
        score <- score+1
      }else{
        break
      }
    }
    
    result[k] <- c(score)
  }
  return(result)
}
