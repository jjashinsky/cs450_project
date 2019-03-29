# data preperation 

library(tidyverse)

tourney <- read_csv("data/NCAATourneyDetailedResults.csv")
regular <- read_csv("data/RegularSeasonDetailedResults.csv")

# group by seaso nand day num in asscending order 
