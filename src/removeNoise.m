function image = removeNoize(IMG)

gray = offshadow(IMG);
level = graythresh(gray);
bw = im2bw(gray,level);
image = IMG;
maior =1;
imtemp = 1-bw;

[objetos, num] = bwlabel(imtemp);
for i = 1:(num)
    cont = length(find(objetos == i));
    if((cont > length(find(objetos ==maior))))
        maior = i;
    end
end



s=size(image);
 for i = 1:(s(1))
     for j = 1:(s(2))
         if(objetos(i,j) ~= maior)
             image(i,j,1) = 255;
             image(i,j,2) = 255;
             image(i,j,3) = 255;
         end
     end
 end
    




	
