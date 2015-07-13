function [segment_gt] = CreateSegmentGroundTruth(img_filename, gt_filename, ...
  cache_dir, force_recalculate_seg, force_recalculate_seg_gt)
%CREATESEGMENTGROUNDTRUTH Collect all ground-truth segment annotations
%   [SEGMENT_GT] = CREATESEGMENTGROUNDTRUTH(IMG_FILENAME, GT_FILENAME,
%         CACHE_DIR, FORCE_RECALCULATE_SEG, FORCE_RECALCULATE_SEG_GT)
%   Calculates all segment ground-truth annotations of IMG_FILENAME. We
%   calculate mean, median and max ground-truth annotation per segment.
%   Data is cached in CACHE_DIR.
%
%   Positional parameters:
%
%     IMG_FILENAME                 Full path of an input image
%     GT_FILENAME                  Full path of a ground-truth annotation
%     CACHE_DIR                    A directory path, all cached data is 
%                                  stored here
%     FORCE_RECALCULATE_SEG        If true, cache will not be used for
%                                  segmentation
%     FORCE_RECALCULATE_SEG_GT     If true, cache will not be used for
%                                  ground-truth calculation
%
%   Return values:
%
%     SEGMENT_GT       S x 3 matrix, where S is number of segments in
%                      input image. Columns are mean, median and max
%
%   References:
%
%   Fried O., Shechtman E., Goldman D., and Finkelstein A. (2015) Finding 
%   Distractors In Images. Computer Vision and Pattern Recognition (CVPR)

  tic;

  % by default, we use the cache
  if (nargin < 5)
    force_recalculate_seg_gt = false;
  end
  if (nargin < 4)
    force_recalculate_seg = false;
  end

  % threshold for segmentation
  THRESHOLD = 0.4;
  
  % create cache file name
  [~, img_filename_no_ext, ~] = fileparts(img_filename);
  mat_filename = [img_filename_no_ext '.mat'];
  
  % read cache
  cached_data = matfile([cache_dir mat_filename], 'Writable', true);

  % Check whether the segment ground truth data was already cached
  info = whos(cached_data, 'segment_gt');
  if ~(isempty(info) || force_recalculate_seg_gt)
    % If cached, there's nothing to do
    fprintf('[-] [CreateSegmentGroundTruth] Skipped %s, loaded from cache...\n', img_filename_no_ext);
    segment_gt = cached_data.segment_gt;
    return;
  end  
  
  % read image
  img = im2double(imread(img_filename));
  
  % Check whether the segmentation was already calculated and cached
  info = whos(cached_data, 'segments_UCM');
  if isempty(info) || force_recalculate_seg
    % if segmentation is not already in cache, we need to calculate it (and append to cache)
    img_segmentation = im2ucm(img, 'fast');
    cached_data.segments_UCM = img_segmentation;
  else
    img_segmentation = cached_data.segments_UCM;
  end

  % Segmentation img is x2 the size of input image. Resize and threshold
  img_segmentation_resized = img_segmentation(1:2:end-1, 1:2:end-1);
  img_segmentation_binary = img_segmentation_resized > THRESHOLD;

  % Calculate bounding-box and create a pixel mask for each segment
  properties = {'BoundingBox', 'Image'};
  seg_stats = regionprops(~img_segmentation_binary, properties);

  % Each row represents a single segment (contains mean, median and max of 
  % ground truth in that segment)

  % Read gt annotation
  gt_img = im2double(imread(gt_filename));
  % if color image, use the red channel
  if size(gt_img, 3) == 3
    gt_img = gt_img(:, :, 1);
  end
  orig_dims = [size(img, 1) size(img, 2)];

  % Allocate space for 3 measurements (mean, median, max) per segment
  segment_gt = zeros(numel(seg_stats), 3);
  
  % Calculate values per segment
  for ii = 1:numel(seg_stats)
    segment_bounding_box = num2cell(ceil(seg_stats(ii).BoundingBox));
    segment_mask = seg_stats(ii).Image;
    
    segment_gt(ii, :) = GetSegmentGt(orig_dims, segment_bounding_box, segment_mask, gt_img);
  end
  
  % save segment features to .mat file
  cached_data.segment_gt = segment_gt;
  
  fprintf('[+] [CreateSegmentGroundTruth] Processed %s, elapsed time = %.2f (secs)\n', img_filename_no_ext, toc);
end


function [seg_gt] = GetSegmentGt(orig_dims, segment_bounding_box, segment_mask, gt_img)
  [x_start, y_start, x_len, y_len] = segment_bounding_box{:};
  x_end = x_start + x_len - 1;
  y_end = y_start + y_len - 1;
  
  % resize gt to fit the original image size
  gt_img = imresize(gt_img, orig_dims);

  % Only keep bounding box area
  gt_img = gt_img(y_start:y_end, x_start:x_end);

  % Only keep masked pixels
  gt_img = double(gt_img(segment_mask));

  % Return mean, median and max
  seg_gt = [mean(gt_img) median(gt_img) max(gt_img)];
end