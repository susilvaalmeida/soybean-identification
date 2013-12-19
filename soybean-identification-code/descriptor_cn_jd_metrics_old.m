function [H,E,P] = descriptor_cn_jd_metrics(a)

    [matrix,degree] = prob(a);
    N  = length(degree);
    
    H = 0; % Entropy
    E = 0; % Energy
    P = 0; % Average Joint Degree

    idx = sub2ind(size(matrix),degree,degree);
    pkl = matrix(idx);
  
    H = -sum(pkl.*log2(pkl+eps));
    E = sum(pkl.^2);
    P = mean(pkl);
    
end