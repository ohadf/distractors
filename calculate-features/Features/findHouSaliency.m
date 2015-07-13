function features = findHouSaliency(img, dims, varargin)
%FINDHOUSALIENCY Calculate image saliency prediction
%
%   References:
%
%   [1] Fried O., Shechtman E., Goldman D., and Finkelstein A. (2015) 
%       Finding Distractors In Images. Computer Vision and Pattern 
%       Recognition (CVPR)
%   [2] Hou X., and Zhang L. (2008) Dynamic Visual Attention: searching for 
%       coding length increments. Neural Information Processing Systems 
%       (NIPS)

fprintf('Finding Hou saliency (NIPS 2008)...'); tic;

S = load('AW.mat');

img = imresize(img, dims);
[imgH, imgW, ~] = size(img);
im_energy = im2Energy(img, S.W);
map = vector2Im(im_energy, imgH, imgW);
features = map(:);

fprintf([num2str(toc), ' seconds \n']);
end