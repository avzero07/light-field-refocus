# Light Field Refocusing Project

## Antialiasing Sub Package

This sub-package contains all functions developed, as part of the overall project, 
to perform shift and sum with disparity-based local interpolation algorithm. 
The sub-package also contains some sample data and a demo script to illustrate how 
these functions may be used to perform the antialiasing in light field refocusing.

-------------------------
Functions of Antialiasing
-------------------------

There are 4 function files. Please refer to each file for detailed comments 
about the purpose and design.

1. antialiasing.m
2. genLfSequence.m
3. interpolation.m
4. lfShiftSum.m

------------------------
Script of Antialiasing
------------------------

There is a script to demonstrate how the functions may be used together. 
These scripts can be executed as is on MATLAB. Please make sure that the 
current working directory is set to this directory to ensure all relative 
paths are visible. Please refer to each file for detailed comments about 
their purpose and design.

Note: this script might take around 15 mins that depends on your computer configuration.

1. antialiasingMain.m

----------------------------
Sample Data of Antialiasing
----------------------------

The directory './Sample-Data/' stores some sample data used in the demo script
to generate the results.
- 'Sample Data/Light Field' contains a frame sequence of light field sub-aperture 
  images that are used as the inpus in the demo script.
- 'Sample Data/Depth Map' contains the corresponding depth maps of each image 
  generated from the 'Depth Estimation' sub-package.
- 'Sample Data/Output' is the directory saving the output images from the demo script.
