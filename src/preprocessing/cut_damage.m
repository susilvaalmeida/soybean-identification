%Cut the small damage of a big image
%   cut = cut_damage(damage) returns an image with bouding box of the damage 
%       img -- input binary matrix where 0 are the contour of the damage
%       
%Authors:
%   Suellen Almeida <susilvaalmeida@gmail.com>
%   Antonio Carlos N. Junior <acnazarejr@gmail.com>
%   Thiago L. G. Souza (in memoriam)

function cut = cut_damage(damage)
    [x y] = find(damage==0);
    cut = damage(min(x):max(x),min(y):max(y));
end