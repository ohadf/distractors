function features = findEdgeBoxesTop20(img, dims, varargin)
%FINDEDGEBOXESTOP20 Calculate top-20 edge boxes
%
%   References:
%
%   [1] Fried O., Shechtman E., Goldman D., and Finkelstein A. (2015) 
%       Finding Distractors In Images. Computer Vision and Pattern 
%       Recognition (CVPR)
%   [2] C. Zitnick, and P. Dollár (2014) Edge Boxes: Locating Object 
%       Proposals from Edges. European Conference on Computer Vision (ECCV)

fprintf('Finding edge boxes (top 20)...'); tic;
img = imresize(img, dims);

% load pre-trained edge detection model and set opts (see edgesDemo.m)
model=load('modelBsds'); model=model.model;
model.opts.multiscale=0; model.opts.sharpen=2; model.opts.nThreads=4;

% set up opts for edgeBoxes (see edgeBoxes.m)
opts = edgeBoxes;
opts.alpha = .65;     % step size of sliding window search
opts.beta  = .75;     % nms threshold for object proposals
opts.minScore = .01;  % min score of boxes to detect
opts.maxBoxes = 1e4;  % max number of boxes to detect

% detect Edge Box bounding box proposals (see edgeBoxes.m)
bbs = edgeBoxes(img, model, opts);

% sort bounding boxes according to score (descending order)
bbs = flipud(sortrows(bbs, 5));

% only use top K bounding boxes
K = 20;
bbs = bbs(1:K, :);

% convert bounding boxes to images
map = zeros(size(img, 1), size(img, 2));
for ii = 1:size(bbs, 1)
  bb = bbs(ii, 1:4);
  bb_val = bbs(ii, 5);
  
  map(bb(2):bb(2)+bb(4)-1, bb(1):bb(1)+bb(3)-1) = ...
    map(bb(2):bb(2)+bb(4)-1, bb(1):bb(1)+bb(3)-1) + bb_val;
end
map = map ./ max(map(:));

features = map(:);
fprintf([num2str(toc), ' seconds \n']);
