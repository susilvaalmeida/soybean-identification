function [net,rec,confm]=RNA(TR,VR)

global threshold

net_in = size(TR.P,1);

%% Iniciar a Rede Neural
%net=newff( TR.P,TR.T,[ceil((2/3)*(net_in+1)) 1], {'tansig' 'tansig' 'logsig'}, 'trainlm' ); %trainlm
net=newff( TR.P,TR.T,2*(net_in+1), {'tansig' 'tansig'}, 'trainlm' ); %trainlm

%% Parâmetros de treinamento da Rede Neural
net.performFcn = 'mse';
net.trainParam.epochs = 500;
net.trainParam.goal = 1e-2;
net.trainParam.lr = 0.005;
net.trainParam.lr_inc = 1.05;
net.trainParam.lr_dec = 0.7;
net.trainParam.show = 50;
net.trainParam.mc = 0.9;
%net.trainParam.min_grad = 1e-3;
net.trainParam.max_perf_inc = 1.04;
net.trainParam.showWindow = false; % window desapears
%net.trainParam.showCommandLine = true
%net.trainParam.ValidationCheck = 5;

[net,rec]=train(net,TR.P,TR.T,[],[],VR);
[outNetVV,x,y,err1,perf]=sim(net,VR.P,[],[],VR.T);
%[outNetTT,x,y,err2,perf]=sim(net,TR.P,[],[],TR.T);

threshold = rec.perf(rec.best_epoch);

outNetV=(outNetVV>threshold);
%outNetT=(outNetTT>threshold);
% row x col - expected x observed
confm(1,1) = length(find( (VR.T==0) & ( outNetV==0 ) ))/length(find(VR.T==0));
confm(1,2) = length(find( (VR.T==1) & ( outNetV==0 ) ))/length(find(VR.T==1));
confm(2,1) = length(find( (VR.T==0) & ( outNetV==1 ) ))/length(find(VR.T==0));
confm(2,2) = length(find( (VR.T==1) & ( outNetV==1 ) ))/length(find(VR.T==1));
