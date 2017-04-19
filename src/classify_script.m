function [acvector sensitivity]=classify_script(tClassifier,featureType)
directoryFeatures   = 'features/';
directoryParameters = 'parameters/';
directoryResults    = 'results/';

if ( strcmp(featureType,'cn')~=1 &&  strcmp(featureType,'fr')~=1 && strcmp(featureType,'wv')~=1 && strcmp(featureType,'zn')~=1 )
    fprintf(1,'Features type invalid!\n');
    return;
end

if ( strcmp(upper(tClassifier),'SVM')~=1 && strcmp(upper(tClassifier),'ANN')~= 1 )
    fprintf(1,'Classifier type invalid!\n');
    return;
end


fOut    = fopen([directoryResults tClassifier '_' featureType '.csv'],'w');
fOutTex = fopen([directoryResults tClassifier '_' featureType '.tex'],'w');
fprintf(fOut,'file;ncarac; n acertos;%% acertos;desvio;mean_conf(00);mean_conf(01);mean_conf(10);mean_conf(11);std_conf(00);std_conf(01);std_conf(10);std_conf(11)\n');


if strcmp(featureType,'cn')
%    t0 = [0.05 0.10 0.15 0.20];
%    tq = [0.60 0.80 0.90 0.95];
%    nts = [ 2  3  5 10 20 30];
    t0 = [0.1];
    tq = [0.9];
    nts = [ 5 ];


%     metrics = {{'K','M','E','H','P'}};
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

%     metrics = {{'K','M','E','H','P'},{'E','H','P'},{'K','M'}};
 
    it=0;
    for i=1:length(t0)
        for j=1:length(tq)
            fprintf(fOutTex,'%4.2f & %4.2f ',t0(i),tq(j));
            for k=1:length(nts)
                for l=1:length(metrics)
                    it=it+1;

                    [filename,parOut]=getFeatureDetails(featureType,{t0(i),tq(j),nts(k),metrics{l}});

                    load([directoryFeatures  filename '.mat'],'matrix');
                    load([directoryFeatures  'folders' '.mat'],'damages','leaves','pool');
                    load([directoryParameters 'svm_' filename '.mat'],'svm_parameters');

                    [accuracy sensitivity,Cc,Cb,Bc,Bb] = svm_validation(matrix,damages,svm_parameters,fOut);

                    fprintf(fOutTex,'& %5.1f & (%3.1f) & %5.1f & %5.1f ',... % & %4d & %4d & 4d & 4d &',...
                        100*mean(accuracy),100*std(accuracy), ...
                        100*mean(sensitivity(1,sensitivity(1,:)~=-1)), ...
                        100*mean(sensitivity(2,sensitivity(2,:)~=-1))); %, ...
                        %sum(Cc),sum(Cb),sum(Bc),sum(Bb));
                        
                    save ([directoryResults 'svm_' filename],'Cc','Cb','Bc','Bb');
                end
            end
            fprintf(fOutTex,'\\\\ \n');
        end
    end
    
elseif strcmp(featureType,'fr')
    nSize = [2 3 5 10 15 20 25 30 40 50];
    it=0;
    for i=1:length(nSize)
        it=it+1;

        [filename,parOut]=getFeatureDetails(featureType,{nSize(i)});

        load([directoryFeatures  filename '.mat'],'matrix');
        load([directoryParameters 'svm_' filename '.mat'],'svm_parameters');

        fprintf(1,'%03d - ',it);fprintf(1,'fr %03d - ',nSize(i));fprintf(1,'%d ',fix(clock));;fprintf(1,'\n');
        [accuracy sensitivity,Cc,Cb,Bc,Bb] = svm_validation(matrix,svm_parameters,fOut);

        fprintf(fOutTex,'& %5.1f & (%3.1f) & %5.1f & %5.1f ',... % & %4d & %4d & 4d & 4d &',...
            100*mean(accuracy),100*std(accuracy), ...
            100*mean(sensitivity(1,sensitivity(1,:)~=-1)), ...
            100*mean(sensitivity(2,sensitivity(2,:)~=-1))); %, ...
            %sum(Cc),sum(Cb),sum(Bc),sum(Bb));

        save ([directoryResults 'svm_' filename],'Cc','Cb','Bc','Bb');
    end
    fprintf(fOutTex,'\\\\ \n');

elseif strcmp(featureType,'wv')
    base = {{'haar'},{'db2'},{'db3'}};
%    nSize1 = [10 20 30 40 50];      
    nSize1 = [10 20 40 50];      
    pSize2 = [0.10 0.25 0.50 0.75 0.90 1];

    it=0;
    for i=1:length(base)
        bs=base{i};
        for j=1:length(nSize1)
            for k=1:length(pSize2)
                it=it+1;                

                [filename,parOut]=getFeatureDetails(featureType,{[bs{:}],nSize1(j),pSize2(k)});
                load([directoryFeatures  filename '.mat'],'matrix');
                load([directoryParameters 'svm_' filename '.mat'],'svm_parameters');

                fprintf(1,'%03d - ',it);fprintf(1,'%s %03d %03.0f - ',[bs{:}],nSize1(j),100*pSize2(k));fprintf(1,'%d ',fix(clock));;fprintf(1,'\n');
                [accuracy sensitivity,Cc,Cb,Bc,Bb] = svm_validation(matrix,svm_parameters,fOut);

                fprintf(fOutTex,'& %5.1f & (%3.1f) & %5.1f & %5.1f ',... % & %4d & %4d & 4d & 4d &',...
                    100*mean(accuracy),100*std(accuracy), ...
                    100*mean(sensitivity(1,sensitivity(1,:)~=-1)), ...
                    100*mean(sensitivity(2,sensitivity(2,:)~=-1))); %, ...
                    %sum(Cc),sum(Cb),sum(Bc),sum(Bb));

                save ([directoryResults 'svm_' filename],'Cc','Cb','Bc','Bb');
            end
            fprintf(fOutTex,'\\\\ \n');
        end
    end

elseif strcmp(featureType,'zn')
%    nDegree = [1,2,3,4,5,6,7,8,9,10,11,12];
    nDegree = [13,14,15,16,17,18];
    it=0;
    for i=1:length(nDegree)
        it=it+1;

        [filename,parOut]=getFeatureDetails(featureType,{nDegree(i)});

        load([directoryFeatures  filename '.mat'],'matrix');
        load([directoryParameters 'svm_' filename '.mat'],'svm_parameters');

        fprintf(1,'%03d - ',it);fprintf(1,'zn %03d - ',nDegree(i));fprintf(1,'%d ',fix(clock));;fprintf(1,'\n');
        [accuracy sensitivity,Cc,Cb,Bc,Bb] = svm_validation(matrix,svm_parameters,fOut);

        fprintf(fOutTex,'& %5.1f & (%3.1f) & %5.1f & %5.1f ',... % & %4d & %4d & 4d & 4d &',...
            100*mean(accuracy),100*std(accuracy), ...
            100*mean(sensitivity(1,sensitivity(1,:)~=-1)), ...
            100*mean(sensitivity(2,sensitivity(2,:)~=-1))); %, ...
            %sum(Cc),sum(Cb),sum(Bc),sum(Bb));

        save ([directoryResults 'svm_' filename],'Cc','Cb','Bc','Bb');
    end
    fprintf(fOutTex,'\\\\ \n');
end
    
fclose(fOut);
fclose(fOutTex);