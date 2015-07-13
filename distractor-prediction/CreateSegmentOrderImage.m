function [combined_img] = CreateSegmentOrderImage(output_img_model, threshold_val)
%CREATESEGMENTORDERIMAGE Create colormap image (to show order of segments)
%   [COMBINED_IMG] = CREATESEGMENTORDERIMAGE(OUTPUT_IMG_MODEL, THRESHOLD_VAL)
%   create an image indicating the segment order and the ones that will be
%   removed according to THRESHOLD_VAL. Segments are shown on a green to
%   yello scale (green being the lowest distractor score). Top distracting
%   segments are shown on a red to yellow scale, red being the most
%   distracting.
%
%   Positional parameters:
%
%     OUTPUT_IMG_MODEL  The row distractor scores of each segment
%     THRESHOLD_VAL     Number of top segments to highlight
%
%   Return values:
%
%     COMBINED_IMG      Image depiction of the distractor prediction scores
%
%   References:
%
%   Fried O., Shechtman E., Goldman D., and Finkelstein A. (2015) Finding 
%   Distractors In Images. Computer Vision and Pattern Recognition (CVPR)

  % Calculate all unique score values (excluding 0)
  all_pred_values = setdiff(unique(output_img_model(:)), 0);
  
  % Init output image
  output_img_model_color = zeros(size(output_img_model));
  
  % Transform each unique value into an (increasing) integer value
  for ii = 1:numel(all_pred_values)  
    output_img_model_color(output_img_model == all_pred_values(ii)) = ii;
  end
  
  % Generate colormaps
  num_colors = max(output_img_model_color(:));
  green_colormap = summer(num_colors);
  red_colormap = flipud(autumn(max(10, threshold_val)));
  combined_colormap = [green_colormap(1:end-threshold_val, :) ; red_colormap(end-threshold_val+1:end, :)];

  % Create output image
  combined_img = im2double(label2rgb(output_img_model_color, combined_colormap));
end
