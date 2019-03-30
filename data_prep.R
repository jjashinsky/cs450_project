# data preperation 

# takes away the randomness when we split the data
set.seed(23)

library(tidyverse)

# load data
tournament_data <- read_csv("data/NCAATourneyDetailedResults.csv")
season_data <- read_csv("data/RegularSeasonDetailedResults.csv")

# make a key to join by later
full_data <- bind_rows(season_data, tournament_data) %>%
  mutate(key = str_c(Season, DayNum, WTeamID))

# get the winning teams
full_data1 <- full_data %>% 
  mutate(status = "win") %>%
  select(key, Season, DayNum, status, "TeamID" = "WTeamID") 

# get the losing teams
full_data2 <- full_data %>%
  mutate(status = "lose") %>%
  select(key, Season, DayNum, status, "TeamID" = "LTeamID")

# join them so that teams are only in one column
# then order their games
new_data <- bind_rows(full_data1, full_data2) %>%
  group_by(TeamID) %>% 
  arrange(Season, DayNum, .by_group = TRUE) %>% 
  mutate(team_game_order = row_number()) %>% 
  ungroup() %>%
  select(key, team_game_order, status)

# joining the ordering data back in
data_with_ordering <- full_data %>%
  left_join(new_data, by = "key")

# spread the data
data <- data_with_ordering %>%
  spread(key = status, value = team_game_order)

# sample half of the data rows
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

# join them back in. 
# half of the losing team is now team1
# half of the winning team is now team1
data_combined <- rbind(sub1, sub2)

# grab the actual game results and make a unique key
game_data <- data_combined %>%
  select(team1_id, team2_id, team1_win, team1_game_order, team2_game_order, key) %>%
  mutate(key_1 = paste0(team1_id, team1_game_order),
         key_2 = paste0(team2_id, team1_game_order))

# getting subset for team1
# increasing their game order by 1 and using it make a key to match game_data
game_data_copy1 <- data_combined %>% mutate(team_game_order_next = team1_game_order + 1,
                                            key = paste0(team1_id, team_game_order_next)) %>%
  select("id" =  "team1_id",
         "score" = "team1_score",
         "num_ot" = "team1_num_ot",
         "fgm" = "team1_fgm",
         "fga" = "team1_fga",
         "fgm3" = "team1_fgm3",
         "fga3" = "team1_fga3",
         "ftm" = "team1_ftm",
         "fta" = "team1_fta",
         "or" = "team1_or",
         "dr" = "team1_dr",
         "ast" = "team1_ast",   
         "to" = "team1_to",
         "stl" = "team1_stl",
         "blk" = "team1_blk",
         "pf" = "team1_pf",
         "won_previous_game" = "team1_win",
         "team_game_order" = "team1_game_order",
         key,
         team_game_order_next)

# same as above but for team2
game_data_copy2 <- data_combined %>% mutate(team_game_order_next = team2_game_order + 1,
                                            key = paste0(team2_id, team_game_order_next),
                                            won_previous_game = case_when(team1_win == 0 ~ 1,
                                                                team1_win == 1 ~ 0)) %>%
  select("id" =  "team2_id",
         "score" = "team2_score",
         "num_ot" = "team2_num_ot",
         "fgm" = "team2_fgm",
         "fga" = "team2_fga",
         "fgm3" = "team2_fgm3",
         "fga3" = "team2_fga3",
         "ftm" = "team2_ftm",
         "fta" = "team2_fta",
         "or" = "team2_or",
         "dr" = "team2_dr",
         "ast" = "team2_ast",   
         "to" = "team2_to",
         "stl" = "team2_stl",
         "blk" = "team2_blk",
         "pf" = "team2_pf",
         "team_game_order" = "team2_game_order",
         won_previous_game,
         key,
         team_game_order_next)

# bind them back together
game_data_rbind <- rbind(game_data_copy1, game_data_copy2)

#joining in the subsets
game_data_full <- game_data %>%
  left_join(game_data_rbind, by = c("key_1" = "key")) %>% # first get the team1 data
  left_join(game_data_rbind, by = c("key_2" = "key")) %>% # then get the team2 data
  filter(team1_game_order > 1, team2_game_order > 1) %>% # get rid of the games that wont have previous data
  na.omit() # still have some NAs (idk why?)

#write.csv(game_data_full, "derived_data/game_data_full.csv")
