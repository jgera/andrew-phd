%This function generates normalised RGB values on the images and a
%probability distribution model based on these values
function normalisedImagesPDF = createNormalisedRGBModel(imageArray, segmentation)
showPlot = 1;

%load the images into local variables
for i=1:size(imageArray,2)
    gradeImage(i,1).val = imread(imageArray(i).val);
end
%Create the image segmentation 
rowSegment = floor(size(gradeImage(1,1).val,1)/segmentation);
columnSegment = floor(size(gradeImage(1,1).val,2)/segmentation);

for curr_mat=1:size(gradeImage,1)
    counter = 1;
    for i=1:segmentation
        for j=1:segmentation           
            gradeImage2(curr_mat,counter).val = gradeImage(curr_mat,1).val((i-1)*rowSegment+1:i*rowSegment,(j-1)*columnSegment+1:j*columnSegment,:);       
            counter = counter + 1;
        end
    end
end

%Generate the normalised values of each subimage
for curr_mat=1:size(gradeImage2,1)
    for curr_sample = 1:size(gradeImage2,2) 
        normalisedImages(curr_mat, curr_sample).val = normaliseImage(gradeImage2(curr_mat, curr_sample).val);        
        %Work out the average RGB value inside each sub sample
        averageR(curr_mat, curr_sample) = sum(sum(normalisedImages(curr_mat, curr_sample).val(:,:,1)))/(size(normalisedImages(curr_mat, curr_sample).val,1)*size(normalisedImages(curr_mat, curr_sample).val,2));
        averageG(curr_mat, curr_sample) = sum(sum(normalisedImages(curr_mat, curr_sample).val(:,:,2)))/(size(normalisedImages(curr_mat, curr_sample).val,1)*size(normalisedImages(curr_mat, curr_sample).val,2));
        averageB(curr_mat, curr_sample) = sum(sum(normalisedImages(curr_mat, curr_sample).val(:,:,3)))/(size(normalisedImages(curr_mat, curr_sample).val,1)*size(normalisedImages(curr_mat, curr_sample).val,2));        
    end
    %Get the mean and variance from the samples of a material for a normal
    %distribution
    [normalisedImagesPDF(curr_mat).Rmean,normalisedImagesPDF(curr_mat).Rstd] = normfit(averageR(curr_mat,:));
    [normalisedImagesPDF(curr_mat).Gmean,normalisedImagesPDF(curr_mat).Gstd] = normfit(averageG(curr_mat,:));
    [normalisedImagesPDF(curr_mat).Bmean,normalisedImagesPDF(curr_mat).Bstd] = normfit(averageB(curr_mat,:));    
end
if showPlot == 1
    for curr_mat = 1:size(averageR,1)
        figure(curr_mat)
        
        subplot(3,1,1)        
        boxplot(averageR(curr_mat,:));
        ylim([0,0.5]);
        ylim('manual');
        title('R channel');
        
        subplot(3,1,2)        
        boxplot(averageG(curr_mat,:));
        ylim([0,0.5]);
        ylim('manual');        
        title('G channel');
        
        subplot(3,1,3)        
        boxplot(averageB(curr_mat,:));
        ylim([0,0.5]);
        ylim('manual');
        title('B channel');        
    end
end








