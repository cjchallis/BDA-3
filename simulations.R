P = 4
theta = rnorm(P, 0, 1)
tau = 1
delta = 0.1
G = 100

results = players = NULL
for (k in 1:G){
  in_game = sample(1:P, 2)
  i = in_game[1]
  j = in_game[2]
  logit_i = 1 / (1 + exp(tau*(theta[j] - theta[i])) )
  draw = delta * exp(tau * - abs(theta[j] - theta[i]))
  p = c(
    (1-draw) * logit_i,
    (1-draw) * (1-logit_i),
    draw
  )
  result = rmultinom(1, 1, p)
  results = rbind(results, t(result))
  players = rbind(players, in_game)
}

