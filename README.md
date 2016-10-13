# reprod-vila-gamp
This repository contains Matlab code for the reproduction of certain results from the following paper by Jeremy Vila and Philip Schniter:

  1. J. P. Vila and P. Schniter, "[Expectation-Maximization Bernoulli-Gaussian Approximate Message Passing](http://www2.ece.ohio-state.edu/~schniter/pdf/asil11_em.pdf)," Proc. Asilomar Conf. on Signals, Systems, and Computers (Pacific Grove, CA), Nov. 2011.

Specifically, the code seeks to reproduce Figure 1 from this paper.

## Dependencies

In order to run this code, you must have the [gampmatlab](http://gampmatlab.wikia.com/wiki/Generalized_Approximate_Message_Passing) toolbox for Matlab available (as well as Matlab). Matlab must be set up to be able to find the following folders from this toolbox: `trunk/code/main/`, `trunk/code/EMGMAMP`, `trunk/code/EMGMAMPnew/`.

The results stored in this repository were produced using revision 562 of the 'gampmatlab' toolbox from the (Subversion) repository **svn://svn.code.sf.net/p/gampmatlab/code**.

## Variants

The folder `reprod-vila2011` contains the main files of the project. Files are provided for a total of four combinations of two features of the algorithms: There is an 'old' and a 'new' version of the EMGMAMP algorithm in the 'gampmatlab' toolbox, `trunk/code/EMGMAMP` and `trunk/code/EMGMAMPnew/` respectively. Furthermore, the algorithms have been run with and without the `uniformVariance` option. These four combinations have been configured in these four files in the folder `reprod-vila2011`:
- phasetrans_new_not_unif.m
- phasetrans_new_unif.m
- phasetrans_old_not_unif.m
- phasetrans_old_unif.m

These four files each contain the main algorithm and the simulation framework set up around it to estimate its reconstruction capability phase transition through Monte Carlo simulations over the undersampling/sparsity parameter plane. The file 'regression_plot.m' is a helper file for generating plots of the simulation results. Running any of the above scripts will automatically call 'regression_plot.m' to plot and store figures and append the estimated phase transition curves to the result .MAT files.

## Generating main results

For convenience, the script 'run_main.m' in the root folder can be called to automatically run the main simulations from this repository (i.e. 'phasetrans_old_unif.m') in `reprod-vila2011` and copy the results to the root folder.
