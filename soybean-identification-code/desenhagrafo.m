function grafo = desenhagrafo(img,a)

    img = im2bw(img);
    
    [x y] = find(img==0);
    
    n = size(a);
    n = n(1);
    
    l = size(img);
    
    l = l(2);
   
    for i=1:n
        for j =1:n
            
            if(a(i,j)==1 && i~=j)
                
                img = func_Drawline(img,x(i),y(i),x(j),y(j),0);
                
            end
            
        end
    end
    
    grafo = img(:,1:l);

end