function feature_extract_script(featureType)

if strcmp(featureType,'cn_jd') || strcmp(featureType,'cn_dg')
    %t0 = [0.1];
    t0 = [0.05 0.10 0.15 0.20];
%    tq = [0.9];
    tq = [0.60 0.80 0.90 0.95];
    nts = [ 2  3  5 10 20 30];
    if strcmp(featureType,'cn_jd')
%        metrics = {{'E'},{'H'},{'P'},{'E','H'},{'E','P'},{'H','P'},{'E','H','P'}};
        metrics = {{'E','H','P'}};
    elseif strcmp(featureType,'cn_jd')
        metrics = {{'K'},{'M'},{'K','M'}};
    end

    it=0;
    for i=1:length(t0)
        for j=1:length(tq)
            for k=1:length(nts)
                for l=1:length(metrics)
                    sm=metrics{l};
                    svm_parameters = sprintf('-s 0 -t 2 -g %f -c 5',1/(8*(3*nts(k))));
                    [filename,parOut]=getFeatureDetails(featureType,{t0(i),tq(j),nts(k),sm});
                    save(['svm_' filename],'svm_parameters');
                end
            end
        end
    end
elseif strcmp(featureType,'zernike')
    D = [1,2,3,4,5,6];
    for i=1:length(D)
        feature_extraction(featureType,D(i));
    end
end