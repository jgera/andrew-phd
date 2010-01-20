%This example creates gray level co occurence matrix for the
%difference grades of rusts as extracted from the ISO8501-1
%standard.
%The GLCM will look at 4 offsets with 45 degree change
%Plots are created to illustrate the different properties of 
%GLCM to see if it's usable for classification.
clear;
offsets = [0 1; -1 1; -1 0; -1 -1];
gradeImage(1).val = imread('gradeA.jpg');
gradeImage(2).val = imread('gradeB.jpg');
gradeImage(3).val = imread('gradeC.jpg');
gradeImage(4).val = imread('gradeD.jpg');


%Construct the 4 offset glcm for each grade
%%GradeA

rowDivider = 4;
columnDivider = 4;
%assume all sample images to be the same size
rowSegment = floor(size(gradeImage(1).val,1)/rowDivider);
columnSegment = floor(size(gradeImage(1).val,2)/columnDivider);

%Initialise the array of structures
%glcmGradeAMatrix(rowDivider*columnDivider) = struct('R', {1:8,1:8,1:4}, 'G', zeros(8,8,4), 'B', zeros(8,8,4), 'Gray', zeros(8,8,4));
%keyboard
%GLCM of the whole image
counter = 1;
for curr_mat=1:size(gradeImage,2)
    glcmGradeMatrix(curr_mat,counter).R = graycomatrix(gradeImage(curr_mat).val(:,:,1), 'Offset', offsets, 'NumLevels', 8); %whole image
    glcmGradeMatrix(curr_mat,counter).G = graycomatrix(gradeImage(curr_mat).val(:,:,2), 'Offset', offsets, 'NumLevels', 8);
    glcmGradeMatrix(curr_mat,counter).B = graycomatrix(gradeImage(curr_mat).val(:,:,3), 'Offset', offsets, 'NumLevels', 8);
    glcmGradeMatrix(curr_mat,counter).Gray = graycomatrix(rgb2gray(gradeImage(curr_mat).val), 'Offset', offsets, 'NumLevels', 8);
end
%Breaks the sample image into sections as specified by the row & column
%divider


for curr_mat=1:size(gradeImage,2)
    counter = 2;
    for i=1:rowDivider
        for j=1:columnDivider
            glcmGradeMatrix(curr_mat,counter).R = graycomatrix(gradeImage(curr_mat).val((i-1)*rowSegment+1:i*rowSegment,(j-1)*columnSegment+1:j*columnSegment,1), 'Offset', offsets, 'NumLevels', 8);       
            glcmGradeMatrix(curr_mat,counter).G = graycomatrix(gradeImage(curr_mat).val((i-1)*rowSegment+1:i*rowSegment,(j-1)*columnSegment+1:j*columnSegment,2), 'Offset', offsets, 'NumLevels', 8);
            glcmGradeMatrix(curr_mat,counter).B = graycomatrix(gradeImage(curr_mat).val((i-1)*rowSegment+1:i*rowSegment,(j-1)*columnSegment+1:j*columnSegment,3), 'Offset', offsets, 'NumLevels', 8);
            glcmGradeMatrix(curr_mat,counter).Gray = graycomatrix(rgb2gray(gradeImage(curr_mat).val((i-1)*rowSegment+1:i*rowSegment,(j-1)*columnSegment+1:j*columnSegment,:)), 'Offset', offsets, 'NumLevels', 8);
            counter = counter + 1;
        end
    end
end

%Average the 4 matrix into 1
for curr_mat=1:size(gradeImage,2)
    for i=1:rowDivider*columnDivider+1
        glcmGradeMatrix(curr_mat,i).R = round((glcmGradeMatrix(curr_mat,i).R(:,:,1)+glcmGradeMatrix(curr_mat,i).R(:,:,2)+glcmGradeMatrix(curr_mat,i).R(:,:,3)+glcmGradeMatrix(curr_mat,i).R(:,:,4))/4);
        glcmGradeMatrix(curr_mat,i).G = round((glcmGradeMatrix(curr_mat,i).G(:,:,1)+glcmGradeMatrix(curr_mat,i).G(:,:,2)+glcmGradeMatrix(curr_mat,i).G(:,:,3)+glcmGradeMatrix(curr_mat,i).G(:,:,4))/4);
        glcmGradeMatrix(curr_mat,i).B = round((glcmGradeMatrix(curr_mat,i).B(:,:,1)+glcmGradeMatrix(curr_mat,i).B(:,:,2)+glcmGradeMatrix(curr_mat,i).B(:,:,3)+glcmGradeMatrix(curr_mat,i).B(:,:,4))/4);
        glcmGradeMatrix(curr_mat,i).Gray = round((glcmGradeMatrix(curr_mat,i).Gray(:,:,1)+glcmGradeMatrix(curr_mat,i).Gray(:,:,2)+glcmGradeMatrix(curr_mat,i).Gray(:,:,3)+glcmGradeMatrix(curr_mat,i).Gray(:,:,4))/4);       
    end    
end

