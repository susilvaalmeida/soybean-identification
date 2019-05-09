%Get the label that the damage represents
%   label = get_label(img,damage) returns the class that the damage represents
%       img -- index of img
%       damage -- index of the damage of image img
%       
%Authors:
%   Suellen Almeida <susilvaalmeida@gmail.com>

function label = get_label(img,damage)
    labels = csvread('../../data/img_sample_class.dat');
    [row,col] = find(labels(:,1)==img&labels(:,2)==damage);
    label = labels(row,3);
end