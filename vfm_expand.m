function [vfm_block] = vfm_expand(vfm_rows)
%VFM_EXPAND   Unpacks a VFM
%   [vfm_block] = VFM_ROWS2BLOCK(vfm_rows) unpacks all vfm_rows creating a
%   vfm_block. A vfm_rows array has a size of ntimes x 5515, and the resulting
%   vfm_block will have a size of nzlev (545) x total_times (ntimes x 15). 
%
%   Low altitude data (< 8km) is returned as in the input data: 15 profiles
%   with 30m vertical by 333m horizontal, corresponding to 290x15 = 4350
%   values.  Higher altitude data is over-sampled in horizontal
%   dimension.
%
%   For 8-20km, returned data has 200x15 = 3000 rather than 200x5 = 1000.
%   For 20-30km, returned data has 55x15 = 825, rather than 55x3 = 165.
%
%   Type of vfm_block is the same as vfm_rows, hence this function could be
%   colled on the bit-compressed or the bit-uncompressed VFM data.
%
%   This function is 5-10 times faster than the original vfm_row2block.m
%   shared on the Calipso website (written by Ralph Kuehn in 2005). 
%  
%   History 
%      2021-mar-09 Optimized version 
%
%      2021-mar-07 First version, looking at Calipso Data user's guide
%      and Kuehn's function. 
%
%

% Check dimensions, it should be: ntimes x 5515
if (ndims(vfm_rows) ~= 2)
  error('Input data should have 2 dimensions.')
end

[ntimes, rowlen] = size(vfm_rows);

if (rowlen ~= 5515)
  if (ntimes == 5515)
    % Try to transpose
    disp('Consider transposing input data.')
    vfm_rows = vfm_rows';
    [ntimes, rowlen] = size(vfm_rows);
  else
    % Something wrong
    error('Could not find a dimension with length 5515.')
  end
end

% Allocate memory for speed
vfm_block = zeros(290+200+55, 15, ntimes, class(vfm_rows));

% Create the blocks
for i=1:ntimes
  line = vfm_rows(i,:);
  bk1 = reshape(line(1:165),55,3);
  bk2 = reshape(line(166:1165),200,5);
  bk3 = reshape(line(1166:end),290,15);
  
  % the 15 compressed profiles vary (in time) faster than ntimes
  for j=1:15
    vfm_block(1:55, j, i) = bk1(:,floor((j-1)/5)+1);
    vfm_block(56:255, j, i) = bk2(:,floor((j-1)/3)+1);
    vfm_block(256:end, j, i) = bk3(:,j);
  end
end

% Last 2 dimensions are "times", so let's make just one
vfm_block = reshape(vfm_block, 545, 15*ntimes);

%