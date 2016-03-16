% This script performs simulation of reconstruction of sparse
% vectors using three different variants of GAMP over the usual
% sparsity/undersampling phase space.

grid_size = [30, 30];
rho_values = linspace(0.05, 0.95, grid_size(1));
delta_values = linspace(0.05, 0.95, grid_size(2));
reps = 100;
N = 1000;

successes_EMBGAMP = zeros(grid_size);
successes_genBGAMP = zeros(grid_size);

% Initialise RNG for reproducibility
rng(42)

for delta_idx = 1:grid_size(2)
    for rho_idx = 1:grid_size(1)
        for rep = 1:reps
            % Set M and K the same way as in EMGMAMPdemo.m and EMBGAMPdemo.m
            M = ceil(delta_values(delta_idx) * N);
            K = floor(rho_values(rho_idx) * M);

            % Form A matrix
            Params = struct('M', M, 'N', N, 'type', 1, 'realmat', true);
            Amat = generate_Amat(Params);

            %Determine true bits
            support = false(N,1);
            support(1:K) = true; %which bits are on

            active_mean = 0;
            active_var = 1;
            %Compute true input vector
            x = (sqrt(active_var)*randn(N,1)+active_mean).* support;
            x = x(randperm(N));

            %Compute true noiseless measurement
            y = Amat*x;

            %set heavy_tailed option to false to operate on sparse signal
            optEM = struct('heavy_tailed', false);

            %Perform EMBGAMP
            xhat_EMBGAMP = EMBGAMP(y, Amat, optEM);

            %set options for genie BGAMP
            optEM.lambda = K/M;
            optEM.active_mean = 0;
            optEM.active_var = 1;
            optEM.noise_var = 0;
            optEM.learn_lambda = false;
            optEM.learn_mean = false;
            optEM.learn_var = false;
            optEM.learn_noisevar = false;

            %Perform genie BGAMP
            xhat_genBGAMP = EMBGAMP(y, Amat, optEM);

            %Evaluate success
            if norm(x-xhat_EMBGAMP)^2/norm(x)^2 < 1e-4
                successes_EMBGAMP(rho_idx, delta_idx) = ...
                    successes_EMBGAMP(rho_idx, delta_idx) + 1;
            end
            if norm(x-xhat_genBGAMP)^2/norm(x)^2 < 1e-4
                successes_genBGAMP(rho_idx, delta_idx) = ...
                    successes_genBGAMP(rho_idx, delta_idx) + 1;
            end
        end
        fprintf('Progress: (%d, %d)\n', delta_idx, rho_idx)
        %Stop evaluating this rho-column if reconstructions start
        %failing completely
        if successes_EMBGAMP(rho_idx, delta_idx) == 0 && ...
                successes_genBGAMP(rho_idx, delta_idx) == 0
            break;
        end
    end
end

save vila2011_results successes* rho_values delta_values reps
