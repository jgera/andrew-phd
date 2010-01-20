%This function constructs the model for each material by returning the mean
%and standard deviation
%model(material,channel,glcmProperties).std and .mean
function model = createGLCMModel(imageArray, segmentation)

showPlot = 1;
%load the images into local variables
for i=1:size(imageArray,2)
    gradeImage(i,1).val = imread(imageArray(i).val);
end
%Create the image segmentation 
rowSegment = floor(size(gradeImage(1,1).val,1)/segmentation);
columnSegment = floor(size(gradeImage(1,1).val,2)/segmentation);

for curr_mat=1:size(gradeImage,1)
    counter = 2;
    for i=1:segmentation
        for j=1:segmentation           
            gradeImage(curr_mat,counter).val = gradeImage(curr_mat,1).val((i-1)*rowSegment+1:i*rowSegment,(j-1)*columnSegment+1:j*columnSegment,:);       
            counter = counter + 1;
        end
    end
end

%Get the GLCM properties of each image
for curr_mat=1:size(gradeImage,1)
    for curr_sample = 1:size(gradeImage,2) 
        properties(curr_mat, curr_sample).val = createGLCMProperties(gradeImage(curr_mat, curr_sample).val);
    end
end

%model(material,channel,glcmProperties).std and .mean
for curr_mat = 1:size(gradeImage,1)
    for curr_channel = 1:4 %RGB and Grayscale
        for features = 1:4 %contrast,correlation, energy and homogeneity
            for curr_sample = 1:size(gradeImage,2)                
                switch features
                    case 1
                        data(curr_sample) = properties(curr_mat, curr_sample).val(curr_channel).Contrast;
                    case 2
                        data(curr_sample) = properties(curr_mat, curr_sample).val(curr_channel).Correlation;
                    case 3
                        data(curr_sample) = properties(curr_mat, curr_sample).val(curr_channel).Energy;
                    case 4
                        data(curr_sample) = properties(curr_mat, curr_sample).val(curr_channel).Homogeneity;
                end
            end
            [muhat,sigmahat]=normfit(data);
            stats(curr_mat,curr_channel,features).data = data;
            model(curr_mat,curr_channel,features).mean = muhat;
            if sigmahat == 0
                sigmahat = eps;
            end
            model(curr_mat,curr_channel,features).std = sigmahat;
        end
    end
end
if showPlot ==1
    boxPlotProperties(stats);
end
%Calculate the std and mean for the sample 
