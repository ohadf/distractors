function features = findHorizonFeatures(img, dims, varargin)
%
% features = findHorizonFeatures(img, dims)

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

fprintf('Finding horizon...'); tic;

% Run horizon detector
h=getHorizon(img);

% Turn it into a map
HorizonMap=zeros(dims);
horizon=round((h+0.5)*dims(1));
HorizonMap(horizon-2:horizon+2, :)=1;
HorizonMap=antonioGaussian(HorizonMap, 2); % blur features
HorizonMap=HorizonMap/max(HorizonMap(:)); % make range 0-1
features=HorizonMap(:);
fprintf([num2str(toc), ' seconds \n']);

if nargout==0
    imshow(reshape(features, dims)); title(['Horizon']);
    display(['Horizon:', num2str(h)]);
end