% This demo calculate a distractor prediction map for a given image. It
% uses the pre-calculated model that was created using our dataset, as
% described in the paper.

% Please follow the readme in ./external for download instructions of all
% external packages. Edit install_all.m as needed.

% Install all external packages
run('./install_all.m');

% Add path to feature calculation and distractor prediction code
addpath(genpath('./calculate-features/'));
addpath('./distractor-prediction/');

% CACHE_DIR is used to cache feature calculation, so that features will not
% be re-computed across different executions of the code.
CACHE_DIR = '~/CACHE/';
% TARGET_FILENAME points to an image, for which we will
% calculate a distractor map.
TARGET_FILENAME = './Lenna.png';

% Load precalculated model
precalculated_model = matfile('distractor-model.mat');

% Predict using model
output_img_model = im2distractor(TARGET_FILENAME, CACHE_DIR, precalculated_model);

% Display result
segments_to_remove = 2;
output_img_order = CreateSegmentOrderImage(output_img_model, segments_to_remove);
input_img = im2double(imread(TARGET_FILENAME));
imshow([input_img output_img_order]);
