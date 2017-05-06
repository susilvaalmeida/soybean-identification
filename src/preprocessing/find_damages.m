%Find the damages of the leaflets images
%   output_img = find_damages(img) returns a binary image without shadow, noise, only with leaflets damages
%       img -- input RGB image
%       
%Here we do the same as explained in remove_noise.m to find the damages and them we remove the rest of the leaflet
%
%Authors:
%   Suellen Almeida <susilvaalmeida@gmail.com>
%   Antonio Carlos N. Junior <acnazarejr@gmail.com>
%   Thiago L. G. Souza (in memoriam)


function output_img = remove_background(img)
    img = filter_noise(img);
    img_gray = rgb2gray(img);
    level = graythresh(img_gray);
    bw = im2bw(img_gray,level);
    
    %bw = bw & ref;
    [labels, num] = bwlabel(bw);
    
    %find largest region
    largest = 1;
    for i = 1:(num)
        cont = length(find(labels == i));
        if((cont > length(find(labels == largest))))
            largest = i;
        end
    end

    output_img = bw;
    N = size(output_img);
    for i = 1:(N(1))
        for j = 1:(N(2))
            if(labels(i,j) == largest)
                output_img(i,j) = 0;
            end
        end
    end

    output_img = 1 - output_img;
end