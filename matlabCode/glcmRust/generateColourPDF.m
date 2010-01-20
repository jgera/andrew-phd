%Calculate PDF of the property values from the constructed model
%glcmProperties(channel).properties
%model(material,channel,glcmProperties).std and .mean
%pdfData(material,channel,glcmProperties).Val
function overallProbPercent = generateColourPDF(imageSample,model)
%Get the average normalised values of the sample image
normalisedImage = normaliseImage(imageSample);
averageR = sum(sum(normalisedImage(:,:,1)))/(size(normalisedImage,1)*size(normalisedImage,2));
averageG = sum(sum(normalisedImage(:,:,2)))/(size(normalisedImage,1)*size(normalisedImage,2));
averageB = sum(sum(normalisedImage(:,:,3)))/(size(normalisedImage,1)*size(normalisedImage,2));

for curr_mat = 1:size(model,2)
    pdfData(curr_mat,1) = normpdf(averageR, model(curr_mat).Rmean, model(curr_mat).Rstd);
    pdfData(curr_mat,2) = normpdf(averageG, model(curr_mat).Gmean, model(curr_mat).Gstd);
    pdfData(curr_mat,3) = normpdf(averageB, model(curr_mat).Bmean, model(curr_mat).Bstd);
    overallProb(curr_mat) = pdfData(curr_mat,1)*pdfData(curr_mat,2)*pdfData(curr_mat,3);
end

%Normalise the overallProb and make into percentage
for i=1:size(overallProb,2)
    overallProbPercent(i) = overallProb(i)/sum(overallProb)*100;
end
