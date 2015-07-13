function features = findSubbandFeatures(img, dims, varargin)
%
% features = findSubbandFeatures(img, dims)
% find the coefficients of the subbands of the steerable pyramid
% 

% Modified from:
% ----------------------------------------------------------------------
% Matlab tools for "Learning to Predict Where Humans Look" ICCV 2009
% Tilke Judd, Kristen Ehinger, Fredo Durand, Antonio Torralba
% 
% Copyright (c) 2010 Tilke Judd
% Distributed under the MIT License
% See MITlicense.txt file in the distribution folder.
% 
% Contact: Tilke Judd at <tjudd@csail.mit.edu>
% ----------------------------------------------------------------------

img = imresize(img, dims);
Nsc = maxPyrHt(dims, [15 15])-1; % Number of scales
edges = 'reflect1';
pyrFilters = 'sp3Filters';

% Find the Steerable Pyramid elements
[pyr, ind] = buildSpyr(double(mean(img,3)), Nsc, pyrFilters, edges);
features = zeros(dims(1)*dims(2), length(ind)-1);

for b=1:length(ind)-1
    out =  pyrBand(pyr,ind,b);
    absOut = abs(out);
    % Low pass the band with a gaussian filter
    gf = fspecial('gaussian', 6, 2);
    absOutBlurred = imfilter(absOut,gf,'replicate');
    absOutMean = absOutBlurred/mean(mean(absOutBlurred)); % Divide the band by the mean
    absOutMeanResized = imresize(absOutMean, dims);  %this reinterpolates the band to be the same size as the image.
    % Fill in features
    features(:, b) = absOutMeanResized(:);
end

if nargout<1
    for b = 1:13
        subband = reshape(features(:, b), dims);
        subplot(3, 6, b); imagesc(subband); title(strcat('band=', num2str(b))); %colorbar;
    end
end