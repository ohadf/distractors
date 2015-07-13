function [allfeatures] = CreateIndividualFeatures(images, cache_dir, dims, feature_list)
%CREATEINDIVIDUALFEATURES Collect features for a list of images
%   [ALLFEATURES] = CREATEINDIVIDUALFEATURES(IMAGES, CACHE_PATH, DIMS, FEATURE_LIST)
%   Calculates the features in FEATURE_LIST for all IMAGES. Data is cached
%   in CACHE_DIR. Images are first down-scaled to size DIMS.
%
%   Positional parameters:
%
%     IMAGES           Cell array, each cell contains the full path of an
%                      input image.
%     CACHE_DIR        A directory path, all cached data is stored here.
%     DIMS             Images are resized to DIMS before feature
%                      calculation
%     FEATURES_LIST    Cell array with names of features to calculate. Each
%                      feature name must have a corresponding find function
%                      in ./Features. For example, the 'Text' feature will
%                      be calculated via the function findText()
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

  % Iterate all input images
  for ii = 1:length(images)
    imagefile = images{ii};

    % Constract cache file name
    [~, filename_no_ext, ~] = fileparts(images{ii});
    feature_file = fullfile(cache_dir, [filename_no_ext '.mat']);

    % Read image
    image = imread(imagefile);

    % Calculate starting index of feature (within allfeatures)
    index = (ii-1)*(dims(1)*dims(2));

    % Load features from cache if available
    if (exist(feature_file, 'file'))
      cached_features = load(feature_file);
    else
      cached_features = [];
    end

    % if feature_list is empty, we use random numbers as features (for
    % baseline)
    if isempty(feature_list)
      NUM_RAND_FEATURES = 10;
      tmp = rand(dims(1) * dims(2), NUM_RAND_FEATURES);
    else
      % We collect the features specified in feature_list
      tmp = [];
      for jj = 1:numel(feature_list)      
        feature_name = feature_list{jj};
        % Collect current feature
        feature_data = FindFeature(cached_features, feature_name, feature_file, image, dims);

        % No nans are allowed
        if any(isnan(feature_data(:)))
          error('NaNs detected in feature %s, file %s', feature_name, feature_file);
        end

        % Append features
        tmp = [tmp feature_data];
      end
    end

    % Only at this point we know the number of features. We allocate the
    % buffer if this is the first iteration
    if ~exist('allfeatures', 'var')
      allfeatures = zeros(dims(1)*dims(2)*length(images), size(tmp, 2));
    end

    allfeatures(index+1:index+dims(1)*dims(2), :) = tmp;

    fprintf('.');
  end
end


function [out_feature] = FindFeature(cached_features, feature_name, feature_file, image, dims)
  % If feature exists in cache, return it
  if (isfield(cached_features, feature_name))
    out_feature = cached_features.(feature_name);
  else
    % construct a function handle (function will always be of the form find*)
    fh = str2func(['find' feature_name]);
    % calculate feature
    out_feature = fh(image, dims, feature_file);
    % cache for next time
    SAVE_DATA.(feature_name) = out_feature;
    if (exist(feature_file, 'file'))
      save(feature_file, '-struct', 'SAVE_DATA', '-append');
    else
      save(feature_file, '-struct', 'SAVE_DATA');
    end
  end
end
