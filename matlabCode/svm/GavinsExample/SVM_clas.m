function SVM_clas()

close all
clear all


%how much data to train with
ratio_to_use=0.1;


mat1_temp=importdata('mat1.jpg');
mat2_temp=importdata('mat2.jpg');
mat3_temp=importdata('mat3.jpg');
figure
subplot(1,3,1);imshow(mat1_temp);
subplot(1,3,2);imshow(mat2_temp);
subplot(1,3,3);imshow(mat3_temp);

%% Make vars
mat1=flatern_image(mat1_temp);
mat2=flatern_image(mat2_temp);
mat3=flatern_image(mat3_temp);


%% Plot on 3D RGB axis
figure
plot3(mat1(:,1),mat1(:,2),mat1(:,3),'r.');hold on
plot3(mat2(:,1),mat2(:,2),mat2(:,3),'g.');hold on
plot3(mat3(:,1),mat3(:,2),mat3(:,3),'b.');hold on

%% get a random index (ri) to train from 
temp=randperm(size(mat1,1));ri1=temp(1:round(size(mat1,1)*ratio_to_use));
mat1=mat1(ri1,:);

temp=randperm(size(mat2,1));ri2=temp(1:round(size(mat2,1)*ratio_to_use));
mat2=mat2(ri2,:);

temp=randperm(size(mat3,1));ri3=temp(1:round(size(mat2,1)*ratio_to_use));
mat3=mat3(ri3,:);

%% Model building
%1 vers 2
model(1,2).val=svmtrain([-1*ones([size(mat1,1),1]);...
                          1*ones([size(mat2,1),1])],...
                          [mat1;mat2],'-b 1');
%1 vers 3
model(1,3).val=svmtrain([-1*ones([size(mat1,1),1]);...
                          1*ones([size(mat3,1),1])],...
                          [mat1;mat3],'-b 1');
%2 vers 3
model(2,3).val=svmtrain([-1*ones([size(mat2,1),1]);....
                          1*ones([size(mat3,1),1])],...
                          [mat2;mat3],'-b 1');

% %% Predicting
% %1 vers 2
% svmpredict([-1*ones([size(mat1,1),1]);...
%              1*ones([size(mat2,1),1])],...
%              [mat1;mat2],model(1,2).val);
% %1 vers 3
% svmpredict([-1*ones([size(mat1,1),1]);...
%              1*ones([size(mat3,1),1])],...
%              [mat1;mat3],model(1,3).val);
% %2 vers 3
% svmpredict([-1*ones([size(mat2,1),1]);....
%              1*ones([size(mat3,1),1])],...
%              [mat2;mat3],model(2,3).val);

%% aquire images and predict         
vid_aq(model)
         