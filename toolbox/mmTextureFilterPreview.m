function out = mmTextureFilterPreview(in,nhood)
%MMTEXTUREFILTERPREVIEW Applies texture filters to input and displays the
%results
%   INPUTS
%   - p: a structure containing a grayscale image (p.gray)
%   - nhood (optional): a neighborhood to apply to the grayscale image.
%                       Needs to be a matrix (like true(3))
%   OUTPUTS
%   - p: a structure containing the filtered images
% ---
% University of Colorado School of Medicine
% Modern Human Anatomy Program
% Ernesto Salcedo, PhD
% Ernesto.Salcedo@cuanschutz.edu

if nargin>1
    in.std = stdfilt(in.gray,nhood);
    in.rng = rangefilt(in.gray,nhood);
    in.ent = entropyfilt(in.gray,nhood);
else
    in.std = stdfilt(in.gray);
    in.rng = rangefilt(in.gray);
    in.ent = entropyfilt(in.gray);
end

% rescale
in.std =rescale(in.std);
in.ent = rescale(in.ent);

out = in;

tiledlayout("horizontal",TileSpacing="none",Padding="compact")
for n=["std" "rng" "ent"]
    nexttile
    imshow(in.(n))
    title(n)
end
sgtitle("Texture Filters")

end