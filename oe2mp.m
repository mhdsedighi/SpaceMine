function mp=oe2mp(oe)

mp=oe;

% a = oe(1);
e = oe(2);
inc = oe(3);
omega = oe(4);
OMEGA = oe(5);
theta = oe(6);



angelaan=omega+OMEGA;
tan_i_2=tan(inc/2);

ep1=e*sin(angelaan);
ep2=e*cos(angelaan);
zig1=tan_i_2*sin(OMEGA);
zig2=tan_i_2*cos(OMEGA);
lambda=theta+omega+OMEGA;

% mp(1)=a;
mp(2)=ep1;
mp(3)=ep2;
mp(4)=zig1;
mp(5)=zig2;
mp(6)=lambda;


end