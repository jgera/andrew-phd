function normalisedImage = normaliseImage(RGBimage,showFigure)
% This function takes an RGB image and produces an approximated 
% normalised image.
if nargin < 2, showFigure = 0; end
normalisedImage = zeros(size(RGBimage,1), size(RGBimage,2),3);
%sum = double(RGBimage(:,:,1)+RGBimage(:,:,2)+RGBimage(:,:,3));
Original = RGBimage;
RGBimage = double(RGBimage);
normalisedImage(:,:,1) = RGBimage(:,:,1)./(RGBimage(:,:,1)+RGBimage(:,:,2)+RGBimage(:,:,3));
normalisedImage(:,:,2) = RGBimage(:,:,2)./(RGBimage(:,:,1)+RGBimage(:,:,2)+RGBimage(:,:,3));
normalisedImage(:,:,3) = RGBimage(:,:,3)./(RGBimage(:,:,1)+RGBimage(:,:,2)+RGBimage(:,:,3));
if showFigure == 1
    figure; 
    imshow(Original);
    figure;
    imshow(normalisedImage);
end
