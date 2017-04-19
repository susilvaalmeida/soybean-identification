function [danos num] = extraicontornos(edges)
 
 %edges = im2bw(edges);
 [obj,num] = bwlabel(1-edges);
 
 for i=1:num
     
     img = obj==i;    
     danos(:,:,i)= img;
     
 end
 
 
  

end