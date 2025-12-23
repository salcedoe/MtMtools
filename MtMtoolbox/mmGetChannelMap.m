function [cm] = mmGetChannelMap(ch)
%MMGETCHANNELMAP This function returns a 256 colormap of the shade indicated by the
%input
%
% INPUT: a channel name, letter, or index
% OUTPUT: a colormap of the shade indicated by the input
%
% EXAMPLE
%
% red_cm = mmGetChannelMap('red')
% green_cm = mmGetChannelMap('g')
%
% Author: Ernesto Salcedo, PhD. 2019
% Created: 18-Sep-2019 using Malab '9.7.0.1190202 (R2019b)'

if ischar(ch) % if char, get the first letter
    ch = lower(ch);
    ch = ch(1);
    la = 'rgb' == ch;
elseif isnumeric(ch)
    la = ismember([1 2 3],  ch);
else
    beep
    disp('input format not recognized')
    return    
end

cm = gray(256); % 256 shades of gray
cm(:,~la) = zeros(size(cm,1), sum(~la)); % zeros out the non-matching columns