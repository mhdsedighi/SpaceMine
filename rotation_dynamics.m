function dx = rotation_dynamics(x,u,params)

% L M N p q r Ixx Iyy Izz Ixy Ixz Iyz


Ixx=5000;
Iyy=1000;
Izz=3000;
Ixy=100;
Ixz=100;
Iyz=100;

vec1=[0;0.7071;0.7071];
vec2=[0.7071;0.7071;0];
vec3=[0.7071;0.7071;0];

T1=u(1,:);
T2=u(2,:);
T3=u(3,:);


L=T1.*vec1(1)+T2.*vec2(1)+T3.*vec3(1);
M=T1.*vec1(2)+T2.*vec2(2)+T3.*vec3(2);
N=T1.*vec1(3)+T2.*vec2(3)+T3.*vec3(3);


p=x(1,:);
q=x(2,:);
r=x(3,:);



% u_dot=F_x./m+r.*v-q.*w;
% v_dot=F_y./m-r.*u+p.*w;
% w_dot=F_z./m+q.*u-p.*v;



term1=Izz.*Ixy.^2 + 2.*Ixy.*Ixz.*Iyz + Iyy.*Ixz.^2 + Ixx.*Iyz.^2 - Ixx.*Iyy.*Izz;
term2=L + p.*(Ixz.*q - Ixy.*r) + q.*(Iyz.*q + Iyy.*r) - r.*(Izz.*q + Iyz.*r);
term3=M - p.*(Ixz.*p + Ixx.*r) - q.*(Iyz.*p - Ixy.*r) + r.*(Izz.*p + Ixz.*r);
term4=N + p.*(Ixy.*p + Ixx.*q) - q.*(Iyy.*p + Ixy.*q) + r.*(Iyz.*p - Ixz.*q);
term5=Ixz.*Iyz + Ixy.*Izz;
term6=Ixy.*Iyz + Ixz.*Iyy;
term7=Ixy.*Ixz + Ixx.*Iyz;

p_dot=(Iyz.^2-Iyy.*Izz.*term2-term6.*term4-term5.*term3)./term1;
q_dot=(Ixz.^2-Ixx.*Izz.*term3-term7.*term4-term5.*term2)./term1;
r_dot=(Ixy.^2-Ixx.*Iyy.*term4-term6.*term3-term6.*term2)./term1;



dx(1,:)=p_dot;
dx(2,:)=q_dot;
dx(3,:)=r_dot;

end