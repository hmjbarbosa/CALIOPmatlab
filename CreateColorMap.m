function [red, grn, blu] = CreateColorMap(ColorMap, NumColors)
%CREATECOLORMAP   Creates a colormap 
%   [red,grn,blu] = CREATECOLORMAP(ColorMap) takes a ColorMap name (string)
%   and returns float arrays of red, green and blue colors (0-1) that
%   compose the map. ColorMap can be one of the following:
%
%      'Feature Type'
%      'Feature Type QA'
%      'Ice/Water Phase'
%      'Ice/Water Phase QA'
%      'Aerosol Sub-Type'
%      'Cloud Sub-Type'
%      'PSC Sub-Type'
%      'Sub-Type'
%      'Sub-Type QA'
%      'Averaging Required for Detection'
%
%   These correspond to ClassText.FieldDescription returned by
%   vfm_type(), and have a fixed number of colors to match exactly the
%   colors used on the CALIPSO website to show these feature flags.
%
%   [red,grn,blu] = CREATECOLORMAP(ColorMap, NumColors) works the same
%   way, but allows one to choose the number of colors. In this case,
%   only generic linear colormaps are available, which are named:
%  
%      'Rainbow' or 'default'
%      'BlackWhite'
%      'BlackGold'
%
%   History: 
%      2021-mar-09 Added names for all colormaps associated with standard
%                  feature flags. NumColors is now the 2nd parameter, and 
%                  only used for linear colormaps. Colors now match those
%                  used on the CALIPSO website.
%      
%      2005-mar-28 Original code by Ralph Kuehn shared on CALIPO's
%                  website, from 2005/03/28.
%
if strcmp(ColorMap,'Feature Type')
  red = [255   0   0 255 250   0 192   0]'/255;
  grn = [255  38 220 160 255 255 192   0]'/255; 
  blu = [255 255 255   0   0 110 192   0]'/255; 
  return;
end
if strcmp(ColorMap,'Feature Type QA')
  red = [ 230 0 230 255    0 255]'/255;
  grn = [ 230 0   0  255 200   0]'/255;
  blu = [ 230 0   0   0    0 255]'/255; 
  return;
end
if strcmp(ColorMap,'Ice/Water Phase')
  red = [ 192 255  255   0 169]'/255;
  grn = [ 255   0  255   0 169]'/255;
  blu = [ 168   0  255 255 169]'/255; 
  return;
end
if strcmp(ColorMap,'Ice/Water Phase QA')
  red = [ 192 255  255   0 169]'/255;
  grn = [ 255   0  255   0 169]'/255;
  blu = [ 168   0  255 255 169]'/255; 
  return;
end
if strcmp(ColorMap,'Aerosol Sub-Type')
  red = [ 198   0 250 255   0 174 0 255]'/255;
  grn = [ 198   0 255   0 128  87 0   0]'/255; 
  blu = [ 198 255   0   0   0   0 0 255]'/255; 
  return
end
if strcmp(ColorMap,'Cloud Sub-Type')
  red = [  0   0   0 144 255 255 192 255 255]'/255;
  grn = [  0   0 255 255 255 159 192 255   0]'/255; 
  blu = [  0 144 255 111   0   0 192 255 255]'/255; 
  return
end
if strcmp(ColorMap,'PSC Sub-Type')
  red = [255   0   0 144 255 255 192 255 255]'/255;
  grn = [  0   0 255 255 255 159 192 255   0]'/255; 
  blu = [  0 144 255 111   0   0 192 255 255]'/255; 
  return;
end
if strcmp(ColorMap,'Sub-Type')
  red = [255   0   0 144 255 255 192 255 255]'/255;
  grn = [  0   0 255 255 255 159 192 255   0]'/255; 
  blu = [  0 144 255 111   0   0 192 255 255]'/255; 
  return;
end
if strcmp(ColorMap,'Sub-Type QA')
  red = [ 0 180 255]'/255;
  grn = [ 0 180 255]'/255;
  blu = [ 0 180 255]'/255; 
  return;   
end
if strcmp(ColorMap,'Averaging Required for Detection')
  red = [ 202 244   0 255   0   0]'/255;
  grn = [ 202 104 255 255 125   0]'/255; 
  blu = [ 255  12   0   0  63 128]'/255; 
  return;
end

if nargin == 1
  disp('Received only 1 argument, but 2 are required for linear colormaps.')
  red = [ nan ]
  grn = [ nan ]
  blu = [ nan ]
  return
end

