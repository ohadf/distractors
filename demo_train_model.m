% This demo re-trains the full model. After training, it uses the newly 
% computed model to calculate a distractor prediction map.

% Please follow the readme in ./external for download instructions of all
% external packages. Edit install_all.m as needed.

% Install all external packages
run('./install_all.m');

% Add path to feature calculation, model training and distractor prediction
addpath(genpath('./calculate-features/'));
addpath('./train-new-model/');
addpath('./distractor-prediction/');

% IMG_PATH and GT_PATH are directories containing images and ground-truth 
% annotations (for model training). 
IMG_PATH = '../distractors_data/stimuli/';
GT_PATH = '../distractors_data/masks/';
% CACHE_DIR is used to cache feature calculation, so that features will not
% be re-computed across different executions of the code.
CACHE_DIR = '~/CACHE/';

% Compile a list of all training images
base_filenames = dir(IMG_PATH);
base_filenames = regexpi({base_filenames.name}, '.*png$|.*jpg$', 'match');
base_filenames = [base_filenames{:}];
img_filenames = fullfile(IMG_PATH, base_filenames);
gt_filenames = fullfile(GT_PATH, base_filenames);

% Train new model
new_model = TrainModel(img_filenames, gt_filenames, CACHE_DIR);

% Predict using model
target_filename = './Lenna.png';
output_img_model = im2distractor(target_filename, CACHE_DIR, new_model);

% Display result
segments_to_remove = 2;
output_img_order = CreateSegmentOrderImage(output_img_model, segments_to_remove);
input_img = im2double(imread(target_filename));
imshow([input_img output_img_order]);
