function [alt] = vfm_altitude();
%VFM_ALTITUDE   Returns the VFM altitudes
%   [alt] = VFM_ALTITUDE() returns the altitudes of the VFM flags in
%   typical L2 VFM files (with 545 vertical levels). For simplification,
%   it is assumed that levels are separated by 180m, 60m and 30m. The
%   true values (L1) are actually not exactly those. 
%
%   History: 
%      2021-mar-20 Converted Ind2Alt(ind) in a stand-along function
%
%      2005-mar-28 Original code by Ralph Kuehn shared on CALIPO's
%                  website, from 2005/03/28.
%
alt = ones(545, 1);
for i=1:545
  if i < 56,
    alt(i) = 30.1 - (i)*180/1000;
  elseif i < 256,
    alt(i) = 20.2 - (i-55)*60/1000;
  else
    alt(i) = 8.2 - (i-255)*30/1000;
  end
end
%