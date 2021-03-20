clear all
close all

% point to the file to be read
filen='samples/CAL_LID_L2_VFM-ValStage1-V3-30.2013-05-06T17-20-01ZD_Subset.hdf';
disp(['Reading from file: ', filen])

% use HDF to read the VFM 
data=hdfread(filen,'Feature_Classification_Flags');
disp(['Size of dataset: '])
size(data)

%alta = Ind2Alt(1:545)

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

%function [alt] = Ind2Alt(ind);
%sz = length(ind);
%for i=1:sz,
%  if ind(i) < 56,
%    alt(i) = 30.1 - (i)*180/1000;
%  elseif ind(i) < 256,
%    alt(i) = 20.2 - (i-55)*60/1000;
%  else
%    alt(i) = 8.2 - (i-255)*30/1000;
%  end
%end

