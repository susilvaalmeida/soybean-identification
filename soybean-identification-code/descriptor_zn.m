function vetor = descriptor_zn(img,n)
% m is determined from n 

nimg = img(:,:,1);
nimg = ~nimg;

[y x] = find(nimg);

centx = sum(x)/length(x);
centy = sum(y)/length(y);

dist = sqrt( (x-repmat(centx,length(x),1)).^2 + (y-repmat(centx,length(y),1)).^2 );
R=ceil(max(dist));

%[znames, zvalues] = descriptor_zernike_mb(nimg,n,R);
% filling the holes
nimg=imfill(nimg,round(sub2ind(size(nimg),centy,centx)));
[znames, zvalues] = descriptor_zernike_mb(nimg,n,R);

vetor = abs(zvalues);
