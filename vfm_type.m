function [vfm_type, ClassText] = vfm_type(vfm_row, feature)
%VFM_TYPE   Unpacks a VFM row
%   [vfmtype, ClassText] = VFM_TYPE(vfm_row, feature) takes a vfm_row and
%   extracts the bits of a feature flag. vfm_row is a VFM uint16
%   array. feature is a string specifying the name of the feature
%   classification flag, and can be one of the following:
%
%      'type',
%      'typeqa',
%      'phase',
%      'phaseqa',
%      'aerosol',
%      'cloud',
%      'psc',
%      'subtype',
%      'subtypeqa', 
%      'averaging'
%
%   vfm_type is an uint16 array holding the extracted feature. ClassText is
%   a structure that contains information about the vfm_type returned, and
%   contains the following fields:
%
%      'FieldDescription', the feature name 
%      'Vmin' and 'Vmax', the limits of the feature flag
%      'ByteTxt', descriptors of the feature flag
%
%   History: 
%      2021-mar-09 Added max/min values for each feature, help string and
%                  extra comments.  Removed unused features.
%      
%      2005-mar-28 Original code by Ralph Kuehn shared on CALIPO's
%                  website, from 2005/03/28.
%
umask3 = uint16(7);
umask2 = uint16(3);
umask1 = uint16(1);

