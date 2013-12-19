function [damages,leaves,pool] = folders_generation(N)

verbose = 0;

directoryFeatures = 'features/';
directoryImages = 'images/cortes/';
damageDirs = dir([directoryImages '*']);
damageType = ['lag';'col'];

damages = [];
leaves = [];
damageCount=0;
ctDamage = 0;

fprintf(1,'Counting samples of leaves from files...\n');
for i=1:length(damageDirs)
    if (damageDirs(i).isdir) & ~strcmp(damageDirs(i).name,'.') & ~strcmp(damageDirs(i).name,'..')
        ctDamage = ctDamage + 1;
        if verbose fprintf(1,'[%5d] %5d/%-5s - ',ctDamage,damageCount,damageDirs(i).name);end
        damageCountLeaf = 0;
        for(td=1:2)
            damageCountLeafType(td) = 0;
            
            damageFiles = dir([directoryImages  damageDirs(i).name '/' damageType(td,:) '/*.bmp']);
        
            for j=1:length(damageFiles)
                input = damageFiles(j).name;
%                img = imread([directoryImages damageDirs(i).name '/' damageType(td,:) '/' input]);
%                fprintf(1,'%s\n',['cortes3/' damageDirs(i).name '/' damageType(td,:) '/' input]);
                index = eval(input(end-5:end-4));
                sample = eval(damageDirs(i).name);
                    
                damages = [damages; sample index td-1]; % td-1 stands for the target class
                damageCountLeafType(td) = damageCountLeafType(td) + 1;                
            end
            if verbose fprintf(1,'%3d ',damageCountLeafType(td)); end
            damageCountLeaf = damageCountLeaf + damageCountLeafType(td);
        end
        leaves = [leaves; sample damageCountLeafType(1) damageCountLeafType(2)];
        
        if verbose fprintf(1,': %3d\n',damageCountLeaf); end
        damageCount=damageCount+damageCountLeaf;        
    end
end
fprintf(1,'Total of damages %4d (%4d/%4d) from %d leaves\n',damageCount,length(find(damages(:,3) == 0)),length(find(damages(:,3) == 1)),length(unique(damages(:,1))));

leaves(:,4) = leaves(:,2) - leaves(:,3);[tmp,idx]=sort(leaves(:,4),'descend');
t1 = sum(leaves(:,2));
t2 = sum(leaves(:,3));
ratio = t1/t2;

for(i=1:N)
    pool{i} = [];
end

leavesS=leaves(idx,:);
leavespool = leavesS;
leavespool(:,5) = ones(1,length(leaves))';
while( length(find(leavespool(:,5)==1)) > 0 )
    i=WorstPool(leavesS,pool,N);
    [t,leavespool]=BestInsertion(pool,i,leavespool,ratio);
    pool{i} = [pool{i} t];
    leaves(idx(t),4) = i;
    damages(damages(:,1) == leaves(idx(t)),4) = i;
end
i=WorstPool(leavesS,pool,N); %% final!!!

fprintf(1,'Trying improving\n');
[i,j]=WorstPools(leavesS,pool,N,ratio);
while(i~= 0 & j ~=0)
    [a,b]=Ratio(leavesS,i,j,pool,N,ratio);
    fprintf(1,'%d %3d/%3d <-> %d %3d/%3d\n', ...
      i,leavesS(pool{i}(a),2),leavesS(pool{i}(a),3), ...
      j,leavesS(pool{j}(b),2),leavesS(pool{j}(b),3));
    
    pool{j} = [pool{j} pool{i}(a)]; 
    pool{i} = [pool{i} pool{j}(b)]; 
    leaves(idx(pool{i}(a)),4) = j; 
    leaves(idx(pool{j}(b)),4) = i;
    damages(damages(:,1) == leaves(idx(pool{i}(a))),4) = j;
    damages(damages(:,1) == leaves(idx(pool{j}(a))),4) = i;
    pool{i}(a) = []; 
    pool{j}(b) = []; 
    [i,j]=WorstPools(leavesS,pool,N,ratio);
end

save ([directoryFeatures 'folders'],'damages','leaves','pool');

end

function fitness=WorstPool(leaves,pool,N)
% number of leaves in pool?
% balance in the total number of damages by pool
% balance in the ratio lag/col by pool
for(i=1:N)
    poolT = leaves(pool{i},:);
    tot(i) = sum(poolT(:,2) + poolT(:,3));
    rat(i) = sum(poolT(:,2)) / sum(poolT(:,3));
    fprintf(1,'%3d(%3d/%3d)=%4.2f, ',tot(i),sum(poolT(:,2)),sum(poolT(:,3)),rat(i));
end
fprintf(1,'\n');
%[tmp,fitness] = min(abs(rat-ratio));
[tmp,fitness] = min(tot);
end


function [a,b]=WorstPools(leaves,pool,N,ratio)
for(i=1:N)
    poolT = leaves(pool{i},:);
    tot(i) = sum(poolT(:,2) + poolT(:,3));
    rat(i) = sum(poolT(:,2)) / sum(poolT(:,3));
    fprintf(1,'%3d(%3d/%3d)=%4.2f, ',tot(i),sum(poolT(:,2)),sum(poolT(:,3)),rat(i));
end
fprintf(1,'\n');
%[tmp,fitness] = min(abs(rat-ratio));
[tmp1,a] = max(rat);
[tmp2,b] = min(rat);
if (abs(ratio-tmp1) < 0.01 & abs(ratio-tmp2) < 0.01)
    a = 0; b = 0;
end
end


function [element,leaves]=BestInsertion(pool,i,leaves,ratio)
poolT = [leaves(pool{i},:)];
posL=find(leaves(:,5)==1);
leavesN=leaves(leaves(:,5)==1,:);
leavesNL = [repmat(sum(poolT(:,2)),size(leavesN,1),1) repmat(sum(poolT(:,3)),size(leavesN,1),1) leavesN(:,2) leavesN(:,3)];
ranking = (leavesNL(:,1) + leavesNL(:,3)) ./ (leavesNL(:,2) + leavesNL(:,4));
ranking = abs(ranking - ratio);
[tmp,element] = min(ranking);
element = posL(element);

leaves(element,5) = 0; % removendo elemento
end

function [a,b]=Ratio(leaves,i,j,pool,N,ratio);
poolT = leaves(pool{i},:);
ratI = poolT(:,2) ./ poolT(:,3);
[tmp,a] = max(ratI);
%a = find(poolT(a) == leaves(:,1));

poolT = leaves(pool{j},:);
ratJ = poolT(:,2) ./ poolT(:,3);
[tmp,b] = min(ratJ);
%b = find(poolT(b) == leaves(:,1));
end