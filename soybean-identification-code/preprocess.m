function media =  preprocess()
    
%     for i =1:530
%         
% 
%         input = ['danos/damostra' int2str(i) '.bmp'];
%                 
%         if(exist(input,'file'))
%             img = imread(input);
% 
%             edges = edge(uint8(img),'canny');
% 
%             [obj,num] = bwlabel(edges);
%             
%             for j=1:num
%                 
%                 dano = obj==j;
%                 dano = recortadanos(1-dano);                
%                 output =['cortes/damostra' int2str(i) ' - ' int2str(j) '.bmp']; 
%                 
%                 imwrite(dano,output);               
%                 
%             end
%             i
%         end
%     end    

    for i =1:530
        
        sum = 0;
        count=0;
        input = ['normais/amostra' int2str(i) '.bmp'];
                        
        if(exist(input,'file'))
            img = imread(input);
            s = size(img);
            sum = sum + (s(1)*s(2));
            count = count+1;
            i
        end
        
        media = sum/count;
    end 
end