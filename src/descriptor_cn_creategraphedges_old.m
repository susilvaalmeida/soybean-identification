function w = descriptor_cn_creategraph(corte)
    corte = im2bw(corte);
    [y x] = find(corte==0);
    n = size(x,1);
    
    w = sqrt( (repmat(x',[n 1])-repmat(x,[1 n])).^2 + (repmat(y',[n 1])-repmat(y,[1 n])).^2 );
    w = w / max(w(:));
end


