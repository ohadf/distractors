function features = findCoxelSaliency(img, dims, varargin)
%FINDCOXELSALIENCY Find saliency via coxels
%
%   References:
%
%   [1] Fried O., Shechtman E., Goldman D., and Finkelstein A. (2015) 
%       Finding Distractors In Images. Computer Vision and Pattern 
%       Recognition (CVPR)
%   [2] Mairon R., and Ben-Shahar O. (2014) A Closer Look at Context: From 
%       Coxels to the Contextual Emergence of Object Saliency. European
%       Conference on Computer Vision (ECCV)

fprintf('Finding Coxel saliency...'); tic;

img = imresize(img, dims);

% Compute raw saliency: Count votes per saliency bridge.
rawData = SVC_raw(img);

% Use the raw data to accumulate saliency votes in the 
% image pixels saliency bridges traverse.
map = SVC_map(rawData);
map = imresize(map, dims);

% Normalize
map = map - min(map(:));
map = map ./ max(map(:));

features = map(:);
fprintf([num2str(toc), ' seconds \n']);


