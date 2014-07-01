  input = './data/front.jpg';
  input2 = './data/side.jpg';
  mode = 'auto';
  
  % read image from input file
  im=imread(input);
  imside=imread(input2);
  
  % check whether the image is too big
  if size(im, 1) > 600
      im = cv.resize(im, (600 / size(im, 1)));
  end
  
  if size(imside, 1) > 600
      imside = cv.resize(imside, (600 / size(imside, 1)));
  end
  
  % load model and parameters, type 'help xx_initialize' for more details
  [Models,option] = xx_initialize;

    % own implemented face detect function, detects 2 more faces
    faces = detect_matfaces( im );
    
    % frontal view and points
    subplot(2, 2, 1), imshow(im); hold on;
    for i = 1:length(faces)
      output = xx_track_detect(Models,im,faces{i},option);
      if ~isempty(output.pred)
        plot(output.pred(:,1),output.pred(:,2),'g*','markersize',2); 
      end
    end

fixedPoints  = [double(output.pred(20,1)) double(output.pred(20,2)); double(output.pred(29,1)) double(output.pred(29,2)); ...
                double(output.pred(14,1)) double(output.pred(14,2)); double(output.pred(15,1)) double(output.pred(15,2)); ...
                double(output.pred(19,1)) double(output.pred(19,2)); ];
    plot(fixedPoints(:,1),fixedPoints(:,2),'r*','markersize',2); hold off;


facesside = detect_matfaces( imside );
%insertObjectAnnotation(imside,'rectangle',facesside{1},'Face');
subplot(2, 2, 2), imshow(imside); hold on;
    for i = 1:length(faces)
      output2 = xx_track_detect(Models,imside,facesside{i},option);
      if ~isempty(output2.pred)
        plot(output2.pred(:,1),output2.pred(:,2),'g*','markersize',2); 
      end
    end 
 movingfixedPoints  = [output2.pred(20,1) output2.pred(20,2); output2.pred(29,1) output2.pred(29,2); ...
                       output2.pred(14,1) output2.pred(14,2); output2.pred(15,1) output2.pred(15,2); ...
                       output2.pred(19,1) output2.pred(19,2); ];    
 plot(movingfixedPoints(:,1), movingfixedPoints(:,2), 'b*', 'markersize',2);

 hold off;

% STARTING THE WARP 
 
% generate the piecewise affine transformation
tform = fitgeotrans(movingfixedPoints,fixedPoints,'Affine');
%tform = cp2tform(movingPoints, fixedPoints, 'piecewise linear');
imsidewarp = imwarp(imside,tform,'OutputView',imref2d(size(im)));

faceswarp = detect_matfaces( imsidewarp );

% TODO generalize this
faceswarp{1} = [(faceswarp{1}(1) - faceswarp{1}(3) / 4) (faceswarp{1}(2) - faceswarp{1}(2) / 4) ...
                (faceswarp{1}(3) * 1.25) (faceswarp{1}(4) * 1.25)];
imsidebound = insertObjectAnnotation(imsidewarp,'rectangle',faceswarp{1},'Face');
for i = 1:length(facesside)
            output3 = xx_track_detect(Models,imsidewarp,faceswarp{i},option);
   if ~isempty(output3.pred)
            % first select the mean control points and the examples control points
            movingPoints  = [output3.pred(20,1) output3.pred(20,2); output3.pred(29,1) output3.pred(29,2); ...
                             output3.pred(14,1) output3.pred(14,2); output3.pred(15,1) output3.pred(15,2); ...
                             output3.pred(19,1) output3.pred(19,2); ];
   end
end 

% approximate the normalized face

    subplot(2,2,3), imshow(imsidebound); hold on;
        insertObjectAnnotation(imsidewarp,'rectangle',faceswarp{1},'Face');
        plot(fixedPoints(:,1),fixedPoints(:,2),'r*','markersize',2);       
        plot(output3.pred(:,1),output3.pred(:,2),'g*','markersize',2);
        plot(movingPoints(:,1),movingPoints(:,2),'b*','markersize',2);
    hold off;
    
    falsecolorOverlay = imfuse(im,imsidewarp);
    subplot(2,2,4), imshow(falsecolorOverlay,'InitialMagnification','fit'); hold on;
        plot(fixedPoints(:,1),fixedPoints(:,2),'r*','markersize',2); 
    hold off