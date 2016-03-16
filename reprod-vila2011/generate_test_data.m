grid_size = [30, 30];
rho_values = linspace(0.05, 0.95, grid_size(1));
delta_values = linspace(0.05, 0.95, grid_size(2));
reps = 100;

L = 1;
k = -8;

f = bsxfun(@(a,b) L./(1+ exp(-k*(a-b))), rho_values', linspace(.3, ...
                                                  .7,grid_size(1)));
successes_EMBGAMP = round(f*reps);
f = bsxfun(@(a,b) L./(1+ exp(-k*(a-b))), rho_values', linspace(.7, ...
                                                  .3,grid_size(1)));
successes_EMGMAMP = round(f*reps);
f = bsxfun(@(a,b) L./(1+ exp(-k*(a-b))), rho_values', linspace(.5, ...
                                                  .5,grid_size(1)));
successes_genGMAMP = round(f*reps);

save vila_results successes* rho_values delta_values reps
