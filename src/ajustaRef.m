function nref = ajustaRef(img,ref)

    gray = rgb2gray(img);
    level = graythresh(gray);
    
    bw = im2bw(gray,level);
    
    refbw = im2bw(ref);
    
    
    soma = uint8(im2bw((1-refbw) + (1-bw)));
    edges = edge(soma,'canny');
    
    inter = edges | refbw;
    %inter = 1-inter;
    
    nref = refbw+inter;

end

