function coeffs=pointsToPlane(P1,P2,P3)
normal = cross(P1-P2, P1-P3);
coeffs.a = normal(1);
coeffs.b = normal(2);
coeffs.c = normal(3);
coeffs.d = -(normal(1)*P1(1)+normal(2)*P1(2)+normal(3)*P1(3));

