function features = findPCASaliency(img, dims, varargin)
%FINDPCASALIENCY Calculate image saliency prediction
%
%   References:
%
%   [1] Fried O., Shechtman E., Goldman D., and Finkelstein A. (2015) 
%       Finding Distractors In Images. Computer Vision and Pattern 
%       Recognition (CVPR)
%   [2] Margolin R., Tal A., and Zelnik-Manor L. (2013) What Makes a Patch 
%       Distinct? Computer Vision and Pattern Recognition (CVPR)

fprintf('Finding PCA saliency...'); tic;

img = imresize(img, dims);
if size(img, 3) == 1
    fprintf('\nNote: Grayscale image treated as colored\n');
    img = repmat(img, [1 1 3]);
end

map = PCA_Saliency_Core(img);
features = map(:);
fprintf([num2str(toc), ' seconds \n']);