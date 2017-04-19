function v = degree(a,img)

    [y x] = find(img==0);

    n = size(a);
    n = n(1);
    v = zeros([n 3]);
    
    k = zeros([1 n]);
    
    for i=1:n
        
        k(i) = sum(a(i,:))/n; %NORMALIZAÇÃO
        v(i,:) = [x(i) y(i) k(i)];
        
    end
    

end