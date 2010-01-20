%This is a simple code that generates the coordinate points that moves
%around a circle to provide viewing angle change. You provide the (x,y) position
%of the camera facing the surface at 100mm away
%y axis -ve to +ve is up to down
%x axis -ve to +ve is 
function viewingAngle(x,y)
baseX = x;
baseY = y-100; 

point285x = baseX + 100*cos(deg2rad(285))
point285y = baseY - 100*sin(deg2rad(285))

point300x = baseX + 100*cos(deg2rad(300))
point300y = baseY - 100*sin(deg2rad(300))

point315x = baseX + 100*cos(deg2rad(315))
point315y = baseY - 100*sin(deg2rad(315))

point330x = baseX + 100*cos(deg2rad(330))
point330y = baseY - 100*sin(deg2rad(330))
hold on;
plot(baseX, baseY,'ro');
plot(x,y,'o');
plot(point285x,point285y,'o');
plot(point300x,point300y,'o');
plot(point315x,point315y,'o');
plot(point330x,point330y,'o');
