% Signature: 
%   detect_image(input, mode)
%
% Usage:
%     This function demonstrates how to use xx_track_detect in detecting
%   facial landmarks in one image. There are two modes for this function.
%
%   For 'auto' mode, OpenCV face detector is used to find the largest face
%   in the image and then perform face alignment on it. 
%
%   For 'interactive' mode, the user is asked to drag a rectangle to locate
%   the face and then face alignment is performed on the created rectangle. 
%   To obtain good performance, the upper and lower boundaries need to 
%   exceed one's eyebrow and lip. For examples of good input rectangles, 
%   please refer to "../data/good_input_rect.jpg".
%
%   Note that the initialization is optimized for OpenCV face detector. 
%   However, the algorithm is not very sensitive to initialization. It is 
%   possible to replace OpenCV's with your own face detector. If the output 
%   of your face detector largely differs from the OpenCV's, you can add a 
%   constant offset to the output of your detector using an optional 
%   parameter. See more details in "xx_track_detect.m".
%
% Params:
%   input - string to the input image
%   mode - 'iteractive' or 'auto'
%
% Return: None
%
% Author: 
%   Xuehan Xiong, xiong828@gmail.com
% 
% Citation:
%   Xuehan Xiong, Fernando de la Torre, Supervised Descent Method and Its
%   Application to Face Alignment. CVPR, 2013
%

function detect_image(input, mode)
  %input = './data/front.jpg';
  %mode = 'auto';
  
  % read image from input file
  im=imread(input);
  
  % check whether the image is too big
  if size(im, 1) > 600
      im = cv.resize(im, (600 / size(im, 1)));
  end
  
  % load model and parameters, type 'help xx_initialize' for more details
  [Models,option] = xx_initialize;
  
  if strcmpi(mode,'auto') == 1
    % perform face alignment in one image, type 'help xx_track_detect' for
    % more details
    %faces = Models.DM{1}.fd_h.detect(im,'MinNeighbors',option.min_neighbors,...
    %  'ScaleFactor',1.2,'MinSize',[50 50]);

    % own implemented face detect function, detects 2 more faces
    faces = detect_matfaces( im );
  
    imshow(im); hold on;
    for i = 1:length(faces)
      output = xx_track_detect(Models,im,faces{i},option);
      if ~isempty(output.pred)
        plot(output.pred(:,1),output.pred(:,2),'g*','markersize',2); 
      end
    end
    hold off
    
  elseif strcmpi(mode,'interactive') == 1
    imshow(im); hold on;
    h = imrect;
    position = wait(h); % double click inside of the rectangle
    output = xx_track_detect(Models,im,position,option);
    if ~isempty(output.pred)
      plot(output.pred(:,1),output.pred(:,2),'g*','markersize',2); 
    end
    hold off
  else
    disp(['Unknow mode: ' mode]);
  end
end


