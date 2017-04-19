function descriptors = descriptor_wv(img,base,nSize1,pSize2)

    % being sure that image is binary
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

    ay = y;
    ax = x; % level 0    
    while(length(ax)>=nSize1)
        [ay dy] = dwt(ay,base);
        [ax dx] = dwt(ax,base);
    end

    z = ax + i*ay;    %z(t) = x(t) + iy(t) --> complex coordinates
    mt = sort(abs(z),'descend');
    mt = mt';

    nSizeT = length(mt);
    nSize2 = round(nSize1*pSize2);
    if(nSizeT<nSize2)
    	descriptors = mt;
        descriptors(nSizeT+1:nSize2) = zeros(1,nSize2-nSizeT);
   	else
   		descriptors = mt(1:nSize2);
    end
    descriptors = descriptors/max(descriptors);
end