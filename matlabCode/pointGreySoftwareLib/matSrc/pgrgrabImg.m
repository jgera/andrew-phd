% pgrgrabImage 
%   example matlab program that will grab and display images from a pgr
%   color firewire camera
%

camnum=matGetFlyCount;
fprintf( 1, 'Found %d cameras. ', camnum );

for i=1:camnum,
    context(i)=matInitFly(i);
end
keyboard
fprintf( 1, '\n' );
 for i=1:100,
     fprintf( 1, 'Grabing frame %d : ', i );
     for j=1:camnum
        fprintf( 1, 'cam%d ... ', j );
        grabbedImage=matGrabFlyImg(context(j));
        grabbedImage=reshape(grabbedImage,3,[]);
        
        % reshape the grabbed image so that we can display it as a color
        % image
        Im{j,i}=zeros( 480, 640, 3 );
        Im{j,i}(:,:,1)=reshape(grabbedImage(3,:),640,[])';
        Im{j,i}(:,:,2)=reshape(grabbedImage(2,:),640,[])';
        Im{j,i}(:,:,3)=reshape(grabbedImage(1,:),640,[])';
        Im{j,i} = Im{j,i} / 256;
    end
    
    
     %display images
     fprintf( 1, 'display ... ' );
     for j=1:camnum
        fprintf( 1, 'cam%d ... ', j );
        figure(j);
        image( Im{j,i} );
     end
     
     % delay between grabs
     fprintf( 1, 'pause ... ' );
     
     if i==5
%         % extra long delay (1 min) just on frame 5
%         pause(60.0);
        % slightly longer delay on frame 5
        pause(0.5);
     else
        % otherwise a short delay (0.1 sec) will do
        pause(0.1);
     end
     
     fprintf( 1, 'done\n' );
 end
 
 for j=1:camnum
     matStopFly(context(j));
 end
 
 fprintf( 1, '\nProgram terminated.\n' );

 
 