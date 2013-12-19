function vetor = wavelet_descriptor(img)

    nimg = img(:,:,1);
    nimg = ~nimg; 

    b = boundaries(nimg);
    [y x] = b{1}
   
    [ax dx] = dwt(x,'haar');
    [ay dy] = dwt(y,'haar');
   
    while(length(ax)>40)
        [ax dx] = dwt(ax, 'haar'); 
        [ay dy] = dwt(ay,'haar');
    end
    
    %centroides
    bx = sum(ax)/length(ax);
    by = sum(ay)/length(ay);

    z = (ax-bx) + i*(ay-by);    %z(t) = x(t) + iy(t) --> complex coordinates
    z = sort(abs(z));
    
    tam = length(z);
    vetor = z(tam-19:tam)';
end