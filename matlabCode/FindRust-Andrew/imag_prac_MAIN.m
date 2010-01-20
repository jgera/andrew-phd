function imag_prac_MAIN()
close all;clear all;imtool close all;

%PROG OPTIONS
options.    display_I_details=1;
options.    use_image_tool=1;
options.    show_image_breakdown=1;
options.    change_contrast=1; 
    options.    save_new_contrast_file=0;

options.    perform_morphological_operation=0;
    options.    change_background=1;
        options.    save_new_background_file=0;
        options.    change_background_then_contrast=1;
            options.    save_change_background_then_contrast=0;
            options.    do_bin_representation=1;
                options.    pseudo_color_of_bin_rep=0;
                options.    bind_sections_and_plot=1;

options.    warp_object_to_3D_shape=0;
options.    select_region=0;
options.    dofunnycolorstuff=0;
options.    rotation=0;
options.    crop=0;
options.    transform=0;




%Choose picture file
options.     pic_choice=1;
options.    fname{1}={'untitled.png'};
% options.    fname{2}={'Picture 006.tif'};
% options.    fname{3}={'Picture 006.bmp'};
% options.    fname{4}={'pout.tif'};
% options.    fname{5}={'rice.png'};
% options.    fname{6}={'eight.tif'};
% options.    fname{7}={'me.bmp'};
% options.    fname{8}={'CSCbot.bmp'};





level_grey_threshhold=false;

%image read
I = imread(char(options.fname{options.pic_choice}));
figure;
imshow(I)
title('I');

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

%this value of 10 should depend upon the size of the original image 
med_filter_xy=round(sqrt(size(I,1)*size(I,2)/5000));

bw2_aftermed = medfilt2(bw1, [med_filter_xy med_filter_xy]);
figure;
imshow(bw2_aftermed);
title('bw2_aftermed');

canny_edge=edge(uint8(bw2_aftermed*255),'canny');
figure;
imshow(canny_edge);
title('canny_edge');

scalling_fac=100;
canny_edge_scalled=canny_edge*scalling_fac;
figure;
new_grey=uint8(canny_edge_scalled)+grey_I;
imshow(new_grey);
title('new_grey');


new_I(:,:,1)=uint8(canny_edge_scalled)+I(:,:,1);
new_I(:,:,2)=uint8(canny_edge_scalled)+I(:,:,2);
new_I(:,:,3)=uint8(canny_edge_scalled)+I(:,:,3);
figure;
imshow(new_I);
title('new_I');




afterwatershed = watershed(bw2_aftermed);
figure;
imshow(afterwatershed);
title('afterwatershed');
return;



%I is a X pixel by Y pixel of RGB colors, Bytes size is the same as the size of the file
    if options.display_I_details; display('IMAGE DETAILS'); display(whos('I')); end

%this gives and interactive interface and you can look at all the pixels etc
    if options.use_image_tool; imtool(I); end

%this will display the image and its histogram breakdown
    if options.show_image_breakdown; plot_I_details(I,'Original Figure & breakdown'); end
    
%the histeq function to spread the intensity values over the full range of the image
    if options.change_contrast; 
        for current_array=1:size(I,3); I2(:,:,current_array) = histeq(I(:,:,current_array));end      
        plot_I_details(I2,'Changed Contrast & breakdown');
        %save the file to the same filename with "_newcontr" after it
        if options.save_new_contrast_file; save_images(I2,options,'_newcontr'); end
     end

%Morphological opening is an erosion followed by a dilation, using the same structuring element for both operations. 
%The opening operation has the effect of removing objects that cannot completely contain the structuring element
    if options.perform_morphological_operation; perform_morphological_operation(I, options); end
    
if options.warp_object_to_3D_shape
    %choose shap to warp to
    [x,y,z] = cylinder;
    x=x(:,1:round(size(x,2)/2));
    y=y(:,1:round(size(y,2)/2));
    z=z(:,1:round(size(z,2)/2));
    warp(x,y,z,I);
    
%     hold on
%     [point_cloud,point_cloud_handle]=draw_point_cloud();
%     warp([point_cloud(1:3:end-1,1)';point_cloud(2:3:end,1)';point_cloud(2:3:end,1)'],...
%          [point_cloud(1:3:end-1,2)';point_cloud(2:3:end,2)';point_cloud(2:3:end,2)'],...
%          [point_cloud(1:3:end-1,3)';point_cloud(2:3:end,3)';point_cloud(2:3:end,3)'],I)

end

%select a specific region worth of pixels for analysis
if options.select_region
    c = [222 272 300 270 221 194];
    r = [21 21 75 121 121 75];
    BW = roipoly(I,c,r);
    plot_I_details(BW,'specific region');
end

if options.do_bin_representation
    do_bin_representation(I,options,1);
end

%do some addition subtraction on the images and see what comes out
if options.dofunnycolorstuff
    figure
    imshow(I,'DisplayRange',[]), colorbar
    % I2(:,:,1) = (I(:,:,2)+I(:,:,3))/2;
    % I2(:,:,2) =I(:,:,2);I2(:,:,3) =I(:,:,3);
    I2(:,:,1)=I(:,:,1)-I(:,:,1);
    I2(:,:,2)=I(:,:,2);
    I2(:,:,3)=I(:,:,3);

    plot_I_details(I2,'funny colors remoulded together');
end

%rotate around, I define value of i (deg)
if options.rotation; warning off;for i=1:1;imrotate(I,i);drawnow;end;warning on;end

%crop image and put a border around cropped bit on main image
if options.crop
    figure;
    subplot(1,2,1);imshow(I);hold on;
    plot([100,100,200,200,100],[150,250,250,150,150]);
    subplot(1,2,2);imshow(I2);
end

% do Transform (movement)
if options.transform
    cb=checkerboard;
    xform = [1,0,0;0,1,0;40,40,1];
    tform_translate = maketform('affine',xform);
    [cb_trans xdata ydata]= imtransform(cb, tform_translate);
    cb_trans2 = imtransform(cb, tform_translate,'XData',[1 (size(cb,2)+xform(3,1))],'YData', [1 (size(cb,1)+xform(3,2))],'FillValues', .7 );
    %draw it up
    figure;
    subplot(1,2,1); imshow(cb);
    subplot(1,2,2); imshow(cb_trans2);
end