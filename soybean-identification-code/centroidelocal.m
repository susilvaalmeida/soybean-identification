function [matriz centroide] = centroidelocal(classe,n)

    if(strcmp(classe,'lagarta'))
        size = 1000;
    elseif(strcmp(classe,'coleoptero') )
        size = 700;
    end    
    matriz = zeros([(size*0.9) 24]);
    aux =1;
    ex = (size/10)*(n-1)+1:(size/10)*(n);
    
    for i =1:size    
        input = [classe '/' classe int2str(i) '.bmp'];
        if(exist(input,'file') && sum(i==ex)==0)
            img = imread(input);            
            vetor = degreevector2(img); 
            matriz(aux,:)=vetor;
            aux= aux+1;
        end
     end    
     centroide = mean(matriz);
end