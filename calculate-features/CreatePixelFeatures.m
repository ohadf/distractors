function [allfeatures] = CreatePixelFeatures(images, cache_dir, dims)
%CREATEPIXELFEATURES Collect all pixel features for a list of images
%   [ALLFEATURES] = CREATEPIXELFEATURES(IMAGES, CACHE_DIR, DIMS) Calculates 
%   all features for all IMAGES. Data is cached in CACHE_DIR. Images are 
%   first down-scaled to size DIMS.
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
%     ALLFEATURES      (prod(DIMS)*K) x F matrix, where K is number of 
%                      input images and F is number of features
%
%   References:
%
%   Fried O., Shechtman E., Goldman D., and Finkelstein A. (2015) Finding 
%   Distractors In Images. Computer Vision and Pattern Recognition (CVPR)

  % Calculate all features in our model
  feature_list = {
    'SubbandFeatures'
    'ColorFeatures'
    'HorizonFeatures'
    'ObjectFeatures'
    'Text'
    'DistToCenterFeatures'
    'DistToEdgeFeatures'
    'IttiFeatures'
    'TorralbaSaliency'
    'HouSaliency'
    'PCASaliency'
    'CoxelSaliency'
    'EdgeBoxes'
    'EdgeBoxesTop20'
    'EdgeBoxesNotInCenter'
    'AttenuatedSaliency'
    'AttenuatedSaliencyFromPeak'
  };

  allfeatures = CreateIndividualFeatures(images, cache_dir, dims, ...
                                         feature_list);
end
