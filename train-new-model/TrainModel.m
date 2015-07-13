function [result] = TrainModel(img_filenames, gt_filenames, cache_dir)
%TRAINMODEL Train a distractor prediction model
%   [RESULT] = TRAINMODEL(IMG_FILENAMES, GT_FILENAMES, CACHE_DIR) trains a
%   new distractor prediction model using images and ground-truth
%   distractor annotations. A cache directory is used to make sure are only
%   calculated once.
%
%   Positional parameters:
%
%     IMG_FILENAMES    A cell array, each cell contains the full path of an
%                      input image.
%     GT_FILENAMES     A cell array, each cell contains the full path of an
%                      annotation image. Note that GT_FILENAMES{k} is the
%                      annotation for IMG_FILENAMES{k}.
%     CACHE_DIR        A directory path, all cached data is stored here.
%
%   Return values:
%
%     RESULT           The trained model and normalization parameters, in
%                      the form of a struct with the following fields:
%                      result.model        -- prediction model
%                      result.feature_mean -- vector with feature means
%                      result.feature_std  -- vector with feature stdevs
%
%   References:
%
%   Fried O., Shechtman E., Goldman D., and Finkelstein A. (2015) Finding 
%   Distractors In Images. Computer Vision and Pattern Recognition (CVPR)

  % We calculate features on a downscaled version of the images
  DIMS = [200, 200];
  
  % Init variables
  result = struct();
  train_X = [];
  train_Y = [];

  % Iterate over all input imagges
  for ii = 1:numel(img_filenames)
    % Calculate segment features
    X = CreateFeatures(img_filenames{ii}, cache_dir, DIMS);
    % Calculate segment ground truth
    Y = CreateSegmentGroundTruth(img_filenames{ii}, gt_filenames{ii}, cache_dir);
    % We use segment mean (columns 2 and 3 are median and max)
    Y = Y(:, 1);

    % Append all training data
    train_X = [train_X ; X];
    train_Y = [train_Y ; Y];
  end

  % Whitening
  [train_X, result.feature_mean, result.feature_std] = WhitenTrainingData(train_X);

  % Construct model using LASSO
  [b, fitinfo] = lasso(train_X, im2double(train_Y), 'CV', 10);  
  result.model = b(:, fitinfo.Index1SE);
end


function [training_data, mean_vec, std_vec] = WhitenTrainingData(training_data)
% Normalize training_data to have 0 mean and 1 stdev. Also return the means
% and stdevs, to be used when normalizing the testing data.

  % subtract mean from data
  mean_vec = mean(training_data, 1);
  training_data = training_data - repmat(mean_vec, [size(training_data, 1), 1]);

  % dividing by standard deviation
  std_vec = std(training_data);
  z = find(std_vec == 0);
  if ~isempty(z)
      warning('feature with stdev == 0 exists, using 1 instead');
      std_vec(z) = 1;
  end
  training_data = training_data ./ repmat(std_vec, [size(training_data, 1), 1]);
end
