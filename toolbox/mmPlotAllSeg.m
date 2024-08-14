function hp = mmPlotAllSeg(mV,segT,options)
%MMPLOTMASKSURFACE - Wrapper function that plots all segmentations from a
%   3D Slicer segmentation volume.
%   Options include Smoothing of Volume and decimation, and lighting
%   Default plots surface as a patch in one simple function call
%
% INPUTS:
%   - Vol:       3D array
%   - segT:      Table containing the following slicer info — Name, Layer,
%                   LabelValue, Color
%
% OPTIONAL INPUTS. Enter empty brackets if skipping.
%   - new_figure:   logical (default = true). Create new figure if true
%   - falpha:       scalar (0-1, default = 0.5) - transparency of the faces
%   - smooth:       boolean (default=false). True means Smooth volume
%   - affTrfm:      4X4 3D affinity transformation matrix (default = [], no transformation)
%                    Used to transform the vertices to match the orientation and size of the
%                   original volume. Requires matGEOM - plugged into transformPoint3d
%
% OUTPUT
%   - hp: handle to patch
% ---
% EXAMPLES
% hp = mmPlotAllSeg(Vol,segT);
% hp = mmPlotAllSeg(Vol,segT, falpha=0.25, affTrfm=tfO.A);
%
% tform = createScaling3d(Sseg.xyz)
% segT = mmGetSlicerSegNames(seg_file)
% hp = mmPlotAllSeg(Vol,segT,affTrfm=tform);
% ---
% AUTHOR: Ernesto Salcedo, PhD
% SITE: University of Colorado Modern Human Anatomy
% UPDATED: 03-12-2023

arguments
    mV medicalVolume
    segT table
    % options.affTrfm (4,4) double = zeros(4,4); % 3D affinity transformation
    options.falpha (1,1) double = 0.5;
    options.smooth logical = false;
    options.dec_factor (1,1) double = 0.15;
    options.new_figure logical = true;
end

if options.new_figure
    figure(Visible="on")
end

count = height(segT);
% tform = intrinsicToWorldMapping(mV.VolumeGeometry);
[~,name] = fileparts(segT.Properties.UserData.Filename);
name = extractBefore(name,(" "|"_"));

hp = gobjects(count,1);
for n=1:count
    % disp(n)
    sname = segT.Name(n);
    S = mmGetMedicalVolumeSegment(mV,segT,segName=sname);

    if options.smooth % smooth boolean
        S.mask = smooth3(S.mask);
    end

    % generate isosurface
    fv = mmGetSurface(S.mask, iv=0.5, decimator=options.dec_factor, affTrfm=S.tform.A, use_fast_march=true);

    if ~isempty(fv.vertices)
        % plot surface
        hp(n) = mmPlotSurface(fv, segT.Color(n,:), options.falpha);
        hp(n).Tag =  name + "-" + segT.Name(n);
    end

end
mmSetSurfacePlotProps

end