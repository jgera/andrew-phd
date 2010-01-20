%This example creates gray level co occurence matrix for the
%difference grades of rusts as extracted from the ISO8501-1
%standard.
%The GLCM will look at 4 offsets with 45 degree change
%Plots are created to illustrate the different properties of 
%GLCM to see if it's usable for classification.
offsets = [0 1; -1 1; -1 0; -1 -1];
gradeAImage = imread('gradeA.jpg');
gradeBImage = imread('gradeB.jpg');
gradeCImage = imread('gradeC.jpg');
gradeDImage = imread('gradeD.jpg');


%Construct the 4 offset glcm for each grade
glcmGradeAMatrixR = graycomatrix(gradeAImage(:,:,1), 'Offset', offsets, 'NumLevels', 8);
glcmGradeAMatrixG = graycomatrix(gradeAImage(:,:,2), 'Offset', offsets, 'NumLevels', 8);
glcmGradeAMatrixB = graycomatrix(gradeAImage(:,:,3), 'Offset', offsets, 'NumLevels', 8);
glcmGradeAMatrixGray = graycomatrix(rgb2gray(gradeAImage), 'Offset', offsets, 'NumLevels', 8);

glcmGradeBMatrixR = graycomatrix(gradeBImage(:,:,1), 'Offset', offsets, 'NumLevels', 8);
glcmGradeBMatrixG = graycomatrix(gradeBImage(:,:,2), 'Offset', offsets, 'NumLevels', 8);
glcmGradeBMatrixB = graycomatrix(gradeBImage(:,:,3), 'Offset', offsets, 'NumLevels', 8);
glcmGradeBMatrixGray = graycomatrix(rgb2gray(gradeBImage), 'Offset', offsets, 'NumLevels', 8);

glcmGradeCMatrixR = graycomatrix(gradeCImage(:,:,1), 'Offset', offsets, 'NumLevels', 8);
glcmGradeCMatrixG = graycomatrix(gradeCImage(:,:,2), 'Offset', offsets, 'NumLevels', 8);
glcmGradeCMatrixB = graycomatrix(gradeCImage(:,:,3), 'Offset', offsets, 'NumLevels', 8);
glcmGradeCMatrixGray = graycomatrix(rgb2gray(gradeCImage), 'Offset', offsets, 'NumLevels', 8);

glcmGradeDMatrixR = graycomatrix(gradeDImage(:,:,1), 'Offset', offsets, 'NumLevels', 8);
glcmGradeDMatrixG = graycomatrix(gradeDImage(:,:,2), 'Offset', offsets, 'NumLevels', 8);
glcmGradeDMatrixB = graycomatrix(gradeDImage(:,:,3), 'Offset', offsets, 'NumLevels', 8);
glcmGradeDMatrixGray = graycomatrix(rgb2gray(gradeDImage), 'Offset', offsets, 'NumLevels', 8);

%Construct the average glcmMatrix
glcmGradeAMatrixRAverage = round((glcmGradeAMatrixR(:,:,1)+glcmGradeAMatrixR(:,:,2)+glcmGradeAMatrixR(:,:,3)+glcmGradeAMatrixR(:,:,4))/4);
glcmGradeAMatrixGAverage = round((glcmGradeAMatrixG(:,:,1)+glcmGradeAMatrixG(:,:,2)+glcmGradeAMatrixG(:,:,3)+glcmGradeAMatrixG(:,:,4))/4);
glcmGradeAMatrixBAverage = round((glcmGradeAMatrixB(:,:,1)+glcmGradeAMatrixB(:,:,2)+glcmGradeAMatrixB(:,:,3)+glcmGradeAMatrixB(:,:,4))/4);
glcmGradeAMatrixGrayAverage = round((glcmGradeAMatrixGray(:,:,1)+glcmGradeAMatrixGray(:,:,2)+glcmGradeAMatrixGray(:,:,3)+glcmGradeAMatrixGray(:,:,4))/4);

glcmGradeBMatrixRAverage = round((glcmGradeBMatrixR(:,:,1)+glcmGradeBMatrixR(:,:,2)+glcmGradeBMatrixR(:,:,3)+glcmGradeBMatrixR(:,:,4))/4);
glcmGradeBMatrixGAverage = round((glcmGradeBMatrixG(:,:,1)+glcmGradeBMatrixG(:,:,2)+glcmGradeBMatrixG(:,:,3)+glcmGradeBMatrixG(:,:,4))/4);
glcmGradeBMatrixBAverage = round((glcmGradeBMatrixB(:,:,1)+glcmGradeBMatrixB(:,:,2)+glcmGradeBMatrixB(:,:,3)+glcmGradeBMatrixB(:,:,4))/4);
glcmGradeBMatrixGrayAverage = round((glcmGradeBMatrixGray(:,:,1)+glcmGradeBMatrixGray(:,:,2)+glcmGradeBMatrixGray(:,:,3)+glcmGradeBMatrixGray(:,:,4))/4);

