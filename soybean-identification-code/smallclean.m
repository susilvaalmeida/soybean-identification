function image = smallclean(bw)

[r c] = size(bw);

tam = r*c;
image = bw;
bw = 1-bw;
[objetos, num] = bwlabel(bw);
for i = 1:(num)
    perc = length(find(objetos == i))/tam;
    
    if(perc < 0.0002)
        image(objetos==i) = 255;
    end
end    