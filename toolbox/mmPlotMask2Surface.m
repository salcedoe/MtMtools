function hp = mmPlotMask2Surface(MSK,options)
%MMPLOT2MASKSURFACE - Wrapper function that creates an isosurface from a 
%   input volume.
%   Options include Smoothing of Volume and decimation, and lighting
%   Default plots surface as a patch in one simple function call
%  
%
% INPUTS:
%   - BW:       logical 3D array
% OPTIONAL INPUTS (in this order). Enter empty brackets if skipping. 
%   - fcolor:    character array (default = 'cyan') - facecolor of the
%                isosurface.
%   - falpha:    scalar (0-1, default = 0.5) - transparency of the faces 
%   - lightEMup: boolean (default = true) - add lights to plot. Set to
%                false for multiple function calls (and then set to true 
%                on the final call). Otherwise you'll add too many lights
%                to scene
%   - report:    boolean (default=false) - print a report of settings to command window
%   - smooth:    boolean (default=false). True means Smooth volume
%   - decimator: decimation factor (0-1, default=0.15) of the generated surface 
%   - affTrfm:   4X4 3D affinity transformation matrix (default = [], no transformation)
%                Used to transform the vertices to match the orientation and size of the  
%                original volume. Requires matGEOM - plugged into
%                transformPoint3d
%   
% OUTPUT
%   - hp: handle to patch
% ---
% EXAMPLES
% hp = plot_seg_surface(BW);
% hp = plot_seg_surface(BW,fcolor='cyan');
% hp = plot_seg_surface(BW,fcolor='magenta',falpha=0.25, lightEMup=true, decimator=0.2);
%
% tform = createScaling3d(Sseg.xyz)
% hp = plot_seg_surface(BW,'magenta',transform_mat=tform); 
% ---
% AUTHOR: Ernesto Salcedo, PhD
% SITE: University of Colorado Modern Human Anatomy
% UPDATED: 03-12-23

arguments
    MSK (:,:,:) 
    options.fcolor = 'cyan';
    options.falpha (1,1) double = 0.5;
    options.lightEMup logical = true;
    options.report logical = false;
    options.smooth logical = false;
    options.decimator (1,1) double = 0.15;
    options.affTrfm (4,4) double = zeros(4,4); % 3D affinity transformation
    options.new_figure logical = false;
    options.tag char='';
    options.title char='';

end

if options.smooth % smooth boolean
    MSK = smooth3(MSK);
end

if options.new_figure
    figure(Visible="on")
end

% generate isosurface 
% [fv, report_s] = mmGetSurface(MSK, iv=0.5, decimator=options.decimator);
[fv, report_s] = mmGetSurface(MSK, ...
    iv=0.5, ...
    affTrfm=options.affTrfm, ...
    decimator=options.decimator);

if ~isempty(options.tag)
    fv.tag = options.tag;
end


% plot surface
hp = mmPlotSurface(fv, options.fcolor, options.falpha);

if ~isempty(options.title)
    title(options.title)
end

if options.lightEMup
    mmSetSurfacePlotProps
end

if options.report
    sc = {' not',' '}; 
    ss = sc{options.smooth+1}; % smooth string

     fprintf(['Volume was%s smoothed. ' ...
        'Surface Face Alpha was set to %1.2f. %s'], ...
        ss, ...
        options.falpha, ...
        report_s);
end