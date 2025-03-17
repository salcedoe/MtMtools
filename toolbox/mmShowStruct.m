function mmShowStruct(p,options)
%MMSHOWSTRUCT Displays images that are packaged into a structure
%
% INPUTS
% - p: a structure contain fields with image variables
% - titles (optional): string array of titles for plots

arguments
    p struct % must contain fields with images in them
    options.fn2display = [];
    options.titles = [] % optional set of titles 
end


if ~isempty(options.fn2display)
    fn = options.fn2display; % set fieldnames to show
else
    fn = string(fieldnames(p));
    la = structfun(@ismatrix,p); 
    fn = fn(la); % ignore non-numeric inputs
end

if isempty(options.titles)
    titles = fn;
else
    titles = options.titles;
end

for n=1:numel(fn)
    nexttile
    imshow(p.(fn(n)))
    title(titles(n))
end

set(gcf, 'Tag','mmShowStruct')
end