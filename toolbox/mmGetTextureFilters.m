function p = mmGetTextureFilters(p,nhood)
%MMGETTEXTUREFILTERS - generate standard texture filters of input image, 
% standard deviation, range, and entropy
%
% INPUTS:
% p - a structure that contains a field called gray that contains a
%       grayscale image
% nhood - (optional) a matrix nhood of trues
% OUTPUTS
% p - updated structure containing three new fields: std, rng, and ent
%
% Author: Ernesto Salcedo, PhD
% Site: University of Colorado Modern Human Anatomy
% Updated: 10/01/2024

arguments
    p struct
    nhood (:,:) {mustBeNumericOrLogical} = []
end

if ~isfield(p,'gray')
    disp('Input 1 must be a structure with a field named gray, that contains a grayscale image.')
    return
end

if nargin>1
    p.std = stdfilt(p.gray,nhood);
    p.rng = rangefilt(p.gray,nhood);
    p.ent = entropyfilt(p.gray,nhood);
else
    p.std = stdfilt(p.gray);
    p.rng = rangefilt(p.gray);
    p.ent = entropyfilt(p.gray);
end

% rescale
p.std =rescale(p.std);
p.ent = rescale(p.ent);

end