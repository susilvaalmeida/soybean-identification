%Discard the damages with area less than 20 pixels
%   output_img = discard_small_damages(img) returns a binary image with damages, discarding the small ones
%       img -- input binary image with damages
%       
%Authors:
%   Suellen Almeida <susilvaalmeida@gmail.com>
%   Antonio Carlos N. Junior <acnazarejr@gmail.com>
%   Thiago L. G. Souza (in memoriam)

function output_img = discard_small_damages(bw_img)
    [r c] = size(bw_img);
    total_size = r*c;

    output_img = bw_img;
    bw_img = 1-bw_img;
    
    [labels, num] = bwlabel(bw_img);
    for i = 1:(num)
        perc = length(find(labels == i))/total_size;
        
        if(perc < 0.0002)
            output_img(labels==i) = 1;
        end
    end   
end 