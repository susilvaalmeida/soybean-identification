%Preprocessing applied to the leaflet image in order to obtain the damage contour
%   preprocess_leaflets(input_folder) saves contours of input images and the damage contours
%       input_folder -- folder with orginal leaflet images
%   
%       save the contours of the leaflet in folder ../../data/coutours/
%       save the contours of the damages in folder ../../data/cuts/
%
%Authors:
%   Suellen Almeida <susilvaalmeida@gmail.com>
%   Antonio Carlos N. Junior <acnazarejr@gmail.com>
%   Thiago L. G. Souza (in memoriam)

function preprocess(input_folder,ref_folder)
    if nargin < 1
        input_folder = '../../data/input/';
        ref_folder = '../../data/input_ref/';
    end

    % get all bmp images of input_folder
    images = dir([input_folder '*.bmp']);
    images_ref = dir([ref_folder '*.bmp']);
    N = length(images);

    % create output dirs
    mkdir('../../data/contours');
    mkdir('../../data/cuts');
    
    for i = 1:N
        disp(images(i).name)
        img = imread([input_folder images(i).name]);
        img_ref = imread([ref_folder images_ref(i).name]);
        %filter image and find damages
        damages_img = find_damages(img,img_ref);

        %extract damages contours
        damages_img = discard_small_damages(damages_img);
        
        output_contours =['../../data/contours/' images(i).name]; 
        imwrite(damages_img,output_contours);   

        damages_img = discard_small_damages(damages_img);
        se = strel('diamond', 1);
        [labels, num] = bwlabel(1-damages_img,4);
        for j = 1:num
            damage = labels == j;
            erode = imerode(damage,se);
            damage = damage - erode;
            %figure;imshow(damage);
            if(sum(damage(:)) > 15)
                damage = cut_damage(1-damage);                
                output_cut =['../../data/cuts/' images(i).name(1:end-4) ' - ' int2str(j) '.bmp']; 
                imwrite(damage,output_cut);  
            end             
        end
    end
end 