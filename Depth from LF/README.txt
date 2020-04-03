Francisco Carlos Calderon M.Sc April 2014
Creative commons 2.5 share alike by non-commercial (if other licences not apply in your country)
there are 3 files included:

Dept_vol_subpixel_2: the main function
shift_image: sub function to shift...
PlotDepthdisparity: An extra function to plot "it is not necessary"

You need  to use a lightField of dimension LF(t,s,v,u,c) c=colour channels.
please use the help of the functions:
>>help Dept_vol_subpixel_2
>>help shift_image
>>help PlotDepthdisparity


-----------------------------------------------------------------------------

Important notes:

(1) To run our code you need to additionally download the "Guided Image Filter" [K. He, J. Sun, X. Tang, Guided Image Filtering, ECCV10] from Kaiming He's website (http://personal.ie.cuhk.edu.hk/~hkm007/) and extract the files "guidedfilter_color.m" and "boxfilter.m" into the same directory as the other Matlab files. we provide a simple modification called guidedfilterx and boxfilterx based in their original works. 

(2) The code is provided for academic use only. Use of the code in any commercial or industrial related activities is prohibited. 

(3) If you use our code we request that you cite the paper Depth map estimation in light fields using an stereo-like taxonomy


@INPROCEEDINGS{Calderon2014, 
author={Calderon, F.C. and Parra, C.A. and Nino, C.L.}, 
booktitle={Image, Signal Processing and Artificial Vision (STSIVA), 2014 XIX Symposium on}, 
title={Depth map estimation in light fields using an stereo-like taxonomy}, 
year={2014}, 
pages={1-5}, 
keywords={cameras;feature extraction;image processing;image sensors;lenses;optimisation;spatial variables measurement;angular information;cost tensor;depth map estimation;lens;light fields;optimization algorithm;single camera;spatial information;stereo depth-map algorithms;stereo-like taxonomy;support weight window;Cameras;Computer vision;Equations;Estimation;Mathematical model;Stereo vision;Taxonomy;Depth Map;Stereo Light field;Stereo Taxonomy;smoothing filter}, 
doi={10.1109/STSIVA.2014.7010131}, 
month={Sept},}



(4) Please use the datasets in http://hci.iwr.uni-heidelberg.de/HCI/Research/LightField/lf_benchmark.php and then convert the HDF5 files to matlab and to the LF(t,s,v,u,c) imput form. read the documentation and the code first.


Copyright (c) 2014, Francisco Carlos Calderon
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


                                     :X-
                                  :X###
                                ;@####@
                              ;M######X
                            -@########$
                          .$##########@
                         =M############-
                        +##############$
                      .H############$=.
         ,/:         ,M##########-;.
      -+@###;       =##########-;
   =%M#######;     :#########-/
-$M###########;   :########N/
 ,;X###########; =#######A$.
     ;H#########+#######M=
       ,+#############O+
          /M#########H-
            ;M######C
              +####A
               ,$P-
