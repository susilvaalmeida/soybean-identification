function Iout = offshadow(IMG)

H = rgb2hsv(IMG);
H = H(:,:,1);
HBW = im2bw(H,0.3);
Iout = rgb2gray(IMG);
Iout = (im2double(Iout)+double(HBW));