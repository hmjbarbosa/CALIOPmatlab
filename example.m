clear all
close all

% point to the file to be read
filen='samples/CAL_LID_L2_VFM-ValStage1-V3-30.2013-05-06T17-20-01ZD_Subset.hdf';
disp(['Reading from file: ', filen])

% read the VFM 
data=hdfread(filen,'Feature_Classification_Flags');
disp(['Size of dataset: '])
[cnt, cline]=size(data)

% convert VFM rows into blocks
vfmblock = vfm_expand(data);
disp('Size of VFM block:')
[nz, nt] = size(vfmblock)

% extract the first feature flag (Feature Type)
vfmflag = vfm_type(vfmblock, 'type');

% read latitude
% Not all data files have the ssLatitude variable
% This is the latitude at the level 1 data (i.e. 333m)
% If we don't have that, we have to interpolate
try
  lat=double(hdfread(filen,'ssLatitude')); 
catch
  % Not sure if this is correct. Need to check "where" the Latitute of a L2
  % product is placed relative to the L1 positions.
  tmp=double(hdfread(filen,'Latitude'));
  lat=interp1(15*((1:cnt)-0.5), tmp, (1:nt)-0.5);
end
%lat=1:3345;

% read altitude
hinfo=hdfinfo(filen);
hmeta=hdfread(filen,'metadata');
for i=1:length(hinfo.Vdata.Fields)
  if strcmp(hinfo.Vdata.Fields(i).Name, 'Lidar_Data_Altitudes')
    alt=double(hmeta{i});
  end
end
alt = alt(alt>-0.5 & alt<30);

% plot the flag
vfm_plot(vfmflag, lat, alt);

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

