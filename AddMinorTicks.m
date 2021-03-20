function [hx, hy] = AddMinorTicks(fig, ax, n, cor, len)
%ADDMINORTICKS   Adds minor ticks to an axis for old Matlab versions
%   AddMinorTicks(fig, ax) adds minor ticks in-between major ticks into
%   the axis (ax) and the figure (fig) passed by the user. 
%
%   AddMinorTicks(fig, ax, n, cor, len) allows controlling the number of
%   minor ticks (default 1), the color (default 'k') and length (default
%   '0.007'). Positive lengths (negative) mean TickDir is in (out). 
%
%   [hx, hy] = AddMinorTicks(fig, ax, ... ) returns the lists to the handles
%   of the minor ticks in the x and y axis respectivelly (they are draw as
%   lines). They could be used, for instance, to change the color or other
%   properties.
%
if (nargin<5)
  len=0.007;
end
if (nargin<4)
  cor = 'k'
end
if (nargin<3)
  n = 1
end

% position in figure units
pos = get(ax, 'position');
% axis limits
xl = get(ax, 'xlim');
yl = get(ax, 'ylim');

% convert from axis units to figure units
posx = @(x) pos(1) + (x-xl(1))*pos(3)/(xl(2)-xl(1));
posy = @(y) pos(2) + (y-yl(1))*pos(4)/(yl(2)-yl(1));

% major ticks position in axis units
xt = get(ax, 'xtick');
yt = get(ax, 'ytick');

% minor ticks separation
dx = (xt(2)-xt(1))/(n+1.);
dy = (yt(2)-yt(1))/(n+1.);

% find all possible tick positions
% and remove major ticks
minxt = setdiff([flip(xt(1):-dx:xl(1))  xt(1):dx:xl(2)],xt);
minyt = setdiff([flip(yt(1):-dy:yl(1))  yt(1):dy:yl(2)],yt);

% minor tick size 
fpos = get(fig, 'position');

% tick length is normalized to longest visible axis
if (fpos(3) > fpos(4))
  tlx = len*fpos(3)*pos(4)/fpos(4);
  tly = len*fpos(3)*pos(3)/fpos(3);
else
  tlx = len*fpos(3)*pos(4)/fpos(3);
  tly = len*fpos(4)*pos(3)/fpos(3);
end

tmp = posx(minxt);
for j=1:length(tmp)
  hx(j) = annotation('line', [tmp(j) tmp(j)], [pos(2), pos(2)+tlx], 'color',cor);
end

tmp = posy(minyt);
for j=1:length(tmp)
  hy(j) = annotation('line', [pos(1), pos(1)+tly], [tmp(j) tmp(j)], 'color',cor);
end


