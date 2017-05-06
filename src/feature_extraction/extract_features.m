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
%               cn : 
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



end