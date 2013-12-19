function vdegree = descriptor_cn_dg(img,t)
   
    n = size(t);
    n = n(2);
    
    vdegree = zeros([1 2*n]);
    
    for i=1:n
        
        w = geragrafo(img);
        a = removearestas(w,t(i));
        
        v = degree(a,img);
        k = v(:,3);       

        vdegree((2*i)-1)=mean(k);
        vdegree(2*i) = max(k);
    end
end