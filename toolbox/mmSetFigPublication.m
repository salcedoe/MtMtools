function mmSetFigPublication(fontsz)
%MMSETFIGPUBLICATION sets the default axes font and figure color

arguments
    fontsz (1,1) {mustBeNumeric} = 16
end

set(groot, 'defaultAxesFontSize', fontsz, 'defaultFigureColor','w');

fprintf('Default figure color set to white.\nDefault font size set to %1.1f.',fontsz)
end