function features = findObjectFeatures(img, dims, varargin)
%
% features = findObjectFeatures(img, dims)
% Find all the faces, cars and people in the images

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

[w h c] = size(img);
Cars=zeros(w, h);
People=zeros(w, h);
Faces=zeros(w,h);

%-----------------%
% Find Cars      
%-----------------%
fprintf('Finding cars...'); tic;
load car_final.mat; % loads a car model
boxes = detect(img, model, 0);
top = nms(boxes, 0.4);

bboxes = getboxes(model, boxes);
top = nms(bboxes, 0.4);
bboxes = clipboxes(img, top);

for j=1:size(bboxes, 1)
    b = max(floor(bboxes(j, :)), 1);
    Cars(b(2):b(4), b(1):b(3))=1;
end
Cars = imresize(Cars, dims);
features(:, 1) = Cars(:);
fprintf([num2str(toc), ' seconds \n']);


%-----------------%
% Find People      
%-----------------%
fprintf('Finding people...'); tic;
load person_final.mat; % loads a person model
boxes = detect(img, model, 0);
top = nms(boxes, 0.4);

bboxes = getboxes(model, boxes);
top = nms(bboxes, 0.4);
bboxes = clipboxes(img, top);

for j=1:size(bboxes, 1)
    b = max(floor(bboxes(j, :)), 1);
    People(b(2):b(4), b(1):b(3))=1;
end
People = imresize(People, dims);
features(:, 2) = People(:);
fprintf([num2str(toc), ' seconds \n']);

%-----------------%
% Find Faces      
%-----------------%

fprintf('Finding faces...'); tic;

FilenameHaarcasade = 'haarcascade_frontalface_alt.mat';
Objects = ObjectDetection(img, FilenameHaarcasade);

for ii=1:size(Objects, 1)
  current_face = Objects(ii, :);
  Faces(ceil(current_face(2)+eps):floor(current_face(2)+current_face(4)), ceil(current_face(1)+eps):floor(current_face(1)+current_face(3))) = 1;
end
Faces = imresize(Faces, dims);

%ShowDetectionResult(img, Objects);

features(:, 3) = Faces(:);
fprintf([num2str(toc), ' seconds \n']);


if nargout <1
    figure;
    subplot(141); imshow(img);
    subplot(142); imshow(Cars); title(['Cars']);
    subplot(143); imshow(People); title(['People']);
    subplot(144); imshow(Faces); title(['Faces']);
end
