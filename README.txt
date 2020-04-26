# Team : Light Field Refocusing

## Team Members

Akshay Viswakumar	- 32971665

Jeffery Li		- 59322511

Yonghan Zhou		- 93506160

Zhihui Lu		- 85910719

--------------------
# System Requirements
--------------------

## Minimum Requirements

All code was developed using the MATLAB version r2019b. All code in this package will run on any system capable of running MATLAB r2019b. System requirements for running MATLAB r2019b are indicated on Mathworks' webpage linked below.

https://www.mathworks.com/support/requirements/previous-releases.html

### Other Mandatory Requirements

- Please make sure the following MATLAB toolboxes and packages are present.
	- Computer Vision and Image Processing Toolbox
	- Parallel Computing Toolbox
	
NOTE: This package should run fine on all newer releases of MATLAB (greater than r2019b). That said, this Demo package has not been tested on other versions of MATLAB so we cannot guarantee the same user experience in other versions of MATLAB.

## Recommended Requirements

- While a GPU is not necessary, it will be useful to have one since many MATLAB functions and packages are optimized internally to run better in the presence of a GPU.

- Our codebase utilizes several in-built MATLAB functions that are optimized to take advantage of the parallel computing and GPUs available in modern systems. To achieve the best performance please use a modern computer system with a processor having 4 cores or more as well as a GPU.

--------------------
# More Instructions
--------------------

The codebase has been logically segmented into the following sub-packages so that it is better organized.

1. DepthMap Generation
2. Antialiasing
3. Selective Refocus

Targeted README files have been included in each of the following sub-packages for the user's benefit.

----------------------------------------
# Possible Enhancements and Future Work
----------------------------------------

### 1. Optimize Algorithms

- Depth estimation using multi-resolution correspondence matching is quite slow since since the algorithm needs to process 16 sub-aperture images to generate a depth-map for one reference view. It will be worthwhile to make modifications to the algorithm in order to take advantage of parallel processing and GPU computing to speed up overall computation.

- Depth estimation currently uses Zero-mean Normalised Cross Correlation (ZNCC) as the metric of similarity.  However, the way it averages the cross correlation leads to the appearance of noise at the edges of the depth map.  It may be worth exploring other algorithms to replace ZNCC in order to try an improve the overall accuracy.
    
- Selective blurring currently works by creating filtered versions of the input image which are then used as a look-up table when generating the final output. The algorithm can slow down when there are a large number of depth levels. A way of optimizing this would be to run a raster scan over the image and perform localized filtering at each pixel. The benefit of this approach is that the overall algorithm can then be parallelized over several  CPU cores for faster processing. It may also be possible to leverage a GPU to further improve performance.

### 2. Enhance Depth-maps

The depth-maps generated using multi-resolution correspondence matching are prone to some noise and minor artifacts. While this does not severely impact refocusing efforts, a post-filtering or post-processing stage can be incorporated to the depth estimation step to ensure that depth-maps are clean and free of any errors. Overall, improving the accuracy of the depth map will help also help improve the quality of the refocused image.

### 3. Localized Refocusing

This enhancement would allow for specific objects in a scene to be in focus. The current implementation of selective blurring refocuses all pixels in depth levels that the user specifies. This may not be ideal and users may be interested in only certain object within a scene. Object recognition methods may be incorporated into the selective blurring algorithm in order to ensure that only specific regions of interest are in focus. This can be an optional feature that the end user may toggle depending on how they want the refocusing to occur. 

### 4. User Interaction

The current implementation of selective blurring requires the user to set parameters (related to the depth planes which are to be focused and filter sizes) and run a script to generate the refocused output. It would definitely be worth designing a graphical user interface (GUI) component that allows users to dynamically interact with an image and refocus different regions of a scene by clicking on objects/regions of interest.

### 5. Expand Usage to Other Light Field Datasets

All functions and code that have been developed are tailored to the Interdigital light field dataset that has been used for this project. The codebase will need to be modified in order to extend usage to other light field datasets. We have left enough comments and notes within the codebase to help make modifications.
