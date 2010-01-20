%This function constructs the model for each material by returning the mean
%and standard deviation
%model(material,channel,glcmProperties).std and .mean
function model = createGLCMModelNonDistance(imageArray, segmentation)

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

%Get the GLCM properties of each image
for curr_mat=1:size(gradeImage2,1)
    for curr_sample = 1:size(gradeImage2,2) 
        properties(curr_mat, curr_sample).val = createGLCMProperties(gradeImage2(curr_mat, curr_sample).val);
    end
end

for i = 1:size(properties,1)
    for j = 1:size(properties,2)
        for channel = 1:4
            temp(1,(i-1)*100+j) = properties(i,j).val(1).Contrast; %R
            temp(2,(i-1)*100+j) = properties(i,j).val(2).Contrast; %G
            temp(3,(i-1)*100+j) = properties(i,j).val(3).Contrast; %B
            temp(4,(i-1)*100+j) = properties(i,j).val(4).Contrast; %Gray            
            temp(5,(i-1)*100+j) = properties(i,j).val(1).Correlation;            
            temp(6,(i-1)*100+j) = properties(i,j).val(2).Correlation;            
            temp(7,(i-1)*100+j) = properties(i,j).val(3).Correlation;            
            temp(8,(i-1)*100+j) = properties(i,j).val(4).Correlation;               
            temp(9,(i-1)*100+j) = properties(i,j).val(1).Energy;
            temp(10,(i-1)*100+j) = properties(i,j).val(2).Energy;
            temp(11,(i-1)*100+j) = properties(i,j).val(3).Energy;
            temp(12,(i-1)*100+j) = properties(i,j).val(4).Energy;
            temp(13,(i-1)*100+j) = properties(i,j).val(1).Homogeneity;
            temp(14,(i-1)*100+j) = properties(i,j).val(2).Homogeneity;
            temp(15,(i-1)*100+j) = properties(i,j).val(3).Homogeneity;
            temp(16,(i-1)*100+j) = properties(i,j).val(4).Homogeneity;
        end
    end
end

for channel = 1:4
    [muhat,sigmahat] = normfit(temp(channel,:));
    model(1,channel,1).mean = muhat;
    model(1,channel,1).std = sigmahat;
    [muhat,sigmahat] = normfit(temp(channel+4,:));
    model(1,channel,2).mean = muhat;
    model(1,channel,2).std = sigmahat;
    [muhat,sigmahat] = normfit(temp(channel+8,:));
    model(1,channel,3).mean = muhat;
    model(1,channel,3).std = sigmahat;
    [muhat,sigmahat] = normfit(temp(channel+12,:));
    model(1,channel,4).mean = muhat;
    model(1,channel,4).std = sigmahat;
end

for curr_property=1:4
    figure(curr_property)
    for curr_channel=1:4
        subplot(4,1,curr_channel)
        ylim([0,1]);
        ylim('manual');        
        boxplot(temp((curr_property-1)*4+curr_channel,:));
        switch curr_property
            case 1
                property = 'Contrast';
            case 2
                property = 'Correlation';
            case 3
                property = 'Energy';
            case 4
                property = 'Homogeneity';
        end
        switch curr_channel
            case 1
                channel = 'Channel R';
            case 2
                channel = 'Channel G';
            case 3
                channel = 'Channel B';
            case 4
                channel = 'Channel Gray';
        end
        string = [channel, '',property];
        title(string);
    end
end
%Calculate the std and mean for the sample 
