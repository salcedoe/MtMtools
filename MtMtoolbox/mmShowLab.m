function lab = mmShowLab(rgb)
%MMSHOWLAB converts rgb image to lab and display the planes
% lab = mmShowLab(rgb)

arguments (Input)
    rgb (:,:,3) {mustBeNumeric}
end

lab = rgb2lab(rgb); % convert to L*a*b* Space

figure;
tiledlayout(2,3,"TileSpacing","tight")
titles = ["L (lightness)", "a (green-red)", "b (yellow-blue)"];
for n=1:3
    nexttile(n);
    imshow(lab(:,:,n),[])
    title(titles(n));

    nexttile(n+3)
    histogram(lab(:,:,n))
end

end