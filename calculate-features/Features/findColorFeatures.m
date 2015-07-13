function features = findColorFeatures(img, dims, varargin)
%
% features = findColorFeatures(img, dims)
% Find the colors, the color probabilities, and the 3D histogram of colors

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

fprintf('Finding Color channels...'); tic;
features=zeros(dims(1)*dims(2), 11);
img=imresize(img, dims);
img=im2double(img);

% calculate each color channel and the probability of that color
for i=1:3
    channel=img(:, :, i);
    features(:, i)=channel(:);
    
    [h,x] = hist(channel(:), 100);
    h = h+1; h = h/sum(h);
    probChannel = interp1(x, -log(h), channel(:), 'nearest', min(-log(h)));
    probChannel=(probChannel-min(probChannel(:)))/max(probChannel(:));
    features(:, i+3)=probChannel(:);
end
fprintf([num2str(toc), ' seconds \n']);



% use 3D histograms to find the probability of a color at different blur
% levels.
fprintf('Finding probabilities of colors at blur level...'); tic;
medianFilterSizes=[0, 2, 4, 8, 16];
for i=1:5
    m=medianFilterSizes(i);
    fprintf([num2str(m), ', ']);
    featureMap=colorHistogram(img, m);
    features(:, i+6)=featureMap(:);
end
fprintf([num2str(toc), ' seconds \n']);



if nargout==0
    subplot(2, 6, 12); imshow(img);
    for i=1:11
        subplot(2, 6, i); imagesc(reshape(features(:, i), dims));
    end
    subplot(2, 6, 1); title('Red');
    subplot(2, 6, 2); title('Green');
    subplot(2, 6, 3); title('Blue');
    subplot(2, 6, 4); title('Red Prob');
    subplot(2, 6, 5); title('Green Prob');
    subplot(2, 6, 6); title('Blue Prob');
    subplot(2, 6, 7); title('M=0');
    subplot(2, 6, 8); title('M=2');
    subplot(2, 6, 9); title('M=4');
    subplot(2, 6, 10); title('M=8');
    subplot(2, 6, 11); title('M=16');
end
