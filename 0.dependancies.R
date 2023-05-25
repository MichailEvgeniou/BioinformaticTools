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


