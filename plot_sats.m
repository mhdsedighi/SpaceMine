
% % for test
% close all
% N_sat=1
% betas=40
% phis=20
% alphas=-10
% betas=22
% N_sat=25;
% lambdas=rand_gen(1,N_sat,0,360);
% phis=rand_gen(1,N_sat,-90,90);
% alphas=rand_gen(1,N_sat,-45,45);
% betas=rand_gen(1,N_sat,0,360);



% figure
figure('DefaultAxesFontSize',5,'defaultAxesFontName','Euclid','defaultTextFontName','Euclid')
hold on
axis equal
view(25,45)
set(gca, 'XTick', [], 'YTick', [], 'ZTick', [])
set(gca, 'xcolor', 'w', 'ycolor', 'w','zcolor', 'w') ;

load shape


% [x_surf, y_surf, z_surf] = ellipsoid(0,0,0,a,b,c,35);
% surf(x_surf, y_surf,z_surf,'FaceAlpha',0.1,'EdgeColor','none');

% params.shape.V=shape.V;
% params.shape.F=shape.F;

if assume_ellipsoid
    [x_surf, y_surf, z_surf] = ellipsoid(0,0,0,params.a,params.b,params.c,35);
    astplt=surf(x_surf, y_surf,z_surf,'FaceAlpha',0.1,'EdgeColor','none');
else  
    astplt=drawMesh(shape.V, shape.F);
end

astplt.FaceAlpha=0;
astplt.EdgeAlpha=0.09;
astplt.FaceColor=[0.3020 0.1529 0.0235];
astplt.EdgeColor=[0.3020 0.1529 0];
% lighting flat
% material metal
material dull
camlight

plot3(0,0,0,'ko')


sat_pos=zeros(N_sat,3);
UP_vec=zeros(N_sat,3);
North_vec=zeros(N_sat,3);
Right_vec=zeros(N_sat,3);
force_vec=zeros(N_sat,3);

for i=1:N_sat
    
    if assume_ellipsoid
        [sat_pos(i,:),UP_vec(i,:),North_vec(i,:),Right_vec(i,:)]=ellip_shape(params.a,params.b,params.c,lambdas(i),phis(i));     
    else
        [sat_pos(i,:),UP_vec(i,:),North_vec(i,:),Right_vec(i,:)]=ellip_shape_3d(shape.V,shape.F,lambdas(i),phis(i));
    end
    
    
    force_vec(i,:)=sind(alphas(i))*UP_vec(i,:)+cosd(alphas(i))*cosd(betas(i))*North_vec(i,:)+cosd(alphas(i))*sind(betas(i))*Right_vec(i,:);



% h_cone=2;
% plot3(sat_pos(i,1)+h_cone*UP_vec(i,1),sat_pos(i,2)+h_cone*UP_vec(i,2),sat_pos(i,3)+h_cone*UP_vec(i,3),'k*')


% v_tran=cone_plot(sat_pos(i,:),h_cone*vec0,UP_vec(i,:),0,betas(i),1);
% plot_arc1=plot3(v_tran(:,1),v_tran(:,2),v_tran(:,3),'k.');
% 
% v_tran=cone_plot(sat_pos(i,:),h_cone*vec0,UP_vec(i,:),betas(i),360,10);
% plot_arc2=plot3(v_tran(:,1),v_tran(:,2),v_tran(:,3),'k.');
% 
% plot_arc1.MarkerSize=7;
% plot_arc2.MarkerSize=0.02;
% plot_arc2.Color=[0,0, 0.192];
    
end

scale=1*params.a/5;

UP_vec=UP_vec*scale;
North_vec=North_vec*scale;
Right_vec=Right_vec*scale;
force_vec=1.5*force_vec*scale;


plt1=quiver3(sat_pos(:,1),sat_pos(:,2),sat_pos(:,3),North_vec(:,1),North_vec(:,2),North_vec(:,3));
plt2=quiver3(sat_pos(:,1),sat_pos(:,2),sat_pos(:,3),Right_vec(:,1),Right_vec(:,2),Right_vec(:,3));
plt3=quiver3(sat_pos(:,1),sat_pos(:,2),sat_pos(:,3),UP_vec(:,1),UP_vec(:,2),UP_vec(:,3));
plt4=quiver3(sat_pos(:,1),sat_pos(:,2),sat_pos(:,3),force_vec(:,1),force_vec(:,2),force_vec(:,3));

% plt1.Color=[0.6350, 0.0780, 0.1840];
% plt2.Color=[0.4660, 0.6740, 0.1880];
% plt3.Color=[0, 0.4470, 0.7410];
plt1.Color=[0.4940, 0.1840, 0.5560];
plt2.Color=[0.4940, 0.1840, 0.5560];
plt3.Color=[0.4940, 0.1840, 0.5560];
plt4.Color=[0.25, 0.25, 0.25];

% plt1.LineStyle=':';
% plt2.LineStyle=':';
% plt3.LineStyle=':';
plt1.ShowArrowHead=0;
plt2.ShowArrowHead=0;
plt3.ShowArrowHead=0;
plt1.LineWidth=0.5;
plt2.LineWidth=0.5;
plt3.LineWidth=0.5;
plt4.LineWidth=1.3;


plt1.AutoScale=0;
plt2.AutoScale=0;
plt3.AutoScale=0;
plt4.AutoScale=0;


plot_line([0 0 0],[1 0 0],2,'r-','$x_b$',10)
plot_line([0 0 0],[0 1 0],2,'g-','$y_b$',10)
plot_line([0 0 0],[0 0 1],2,'b-','$z_b$',10)


lambdas=lambdas-360*(lambdas-360>0);
phis=phis-360*(phis-360>0);
% alphas=alphas-360*(alphas-360>0);
betas=betas-360*(betas-360>0);

sat_table=[floor([1:N_sat]') round(lambdas',2) round(phis',2) round(alphas',2) round(betas',2)]



for i=1:N_sat
pp1=sat_pos(i,:)+force_vec(i,:)*1.3;

% str1=num2str(i)+newline+num2str(lambdas(i))+newline+num2str(phis(i))+newline+num2str(alphas(i))+newline+num2str(betas(i));
% str1=num2str(i)+","+num2str(lambdas(i),'%.1f')+","+num2str(phis(i),'%.1f')+","+num2str(alphas(i),'%.1f')+","+num2str(betas(i),'%.1f');
str1=num2str(i);
pt1=text(pp1(1),pp1(2),pp1(3),str1);
pt1.FontSize=8;
pt1.Color=[1.0000    0.0745    0.6510];
end



[sat_pos,UP_vec,North_vec,Right_vec]=ellip_shape_3d(params.shape.V,params.shape.F,0,90);
plot3(sat_pos(1),sat_pos(2),sat_pos(3),'b.')
text(sat_pos(1),sat_pos(2),1.1*sat_pos(3),'\uparrow N','FontSize',14,'Color','b');

axis tight

function plot_line(p,dir,d,style,name,font_size)

p2=p+d*dir;
XYZ=[p;p2];
plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),style);

p2=p+1.1*d*dir;
text(p2(1),p2(2),p2(3),name,'FontSize',font_size, 'Interpreter','latex')

end



