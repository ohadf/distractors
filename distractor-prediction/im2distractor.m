function [distractor_map] = im2distractor(img_filename, cache_dir, distractor_model)
%IM2DISTRACTOR Create a distractor prediction map for a given image
%   [OUTPUT_IMG_MODEL] = IM2DISTRACTOR(IMG_FILENAME, CACHE_DIR, DISTRACTOR_MODEL)
%   takes an image filename as input and calculates a distractor map for 
%   the image. 
%
%   Positional parameters:
%
%     IMG_FILENAME      Input image full file name
%     CACHE_DIR         Directory where all features are cached
%     DISTRACTOR_MODEL  A struct containing the following fields:
%                       feature_mean -- mean of training features
%                       feature_std  -- standard dev of training features
%                       model        -- the model (weight matrix)
%
%   Return values:
%
%     DISTRACTOR_MAP    An image with a distractor score per segment
%
%   References:
%
%   Fried O., Shechtman E., Goldman D., and Finkelstein A. (2015) Finding 
%   Distractors In Images. Computer Vision and Pattern Recognition (CVPR)

  % We calculate features on a downscaled version of the images
  DIMS = [200, 200];

  % Calculate segment features
  test_X = CreateFeatures(img_filename, cache_dir, DIMS);
  
  % Whitening
  num_segments = size(test_X, 1);
  test_X = test_X - repmat(distractor_model.feature_mean, [num_segments, 1]);
  test_X = test_X ./ repmat(distractor_model.feature_std, [num_segments, 1]);

  % Distractor prediction
  Y = test_X * distractor_model.model;

  % Return result
  distractor_map = Labels2Image(cache_dir, img_filename, Y);
end


function [output_img] = Labels2Image(cache_dir, img_filename, seg_values)
%LABELS2IMAGE Convert a list of segment labels into an image

  % Segmentation threshold
  THRESHOLD = 0.4;

  % We assume segmentation was already cached (and read it from cache)
  [~, img_filename_no_ext, ~] = fileparts(img_filename);
  cached_data = matfile([cache_dir img_filename_no_ext '.mat']);
  img_segmentation = cached_data.segments_UCM;

  % Resize and threshold segmentation
  img_segmentation_resized = img_segmentation(1:2:end-1, 1:2:end-1);
  img_segmentation_binary = img_segmentation_resized > THRESHOLD;
  
  % Collect all indices for each segment
  properties = {'PixelIdxList'};
  STATS = regionprops(~img_segmentation_binary, properties);
  
  % Replace all pixels belonging to a segment with the segment's value
  output_img = zeros(size(img_segmentation_binary));
  for ii = 1:numel(STATS)
    output_img(STATS(ii).PixelIdxList) = seg_values(ii);
  end
end
