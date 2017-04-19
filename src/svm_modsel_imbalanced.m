function [X,Y,Z,hC,best_c,best_g] = svm_modsel_imbalanced(label,inst)
% Model selection for (lib)SVM by searching for the best param on a 2D grid
% example:
%
% load heart_scale.mat
% [X,Y,Z,hC,best_c,best_g] = modsel(heart_scale_label,heart_scale_inst);
%
% where X,Y,Z are the contour data and hC is the contour handle

%contour plot
wa = @(e1,e2,s1,s2)(1-(e1*1/s1+e2*1/s2)/2)*100; %weighted accuracy
label(label==-1) = 2;
label(label==0) = 2;
fold = 10;
c_begin = -5; c_end = 10; c_step = 1;
g_begin = 8; g_end = -8; g_step = -1;
best_cv = 0;
best_c = 2^c_begin;
best_g = 2^g_begin;
i = 1; j = 1;
indices = crossvalind('Kfold',label,fold);
for log2c = c_begin:c_step:c_end
    for log2g = g_begin:g_step:g_end
        cmd = ['-q -c ',num2str(2^log2c),' -g ',num2str(2^log2g)];
%        '-w1 5 -w2 1 
        cp = classperf(label);
        for k = 1:fold
            test = (indices == k); train = ~test;
            mdl = svmtrain(label(train,:),inst(train,:),cmd);
            [class] = svmpredict(label(test,:),inst(test,:),mdl);
            classperf(cp,class,test);
        end        
        cv = wa(cp.errorDistributionByClass(1) ,cp.errorDistributionByClass(2),...
                cp.SampleDistributionByClass(1),cp.SampleDistributionByClass(2));       
        if (cv > best_cv) || ((cv == best_cv) && (2^log2c < best_c) && (2^log2g == best_g))
            best_cv = cv; best_c = 2^log2c; best_g = 2^log2g;
        end
        disp([num2str(log2c),' ',num2str(log2g),' (best c=',num2str(best_c),' g=',num2str(best_g),' rate=',num2str(best_cv),'%)'])
        Z(i,j) = cv;        
        j = j+1;
    end
    j = 1;
    i = i+1;
end
xlin = linspace(c_begin,c_end,size(Z,1));
ylin = linspace(g_begin,g_end,size(Z,2));
[X,Y] = meshgrid(xlin,ylin); 
acc_range = (ceil(best_cv)-3.5:.5:ceil(best_cv));
[C,hC] = contour(X,Y,Z',acc_range);    

%legend plot
set(get(get(hC,'Annotation'),'LegendInformation'),'IconDisplayStyle','Children')
ch = get(hC,'Children');
tmp = cell2mat(get(ch,'UserData'));
[M,N] = unique(tmp);
c = setxor(N,1:length(tmp));
for i = 1:length(N)
    set(ch(N(i)),'DisplayName',num2str(acc_range(i)))
end  
for i = 1:length(c) 
    set(get(get(ch(c(i)),'Annotation'),'LegendInformation'),'IconDisplayStyle','Off')
end
legend('show')  

%bullseye plot
hold on;
plot(log2(best_c),log2(best_g),'o','Color',[0 0.5 0],'LineWidth',2,'MarkerSize',15); 
axs = get(gca);
plot([axs.XLim(1) axs.XLim(2)],[log2(best_g) log2(best_g)],'Color',[0 0.5 0],'LineStyle',':')
plot([log2(best_c) log2(best_c)],[axs.YLim(1) axs.YLim(2)],'Color',[0 0.5 0],'LineStyle',':')
hold off;
title({['Best log2(C) = ',num2str(log2(best_c)),',  log2(gamma) = ',num2str(log2(best_g)),',  Accuracy = ',num2str(best_cv),'%'];...
    ['(C = ',num2str(best_c),',  gamma = ',num2str(best_g),')']})
xlabel('log2(C)')
ylabel('log2(gamma)')