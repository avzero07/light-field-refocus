# Light Field Refocusing Project

## Selective Refocus Sub Package

This sub-package contains all functions developed, as part of the overall project, to perform selective refocusing. The package also contains some demo scripts to illustrate how these functions may be used to perform selective refocus.

-----------------------------------------------
# Description of Selective Refocus Sub Package
-----------------------------------------------

The sub-package consists of Functions, Scripts and some Sample Data

There are 6 function files. Please refer to each file for detailed comments about the purpose and design.

1. changeBaseView.m
2. genDepthSequence.m
3. genImSequence.m
4. genLfSequence.m
5. selectiveBlurring.m
6. shiftSumRefocus.m

There are 3 demo scripts to demonstrate how the functions may be used together. These scripts can be executed as is on MATLAB. Please make sure that the current working directory is set to this directory to ensure all relative paths are visible. Please refer to each file for detailed comments about their purpose and design.

1. demoShiftSumRefocus.m
2. demoSelectiveRefocus.m
3. demoSelectiveRefocusVideo.m

There is an additional CSV file 'refocusPlan.csv' that is included in this sub-package. Note that this file is used in 'demoSelectiveRefocusVideo.m'. Please refer to the script to get more information about this file.

NOTE: Each demo can take upto 5 minutes to run depending on system capabilities. Runtime should be less than 5 minutes if the system meets recommended requirements (refer to README file in the root folder of the Project Package).

--------------------------------------------------
# Other Contents of Selective Refocus Sub Package
--------------------------------------------------

Note that the Sample-Data/ directory contains some images (subset of the Technicolor lightField Dataset) that are used in the Demo scripts to demonstrate results. Please refrain from making modificatios to the directory or its contents as it may impact the demo scripts.
