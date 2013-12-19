    for i =1:530
        

        input = ['danos/damostra' int2str(i) '.bmp'];
                
        if(exist(input,'file'))
            img = imread(input);
            
%            edges = edge(uint8(img),'canny');
            img = smallclean(img);
          
            se = strel('diamond',1);

            [obj,num] = bwlabel(1-img,4);
            pasta = ['damostra' int2str(i) '.bmp'];
            mkdir('cortes3',pasta);
            for j=1:num
                
            dano = obj==j;
            erodimg = imerode(dano,se);
            dano = dano - erodimg;
            if(sum(dano(:)) > 15)
                dano = recortadanos(1-dano);                
                output =['cortes3/' pasta '/damostra' int2str(i) ' - ' int2str(j) '.bmp']; 
                imwrite(dano,output);               
            end
                
            end
            i
        end
    end    
