function [accvector sensitivity,Cc,Cb,Bc,Bb] = svm_validation(matrix,damages,svm_parameters,pfOut)

    [l c] = size(matrix);
    nFeatures = c-3;
    class   = matrix(:,c);
    damage  = matrix(:,c-1);
    samples = matrix(:,c-2);
       
    nFolds = max(damages(:,4));
    vFolds = damages(:,4);
    nSamples = length(find(samples(1:end-1)-samples(2:end)))+1;
    vSamples = samples(find(samples(1:end-1)-samples(2:end)));
    vSamples(end+1) = samples(end); 
    
%    confTest  = zeros([2 2 nSamples]);
    confTest  = zeros([2 2 nFolds]);
%    confTrain = zeros([2 2 nSamples]);
    confTrain = zeros([2 2 nFolds]);
%    acvector  = zeros([1 nSamples]);
    acvector  = zeros([1 nFolds]);
    nsensitivity = zeros([1 2]);

    % leave-N-out, where N is the number of sample in each vSample(i) step
    tic;
    for(k=1:nFolds)
%         img=sprintf('normais/amostra%d.bmp',vSample(i)); 
%         fprintf(1,'testando %s\n',img);        
%         if (exist(img,'file') == 0)
%             fprintf(1,'arquivo nao existe!\n');
%             return
%         end
%     end
    
%    acvector=ones(1,10);sensitivity=ones(2,10);return;
        
%        train = (samples ~= vSamples(k));
        train = (vFolds ~= k);
