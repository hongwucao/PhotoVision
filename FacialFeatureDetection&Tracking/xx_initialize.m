% Signature: 
%   xx_initialize
%
% Dependence:
%   OpenCV2.4 above, mexopencv
%   mexopencv can be downloaded here:
%   http://www.cs.stonybrook.edu/~kyamagu/mexopencv/
%
%   You do not need the above two packages unless you want to build OpenCV
%   on yourself or re-compile mexopencv. All DLLs and mex functions are
%   included in this package.
%
% Usage:
%   This function loads models and set default parameters of the tracker.
%
% Params:
%   None
%
% Return:
%   Models.DM - detection model
%   Models.TM - tracking model
%   option - tracker parameters
%     .face_score - threshold ([0,1]) determining whether the tracked face is
%     lost. The lower the value the more tolerated it becomes.
%
%     .min_neighbors - OpenCV face detector parameter (>0). The lower the more 
%     likely to find a face as well as false positives.
%
%     .min_face_image_ratio - minimum ratio between face size and image
%     height. This is used for determining the minimum face size for OpenCV 
%     face detector.
%
%     .compute_pose - flag indicating whether to compute head pose.
%
% Author: 
%   Xuehan Xiong, xiong828@gmail.com
% 
% Creation date:
%   4/7/2014
%

function [Models, option] = xx_initialize

% initialize all the options for the model classifier
  option.face_score = 0.3;
  option.min_neighbors = 2;
  option.min_face_image_ratio = 0.15;
  option.compute_pose = true;
  
  % OpenCV face detector model file
  xml_file = './models/haarcascade_frontalface_alt2.xml';
  
  % addd the xml file for profile faces and eyeglasses
  %xml_file = './models/haarcascade_profileface.xml';
  %xml_file = './models/haarcascade_eye_tree_eyeglasses.xml';
  %xml_file = './models/haarcascade_frontalface_alt.xml';
  %xml_file = './models/haarcascade_frontalface_alt_tree.xml';
  %xml_file = './models/haarcascade_frontalface_default.xml';
  %xml_file = './models/lbpcascade_frontalface.xml';
  %xml_file = './models/facefinder.ea';
  
  
  % load tracking model
  load('./models/TrackingModel-xxsift-v1.10.mat');
  
  % load detection model
  load('./models/DetectionModel-xxsift-v1.5.mat');
  
  % create face detector handlers
  fd_h = cv.CascadeClassifier(xml_file);
  % fd_p = cv.CascadeClassifier(xml_profile);
  % fd_g = cv.CascadeClassifier(xml_glasses);
  
  DM{1}.fd_h = fd_h;
  % DM{1}.fd_p = fd_p;
  % DM{1}.fd_g = fd_g;
  
  Models.DM = DM;
  Models.TM = TM;
  
end




