#libraries
t <- data.frame(human_uniprotID=c("P01308","P01317"),
                bovine_uniprotID=c("P01317","P01317"))
rio::export(t,"BeefTestData.csv")


if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

install.packages("pacman")
pacman::p_load("rio","Rcpi","seqinr","protr")

# library( Rcpi ) 
 library(rio)
# library(seqinr)
# library(protr)

install_formats()


#the function
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
                                    type = "local",
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

df <- read.csv("BeefTestData.csv")

df[[1]][1]
df[[1]][2]
#uniprot id

prot1 <- df[[1]][1]
prot2 <- df[[1]][2]

beef(prot1,prot2)
