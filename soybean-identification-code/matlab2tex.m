fOutTex = fopen('test.tex','w');

matrix = int16(1000*rand(5,5));
symbols = ['A','B','C','D','E'];

fprintf(fOutTex,'     & ');
for(i=1:length(symbols))
    fprintf(fOutTex,'  %c ',symbols(i));
    if (i ~= length(symbols))
        fprintf(fOutTex,' & ');
    end
end
fprintf(fOutTex,'\\\\ \n');

for(i=1:size(matrix,1))
    fprintf(fOutTex,'  %c  & ', symbols(i));
    for(j=1:size(matrix,2))
        fprintf(fOutTex,'%4.0f',matrix(i,j));
        if (j ~= size(matrix,2))
            fprintf(fOutTex,' & ');
        end
    end
    fprintf(fOutTex,'\\\\ \n');
end

fclose(fOutTex);
