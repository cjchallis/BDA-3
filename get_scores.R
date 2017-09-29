library(dplyr)
library(tidyr)
library(lubridate)

key = "1yXm8ZAHxl7vtDQp1-hoVgr169j3rz4vLQ-y4fCegPnk"
#key = "1mpzOzK3IwFsgWAo5o4nyktiZEZc7DDOQZ29fd4-UG5U"
baseurl = "https://spreadsheets.google.com/feeds/download/spreadsheets/"
download.file(sprintf("%sExport?key=%s&exportFormat=csv", baseurl, key), "scores.csv")

df = read.csv("scores.csv", stringsAsFactors=FALSE)
df %>% gather(Player, Score, Score1, Score2, Score3, Score4)

tidy = NULL

for (i in 1:4){
  player = paste("Player", i, sep = "")
  score = paste("Score", i, sep = "")
  segment = df[c("Date", "GameID", player, score)]
  names(segment) = c("Date", "GameID", "Player", "Score")
  tidy = rbind(segment, tidy)
}

tidy = tidy %>% filter(Player != "")


all_pairs = merge(tidy, tidy, by = c("GameID", "Date"))
all_pairs = all_pairs %>% 
  filter(Player.x < Player.y) %>%
  mutate(Date = date(Date), Actual.x = (Score.x > Score.y) + (Score.x == Score.y) / 2)

players = unique(c(all_pairs$Player.x, all_pairs$Player.y))
players = c(players, "Nobody")
N = length(players)

translate = 1:N
names(translate) = players

outcomes = all_pairs %>%
  mutate(result = 2 * (Score.x == Score.y) + (Score.x < Score.y) + 1) %>%
  select(result)

outcomes = as.numeric(unlist(outcomes))

results = matrix(0, length(outcomes), 3)

for (i in 1:nrow(results)){
  results[i, outcomes[i]] = 1
}

players = cbind(translate[all_pairs$Player.x], translate[all_pairs$Player.y])
G = nrow(results)
P = length(translate)
