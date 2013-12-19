function areas = smallclean(bw)


bw = 1-bw;
[objetos, num] = bwlabel(bw);

areas = zeros([1 num]);
for i = 1:(num)
    cont = length(find(objetos == i));
    areas(i) = cont;
end
