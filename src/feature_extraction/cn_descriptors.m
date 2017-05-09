%Extract descriptors (connectivity and joint degree) using complex network of damages contours
%   descriptors = cn_descriptors(damage_img,thresholds,feature_types) extracts connectivity or/and joint degree, modeling the damage contour as a complex network
%       damage_img -- binary image with one damage
%       thresholds -- initial and final thresholds and number of intervals of dynamic evolution 
%       feature_type -- features to extract from complex network (individual or group)
%           options:
%               k (connectivity average degree)
%               m (connectivity maximum degree)
%               h (joint degree entropy)
%               e (joint degree energy)
%               p (joint degree average)
%
%Author:
%   Suellen Almeida <susilvaalmeida@gmail.com>

function descriptors = cn_descriptors(damage_img,thresholds,feature_types)
    t0 = thresholds(1); % initial threshould
    tq = thresholds(2); % final threshould
    nts = thresholds(3); % number of intervals

    tinc = (tq-t0) / (nts-1);
    tl = t0 + (0:nts-1) * tinc;

    size_tl = size(tl,2);
    num_features = length(feature_types);
    descriptors = zeros([1 num_features*size_tl]);

    p=0;
    if sum(feature_types == 'k') p=p+1; pos(1) = p; end
    if sum(feature_types == 'm') p=p+1; pos(2) = p; end
    if sum(feature_types == 'e') p=p+1; pos(3) = p; end
    if sum(feature_types == 'h') p=p+1; pos(4) = p; end
    if sum(feature_types == 'p') p=p+1; pos(5) = p; end
    
    % creating graph edges
    img = im2bw(damage_img); 
    [y x] = find(img==0); 
    num_vertices = size(x,1);
    w = sqrt( (repmat(x',[num_vertices 1])-repmat(x,[1 num_vertices])).^2 + (repmat(y',[num_vertices 1])-repmat(y,[1 num_vertices])).^2 );
    w = w / max(w(:));
    
    % dynamic evolution
    for i=1:size_tl
        % edge removing for t(i)
        a = ones(size(w));
        a(w>=tl(i)) = 0;

        % statistics & probabilities
        degree = sum(a); 
        ndegree = length(a);
        
        K = mean(degree/num_vertices); % normalizing the degree to the number of vertices in the graph in order to obtain scale invariance
        M = max(degree/num_vertices);

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

        if sum(feature_types == 'k') descriptors(num_features*(i-1)+pos(1)) = K; end
        if sum(feature_types == 'm') descriptors(num_features*(i-1)+pos(2)) = M; end
        if sum(feature_types == 'e') descriptors(num_features*(i-1)+pos(3)) = E; end
        if sum(feature_types == 'h') descriptors(num_features*(i-1)+pos(4)) = H; end
        if sum(feature_types == 'p') descriptors(num_features*(i-1)+pos(5)) = P; end
    end
end