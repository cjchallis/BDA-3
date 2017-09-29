data{
  int<lower=0> P;
  int<lower=0> G;
  int results[G, 3];
  int players[G, 2];
}
parameters{
  real theta[P];
  real<lower=0, upper=1> delta;
  real<lower=0> tau;
  real<lower=0> sigma;
}
model{
  int i;
  int j;
  real logit_i;
  real draw;
  vector[3] p;
  delta ~ beta(1,10);
  sigma ~ gamma(0.5, 1);
  tau ~ gamma(1, 1);
  for (player in 1:P)
    theta[player] ~ normal(0,1);
  for (g in 1:G){
    i = players[g, 1];
    j = players[g, 2];
    logit_i = 1 / (1 + exp(tau*(theta[j] - theta[i])) );
    draw = 2*delta / (1 + exp(sigma * (theta[j] - theta[i])^2));
    p[1] = (1-draw) * logit_i;
    p[2] = (1-draw) * (1-logit_i);
    p[3] = draw;
    results[g,] ~ multinomial(p);  
  }
}
generated quantities{
  real theta_tau[P];
  for (p in 1:P){
    theta_tau[p] = theta[p] * tau;
  }
}
