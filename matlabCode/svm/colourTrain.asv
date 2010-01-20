%Test to train SVM to classify between two colour classes
%Select the training area from the image that represents each of the 2 classes
close all
image = imread('f:\Projects\wallPhoto.jpg');

class1Dataset=zeros(1000,3); %assume we're taking 20x50 pixels
class2Dataset=zeros(1000,3);
for i = 1:20
    class1Dataset((i-1)*50+1:(i)*50,:) = image(i,136:185,:);
    class2Dataset((i-1)*50+1:(i)*50,:) = image(i+219,136:185,:);
end

%Confirm that we have got the right area by plotting
imageClass1=uint8(zeros(20,50,3));
imageClass2=uint8(zeros(20,50,3));
for i = 1:20
    for j = 136:185
        imageClass1(i,j-135,:) = image(i,j,:);
        imageClass2(i,j-135,:) = image(i+219,j,:);
    end
end
figure(1);
subplot(2,1,1);
imagesc(imageClass1);
subplot(2,1,2);
imagesc(imageClass2);

%Perform scaling of data 0 to 1
scaledClass1Dataset=zeros(1000,3);
scaledClass2Dataset=zeros(1000,3);
for i = 1:1000
    scaledClass1Dataset(i,1) = class1Dataset(i,1)/255;
    scaledClass1Dataset(i,2) = class1Dataset(i,2)/255;
    scaledClass1Dataset(i,3) = class1Dataset(i,3)/255;
    
    scaledClass2Dataset(i,1) = class2Dataset(i,1)/255;
    scaledClass2Dataset(i,2) = class2Dataset(i,2)/255;
    scaledClass2Dataset(i,3) = class2Dataset(i,3)/255;
end
  
class1DatasetAnswer=ones([1000,1]);
class2DatasetAnswer=-1*ones([1000,1]);
model=svmtrain([class1DatasetAnswer;class2DatasetAnswer],[scaledClass1Dataset;scaledClass2Dataset],'-b 1');

%Apply the model to classifier the whole image as the learning set
learningDatasetAnswer = double(ones(size(image,1)*size(image,2),1));
learningDataset = zeros(size(image,1)*size(image,2),3);
scaledLearningDataset = zeros(size(learningDataset,1),3);
for i=1:size(image,1)
    learningDataset((i-1)*size(image,2)+1:(i)*size(image,2),1)=double(image(i,:,1));
    learningDataset((i-1)*size(image,2)+1:(i)*size(image,2),2)=double(image(i,:,2));
    learningDataset((i-1)*size(image,2)+1:(i)*size(image,2),3)=double(image(i,:,3));
end
for i=1:size(learningDataset,1)
    scaledLearningDataset(i,1) = learningDataset(i,1)/255;
    scaledLearningDataset(i,2) = learningDataset(i,2)/255;
    scaledLearningDataset(i,3) = learningDataset(i,3)/255;
end

%svmOutput = svmpredict([class1DatasetAnswer;class2DatasetAnswer],[scaledClass1Dataset;scaledClass2Dataset],model,'-b 1');
svmOutput = svmpredict(learningDatasetAnswer,scaledLearningDataset,model,'-b 1');
BW=(svmOutput+1)/2;
newBW=reshape(BW,240,320);

%reconstruct back into a classified image representation
imageClassified = uint8(zeros(240,320,3));
for i=1:240
    for j=1:320
        if svmOutput((i-1)*320+j) == 1
            imageClassified(i,j,:) = 255;            
        else
            imageClassified(i,j,:) = 0;
        end
    end
end
keyboard;