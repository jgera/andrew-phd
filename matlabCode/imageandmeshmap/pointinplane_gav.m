function imageonsurf()
% system('F:\Program Files\MATLAB\R2007a\work\EyeinHand>EyeInHand.exe /regserver')
global hMesh
% clear global hMesh
pause_rate=0;

% hMesh=[];

if isempty(hMesh)
    h = actxserver('EyeInHand.SurfaceMap');
    directory=pwd;

    %needs to be in front of wehn surface is added
    h.Resolution=0.1;
    
    h.SurfaceFusionDistance = 0.1;
    h.SurfaceDeviation = 0.05;
    
%     aabbExtent = [-10, -10, -10; 3, 10, 10];
%     aabbExtent = [-2, -1, 0; 2, 1, 3];
%     h.Extent = aabbExtent;

%     h.AddSurfaceMap([directory,'\','test2.ply']);
    % h.AddRangeGrid([directory,'\','bunny.ply']);
    h.AddRangeGrid([directory,'\','grid_1.ply']);

    

    %shold do this too
    % h.Optimise;
%     aabb.lower = [-10, -10, -10];
%     aabb.upper = [10, 10, 10];
    aabb.lower = [-2, -1, 0];
    aabb.upper = [2, 1, 3];

    hMesh = h.SurfacesInsideBox(aabb.lower, aabb.upper);
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

% keyboard
%            
% %Triangle #1
% Pnt1 = [1 -1 -1];Pnt2 = [2 2 3];Pnt3 = [2 2 0];
% %Triangle #2
% Pnt1a = [0 1.5 1];Pnt2a = [2 2 3];Pnt3a = [2 2 0];
% %Triangle #3
% Pnt1b = [1.5 1.5 2];Pnt2b = [1.75 0.5 2];Pnt3b = [0 1.5 1.5];
% 
% pause_rate = 0.1;
% %determine all normals
% meshnormals = [cross(Pnt1-Pnt2, Pnt1-Pnt3);...
%                cross(Pnt1a-Pnt2a, Pnt1a-Pnt3a);...
%                cross(Pnt1b-Pnt2b, Pnt1b-Pnt3b)];
% For plotting
xlabel('x');
ylabel('y');
camlight;
axis equal           

% triangle 1,2,3
% verts = [Pnt1;Pnt2;Pnt3; Pnt1a;Pnt2a;Pnt3a; Pnt1b;Pnt2b;Pnt3b];
%faces (which vertices to link)
% faces = [1 2 3;4,5,6;7,8,9];
%face color in RGB
% tcolor = [1 1 1;1,1,1;1,1,1];
% patch('Faces',faces,'Vertices',verts,'FaceVertexCData',tcolor,'FaceColor','flat');
patch('Faces',faces,'Vertices',verts);

hold on;



%% Start and end poses (you need to use 7 joints with the new robot)
% startQ=[18.8593  151.4173   16.1927    3.2566  -57.8998 0,0];
% midQ1=[44.8941   91.4173   15.6529   -2.5330  -39.9189 0,0];
% midQ2= [63.3475   72.1016   12.7140   -4.6554  -12.8295 0,0];
% endQ = [65.6547   57.6991   45  -6.7510 -116.1888         0,0];

startQ=[0  -90   90    0  -100 0,0];
endQ=[0  -90   90    0  100 0,0];
% midQ1=[44.8941   91.4173   15.6529   -2.5330  -39.9189 0,0];
% midQ2= [63.3475   72.1016   12.7140   -4.6554  -12.8295 0,0];
% endQ = [65.6547   57.6991   45  -6.7510 -116.1888         0,0];

%% Make increments between start and finish poses
% first run increments
[all_steps,row_of_all_steps]=onedegree_inc_movement(startQ,endQ);
% % second run  increments
% [all_steps_Sec,row_of_all_steps_sec]=onedegree_inc_movement(midQ1,midQ2);
% % Third run  increments
% [all_steps_thir,row_of_all_steps_thir]=onedegree_inc_movement(midQ2,endQ);
% % add all steps together
% all_steps=[all_steps;all_steps_Sec;all_steps_thir];
% row_of_all_steps=row_of_all_steps+row_of_all_steps_sec+row_of_all_steps_thir;

%% Plotting first run
for i = 1:row_of_all_steps 
    data= deg2rad(all_steps(i,:)) ;   % : means all the colouumn values
    tr= fkine(r, data );                               
    endefectr= tr(1:3,4)';   % the point of end effector 
    blastpoint=endefectr+tr(1:3,3)';  
    
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
                            (verts(faces(:,1),3)-blastpoint(3)).^2)<1);
    if isempty(faces_of_interest)
        %plot robot on current axis
        axisH=gcf;
        plot(r,data,'axis',axisH);
        pause (pause_rate);
        continue
    end
%     ,verts(faces(:,2),:),verts(faces(:,3),:)
%     find(blastpoint
    
% profile clear; profile on;
%     for j=1:size(faces,1)
    for j=faces_of_interest'
        [pntInt_temp]=plane_line_intersect(meshnormals(j,:),verts(faces(j,1),:),endefectr,blastpoint);        
        if ~isempty(find(pntInt_temp==inf,1))
            continue
        end
        Dis_endef_pntint= sqrt((endefectr(1) - pntInt_temp(1))^2+(endefectr(2) - pntInt_temp(2))^2+(endefectr(3) - pntInt_temp(3))^2);
        Dis_blast_pntint= sqrt((blastpoint(1) - pntInt_temp(1))^2+(blastpoint(2) - pntInt_temp(2))^2+(blastpoint(3) - pntInt_temp(3))^2);    
        
        %check if point of intersection is inside triange    
        if PointInQuad(pntInt_temp, [verts(faces(j,1),:);verts(faces(j,2),:);verts(faces(j,3),:)])
            %check if point of intersection is between end effector and blast point
            if Dis_endef_pntint< De && Dis_blast_pntint< De
                if Dis_endef_pntint<currMin
                    pntInt=pntInt_temp;
                end
            % if is on the correct side and a little bit too far
            elseif Dis_blast_pntint< De
                if Dis_endef_pntint<currMin_disttoofar
                    pntInt_disttoofar=pntInt_temp;
                end
            end
        end
    end
%     profile off;
%     profile viewer;
%     keyboard;

    %check if we have a valid point of intersection with a triangle
    if ~isempty(pntInt) || ~isempty(pntInt_disttoofar)
        hold on;
        %check if point of intersection is between end effector and blast point
        if ~isempty(pntInt)
            plot3(pntInt(1),pntInt(2),pntInt(3),'b.'); % the plane intersection
            greenline=plot3([pntInt(1),endefectr(1)],[pntInt(2),endefectr(2)],[pntInt(3),endefectr(3)],'b'); % the line form projection to the point on plane
            pause(pause_rate)
            delete(greenline)
        elseif ~isempty(pntInt_disttoofar)
            plot3(blastpoint(1),blastpoint(2),blastpoint(3),'r.'); %projection from the end effector
            plot3(pntInt_disttoofar(1),pntInt_disttoofar(2),pntInt_disttoofar(3),'g*');
            redline = plot3([tr(1,4),blastpoint(1)],[tr(2,4),blastpoint(2)],[tr(3,4),blastpoint(3)],'r');  % the line from end effector to the projecttion
            pause(pause_rate)
            delete(redline)
        end
    else
        plot3(blastpoint(1),blastpoint(2),blastpoint(3),'y*');
    end
    hold on;

    %plot robot on current axis
    axisH=gcf;
    plot(r,data,'axis',axisH);
    pause (pause_rate);

 
    %% Pose selection
   % a=tr(1,3); 
    %b=tr(2,3); 
    %c=tr(3,3);
    %d=-a*blastpoint(1)-b*blastpoint(2)-c*blastpoint(3);
    %planeEqu=[a,b,c,d]; 

    %qnew=blasting_posesel(blastpoint, planeEqu, deg2rad(midQ1));  

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