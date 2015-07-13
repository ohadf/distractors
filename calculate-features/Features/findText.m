function features = findText(img, dims, varargin)
%FINDTEXT Find text location in image
%
%   References:
%
%   Fried O., Shechtman E., Goldman D., and Finkelstein A. (2015) Finding 
%   Distractors In Images. Computer Vision and Pattern Recognition (CVPR)

  fprintf('Finding text...'); tic;

  im_text = img2textmask(img);
  im_text = imresize(im_text, [dims(1) dims(2)]);
  features = im_text(:);

  fprintf([num2str(toc), ' seconds \n']);
end