%Preprocessing applied to the leaflet image in order to obtain the damage contour
%	preprocess_leaflets(input_folder) saves contours of input images and the damage contours
%		input_folder -- folder with orginal leaflet images
%	
%		save the contours of the leaflet in folder ../../data/coutours/
%		save the contours of the damages in folder ../../data/cuts/
%
%Authors:
% 	Suellen Almeida <susilvaalmeida@gmail.com>
% 	Antonio Carlos N. Junior <acnazarejr@gmail.com>
% 	Thiago L. G. Souza (in memoriam)

function preprocess_leaflets(input_folder)
	% get all bmp images of input_folder
	images = dir([input_folder '*.bmp']);
	N = length(images)

	% check images
    %if(~exist(input_folder, 'dir') || N<1)
    %    display('Directory not found or no matching images found.');

    % create output dirs
    mkdir('../../data/contours');
    mkdir('../../data/cuts');
    
	for i = 1:N
		i
        img = imread([input_folder images(i).name]);

        %filter image and find damages
        damages_img = find_damages(img);

        %extract damages contours
        damages_img = discard_small_damages(damages_img);
        output_contours =['../../data/contours/' images(i).name]; 
        imwrite(damages_img,output_contours);   

        se = strel('diamond', 1);
        [labels num] = bwlabel(1-damages_img,4);
        for j = 1:num
            damage = labels == j;
            erode = imerode(damage,se);
            damage = damage - erode;
            if(sum(damage(:)) > 15)
                damage = cut_damage(1-damage);                
                output_cut =['../../data/cuts/' images(i).name(1:end-4) ' - ' int2str(j) '.bmp']; 
                imwrite(damage,output_cut);  
            end             
        end
	end
end 