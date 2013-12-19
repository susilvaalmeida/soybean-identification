function areas = calcarea()
    
    areas = [];

    for i =1:530
        input = ['danos2/damostra' int2str(i) '.bmp'];
        output = ['danos3/damostra' int2str(i) '.bmp'];
        
        if(exist(input,'file'))
            bw = imread(input);
            bw = smallclean(bw);
            
            imwrite(bw,output);
            
        end
    end    
end