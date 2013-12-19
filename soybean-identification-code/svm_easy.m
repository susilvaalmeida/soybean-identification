function svm_easy(featureType,parameters)
directoryFeatures   = './features/';
directoryParameters = './parameters-opt/';

[filename,parOut]=getFeatureDetails(featureType,parameters);

load([directoryFeatures  filename '.mat'],'matrix');

nFeatures = size(matrix,2)-3;
target = matrix(:,nFeatures+3);
data   = matrix(:,1:nFeatures);


% Pre-process data
%[data2,row_factor] = removeconstantrows(data');
%[data2,col_factor,temp] = unique(data2','rows');

% Scaling data
% instance_matrix =
% (instance_matrix-repmat(min(instance_matrix,[],1),size(instance_matrix,1),1))./(repmat(max(instance_matrix,[],1)-min(instance_matrix,[],1),size(instance_matrix,1),1));
%[data2,scale_factor] = mapminmax(data2');   
%data2 = data2';
% [instance_matrix2,scale_factor] = mapstd(instance_matrix2');  
%target2 = target(col_factor);

% Cross validation 
%[best_c,best_g,best_cv,hC] = svm_modsel_balanced(target2,data2);
[X,Y,Z,hC,best_c,best_g] = svm_modsel_imbalanced(target,data);
saveas(hC,[directoryParameters 'svm_' filename],'eps') 

% --- define svm options ---
svm_type    = 0;       % epsilon SVM -- C-svm
kernel_type = 2;       % RBF kernel: exp(-gamma*|u-v|^2)
gamma       = best_g;  % 'width' of the Gaussian basis function
cost        = best_c;  % C parameter in loss function
%epsilon     = 0.1;     % epsilon parameter in loss function

svm_parameters = ['-s ', num2str(svm_type),...
 ' -t ', num2str(kernel_type),...
 ' -g ', num2str(gamma),...
 ' -c ', num2str(cost)];
% ' -p ', num2str(epsilon)];
 
save ([directoryParameters 'svm_' filename],'svm_parameters');

% --- solve the problem ---
fprintf('Starting LIBSVM\n');
tic;
model = svmtrain(target, data, svm_parameters);
fprintf('Optimization finished in %3.2f sec\n',toc);

%%% --- pre-process test data ---
%data = removeconstantrows('apply',removeconstantrows(data'),row_factor);
%data = mapminmax('apply',data,scale_factor);
%data = data';
%% instance_matrix = mapstd('apply',instance_matrix,scale_factor);

% --- generalize solution ---
[pred_label accuracy decision_val] = svmpredict(target, data, model);
fprintf('Final accuracy: %f+-%f\n',accuracy(1),accuracy(2));