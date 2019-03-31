library(tidyverse)

game_data <- read_csv("derived_data/game_data_full.csv")


game_data_2 <- game_data %>% 
  mutate(team1_score = `score.x`,
         team1_num_ot = `num_ot.x`,
         team1_fgm = `fgm.x`,
         team1_fga = `fga.x`,
         team1_fgm3 = `fgm3.x`,
         team1_fga3 = `fga3.x`,
         team1_ftm = `ftm.x`,
         team1_fta = `fta.x`,
         team1_or = `or.x`,
         team1_dr = `dr.x`,
         team1_ast = `ast.x`,
         team1_to = `to.x`,
         team1_stl = `stl.x`,
         team1_blk = `blk.x`,
         team1_pf = `pf.x`,
         team1_won_previous_game = `won_previous_game.x`,
         team2_score = `score.y`,
         team2_num_ot = `num_ot.y`,
         team2_fgm = `fgm.y`,
         team2_fga = `fga.y`,
         team2_fgm3 = `fgm3.y`,
         team2_fga3 = `fga3.y`,
         team2_ftm = `ftm.y`,
         team2_fta = `fta.y`,
         team2_or = `or.y`,
         team2_dr = `dr.y`,
         team2_ast = `ast.y`,
         team2_to = `to.y`,
         team2_stl = `stl.y`,
         team2_blk = `blk.y`,
         team2_pf = `pf.y`,
         team2_won_previous_game = `won_previous_game.y`) %>% 
  select(team1_win, team1_id, team2_id, team1_game_order, team2_game_order, team1_score, team1_num_ot, team1_fgm, team1_fga, team1_fgm3, team1_fga3, team1_ftm, team1_fta, team1_or, team1_dr, team1_ast, team1_to, team1_stl, team1_blk, team1_pf, team1_won_previous_game, team2_score, team2_num_ot, team2_fgm, team2_fga, team2_fgm3, team2_fga3, team2_ftm, team2_fta, team2_or, team2_dr, team2_ast, team2_to, team2_stl, team2_blk, team2_pf, team2_won_previous_game)

game_data_3 <- game_data_2 %>% 
  mutate(diff_game_order = team1_game_order - team2_game_order,
         diff_score = team1_score - team2_score,
         diff_num_ot = team1_num_ot - team2_num_ot,
         diff_fgm = team1_fgm - team2_fgm,
         diff_fga = team1_fga - team2_fga,
         diff_fgm3 = team1_fgm3 - team2_fgm3,
         diff_fga3 = team1_fga3 - team2_fga3,
         diff_ftm = team1_ftm - team2_ftm,
         diff_fta = team1_fta - team2_fta,
         diff_or = team1_or - team2_or,
         diff_dr = team1_dr - team2_dr,
         diff_ast = team1_ast - team2_ast,
         diff_to = team1_to - team2_to,
         diff_stl = team1_stl - team2_stl,
         diff_blk = team1_blk - team2_blk,
         diff_pf = team1_pf - team2_pf,
         diff_won_previous_game = team1_won_previous_game - team2_won_previous_game) %>% 
  select(team1_win, team1_id, team2_id, diff_game_order, diff_score, diff_num_ot, diff_fgm, diff_fga, diff_fgm3, diff_fga3, diff_ftm, diff_fta, diff_or, diff_dr, diff_ast, diff_to, diff_stl, diff_blk, diff_pf, diff_won_previous_game)
  

write_csv(game_data_3, "derived_data/game_data_ml.csv")


