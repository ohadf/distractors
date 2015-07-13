function features = findAttenuatedSaliencyFromPeak(img, dims, filename, varargin)
%FINDATTENUATEDSALIENCYFROMPEAK Attenuate saliency features with distance to peak
%
%   References:
%
%   Fried O., Shechtman E., Goldman D., and Finkelstein A. (2015) Finding 
%   Distractors In Images. Computer Vision and Pattern Recognition (CVPR)

fprintf('Multiplying saliency by reverse distance from center...'); tic;

S = load(filename);

all_saliency_features = [S.IttiFeatures S.TorralbaSaliency S.HouSaliency S.PCASaliency S.CoxelSaliency S.EdgeBoxes S.EdgeBoxesTop20];

features = zeros(size(all_saliency_features));

for ii = 1:size(all_saliency_features, 2)
  current_feature = reshape(all_saliency_features(:, ii), dims);
  [~, max_inds] = max(current_feature(:));
  [peak_y, peak_x] = ind2sub(dims, max_inds);
  current_mask = GetShiftedReverseGaussian(dims, peak_x, peak_y);
  
  current_feature = current_feature .* current_mask;
  max_current_feature = max(current_feature(:));
  if (0 == max_current_feature)
    max_current_feature = 1;
  end
  current_feature = current_feature ./ max_current_feature;
  
  features(:, ii) = current_feature(:);
end

fprintf([num2str(toc), ' seconds \n']);

end

function [out_filter] = GetShiftedReverseGaussian(dims, peak_x, peak_y)
  % We construct the Gaussian in a larger matrix and later truncate
  new_dims = dims .* 2;

  SIGMA = 0.35 .* sqrt(new_dims(1) .* new_dims(2));
  out_filter = fspecial('gaussian', new_dims, SIGMA);
  out_filter = 1 - out_filter ./ max(out_filter(:));

  % translate and crop
  x_center = floor(new_dims(2)/2) + floor(dims(2)/2) - peak_x;
  y_center = floor(new_dims(1)/2) + floor(dims(1)/2) - peak_y;
  x_start = x_center - floor(dims(2)/2);
  y_start = y_center - floor(dims(1)/2);
  x_end = x_start + dims(2) - 1;
  y_end = y_start + dims(1) - 1;
  out_filter = out_filter(y_start:y_end, x_start:x_end);
end