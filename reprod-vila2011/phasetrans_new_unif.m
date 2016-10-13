% This script performs simulation of reconstruction of sparse
% vectors using three different variants of GAMP over the usual
% sparsity/undersampling phase space.

newEM = true % set true to use new version of EMGMAMP
disableDamp = true % set true to disable adaptive damping

DISPLAY_OUTPUT = false;
DEMO = 1;
switch DEMO
  case 1 % full phase plane
    grid_size = [30, 30];
    delta_values = linspace(0.05, 0.95, grid_size(2));
    rho_values = linspace(0.05, 0.95, grid_size(1));
    reps = 100;
  case 2 % test difficult spot at (delta=0.3,rho=0.5)
    grid_size = [1,1];
    delta_values = 0.3;
    rho_values = 0.5;
    reps = 100;
end

% correct EMGMAMP path if needed
EMGMpath = fileparts(which('EMGMAMP')); % current path to EMGM
[GAMPdir,EMGMver] = fileparts(EMGMpath); % GAMPmatlab dir and EMGM version
if newEM
  if strcmp(EMGMver,'EMGMAMP')
    rmpath(EMGMpath)
    addpath([GAMPdir,'/EMGMAMPnew'])
  end
else 
  if strcmp(EMGMver,'EMGMAMPnew')
    rmpath(EMGMpath)
    addpath([GAMPdir,'/EMGMAMP'])
  end
end

% disable adaptive damping if needed
if disableDamp
  optGAMP.adaptStep = false;
end

% optionally improve some defaults
if 1
  if newEM
    optGAMP.nit = 500; % use more iterations
    optGAMP.uniformVariance = true; % speeds things up
  else 
    optGAMP.uniformVariance = true; % speeds things up
  end
end


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
            xhat_EMBGAMP = EMBGAMP(y, Amat, optEM, optGAMP);

            %set options for genie BGAMP
            optEM.lambda = K/N; % THIS READ K/M !!
            optEM.active_mean = 0;
            optEM.active_var = 1;
            optEM.noise_var = eps; % SET >0 TO AVOID ANNOYING WARNING
            optEM.learn_lambda = false;
            optEM.learn_mean = false;
            optEM.learn_var = false;
            optEM.learn_noisevar = false;

            %Perform genie BGAMP
            xhat_genBGAMP = EMBGAMP(y, Amat, optEM, optGAMP);

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

%if DEMO==1
  save vila2011_results_new_unif successes* rho_values delta_values reps
%end

% display results
if DISPLAY_OUTPUT
  if max(grid_size)>1

    % imagesc plot of success
    figure(1); clf;
    imagesc(rho_values,delta_values,(1/reps)*successes_EMBGAMP); colorbar
    set(gca,'YDir','normal')
    set(gca,'YTick',rho_values)
    if grid_size(2)<10, set(gca,'XTick',delta_values); end
    ylabel('rho')
    xlabel('delta')
    title('EMBGAMP')
    grid on

    % imagesc plot of success
    figure(2); clf;
    imagesc(rho_values,delta_values,(1/reps)*successes_genBGAMP); colorbar
    set(gca,'YDir','normal')
    set(gca,'YTick',rho_values)
    if grid_size(2)<10, set(gca,'XTick',delta_values); end
    ylabel('rho')
    xlabel('delta')
    title('genBGAMP')
    grid on

  else

    % print success rate
    EMBGAMP_success_rate = successes_EMBGAMP/rep
    successes_genBGAMP = successes_genBGAMP/rep

  end
end

% plot phase transition curve
if min(grid_size)>1
  figure(3); clf;
  regression_plot('vila2011_results_new_unif', ...
                  'Simulated phase transition (new alg., unif. option true)');
end
