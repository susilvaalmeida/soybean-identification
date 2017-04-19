function vetor = plotaAreas(areas,tamclasse)

    nclasses = uint32(max(areas)/tamclasse)
    vetor = zeros([1 nclasses]);
    menor = min(areas)
    maior = max(areas)
    s = size(areas);
    s = s(2);
    for i = 1:(s)

        x = (areas(i)/maior)*(nclasses-1)+1;
        
        vetor(x) = vetor(x) +1;
    end
    
    
    
end

