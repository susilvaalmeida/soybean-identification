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
    mkdir(features_folder);

    damages_folder = '../../data/cuts/';
    damages_images = dir([damages_folder '*.bmp']);
    N = length(damages_images);

    for i = 1:N
        img = imread([damages_folder damages_images(i).name]);
        image_index = eval(damages_images(i).name(end-11:end-9));
        sample_index = eval(damages_images(i).name(end-5:end-4));
end