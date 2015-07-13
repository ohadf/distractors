function feature=colorHistogram(img, m)
%
% feature=colorHistogram(img, m)
% Create a histogram of colors

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


bins=10; % number of bins per color axis
if m>0
    img(:, :, 1) = medfilt2(img(:, :, 1), [m m], 'symmetric');
    img(:, :, 2) = medfilt2(img(:, :, 2), [m m], 'symmetric');
    img(:, :, 3) = medfilt2(img(:, :, 3), [m m], 'symmetric');
end

img(find(img>=0.999))=0.999;
img(find(img<=0))=0;
r=img(:, :, 1); r=r(:);
g=img(:, :, 2); g=g(:);
b=img(:, :, 3); b=b(:);

H=zeros(bins, bins, bins);
bucketsize=1/bins;
for ri=1:bins
   for gi=1:bins
       for bi=1:bins
           rmin=(ri-1)*bucketsize;
           rmax=ri*bucketsize;
           gmin=(gi-1)*bucketsize;
           gmax=gi*bucketsize;
           bmin=(bi-1)*bucketsize;
           bmax=bi*bucketsize;
           
           rInBucket=find(r>=rmin & r<rmax);
           gInBucket=find(g>=gmin & g<gmax);
           bInBucket=find(b>=bmin & b<bmax);
           
           I=intersect(intersect(rInBucket, gInBucket), bInBucket);
           H(ri, gi, bi)=length(I);
       end
   end
   X(ri)=rmin;
end


H=H+1;
Hpercent=H/(sum(sum(sum(H))));
Hprob=-log(Hpercent);

feature=zeros(length(r), 1);
for i=1:length(r)
    ri=floor(r(i)/bucketsize+1);
    gi=floor(g(i)/bucketsize+1);
    bi=floor(b(i)/bucketsize+1);
    feature(i)=Hprob(ri, gi, bi);
end