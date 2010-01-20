%Calculate the distance between a point and a line x1 and x2 form the line
function d = pointToLine(P,Q1,Q2) %
d = norm(cross(Q2-Q1,P-Q1))/norm(Q2-Q1);
%d = abs(cross(Q2-Q1,P-Q1))/abs(Q2-Q1);
% keyboard
% a = x2-x1;
% b = x1-x0;
% c = x2-x1;
% numerator = abs(cross(a,b));
% denominator = abs(c);
% keyboard
% d = (numerator(1)^2)+numerator(2)^2/denominator;
%d = abs(cross((p0-p1),(p0-p2)))/abs(p2-p1);