switch lower(feature)
 case {'type'}
  % bits 1-3 Feature Type 
  % 0 = invalid (bad or missing data)
  % 1 = "clear air"
  % 2 = cloud
  % 3 = aerosol
  % 4 = stratospheric feature
  % 5 = surface
  % 6 = subsurface
  % 7 = no signal (totally attenuated)
  vfm_type = bitand(umask3,vfm_row);
  ClassText = struct('FieldDescription', {'Feature Type'},...
                     'Vmin',{0}, 'Vmax',{7},...
                     'ByteTxt',{{'Invalid','Clear Air','Cloud','Aerosol','Strat Feature',...
                                 'Surface','Subsurface','No Signal'}});
 
 case{'typeqa'}
  % bits 4-5 Feature Type QA 
  % 0 = none
  % 1 = low
  % 2 = medium
  % 3 = high
  vfm_type = bitand(umask3,vfm_row);
  not_clear_air = ((vfm_type == 0) | (vfm_type == 2) | (vfm_type == 3) | (vfm_type ==4));
  a = bitshift(vfm_row,-3);
  vfm_type = bitand(umask2,a);
  vfm_type = vfm_type + uint16(not_clear_air);
  ClassText = struct('FieldDescription',{'Feature Type QA'},...
                     'Vmin',{0}, 'Vmax',{3},...
                     'ByteTxt',{{'Clear Air','No','Low','Medium','High'}});
 
 case{'phase'}
  % 6-7 Ice/Water Phase
  % 0 = unknown / not determined
  % 1 = randomly oriented ice
  % 2 = water
  % 3 = horizontally oriented ice
  a = bitshift(vfm_row,-5);
  vfm_type = bitand(umask2,a);
  ClassText = struct('FieldDescription',{'Ice/Water Phase'},...
                     'Vmin',{0}, 'Vmax',{3},...
                     'ByteTxt',{{'Unknown/Not Determined','Ice','Water','HO'}});
 
 case{'phaseqa'}
  % 8-9 Ice/Water Phase QA 
  % 0 = none
  % 1 = low
  % 2 = medium
  % 3 = high
  a = bitshift(vfm_row,-7);
  vfm_type = bitand(umask2,a);
  ClassText = struct('FieldDescription',{'Ice/Water Phase QA'},...
                     'Vmin',{0}, 'Vmax',{3},...
                     'ByteTxt',{{'None','Low','Medium','High'}});
 
 case{'aerosol'}
  % 10-12 Feature Sub-type
  % If feature type = aerosol, bits 10-12 will specify the aerosol type
  % 0 = not determined
  % 1 = clean marine
  % 2 = dust
  % 3 = polluted continental
  % 4 = clean continental
  % 5 = polluted dust
  % 6 = smoke
  % 7 = other
  a = bitshift(vfm_row,-9);
  temp = bitand(umask3,a);
  vfm_type2 = bitand(umask3,vfm_row);
  tmask = (vfm_type2 == 3);
  temp2 = (temp & tmask);
  vfm_type = temp.*uint16(temp2);
  ClassText = struct('FieldDescription',{'Aerosol Sub-Type'},...
                     'Vmin',{0}, 'Vmax',{7},...
                     'ByteTxt',{{'Not Determined','Clean Marine','Dust','Polluted Cont.','Clean Cont.',...
                                 'Polluted Dust','Smoke','Other'}});
 
 case{'cloud'}
  % 10-12 Feature Sub-type
  % If feature type = cloud, bits 10-12 will specify the cloud type.
  % 0 = low overcast, transparent
  % 1 = low overcast, opaque
  % 2 = transition stratocumulus
  % 3 = low, broken cumulus
  % 4 = altocumulus (transparent)
  % 5 = altostratus (opaque)
  % 6 = cirrus (transparent)
  % 7 = deep convective (opaque)
  a = bitshift(vfm_row,-9);
  temp = bitand(umask3,a);
  vfm_type2 = bitand(umask3,vfm_row);
  tmask = (vfm_type2 == 2);
  temp2 = (temp & tmask);
  vfm_type = temp.*uint16(temp2) +  uint16(tmask);
  ClassText = struct('FieldDescription',{'Cloud Sub-Type'},...
                     'Vmin',{0}, 'Vmax',{7},...
                     'ByteTxt',{{'NA','Low, overcast, thin','Low, overcast, thick','Trans. StratoCu','Low Broken',...
                                 'Altocumulus','Altostratus','Cirrus (transparent)','Deep Convection'}});
 
 case{'psc'}
  % 10-12 Feature Sub-type
  % If feature type = Polar Stratospheric Cloud, bits 10-12 will specify PSC classification.
  % 0 = not determined
  % 1 = non-depolarizing PSC
  % 2 = depolarizing PSC
  % 3 = non-depolarizing aerosol
  % 4 = depolarizing aerosol
  % 5 = spare
  % 6 = spare
  % 7 = other
  a = bitshift(vfm_row,-9);
  temp = bitand(umask3,a);
  vfm_type2 = bitand(umask3,vfm_row);
  tmask = (vfm_type2 == 4);
  temp2 = (temp & tmask);
  vfm_type = temp.*uint16(temp2);
  ClassText = struct('FieldDescription',{'PSC Sub-Type'},...
                     'Vmin',{0}, 'Vmax',{7},...
                     'ByteTxt',{{'Not Determined','Non-Depol. PSC','Depol. PSC',...
                                 'Non-Depol Aerosol','Depol. Aerosol','spare','spare','Other'}});
 
 case{'subtype'}
  % Returns just subtype number
  a = bitshift(vfm_row,-9);
  vfm_type = bitand(umask3,a);
  ClassText = struct('FieldDescription',{'Sub-Type'},...
                     'Vmin',{0}, 'Vmax',{7},...
                     'ByteTxt',{{'Zero','One','Two','Three','Four','Five',...
                                 'Six','Seven'}});
 
 case{'subtypeqa'}
  % 13 Cloud / Aerosol /PSC Type QA 
  % 0 = not confident
  % 1 = confident
  a = bitshift(vfm_row,-12);
  vfm_type = bitand(umask1,a);
  ClassText = struct('FieldDescription',{'Sub-Type QA'},...
                     'Vmin',{0}, 'Vmax',{1},...
                     'ByteTxt',{{'Not Confident','Confident'}});
 
 case{'averaging'}
  % 14-16 Horizontal averaging required for detection
  % (provides a coarse measure of feature backscatter intensity)
  % 0 = not applicable
  % 1 = 1/3 km
  % 2 = 1 km
  % 3 = 5 km
  % 4 = 20 km
  % 5 = 80 km
  a = bitshift(vfm_row,-13);
  vfm_type = bitand(umask3,a);
  ClassText = struct('FieldDescription',{'Averaging Required for Detection'},...
                     'Vmin',{0}, 'Vmax',{5},...
                     'ByteTxt',{{'NA','1/3 km','1 km','5 km','20 km','80 km'}});
  
 otherwise
  disp('Unknown type specifier. Check input');
  vfm_type = 0;
  ClassText = struct('FieldDescription',{'empty'},'Vmin',{nan}, 'Vmax',{nan},'ByteTxt',{'empty'});
end
