%Extract features of the damages contours
%   extract_features(feature_type,parameters) extracts and saves features of the damages
%       feature_type -- which feature extraction method will be used
%           options: 
%               cn (complex network)
%               fr (fourier)
%               wv (wavelets)
%               zn (zernike moments)
%       parameters -- dic with the parameters needed for the extraction method
%           options:
%               cn : threshoulds of complex network and type of feature to extract from the complex network (k,m,h,e,p)
%               fr : number of descriptors to extract
%               wv : wavelet family, number of wavelets coefficients, percent of the coefficients to consider descriptors
%               zn : degree of the zernike moments
%
%       save the features in folder ../../data/features/
%
%Author:
%   Suellen Almeida <susilvaalmeida@gmail.com>

function extract_features(feature_type,parameters)
    features_folder = '../../data/features/';
    
    damages_folder = '../../data/cuts/';
    damages_images = dir([damages_folder '*.bmp']);
    N = length(damages_images);

    matrix = [];
    damage_count = 0;
    filename = '';

    for i = 1:N
        img = imread([damages_folder damages_images(i).name]);
        
        image_index = strsplit(damages_images(i).name);
        image_index = strrep(image_index{1}, 'amostra', '');
        image_index = eval(image_index);
        
        sample_index = strsplit(damages_images(i).name);
        sample_index = strsplit(sample_index{3},'.');
        sample_index = eval(sample_index{1});

        if(strcmp(feature_type,'cn'))
            metrics = parameters{4};
            smetrics = [];
            if (sum([metrics{:}] == 'K') == 1) smetrics = [smetrics 'k']; end
            if (sum([metrics{:}] == 'M') == 1) smetrics = [smetrics 'm']; end
            if (sum([metrics{:}] == 'E') == 1) smetrics = [smetrics 'e']; end
            if (sum([metrics{:}] == 'H') == 1) smetrics = [smetrics 'h']; end
            if (sum([metrics{:}] == 'P') == 1) smetrics = [smetrics 'p']; end
            filename = sprintf('cn_%s_%03.f_%03.f_%03d',smetrics,100*parameters{1},100*parameters{2},parameters{3});
            descriptors = cn_descriptors(img,[parameters{1},parameters{2},parameters{3}], smetrics);
        elseif(strcmp(feature_type,'fr'))
            filename = sprintf('fr_%03d',parameters{1});
            descriptors = fourier_descriptors(img,parameters{1});
        elseif(strcmp(feature_type,'zn'))
            filename = sprintf('zn_%03d',parameters{1});
            descriptors = zernike_descriptors(img,parameters{1});
        elseif(strcmp(feature_type,'wv'))
            filename = sprintf('wv_%s_%03d_%03.f',parameters{1},parameters{2},parameters{3}*100);
            descriptors = wavelet_descriptors(img,parameters{1},parameters{2},parameters{3});
        end

        target_class = get_label(image_index,sample_index);
        if isempty(target_class)
            continue;
        end    
        descriptors = [descriptors image_index sample_index target_class];
        matrix = [matrix; descriptors];
        
        damage_count = damage_count+1;
    end

    [tmp,scale_factor] = mapminmax(matrix(:,1:end-3)'); 
    matrix(:,1:end-3) = tmp';

    save ([features_folder filename],'matrix');
    fprintf(1,'\nTotal of analyzed damages: %d\n',damage_count);

end