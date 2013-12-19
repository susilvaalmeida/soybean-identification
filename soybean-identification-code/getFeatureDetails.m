function [filename,parOut]=getFeatureDetails(featureType,parameters)

if ( strcmp(featureType,'cn') )
    t0 = parameters{1}; tq = parameters{2}; nts = parameters{3}; metrics = parameters{4};

    smetrics = [];
    if (sum([metrics{:}] == 'K') == 1) smetrics = [smetrics 'k']; end
    if (sum([metrics{:}] == 'M') == 1) smetrics = [smetrics 'm']; end
    if (sum([metrics{:}] == 'E') == 1) smetrics = [smetrics 'e']; end
    if (sum([metrics{:}] == 'H') == 1) smetrics = [smetrics 'h']; end
    if (sum([metrics{:}] == 'P') == 1) smetrics = [smetrics 'p']; end
    parOut{3}= smetrics;
    
    filename = sprintf('%s_%s_%03.f_%03.f_%03d',featureType,smetrics,100*t0,100*tq,nts);
    parOut{1} = (tq-t0) / (nts-1); % tinc 
    parOut{2} = t0 + (0:nts-1) * parOut{1}; % tl
elseif (strcmp(featureType,'fr') )
    filename = sprintf('%s_%03d',featureType,parameters{1});
    parOut = [];
elseif (strcmp(featureType,'wv') )
    base = parameters{1}; nSize1 = parameters{2}; pSize2 = parameters{3};
    filename = sprintf('%s_%s_%03d_%03.f',featureType,base,nSize1,100*pSize2);
    parOut = [];    
elseif (strcmp(featureType,'zn') )
    filename = sprintf('%s_%03d',featureType,parameters{1});
    parOut = [];
else
    filename = sprintf('%s',featureType);
    fprintf(1,'%s\n',filename);    
    parOut = [];    
end
