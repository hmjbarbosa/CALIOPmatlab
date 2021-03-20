function [block,TypeText] = vfm_plot(vfm,x,y,imgSize)
% Description: Plots a vertical feature mask (vfm) within a specified set of horizontal limits and of a specified type. 
% Inputs: vfm - a 2d array (????x5515) of vfm data that has been imported using the hdftool
%        lims - a 1x2 array that specify the x limits of the plot in index units (e.g. [1 1000])
%        type - a string, choose ONE of the following:
%         'type','all','qa','phase','phaseqa','aerosol','cloud','psc','subtype','typeqa','averaging'
%        imgSize - the size in pixels of the image, good sizes are 1024x512 for saving, 
%                  or 1024x430 for side-by-side comparison in matlab 
%        noplot - if added will it will not produce a plot;
% Outputs: block - a 2d array of typed vfm data...the data that is to be plotted.
%       TypeText - a data structure that contains text information (a legend) about the vfm type returned
% Example: >> vfm_plot(vfm,[1 1000],'all');
% Will produce an image(plot) of vfm data from x indexes 1 to 1000 of the original vfm array of the feature
% type (i.e. invalid, clear air, cloud, aerosol, etc.)
%
% Uses vfm_type,vfm_row2block,CreateColorMap
% Return type is uint8
%className = 'uint8';
%offset = 1165;
%step = 290;
% For now only return low alt data
% This low altitude data is stored as 15 profiles 30m vertical by 333m horizontal
% This corresponds to an array 290x15 packed in a 1d-array 4350 elements long;

% Get typed array;

%block = ones(290,15,className)*10;
% Get the number of rows of the vfm data (In Matlab data is ROWxCOL)
sz = size(vfm,1);
% Convert the first row of data and convert to a block (block variable is automatically created)
%[block,TypeText] = vfm_row2block(vfm(lims(1),:),type);
% Convert the rest of the rows to block and append
%for i =lims(1)+1:lims(2),
%  block=cat(2,block,vfm_row2block(vfm(i,:),type));
%end

% Was 'noplot' option used?
%if (nargin == 5),
%    disp('Plotting is off');
%    if length(imgSize) ~= 2,
%	error('imgSize is not a usable size. Must be 1x2 it is %f',size(imgSize));
%    end
%else 
    % Determine or set image size
    if (exist('imgSize'))
        if length(imgSize) ~= 2,
            MSG = num2str(length(imgSize));
            error('imgSize is not a usable size. Must be of length 2, it is %s',MSG);
        end
    else
        imgSize = [1300 667];
    end

    % Create axis arrays (i.e. distances);
    %y = zeros(55+200+290,1);
    %x = zeros((lims(2)-lims(1))*15,1);
    %temp = [1:1:(lims(2)-lims(1)+1)*15]' - 1 ;
    %size(temp)

    %x = lims(1)*15*333/1000 + 333*temp/1000; % distance in km
    %ya = [1:1:545]';
    %y = Ind2Alt(ya);
    %disp('Altitudes(km)=')
    %disp(y)
    %figure(10); clf; hold on
    %plot(y,'ob')
    
    % Create Figure & set size
    TheFig=figure(newfigure());
    %TheFig=figure(1);
    temp = get(TheFig,'Position');
%    set(TheFig,'Position',[temp(1) temp(2) imgSize(1) imgSize(2)]);
    dpi=300;
