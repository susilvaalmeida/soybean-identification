function corte = recortadanos(danos)

    %danos = im2bw(danos);
    
    [x y] = find(danos==0);
    
    corte = danos(min(x):max(x),min(y):max(y));


end