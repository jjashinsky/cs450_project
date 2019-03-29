# data preperation 


set.seed(23)

library(tidyverse)

tournament_data <- read_csv("data/NCAATourneyDetailedResults.csv")
season_data <- read_csv("data/RegularSeasonDetailedResults.csv")

full_data <- bind_rows(season_data, tournament_data) %>%
  mutate(key = str_c(Season, DayNum, WTeamID))

full_data1 <- full_data %>% 
  select(key, Season, DayNum, WTeamID, WScore, WLoc, NumOT, WFGM, WFGA, WFGM3, WFGA3, WFTM, WFTA, WOR, WDR, WAst, WTO, WStl, WBlk, WPF)

full_data2 <- full_data %>% 
  select(key, Season, DayNum, LTeamID, LScore, WLoc, NumOT, LFGM, LFGA, LFGM3, LFGA3, LFTM, LFTA, LOR, LDR, LAst, LTO, LStl, LBlk, LPF)

full_data1 <- full_data1 %>% 
  mutate(status = "win", TeamID = WTeamID, Score = WScore, Loc = WLoc, FGM = WFGM, FGA = WFGA, FGM3 = WFGM3, FGA3 = WFGA3, FTM = WFTM, FTA = WFTA, OR = WOR, DR = WDR, Ast = WAst, TO = WTO, Stl = WStl, Blk = WBlk, PF = WPF) %>% 
  select(-WTeamID, -WScore, -WLoc, -WFGM, -WFGA, -WFGM3, -WFGA3, -WFTM, -WFTA, -WOR, -WDR, -WAst, -WTO, -WStl, -WBlk, -WPF)

full_data2 <- full_data2 %>% 
  mutate(status = "lose", TeamID = LTeamID, Score = LScore, Loc = WLoc, FGM = LFGM, FGA = LFGA, FGM3 = LFGM3, FGA3 = LFGA3, FTM = LFTM, FTA = LFTA, OR = LOR, DR = LDR, Ast = LAst, TO = LTO, Stl = LStl, Blk = LBlk, PF = LPF) %>% 
  select(-LTeamID, -LScore, -WLoc, -LFGM, -LFGA, -LFGM3, -LFGA3, -LFTM, -LFTA, -LOR, -LDR, -LAst, -LTO, -LStl, -LBlk, -LPF)

new_data <- bind_rows(full_data1, full_data2)

new_data1 <- new_data %>% 
  group_by(TeamID) %>% 
  arrange(Season, DayNum, .by_group = TRUE) %>% 
  mutate(team_game_order = row_number()) %>% 
  ungroup()

new_data2 <- new_data1 %>% 
  select(key, team_game_order, status)



# group by season and teamID 
# order by daynum
# take last 3-5 games to find momentum
# average overall for all games in season (avg points, )
# join in conferences using TeamConferences.csv 


data_with_ordering <- full_data %>%
  left_join(new_data2, by = "key")

data <- data_with_ordering %>%
  spread(key = status, value = team_game_order)


rows <- 1:nrow(data)
sub_rows <- sample(rows, trunc(length(rows) * 0.5))


# get subset1
sub1 <- data[sub_rows, ] %>%
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
         "team2_pf" = "LPF",
         "team1_game_order" = "win",
         "team2_game_order" = "lose") %>%
  mutate(team2_num_ot = team1_num_ot, team1_win = 1)

# get subset2
  
sub2 <- data[-sub_rows,] %>%
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
         "team2_pf" = "WPF",
         "team1_game_order" = "lose",
         "team2_game_order" = "win") %>%
  mutate(team2_num_ot = team1_num_ot, team1_win = 0)

data_combined <- rbind(sub1, sub2)


game_data <- data_combined %>%
  select(team1_id, team2_id, team1_win, key, team1_game_order, team2_game_order)