%    set( groot, 'ScreenPixelsPerInch' , 96)
    set(gcf,'position',[temp(1), temp(2),imgSize(1),imgSize(2)]); % units in pixels!
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 imgSize(1)/dpi imgSize(2)/dpi])

    clf
    %opengl autoselect
    %set(gcf, 'Renderer', 'OpenGL')
    %set(gcf, 'Renderer', 'Zbuffer')
    set(gcf, 'Renderer', 'painters')

    set(gcf,'color','w');
    %block(:,1) = zeros(290,1);
    %block(:,2) = ones(290,1);
    % Display the image
    %image(x,ya,block);
    % can't use image because it doesnt like non-uniform X and Y
    % coordinates
    % image(x,y,block);
    class(vfm)
    size(x)
    size(y)
    size(vfm.Data)
    p = pcolor(x,y,double(vfm.Data));
    set(p,'edgecolor','none');
    disp('Size of image:')
    size(vfm.Data)
    % Title and legend
    title(vfm.FieldDescription);
    xlabel('Distance (km)')%,'FontSize',14,'FontWeight','bold')
    ylabel('Altitude (km)','FontSize',14,'FontWeight','bold')

    set(gca,...
        'FontName'    , 'Verdana'   , ...
        'FontSize'    , 14        , ...
        'FontWeight'  , 'bold'     , ...
        'Box'         , 'off'      , ...
        'TickDir'     , 'out'      , ...
        'TickLength'  , [.010 .010] , ...
        'XMinorTick'  , 'off'      , ...
        'YMinorTick'  , 'off'      , ...
        'XGrid'       , 'off'     , ...
        'YGrid'       , 'off'     , ...
        'XColor'      , [.03 .03 .03], ...
        'YColor'      , [.03 .03 .03], ...
        'LineWidth'   , 1.0         );

    set(get(gca,'title'),...
        'FontName'  , 'Verdana', ...
        'FontSize'  , 18          , ...
        'FontWeight', 'bold'      );

    set([get(gca,'xlabel'), get(gca,'ylabel')],       ...
        'FontName', 'Verdana', ...
        'FontSize', 14         , ...
        'FontWeight', 'bold'      );
    %disp(y')
    % Get the axis handle (NOTE: axes and axis are distinct and different!)
    IH = gca;
    % Reverse the direction of the y axis
    %set(IH,'YDir','reverse');
    set(IH,'YDir','normal');
    % Change the size of the image wrt the figure window
    % set(IH,'Position',[0.047 0.111 0.915 0.844]);
    set(IH,'Position',[0.062 0.121 0.837 0.788]);
    pos=get(IH,'position');
    %correctYLabel(gca,y); % Puts the correct labels on
    set(IH,'ylim',[-2. 30.])
    
    [tx, ty] = AddMinorTicks(gcf, gca, 4, 'k', -0.006);
    annotation('line', [pos(1), pos(1)+pos(3)], [pos(2)+pos(4), pos(2)+pos(4)], ...
               'color', [.03 .03 .03]);
    annotation('line', [pos(1)+pos(3), pos(1)+pos(3)], [pos(2), pos(2)+pos(4)], ...
               'color', [.03 .03 .03]);
    
    % we shouldn't rely on the length of this text object. Intead, we
    % should explicilty define the minimum and maximum values for each
    % type of plot (i.e. variable). 
    len = length(vfm.ByteTxt);  %Get number of types to be plotted
    disp(vfm.FieldDescription)
    [r,g,b] = CreateColorMap(vfm.FieldDescription);
    size(r)
    len
    colormap([r g b]);  %Set colormap
    %colormap(jet)
    % This does not work properly in all version of matlab. We should set
    % the y-axis limits of the colorbar. Because we are plotting integer
    % numbers, and we want them centered with the colors in the colorbar, 
    % the range has to be +-0.5 wider than the actual range
    caxis([-0.5 len-0.5]);     %Set color axis limits
    cb = colorbar;      %Put on colorbar
    % most plots include the 0, so (len) is one more than the maximum value
    %set(cb, 'ylim', [-0.5 len-0.5])
    set(cb, 'ticklength', [0 0], 'fontsize', 14, 'fontweight', 'bold')
    % This was a very ackward way of doing things: changing the labes
    % of the axis, while keeping the ticks/value at the same position. 
    %correctCBLabel(cb); %Correct the label for if 4 color colorbar
    %set(cb,'Position',[0.970 0.113 0.013 0.845]) %Set size & loc of colorbar
    set(cb,'Position',[0.919 0.121 0.021 0.788])
    %ylim([-2 30])
    % Display type legend   
    typelabel = sprintf('%d - %s,     ',0,char(vfm.ByteTxt(1)));
    for i = 2:len-1,
      typelabel = sprintf('%s%d - %s,     ',typelabel,i-1,char(vfm.ByteTxt(i)));
    end
    typelabel = sprintf('%s%d - %s   ',typelabel,len-1,char(vfm.ByteTxt(len)));
    %H = axes('position',[0.0 0.0 0.1 0.1]);
    %set(H,'Visible','off');
    TH = annotation('textbox',[0.062 0.0 0.837 0.04],'string',typelabel,'linestyle','none');
    set(TH,'FontSize',14,'fontname','Verdana','FontWeight','Bold','horizontalalignment','center','verticalalignment','middle');
    % Make the image the current axes
    axes(IH)

    % Display warning messages when image is larger than figure window (in pixels)
    % this is to let you know that you're trying to display more information than what
    % is there and that small/thin feature may be missing. If you use the zoom tool that
    % data will be visible.
    %Isize = get(TheFig,'Position');
    %if  (Isize(3) < size(block,2)) && (Isize(4) < size(block,1)),
	%disp('Warning: Image is bigger than the current figure widow'); 
	%disp('         not all pixels may be visible'); 
    %elseif  (Isize(3) < size(block,2)),
	%disp('Warning: Image is wider than the current figure widow'); 
	%disp('         not all pixels may be visible'); 
    %elseif Isize(4) < size(block,1),
	%disp('Warning: Image is taller than the current figure widow'); 
	%disp('         not all pixels may be visible'); 
    %end

%end % if nargin == 4


%aafig = myaa();
%set(aafig,'PaperUnits','inches','PaperPosition',[0 0 1300/dpi 667/dpi])
%print(aafig,'-painters','-dpng',['-r' num2str(dpi)],'teste.png')
%close(aafig)


%------------------------------------------------------------------------------
% Helper functions
%------------------------------------------------------------------------------

%function correctCBLabel(cb) %Colorbar Handle
%    if (max(get(cb,'YTick')) == 5)
%	set(cb,'YTick',[1 2 3 4 5]);
%    elseif (max(get(cb,'YTick')) == 6)
%	set(cb,'YTick',[1 2 3 4 6]);
%    end
%    InputLabel = get(cb,'YTickLabel');
%    sz = max(size(InputLabel));
%    label = '';
%    for i = 1:sz,
%	number = (str2num(InputLabel(i,:)))-1;
%	txti = sprintf('%d',number);
%	label = strvcat(label,txti);
%    end
%    set(cb,'YTickLabel',label);
%    
%function correctYLabel(Taxis,yaConv)
%yticks = [30 25 20 18 16 14 12 10 8 7 6 5 4 3 2 1 0 -0.5]';
%InvYtick = Alt2Ind(yticks);
%set(Taxis,'YTick',InvYtick);
%InputLabel = get(Taxis,'YTickLabel');
%    sz = max(size(InputLabel));
%    % Convert text to a number then raise it to 10^ then convert to text;
%    label = '';
%    for i = 1:sz,
%	number = round((str2num(InputLabel(i,:))));
%	txti = sprintf('%3.1f',yaConv(number));
%	label = strvcat(label,txti);
%    end
%    set(Taxis,'YTickLabel',label);
%
%function [ind] = Alt2Ind(alt)
%% NOTE: Returned index is not an integer.
%sz = length(alt);
% for i=1:sz,
%     if alt(i) >= 20.2,
%         ind(i) = (30.1 - alt(i)) / 0.180;
%     elseif alt(i) >= 8.2,
%         ind(i) = (20.2 - alt(i))/(0.06)+55;
%     else
%         ind(i) = (8.2 - alt(i))/(0.03)+255;
%     end
% end

function [alt] = Ind2Alt(ind);
sz = length(ind);
 for i=1:sz,
    if ind(i) < 56,
     alt(i) = 30.1 - (i)*180/1000;
    elseif ind(i) < 256,
     alt(i) = 20.2 - (i-55)*60/1000;
    else
     alt(i) = 8.2 - (i-255)*30/1000;
    end
 end

 
function [hx, hy] = AddMinorTicks(fig, ax, n, cor, len)

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



