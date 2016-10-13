% This script runs the simulations for and plots the main results, i.e. the
% 'old' version of the algorithm with the `uniformVariance` option set to
% `true`.

cd reprod-vila2011/
%phasetrans_old_unif
copyfile vila2011_results_old_unif.fig ../vila2011_main_results.fig
copyfile vila2011_results_old_unif.mat ../vila2011_main_results.mat
copyfile vila2011_results_old_unif.pdf ../vila2011_main_results.pdf
cd ..
