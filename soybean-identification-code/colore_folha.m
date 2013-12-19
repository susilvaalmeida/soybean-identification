function colore_folha(index,filename,matriz)

    img = imread(filename);
    [l c] = size(matriz);
%    index = eval(filename(end-4:end-4));
    
    vetor_danos = [];
    vetor_cores = [];
    
    amarelo = [255 255 0]; azul = [0 0 255];
    verde = [0 255 0]; vermelho = [255 0 0];
    magenta = [255 0 255];
    
    for i=1:c
        dano = matriz(1,i);
        esperado = matriz(2,i);
        obtido = matriz(3,i);
       
        vetor_danos = [vetor_danos dano];
        
        if(esperado==obtido)
          if(esperado==0)
              vetor_cores = [vetor_cores;amarelo];
          else
              vetor_cores = [vetor_cores;azul];
          end
        else
            if(esperado==0 & obtido==1)
                vetor_cores = [vetor_cores;verde];
            else
                vetor_cores = [vetor_cores;magenta];
            end
        end
    end
    
    imfinal = colore_danos(index, vetor_danos, vetor_cores);
    if(isdir('coloridas')==0)
        mkdir('coloridas');
    end
    output =['coloridas/damostra' int2str(index) '.bmp']; 
    imwrite(imfinal,output);      
end