%Stats Structure 1-4 channel r, 5-8 channel g, 9-12 channel b, 13-16
%channel gray
for curr_mat=1:size(gradeImage,2) %number of material
    for i=1:rowDivider*columnDivider+1 %number of samples
        stats(curr_mat,i).R = graycoprops(glcmGradeMatrix(curr_mat,i).R);
        stats(curr_mat,i).G = graycoprops(glcmGradeMatrix(curr_mat,i).G);
        stats(curr_mat,i).B = graycoprops(glcmGradeMatrix(curr_mat,i).B);
        stats(curr_mat,i).Gray = graycoprops(glcmGradeMatrix(curr_mat,i).Gray);          
    end
end
%Plotting the data
figure(1);
for i=1:size(gradeImage,2)
    for j=1:rowDivider*columnDivider+1
        subplot(4,1,1);
        hold on;
        title({'Contrast channel r'});
        if j == 1
            scatter(i,stats(i,j).R.Contrast,4,'b')
        else
            scatter(i,stats(i,j).R.Contrast,4,'r')
        end        
        subplot(4,1,2);
        hold on;
        title({'Contrast channel g'});
        if j == 1
            scatter(i,stats(i,j).G.Contrast,4,'b')
        else
            scatter(i,stats(i,j).G.Contrast,4,'r')
        end
        subplot(4,1,3);
        hold on;
        title({'Contrast channel b'});
        if j == 1
            scatter(i,stats(i,j).B.Contrast,4,'b')
        else
            scatter(i,stats(i,j).B.Contrast,4,'r')
        end
        subplot(4,1,4);
        hold on;
        title({'Contrast channel gray'});
        if j == 1
            scatter(i,stats(i,j).Gray.Contrast,4,'b')
        else
            scatter(i,stats(i,j).Gray.Contrast,4,'r')
        end
    end
end

figure(2);
for i=1:size(gradeImage,2)
    for j=1:rowDivider*columnDivider+1
        subplot(4,1,1);
        hold on;
        title({'Correlation channel r'});
        if j == 1
            scatter(i,stats(i,j).R.Correlation,4,'b')
        else
            scatter(i,stats(i,j).R.Correlation,4,'r')
        end        
        subplot(4,1,2);
        hold on;
        title({'Correlation channel g'});
        if j == 1
            scatter(i,stats(i,j).G.Correlation,4,'b')
        else
            scatter(i,stats(i,j).G.Correlation,4,'r')
        end
        subplot(4,1,3);
        hold on;
        title({'Correlation channel b'});
        if j == 1
            scatter(i,stats(i,j).B.Correlation,4,'b')
        else
            scatter(i,stats(i,j).B.Correlation,4,'r')
        end
        subplot(4,1,4);
        hold on;
        title({'Correlation channel gray'});
        if j == 1
            scatter(i,stats(i,j).Gray.Correlation,4,'b')
        else
            scatter(i,stats(i,j).Gray.Correlation,4,'r')
        end
    end
end

figure(3);
for i=1:size(gradeImage,2)
    for j=1:rowDivider*columnDivider+1
        subplot(4,1,1);
        hold on;
        title({'Energy channel r'});
        if j == 1
            scatter(i,stats(i,j).R.Energy,4,'b')
        else
            scatter(i,stats(i,j).R.Energy,4,'r')
        end        
        subplot(4,1,2);
        hold on;
        title({'Energy channel g'});
        if j == 1
            scatter(i,stats(i,j).G.Energy,4,'b')
        else
            scatter(i,stats(i,j).G.Energy,4,'r')
        end
        subplot(4,1,3);
        hold on;
        title({'Energy channel b'});
        if j == 1
            scatter(i,stats(i,j).B.Energy,4,'b')
        else
            scatter(i,stats(i,j).B.Energy,4,'r')
        end
        subplot(4,1,4);
        hold on;
        title({'Energy channel gray'});
        if j == 1
            scatter(i,stats(i,j).Gray.Energy,4,'b')
        else
            scatter(i,stats(i,j).Gray.Energy,4,'r')
        end
    end
end

figure(4);
for i=1:size(gradeImage,2)
    for j=1:rowDivider*columnDivider+1
        subplot(4,1,1);
        hold on;
        title({'Homogeneity channel r'});
        if j == 1
            scatter(i,stats(i,j).R.Homogeneity,4,'b')
        else
            scatter(i,stats(i,j).R.Homogeneity,4,'r')
        end        
        subplot(4,1,2);
        hold on;
        title({'Homogeneity channel g'});
        if j == 1
            scatter(i,stats(i,j).G.Homogeneity,4,'b')
        else
            scatter(i,stats(i,j).G.Homogeneity,4,'r')
        end
        subplot(4,1,3);
        hold on;
        title({'Homogeneity channel b'});
        if j == 1
            scatter(i,stats(i,j).B.Homogeneity,4,'b')
        else
            scatter(i,stats(i,j).B.Homogeneity,4,'r')
        end
        subplot(4,1,4);
        hold on;
        title({'Homogeneity channel gray'});
        if j == 1
            scatter(i,stats(i,j).Gray.Homogeneity,4,'b')
        else
            scatter(i,stats(i,j).Gray.Homogeneity,4,'r')
        end
    end
end
keyboard
