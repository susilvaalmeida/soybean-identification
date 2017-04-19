function svm_easy_script(featureType)

if ( strcmp(featureType,'cn') )
    t0 = [0.05];
%    t0 = [0.05 0.10 0.15 0.20];
    tq = [0.9];
%    tq = [0.60 0.80 0.90 0.95];
%    nts = [ 2  3  5 10 20 30];
    nts = [5];

%    metrics = {{'K','M','E','H','P'}};
%     metrics = {{'K'},{'M'},{'E'},{'H'},{'P'}, ...
%                {'K','M'},{'K','E'},{'K','H'},{'K','P'},{'M','E'},{'M','H'},{'M','P'},{'E','H'},{'E','P'},{'H','P'}, ...
%                {'K','M','E'},{'K','M','H'},{'K','M','P'},{'K','E','H'},{'K','E','P'},{'K','H','P'},{'M','E','H'},{'M','E','P'},{'M','H','P'},{'E','H','P'}, ...
%                {'K','M','H','P'},{'K','M','E','P'},{'K','M','H','P'},{'K','E','H','P'},{'M','E','H','P'}, ...
%                {'K','M','E','H','P'}};
% 
%     metrics = {{'K'},{'M'},{'K','M'}};        
%     metrics = {{'K','M'}};
% 
%     metrics = {{'E'},{'H'},{'P'},{'E','H'},{'E','P'},{'H','P'}};%,{'E','H','P'}};
     metrics = {{'E','H','P'}};

    it=0;
    for i=1:length(t0)
        for j=1:length(tq)
            for k=1:length(nts)
                for l=1:length(metrics)
                    sm=metrics{l};

                    it=it+1;
                    fprintf(1,'%03d - ',it);fprintf(1,'cn %s %5.3f %5.3f %2d - ',[sm{:}],t0(i),tq(j),nts(k));fprintf(1,'%d ',fix(clock));;fprintf(1,'\n');
                    svm_easy(featureType,{t0(i),tq(j),nts(k),sm});
                end
            end
        end
    end
elseif strcmp(featureType,'fr')
    nSize = [2 3 5 10 15 20 25 30 40 50];
    it=0;
    for i=1:length(nSize)
        it=it+1;        
        fprintf(1,'%03d - ',it);fprintf(1,'fr %03d - ',nSize(i));fprintf(1,'%d ',fix(clock));;fprintf(1,'\n');
        svm_easy(featureType,{nSize(i)});
    end
elseif strcmp(featureType,'wv')
%    base = {{'haar'},{'db2'},{'db3'}};
    base = {{'db3'}};
%    nSize1 = [10 20 30 40 50];      
    nSize1 = [10 20 40 50];
%    pSize2 = [0.10 0.25 0.50 0.75 0.90 1];
    pSize2 = [0.1]; 

    it=0;
    for i=1:length(base)
        bs=base{i};
        for j=1:length(nSize1)
            for k=1:length(pSize2)
                it=it+1;                
                fprintf(1,'%03d - ',it);fprintf(1,'wv %s %03d %03.f - ',[bs{:}],nSize1(j),100*pSize2(k));fprintf(1,'%d ',fix(clock));;fprintf(1,'\n');
                svm_easy(featureType,{[bs{:}],nSize1(j),pSize2(k)});                
            end
        end
    end
elseif strcmp(featureType,'zn')
%    nDegree = [ 1, 2, 3, 4, 5, 6];
%    nDegree = [ 7, 8, 9,10,11,12];
%    nDegree = [ 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12];
    nDegree = [13,14,15,16,17,18];
    it=0;
    for i=1:length(nDegree)
        it=it+1;        
        fprintf(1,'%03d - ',it);fprintf(1,'zn %03d - ',nDegree(i));fprintf(1,'%d ',fix(clock));;fprintf(1,'\n');
        svm_easy(featureType,{nDegree(i)});
    end
end
