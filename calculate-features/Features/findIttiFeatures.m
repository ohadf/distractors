function features = findIttiFeatures(img, dims, varargin)
%
% features = findIttiFeatures(img, dims)
% the three channels of Itti and Koch's saliency model

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

fprintf('Finding Itti&Koch channels...'); tic;
features=zeros(dims(1)*dims(2), 3);

img = initializeImage(img);
params = defaultSaliencyParams(img.size, 'dyadic');
[salmap, salData] = makeSaliencyMap(img, params);

colorCM = imresize(salData(1).CM.data, dims, 'bilinear');
intensityCM = imresize(salData(2).CM.data, dims, 'bilinear');
orientationCM = imresize(salData(3).CM.data, dims, 'bilinear');

features(:, 1) = colorCM(:);
features(:, 2) = intensityCM(:);
features(:, 3) = orientationCM(:);
fprintf([num2str(toc), ' seconds \n']);

if nargout==0
    subplot(131); imshow(reshape(features(:, 1), dims)); title('color channel');
    subplot(132); imshow(reshape(features(:, 2), dims)); title('intensity channel');
    subplot(133); imshow(reshape(features(:, 3), dims)); title('orientation channel');
end