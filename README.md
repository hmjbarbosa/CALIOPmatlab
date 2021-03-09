# CALIOPmatlab

Matlab routines to open and plot CALIOP data, the lidar on board the
CALIPSO satellite from NASA (https://www-calipso.larc.nasa.gov/). The
focus is on the vertical feature mask (VFM) data, sometimes also
called Feature Classification Flag.

This projects builds upon the original Matlab code by Ralph Kuehn
(U. of Wisconsin-Madison,
https://espo.nasa.gov/gasex/person/Ralph_Kuehn) that can be accessed
at the CALIPSO website here (see section *Layout of the Feature
Classification Flag data block*):

https://www-calipso.larc.nasa.gov/resources/calipso_users_guide/data_summaries/vfm/

The exact link is:

https://www-calipso.larc.nasa.gov/resources/calipso_users_guide/tools/matlab/vfm_plot.zip

This hidden sample code is much more complete than the other samples here:

http://hdfeos.org/zoo/index_openLaRC_Examples.php#CALIPSO
http://hdfeos.org/zoo/LaRC_CALIPSO.php

## What's new

We have corrected the old code to run on newer versions of Matlab
(e.g. 2015), and also made it more generic, so it's easier to define
new variables (and accompaning color maps) to be plotted.

