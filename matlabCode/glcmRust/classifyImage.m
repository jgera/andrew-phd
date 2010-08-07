function labelImage = classifyImage(model, image, pixel)
%Divide the image according to the specified pixel size
%Determine how many column of size pixel is required to fill the image
columnSegment = floor(size(image,2)/pixel);
rowSegment = floor(size(image,1)/pixel);
labelImage = zeros(size(image,1), size(image,2));

columnLeftover = rem(size(image,2),pixel);
rowLeftover = rem(size(image,1),pixel);
windowClass_count=zeros([4,1]);
for i=1:rowSegment
    for j=1:columnSegment
        imageSection = image((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel,:); 
        glcmProperties = createGLCMProperties(imageSection); %Get the properties of the image section
        overallProbPercent = generatePDF(glcmProperties,model);       
        windowClass = 1; %Let the class of the image segment = class 1 first
        for x = 1:size(overallProbPercent,2)-1
            if overallProbPercent(windowClass) < overallProbPercent(x+1)
                windowClass = x+1; %Update the class of the image segment
            end
        end
        labelImage((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel) = windowClass;
        if windowClass == 1
           rgbImage((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel,1) = 0;
           rgbImage((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel,2) = 0;
           rgbImage((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel,3) = 255;
           windowClass_count(1)=windowClass_count(1)+1;
        end
        if windowClass == 2
           rgbImage((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel,1) = 0;
           rgbImage((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel,2) = 255;
           rgbImage((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel,3) = 255; 
           windowClass_count(2)=windowClass_count(2)+1;
        end
        if windowClass == 3
           rgbImage((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel,1) = 255;
           rgbImage((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel,2) = 255;
           rgbImage((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel,3) = 0;
           windowClass_count(3)=windowClass_count(3)+1;
        end
        if windowClass == 4
           rgbImage((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel,1) = 255;
           rgbImage((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel,2) = 0;
           rgbImage((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel,3) = 0;
           windowClass_count(4)=windowClass_count(4)+1;
        end       
    end
end

%rgbImage = label2rgb(labelImage);
figure;
imshow(rgbImage);
title(['Blue: ', num2str(windowClass_count(1)),'(',num2str(windowClass_count(1)/sum(windowClass_count)*100),'%)',...
    ' Teal: ', num2str(windowClass_count(2)),'(',num2str(windowClass_count(2)/sum(windowClass_count)*100),'%)',...
    ' Yellow: ', num2str(windowClass_count(3)),'(',num2str(windowClass_count(3)/sum(windowClass_count)*100),'%)',...
    ' Red: ', num2str(windowClass_count(4)),'(',num2str(windowClass_count(4)/sum(windowClass_count)*100),'%)']);
