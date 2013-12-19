function feature_extraction(featureType,parameters)

directoryFeatures = 'features/';
directoryImages = 'images/cortes/';
damageDirs = dir([directoryImages '*']);
damageType = ['lag';'col'];

[filename,parOut]=getFeatureDetails(featureType,parameters);

matrix = [];
damageCount=0;

minn = 255; maxx = 0;
for i=1:length(damageDirs)
    fprintf(1,'[%5d/%5d] %5d/%s\t',i,length(damageDirs),damageCount,damageDirs(i).name);
    if (mod(i,6)==0) fprintf(1,'\n'); end
    
    if(damageDirs(i).isdir)

        for(td=1:2)
            damageFiles = dir([directoryImages  damageDirs(i).name '/' damageType(td,:) '/*.bmp']);
        
            for j=1:length(damageFiles)
                input = damageFiles(j).name;
                img = imread([directoryImages damageDirs(i).name '/' damageType(td,:) '/' input]);
%                fprintf(1,'%s\n',['cortes3/' damageDirs(i).name '/' damageType(td,:) '/' input]);
                index = eval(input(end-5:end-4));
                sample = eval(damageDirs(i).name);
   
                    if( strcmp(featureType,'cn'  ) )
                    vaux = descriptor_cn(img,parOut{2},parOut{3});
                elseif( strcmp(featureType,'fr') )
                    vaux = descriptor_fr(img,parameters{1});
                elseif( strcmp(featureType,'zn') )
                    vaux = descriptor_zn(img,parameters{1});
                elseif( strcmp(featureType,'wv') )
                    vaux = descriptor_wv(img,parameters{1},parameters{2},parameters{3});
                end
                vaux = [vaux sample index td-1]; % td-1 stands for the target class
                matrix = [matrix; vaux];
                
                damageCount=damageCount+1;
            end
        end
    end
end

[tmp,scale_factor] = mapminmax(matrix(:,1:end-3)'); 
matrix(:,1:end-3) = tmp';

save ([directoryFeatures filename],'matrix');
fprintf(1,'\nTotal of analyzed damages: %d\n',damageCount);

end