%Filter noise of leaflets images
%   output_img = filter_noise(img_gray) returns a RGB image without noise
%       img -- input RGB image
%       
%The noise removal has 3 steps: 
%   1. image segmentation: find global threshold using Otsu's method to find the region of interest
%   2. remove noise: compute connected components for the image, and consider only the largest region (the real leaflet), the others are noise
%   3. find image background: as the images is now binary, the white regions inside the leaflet are the damages
%
%Authors:
%   Suellen Almeida <susilvaalmeida@gmail.com>
%   Antonio Carlos N. Junior <acnazarejr@gmail.com>
%   Thiago L. G. Souza (in memoriam)

function output_img = filter_noise(img)
    img_gray = remove_shadows(img);
    level = graythresh(img_gray);
    bw = imbinarize(img_gray,level);
    output_img = img;
    img_temp = 1-bw;
    
    [labels,num] = bwlabel(img_temp);

    %find largest region
    largest = 1;
    for i = 1:(num)
        cont = length(find(labels == i));
        if((cont > length(find(labels == largest))))
            largest = i;
        end
    end

    
    N = size(output_img);
     for i = 1:(N(1))
         for j = 1:(N(2))
             if(labels(i,j) ~= largest)
                 output_img(i,j,1) = 255;
                 output_img(i,j,2) = 255;
                 output_img(i,j,3) = 255;
             end
         end
     end
end