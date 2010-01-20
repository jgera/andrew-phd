%Calculates the distance between 2 points in 3d space
function distance = pointToPointDistance(point1, point2)
distance = sqrt((point1(1)-point2(1))^2+(point1(2)-point2(2))^2+(point1(3)-point2(3))^2);

