function [type,ClassText] = vfm_type(vfm_row,type)
%Description: Takes a vfm row (1d array 1x????) and extracts the bits of interest as specified by the user
%Inputs: vfm_row - an array 1x????, a single string (e.g. one of the following: 'type','all','qa','phase',...)
%Outputs: type - a vfm row that is of type uint that has been "typed", ClassText - a structur that contains information about the vfm type returned

% ------------------------------------------------------------------------------
% $Log: vfm_type.m,v $
% Revision 1.2  2005/03/28 19:13:39  kuehn
% Updated to better plot feature qa flags.  A value of (1) was added to all feature qa flags as long as the feature is not clear air, surface, subsurface, or no signal. Invalid features ARE included.
%
% Revision 1.1  2005/03/24 21:10:45  kuehn
% First submission under new directory
%
% ------------------------------------------------------------------------------

 umask3 = uint16(7);
 umask2 = uint16(3);
 umask1 = uint16(1);
 switch lower(type)
   case {'type','all'}
       type = bitand(umask3,vfm_row);
       ClassText = struct('FieldDescription',{'Feature Type'},...
       'ByteTxt',{{'Invalid','Clear Air','Cloud','Aerosol','Strat Feature',...
       'Surface','Subsurface','No Signal'}});
   case{'qa'}
       type = bitand(umask3,vfm_row);
       not_clear_air = ((type == 0) | (type == 2) | (type == 3) | (type ==4));
       a = bitshift(vfm_row,-3);
       type = bitand(umask2,a);
       type = type + uint16(not_clear_air);
       ClassText = struct('FieldDescription',{'Feature Type QA'},...
       'ByteTxt',{{'Clear Air','No','Low','Medium','High'}});
   case{'phase'}
       a = bitshift(vfm_row,-5);
       type = bitand(umask2,a);
       ClassText = struct('FieldDescription',{'Ice/Water Phase'},...
       'ByteTxt',{{'Unknown/Not Determined','Ice','Water','HO'}});
   case{'phaseqa'}
       a = bitshift(vfm_row,-7);
       type = bitand(umask2,a);
       ClassText = struct('FieldDescription',{'Ice/Water Phase QA'},...
       'ByteTxt',{{'None','Low','Medium','High'}});
   case{'aerosol'}
       a = bitshift(vfm_row,-9);
       temp = bitand(umask3,a);
       type2 = bitand(umask3,vfm_row);
       tmask = (type2 == 3);
       temp2 = (temp & tmask);
       type = temp.*uint16(temp2);
       ClassText = struct('FieldDescription',{'Aerosol Sub-Type'},...
       'ByteTxt',{{'Not Determined','Clean Marine','Dust','Polluted Cont.','Clean Cont.',...
       'Polluted Dust','Smoke','Other'}});
   case{'cloud'}
       a = bitshift(vfm_row,-9);
       temp = bitand(umask3,a);
       type2 = bitand(umask3,vfm_row);
       tmask = (type2 == 2);
       temp2 = (temp & tmask);
       type = temp.*uint16(temp2) +  uint16(tmask);
       ClassText = struct('FieldDescription',{'Cloud Sub-Type'},...
       'ByteTxt',{{'NA','Low, overcast, thin','Low, overcast, thick','Trans. StratoCu','Low Broken',...
       'Altocumulus','Altostratus','Cirrus (transparent)','Deep Convection'}});
   case{'psc'}
       a = bitshift(vfm_row,-9);
       temp = bitand(umask3,a);
       type2 = bitand(umask3,vfm_row);
       tmask = (type2 == 4);
       temp2 = (temp & tmask);
       type = temp.*uint16(temp2);
       ClassText = struct('FieldDescription',{'PSC Sub-Type'},...
       'ByteTxt',{{'Not Determined','Non-Depol. Large P.','Depol. Large P.','Non-Depol Small P.','Depol. Small P.',...
       'empty','empty','Other'}});
   case{'subtype'}
       % Returns just subtype number
       a = bitshift(vfm_row,-9);
       type = bitand(umask3,a);
       ClassText = struct('FieldDescription',{'Sub-Type'},...
       'ByteTxt',{{'One','Two','Three','Four','Five',...
       'Six','Seven','Eight'}});
   case{'typeqa'}
       a = bitshift(vfm_row,-12);
       type = bitand(umask1,a);
       ClassText = struct('FieldDescription',{'Sub-Type QA'},...
       'ByteTxt',{{'None','Low','Medium','High'}});
   case{'averaging'}
       a = bitshift(vfm_row,-13);
       type = bitand(umask3,a);
       ClassText = struct('FieldDescription',{'Averaging Required for Detection'},...
       'ByteTxt',{{'NA','1/3 km','1 km','5 km','20 km','80 km'}});
   case {'type_truth'}
       type = bitand(umask3,uint16(vfm_row));
       ClassText = struct('FieldDescription',{'Feature Type (Truth)'},...
       'ByteTxt',{{'Invalid','Clear Air','Cloud','Aerosol','Strat Feature',...
       'Surface','Subsurface','No Signal'}});
   case{'phase_truth'}
       a = bitshift(uint16(vfm_row),-6);
       type = bitand(umask3,a);
       ClassText = struct('FieldDescription',{'Ice/Water Phase (Truth)'},...
       'ByteTxt',{{'Unknown/Not Determined','Ice','Water','Mixed Phase'}});
   case{'aerosol_truth'}
       a = bitshift(uint16(vfm_row),-3);
       temp = bitand(umask3,a);
       type2 = bitand(umask3,vfm_row);
       tmask = (type2 == 3);
       temp2 = (temp & tmask);
       type = temp.*uint16(temp2);
       ClassText = struct('FieldDescription',{'Aerosol Sub-Type (Truth)'},...
       'ByteTxt',{{'Not Determined','Clean Marine','Dust','Polluted Cont.','Clean Cont.',...
       'Polluted Dust','Smoke','Other'}});
   case{'cloud_truth'}
       a = bitshift(vfm_row,-3);
       temp = bitand(umask3,a);
       type2 = bitand(umask3,vfm_row);
       tmask = (type2 == 2);
       temp2 = (temp & tmask);
       type = temp.*uint16(temp2);
       ClassText = struct('FieldDescription',{'Cloud Sub-Type (Truth)'},...
       'ByteTxt',{{'Not Determined','Stratus','Cumulus','Altostratus','Altocumulus',...
       'Cirrus','Deep Conv./Frontal Cloud','Other'}});
   otherwise
       disp('Unknown type specifier. Check input');
       type = 0;
       ClassText = struct('FieldDescription',{'empty'},'ByteTxt',{'empty'});
 end
