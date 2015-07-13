function features = findDistToEdgeFeatures(img, dims, varargin)
%FINDDISTTOEDGEFEATURES Calculate distance to image border
%
%   References:
%
%   Fried O., Shechtman E., Goldman D., and Finkelstein A. (2015) Finding 
%   Distractors In Images. Computer Vision and Pattern Recognition (CVPR)

fprintf('Finding distance to the closest border...'); tic;
% calculate the feature.  Each pixel is the distance away from the
% closest border (should measure from the original image)
[imgr, imgc, ~] = size(img);

% calculate the distance to the closest out of the 4 image borders
[x, y] = meshgrid(1:imgr, 1:imgc);
distMatrix = min(cat(3, x - 1, y - 1, imgr - x, imgc - y), [], 3);

distMatrix = distMatrix/max(distMatrix(:));
distMatrix = imresize(distMatrix, dims, 'bilinear');
features = distMatrix(:);
fprintf([num2str(toc), ' seconds \n']);

if nargout<1
    imshow(reshape(features, dims)); title('Dist to Edge');
end