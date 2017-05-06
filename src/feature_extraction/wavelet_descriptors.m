%Extract wavelet descriptors of damages contours
%   descriptors = wavelet_descriptors(damage_img,wv_family,N,percent_N) extracts N wavelets descriptors of the damage contour 
%       damage_img -- binary image with one damage
%       N -- number of wavelets descriptors to extract
%       percent_N -- percent of the extracted coeficients to consider as descriptors
%
%Author:
%   Suellen Almeida <susilvaalmeida@gmail.com>

function descriptors = wavelet_descriptors(damage_img,wv_family,N,percent_N)
    nimg = damage_img(:,:,1);
    nimg = ~nimg; 
    sizeimg = find(nimg);

    % resizing normalization
    if(128/length(sizeimg) < 1) 
        nimg = imdilate(nimg, strel('square',ceil(length(sizeimg)/(128)))); 
    end
    nimg = imresize(nimg, 128/length(sizeimg)); %*size(nimg)
    
    b = bwboundaries(nimg);
    y = b{1}(:,1);
    x = b{1}(:,2);
    
    % translating to mass center
    y = y - mean(y);
    x = x - mean(x);

    ay = y;
    ax = x; % level 0    
    while(length(ax)>=N)
        [ay dy] = dwt(ay,wv_family);
        [ax dx] = dwt(ax,wv_family);
    end

    z = ax + i*ay;    %z(t) = x(t) + iy(t) --> complex coordinates
    z_descriptors = sort(abs(z),'descend');
    z_descriptors = z_descriptors';

    N_z = length(z_descriptors);
    real_N = round(N*percent_N);
    if(N_z<real_N)
        descriptors = z_descriptors;
        descriptors(N_z+1:real_N) = zeros(1,real_N-N_z);
    else
        descriptors = mt(1:real_N);
    end
    descriptors = descriptors/max(descriptors);
end