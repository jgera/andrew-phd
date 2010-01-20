function textureBridge()
profile on;
global hMesh
pause_rate=0.0001;

%if isempty(hMesh)
    h = actxserver('EyeInHand.SurfaceMap');
    %h.Resolution = 0.05;
    directory=pwd;
    %keyboard
    aabbExtent = [-100, -100, -100; 30, 100, 100];
    %h.AddSurfaceMap([directory,'\','test2.ply']);
%     h.AddRangeGrid([directory,'\','grid_1.ply']);
%     h.AddRangeGrid([directory,'\','grid_2.ply']);
%     h.AddRangeGrid([directory,'\','grid_3.ply']);
%     h.AddRangeGrid([directory,'\','grid_4.ply']);
    h.AddRangeGrid([directory,'\','20091203T115035__1.ply']);
    h.AddRangeGrid([directory,'\','20091203T115035__2.ply']);

    aabb.lower = [-10, -10, -10];
    aabb.upper = [10, 10, 10];
    hMesh = h.SurfacesInsideBox(aabb.lower, aabb.upper);
%else
%    display('Not realoading hMesh from scratch!!');
%end


faces = hMesh.FaceData;
verts = hMesh.VertexData;

%% Determine all normals of the mesh, used for ray casting operation
%determine all normals
meshnormals=zeros([size(faces,1),3]);
% meshnormals(i,:)= cross(verts(faces(i,1),:)-verts(faces(i,2),:),
% verts(faces(i,1),:)-verts(faces(i,3),:));
    a=[verts(faces(1:size(faces,1),1),:)-verts(faces(1:size(faces,1),2),:)]';
    b=[verts(faces(1:size(faces,1),1),:)-verts(faces(1:size(faces,1),3),:)]';
    meshnormals(1:size(faces,1),:)= [a(2,:).*b(3,:)-a(3,:).*b(2,:)
                       a(3,:).*b(1,:)-a(1,:).*b(3,:)
                       a(1,:).*b(2,:)-a(2,:).*b(1,:)]';

%% setupfunctions
%setuprobot(6);
a=Ex.robObject('laserRob'); 
%% Points
global r 
close all
currMin=inf;

%% load image
filenames=dir('*.bmp');
%parse filenmae
for i=1:size(filenames)
    image_dat(i).pixels=imread(filenames(i).name);
    image_dat(i).size=[size(image_dat(i).pixels,1),size(image_dat(i).pixels,2)];
    [image_dat(i).time,text_remaining]= strtok(filenames(i).name,'POSE');
    [nothing,text_remaining] =strtok(text_remaining,' ');  
    %get rid of the .png off end and get pose data from file
    image_dat(i).robot_poseDeg=cell2mat(textscan(text_remaining(1:end-4), '%n %n %n %n %n %n', 1));    
end
%scatter3(verts(:,1),verts(:,2),verts(:,3),'filled');
%Draw the environment
%trisurf(faces, verts(:,1), verts(:,2), verts(:,3), 'FaceColor', 'None');
%go through each image
%keyboard

%% Process each image onto the mesh points using the patch function
for curr_im=1:size(image_dat,2)
    
% direction of robot
    for i = 1:size(image_dat(curr_im).robot_poseDeg,2)        
        image_dat(curr_im).robot_pose(i) = deg2rad(image_dat(curr_im).robot_poseDeg(i));     
    end 
            
    tr1=fkine(a.r,image_dat(curr_im).robot_pose);
    M = makehgtform('translate',[-0.04,0.025,0.085]); %Transform the point of the frame 
    N = makehgtform('yrotate',deg2rad(20));    %Rotate the axis
    O = makehgtform('xrotate',deg2rad(180));    %Rotate the axis so the robot faces the other way
    tr = tr1*M*N;

    %tr = tr1;
    endefectr= tr(1:3,4)';   % the point of end effector
    %endefectr = endefectr + [-0.1,-0.06,0.08]; %offset the endefectr point to match camera location    
    bear=tr(1:3,3)'; %used to be [0,0,1]    
    tilt_rotate_vec=tr(1:3,2)';
    pan_rotate_vec=tr(1:3,1)';
    %bear = rot_vec(bear,pan_rotate_vec,deg2rad(21)); %Change normal to an angle that would match the camera's

    %max range of laser
    cam_range=4;

    %Laser Angualar VARIABLES
    %this is the angle either side of the bearing of the center of the scan \|/
    theta=deg2rad(50)/2;
    %the increment angle used in both 
    %theta_incr=scan.theta_incr;
    %this is the angle from the tilt, - is up, + is down, angle must be from -2pi to 2pi
    alpha=deg2rad(35)/2;    
    theta_incr=image_dat(curr_im).size(2)/deg2rad(50);
    %trisurf(faces, verts(:,1), verts(:,2), verts(:,3), 'FaceColor', 'None');
     axisH=gcf;
%      plot(a.r,image_dat(curr_im).robot_pose,'axis',axisH);    
     %camlight;
    dir_vec=cam_range*(bear); 

    % Plot the different ray lines
    line([tr(1,4),tr(1,1)+tr(1,4)],[tr(2,4),tr(2,1)+tr(2,4)],[tr(3,4),tr(3,1)+tr(3,4)],'Color','r'); %pan_rotate_vec (vertical down)
    line([tr(1,4),tr(1,2)+tr(1,4)],[tr(2,4),tr(2,2)+tr(2,4)],[tr(3,4),tr(3,2)+tr(3,4)]); %tilt_rotate_vec (horiztonal) 
    line([tr(1,4),tr(1,3)+tr(1,4)],[tr(2,4),tr(2,3)+tr(2,4)],[tr(3,4),tr(3,3)+tr(3,4)],'Color','g'); %bear (straight) ahead line
    line([endefectr(1),tilt_rotate_vec(1)+endefectr(1)],[endefectr(2),tilt_rotate_vec(2)+endefectr(2)],[endefectr(3),tilt_rotate_vec(3)+endefectr(3)]);
    line([endefectr(1),pan_rotate_vec(1)+endefectr(1)],[endefectr(2),pan_rotate_vec(2)+endefectr(2)],[endefectr(3),pan_rotate_vec(3)+endefectr(3)],'Color','g');
    line([endefectr(1),bear(1)+endefectr(1)],[endefectr(2),bear(2)+endefectr(2)],[endefectr(3),bear(3)+endefectr(3)]); 
    line([endefectr(1),dir_vec(1)+endefectr(1)],[endefectr(2),dir_vec(2)+endefectr(2)],[endefectr(3),dir_vec(3)+endefectr(3)],'Color','k'); 
    %We're assuming a field of view of 40 degrees for the camera for width
    %and 20 degree for height    
    rotationVector1 = rot_vec(dir_vec,pan_rotate_vec,deg2rad(21.8)); %horizontal scout ray Lens field of view is 43'36 x 33'24 = 43.6 x 33.4 for a 1/3' sensor
    rotationVector2 = rot_vec(dir_vec,pan_rotate_vec,deg2rad(-21.8)); % horizontal scout ray
    rotationVector3 = rot_vec(dir_vec,tilt_rotate_vec,deg2rad(16.7)); % vertical scout ray
    rotationVector4 = rot_vec(dir_vec,tilt_rotate_vec,deg2rad(-16.7)); % vertical scout ray
    rotationVector5 = rot_vec(rotationVector1,tilt_rotate_vec,deg2rad(16.7)); %Image corner ray
    rotationVector6 = rot_vec(rotationVector2,tilt_rotate_vec,deg2rad(16.7)); %Image corner ray
    rotationVector7 = rot_vec(rotationVector1,tilt_rotate_vec,deg2rad(-16.7)); %Image corner ray
    rotationVector8 = rot_vec(rotationVector2,tilt_rotate_vec,deg2rad(-16.7)); %Image corner ray
    
    blastpoint(1).vector = rotationVector1+endefectr;
    blastpoint(2).vector = rotationVector2+endefectr;
    blastpoint(3).vector = rotationVector3+endefectr;
    blastpoint(4).vector = rotationVector4+endefectr;
    blastpoint(5).vector = rotationVector5+endefectr;
    blastpoint(6).vector = rotationVector6+endefectr;
    blastpoint(7).vector = rotationVector7+endefectr;
    blastpoint(8).vector = rotationVector8+endefectr;
    blastpoint(9).vector = dir_vec+endefectr;
    
    %De=sqrt((endefectr(1) - blastpoint1(1))^2+(endefectr(2) - blastpoint1(2))^2+(endefectr(3) - blastpoint1(3))^2);
    De=sqrt((endefectr(1) - dir_vec(1))^2+(endefectr(2) - dir_vec(2))^2+(endefectr(3) - dir_vec(3))^2);
    line([endefectr(1),rotationVector1(1)+endefectr(1)],[endefectr(2),rotationVector1(2)+endefectr(2)],[endefectr(3),rotationVector1(3)+endefectr(3)],'Color','r');    
    line([endefectr(1),rotationVector2(1)+endefectr(1)],[endefectr(2),rotationVector2(2)+endefectr(2)],[endefectr(3),rotationVector2(3)+endefectr(3)],'Color','r');
    line([endefectr(1),rotationVector3(1)+endefectr(1)],[endefectr(2),rotationVector3(2)+endefectr(2)],[endefectr(3),rotationVector3(3)+endefectr(3)],'Color','r');
    line([endefectr(1),rotationVector4(1)+endefectr(1)],[endefectr(2),rotationVector4(2)+endefectr(2)],[endefectr(3),rotationVector4(3)+endefectr(3)],'Color','r');
    line([endefectr(1),rotationVector5(1)+endefectr(1)],[endefectr(2),rotationVector5(2)+endefectr(2)],[endefectr(3),rotationVector5(3)+endefectr(3)],'Color','b');
    line([endefectr(1),rotationVector6(1)+endefectr(1)],[endefectr(2),rotationVector6(2)+endefectr(2)],[endefectr(3),rotationVector6(3)+endefectr(3)],'Color','b');
    line([endefectr(1),rotationVector7(1)+endefectr(1)],[endefectr(2),rotationVector7(2)+endefectr(2)],[endefectr(3),rotationVector7(3)+endefectr(3)],'Color','b');
    line([endefectr(1),rotationVector8(1)+endefectr(1)],[endefectr(2),rotationVector8(2)+endefectr(2)],[endefectr(3),rotationVector8(3)+endefectr(3)],'Color','b');
    axis equal;  
    
%% Determine the point of intersection for a ray cast at the corners of
%% image
counter = 1;
    for i=1:size(blastpoint,2) 
        for j=1:size(meshnormals',2)
            [pntInt_temp]=plane_line_intersect(meshnormals(j,:),verts(faces(j,1),:),endefectr,blastpoint(i).vector);
            if ~isempty(find(pntInt_temp==inf,1))
                continue
            end
            Dis_endef_pntint= sqrt((endefectr(1) - pntInt_temp(1))^2+(endefectr(2) - pntInt_temp(2))^2+(endefectr(3) - pntInt_temp(3))^2);
            Dis_blast_pntint= sqrt((blastpoint(i).vector(1) - pntInt_temp(1))^2+(blastpoint(i).vector(2) - pntInt_temp(2))^2+(blastpoint(i).vector(3) - pntInt_temp(3))^2);
            if Dis_blast_pntint< De %If it's less than the laser scanner range
                %check if point of intersection is inside triangle                
                if PointInQuad(pntInt_temp, [verts(faces(j,1),:);verts(faces(j,2),:);verts(faces(j,3),:)])
                    %check if point of intersection is between end effector and blast point
                    if Dis_endef_pntint< De && Dis_blast_pntint< De
                        if Dis_endef_pntint<currMin
                            pntInt(counter).vector=pntInt_temp;
                            distance(counter)= pointToPointDistance(pntInt_temp,endefectr);
                            counter = counter + 1;
                            %x = [verts(faces(j,1),1),verts(faces(j,2),1),verts(faces(j,3),1)];
                            %y = [verts(faces(j,1),2),verts(faces(j,2),2),verts(faces(j,3),2)];
                            %z = [verts(faces(j,1),3),verts(faces(j,2),3),verts(faces(j,3),3)];
                            %tcolor = [.7 .7 .7];
                            %patch(x,y,z,tcolor);
                            break;
                        end
                    end
                end
            end
        end
    end
%% Calculate the scouting ray with the max distance from the end effector
%Determine the mesh points that falls within the frame of the image    
    dir_vec=max(distance)*(bear);
    rotationVector1 = rot_vec(dir_vec,pan_rotate_vec,deg2rad(21.8)); %horizontal scout ray
    rotationVector2 = rot_vec(dir_vec,pan_rotate_vec,deg2rad(-21.8)); % horizontal scout ray
    rotationVector3 = rot_vec(dir_vec,tilt_rotate_vec,deg2rad(16.7)); % vertical scout ray
    rotationVector4 = rot_vec(dir_vec,tilt_rotate_vec,deg2rad(-16.7)); % vertical scout ray
    rotationVector5 = rot_vec(rotationVector1,tilt_rotate_vec,deg2rad(16.7)); %Image corner ray
    rotationVector6 = rot_vec(rotationVector2,tilt_rotate_vec,deg2rad(16.7)); %Image corner ray
    rotationVector7 = rot_vec(rotationVector1,tilt_rotate_vec,deg2rad(-16.7)); %Image corner ray
    rotationVector8 = rot_vec(rotationVector2,tilt_rotate_vec,deg2rad(-16.7)); %Image corner ray
    line([endefectr(1),rotationVector1(1)+endefectr(1)],[endefectr(2),rotationVector1(2)+endefectr(2)],[endefectr(3),rotationVector1(3)+endefectr(3)],'Color','r');
    line([endefectr(1),rotationVector2(1)+endefectr(1)],[endefectr(2),rotationVector2(2)+endefectr(2)],[endefectr(3),rotationVector2(3)+endefectr(3)],'Color','r');
    line([endefectr(1),rotationVector3(1)+endefectr(1)],[endefectr(2),rotationVector3(2)+endefectr(2)],[endefectr(3),rotationVector3(3)+endefectr(3)],'Color','r');
    line([endefectr(1),rotationVector4(1)+endefectr(1)],[endefectr(2),rotationVector4(2)+endefectr(2)],[endefectr(3),rotationVector4(3)+endefectr(3)],'Color','r');
    line([endefectr(1),rotationVector5(1)+endefectr(1)],[endefectr(2),rotationVector5(2)+endefectr(2)],[endefectr(3),rotationVector5(3)+endefectr(3)],'Color','b');
    line([endefectr(1),rotationVector6(1)+endefectr(1)],[endefectr(2),rotationVector6(2)+endefectr(2)],[endefectr(3),rotationVector6(3)+endefectr(3)],'Color','b');
    line([endefectr(1),rotationVector7(1)+endefectr(1)],[endefectr(2),rotationVector7(2)+endefectr(2)],[endefectr(3),rotationVector7(3)+endefectr(3)],'Color','b');
    line([endefectr(1),rotationVector8(1)+endefectr(1)],[endefectr(2),rotationVector8(2)+endefectr(2)],[endefectr(3),rotationVector8(3)+endefectr(3)],'Color','b');
    x1 =[rotationVector5(1)+endefectr(1),rotationVector6(1)+endefectr(1),rotationVector7(1)+endefectr(1)];
    y1 =[rotationVector5(2)+endefectr(2),rotationVector6(2)+endefectr(2),rotationVector7(2)+endefectr(2)];
    z1 =[rotationVector5(3)+endefectr(3),rotationVector6(3)+endefectr(3),rotationVector7(3)+endefectr(3)];    
    tcolor = [.2 .7 .2];
    patch(x1,y1,z1,tcolor);
    x2 =[rotationVector6(1)+endefectr(1),rotationVector8(1)+endefectr(1),rotationVector7(1)+endefectr(1)];
    y2 =[rotationVector6(2)+endefectr(2),rotationVector8(2)+endefectr(2),rotationVector7(2)+endefectr(2)];
    z2 =[rotationVector6(3)+endefectr(3),rotationVector8(3)+endefectr(3),rotationVector7(3)+endefectr(3)];
    tcolor = [.2 .7 .2];
    patch(x2,y2,z2,tcolor); 
%% Find the verts that are within the image plane 

    counter = 1; 
    midpoint=[max(distance)/2*(bear)]+endefectr; %%This is the midpoint of the centre ray
    coeffsPlane1=pointsToPlane(endefectr,rotationVector5+endefectr,rotationVector6+endefectr); %These are the side boundaries
    coeffsPlane2=pointsToPlane(endefectr,rotationVector6+endefectr,rotationVector8+endefectr);
    coeffsPlane3=pointsToPlane(endefectr,rotationVector7+endefectr,rotationVector8+endefectr);
    coeffsPlane4=pointsToPlane(endefectr,rotationVector5+endefectr,rotationVector7+endefectr);
%     valuePlane1 = coeffsPlane1.a*midpoint(1)+coeffsPlane1.b*midpoint(2)+coeffsPlane1.c*midpoint(3)+coeffsPlane1.d; %+ve %These will always be the cause, the structure of the shape doesn't change
%     valuePlane2 = coeffsPlane2.a*midpoint(1)+coeffsPlane2.b*midpoint(2)+coeffsPlane2.c*midpoint(3)+coeffsPlane2.d; %+ve
%     valuePlane3 = coeffsPlane3.a*midpoint(1)+coeffsPlane3.b*midpoint(2)+coeffsPlane3.c*midpoint(3)+coeffsPlane3.d; %-ve
%     valuePlane4 = coeffsPlane4.a*midpoint(1)+coeffsPlane4.b*midpoint(2)+coeffsPlane4.c*midpoint(3)+coeffsPlane4.d; %-ve 
        for i=1:size(verts,1)
            [pntInt_temp]=plane_line_intersect(bear,rotationVector1+endefectr,endefectr,verts(i,:));       
            
            %plot3(pntInt_temp(1),pntInt_temp(2),pntInt_temp(3),'ro');       
            if ~isempty(find(pntInt_temp==inf,1))
                continue
            end
            %check if point of intersection is inside rectangle, by doing
            %double triangle check
            if coeffsPlane1.a*verts(i,1)+coeffsPlane1.b*verts(i,2)+coeffsPlane1.c*verts(i,3)+coeffsPlane1.d >= 0
                if coeffsPlane2.a*verts(i,1)+coeffsPlane2.b*verts(i,2)+coeffsPlane2.c*verts(i,3)+coeffsPlane2.d >= 0
                    if coeffsPlane3.a*verts(i,1)+coeffsPlane3.b*verts(i,2)+coeffsPlane3.c*verts(i,3)+coeffsPlane3.d <= 0
                        if coeffsPlane4.a*verts(i,1)+coeffsPlane4.b*verts(i,2)+coeffsPlane4.c*verts(i,3)+coeffsPlane4.d <= 0
                            if PointInQuad(pntInt_temp, [rotationVector5+endefectr;rotationVector6+endefectr;rotationVector7+endefectr]) %If it's within the image plane                
                                relevantVerts(counter,1) = i;
                                vertsOnImagePlane(counter,:) = pntInt_temp;
                                counter = counter + 1;
                            end         
                            if PointInQuad(pntInt_temp, [rotationVector6+endefectr;rotationVector7+endefectr;rotationVector8+endefectr]) %If it's within the image plane
                                relevantVerts(counter,1) = i;
                                vertsOnImagePlane(counter,:) = pntInt_temp;
                                counter = counter + 1;
                            end
                        end
                    end
                end
            end
        end      
    %hold on;    
    %plot3(rotationVector5(1)+endefectr(1),rotationVector5(2)+endefectr(2),rotationVector5(3)+endefectr(3),'bo');
    %plot3(rotationVector6(1)+endefectr(1),rotationVector6(2)+endefectr(2),rotationVector6(3)+endefectr(3),'bo');
    %plot3(midpoint(1),midpoint(2),midpoint(3),'ro');
    
        
%% Find the faces that exists in the image frame base on the verts list
    counter = 1;
    for i=1:size(faces,1)
        if find(relevantVerts == faces(i,1)) > 0
            if find(relevantVerts == faces(i,2)) > 0
                if find(relevantVerts == faces(i,3)) > 0
                    relevantFaces(counter) = i;
                    counter = counter + 1;
                end
            end
        end            
    end     
    figure;
    plot(a.r,image_dat(curr_im).robot_pose,'axis',axisH); 
    camlight;
    hold on;      
    line([endefectr(1),rotationVector5(1)+endefectr(1)],[endefectr(2),rotationVector5(2)+endefectr(2)],[endefectr(3),rotationVector5(3)+endefectr(3)],'Color','b');
    line([endefectr(1),rotationVector6(1)+endefectr(1)],[endefectr(2),rotationVector6(2)+endefectr(2)],[endefectr(3),rotationVector6(3)+endefectr(3)],'Color','b');
    line([endefectr(1),rotationVector7(1)+endefectr(1)],[endefectr(2),rotationVector7(2)+endefectr(2)],[endefectr(3),rotationVector7(3)+endefectr(3)],'Color','b');
    line([endefectr(1),rotationVector8(1)+endefectr(1)],[endefectr(2),rotationVector8(2)+endefectr(2)],[endefectr(3),rotationVector8(3)+endefectr(3)],'Color','b');
    line([endefectr(1),dir_vec(1)+endefectr(1)],[endefectr(2),dir_vec(2)+endefectr(2)],[endefectr(3),dir_vec(3)+endefectr(3)],'Color','r'); 
    trisurf(faces(relevantFaces(:),:), verts(:,1), verts(:,2), verts(:,3), 'FaceColor', 'None');
    x1 =[rotationVector5(1)+endefectr(1),rotationVector6(1)+endefectr(1),rotationVector7(1)+endefectr(1)];
    y1 =[rotationVector5(2)+endefectr(2),rotationVector6(2)+endefectr(2),rotationVector7(2)+endefectr(2)];
    z1 =[rotationVector5(3)+endefectr(3),rotationVector6(3)+endefectr(3),rotationVector7(3)+endefectr(3)];    
    tcolor = [.2 .7 .2];
    patch(x1,y1,z1,tcolor);
    x2 =[rotationVector6(1)+endefectr(1),rotationVector8(1)+endefectr(1),rotationVector7(1)+endefectr(1)];
    y2 =[rotationVector6(2)+endefectr(2),rotationVector8(2)+endefectr(2),rotationVector7(2)+endefectr(2)];
    z2 =[rotationVector6(3)+endefectr(3),rotationVector8(3)+endefectr(3),rotationVector7(3)+endefectr(3)];
    tcolor = [.2 .7 .2];
    patch(x2,y2,z2,tcolor);
    plot3(vertsOnImagePlane(:,1),vertsOnImagePlane(:,2),vertsOnImagePlane(:,3));
    axis equal
 


%% Relate the verts On Image Plane to an actual RGB value
    distancePerPixelHeight = pointToPointDistance(rotationVector6+endefectr,rotationVector8+endefectr)/image_dat(curr_im).size(1,1); %Height
    distancePerPixelWidth = pointToPointDistance(rotationVector7+endefectr,rotationVector8+endefectr)/image_dat(curr_im).size(1,2); %Width
%     for i=1:size(vertsOnImagePlane,1)        
%         heightDist = pointToLine(vertsOnImagePlane(i,:),rotationVector7+endefectr,rotationVector8+endefectr);
%         widthDist = pointToLine(vertsOnImagePlane(i,:),rotationVector6+endefectr,rotationVector8+endefectr);
%         vertRGBValue(i,:) = image_dat(curr_im).pixels(round(heightDist/distancePerPixelHeight),round(widthDist/distancePerPixelWidth),:);
%     end
%% Patch the mesh with the RGB value 
% figure;
%     for i =1:size(relevantFaces,2)
%         %Find the average RGB values of the verts of interest for a face
%         vert1 = verts(faces(relevantFaces(i),1),:);
%         vert2 = verts(faces(relevantFaces(i),2),:);
%         vert3 = verts(faces(relevantFaces(i),3),:);
%         %Trace the index that is relevant to the vertRGBValue matrix
%         index1 = find(relevantVerts == faces(relevantFaces(i),1));
%         index2 = find(relevantVerts == faces(relevantFaces(i),2));
%         index3 = find(relevantVerts == faces(relevantFaces(i),3));    
%         vert1RGB = vertRGBValue(index1,:);
%         vert2RGB = vertRGBValue(index2,:);
%         vert3RGB = vertRGBValue(index3,:);
%         averageR = mean([vert1RGB(1),vert2RGB(1),vert3RGB(1)]);
%         averageG = mean([vert1RGB(2),vert2RGB(2),vert3RGB(2)]);
%         averageB = mean([vert1RGB(3),vert2RGB(3),vert3RGB(3)]);        
%         hold on;
%         patch([vert1(1),vert2(1),vert3(1)],[vert1(2),vert2(2),vert3(2)],[vert1(3),vert2(3),vert3(3)],[averageR/255,averageG/255,averageB/255],'Linestyle','none');
%     end
   

%%Generate a text file that contains XYZ coordinates and UV for image
%%coordinates. Additional have a text file for the normal to the triangle.
% open the file with write permission

    fid = fopen(['world',int2str(curr_im),'.txt'], 'wt');
    %fid2 = fopen('normals.txt', 'wt');
    fprintf(fid,'NUMPOLLIES %10f \n\n',size(relevantFaces,2));
    height = pointToPointDistance(rotationVector6+endefectr,rotationVector8+endefectr); %Height
    width = pointToPointDistance(rotationVector7+endefectr,rotationVector8+endefectr); %Width
    %figure
    for i = 1:size(relevantFaces,2)
        %for i = 1:2
        vert1 = verts(faces(relevantFaces(i),1),:);
        vert2 = verts(faces(relevantFaces(i),2),:);
        vert3 = verts(faces(relevantFaces(i),3),:);
        normal = meshnormals(relevantFaces(i),:);
        index1 = find(relevantVerts == faces(relevantFaces(i),1));
        index2 = find(relevantVerts == faces(relevantFaces(i),2));
        index3 = find(relevantVerts == faces(relevantFaces(i),3));
        imageCoordinate1(1) = pointToLine(vertsOnImagePlane(index1,:),rotationVector7+endefectr,rotationVector8+endefectr)/height;
        imageCoordinate1(2) = pointToLine(vertsOnImagePlane(index1,:),rotationVector6+endefectr,rotationVector8+endefectr)/width; %0 to 1
        fprintf(fid,'%6.4f %6.4f %6.4f ',vert1);
        fprintf(fid,'%6.4f %6.4f \n', imageCoordinate1);
        imageCoordinate2(1) = pointToLine(vertsOnImagePlane(index2,:),rotationVector7+endefectr,rotationVector8+endefectr)/height;
        imageCoordinate2(2) = pointToLine(vertsOnImagePlane(index2,:),rotationVector6+endefectr,rotationVector8+endefectr)/width; %0 to 1
        fprintf(fid,'%6.4f %6.4f %6.4f ',vert2);
        fprintf(fid,'%6.4f %6.4f \n', imageCoordinate2);
        imageCoordinate3(1) = pointToLine(vertsOnImagePlane(index3,:),rotationVector7+endefectr,rotationVector8+endefectr)/height;
        imageCoordinate3(2) = pointToLine(vertsOnImagePlane(index3,:),rotationVector6+endefectr,rotationVector8+endefectr)/width; %0 to 1
        fprintf(fid,'%6.4f %6.4f %6.4f ',vert3);
        fprintf(fid,'%6.4f %6.4f \n', imageCoordinate3);
        %fprintf(fid2,'%12.9f %12.9f %12.9f ',normal);
        %tcolor = [.2 .7 .2];
        %hold on
        %patch([vert1(1),vert2(1),vert3(1)],[vert1(2),vert2(2),vert3(2)],[vert1(3),vert2(3),vert3(3)],tcolor);
    end
    fclose(fid);
    keyboard
    %fclose(fid2);
 end


