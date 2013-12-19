% Autores : Eduardo Luz e Rensso Mora Colque
% Função : Caregar as características extaídas pelo "featureExtraction.m"
% e coloca-las em 2 partições de forma randomica P1 e P2.
% p1d => dados extraidos - características (primeira partição)
% p1t => classe atribuída (primeira partição)
% p2d => dados extraídos - características (segunda partição)
% p2t => classe atribuída (segunda partição)
%

% pca = 1 => faz o PCA com 98%
% pca = 0 ignora PCA
function [p1d p1t p2d p2t] = cargardadosRandomicamente(filename)
% 
% if nargin == 0    
%     pca = 0;
% end

%pasta  = dir('*.txt');
%pasta  = dir('D:\eduardo\UFOP\mestrado\rp102\trabalhoFinal\*.txt');

%narq   = size(pasta,1);

% NNtotal = [];
% RRtotal = [];
% AAtotal = [];
% VVtotal = [];
% FFtotal = [];
% fftotal = [];    

coltotal = [];
lagtotal = [];
%-------------------------------


[col lag] = loadarq(filename);
coltotal = [coltotal; col];
lagtotal = [lagtotal; lag];


%---------------cria as 2 partições
[p1d p1t p2d p2t] = createPartition(coltotal,lagtotal);

% if(pca == 1)        
% %aplica PCA para reduzir as características
% [newp1d index1]=applyPCA(p1d, 98);
% [newp2d index2]=applyPCA(p2d, 98);
% 
% p1d = newp1d(:,1:index1);
% p2d = newp2d(:,1:index1);
% end

 end

%------------------- funcion dque dforma los grupos
function [p1Data p1Target p2Data p2Target] = createPartition(coltotal,lagtotal)
% coltotal
% cria um novo vetor randomico para coleopteros
z = randperm(size(coltotal,1));
randcol = coltotal(z,:);
% pega apenas 13% dos dados para treino e o restante para teste
trainSize = round(size(coltotal,1)*0.13);
trainDatacol = randcol(1:trainSize,:);
testDatacol = randcol(trainSize:end,:);
t = size(trainDatacol,1);
trainTargetcol = repmat([1 0],t,1); 
t = size(testDatacol,1);
testTargetcol = repmat([1 0],t,1); 

% lagtotal -------------------------------------------------
% cria um novo vetor randomico para lagartas
z = randperm(size(lagtotal,1));
randlag = lagtotal(z,:);
% pega apenas 40% dos dados para treino e o restante para teste
trainSize = round(size(lagtotal,1)*0.20);
trainDatalag = randlag(1:trainSize,:);
testDatalag = randlag(trainSize:end,:);
t = size(trainDatalag,1);
trainTargetlag = repmat([0 1],t,1); 
t = size(testDatalag,1);
testTargetlag = repmat([0 1],t,1); 

%-------- Cria as partições
p1Data = [trainDatacol;trainDatalag];
p1Target = [trainTargetcol;trainTargetlag];
p2Data = [testDatacol;testDatalag];
p2Target = [testTargetcol;testTargetlag];

end



%--------------------funcion de separacion
function [col lag]=loadarq(arq)
load(arq);
%t = size(matrix,2);
pos = find(matrix(:,end)==0); % coleopteros
col = matrix(pos,1:end-3);
pos = find(matrix(:,end)==1); % lagartas
lag  = matrix(pos,1:end-3);

% % remoção das caract. dinâmicas (informação de RR)
% N = N(:,3:end);
% A = A(:,3:end);
% V = V(:,3:end);
% R = R(:,3:end);
% F = F(:,3:end);
% f = f(:,3:end);
end