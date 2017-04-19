function [matriz media] = geravetores(input,n)

    matriz = zeros([1700 24]);
    
    aux =1;
    
    for i =1:100     
            
            if(exist(input,'file') && i~=ex)
                img = imread(input);            
                vetor = degreevector(img); 
                matriz(aux,:)=vetor;
                aux= aux+1;
            end
     end    
    
     centroide = mean(matriz);
    
end