library(tidyverse)

tournament_data <- read_csv("C:/Users/Owner/Desktop/Isaac School/CS 450/Project/cs450_project/data/NCAATourneyDetailedResults.csv")
season_data <- read_csv("C:/Users/Owner/Desktop/Isaac School/CS 450/Project/cs450_project/data/RegularSeasonDetailedResults.csv")

unique(season_data$WTeamID)
unique(tournament_data$WTeamID)

full_data <- bind_rows(season_data, tournament_data)

full_data1 <- full_data %>% 
  select(Season, DayNum, WTeamID, WScore, WLoc, NumOT, WFGM, WFGA, WFGM3, WFGA3, WFTM, WFTA, WOR, WDR, WAst, WTO, WStl, WBlk, WPF)

full_data2 <- full_data %>% 
  select(Season, DayNum, LTeamID, LScore, WLoc, NumOT, LFGM, LFGA, LFGM3, LFGA3, LFTM, LFTA, LOR, LDR, LAst, LTO, LStl, LBlk, LPF)

full_data1 <- full_data1 %>% 
  mutate(TeamID = WTeamID, Score = WScore, Loc = WLoc, FGM = WFGM, FGA = WFGA, FGM3 = WFGM3, FGA3 = WFGA3, FTM = WFTM, FTA = WFTA, OR = WOR, DR = WDR, Ast = WAst, TO = WTO, Stl = WStl, Blk = WBlk, PF = WPF) %>% 
  select(-WTeamID, -WScore, -WLoc, -WFGM, -WFGA, -WFGM3, -WFGA3, -WFTM, -WFTA, -WOR, -WDR, -WAst, -WTO, -WStl, -WBlk, -WPF)

full_data2 <- full_data2 %>% 
  mutate(TeamID = LTeamID, Score = LScore, Loc = WLoc, FGM = LFGM, FGA = LFGA, FGM3 = LFGM3, FGA3 = LFGA3, FTM = LFTM, FTA = LFTA, OR = LOR, DR = LDR, Ast = LAst, TO = LTO, Stl = LStl, Blk = LBlk, PF = LPF) %>% 
  select(-LTeamID, -LScore, -WLoc, -LFGM, -LFGA, -LFGM3, -LFGA3, -LFTM, -LFTA, -LOR, -LDR, -LAst, -LTO, -LStl, -LBlk, -LPF)

new_data <- bind_rows(full_data1, full_data2)

new_data1 <- new_data %>% 
  group_by(TeamID) %>% 
  arrange(Season, DayNum, .by_group = TRUE) %>% 
  mutate(team_game_order = row_number()) %>% 
  ungroup()

new_data2 <- new_data1 %>% 
  mutate(key = str_c(Season, DayNum, TeamID)) %>% 
  select(key, team_game_order)



