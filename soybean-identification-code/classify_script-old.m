arq    = fopen('feat_4\results-svm.csv','w');
arqtex = fopen('feat_4\table.tex','w');
fprintf(arq,'file;ncarac; n acertos;%% acertos;desvio;mean_conf(00);mean_conf(01);mean_conf(10);mean_conf(11);std_conf(00);std_conf(01);std_conf(10);std_conf(11)\n');
%arqs = dir('feat_4\*.mat');
%fIni = 1;fEnd = length(arqs);

%t0 = [0.05 0.10 0.15 0.20];
%tq = [0.6 0.8 0.9 0.95];
t0 = [0.10 0.15];
tq = [0.95];

nts =[10 20 30];

it=0;
for i=1:length(t0)
    for j=1:length(tq)
        fprintf(arqtex,'%4.2f & %4.2f ',t0(i),tq(j));
        for f=1:2
            for k=1:length(nts)
                it=it+1;
                tinc=(tq(j)-t0(i))/(nts(k)-1);
                filename = sprintf('feat_4\\features_%03d_%03d_%03d_%d.mat',int16(1000*t0(i)),int16(1000*tinc),int16(1000*tq(j)),f);
%                fprintf(1,'%02d/%02d - %s',j-fIni+1,fEnd-fIni+1,filename);
                fprintf(1,'%03d/%03d - %s\n',it,length(t0)*length(tq)*2*length(nts),filename);
                if (exist(filename) == 2)
                    [accuracy sensitivity] = svm_validation(filename,arq);
                else
                    fprintf(1,'arquivo não existe!\n');                    
                end

                fprintf(arqtex,'& %6.2f&(%3.1f)&%6.2f&%6.2f',...
                    100*mean(accuracy),100*std(accuracy), ...
                    100*mean(sensitivity(1,:)), ...
                    100*mean(sensitivity(2,:))) ;
            end
        end
        fprintf(arqtex,'\n');
    end
end
fclose(arq);
fclose(arqtex);