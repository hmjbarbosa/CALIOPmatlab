function [fig, ax, cb, th] = vfm_plot(vfm,x,y,imgSize)
%

% Determine or set image size
if (exist('imgSize'))
  if length(imgSize) ~= 2,
    MSG = num2str(length(imgSize));
    error('imgSize is not a usable size. Must be of length 2, it is %s',MSG);
  end
else
  imgSize = [1300 667];
end

dpi=96;
axpos = [0.062 0.121 0.837 0.788];

% Create Figure & set size
fig = figure(); clf;
ax = axes('Parent', fig);

fpos = get(fig,'Position');
set(fig,...
    'Position'     ,[fpos(1), fpos(2),imgSize(1),imgSize(2)],... % units in pixels!
    'PaperUnits'   , 'inches',...
    'PaperPosition',[0 0 imgSize(1)/dpi imgSize(2)/dpi],...
    'Color'        ,'w');

% Matlab try to autoselect OpenGL, Zbuffer or Painters
% If you want the PNG file exactly as shown on screen, you'll need to use
% myaa() and use the same renderer for the fig and the save command.

%set(fig, 'Renderer', 'OpenGL')
%set(fig, 'Renderer', 'Zbuffer')
%set(fig, 'Renderer', 'painters')

p = pcolor(x,y,double(vfm.Data));
set(p,'edgecolor','none');

set(ax,'ylim',[-2. 30.])

% Title and legend
title(vfm.FieldDescription);
xlabel('Latitude (deg)')
ylabel('Altitude (km)')

set(ax,...
    'Position'    , axpos        , ...
    'FontName'    , 'Verdana'    , ...
    'FontSize'    , 14           , ...
    'FontWeight'  , 'bold'       , ...
    'Box'         , 'off'        , ...
    'TickDir'     , 'out'        , ...
    'TickLength'  , [.010 .010]  , ...
    'XMinorTick'  , 'off'        , ...
    'YMinorTick'  , 'off'        , ...
    'XGrid'       , 'off'        , ...
    'YGrid'       , 'off'        , ...
    'XColor'      , [.03 .03 .03], ...
    'YColor'      , [.03 .03 .03], ...
    'LineWidth'   , 1.0          );

set(get(ax,'title'),...
    'FontName'  , 'Verdana', ...
    'FontSize'  , 18       , ...
    'FontWeight', 'bold'   );

set([get(ax,'xlabel'), get(ax,'ylabel')],...
    'FontName', 'Verdana',...
    'FontSize', 14       , ...
    'FontWeight', 'bold' );


%set(ax,'Position',[0.062 0.121 0.837 0.788]);
%pos=get(ax,'position');
    
[tx, ty] = AddMinorTicks(fig, ax, 4, [.03 .03 .03], -0.006);
annotation('line', [axpos(1), axpos(1)+axpos(3)], [axpos(2)+axpos(4), axpos(2)+axpos(4)], ...
           'color', [.03 .03 .03]);
annotation('line', [axpos(1)+axpos(3), axpos(1)+axpos(3)], [axpos(2), axpos(2)+axpos(4)], ...
           'color', [.03 .03 .03]);
    
[r,g,b]=CreateColorMap(vfm.FieldDescription);
colormap([r,g,b]);
% We should set the y-axis limits of the colorbar. Because we are
% plotting integer numbers, and we want them centered with the colors in
% the colorbar, the range has to be +-0.5 wider than the actual range
caxis([vfm.Vmin-0.5, vfm.Vmax+0.5]);     %Set color axis limits
cb = colorbar;      %Put on colorbar
%set(cb, 'ylim', [vfm.Vmin-0.5, vfm.Vmax+0.5])
tlen = get(cb,'ticklength');
if (numel(tlen)>1)
  % old versions
  set(cb,'ticklength', [0 0], 'fontsize', 14, 'fontweight', 'bold')
else
  % new versions of Matlab 
  set(cb,'ticklength', 0, 'fontsize', 14, 'fontweight', 'bold')
end
set(cb,'Position',[0.919 0.121 0.021 0.788])
cby = get(cb,'yticklabel');
set(cb,'yticklabel',num2str(cby,'%02d'))

% Create bottom capton for flag's values
typelabel = '';
for i = 1:length(vfm.ByteTxt)
  typelabel = [typelabel sprintf('%d - %s,     ',vfm.Vmin+i-1,vfm.ByteTxt{i})];
end

th = annotation('textbox',[0.062 0.0 0.837 0.04],'string',typelabel);
set(th,...
    'Linestyle','none',...
    'FontSize',14,...
    'Fontname','Verdana',...
    'FontWeight','Bold',...
    'HorizontalAlignment','Center',...
    'VerticalAlignment','Middle');

% Display warning messages when image is larger than figure window (in pixels)
% this is to let you know that you're trying to display more information than what
% is there and that small/thin feature may be missing. If you use the zoom tool that
% data will be visible.
Isize = get(fig,'Position');
if  (Isize(3) < size(vfm.Data,2)) && (Isize(4) < size(vfm.Data,1)),
  disp('Warning: Image is bigger than the current figure widow'); 
  disp('         not all pixels may be visible'); 
elseif  (Isize(3) < size(vfm.Data,2)),
  disp('Warning: Image is wider than the current figure widow'); 
  disp('         not all pixels may be visible'); 
elseif Isize(4) < size(vfm.Data,1),
  disp('Warning: Image is taller than the current figure widow'); 
  disp('         not all pixels may be visible'); 
end

%aafig = myaa();
%set(aafig,'PaperUnits','inches','PaperPosition',[0 0 imgSize(1)/dpi imgSize(2)/dpi])
%%print(aafig,'-painters','-dpng',['-r' num2str(dpi)],'teste.png')
%print(aafig,'-opengl','-dpng',['-r' num2str(dpi)],'teste.png')
%close(aafig)


