files=dir('*.mat');
for(i=1:length(files))
    if strfind(files(i).name,'_nn_')
        load(files(i).name);
        tmp = strrep(files(i).name,'_nn_','_')
        save(tmp,'svm_parameters');
    end
end