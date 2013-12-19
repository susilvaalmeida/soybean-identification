function rna_validation(arq1)

    load(arq1, 'matrix');
    
    labels = (matrix(:,end))';
    
    matrix = matrix(:,1:end-3);
    
    [l c] = size(matrix);
    ncarac = c;
    
    arq = fopen('feat_6\results-rna.csv','a');
    
    fprintf(arq,[arq1,';']);

    i = crossvalind('kfold',l,10);
    macctrain =0;
    macctest = 0;

    actrain =0;
    actest =0;
   
    confTest = zeros([2 2 10]);
    confaux =zeros([2 2]);

    acvector = zeros([1 10]);
    sizeparts = zeros(1,10);
    tic;
    
    for k=1:10
        if (k~=1) fprintf(1,', '); end
        fprintf('(%d)',k');
        train = i~=k;
        test = i ==k;
        
        sizeparts(k) = sum(test);
        confaux =zeros([2 2]);
        
        TR = struct('P',{matrix(train,:)'},'T',{labels(train)});
        VR = struct('P',{matrix(test,:)'},'T',{labels(test)});
        
        [net,rec,confaux] = RNA(TR,VR);
        confaux
        confTest(:,:,k) = confaux;
       
        sensitivity(1,k) = confaux(1,1) / (confaux(1,1) + confaux(1,2));
        sensitivity(2,k) = confaux(2,2) / (confaux(2,2) + confaux(2,1));
    end
    elapsedtime=toc;
    fprintf(1,'\n');
        
    confMean = zeros([2 2]);
    confStd = zeros([2 2]);
    for l=1:2
        for m=1:2
            confMean(l,m) = mean(confTest(l,m,:));
            confStd(l,m) = std(confTest(l,m,:));
        end
    end

%    fprintf(1,'Accuracy: %6.2f(%3.1f), ',100*mean(acvector),100*std(acvector));
    fprintf(1,'Accuracy: %6.2f, ',(confMean(1,1)+confMean(2,2))*100/2);
%    fprintf(1,'ConfMatrix: (11)%5.1f(%4.1f) (12)%5.1f(%4.1f) (21)%5.1f(%4.1f) (22)%5.1f(%4.1f), ' ...
%       ,confMean(1,1),confStd(1,1) ...
%       ,confMean(1,2),confStd(1,2) ...
%       ,confMean(2,1),confStd(2,1) ...
%       ,confMean(2,2),confStd(2,2) );
    fprintf(1,'Sensitivity(1/2): %5.1f(%4.1f) / %5.1f(%4.1f), ' ...
       ,100*mean(sensitivity(1,:)),100*std(sensitivity(1,:)) ...
       ,100*mean(sensitivity(2,:)),100*std(sensitivity(2,:)) );

%    confMean
%    confStd

    fprintf(1,'elapsedtime: %.2f secs',elapsedtime);
    fprintf(1,'\n');

%    fprintf(arq,'%d;%d;%0.3f;%0.3f;%0.3f;%0.3f;%0.3f;%0.3f;%0.3f;%0.3f;%0.3f;%0.3f\n',ncarac,actest,macctest,desvio,confMean(1,1),confMean(1,2),confMean(2,1),confMean(2,2),confStd(1,1),confStd(1,2),confStd(2,1),confStd(2,2));

    fclose(arq);
   
%     arq = fopen('conf.csv','a');
%     fprintf(arq,'Teste\n');
%     fprintf(arq,';Col;Lag\nCol;%d;%d\nLag;%d;%d\n\n',confTest(1,1),confTest(1,2),confTest(2,1),confTest(2,2));
%     confTest(:,1) = confTest(:,1)/(confTest(1,1)+confTest(2,1));
%     confTest(:,2) = confTest(:,2)/(confTest(1,2)+confTest(2,2));
%     fprintf(arq,'%f;%f\n%f;%f\n\n',confTest(1,1),confTest(1,2),confTest(2,1),confTest(2,2));
%    
%     fprintf(arq,'Treino\n');
%     fprintf(arq,';Col;Lag\nCol;%d;%d\nLag;%d;%d\n\n',confTrain(1,1),confTrain(1,2),confTrain(2,1),confTrain(2,2));
%    
%     confTrain(:,1) = confTrain(:,1)/(confTrain(1,1)+confTrain(2,1));
%     confTrain(:,2) = confTrain(:,2)/(confTrain(1,2)+confTrain(2,2));
%     fprintf(arq,'%f;%f\n%f;%f\n\n',confTrain(1,1),confTrain(1,2),confTrain(2,1),confTrain(2,2));
%    
%    
%    
%     fclose(arq); 
   
end