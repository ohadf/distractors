function features = findAttenuatedSaliency(img, dims, filename, varargin)
%FINDATTENUATEDSALIENCY Attenuate saliency features with distance to center
%
%   References:
%
%   Fried O., Shechtman E., Goldman D., and Finkelstein A. (2015) Finding 
%   Distractors In Images. Computer Vision and Pattern Recognition (CVPR)

fprintf('Multiplying saliency by reverse distance from center...'); tic;

S = load(filename);

all_saliency_features = [S.IttiFeatures S.TorralbaSaliency S.HouSaliency S.PCASaliency S.CoxelSaliency S.EdgeBoxes S.EdgeBoxesTop20];

%attenuating_feature_centered = S.DistToCenterFeatures;
SIGMA = 0.7 .* sqrt(dims(1) .* dims(2));
attenuating_feature_centered = fspecial('gaussian', dims, SIGMA);
attenuating_feature_centered = 1 - attenuating_feature_centered ./ max(attenuating_feature_centered(:));
attenuating_feature_centered = attenuating_feature_centered(:);

features = all_saliency_features .* repmat(attenuating_feature_centered, 1, size(all_saliency_features, 2));
% Normalize each feature
max_of_features = max(features);
max_of_features(max_of_features == 0) = 1;
features = features ./ repmat(max_of_features, size(features, 1), 1);

%features = map(:);
fprintf([num2str(toc), ' seconds \n']);