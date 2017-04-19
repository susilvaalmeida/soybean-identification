function image = removeFundo(IMG,ref)

IMG = removeNoize(IMG);
gray = rgb2gray(IMG);
level = graythresh(gray);
bw = im2bw(gray,level);
maior =1;
image = bw;

bw = bw & ref;

[objetos, num] = bwlabel(bw);
for i = 1:(num)
    cont = length(find(objetos == i));
    if((cont > length(find(objetos ==maior))))
        maior = i;
    end
end

%image(objetos ~= maior,:) = 255;

s=size(image);
 for i = 1:(s(1))
     for j = 1:(s(2))
         if(objetos(i,j) == maior)
             
             image(i,j) = 0;
             
         end
     end
 end
 
 image = 1 - image;


	
