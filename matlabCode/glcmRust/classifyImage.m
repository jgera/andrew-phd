function labelImage = classifyImage(model, image, pixel)
%Divide the image according to the specified pixel size
%Determine how many column of size pixel is required to fill the image
columnSegment = floor(size(image,2)/pixel);
rowSegment = floor(size(image,1)/pixel);
labelImage = zeros(size(image,1), size(image,2));

columnLeftover = rem(size(image,2),pixel);
rowLeftover = rem(size(image,1),pixel);
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
        end
        if windowClass == 2
           rgbImage((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel,1) = 0;
           rgbImage((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel,2) = 255;
           rgbImage((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel,3) = 255; 
        end
        if windowClass == 3
           rgbImage((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel,1) = 255;
           rgbImage((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel,2) = 255;
           rgbImage((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel,3) = 0;
        end
        if windowClass == 4
           rgbImage((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel,1) = 255;
           rgbImage((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel,2) = 0;
           rgbImage((i-1)*pixel+1:i*pixel,(j-1)*pixel+1:j*pixel,3) = 0;
        end       
    end
end

%rgbImage = label2rgb(labelImage);
figure;
imshow(rgbImage);
