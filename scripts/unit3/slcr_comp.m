%[text] ## Compare femurs
%[text] How morphologically similar are the femurs? Let's overlay the femurs
figure;
hpL = mmPlotMask2Surface(lSeg.maskCombo, fcolor='g', ...
    falpha=1, ...
    transform=rSeg.tform);% transform the surface (to mm space)
hpL.Vertices = hpL.Vertices - mean(hpL.Vertices);

hpR = mmPlotMask2Surface(rSeg.mask, fcolor='r', ...
    falpha=0.5, ...
    transform=rSeg.tform); % transform the surface (to mm space)

hpR.Vertices = hpR.Vertices - mean(hpR.Vertices);


%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