if (strcmp(ColorMap,'Rainbow') | strcmp(ColorMap,'default'))
  fprintf('Using Rainbow colormap\n');
  start_hsv(1) = 300;
  final_hsv(1) = 15;
  start_hsv(2) = 1000;
  final_hsv(2) = 1000;
  start_hsv(3) = 1000;
  final_hsv(3) = 1000;
elseif strcmp(ColorMap,'BlackWhite')
  fprintf('Using Black and White colormap\n');
  start_hsv(1) = 0;
  final_hsv(1) = 0;
  start_hsv(2) = 0;
  final_hsv(2) = 0;
  start_hsv(3) = 1000;
  final_hsv(3) = 0;
elseif strcmp(ColorMap,'BlackGold')
  fprintf('Using Black and Gold colormap\n');
  start_hsv(1) = 59;
  final_hsv(1) = 39;
  start_hsv(2) = 1000;
  final_hsv(2) = 730;
  start_hsv(3) = 0;
  final_hsv(3) = 1000;
else  
  disp(['Unknown ColorMap. Check input', ColorMap]);
  return 
end

Dhue = (final_hsv(1) - start_hsv(1))/NumColors;
Dsat = (final_hsv(2) - start_hsv(2))/NumColors;
Dval = (final_hsv(3) - start_hsv(3))/NumColors;

hue = start_hsv(1);
sat = start_hsv(2);
val = start_hsv(3);

if (strcmp(ColorMap,'Rainbow') | strcmp(ColorMap,'default')),
  R = zeros(NumColors,1);
  G = zeros(NumColors,1);
  B = zeros(NumColors,1);
  bluStep = 4;
  grnStep = 3.2;
  i = 1;
  while (hue >= final_hsv(1)),
	[R(i),G(i),B(i)]=HSVtoRGB(round(hue),round(sat),round(val));
	% ColorValue(i)=red*65536+grn*256+blu;
    if (hue <= 254) && (hue >= 222),
      hue = hue + Dhue*bluStep;
    elseif (hue <= 140) && (hue >= 85),
      hue = hue + Dhue*grnStep;
    else
      hue = hue + Dhue;
    end
    i = i + 1;
  end
  % Copy color info to new array of correct size 
  red = ones(i,1).*R(1:i);
  grn = ones(i,1).*G(1:i);
  blu = ones(i,1).*B(1:i);

else
  red = zeros(NumColors,1);
  grn = zeros(NumColors,1);
  blu = zeros(NumColors,1);
  for i=1:NumColors,
	[red(i),grn(i),blu(i)]=HSVtoRGB(round(hue),round(sat),round(val));
	% ColorValue(i)=red*65536+grn*256+blu;
    hue = hue + Dhue;
    sat = sat + Dsat;
    val = val + Dval;
    if (hue < 0.0), hue = hue + 360; end
	if (hue > 360.0), hue = hue - 360; end
	% Should use a better convention below because
	% there would be a discontinuity in the colormap
	% if we jump from ~0 to ~1000.
	if (sat < 0.0), sat = sat + 1000; end
	if (sat > 1000) sat = sat - 1000; end
	if (val < 0.0) val = val + 1000; end
	if (val > 1000.0) val = val + 1000; end
  end
end

red(1) = 0;
grn(1) = 0;
blu(1) = 0;

red(i) = 1; 
grn(i) = 1;
blu(i) = 1;


function [r,g,b] = HSVtoRGB( h, s, v)
  % int i, f;
  % int p, q, t;
  % s = (s * 0xff) / 1000;
  % v = (v * 0xff) / 1000;
  ff = 255;
  s = (s * ff) / 1000;
  v = (v * ff) / 1000;
  if (h == 360), h = 0; end
  if (s == 0),  h = 0; r = v; g = v; b = v; end
  i = floor(h / 60);
  f = mod(h,60);
  % p = v * (0xff - s) / 0xff;
  % q = v * (0xff - s * f / 60) / 0xff;
  % t = v * (0xff - s * (60 - f) / 60) / 0xff;
  p = v * (ff - s) / ff;
  q = v * (ff - s * f / 60) / ff;
  t = v * (ff - s * (60 - f) / 60) / ff;
    if i == 0,
      r = v; g = t; b = p; 
    elseif i == 1,
      r = q; g = v; b = p; 
    elseif i == 2,
      r = p; g = v; b = t; 
    elseif i == 3, 
      r = p; g = q; b = v;
    elseif i == 4,
      r = t; g = p; b = v;
    elseif i == 5, 
      r = v; g = p; b = q;
    else,
      r = ff; g = ff; b = ff;
  end
  r = r/ff;
  g = g/ff;
  b = b/ff;
