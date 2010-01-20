% Check if point lies within plane boundaries
% Ref: http://www.blackpawn.com/texts/pointinpoly/default.html

function test_plane=PointInQuad(Pint,obs)
%% this is slightly faster
test_plane=0;
if sameSide(Pint,obs(3,:,:),obs(1,:,:),obs(2,:,:))
    if sameSide(Pint,obs(1,:,:),obs(2,:,:),obs(3,:,:)) 
        if sameSide(Pint,obs(2,:,:),obs(3,:,:),obs(1,:,:)) 
            test_plane=1;
            %means that it is inside the triangle
        end
    end
end


% sameSide
% ========
function Pin=sameSide(p1,p2,a,b)
%% Do this code instead
BminusA=[b-a]';
P1minusA=[p1-a]';
%this is the formula for cross product
cp1 =[BminusA(2,:).*P1minusA(3,:)-BminusA(3,:).*P1minusA(2,:),...
      BminusA(3,:).*P1minusA(1,:)-BminusA(1,:).*P1minusA(3,:),...
      BminusA(1,:).*P1minusA(2,:)-BminusA(2,:).*P1minusA(1,:)];
 

P2minusA=[p2-a]';
cp2 =[BminusA(2,:).*P2minusA(3,:)-BminusA(3,:).*P2minusA(2,:),
      BminusA(3,:).*P2minusA(1,:)-BminusA(1,:).*P2minusA(3,:),
      BminusA(1,:).*P2minusA(2,:)-BminusA(2,:).*P2minusA(1,:)];
%this is quicker than dot product  
if sum(cp1'.*cp2)>=0
    Pin=1;
else
    Pin=0;
end