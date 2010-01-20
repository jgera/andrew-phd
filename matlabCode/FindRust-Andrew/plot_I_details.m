function plot_I_details(I,title_string)
    figure
    if size(I,3)==1
        %show the image
        subplot(1,2,1); imshow(I);
        title(title_string);
        %Historgram of image
        subplot(1,2,2); imhist(I);
        title('imhist Breakdown');

    elseif size(I,3)==3
        subplot(4,2,1:2); imshow(I);
        title(title_string);
        %array 1
        subplot(4,2,3); imshow(I(:,:,1));
        subplot(4,2,4); imhist(I(:,:,1));
        %array 2
        subplot(4,2,5); imshow(I(:,:,2));
        subplot(4,2,6); imhist(I(:,:,2));
        %array 3
        subplot(4,2,7); imshow(I(:,:,3));
        subplot(4,2,8); imhist(I(:,:,3));
    else uiwait(msgbox('unknown format, you have control'));
        keyboard
    end