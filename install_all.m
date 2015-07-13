% To following assumes all external libraries were downloaded and placed in
% ./external/
% See ./external/README.md for download and installation instructions.

BASE_PATH = [cd(cd('./external/')) '/'];

addpath(genpath([BASE_PATH 'matlabPyrTools/']));

addpath([BASE_PATH 'LabelMeToolbox-master/features/']);
addpath([BASE_PATH 'LabelMeToolbox-master/imagemanipulation/']);

addpath([BASE_PATH 'voc-release3.1/']);
addpath([BASE_PATH 'voc-release3.1/VOC2008/']);

addpath([BASE_PATH 'ViolaJones_version0b/']);
addpath([BASE_PATH 'ViolaJones_version0b/HaarCascades/']);

addpath([BASE_PATH 'opencv_text_detection/']);

addpath([BASE_PATH 'SaliencyToolbox/']);

addpath([BASE_PATH 'nips08matlab/']);

addpath([BASE_PATH 'PCA_Saliency_CVPR2013/']);
bindir = mexext;
if strcmp(bindir, 'dll')
  bindir = 'mexw32'; 
end
addpath(fullfile([BASE_PATH 'PCA_Saliency_CVPR2013/EXT'], 'vl_slic'));
addpath(fullfile([BASE_PATH 'PCA_Saliency_CVPR2013/EXT'], 'vl_slic', bindir));
addpath(fullfile([BASE_PATH 'PCA_Saliency_CVPR2013/EXT'], 'IM2COLSTEP'));

run([BASE_PATH 'vlfeat-0.9.20/toolbox/vl_setup.m']);

addpath(genpath([BASE_PATH '[SaliencyViaCoxels]/']));

addpath(genpath([BASE_PATH 'PiotrToolbox/']));

% Note that EdgeBoxes and MCG might collide. One way to solve this is to
% keep the current order for segment feature calculation and swap it for
% pixel feature calculation. 
% A better approach would be to update the external code to use package
% folders...

addpath([BASE_PATH 'EdgeBoxes/']);
addpath([BASE_PATH 'EdgeBoxes/models/forest/']);

run([BASE_PATH 'pre-trained/install.m']);
