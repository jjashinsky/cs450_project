# data preperation 


set.seed(23)

library(tidyverse)

tourney <- read_csv("data/NCAATourneyDetailedResults.csv")
regular <- read_csv("data/RegularSeasonDetailedResults.csv")

# group by season and teamID 
# order by daynum
# take last 3-5 games to find momentum
# average overall for all games in season (avg points, )
# join in conferences using TeamConferences.csv 


rows <- 1:nrow(regular)
sub_rows <- sample(rows, trunc(length(rows) * 0.5))


# get subset1
sub1 <- regular[sub_rows, ] %>%
  rename("team1_id" = "WTeamID",
         "team1_score" = "WScore",
         "team2_id" = "LTeamID",
         "team2_score" = "LScore",
         "team1_loc" = "WLoc",
         "team1_num_ot" = "NumOT", 
         "team1_fgm" = "WFGM",
         "team1_fga" = "WFGA",
         "team1_fgm3" = "WFGM3",   
         "team1_fga3" = "WFGA3",
         "team1_ftm" = "WFTM",
         "team1_fta" = "WFTA",
         "team1_or" = "WOR",
         "team1_dr" = "WDR",
         "team1_ast" = "WAst",
         "team1_to" = "WTO",
         "team1_stl" = "WStl",
         "team1_blk" = "WBlk",
         "team1_pf" = "WPF",
         "team2_fgm" = "LFGM",
         "team2_fga" = "LFGA",
         "team2_fgm3" = "LFGM3",
         "team2_fga3" = "LFGA3",
         "team2_ftm" = "LFTM",
         "team2_fta" = "LFTA",
         "team2_or" = "LOR",
         "team2_dr" = "LDR",
         "team2_ast" = "LAst",   
         "team2_to" = "LTO",
         "team2_stl" = "LStl",
         "team2_blk" = "LBlk",
         "team2_pf" = "LPF") %>%
  mutate(team2_num_ot = team1_num_ot, team1_win = 1)

# get subset2
  
sub2 <- regular[-sub_rows,] %>%
  rename("team1_id" = "LTeamID",
         "team1_score" = "LScore",
         "team2_id" = "WTeamID",
         "team2_score" = "WScore",
         "team1_num_ot" = "NumOT",
         "team1_fgm" = "LFGM",
         "team1_fga" = "LFGA",
         "team1_fgm3" = "LFGM3",
         "team1_fga3" = "LFGA3",
         "team1_ftm" = "LFTM",
         "team1_fta" = "LFTA",
         "team1_or" = "LOR",
         "team1_dr" = "LDR",
         "team1_ast" = "LAst",   
         "team1_to" = "LTO",
         "team1_stl" = "LStl",
         "team1_blk" = "LBlk",
         "team1_pf" = "LPF",
         "team1_loc" = "WLoc",
         "team2_fgm" = "WFGM",
         "team2_fga" = "WFGA",
         "team2_fgm3" = "WFGM3",   
         "team2_fga3" = "WFGA3",
         "team2_ftm" = "WFTM",
         "team2_fta" = "WFTA",
         "team2_or" = "WOR",
         "team2_dr" = "WDR",
         "team2_ast" = "WAst",
         "team2_to" = "WTO",
         "team2_stl" = "WStl",
         "team2_blk" = "WBlk",
         "team2_pf" = "WPF",) %>%
  mutate(team2_num_ot = team1_num_ot, team1_win = 0)

full <- rbind(sub1, sub2)



