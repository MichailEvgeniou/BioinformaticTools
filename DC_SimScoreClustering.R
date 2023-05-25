DC_SimScoreClustering <- function(data,FilteredDrugPairsByScore){
  #fix data column names
  data <- data
  colnames(data) <- c("Drug.Name","gene")
  
  #keep only the entries with certain score
  FilteredDrugPairsByScore <- FilteredDrugPairsByScore %>% dplyr::filter(jaccard==1)
  #trasnform them to a graph
  g <- graph_from_data_frame(FilteredDrugPairsByScore)
  #identify the subnetoworks
  g <- decompose.graph(g)
  # create a named list of subnetworks
  g <- setNames(g, paste0("subnet",   1:length(g))) #the name of the list is the index of the inner list
  # convert to dataframe
  subnet_df <- data.frame(
    subnetwork = seq_along(g),
    elements = map_chr(.x = g,.f = function(x){toString(igraph::as_ids(V(x)))})
  )
  #column 1 includes the cluster index and column 2 the drugs 
  subnet_df <- separate_rows(subnet_df,elements,sep = ",")
  subnet_df$elements <- str_trim(subnet_df$elements,side = "both")
  colnames(data)[[1]]
  FilteredDrugPairsByScore <- full_join(data,subnet_df,by=c("Drug.Name"="elements"))
  
  # replace NA values with sequence starting from 1000
  ClusterDrugDictionery <- FilteredDrugPairsByScore %>%
    dplyr::mutate(subnetwork = ifelse(is.na(subnetwork), seq(1000, length.out = sum(is.na(subnetwork))), subnetwork)) %>% 
    dplyr::group_by(Drug.Name) %>% 
    dplyr::mutate(subnetwork=sum(subnetwork)) %>% 
    dplyr::filter(!(is.na(gene))) %>% 
    ungroup
  return(ClusterDrugDictionery)
}



