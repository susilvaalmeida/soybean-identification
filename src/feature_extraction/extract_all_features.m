%Extract features of the damages contours
%   extract_all_features() extracts and saves all features of the damages
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

function extract_all_features()
    features_folder = '../../data/features/';
    mkdir(features_folder);

    % complex network
    t0 = [0.05,0.10,0.15,0.20];
    tq = [0.60,0.80,0.90,0.95];
    nts = [2,3,5,10,20,30];
    metrics = {{'K'},{'M'},{'E'},{'H'},{'P'}, ...
                {'K','M'},{'K','E'},{'K','H'},{'K','P'},{'M','E'},{'M','H'},{'M','P'},{'E','H'},{'E','P'},{'H','P'}, ...
                {'K','M','E'},{'K','M','H'},{'K','M','P'},{'K','E','H'},{'K','E','P'},{'K','H','P'},{'M','E','H'},{'M','E','P'},{'M','H','P'},{'E','H','P'}, ...
                {'K','M','H','P'},{'K','M','E','P'},{'K','M','H','P'},{'K','E','H','P'},{'M','E','H','P'}, ...
                {'K','M','E','H','P'}};

    it = 0;
    for i=1:length(t0)
        for j=1:length(tq)
            for k=1:length(nts)
                for l=1:length(metrics)
                    f_type = metrics{l};
                    it=it+1;
                    fprintf(1,'%03d - ',it);fprintf(1,'%s %5.3f %5.3f %2d - ',[f_type{:}],t0(i),tq(j),nts(k));fprintf(1,'%s ',datetime('now'));fprintf(1,'\n');
                    extract_features('cn',{t0(i),tq(j),nts(k),f_type}); 
                end
            end
        end
    end

    % fourier
    fourier_num = [2,3,5,10,15,20,25,30,40,50];
    it = 0;
    for i=1:length(fourier_num)
        it=it+1;
        fprintf(1,'%03d - ',it);fprintf(1,'fr %03d - ',fourier_num(i));fprintf(1,'%s ',datetime('now'));fprintf(1,'\n');
        extract_features('fr',{fourier_num(i)}); 
    end

    % wavelet
    wavelet_family = {{'haar'},{'db2'},{'db3'}};
    n_coefficients = [10,20,30,40,50];
    percent = [0.10,0.25,0.50,0.75,0.90,1];
    it = 0;
    for i=1:length(wavelet_family)
        family = wavelet_family{i};
        for j=1:length(n_coefficients)
            for k=1:length(percent)
                it=it+1;
                fprintf(1,'%03d - ',it);fprintf(1,'wv %s %03d %03.f - ',[family{:}],n_coefficients(j),100*percent(k));fprintf(1,'%s ',datetime('now'));fprintf(1,'\n');
                extract_features('wv',{[family{:}],n_coefficients(j),percent(k)});
        end
    end

    % zernike
    zernike_degree = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18];
    it = 0;
    for i=1:length(zernike_degree)
        it=it+1;
        fprintf(1,'%03d - ',it);fprintf(1,'zn %03d - ',zernike_degree(i));fprintf(1,'%s ',datetime('now'));fprintf(1,'\n');
        extract_features('zn',{zernike_degree(i)}); 
    end
    

end