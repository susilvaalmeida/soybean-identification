%Extract zernike descriptors of damages contours
%   descriptors = zernike_descriptors(damage_img,N) extracts zernike descriptors of the damage contour 
%       damage_img -- binary image with one damage
%       N -- number of degrees
%
%Author:
%   Suellen Almeida <susilvaalmeida@gmail.com>

function descriptors = zernike_descriptors(damage_img,N)
    nimg = damage_img(:,:,1);
    nimg = ~nimg; 

    [y x] = find(nimg);

    centx = sum(x)/length(x);
    centy = sum(y)/length(y);

    % compute maximum radius for the zernike polynomials
    dist = sqrt((x-repmat(centx,length(x),1)).^2 + (y-repmat(centx,length(y),1)).^2);
    R = ceil(max(dist));

    % filling the holes
    nimg=imfill(nimg,round(sub2ind(size(nimg),centy,centx)));

    % zernike moments
    [znames, zvalues] = descriptor_zernike_mb(nimg,N,R);
    descriptors = abs(zvalues);
end