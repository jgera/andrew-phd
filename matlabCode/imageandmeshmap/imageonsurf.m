function imageonsurf()
% system('F:\Program Files\MATLAB\R2007a\work\EyeinHand>EyeInHand.exe /regserver')
global hMesh
% clear global hMesh
pause_rate=0.0001;

%  hMesh=[];

if isempty(hMesh)
    h = actxserver('EyeInHand.SurfaceMap');
    directory=pwd;

    %needs to be in front of wehn surface is added
%     h.Resolution=0.18;
    
%     h.SurfaceFusionDistance = 0.1;
%     h.SurfaceDeviation = 0.05;
    
    aabbExtent = [-10, -10, -10; 3, 10, 10];
%     aabbExtent = [-2, -1, 0; 2, 1, 3];
%     h.Extent = aabbExtent;

    h.AddSurfaceMap([directory,'\','test2.ply']);
    %to get range grid I need trace to in the scanner command
%     h.AddRangeGrid([directory,'\','test2.ply']);
    % h.AddRangeGrid([directory,'\','bunny.ply']);
%     h.AddRangeGrid([directory,'\','grid_1.ply']);


    %shold do this too
    % h.Optimise;
    aabb.lower = [-10, -10, -10];
    aabb.upper = [10, 10, 10];
%     aabb.lower = [-2, -1, 0];
%     aabb.upper = [2, 1, 3];

    hMesh = h.SurfacesInsideBox(aabb.lower, aabb.upper);
else
    display('Not realoading hMesh from scratch!!');
end
faces = hMesh.FaceData;
verts = hMesh.VertexData;


%% setupfunctions
setuprobot(7);
% setupworkspace(false);
% setupoptimisation();
% setupscanner();

%% Points
global r 
close all

%determine all normals
meshnormals=zeros([size(faces,1),3]);
% meshnormals(i,:)= cross(verts(faces(i,1),:)-verts(faces(i,2),:),
% verts(faces(i,1),:)-verts(faces(i,3),:));
    a=[verts(faces(1:size(faces,1),1),:)-verts(faces(1:size(faces,1),2),:)]';
    b=[verts(faces(1:size(faces,1),1),:)-verts(faces(1:size(faces,1),3),:)]';
    meshnormals(1:size(faces,1),:)= [a(2,:).*b(3,:)-a(3,:).*b(2,:)
                       a(3,:).*b(1,:)-a(1,:).*b(3,:)
                       a(1,:).*b(2,:)-a(2,:).*b(1,:)]';

%load image
filenames=dir('*.png');
%parse filenmae
for i=1:size(filenames)
    image_dat(i).pixels=imread(filenames(i).name);
    image_dat(i).size=[size(image_dat(i).pixels,1),size(image_dat(i).pixels,2)];
    [image_dat(i).time,text_remaining]= strtok(filenames(i).name,'POSE');
    [nothing,text_remaining] =strtok(text_remaining,' ');  
    %get rid of the .png off end and get pose data from file
    image_dat(i).robot_pose=cell2mat(textscan(text_remaining(1:end-4), '%n %n %n %n %n %n', 1));
end

%go through each image
for curr_im=1:size(image_dat,2)
    
% direction of robot
tr=fkine(r,[image_dat(curr_im).robot_pose,0]);


%this will actually be x or y axis from end effector but not sure which
%have to find out which axis the 5th joint rotates around
laser_pos=tr(1:3,4)';
bear=tr(1:3,3)'; %used to be [0,0,1]
tilt_rotate_vec=tr(1:3,1)';
pan_rotate_vec=tr(1:3,2)';

%max range of laser
cam_range=3;

%Laser Angualar VARIABLES
%this is the angle either side of the bearing of the center of the scan \|/
theta=deg2rad(50)/2;
%the increment angle used in both 
%theta_incr=scan.theta_incr;
%this is the angle from the tilt, - is up, + is down, angle must be from -2pi to 2pi
alpha=deg2rad(35)/2;

% %SETUP WORKSPACE

%since we want to know what is the max angle we can use HERE only so that
%at the furthest point we have resolution enough to cover our cubes at
%least 3 times at the point of longest laser range, so we use that angular
%resolution for this simulation
% theta_incr=atan((cube_size/3)/cam_range);
theta_incr=image_dat(curr_im).size(2)/deg2rad(50);

%we have an actual min resoltion in hardware so this is the minmum
% if theta_incr<scan.theta_incr
%     theta_incr=scan.theta_incr;
% end
    
%% Take the scan - work out end points
% This is the most important vector
% it describes the center of the first laser pan scan 
% we will rotate to ge the pan scan
dir_vec=cam_range*(bear);
%this is the vector that we will pan rotate around, it is always at origin
%so we get cross product of the two vectors on the plane to get normal
%pan_rotate_vec=cross(dir_vec,tilt_rotate_vec);
% pan_rotate_vec=tilt_rotate_vec  * [0 -dir_vec(3) dir_vec(2);...
%                                    dir_vec(3) 0 -dir_vec(1);...
%                                    -dir_vec(2) dir_vec(1) 0];


%this works out through pan rotation of the ice cream cone from the origin
%work out how many increments based on lasers lowest steps
% increments=round(2*theta/theta_incr);
theta_increments=image_dat(curr_im).size(2);
single_pan=[]; 
for j=theta:-(2*theta)/(theta_increments-1):-theta
    single_pan=[single_pan;rot_vec(dir_vec,pan_rotate_vec,j)];
end
current_row=1;

alpha_increments=image_dat(curr_im).size(1);

ice_cream_bounds=zeros([theta_increments*alpha_increments,3]);



%this tilt rotates and transforms to come form laser position
% for i=-2*alpha:2*alpha/(alpha_increments-1):0
% for i=0:2*alpha/(alpha_increments-1):2*alpha
for i=-alpha:2*alpha/(alpha_increments-1):alpha
    tilt_rot_res=rot_vec(single_pan,tilt_rotate_vec,i);
    new_current_row=current_row+size(tilt_rot_res,1);
    ice_cream_bounds(current_row:new_current_row-1,:)=[tilt_rot_res(:,1)+laser_pos(1),...
        tilt_rot_res(:,2)+laser_pos(2),...
        tilt_rot_res(:,3)+laser_pos(3)];
    current_row=new_current_row;    
end

%normlise image and put into collums
normalise_im=double(image_dat(curr_im).pixels)/double(max(max(max(image_dat(curr_im).pixels))));
% image_dat(curr_im).pixels(1:10,1,:)/max(max(max(image_dat(curr_im).pixels(1:10,1,:))));
newimage=zeros([size(image_dat(curr_im).pixels,1)*size(image_dat(curr_im).pixels,2),3]);
for i=1:size(image_dat(curr_im).pixels,1)
%     for j=1:size(image_dat(curr_im).pixels,2)
%         newimage((i-1)*size(image_dat(curr_im).pixels,2)+j,:)=squeeze(normalise_im(i,j,:))';
%     end

        newimage((i-1)*size(image_dat(curr_im).pixels,2)+1:(i-1)*size(image_dat(curr_im).pixels,2)+size(image_dat(curr_im).pixels,2),:)=...
            squeeze(normalise_im(i,:,:));

end


% plot3(ice_cream_bounds(:,1),ice_cream_bounds(:,2),ice_cream_bounds(:,3),'r.')
% plot3(ice_cream_bounds(:,1),ice_cream_bounds(:,2),ice_cream_bounds(:,3),'color',newimage)
%  scatter3(ice_cream_bounds(:,1),ice_cream_bounds(:,2),ice_cream_bounds(:,3),10*ones([size(ice_cream_bounds,1),1]),newimage(:,1:3))
% scatter3(ice_cream_bounds(1:20000,1),ice_cream_bounds(1:20000,2),ice_crea
% m_bounds(1:20000,3),ones([20000,1]),newimage(1:20000,1:3))

view(3)
if curr_im==1
    camlight;
end
% figure
% image(image_dat(curr_im).pixels)
% For plotting
xlabel('x');
ylabel('y');



% triangle 1,2,3
% verts = [Pnt1;Pnt2;Pnt3; Pnt1a;Pnt2a;Pnt3a; Pnt1b;Pnt2b;Pnt3b];
%faces (which vertices to link)
% faces = [1 2 3;4,5,6;7,8,9];
%face color in RGB
% tcolor = [1 1 1;1,1,1;1,1,1];
% patch('Faces',faces,'Vertices',verts,'FaceVertexCData',tcolor,'FaceColor','flat');
% patch('Faces',faces,'Vertices',verts,'FaceColor',[0.1*ones([size(faces,1),1])],'EdgeColor',0.1*ones([size(faces,1),1]));
patch('Faces',faces,'Vertices',verts,'FaceVertexCData',[0.1*ones([size(faces,1),1])],'FaceColor','none');

hold on;



%% Start and end poses (you need to use 7 joints with the new robot)
% startQ=[18.8593  151.4173   16.1927    3.2566  -57.8998 0,0];
% midQ1=[44.8941   91.4173   15.6529   -2.5330  -39.9189 0,0];
% midQ2= [63.3475   72.1016   12.7140   -4.6554  -12.8295 0,0];
% endQ = [65.6547   57.6991   45  -6.7510 -116.1888         0,0];

% startQ=[0  -90   90    0  -100 0,0];
% endQ=[0  -90   90    0  100 0,0];
% midQ1=[44.8941   91.4173   15.6529   -2.5330  -39.9189 0,0];
% midQ2= [63.3475   72.1016   12.7140   -4.6554  -12.8295 0,0];
% endQ = [65.6547   57.6991   45  -6.7510 -116.1888         0,0];

%% Make increments between start and finish poses
% first run increments
% [all_steps,row_of_all_steps]=onedegree_inc_movement(startQ,endQ);
% % second run  increments
% [all_steps_Sec,row_of_all_steps_sec]=onedegree_inc_movement(midQ1,midQ2);
% % Third run  increments
% [all_steps_thir,row_of_all_steps_thir]=onedegree_inc_movement(midQ2,endQ);
% % add all steps together
% all_steps=[all_steps;all_steps_Sec;all_steps_thir];
% row_of_all_steps=row_of_all_steps+row_of_all_steps_sec+row_of_all_steps_thir;

axisH=gcf;
plot(r,[image_dat(curr_im).robot_pose,0],'axis',axisH);

axis equal

toplot=[];
toplot_color=[];
% profile clear; profile on;
%% Plotting first run
for i = 1:size(ice_cream_bounds,1)
%     data= deg2rad(all_steps(i,:)) ;   % : means all the colouumn values
%     tr= fkine(r, data );                               
     endefectr= tr(1:3,4)';   % the point of end effector 
%     blastpoint=endefectr+tr(1:3,3)';  
    blastpoint=ice_cream_bounds(i,:);
    
    % Blaststream Distance
    De=sqrt((endefectr(1) - blastpoint(1))^2+(endefectr(2) - blastpoint(2))^2+(endefectr(3) - blastpoint(3))^2);

    %Go through all faces and check which has the smallest distance to the end
    %effector
    currMin=inf;
    currMin_disttoofar=inf;
    pntInt=[];
    pntInt_disttoofar=[];
    faces_of_interest=find(((verts(faces(:,1),1)-blastpoint(1)).^2+...
                            (verts(faces(:,1),2)-blastpoint(2)).^2+...
                            (verts(faces(:,1),3)-blastpoint(3)).^2)<3);
[nothing,faces_of_interest_order]=sortrows((verts(faces(faces_of_interest,1),1)-blastpoint(1)).^2+...
                              (verts(faces(faces_of_interest,1),2)-blastpoint(2)).^2+...
                              (verts(faces(faces_of_interest,1),3)-blastpoint(3)).^2);
faces_of_interest=faces_of_interest(faces_of_interest_order);
                        
    if isempty(faces_of_interest)
%         %plot robot on current axis
%         axisH=gcf;
%         plot(r,data,'axis',axisH);
%         pause (pause_rate);
        continue
    end
%     if mod(i,20)==0
%         i
%     end
%     ,verts(faces(:,2),:),verts(faces(:,3),:)
%     find(blastpoint
    
% profile clear; profile on;
%     for j=1:size(faces,1)
% counter=0;
    for j=faces_of_interest'
        keyboard
%         counter=counter+1;
        [pntInt_temp]=plane_line_intersect(meshnormals(j,:),verts(faces(j,1),:),endefectr,blastpoint);        
        if ~isempty(find(pntInt_temp==inf,1))
            continue
        end
        Dis_endef_pntint= sqrt((endefectr(1) - pntInt_temp(1))^2+(endefectr(2) - pntInt_temp(2))^2+(endefectr(3) - pntInt_temp(3))^2);
        Dis_blast_pntint= sqrt((blastpoint(1) - pntInt_temp(1))^2+(blastpoint(2) - pntInt_temp(2))^2+(blastpoint(3) - pntInt_temp(3))^2);    
        keyboard         
        if Dis_blast_pntint< De
            %check if point of intersection is inside triange  
            if PointInQuad(pntInt_temp, [verts(faces(j,1),:);verts(faces(j,2),:);verts(faces(j,3),:)])
                %check if point of intersection is between end effector and blast point
                if Dis_endef_pntint< De && Dis_blast_pntint< De
                    if Dis_endef_pntint<currMin
                        pntInt=pntInt_temp;
                        break;
                    end
                % if is on the correct side and a little bit too far
                elseif Dis_blast_pntint< De
                    if Dis_endef_pntint<currMin_disttoofar
                        pntInt_disttoofar=pntInt_temp;
                        break;
                    end
                end
            end
        end
    end
%     counter/size(faces_of_interest,1)
    
%     profile off;
%     profile viewer;
%     keyboard;

    %check if we have a valid point of intersection with a triangle
    if ~isempty(pntInt) || ~isempty(pntInt_disttoofar)
%         hold on;
        %check if point of intersection is between end effector and blast point
        if ~isempty(pntInt)
            toplot=[toplot;pntInt];toplot_color=[toplot_color;newimage(i,:)];
%             plot3(pntInt(1),pntInt(2),pntInt(3),'color',newimage(i,:),'Marker','.','Markersize',30); % the plane intersection
% %             greenline=plot3([pntInt(1),endefectr(1)],[pntInt(2),endefectr(2)],[pntInt(3),endefectr(3)],'b'); % the line form projection to the point on plane
%              pause(pause_rate)
% %             delete(greenline)
        elseif ~isempty(pntInt_disttoofar)
            toplot=[toplot;pntInt_disttoofar];toplot_color=[toplot_color;newimage(i,:)];
% %             plot3(blastpoint(1),blastpoint(2),blastpoint(3),'r.'); %projection from the end effector
%             plot3(pntInt_disttoofar(1),pntInt_disttoofar(2),pntInt_disttoofar(3),'color',newimage(i,:),'Marker','.','Markersize',30);
% %             redline = plot3([tr(1,4),blastpoint(1)],[tr(2,4),blastpoint(2)],[tr(3,4),blastpoint(3)],'r');  % the line from end effector to the projecttion
%              pause(pause_rate)
% %             delete(redline)
        end
    else
%         if rand>0.99
%             plot3(blastpoint(1),blastpoint(2),blastpoint(3),'color',newimage(i,:),'Marker','.','Markersize',10);
%         end
%         pause(pause_rate)
    end
%     hold on;

%     %plot robot on current axis
%     axisH=gcf;
%     plot(r,data,'axis',axisH);
%     pause (pause_rate);

 
    %% Pose selection
   % a=tr(1,3); 
    %b=tr(2,3); 
    %c=tr(3,3);
    %d=-a*blastpoint(1)-b*blastpoint(2)-c*blastpoint(3);
    %planeEqu=[a,b,c,d]; 

    %qnew=blasting_posesel(blastpoint, planeEqu, deg2rad(midQ1));  

end 
% profile off;profile viewer; 
    if size(toplot,1)>0
        scatter3(toplot(:,1),toplot(:,2),toplot(:,3),60*ones([size(toplot,1),1]),toplot_color,'filled'); % the plane intersection
    end
end


%% onedegree_inc_movement between 2 poses 
%divides 2 poses passed in by eiher the maximum size or it will simply put
%together the start and end 
function [all_steps,size_all_steps]=onedegree_inc_movement(startQ,endQ)
all_steps=[];
total_incre = max(abs(endQ-startQ)); 

increments=(endQ-startQ)/max(abs(endQ-startQ));

all_steps=[];

%start point
all_steps=startQ;

for i=1:total_incre  
    all_steps=[all_steps;...             
              startQ+i*increments];          
end

all_steps=[all_steps;endQ];
%size of all_steps
size_all_steps= size(all_steps,1);