glcmGradeCMatrixRAverage = round((glcmGradeCMatrixR(:,:,1)+glcmGradeCMatrixR(:,:,2)+glcmGradeCMatrixR(:,:,3)+glcmGradeCMatrixR(:,:,4))/4);
glcmGradeCMatrixGAverage = round((glcmGradeCMatrixG(:,:,1)+glcmGradeCMatrixG(:,:,2)+glcmGradeCMatrixG(:,:,3)+glcmGradeCMatrixG(:,:,4))/4);
glcmGradeCMatrixBAverage = round((glcmGradeCMatrixB(:,:,1)+glcmGradeCMatrixB(:,:,2)+glcmGradeCMatrixB(:,:,3)+glcmGradeCMatrixB(:,:,4))/4);
glcmGradeCMatrixGrayAverage = round((glcmGradeCMatrixGray(:,:,1)+glcmGradeCMatrixGray(:,:,2)+glcmGradeCMatrixGray(:,:,3)+glcmGradeCMatrixGray(:,:,4))/4);

glcmGradeDMatrixRAverage = round((glcmGradeDMatrixR(:,:,1)+glcmGradeDMatrixR(:,:,2)+glcmGradeDMatrixR(:,:,3)+glcmGradeDMatrixR(:,:,4))/4);
glcmGradeDMatrixGAverage = round((glcmGradeDMatrixG(:,:,1)+glcmGradeDMatrixG(:,:,2)+glcmGradeDMatrixG(:,:,3)+glcmGradeDMatrixG(:,:,4))/4);
glcmGradeDMatrixBAverage = round((glcmGradeDMatrixB(:,:,1)+glcmGradeDMatrixB(:,:,2)+glcmGradeDMatrixB(:,:,3)+glcmGradeDMatrixB(:,:,4))/4);
glcmGradeDMatrixGrayAverage = round((glcmGradeDMatrixGray(:,:,1)+glcmGradeDMatrixGray(:,:,2)+glcmGradeDMatrixGray(:,:,3)+glcmGradeDMatrixGray(:,:,4))/4);

%Stats Structure 1-4 channel r, 5-8 channel g, 9-12 channel b, 13-16
%channel gray
stats(1) = graycoprops(glcmGradeAMatrixRAverage);
stats(2) = graycoprops(glcmGradeBMatrixRAverage);
stats(3) = graycoprops(glcmGradeCMatrixRAverage);
stats(4) = graycoprops(glcmGradeDMatrixRAverage);

stats(5) = graycoprops(glcmGradeAMatrixGAverage);
stats(6) = graycoprops(glcmGradeBMatrixGAverage);
stats(7) = graycoprops(glcmGradeCMatrixGAverage);
stats(8) = graycoprops(glcmGradeDMatrixGAverage);

stats(9) = graycoprops(glcmGradeAMatrixBAverage);
stats(10) = graycoprops(glcmGradeBMatrixBAverage);
stats(11) = graycoprops(glcmGradeCMatrixBAverage);
stats(12) = graycoprops(glcmGradeDMatrixBAverage);

stats(13) = graycoprops(glcmGradeAMatrixGrayAverage);
stats(14) = graycoprops(glcmGradeBMatrixGrayAverage);
stats(15) = graycoprops(glcmGradeCMatrixGrayAverage);
stats(16) = graycoprops(glcmGradeDMatrixGrayAverage);

%Plotting the data
figure(1);
for i=1:4
    subplot(4,1,1);
    hold on;
    title({'Contrast channel r'});
    scatter(i,stats(i).Contrast,4)
    subplot(4,1,2);
    hold on;
    title({'Contrast channel g'});
    scatter(i,stats(i+4).Contrast,4)
    subplot(4,1,3);
    hold on;
    title({'Contrast channel b'});
    scatter(i,stats(i+8).Contrast,4)
    subplot(4,1,4);
    hold on;
    title({'Contrast channel gray'});
    scatter(i,stats(i+8).Contrast,4)
end

figure(2);
for i=1:4
    subplot(4,1,1);
    hold on;
    title({'Correlation channel r'});
    scatter(i,stats(i).Correlation,4)
    subplot(4,1,2);
    hold on;
    title({'Correlation channel g'});
    scatter(i,stats(i+4).Correlation,4)
    subplot(4,1,3);
    hold on;
    title({'Correlation channel b'});
    scatter(i,stats(i+8).Correlation,4)
    subplot(4,1,4);
    hold on;
    title({'Correlationt channel gray'});
    scatter(i,stats(i+8).Correlation,4)
end

figure(3);
for i=1:4
    subplot(4,1,1);
    hold on;
    title({'Energy channel r'});
    scatter(i,stats(i).Energy,4)
    subplot(4,1,2);
    hold on;
    title({'Energy channel g'});
    scatter(i,stats(i+4).Energy,4)
    subplot(4,1,3);
    hold on;
    title({'Energy channel b'});
    scatter(i,stats(i+8).Energy,4)
    subplot(4,1,4);
    hold on;
    title({'Energy channel gray'});
    scatter(i,stats(i+8).Energy,4)
end

figure(4);
for i=1:4
    subplot(4,1,1);
    hold on;
    title({'Homogeneity channel r'});
    scatter(i,stats(i).Homogeneity,4)
    subplot(4,1,2);
    hold on;
    title({'Homogeneity channel g'});
    scatter(i,stats(i+4).Homogeneity,4)
    subplot(4,1,3);
    hold on;
    title({'Homogeneity channel b'});
    scatter(i,stats(i+8).Homogeneity,4)
    subplot(4,1,4);
    hold on;
    title({'Homogeneity channel gray'});
    scatter(i,stats(i+8).Homogeneity,4)
end

keyboard
