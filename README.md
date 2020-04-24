# light-field-refocus
Repo for Light Field Refocus Implementations

--------------------
System Requirements
--------------------

1. Hardware Requirements

- Any modern computer system (2014 or later) should be sufficient. 
- While a GPU is not necessary, it will be useful to have one since many MATLAB functions and packages are optimized internally to run better in the presence of a GPU.

2. Software Requirements

- All development was carried out on MATLAB r2019b and higher. All higher versions of MATLAB should be able to run all code without issue. Lower versions of MATLAB upto r2017a may be compatible since all associated functions and toolboxes are available starting version r2017. That said, this Demo package has not been tested on lower versions of MATLAB and so we cannot guarantee the performance.

- Please make sure the following MATLAB toolboxes and packages are present.
	- Computer Vision and Image Processing Toolbox
	- Parallel Computing Toolbox

--------------------
More Instructions
--------------------

The codebase has been logically segmented into the following sub-packages to that it is better organized.

1. DepthMap Generation
2. Antialiasing
3. Selective Refocus

Targeted README files have been included in each of the following sub-packages for the user's benefit.