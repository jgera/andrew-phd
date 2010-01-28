%This function takes an image and generates a glcm with 4 offsets
%Averages the glcm and returns the properties(contrast, correlation, energy and homogeneity)
function glcmProperties = createGLCMProperties(image) %Image is an NxNx3 matrix
offsets = [0 1; -1 1; -1 0; -1 -1]; %Set the offsets for 0,45,90,135 degrees
%generate the 8x8x4 glcm matrix
glcmGradeMatrix.R = graycomatrix(image(:,:,1), 'Offset', offsets, 'NumLevels', 32);
glcmGradeMatrix.G = graycomatrix(image(:,:,2), 'Offset', offsets, 'NumLevels', 32);
glcmGradeMatrix.B = graycomatrix(image(:,:,3), 'Offset', offsets, 'NumLevels', 32);
grayImage = rgb2gray(image);
grayAdjustedImage = imadjust(grayImage, stretchlim(grayImage),[]); %Contrast adjustment
%figure;imshow(grayAdjustedImage);
%glcmGradeMatrix.Gray = graycomatrix(rgb2gray(image), 'Offset', offsets, 'NumLevels', 32);
glcmGradeMatrix.Gray = graycomatrix(grayAdjustedImage, 'Offset', offsets, 'NumLevels', 32);
%Average the 8x8x4 matrix into a 8x8x1 matrix
glcmGradeMatrix.R = round((glcmGradeMatrix.R(:,:,1)+glcmGradeMatrix.R(:,:,2)+glcmGradeMatrix.R(:,:,3)+glcmGradeMatrix.R(:,:,4))/4);
glcmGradeMatrix.G = round((glcmGradeMatrix.G(:,:,1)+glcmGradeMatrix.G(:,:,2)+glcmGradeMatrix.G(:,:,3)+glcmGradeMatrix.G(:,:,4))/4);
glcmGradeMatrix.B = round((glcmGradeMatrix.B(:,:,1)+glcmGradeMatrix.B(:,:,2)+glcmGradeMatrix.B(:,:,3)+glcmGradeMatrix.B(:,:,4))/4);
glcmGradeMatrix.Gray = round((glcmGradeMatrix.Gray(:,:,1)+glcmGradeMatrix.Gray(:,:,2)+glcmGradeMatrix.Gray(:,:,3)+glcmGradeMatrix.Gray(:,:,4))/4); 


%glcmGradeMatrix.Gray = imadjust(glcmGradeMatrix.Gray, stretchlim(glcmGradeMatrix.Gray),[]); %Contrast adjustment


%Generate the properties for each channel glcm
glcmProperties(1) = graycoprops(glcmGradeMatrix.R);
glcmProperties(2) = graycoprops(glcmGradeMatrix.G); 
glcmProperties(3) = graycoprops(glcmGradeMatrix.B); 
glcmProperties(4) = graycoprops(glcmGradeMatrix.Gray);
for i=1:4
    if isnan(glcmProperties(i).Correlation) 
        glcmProperties(i).Correlation = 0; %Forcing the NaN to become 0 so the normfit would work
    end
end


