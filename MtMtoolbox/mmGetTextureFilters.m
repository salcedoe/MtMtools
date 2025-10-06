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
% Examples:
%
% p = mmGetTextureFilters(p)
% p = mmGetTextureFilters(p,true(7))
%
% Author: Ernesto Salcedo, PhD
% Site: University of Colorado Modern Human Anatomy
% Updated: 09/28/2025

arguments
    p struct
    nhood (:,:) {mustBeNumericOrLogical} = []
end

if any(isfield(p,{'rgb','gray'})) % must contain a field called rgb or gray
    if isfield(p,'rgb')
        p.gray = rgb2gray(p.rgb);
    elseif isfield(p,'gray') && ~ismatrix(p.gray)
        try
            p.gray = rgb2gray(p.gray);
        catch
            disp('The field p.gray cannot be converted to grayscale')
        end
    end
else
    disp('First input must be a structure containing a field called rgb (for color images) or gray (for grayscale images).')
    return
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