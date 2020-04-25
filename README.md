# Team : light-field-refocusing

## Team Members

Akshay Viswakumar	- 32971665
Jeffrey Li		- 59322511
Yonghan Zhou		- 93506160
Zhihui Lu		- 85910719

--------------------
System Requirements
--------------------

## Minimum Requirements

All code was developed using the MATLAB version r2019b. All code in this package will run on any system capable of running MATLAB r2019b. Minimum requirements for running MATLAB r2019b are indicated on Mathworks' webpage linked below.

https://www.mathworks.com/support/requirements/previous-releases.html

### Other Mandatory Requirements

- Please make sure the following MATLAB toolboxes and packages are present.
	- Computer Vision and Image Processing Toolbox
	- Parallel Computing Toolbox
	
NOTE: This package should run fine on all newer releases of MATLAB (greater than r2019b). That said, this Demo package has not been tested on other versions of MATLAB so we cannot guarantee what the user experience might exactly be in other versions of MATLAB.

## Recommended Requirements

1. Hardware Requirements

- While a GPU is not necessary, it will be useful to have one since many MATLAB functions and packages are optimized internally to run better in the presence of a GPU.

- Our codebase utilizes several in-built MATLAB functions that are optimized to take advantage of the parallel computing and GPUs available in modern systems. To achieve the best performance please use a modern computer system with a processor having 4 cores or more as well as a GPU.

--------------------
More Instructions
--------------------

The codebase has been logically segmented into the following sub-packages so that it is better organized.

1. DepthMap Generation
2. Antialiasing
3. Selective Refocus

Targeted README files have been included in each of the following sub-packages for the user's benefit.
