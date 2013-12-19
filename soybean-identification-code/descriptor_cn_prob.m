function [mgraus,graus] = descriptor_cn_prob(a)
 
    graus = sum(a);
    ngraus = length(a);

    mgraus = zeros([ngraus ngraus]);
    [y,x] = find(a==1);
    pm = sub2ind(size(mgraus),graus(y),graus(x));
    pml = unique(pm);
    fpm = histc(pm,1:max(pm))
    mgraus(pml) = fpm(pml);
    pgraus = mgraus/sum(graus);

%    mgraus = zeros([ngraus ngraus]);
%    [l c] = size(a)
%    for i=1:l
%        for j=1:c
%            if(a(i,j) == 1)
%                mgraus(graus(i),graus(j)) = mgraus(graus(i),graus(j))+1;
%            end
%        end        
%    end

end