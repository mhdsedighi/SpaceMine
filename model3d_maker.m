% clear
% close all
clc

% length_real=9*0.2617;

% length_real=5.4938;

length_real=10/0.97532;


addpath('geom3d/geom3d')
addpath('geom3d/meshes3d')
addpath('3dmodels')
addpath('polyhedron')

obj = readObj('10464_Asteroid_v1_Iterations-2.obj');


x=obj.v(:,1);
y=obj.v(:,2);
z=obj.v(:,3);
Np=length(x);


F=obj.f.v;



% % % % xc=(max(x)+min(x))/2;
% % % % yc=(max(y)+min(y))/2;
% % % zc=(max(z)+min(z))/2;
% % % 
% % % [~,inx_pole]=max(z);
% % % xc=x(inx_pole);
% % % yc=y(inx_pole);

[~,rc,~,~]=polhedrn(x,y,z,F);


x=x-rc(1);
y=y-rc(2);
z=z-rc(3);

scale=length_real/(max(x)-min(x));

x=x*scale;
y=y*scale;
z=z*scale;







% 
% [AZI,ELE] = meshgrid(linspace(0,360,20),linspace(-90,90,20));
% 
% [m,n]=size(AZI);
% 
% pos_x=zeros(m,n);
% pos_y=zeros(m,n);
% pos_z=zeros(m,n);
% UP_vec_x=zeros(m,n);
% UP_vec_y=zeros(m,n);
% UP_vec_z=zeros(m,n);
% North_vec_x=zeros(m,n);
% North_vec_y=zeros(m,n);
% North_vec_z=zeros(m,n);
% 
% figure
% hold on
% axis equal
% 
% 
% for i=1:m
%     for j=1:n
%         
%         lambda=AZI(i,j);
%         phi=ELE(i,j);
%         
%         [pos,UP_vec,North_vec,Right_vec]=ellip_shape_3d(V,F,lambda,phi);
%         %
%         %         pos_x
%         %         pos_y
%         %         pos_z
%         
%         pos_x(i,j)=pos(1);
%         pos_y(i,j)=pos(2);
%         pos_z(i,j)=pos(3);
%         UP_vec_x(i,j)=UP_vec(1);
%         UP_vec_y(i,j)=UP_vec(2);
%         UP_vec_z(i,j)=UP_vec(3);
%         North_vec_x(i,j)=North_vec(1);
%         North_vec_y(i,j)=North_vec(2);
%         North_vec_z(i,j)=North_vec(3);
%         
%         
%         plot3(pos_x(i,j),pos_y(i,j),pos_z(i,j),'k.');
%         
%         
%     end
% end
% shape.AZI=AZI;
% shape.ELE=ELE;
% shape.pos_x=pos_x;
% shape.pos_y=pos_y;
% shape.pos_z=pos_z;
% shape.UP_vec_x=UP_vec_x;
% shape.UP_vec_y=UP_vec_y;
% shape.UP_vec_z=UP_vec_z;
% shape.North_vec_x=North_vec_x;
% shape.North_vec_y=North_vec_y;
% shape.North_vec_z=North_vec_z;
% %%%
% test
% Vq = interp2(AZI,ELE,pos_x,0,0)


[v,rc,vrr,irr]=polhedrn(x,y,z,F);

V=[x y z];
shape.V=V;
shape.F=F;
shape.volume=v;
shape.MomentTensor=irr;

% 169581/shape.volume*rho
shape.volume*1270

save shape shape
