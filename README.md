# MSSEG: MS Lesion Segmentation

Here is the MATLAB code related to the
[MASc Thesis](http://hdl.handle.net/10214/12142)
and
[paper](https://doi.org/10.1016/j.mri.2018.06.009)
by Jesse Knight 

This readme best viewed in
[git markup](https://jbt.github.io/markdown-editor/).

## Contents

```
code/
├── data/         % all .mat files, usually results of cross validation and preprocessed data
│   ├── misc/     % .mat from non-VLR experiments
│   ├── train/    % .mat with preprocessed data to save recompute for during train-test runs
│   └── tmp/      % for temporary .mat files during performance analysis using performancebat
├── exp/          % (no files)
│   ├── hyp/      % hyperparameter definitions and variants for exploration
│   ├── toy/      % framework for single-voxel toy model exploration
│   └── ystd/     % framework for toy exploration of graylevel standardization 
├── fig/          % specific figures used in the thesis, do not use VLR results
│   └── utils/    % utilities for streamlining figure generation for this project
├── paper/        % compute stats for paper, copy necessary figures, ROI stuff that went unused
├── spm/          % genbatch.m: create SPM batch files using templates
│   ├── deform/   % files to warp images to/from MNI using SPM pre-computed transforms (2 ways)
│   ├── ran/      % batch files which were already run with SPM
│   └── templates/% template batch files for a single job. Replace wildcards using genbatch.m
├── utils/        % various utilities used by other functions throughout
│   ├── fig/      % utilities for figure generation (can be used for any project)
│   ├── mri/      % utilities for MRI info: scan parameters and image name lookup tables (lut)
│   └── nii/      % utilities for loading .nii files into matlab (+ the filexchange toolbox)
└── vlr/          % the VLR model: functions for training and testing it
    └── ops/      % functions used by the VLR model, but not specific to it.
```

### Overview

Many files in this directory are well documented. Try `help <function>` for mor information.

- `vlr/uber.m` - This function should run all cross validations and other experiments necessary for the thesis, and then summarize the results and produce all figures in the thesis.
- `vlr/hypfill.m` & `utils/thesisname.m` & `utils/mri/imgname/imgname.m` - Contain absolute paths used throughout for loading and saving images and data; requires update before running.
- `vlr/arbiter.m` - The "main" function for one cross validation run using a particular set of hyperparameters (e.g. `exp/hyp/hypdef.m`)
- `vlr/hypdef.m` - All hyperparameters for the VLR model (specific combinations are saved in `exp/hyp/hypdef_final.m` & `exp/hyp/hypdef_baseline.m` - do not edit these)
- `vlr/vlrmap.m` - The training function for the VLR model. Uses GPU.
- `utils/fig/show/volshow & timshow` - really handy tools for viewing multiple 3D and 2D images in matlab. Well documented.
- `utils/fig` & `vlr/ops` - There are some really handy functions in here.

### Author

Jesse Knight 2017.
Contact: [jesse.x.knight@gmail.com](mailto:jesse.x.knight@gmail.com)

### References

[1] J Knight (2017). “Voxel-Wise Image Analysis for White Matter Hyperintensity Segmentation”. Master of Applied Science. University of Guelph.

[2] J Knight, G Taylor, and A Khademi (under revision). “Voxel-Wise Logistic Regression and Leave-OneScanner-Out Cross Validation for White Matter Hyperintensity Segmentation” in NeuroImage.

[3] WMH Segmentation Challenge 2017 - http://wmh.isi.uu.nl/results/knight/