%        test  = (samples == vSamples(k));
        test  = (vFolds == k);

        fprintf('(%3d - %4d/%2d)',k',length(find(train)),length(find(test)));
        
        mtrain  = matrix(train,1:nFeatures);
        train_class  = class(train);

%        nsamples0=length(find(train_class==0));
%        nsamples1=length(find(train_class==1));
%        if (nsamples0 > nsamples1)
%            svm_parameters = [ svm_parameters sprintf(' -w1 1 -w2 %5.3f',nsamples0/nsamples1) ];
%        else
%            svm_parameters = [ svm_parameters sprintf(' -w1 %5.3f -w2 1',nsamples1/nsamples0) ];
%        end
        
        svmStruct = svmtrain(train_class,mtrain,svm_parameters);

        
        [predicted_class, accuracy, prob_estimates] = svmpredict(train_class, mtrain, svmStruct);
        confaux(1,1) = length(find(predicted_class == train_class & predicted_class == 0));
        confaux(1,2) = length(find(predicted_class ~= train_class & predicted_class == 0));
        confaux(2,1) = length(find(predicted_class ~= train_class & predicted_class == 1));
        confaux(2,2) = length(find(predicted_class == train_class & predicted_class == 1));
        confTrain(:,:,k) = confaux;
        

        test_class = class(test);
        mtest = matrix(test,1:nFeatures);
        [predicted_class, accuracy, prob_estimates] = svmpredict(test_class, mtest, svmStruct);

        acvector(k)=length(find(predicted_class==test_class));
        ttvector(k)=length(test_class);
       
%        for n=1:length(test_class)
%            confaux(predicted_class(n)+1,test_class(n)+1) = confaux(predicted_class(n)+1,test_class(n)+1)+1;
%        end

        % TP - true positive, FP - false positive, FN - false negative, TN - true negative
        % expected/observed
        % TP FN  Cc Cb 
        % FP TN  Bc Bb
        confaux(1,1) = length(find(predicted_class == test_class & predicted_class == 0));
        confaux(1,2) = length(find(predicted_class ~= test_class & predicted_class == 1));
        confaux(2,1) = length(find(predicted_class ~= test_class & predicted_class == 0));
        confaux(2,2) = length(find(predicted_class == test_class & predicted_class == 1));
        confTest(:,:,k) = confaux;
       
       % sensitivity = TP / (TP + FN) - the number of actual positive samples
       % specificify = TN / (TN + FP) - the number of actual negative samples
        if ( (confaux(1,1) + confaux(1,2)) ~= 0)
            sensitivity(1,k) = confaux(1,1) / (confaux(1,1) + confaux(1,2));
            nsensitivity(1) = nsensitivity(1) + 1;
        else
            sensitivity(1,k) = -1;
        end
        if ( (confaux(2,2) + confaux(2,1)) ~= 0)
            sensitivity(2,k) = confaux(2,2) / (confaux(2,2) + confaux(2,1));
            nsensitivity(2) = nsensitivity(2) + 1;
        else
            sensitivity(2,k) = -1;
        end

        sTmp=sprintf(' acc: %3d/%6.2f%%, sen1: %6.2f%%, sen2: %6.2f%%, Cc: %4d, Cb: %4d, Bc: %4d, Bb: %4d\n',...
            acvector(k),acvector(k)/ttvector(k)*100, ...
            100*sensitivity(1,k),100*sensitivity(2,k), ...
            confaux(1,1),confaux(1,2),confaux(2,1),confaux(2,2));
        sTmp=strrep(sTmp,'-100.00%','------%');
        fprintf(1,'%s',sTmp);
        
%        clear mcolore;
%        mcolore(1,:) = damage(test)';
%        mcolore(2,:) = test_class'; % expected
%        mcolore(3,:) = predicted_class'; % observed
%        colore_folha(vSamples(k),sprintf('images/normais/amostra%d.bmp',vSamples(k)),mcolore);
    end
    elapsedtime=toc;
    fprintf(1,'\n');
        
    % TP FN  Cc Cb 
    % FP TN  Bc Bb
    
    Cc = confTest(1,1,:); Cc = Cc(:);
    Cb = confTest(1,2,:); Cb = Cb(:);
    Bc = confTest(2,1,:); Bc = Bc(:);
    Bb = confTest(2,2,:); Bb = Bb(:);
    
    confTestMean(1,1) = mean(Cc);confTestMean(1,2) = mean(Cb);confTestMean(2,1) = mean(Bc);confTestMean(2,2) = mean(Bb);
    confTestStd (1,1) = std (Cc);confTestStd (1,2) = std (Cb);confTestStd (2,1) = std (Bc);confTestStd (2,2) = std (Bb);

    accvector = acvector ./ ttvector;
    
    fprintf(1,'Leaves: Accuracy: %6.2f(%3.1f), ',100*mean(accvector),100*std(accvector));
%    fprintf(1,'ConfMatrix: (11)%5.1f(%4.1f) (12)%5.1f(%4.1f) (21)%5.1f(%4.1f) (22)%5.1f(%4.1f), ' ...
%       ,confMean(1,1),confStd(1,1) ...
%       ,confMean(1,2),confStd(1,2) ...
%       ,confMean(2,1),confStd(2,1) ...
%       ,confMean(2,2),confStd(2,2) );
    fprintf(1,'Sensitivity(1/2): %5.1f(%4.1f) / %5.1f(%4.1f), ' ...
       ,100*mean(sensitivity(1,sensitivity(1,:)~=-1)),100*std(sensitivity(1,sensitivity(1,:)~=-1)) ...
       ,100*mean(sensitivity(2,sensitivity(2,:)~=-1)),100*std(sensitivity(2,sensitivity(2,:)~=-1)) );

   fprintf(1,'elapsedtime: %.2f secs',elapsedtime);
    fprintf(1,'\n');
    
%     fprintf(1,'%d;%d;%0.3f;%0.3f;%0.3f;%0.3f;%0.3f;%0.3f;%0.3f;%0.3f;%0.3f;%0.3f\n', ...
%         nFeatures,sum(acvector), ...
%         100*mean(acvector ./ ttvector),100*std(acvector ./ ttvector), ...
%         confTestMean(1,1),confTestMean(1,2),confTestMean(2,1),confTestMean(2,2),confTestStd(1,1),confTestStd(1,2),confTestStd(2,1),confTestStd(2,2) );

    fprintf(1,'Confusion Matrix of damages\n');
    fprintf(1,'R\\A\t Cat\t Bee\nCat\t%4d\t%4d\nBee\t%4d\t%4d\n\n',sum(Cc),sum(Cb),sum(Bc),sum(Bb));

    fprintf(1,'R\\A\t Cat\t Bee\nCat\t%6.2f%%\t%6.2f%%\nBee\t%6.2f%%\t%6.2f%%\n\n',...
        100*sum(Cc)/sum(Cc+Cb),100*sum(Cb)/sum(Cc+Cb),...
        100*sum(Bc)/sum(Bc+Bb),100*sum(Bb)/sum(Bc+Bb));

%     fprintf(1,'Treino\n');
%     fprintf(1,'\t Col\t Lag\nCol\t %4d\t%4d\nLag\t %4d\t%4d\n\n',confTrainSum(1,1),confTrainSum(1,2),confTrainSum(2,1),confTrainSum(2,2));
%     confTrainSum(:,1) = confTrainSum(:,1)/(confTrainSum(1,1)+confTrainSum(2,1));
%     confTrainSum(:,2) = confTrainSum(:,2)/(confTrainSum(1,2)+confTrainSum(2,2));
%     fprintf(1,'%6.2f%%\t%6.2f%%\n%6.2f%%;%6.2f%%\n\n',confTrainSum(1,1),confTrainSum(1,2),confTrainSum(2,1),confTrainSum(2,2));
    
end