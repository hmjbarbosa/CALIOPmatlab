# CALIOPmatlab

Matlab routines to open and plot data from [CALIOP, the lidar on board the
CALIPSO satellite from NASA](https://www-calipso.larc.nasa.gov/). The
focus is on the vertical feature mask (VFM), sometimes 
called Feature Classification Flag (e.g. VFM files) or
Atmospheric Volume Description (e.g. aerosol files).

This projects builds upon the original Matlab code by [Ralph Kuehn
(U. of Wisconsin-Madison)](https://espo.nasa.gov/gasex/person/Ralph_Kuehn)
that can be accessed at the CALIPSO website (see section **Layout of the Feature
Classification Flag data block**):

https://www-calipso.larc.nasa.gov/resources/calipso_users_guide/data_summaries/vfm/

The exact link is:

https://www-calipso.larc.nasa.gov/resources/calipso_users_guide/tools/matlab/vfm_plot.zip

This hidden sample code is much more complete than the more readily available codes here:

* http://hdfeos.org/zoo/index_openLaRC_Examples.php#CALIPSO
* http://hdfeos.org/zoo/LaRC_CALIPSO.php

## What's new

* Corrected the old code to show the true values of the flags on the colorbar.
* Made the code  more generic, so it's easier to define new variables (and accompaning color maps) to be plotted.
* Modified the colormaps to match precisely those used at the CALIPSO website.

In the future, we'll use the aerosol colormaps from
[ccplot](https://ccplot.org/) and include the hability to plot the
aerosol fields as well.

## Usage

Just open Matlab on the directory with all files, and run example.m. It will use
the provided V3-30 VFM HDF file, which is for 2013-May-6 17:20, to produce a plot
of the Feature Type. This is the expected output:

https://go.nasa.gov/2N0Tagl

Also found on the samples folder. 

## VFM structure

To save space, the VFM uses a highly compacted representation of 7
different masks/flags (integer values) into a single 2-byte (16-bit)
integer. If you haven't done so yet, please read carefully the
documentation here:

https://www-calipso.larc.nasa.gov/resources/calipso_users_guide/data_summaries/vfm/

Here is a summary: 

bits 1-3 Feature Type 
* 0 = invalid (bad or missing data)
* 1 = "clear air"
* 2 = cloud
* 3 = aerosol
* 4 = stratospheric feature
* 5 = surface
* 6 = subsurface
* 7 = no signal (totally attenuated)

bits 4-5 Feature Type QA 
* 0 = none
* 1 = low
* 2 = medium
* 3 = high

6-7 Ice/Water Phase
* 0 = unknown / not determined
* 1 = randomly oriented ice
* 2 = water
* 3 = horizontally oriented ice

8-9 Ice/Water Phase QA 
* 0 = none
* 1 = low
* 2 = medium
* 3 = high

10-12 Feature Sub-type
* If feature type = aerosol, bits 10-12 will specify the aerosol type
* 0 = not determined
* 1 = clean marine
* 2 = dust
* 3 = polluted continental
* 4 = clean continental
* 5 = polluted dust
* 6 = smoke
* 7 = other

If feature type = cloud, bits 10-12 will specify the cloud type.
* 0 = low overcast, transparent
* 1 = low overcast, opaque
* 2 = transition stratocumulus
* 3 = low, broken cumulus
* 4 = altocumulus (transparent)
* 5 = altostratus (opaque)
* 6 = cirrus (transparent)
* 7 = deep convective (opaque)

If feature type = Polar Stratospheric Cloud, bits 10-12 will specify PSC classification.
* 0 = not determined
* 1 = non-depolarizing PSC
* 2 = depolarizing PSC
* 3 = non-depolarizing aerosol
* 4 = depolarizing aerosol
* 5 = spare
* 6 = spare
* 7 = other

13 Cloud / Aerosol /PSC Type QA 
* 0 = not confident
* 1 = confident

14-16 Horizontal averaging required for detection
* (provides a coarse measure of feature backscatter intensity)
* 0 = not applicable
* 1 = 1/3 km
* 2 = 1 km
* 3 = 5 km
* 4 = 20 km
* 5 = 80 km


