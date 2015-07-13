Finding Distractors In Images
=============================

This file contains code for our CVPR 2015 paper. If you use the code, please add the following cite:

    @inproceedings{Fried:2015:FDI,
      author = "Ohad Fried and Eli Shechtman and Dan B Goldman and Adam Finkelstein",
      title = "Finding Distractors In Images",
      booktitle = "Computer Vision and Pattern Recognition (CVPR)",
      year = "2015",
      month = jun
    }

Dependencies
------------
The code has many external dependancies. First and foremost, an early version of the code was based on "learning to predict where humans look", for which we are very grateful. Since parts of that code are still present, please consider citing appropriately.

You will need to install other external packages. Please refer to `./external/README.md` for installation instructions.

Getting started
---------------
After completing the installation process in `./external/README.md`, the demo files should execute properly. We supply two demos:
- `demo_predict.m` calculates a distractor prediction map for a given image, using our precalculated model. Start here if you want to predict distractor locations.
- `demo_train_model.m` trains a new distractor prediction model. Start here if you want to augment our model with new features and algorithms.

Compatibility
-------------
The code was tested on Mac OS X 10.10, using Matlab R2015a. It should work on other configurations with minor adjustments. If you happen to make such adjustments, it would be great if you are willing to share! Propose a change via GitHub and I'll integrate your changes for everyone to enjoy.

For any questions, comments or suggestions, please contact [Ohad Fried](http://www.cs.princeton.edu/~ohad/)

<sub><sup>_Version 1.0_</sup></sub>
