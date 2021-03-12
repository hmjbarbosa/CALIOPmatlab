clear all
close all

% point to the file to be read
filen='samples/CAL_LID_L2_VFM-ValStage1-V3-30.2013-05-06T17-20-01ZD_Subset.hdf';
disp(['Reading from file: ', filen])

% use HDF to read the VFM 
data=hdfread(filen,'Feature_Classification_Flags');
disp(['Size of dataset: '])
size(data)

% plot one first feature
[vfmdata, vfmtype] = vfm_plot(data,[1 223],'type');

% other features
%[vfmdata, vfmtype] = vfm_plot(data,[1 223],'typeqa');
%[vfmdata, vfmtype] = vfm_plot(data,[1 223],'phase');
%[vfmdata, vfmtype] = vfm_plot(data,[1 223],'phaseqa');
%[vfmdata, vfmtype] = vfm_plot(data,[1 223],'aerosol');
%[vfmdata, vfmtype] = vfm_plot(data,[1 223],'cloud');
%[vfmdata, vfmtype] = vfm_plot(data,[1 223],'psc');
%[vfmdata, vfmtype] = vfm_plot(data,[1 223],'subtype');
%[vfmdata, vfmtype] = vfm_plot(data,[1 223],'subtypeqa');
%[vfmdata, vfmtype] = vfm_plot(data,[1 223],'averaging');


