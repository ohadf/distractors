function [allfeatures] = CreateSegmentFeatures(img_filename, cache_dir, ...
                                                force_recalculate_seg, ...
                                                force_recalculate_features)
%CREATESEGMENTFEATURES Collect all segment features for a given image
%   [ALLFEATURES] = CREATESEGMENTFEATURES(IMG_FILENAME, CACHE_DIR, 
%         FORCE_RECALCULATE_SEG, FORCE_RECALCULATE_FEATURES)
%   Calculates all segment features of IMG_FILENAME. Data is cached in 
%   CACHE_DIR.
%
%   Positional parameters:
%
%     IMG_FILENAME                 Full path of an input image
%     CACHE_DIR                    A directory path, all cached data is 
%                                  stored here
%     FORCE_RECALCULATE_SEG        If true, cache will not be used for
%                                  segmentation
%     FORCE_RECALCULATE_FEATURES   If true, cache will not be used for
%                                  features
%
%   Return values:
%
%     ALLFEATURES      S x F matrix, where S is number of segments in
%                      input image and F is number of segment features
%
%   References:
%
%   Fried O., Shechtman E., Goldman D., and Finkelstein A. (2015) Finding 
%   Distractors In Images. Computer Vision and Pattern Recognition (CVPR)

  tic;

  % by default, we use the cache
  if (nargin < 4)
    force_recalculate_features = false;
  end
  if (nargin < 3)
    force_recalculate_seg = false;
  end
  
  % threshold for segmentation
  THRESHOLD = 0.4;
  
  % create cache file name
  [~, img_filename_no_ext, ~] = fileparts(img_filename);
  mat_filename = [img_filename_no_ext '.mat'];

  % read image
  img = im2double(imread(img_filename));

  % read cache
  cached_data = matfile([cache_dir mat_filename], 'Writable', true);
  
  info = whos(cached_data, 'segment_features');
  if ~(isempty(info) || force_recalculate_features)
    % If cached, there's nothing to do
    fprintf('[-] [CreateSegmentFeatures] Skipped %s, features loaded from cache...\n', img_filename_no_ext);
    allfeatures = cached_data.segment_features;
    return;
  end
  
  info = whos(cached_data, 'segments_UCM');
  if isempty(info) || force_recalculate_seg
    % if segmentation is not already in cache, we need to calculate it 
    % (and append to cache)
    img_segmentation = im2ucm(img, 'fast');
    cached_data.segments_UCM = img_segmentation;
  else
    img_segmentation = cached_data.segments_UCM;
  end

  % Segmentation img is x2 the size of input image. Resize and threshold
  img_segmentation_resized = img_segmentation(1:2:end-1, 1:2:end-1);
  img_segmentation_binary = img_segmentation_resized > THRESHOLD;

  % Calculating segment-only features (size, elongation, etc.)
  properties = {
    'BoundingBox', 'Image', ...
    'Area', 'EulerNumber', 'Orientation', 'Extent', 'Perimeter', ...
    'ConvexArea', 'FilledArea', 'Solidity', 'Eccentricity', ...
    'MajorAxisLength', 'EquivDiameter', 'MinorAxisLength'
  };
  seg_stats = regionprops(~img_segmentation_binary, properties);

  % concatenate all segment-only features
  allfeatures = ...
    [[seg_stats.Area]' [seg_stats.MajorAxisLength]' ...
     [seg_stats.MinorAxisLength]' [seg_stats.Eccentricity]' ...
     [seg_stats.Orientation]' [seg_stats.ConvexArea]' ...
     [seg_stats.FilledArea]' [seg_stats.EulerNumber]' ...
     [seg_stats.EquivDiameter]' [seg_stats.Solidity]' ...
     [seg_stats.Extent]' [seg_stats.Perimeter]' ];

  % Calculate mean, max and median of all our pixel features for each segment
  feature_list = {...
    'SubbandFeatures', 'IttiFeatures', 'ColorFeatures', 'TorralbaSaliency', ...
    'HorizonFeatures', 'ObjectFeatures', 'DistToCenterFeatures', ...
    'DistToEdgeFeatures', 'HouSaliency', 'PCASaliency', 'Text', ...
    'CoxelSaliency', 'EdgeBoxes', 'EdgeBoxesTop20', 'EdgeBoxesNotInCenter', ...
    'AttenuatedSaliency', 'AttenuatedSaliencyFromPeak'
  };
  feature_list_size = 180;
  
  orig_dims = [size(img, 1) size(img, 2)];
  
  all_seg_features = zeros(numel(seg_stats), feature_list_size);
  
  % iterate all segments and features
  for ii = 1:numel(seg_stats)
    current_seg_features = [];
    segment_bounding_box = num2cell(ceil(seg_stats(ii).BoundingBox));
    segment_mask = seg_stats(ii).Image;
    
    for jj = 1:numel(feature_list)
      feature_name = feature_list{jj};
      
      retval = GetSegmentFeature(orig_dims, segment_bounding_box, segment_mask, feature_name, cached_data);
      current_seg_features = [current_seg_features retval];
    end
    all_seg_features(ii, :) = current_seg_features;
  end
    
  % append segment-only and segment-context features
  allfeatures = [allfeatures all_seg_features];
  
  % save segment features to .mat file
  cached_data.segment_features = allfeatures;
  
  fprintf('[+] [CreateSegmentFeatures] Processed %s, elapsed time = %.2f (secs)\n', img_filename_no_ext, toc);
end


function [seg_features] = GetSegmentFeature(orig_dims, segment_bounding_box, ...
                                            segment_mask, feature_name, ...
                                            cached_data)
  % We use 200x200 downsized image for feature calculation
  M = 200;
  N = 200;
  
  [x_start, y_start, x_len, y_len] = segment_bounding_box{:};
  x_end = x_start + x_len - 1;
  y_end = y_start + y_len - 1;
  
  feature_data = cached_data.(feature_name);
  feature_data = reshape(feature_data, M, N, []);
  
  seg_features = [];
  for ii = 1:size(feature_data, 3)
    feature_data_channel = feature_data(:, :, ii);
    
    % resize each of the features to fit the original image size
    feature_data_channel = imresize(feature_data_channel, orig_dims);
    
    % Only keep bounding box area
    feature_data_channel = feature_data_channel(y_start:y_end, x_start:x_end);
    
    % Only keep masked pixels
    feature_data_channel = double(feature_data_channel(segment_mask));
    
    % Return mean, median and max
    seg_features = [seg_features mean(feature_data_channel) median(feature_data_channel) max(feature_data_channel)];
  end
end