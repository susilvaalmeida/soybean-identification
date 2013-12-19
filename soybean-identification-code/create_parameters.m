function feature_extract_script(featureType)
directoryParameters = 'parameters\';

if strcmp(featureType,'cn')
%    t0 = [0.05];
    t0 = [0.05 0.10 0.15 0.20];
%    tq = [0.1 0.2 0.4];
    tq = [0.60 0.80 0.90 0.95];
%    nts = [ 2  3  5 10 20 30];
    nts = [ 5 ];

%     metrics = {{'K','M','E','H','P'}};
%     metrics = {{'K'},{'M'},{'E'},{'H'},{'P'}, ...
%                {'K','M'},{'K','E'},{'K','H'},{'K','P'},{'M','E'},{'M','H'},{'M','P'},{'E','H'},{'E','P'},{'H','P'}, ...
%                {'K','M','E'},{'K','M','H'},{'K','M','P'},{'K','E','H'},{'K','E','P'},{'K','H','P'},{'M','E','H'},{'M','E','P'},{'M','H','P'},{'E','H','P'}, ...
%                {'K','M','H','P'},{'K','M','E','P'},{'K','M','H','P'},{'K','E','H','P'},{'M','E','H','P'}, ...
%                {'K','M','E','H','P'}};
% 
     metrics = {{'K'},{'M'}};%,{'K','M'}};        
%     metrics = {{'K','M'}};        
% 
%     metrics = {{'E'},{'H'},{'P'},{'E','H'},{'E','P'},{'H','P'}};%,{'E','H','P'}};
%     metrics = {{'E','H','P'}};

%     metrics = {{'K','M','E','H','P'},{'E','H','P'},{'K','M'}};

    it=0;
    for i=1:length(t0)
        for j=1:length(tq)
            for k=1:length(nts)
                for l=1:length(metrics)
                    sm=metrics{l};
                    svm_parameters = sprintf('-s 0 -t 2 -g %f -c 5',1/(8*(length(sm)*nts(k))));
                    [filename,parOut]=getFeatureDetails(featureType,{t0(i),tq(j),nts(k),sm});
                    save([directoryParameters 'svm_' filename],'svm_parameters');
                end
            end
        end
    end
elseif strcmp(featureType,'fr')
    nSize = [2 3 5 10 15 20 25 30 40 50];
    for i=1:length(nSize)
        svm_parameters = sprintf('-s 0 -t 2 -g %f -c 5',1/(8*(nSize(i))));
        [filename,parOut]=getFeatureDetails(featureType,{nSize(i)});
        save([directoryParameters 'svm_' filename],'svm_parameters');
    end
elseif strcmp(featureType,'wv')
    base = {{'haar'},{'db2'},{'db3'}};
    nSize1 = [10 20 30 40 50];      
    pSize2 = [0.10 0.25 0.50 0.75 0.90 1];

    it=0;
    for i=1:length(base)
        bs=base{i};
        for j=1:length(nSize1)
            for k=1:length(pSize2)
                it=it+1;                
                svm_parameters = sprintf('-s 0 -t 2 -g %f -c 5',1/(8*round(nSize1(j)*pSize2(k))) );
                [filename,parOut]=getFeatureDetails(featureType,{[bs{:}],nSize1(j),pSize2(k)});
                save([directoryParameters 'svm_' filename],'svm_parameters');
            end
        end
    end
elseif strcmp(featureType,'zn')
%    nDegree = [ 1, 2, 3, 4, 5, 6];
%    nDegree = [ 7, 8, 9,10,11,12];
    nDegree = [13,14,15,16,17,18];
    for i=1:length(nDegree)
        svm_parameters = sprintf('-s 0 -t 2 -g %f -c 5',1/(8*(nDegree(i))));
        [filename,parOut]=getFeatureDetails(featureType,{nDegree(i)});
        save([directoryParameters 'svm_' filename],'svm_parameters');
    end
end