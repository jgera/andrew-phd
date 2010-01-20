% function [I,check]=plane_line_intersect(n,V0,P0,P1)
function [I]=plane_line_intersect(n,V0,P0,P1) %n = normal of the plane, V0 = point on the plane, P0 = ray point 1, P = ray point 2
%gavin changed
I=[inf inf inf];
u = P1-P0;
w = P0 - V0;
% D2 = dot(n,u);
% D1=sum(n.*u);
D=n(1)*u(1)+n(2)*u(2)+n(3)*u(3);
% if (D~=D1||D~=D2)
%     keyboard
% end

% N = -dot(n,w);
N=-(n(1)*w(1)+n(2)*w(2)+n(3)*w(3));

% check=0;
if abs(D) < 10^-6        % The segment is parallel to plane
    return
%         if N == 0           % The segment lies in plane
%             check=2;
%             return
%         else
%             check=0;       %no intersection
%             return
%         end
end

%compute the intersection parameter
sI = N / D;
I = P0+ sI.*u;

% if (sI < 0 || sI > 1)
%     check= 3;          %The intersection point  lies outside the segment, so there is no intersection
% else
%     check=1;
% end
% 
% 
% 
