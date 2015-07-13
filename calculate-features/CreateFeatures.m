function [allfeatures] = CreateFeatures(images, cache_dir, dims)
%CREATEFEATURES Create all pixel and segment features
%   [ALL_FEATURES] = CREATEFEATURES(IMG_FILENAMES, CACHE_DIR, DIMS) 
%   Calculates all pixel features for all IMAGES. Then it aggregates all 
%   pixel features into segment features. Data is cached in CACHE_DIR. 
%   Images are first down-scaled to size DIMS.
%
%   Positional parameters:
%
%     IMAGES           Cell array, each cell contains the full path of an
%                      input image.
%     CACHE_DIR        A directory path, all cached data is stored here.
%     DIMS             Images are resized to DIMS before feature
%                      calculation
%
%   Return values:
%
%     ALLFEATURES      S x F matrix, where S is number of segments in all
%                      input images and F is number of segment features
%
%   References:
%
%   Fried O., Shechtman E., Goldman D., and Finkelstein A. (2015) Finding 
%   Distractors In Images. Computer Vision and Pattern Recognition (CVPR)

  % img_filenames can be a cell array of strings, or a single string. If a
  % single string is given, we convert it to a cell array
  if ischar(images)
    images = {images};
  end
    
  CreatePixelFeatures(images, cache_dir, dims);
  
  allfeatures = [];
  for ii = 1:numel(images)
    allfeatures = [allfeatures ; CreateSegmentFeatures(images{ii}, cache_dir)];
  end

end

