function features = findTorralbaSaliency(img, dims, varargin)
%
% features = findTorralbaSaliency(img, [M, N])
%

% Modified from:
% ----------------------------------------------------------------------
% Matlab tools for "Learning to Predict Where Humans Look" ICCV 2009
% Tilke Judd, Kristen Ehinger, Fredo Durand, Antonio Torralba
% 
% Copyright (c) 2010 Tilke Judd
% Distributed under the MIT License
% See MITlicense.txt file in the distribution folder.
% 
% Contact: Tilke Judd at <tjudd@csail.mit.edu>
% ----------------------------------------------------------------------

fprintf('Finding Torralba saliency...'); tic;
if size(img, 3)>1
    img=rgb2gray(img);
end
img = imresize(img, dims);
map = torralbaSaliency(img);
map=map/(max(map(:)));
features = map(:);
fprintf([num2str(toc), ' seconds \n']);