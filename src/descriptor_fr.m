function descriptors = descriptor_fr(img,nSize)

    nimg = img(:,:,1);
    nimg = ~nimg; 
    sizeimg = find(nimg);

    % resing normalization
    if(128/length(sizeimg) < 1) nimg = imdilate(nimg, strel('square',ceil(length(sizeimg)/(128)))); end
    nimg = imresize(nimg, 128/length(sizeimg)); %*size(nimg)
    
    b = boundaries(nimg);
    y = b{1}(:,1);
    x = b{1}(:,2);
    
    % translating to mass center
    y = y - mean(y);
    x = x - mean(x);
    
    z = x + i*y;    %z(t) = x(t) + iy(t) --> complex coordinates
    tam = length(z);
    zm = abs(z);
    
    % starting point invariance - max(abs(z))
    [zmax,pzmax]=max(zm);
    zl(1:tam-pzmax+1) = z(pzmax:end);
    zl(tam-pzmax+2:tam) = z(1:pzmax-1);
    z = zl;

    zt = fft(z);
    mt = abs(zt);

    nSizeT = length(mt);
    if(nSizeT<nSize)
    	descriptors = mt;
        descriptors(nSizeT+1:nSize) = zeros(1,nSize-nSizeT);
   	else
   		descriptors = mt(1:nSize);
    end
end