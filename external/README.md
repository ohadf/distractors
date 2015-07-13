First, let's define a variable with the base path to all 3rd party code we will use
```
BASE_PATH = '/location/of/code/distractors_code/external/';
```
For each of the packages below, place it inside your `external` directory and follow the installation instructions.

matlabPyrTools
--------------
<http://www.cns.nyu.edu/lcv/software.php>

```
addpath(genpath([BASE_PATH 'matlabPyrTools/']));
```

LabelMe MATLAB Toolbox
----------------------
<http://labelme.csail.mit.edu/Release3.0/browserTools/php/matlab_toolbox.php>

```
addpath([BASE_PATH 'LabelMeToolbox-master/features/']);
addpath([BASE_PATH 'LabelMeToolbox-master/imagemanipulation/']);
```

Note that LabelMe Toolbox includes a file called `pca.m` that clashes with the Matlab native `pca()`. This will cause issues later on. Since we are not using the LabelMe version, let's rename it
```
mv <LABEL_ME PATH>/features/pca.m <LABEL_ME PATH>/features/pca.m.old
```
Alternatively, you can use a package folder (`+package-name` syntax).

Discriminatively Trained Deformable Part Models (release 3.1)
-------------------------------------------------------------
<http://cs.brown.edu/~pff/latent-release3/>

Note that newer versions exist, however this code was written using release 3.1.

After downloading the code, you will need to run the compilation script. Open `compile.m` and make sure the correct option is active (for example, don't use BLAS if you don't have it. Also, you might need to change the outdated `-o` switch to `-output`). Next, you will need to compile and add the relevant directories to your search path:
```
compile();
addpath([BASE_PATH 'voc-release3.1/']);
addpath([BASE_PATH 'voc-release3.1/VOC2008/']);
```

Viola-Jones
-----------
<http://www.mathworks.com/matlabcentral/fileexchange/29437-viola-jones-object-detection>

After downloading the code, you will first need to convert the OpenCV `.xml` format to `.mat`
```
ConvertHaarcasadeXMLOpenCV('HaarCascades/haarcascade_frontalface_alt');
```

Next, add to search path
```
addpath([BASE_PATH 'ViolaJones_version0b/']);
addpath([BASE_PATH 'ViolaJones_version0b/HaarCascades/']);
```

OpenCV Text Detector
--------------------
<http://opencv.org/opencv-3-0.html>

OpenCV3.0 comes with a text detector under the `opencv_contrib` directory. You will need to install opencv and opencv_contrib. [Here](http://www.learnopencv.com/install-opencv-3-on-yosemite-osx-10-10-x/) is a nice tutorial for Mac users. OpenCV3.0 also comes with integrated Matlab support. However, currently the feature does not fully work on all configurations. Either get it to work the "standard" way, or use my workaround in the `opencv_text_detection` directory.

If you are using the workaround, you will still need to install OpenCV3.0. Afterwards, compile `textdetectionmex.cpp` within Matlab:
```
mex textdetectionmex.cpp -output textdetection -I/path/to/opencv3/build/include/ -L/path/to/opencv3/build/lib/ -lopencv_core.3.0.0 -lopencv_text.3.0.0 -lopencv_imgproc.3.0.0 -lopencv_highgui.3.0.0 -lopencv_imgcodecs.3.0.0
```

Next, you will need to edit `img2textmask.m`. Update the following with the full path to the `opencv_text_detection` directory.
```
PATH_TO_TEXT_DETECTOR = 'CHANGE ME';
```

SaliencyToolbox
---------------
<http://www.saliencytoolbox.net/download.html>

Download the code to the 3rd party directory, and add to path:
```
addpath([BASE_PATH 'SaliencyToolbox/']);
```

Dynamic Visual Attention: searching for coding length increments
----------------------------------------------------------------
<http://www.klab.caltech.edu/~xhou/projects/dva/dva.html>

Download and add to path.
```
addpath([BASE_PATH 'nips08matlab/']);
```

What Makes a Patch Distinct
---------------------------
<http://cgm.technion.ac.il/Computer-Graphics-Multimedia/Software/DstnctSal/>
```
addpath([BASE_PATH 'PCA_Saliency_CVPR2013/']);
bindir = mexext;
if strcmp(bindir, 'dll')
  bindir = 'mexw32';
end
addpath(fullfile([BASE_PATH 'PCA_Saliency_CVPR2013/EXT'], 'vl_slic'));
addpath(fullfile([BASE_PATH 'PCA_Saliency_CVPR2013/EXT'], 'vl_slic', bindir));
addpath(fullfile([BASE_PATH 'PCA_Saliency_CVPR2013/EXT'], 'IM2COLSTEP'));
```

VLFeat
------
<http://www.vlfeat.org/>
```
run([BASE_PATH 'vlfeat-0.9.20/toolbox/vl_setup.m']);
```

A Closer Look at Context: From Coxels to the Contextual Emergence of Object Saliency
------------------------------------------------------------------------------------
Request code from authors.
Remove the `VLFeat` directory from within the code (if exists), since we already installed it. Add to path:
```
addpath(genpath([BASE_PATH '[SaliencyViaCoxels]/']));
```
Note: omitting this feature, our model still performs well. Thus, if you are having trouble obtaining the code, simply omit the feature. This will also speed up feature calculation, since coxel features are the slowest to compute out of all our features.

Piotr's Matlab Toolbox
----------------------
<http://vision.ucsd.edu/~pdollar/toolbox/doc/>
```
addpath(genpath([BASE_PATH 'PiotrToolbox/']));
```
Similarly to LabelMe, Piotr's Toolbox includes a file called `pca.m` that clashes with the Matlab native `pca()`. This will cause issues later on. Let's rename it
```
mv <TOOLBOX PATH>/classify/pca.m <TOOLBOX PATH>/classify/pca.m.old
```
Alternatively, you can use a package folder (`+package-name` syntax).

Structured Edge Detection Toolbox
---------------------------------
<http://research.microsoft.com/en-us/downloads/389109f6-b4e8-404c-84bf-239f7cbf4e3d/>
```
addpath([BASE_PATH 'EdgeBoxes/']);
addpath([BASE_PATH 'EdgeBoxes/models/forest/']);
```
Now follow `readme.txt` to compile all mex files.

MCG: Multiscale Combinatorial Grouping
--------------------------------------
<http://www.eecs.berkeley.edu/Research/Projects/CS/vision/grouping/mcg/#code>

You will only need the `pre-trained` directory. Copy it to the 3rd party folder and run the installation script:
```
run([BASE_PATH 'pre-trained/install.m']);
```
