function vprob = exdescriptor_cn_jd(img,t,sm)

%    t0 = 0.025;
%    tinc = 0.075;
%    tq = 0.875;
%    t = t0:tinc:tq;
    
    nt = size(t,2);
    ssm = length(sm);
    vprob = zeros([1 ssm*nt]);

    p=0;
    if sum(sm == 'k') p=p+1; pos(1) = p; end
    if sum(sm == 'm') p=p+1; pos(2) = p; end
    if sum(sm == 'e') p=p+1; pos(3) = p; end
    if sum(sm == 'h') p=p+1; pos(4) = p; end
    if sum(sm == 'p') p=p+1; pos(5) = p; end
    
    % creating graph edges - w = descriptor_cn_creategraphedges(img);
    img = im2bw(img); [y x] = find(img==0); nv = size(x,1);
    w = sqrt( (repmat(x',[nv 1])-repmat(x,[1 nv])).^2 + (repmat(y',[nv 1])-repmat(y,[1 nv])).^2 );
    w = w / max(w(:));
    
    for i=1:nt
        % edge removing for t(i)
        a = ones(size(w));
        a(w>=t(i)) = 0;

        % statistics & probabilities
        degree = sum(a); 
        ndegree = length(a);
        
        K = mean(degree/nv); % normalizing the degree to the number of vertices in the graph in order to obtain scale invariance
        M = max(degree/nv);

        mdegree = zeros([ndegree ndegree]);
        [y,x] = find(a==1);
        pm = sub2ind(size(mdegree),degree(y),degree(x));
        pml = unique(pm);
        fpm = histc(pm,1:max(pm));
        mdegree(pml) = fpm(pml);
        mdegree = mdegree / sum(degree);
        
        % computing metrics
        idx = sub2ind(size(mdegree),degree,degree);
        pkl = mdegree(idx);

        H = -sum(pkl.*log2(pkl+eps));
        E = sum(pkl.^2);
        P = mean(pkl);

        if sum(sm == 'k') vprob(ssm*(i-1)+pos(1)) = K; end
        if sum(sm == 'm') vprob(ssm*(i-1)+pos(2)) = M; end
        if sum(sm == 'e') vprob(ssm*(i-1)+pos(3)) = E; end
        if sum(sm == 'h') vprob(ssm*(i-1)+pos(4)) = H; end
        if sum(sm == 'p') vprob(ssm*(i-1)+pos(5)) = P; end
    end
end