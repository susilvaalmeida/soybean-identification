function nova = colore_danos(folha,danos,cor)

    input = ['danos/damostra' int2str(folha) '.bmp'];
    img = imread(input);
    [l c] = size(img);
    total = l*c;
    original = ['normais/amostra' int2str(folha) '.bmp'];
    nova = imread(original);
    img = smallclean(img);
    se = strel('diamond',1);
    [obj,num] = bwlabel(1-img,4);
    
    for j=1:length(danos)
        atual = obj==danos(j);
        nova(find(atual==1)) = cor(j,1);
        nova(find(atual==1)+total) = cor(j,2);
        nova(find(atual==1)+total*2) = cor(j,3);
    end

end
