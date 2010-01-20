%Calculate PDF of the property values from the constructed model
%glcmProperties(channel).properties
%model(material,glcmProperties).std and .mean
%pdfData(material,glcmProperties).Val
function overallProbPercent = generateGrayPDF(glcmProperties,model)

for curr_property = 1:size(model,2)
    
        for curr_mat = 1:size(model,1)
            switch curr_property
                case 1                     
                    pdfData(curr_mat,curr_property) = normpdf(glcmProperties(4).Contrast, model(curr_mat,curr_property).mean, model(curr_mat,curr_property).std);
                case 2 
                    pdfData(curr_mat,curr_property) = normpdf(glcmProperties(4).Correlation, model(curr_mat,curr_property).mean, model(curr_mat,curr_property).std);
                case 3
                    pdfData(curr_mat,curr_property) = normpdf(glcmProperties(4).Energy, model(curr_mat,curr_property).mean, model(curr_mat,curr_property).std);
                case 4
                    pdfData(curr_mat,curr_property) = normpdf(glcmProperties(4).Homogeneity, model(curr_mat,curr_property).mean, model(curr_mat,curr_property).std);
            end
       
    end
end
%Working out the overall probability, first arrange it into a list for
%easier calculation
for curr_mat = 1:size(pdfData,1)
    counter = 1;
    for curr_property = 1:size(pdfData,2)
        %for curr_channel = 1:size(pdfData,2)
            pdfList(curr_mat,counter) = pdfData(curr_mat,curr_property); 
            counter = counter + 1;
        %end
    end
end

%Multiple all the probabilities together for each material type
for curr_mat=1:size(pdfList,1)
    for i=2:size(pdfList,2)
        if i == 2
            overallProb(curr_mat) = pdfList(curr_mat,i-1)*pdfList(curr_mat,i);            
        else
            overallProb(curr_mat) = overallProb(curr_mat)*pdfList(curr_mat,i); 
        end
    end
end
%Normalise the overallProb and make into percentage
for i=1:size(overallProb,2)
    overallProbPercent(i) = overallProb(i)/sum(overallProb)*100;
end
