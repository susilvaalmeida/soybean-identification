%Extract fourier descriptors of damages contours
%   descriptors = fourier_descriptors(damage_img,N) extracts N fourier descriptors of the damage contour 
%       damage_img -- binary image with one damage
%       N -- number of fourier descriptors to extract
%
%Author:
%   Suellen Almeida <susilvaalmeida@gmail.com>

function descriptors = fourier_descriptors(damage_img,N)
    nimg = damage_img(:,:,1);
    nimg = ~nimg; 
    sizeimg = find(nimg);

    % resizing normalization
    if(128/length(sizeimg) < 1) 
        nimg = imdilate(nimg, strel('square',ceil(length(sizeimg)/(128)))); 
    end
    nimg = imresize(nimg, 128/length(sizeimg)); %*size(nimg)
    
    % get boundaries
    b = bwboundaries(nimg);
    y = b{1}(:,1);
    x = b{1}(:,2);
    
    % translating to mass center
    y = y - mean(y);
    x = x - mean(x);
    
    z = x + i*y;    %z(t) = x(t) + iy(t) --> complex coordinates
    lenz = length(z);
    absz = abs(z);
    
    % starting point invariance - max(abs(z))
    [zmax,pzmax] = max(absz);
    zl(1:lenz-pzmax+1) = z(pzmax:end);
    zl(lenz-pzmax+2:lenz) = z(1:pzmax-1);
    z = zl;

    % discrete fourier transform
    z_fft = fft(z);
    z_descriptors = abs(z_fft);

    N_z = length(z_descriptors);
    if(N_z < N)
        descriptors = z_descriptors;
        descriptors(N_z+1:N) = zeros(1,N-N_z);
    else
        descriptors = z_descriptors(1:N);
    end
end