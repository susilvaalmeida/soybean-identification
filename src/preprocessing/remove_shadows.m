%Removes the shadows of leaflet images using hue channel of HSV image
%   output_img = remove_shadows(img) returns a gray image without shadows
%       img -- input RGB image
%       
%Authors:
%   Suellen Almeida <susilvaalmeida@gmail.com>
%   Antonio Carlos N. Junior <acnazarejr@gmail.com>
%   Thiago L. G. Souza (in memoriam)

function output_img = remove_shadows(img)
    hsv = rgb2hsv(img);
    hue = hsv(:,:,1);   
    hue_bw = imbinarize(hue,0.3);
    output_img = rgb2gray(img);
    output_img = (im2double(output_img)+double(hue_bw));
end