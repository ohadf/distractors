function features = findEdgeBoxesNotInCenter(img, dims, varargin)
%FINDEDGEBOXESNOTINCENTER Calculate edge boxes away from image center
%
%   References:
%
%   [1] Fried O., Shechtman E., Goldman D., and Finkelstein A. (2015) 
%       Finding Distractors In Images. Computer Vision and Pattern 
%       Recognition (CVPR)
%   [2] C. Zitnick, and P. Dollár (2014) Edge Boxes: Locating Object 
%       Proposals from Edges. European Conference on Computer Vision (ECCV)

fprintf('Finding edge boxes (near image boundary)...'); tic;
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

% only use bouding boxes above threshold
BB_THRESH = 0.085;
bbs = bbs(bbs(:, 5) > BB_THRESH, :);

% convert bounding boxes to images
map_sum = zeros(size(img, 1), size(img, 2));
map_max = zeros(size(img, 1), size(img, 2));
for ii = 1:size(bbs, 1)
  bb = bbs(ii, 1:4);
  bb_val = bbs(ii, 5);
  
  % Only keep rectangles strictly in the ALLOWED_AREA praction of the image 
  % (from either side)
  ALLOWED_AREA = 0.25;
  x1 = bb(1);
  y1 = bb(2);
  x2 = bb(1) + bb(3) - 1;
  y2 = bb(2) + bb(4) - 1;

  if  ~ ( all([y1, y2] < ALLOWED_AREA .* size(img, 1))        || ...    % Top & bottom
          all([y1, y2] > (1 - ALLOWED_AREA) .* size(img, 1))  || ...
          all([x1, x2] < ALLOWED_AREA .* size(img, 2))        || ...    % Left & right
          all([x1, x2] > (1 - ALLOWED_AREA) .* size(img, 2))      )
      continue
  end
  
  % Only keep rectangles that touch BOUNDARY_WIDTH (measured in pixels)
  BOUNDARY_WIDTH = 5;
  if  ~(any([x1, y1] <= BOUNDARY_WIDTH) || ...
        x2 > size(img, 2) - BOUNDARY_WIDTH || ...
        y2 > size(img, 1) - BOUNDARY_WIDTH )
      continue;
  end

  % Only keep rectangles which are smaller than SIZE_THRESHOLD fraction of 
  % the image
  SIZE_THRESHOLD = 0.05; % 5 percent
  if bb(3) * bb(4) > SIZE_THRESHOLD * size(img, 1) * size(img, 2)
    continue;
  end

  map_sum(y1:y2, x1:x2) = map_sum(y1:y2, x1:x2) + bb_val;
  map_max(y1:y2, x1:x2) = max(map_max(y1:y2, x1:x2), bb_val);
end

% Normalize maximal value to 1, unless all values are 0
if any(map_sum(:) ~= 0)
  map_sum = map_sum ./ max(map_sum(:));
end
if any(map_max(:) ~= 0)
  map_max = map_max ./ max(map_max(:));
end

% Return both maps as features
features = [map_sum(:) map_max(:)];
fprintf([num2str(toc), ' seconds \n']);
