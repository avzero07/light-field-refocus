# Light Field Refocusing Project

## Multi-resolution Correspondence-Matching Depth Estimation Sub Package

This sub-package contains all functions developed, as part of the overall project, to perform depth estimation. The package also contains a demo script, "depthmapMain" that can use the provided example data to generate a depth map.

----------------------------
Description of Sub Package
----------------------------

The sub-package consists of Functions, Scripts and some Sample Data

There are 7 function files. Please refer to each file for detailed comments about the purpose and design.

1. changeBaseView.m
2. genLfSequenceGray.m
3. multiResDepthEstm.m
4. getCoarseDepthmap.m
5. getRefinedDepthMap.m
6. computeZNCC.m
7. computeZNCCLocal.m
8. resizeLightField.m

There are 1 demo scripts to demonstrate how the functions may be used together. These scripts can be executed as is on MATLAB. Please make sure that the current working directory is set to this directory to ensure all relative paths are visible. Please refer to each file for detailed comments about their purpose and design.

1. depthmapMain.m
Note!!!: The time required for running this demo varies based on the hardware configuration of the platform where you run it. When running it on a high-end CPU with 32GB of RAM, it took 15 mins to complete the run. Please be patient if the run lasts for long!!!!

----------------------------
Other Contents of Demo Package
----------------------------

Note that the Sample-Data/ directory contains some images (subset of the Technicolor lightField Dataset) that are used in the Demo scripts to demonstrate results. Please refrain from making modificatios to the directory or its contents as it may impact the demo scripts.

The "Sample Data/ Depth Estimation Input" directory is the folder for you to put your input data and the "Sample Data/ Depth Estimation Output" is where you can find the depth map output of the demo.


----------------------------
Instruction for running the Demo Package
----------------------------
Go to the "depthmapMain.m".

For demo, nothing need to be configured, just run the demo script as it is.

For running the depth estimation tool with your own data, configure all the parameters under Parameter Setting section to meet the spec of your dataset and requirement.

The 'for' loop that loops through selected frames supports parallel computing, however it is heavy on memory consumption. Use it with caution, the more worker you use, the more memory it consumes.

Restriction:

1.The resolution of the image has been hard coded in multiple places inside the code, must be changed to use image with different resolution. Our hard coded resolution is 1088x2048

2.The logic inside the changeBaseView function and genLfSequenceGray function is very specific to the Technicolor lightField Dataset, you may need to modify the logic of these two functions before they can be applied to your own dataset. Especially when your data file naming convention is different and your camera rig system is not 4 by 4.
