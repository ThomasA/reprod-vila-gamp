load vila2011_results

transition_rho_values_EMBGAMP = zeros(size(delta_values));
transition_rho_values_genBGAMP = zeros(size(delta_values));
for idx = 1:max(size(delta_values))
    params = glmfit(rho_values, [successes_EMBGAMP(:, idx) reps* ...
                        ones(max(size(rho_values)),1)], 'binomial');
    transition_rho_values_EMBGAMP(idx) = params(1)/-params(2);
    params = glmfit(rho_values, [successes_genBGAMP(:, idx) reps* ...
                        ones(max(size(rho_values)),1)], 'binomial');
    transition_rho_values_genBGAMP(idx) = params(1)/-params(2);
end

plot(delta_values, transition_rho_values_EMBGAMP)
hold on
plot(delta_values, transition_rho_values_genBGAMP)
xlabel('\delta')
ylabel('\rho')
legend('EMBGAMP', 'genie-BGAMP')
axis([0 1 0 1])
title('Simulated phase transitions')
