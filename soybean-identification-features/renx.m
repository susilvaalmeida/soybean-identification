files=dir('*.mat');
for(i=1:length(files))
    if strfind(files(i).name,'_jd_')
        load(files(i).name);
        tmp = strrep(files(i).name,'_jd_','_');
        save(tmp,'matrix');
    end
end