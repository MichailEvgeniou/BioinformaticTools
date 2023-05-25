install.packages("pacman")
pacman::p_load(tidyverse,
               dplyr,
               data.table,
               igraph,
               RcppAlgos,
               bayesbio,
               furrr,
               data.table,
               purrr,
               WGCNA,
               DESeq2,
               GEOquery,
               CorLevelPlot,
               gridExtra,
               usethis,
               gitcreds)

# 0. Background establishments ---------------------------------------------------------------
#
no_cores <- availableCores() - 1
plan(multicore, workers = no_cores)

#data
source("C:/Users/MIchail Evgeniou/Desktop/PhD/R_Projects/BioinfoNShit/0.data.R")
#Functions
source("C:/Users/MIchail Evgeniou/Desktop/PhD/R_Projects/BioinfoNShit/DC_parJacSim.R")
source("C:/Users/MIchail Evgeniou/Desktop/PhD/R_Projects/BioinfoNShit/DC_SimScoreClustering.R")
source("C:/Users/MIchail Evgeniou/Desktop/PhD/R_Projects/BioinfoNShit/DC_ConnectClinicalDataToClusters.R")
source("C:/Users/MIchail Evgeniou/Desktop/PhD/R_Projects/BioinfoNShit/DC_TranslateDrugToProximity.R")