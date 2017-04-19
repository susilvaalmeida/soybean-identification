function classe = discfunction(img,c1,c2,l1,l2, u1, u2)
    
    x = degreevector2(img);
    
%    p1 = 630/1530;
%    p2 = 900/1530;

    p1 = l1/(l1+l2);
    p2 = l2/(l1+l2);
  
    C =p1.*c1 + p2.*c2;
    
    f1 = u1*inv(C)*(x') - 1/2*u1*inv(C)*(u1')+log(p1);
    f2 = u2*inv(C)*(x') - 1/2*u2*inv(C)*(u2')+log(p2);
    
    if(f1>f2)
        classe = 'coleoptero';
    else
        classe = 'lagarta';
    end
end