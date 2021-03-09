function [block,TypeText] = vfm_row2block(vfm_row,type)
% Description: Rearanges a vfm row to a 2d grid
% Inputs: vfm_row - an array 1x5515, type - a string (see vfm_type for details)
% Outputs: block - 2d array of vfm data, see function vfm_altitude for
%          altitude array information. Altitude array is in similar format as
%          CALIPSO L1 profile data (i.e. it isn't uniform).
%          TypeText - a string (see vfm_type for details)
% 
% Notes: 
% -Uses vfm_type
% -Return type is uint8
% -This low altitude data (< 8km) is stored as 15 profiles 30m vertical by 333m horizontal
% -This corresponds to an array 290x15 packed in a 1d-array 4350 elements long;

% ------------------------------------------------------------------------------
% $Log: vfm_row2block.m,v $
% Revision 1.1  2005/03/24 21:10:45  kuehn
% First submission under new directory
%
% ------------------------------------------------------------------------------

className = 'uint8';

% Get typed array;
if strcmp(type,'AllNew');
    % Combine feature type with ice water
    [AtypedA,TypeText] = vfm_type(vfm_row,'all');
    [AtypedP,TypeText] = vfm_type(vfm_row,'phase');
    [Atyped,TypeText] = mergeIt(AtypedA,AtypedP);
else
    [Atyped,TypeText] = vfm_type(vfm_row,type);
end

%block = ones(290,15,className)*intmax(className);
% For higher altitude data, info will be over-sampled in horizontal dimension
% for 8-20km block it will be 200x15 = 3000 rather than 200x5 = 1000
% for 20-30 km block it will be 55x15 = 825, rather than 55x3 = 165
block = ones(55+200+290,15,className)*10;
offset = 1;
step = 55;
indA = 1; 
indB = 55; 
for i =1:3,
    iLow = offset+step*(i-1);
    iHi = iLow+step-1;
    n = (i-1)*5;
    for k=1:5,
     block(indA:indB,n+k) = Atyped(iLow:iHi);
    end
end

offset = 165+1;
step = 200;
indA = 55+1; 
indB = 55+200; 
for i =1:5,
    iLow = offset+step*(i-1);
    iHi = iLow+step-1;
    n = (i-1)*3;
    for k=1:3,
     block(indA:indB,n+k) = Atyped(iLow:iHi);
    end
end
% element 1,1 correspond to Alt -0.5km, position -2.5 km from center lat lon.
offset = 1165+1;
step = 290;
indA = 55+200+1; 
indB = 55+200+290; 
for i =1:15,
    iLow = offset+step*(i-1);
    iHi = iLow+step-1;
    block(indA:indB,i) = Atyped(iLow:iHi);
end

function [Atyped,TypeText] = mergeIt(AtypedA,AtypedP)

TypeText = struct('FieldDescription',{'Feature Type'},...
   'ByteTxt',{{'Invalid','Clear Air','Ice Cloud','Water Cloud', 'Aerosol','Strat Feature',...
   'Surface','Subsurface','No Signal'}});

temp  = uint16(AtypedA >= 3);
Atyped = AtypedA + temp;

temp = uint16(AtypedP >= 2);
Atyped = Atyped + temp;
