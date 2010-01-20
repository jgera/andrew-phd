%turns an n-by-m images into a 3-by-(m*n) matrix and normalises by dividing
%by 255
function flatterned_data=flatern_image(imageData)
flatterned_data=zeros([size(imageData,1)*size(imageData,2),3]);
% mat2=zeros([size(mat2_temp,1)*size(mat2_temp,2),3]);
% mat3=zeros([size(mat3_temp,1)*size(mat3_temp,2),3]);

for i=1:size(imageData,1)
    flatterned_data((i-1)*size(imageData,2)+1:i*size(imageData,2),:)=imageData(i,:,:);
end


flatterned_data=flatterned_data/255;
