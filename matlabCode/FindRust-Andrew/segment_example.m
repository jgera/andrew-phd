%Choose picture file
options.     pic_choice=1;
options.    fname{1}={'untitled.png'};

level_grey_threshhold=false;

%image read
I = imread(char(options.fname{options.pic_choice}));
figure;
imshow(I)
title('I');

%make grey (equal contribution from all colors)
grey_I=(I(:,:,1)+I(:,:,2)+I(:,:,3))/3;
figure;
imshow(grey_I);
title('grey_I');

if level_grey_threshhold
    level = graythresh(I);
    bw1=im2bw(I,level);
else
    bw1=im2bw(I);
end
figure;
imshow(bw1);
title('bw2_aftermed');

%a value of about 10 is good from this large sized image
med_filter_xy=round(sqrt(size(I,1)*size(I,2)/5000));

bw2_aftermed = medfilt2(bw1, [med_filter_xy med_filter_xy]);
figure;
imshow(bw2_aftermed);
title('bw2_aftermed');
keyboard
%do canny
canny_edge=edge(uint8(bw2_aftermed*255),'canny');
figure;
imshow(canny_edge);
title('canny_edge');

%put the canny over the top of the original grey image
scalling_fac=100;
canny_edge_scalled=canny_edge*scalling_fac;
figure;
new_grey=uint8(canny_edge_scalled)+grey_I;
imshow(new_grey);
title('new_grey');

%put canny edge over original color image
new_I(:,:,1)=uint8(canny_edge_scalled)+I(:,:,1);
new_I(:,:,2)=uint8(canny_edge_scalled)+I(:,:,2);
new_I(:,:,3)=uint8(canny_edge_scalled)+I(:,:,3);
figure;
imshow(new_I);
title('new_I');



% Do watershed on the bw image after median filtering
afterwatershed = watershed(bw2_aftermed);
figure;
rgb = label2rgb(afterwatershed,'jet',[.5 .5 .5]);imshow(rgb);
title('afterwatershed');
return;