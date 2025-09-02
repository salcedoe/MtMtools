function p = mmGetTextureFilters(p,nhood)
%MMGETTEXTUREFILTERS - generate standard texture filters of input image,
% standard deviation, range, and entropy
%
% INPUTS:
% p - a structure that contains a field called 'rgb' or 'img'
%        - rgb should be an rgb image
%        - img should be a grayscale
%  nhood - (optional) a matrix nhood of trues
% OUTPUTS
% p - updated structure containing four new fields: gray, std, rng, and ent
%
% Author: Ernesto Salcedo, PhD
% Site: University of Colorado Modern Human Anatomy
% Updated: 10/01/2024

arguments
    p struct
    nhood (:,:) {mustBeNumericOrLogical} = []
end

if any(isfield(p,{'rgb','img'}))
    if isfield(p,'rgb')
        p.gray = rgb2gray(p.rgb);
    elseif isfield(p,'img')
        p.gray = p.img;
    else
        disp('First input must be a structure containing a field named rgb for color images or img for grayscale images.')
        return
    end
end

if nargin>1 % apply neighborhood
    p.std = stdfilt(p.gray,nhood);
    p.rng = rangefilt(p.gray,nhood);
    p.ent = entropyfilt(p.gray,nhood);
else
    p.std = stdfilt(p.gray);
    p.rng = rangefilt(p.gray);
    p.ent = entropyfilt(p.gray);
end

% rescale
p.std = rescale(p.std);
p.ent = rescale(p.ent);

end