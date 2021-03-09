function [red,grn,blu]=CreateColorMap(NumColors,ColorMap)
% Function CreateColorMap
% Input: number of colors, and colormap: 'Rainbow','BlackWhite','BlackGold','Aerosol Sub-Type','Cloud Sub-Type'
% Output: r,g,b colorvalues
% Default colormap is rainbow
% Note: Some of this is copied from various sources (the conversion routines) and has been hacked
% on mercilessly...but it works the way I want it to.
% -----------------------------------------------------------------------------
% $Log: CreateColorMap.m,v $
% Revision 1.2  2005/03/28 19:13:39  kuehn
% Updated to better plot feature qa flags.  A value of (1) was added to all feature qa flags as long as the feature is not clear air, surface, subsurface, or no signal. Invalid features ARE included.
%
% Revision 1.1  2005/03/24 21:10:45  kuehn
% First submission under new directory
%
% -----------------------------------------------------------------------------

%	int i;
%        int red,grn,blu;
%        float hue,sat,val;
%        float Dhue,Dsat,Dval;
  c1 = [0 220 220];
  c2 = [144 255 111];
  c3 = [255 159 0];

  if nargin == 1,
    ColorMap = 'default';
  end
     if (NumColors == 8),
         if strcmp(ColorMap,'Aerosol Sub-Type') | strcmp(ColorMap,'Aerosol Sub-Type (Truth)'), 
	   red = [  0   0 255 144 255   0 192 255 255]'/255;
	   grn = [  0   0 159 255 255 255 192 255   0]'/255; 
	   blu = [  0 144   0 111   0 255 192 255 255]'/255; 
         elseif strcmp(ColorMap,'Cloud Sub-Type') | strcmp(ColorMap,'Cloud Sub-Type (Truth)'),
	   red = [  0   0   0 144 255 255 192 255 255]'/255;
	   grn = [  0   0 255 255 255 159 192 255   0]'/255; 
	   blu = [  0 144 255 111   0   0 192 255 255]'/255; 
         elseif strcmp(ColorMap,'diff_type'),
	   red = [  0 102  51  51 140 250 255 255]'/255;
	   grn = [  0 255   0 204 140 250 153   0]'/255; 
	   blu = [  0 255 153 153 140   0   0   0]'/255; 
         else
	   red = [255   0   0 144 255 255 192 255 255]'/255;
	   grn = [  0   0 255 255 255 159 192 255   0]'/255; 
	   blu = [  0 144 255 111   0   0 192 255 255]'/255; 
         end
       return;
    elseif (NumColors == 9),
       if strcmp(ColorMap,'Cloud Sub-Type') | strcmp(ColorMap,'Cloud Sub-Type (Truth)'),
	   red = [  0   0   0 144 255 255 192 255 255 255]'/255;
	   grn = [  0   0 255 255 255 159 192 255   0   0]'/255; 
	   blu = [  0 144 255 111   0   0 192 255 255   0]'/255; 
       else
	   red = [255   0   0 128 144 255 255 192 255 255]'/255;
	   grn = [  0   0 255   0 255 255 159 192 255   0]'/255; 
	   blu = [  0 144 255 128 111   0   0 192 255 255]'/255; 
       end
       return;
    elseif (NumColors == 6),
       red = [  0 221 255 153  33   0   0]'/255;
       grn = [  0 221 153   0   0 204 153]'/255; 
       blu = [  0 221 221 204 153 255   0]'/255; 
       return;
    elseif (NumColors == 5),
       red = [ 230 0 230 255    0 255]'/255;
       grn = [ 230 0   0  255 200   0]'/255;
       blu = [ 230 0   0   0    0 255]'/255; 
       return;
    elseif (NumColors == 4),
       red = [ 0 230 255    0 255]'/255;
       grn = [ 0   0  255 200 255]'/255;
       blu = [ 0   0   0    0 255]'/255; 
       return;
    elseif (NumColors == 3) & (ColorMap == 1),
       red = [c1(1) c2(1) c3(1)]'/255;
       grn = [c1(2) c2(2) c3(2)]'/255;
       blu = [c1(3) c2(3) c3(3)]'/255; 
       return;
    elseif (NumColors == 3) & (ColorMap == 2),
       red = [c2(1) c1(1) c3(1)]'/255;
       grn = [c2(2) c1(2) c3(2)]'/255;
       blu = [c2(3) c1(3) c3(3)]'/255; 
       return;
    elseif (NumColors == 3) & (ColorMap == 3),
       red = [c3(1) c1(1) c2(1)]'/255;
       grn = [c3(2) c1(2) c2(2)]'/255;
       blu = [c3(3) c1(3) c2(3)]'/255; 
       return;
    elseif (NumColors == 3),
       red = [ 0 255   0 200]'/255;
       grn = [ 0 255 180   0]'/255;
       blu = [ 0 255   0   0]'/255; 
       return;   
    elseif (NumColors == 2),
       red = [ 0 180 255]'/255;
       grn = [ 0 180 255]'/255;
       blu = [ 0 180 255]'/255; 
       return;   
   end 
  if (strcmp(ColorMap,'Rainbow') | strcmp(ColorMap,'default')),
    fprintf('Using Rainbow colormap\n');
    start_hsv(1) = 300;
    final_hsv(1) = 15;
    start_hsv(2) = 1000;
    final_hsv(2) = 1000;
    start_hsv(3) = 1000;
    final_hsv(3) = 1000;
  elseif strcmp(ColorMap,'BlackWhite'),
    fprintf('Using Black and White colormap\n');
    start_hsv(1) = 0;
    final_hsv(1) = 0;
    start_hsv(2) = 0;
    final_hsv(2) = 0;
    start_hsv(3) = 1000;
    final_hsv(3) = 0;
  elseif strcmp(ColorMap,'BlackGold'),
    fprintf('Using Black and Gold colormap\n');
    start_hsv(1) = 59;
    final_hsv(1) = 39;
    start_hsv(2) = 1000;
    final_hsv(2) = 730;
    start_hsv(3) = 0;
    final_hsv(3) = 1000;
  else  % Colormap  is Rainbow
    fprintf('Attention! Using default (Rainbow) colormap.\n');
    start_hsv(1) = 300;
    final_hsv(1) = 600;
    start_hsv(2) = 1000;
    final_hsv(2) = 1000;
    start_hsv(3) = 1000;
    final_hsv(3) = 1000;
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
