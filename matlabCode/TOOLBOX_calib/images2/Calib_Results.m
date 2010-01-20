% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly excecuted under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 1690.652326281454600 ; 1696.447618948740700 ];

%-- Principal point:
cc = [ 656.966174309362490 ; 509.516039085510270 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ -0.196603715421073 ; -0.013482788620182 ; -0.002260837622387 ; 0.002095244841684 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 10.371552106550453 ; 11.388960818348286 ];

%-- Principal point uncertainty:
cc_error = [ 18.266646121722058 ; 15.427522296682881 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.027981970782009 ; 0.209891352946868 ; 0.001832914573886 ; 0.001847480210975 ; 0.000000000000000 ];

%-- Image size:
nx = 1280;
ny = 960;


%-- Various other variables (may be ignored if you do not use the Matlab Calibration Toolbox):
%-- Those variables are used to control which intrinsic parameters should be optimized

n_ima = 11;						% Number of calibration images
est_fc = [ 1 ; 1 ];					% Estimation indicator of the two focal variables
est_aspect_ratio = 1;				% Estimation indicator of the aspect ratio fc(2)/fc(1)
center_optim = 1;					% Estimation indicator of the principal point
est_alpha = 0;						% Estimation indicator of the skew coefficient
est_dist = [ 1 ; 1 ; 1 ; 1 ; 0 ];	% Estimation indicator of the distortion coefficients


%-- Extrinsic parameters:
%-- The rotation (omc_kk) and the translation (Tc_kk) vectors for every calibration image and their uncertainties

%-- Image #1:
omc_1 = [ 2.069166e+000 ; 1.000113e+000 ; -2.636870e-001 ];
Tc_1  = [ -2.412733e+002 ; 2.916079e+001 ; 1.460397e+003 ];
omc_error_1 = [ 8.176564e-003 ; 6.831952e-003 ; 1.233156e-002 ];
Tc_error_1  = [ 1.582723e+001 ; 1.332765e+001 ; 9.186215e+000 ];

%-- Image #2:
omc_2 = [ 2.420576e+000 ; -1.041542e+000 ; -4.050280e-001 ];
Tc_2  = [ 1.448079e+002 ; 3.901815e+002 ; 1.921396e+003 ];
omc_error_2 = [ 9.468517e-003 ; 4.685349e-003 ; 1.500576e-002 ];
Tc_error_2  = [ 2.099934e+001 ; 1.758744e+001 ; 1.133346e+001 ];

%-- Image #3:
omc_3 = [ 1.879509e+000 ; 1.032828e+000 ; -3.296514e-001 ];
Tc_3  = [ -4.057572e+002 ; -1.450307e+002 ; 1.132998e+003 ];
omc_error_3 = [ 7.937110e-003 ; 8.113001e-003 ; 1.134181e-002 ];
Tc_error_3  = [ 1.230900e+001 ; 1.038717e+001 ; 8.190105e+000 ];

%-- Image #4:
omc_4 = [ 2.189920e+000 ; -1.764681e+000 ; 6.708945e-001 ];
Tc_4  = [ 1.470457e+002 ; 3.167298e+002 ; 1.624323e+003 ];
omc_error_4 = [ 6.815362e-003 ; 8.228453e-003 ; 1.441411e-002 ];
Tc_error_4  = [ 1.769679e+001 ; 1.502613e+001 ; 9.887372e+000 ];

%-- Image #5:
omc_5 = [ 1.615499e+000 ; 1.531125e+000 ; -8.333861e-001 ];
Tc_5  = [ -3.810508e+002 ; -2.375165e+001 ; 1.771884e+003 ];
omc_error_5 = [ 6.309360e-003 ; 9.184146e-003 ; 1.157903e-002 ];
Tc_error_5  = [ 1.911896e+001 ; 1.622230e+001 ; 1.047191e+001 ];

%-- Image #6:
omc_6 = [ 2.036652e+000 ; 1.438509e+000 ; -3.370488e-001 ];
Tc_6  = [ -3.626764e+002 ; -1.843040e+002 ; 1.385811e+003 ];
omc_error_6 = [ 7.111731e-003 ; 7.808420e-003 ; 1.312803e-002 ];
Tc_error_6  = [ 1.505345e+001 ; 1.259224e+001 ; 9.448395e+000 ];

%-- Image #7:
omc_7 = [ 1.808687e+000 ; 2.123661e+000 ; -8.831897e-001 ];
Tc_7  = [ -3.256810e+002 ; -2.151165e+002 ; 1.760568e+003 ];
omc_error_7 = [ 4.267515e-003 ; 9.956251e-003 ; 1.453641e-002 ];
Tc_error_7  = [ 1.903035e+001 ; 1.601713e+001 ; 1.121338e+001 ];

%-- Image #8:
omc_8 = [ 1.724517e+000 ; 1.926041e+000 ; -8.452569e-001 ];
Tc_8  = [ -3.674300e+002 ; -1.109062e+002 ; 2.710482e+003 ];
omc_error_8 = [ 5.385466e-003 ; 9.786573e-003 ; 1.362717e-002 ];
Tc_error_8  = [ 2.924809e+001 ; 2.467577e+001 ; 1.671380e+001 ];

%-- Image #9:
omc_9 = [ 2.116835e+000 ; 1.125982e+000 ; -6.951526e-002 ];
Tc_9  = [ -3.176212e+002 ; -1.829438e+001 ; 1.844044e+003 ];
omc_error_9 = [ 8.145873e-003 ; 6.495686e-003 ; 1.293413e-002 ];
Tc_error_9  = [ 1.999003e+001 ; 1.680203e+001 ; 1.211268e+001 ];

%-- Image #10:
omc_10 = [ 2.103428e+000 ; 8.605833e-001 ; -2.335737e-001 ];
Tc_10  = [ -4.527317e+002 ; 1.242239e+002 ; 2.085605e+003 ];
omc_error_10 = [ 8.144739e-003 ; 6.647462e-003 ; 1.211458e-002 ];
Tc_error_10  = [ 2.263565e+001 ; 1.921425e+001 ; 1.339741e+001 ];

%-- Image #11:
omc_11 = [ -2.411121e+000 ; -1.782474e+000 ; -5.119869e-001 ];
Tc_11  = [ -3.801886e+002 ; -3.455062e+001 ; 1.798231e+003 ];
omc_error_11 = [ 8.936425e-003 ; 8.656818e-003 ; 1.732799e-002 ];
Tc_error_11  = [ 1.944258e+001 ; 1.646868e+001 ; 1.271442e+001 ];

