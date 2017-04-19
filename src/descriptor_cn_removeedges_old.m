function a = descriptor_cn_jd_removeedges(w,t)

    a = ones(size(w));
    [l, j] = size(w);
    
%     for i=1:l
%         a(i,i) =0;
%     end
    
    a(w>=t) = 0;
    

end