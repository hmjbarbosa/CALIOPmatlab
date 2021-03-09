function FigNum = newfigure()
% Function will return the first available figure number
% Example: If figures 1,2,3,11 are used the new figure # retured will be 4

num = get(0,'Children');
if isempty(num),  %Determine if ZERO figures are open
    FigNum = 1;
elseif length(num) == 1,
    if num(1) == 1,
	FigNum = 2;
	return;
    else
	FigNum = 1;
	return;
    end
else
    num = sort(num);
    sz = length(num);
    for i = 1:sz,
        FigNum = i;
        if num(i) > FigNum,
            return;
        end
    end
    FigNum = i+1;
end
