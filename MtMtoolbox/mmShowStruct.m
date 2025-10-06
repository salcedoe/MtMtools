function mmShowStruct(S,options)
%MMSHOWSTRUCT Displays images that are packaged into a structure
%
% INPUTS
% - S: a structure contain fields with image variables
% - fn2display: cell array or string contain the names of the fields you
% want to display
% - titles (optional): string array of titles for plots
%
% EXAMPLES
% mmShowStruct(p)
% mmShowStruct(p,fn2display={'rgb','gray'})
% mmShowStruct(p,fn2display={'rgb','gray'},titles={'Original','Grayscale'})

arguments
    S struct % must contain fields with images in them
    options.fn2display {mustBeText} = '';
    options.titles {mustBeText} = '' % optional set of titles
end

% find the numeric fields
fn = string(fieldnames(S)); % indicated fieldnames that are in S
% num_la = structfun(@isnumeric,S); % find numeric fields in p
num_la = structfun(@ismatrix,S); % find numeric fields in p



if ~isempty(options.fn2display) % only plot indicate fields

    la = ismember(fn, options.fn2display) & num_la; % do the fields exist and are they numeric
   
    if any(la)
        fn = fn(la);
    else        
        error('Fields to display (fn2disp) not found in structure or not numeric.')        
    end
else
    fn = string(fieldnames(S)); % all fieldnames
    fn = fn(num_la); % ignore non-numeric inputs
end

if isempty(options.titles)
    titles = fn;
else
    if isequal(numel(options.titles),numel(fn))
        titles = options.titles;
    else
        disp('Number of titles must match the number of fields to display.');
        titles = fn; %
    end
end

% Display the indicated fields in the structure
ax = gobjects(numel(fn));
for n=1:numel(fn)
    ax(n) = nexttile;
    imshow(S.(fn(n)))
    title(titles(n))
end

set(gcf, 'Tag','mmShowStruct') % tag the figure 
linkaxes(ax,'xy') % link the axes
end