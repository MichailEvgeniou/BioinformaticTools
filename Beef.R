# BACK ---------------------------------------------------------------

## packages----
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

#install.packages("pacman")
pacman::p_load("furrr","Rcpi","seqinr","protr")
#library(protr)
## paralel computing----


no_cores <- availableCores() - 1 #number of free cores
plan(multicore, workers = no_cores)


# ## dammy data----
# t <- data.frame(human_uniprotID=c("P01308","P01317","O44750","Q78EG7","O44750"),
#                 bovine_uniprotID=c("P01317","P01317","P79307","P01317","P79307"))
# rio::export(t,"BeefTestData.csv")

## function----

beef <- function(prot1,prot2){
  #download fasta from unirpot
  prot1 <- prot1
  prot2 <- prot2
  fasta1 <- Rcpi::getFASTAFromUniProt(prot1) 
  fasta2 <- Rcpi::getFASTAFromUniProt(prot2) 
  
  #create fasta files
  write(fasta1,"prot.fasta1")
  write(fasta2,"prot.fasta2")
  
  #retrieve the sequences
  protSeq1 <- seqinr::read.fasta(file = "prot.fasta1",seqtype = "AA",as.string = TRUE)
  protSeq1[[1]][1]
  protSeq2 <- seqinr::read.fasta(file = "prot.fasta2",seqtype = "AA",as.string = TRUE)
  protSeq2[[1]][1]
  
  #do the similarity check
  protAlingment <- protr::twoSeqSim(protSeq1[[1]][1],
                                    protSeq2[[1]][1],
                                    type = "global",
                                    submat = "BLOSUM62")
  
  #keep only the score 
  result <- data.frame(human_prot=prot1,
                       bovine_prot=prot2,
                       score=score(protAlingment))
  #summary(r)
  
  #delete the fasta files
  do.call(file.remove, list("prot.fasta1","prot.fasta2"))
  return(result)
}

##warning
##!!!! MIND THE NUMBER OF CORES IN USE, DEFAULT PARAMETERS WILL USE 
##!!!! ALL BUT ONE OF YOUR CORES. IF YOU WANT TO CHANGE IT CHEKC THE NUMBER ON LINE 15 

warning("MIND THE NUMBER OF CORES IN USE, DEFAULT PARAMETERS WILL USE ALL BUT ONE OF YOUR CORES. IF YOU WANT TO CHANGE IT CHECK THE NUMBER ON LINE 15 ")


# FRONT -------------------------------------------------------------------

## load the data----
data <- read.csv("BeefTestData.csv")

## result----
SimPairDf <- furrr::future_map2_dfr(data[[1]],
                                    data[[2]],
                                    beef)
beef("P01308","P01308")
